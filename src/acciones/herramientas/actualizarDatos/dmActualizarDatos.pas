unit dmActualizarDatos;

interface

uses
  SysUtils, Classes, IBDatabase, IBSQL, Windows, dmLoginServer,
  BusCommunication, dmDescargarDatos, dmImportarDatos, dmInternalUserServer;

type
  MessageDatosActualizados = class(TBusMessage);
  MessageStructureMessageChanged = class(TBusMessage);

  TActualizarDatos = class(TInternalUserServer)
  private
    FDiario, FSemanal: boolean;
    TwoCommitTransaction: TIBTransaction;
    BDDiario, BDSemanal, BDComun: TIBDatabase;
    IBSQLDiario, IBSQLSemanal, IBSQLComun: TIBSQL;
    FPerCentWindowReceiver: HWND;
    FOnModificaciones: TNotifyEvent;
    DataFileName: TFileName;
    Importar: TImportarDatos;
    Descargar: TDescargarDatos;
    procedure Commit;
  public
    constructor Create(const Owner: TComponent;
      const Diario, Semanal: boolean;
      const PerCentWindowReceiver: HWND;
      const OnModificaciones: TNotifyEvent); reintroduce;
    destructor Destroy; override;
    procedure DescargarDatos(const LoginState: TLoginState);
    procedure ImportarDatos(const LoginState: TLoginState);
    procedure Cancel;
  end;

implementation

{$R *.dfm}

uses dmBD, UserServerCalls, dmDataComun;

procedure TActualizarDatos.ImportarDatos(const LoginState: TLoginState);
var reintentar: boolean;
begin
  AssignLoginState(LoginState);
  reintentar := true;
  while reintentar do begin
    TwoCommitTransaction.StartTransaction;
    try
      Importar.Importar(DataFileName, FPerCentWindowReceiver);
      Commit;
      TwoCommitTransaction.Commit;
      reintentar := false;
      try
        if Importar.HayModificaciones then begin
          FOnModificaciones(Self);
          Importar.ImportarModificaciones(TwoCommitTransaction);
        end;
      finally
        DataComun.ReloadSesiones;
        Bus.SendEvent(MessageDatosActualizados);
      end;
    except
      on e: EStructureChange do begin
        if TwoCommitTransaction.InTransaction then
          TwoCommitTransaction.Rollback;
        Bus.SendEvent(MessageStructureMessageChanged);
        reintentar := true;
      end;
      on e: Exception do begin
        if TwoCommitTransaction.InTransaction then
          TwoCommitTransaction.Rollback;
        raise;
      end;
    end;
  end;
end;

procedure TActualizarDatos.Cancel;
begin
  if Descargar <> nil then
    Descargar.CancelCurrentOperation;
  if Importar <> nil then
    Importar.CancelCurrentOperation;
end;

procedure TActualizarDatos.Commit;
var commitCall: TCommitUserServerCall;
begin
  commitCall := TCommitUserServerCall.Create(Self);
  try
    commitCall.Commit(FDiario, FSemanal);
  finally
    commitCall.Free;
  end;
end;

constructor TActualizarDatos.Create(const Owner: TComponent;
  const Diario, Semanal: boolean; const PerCentWindowReceiver: HWND;
  const OnModificaciones: TNotifyEvent);
begin
  inherited Create(Owner);
  FOnModificaciones := OnModificaciones;
  FPerCentWindowReceiver := PerCentWindowReceiver;
  FDiario := Diario;
  FSemanal := Semanal;
  TwoCommitTransaction := TIBTransaction.Create(nil);
  BDComun := BD.GetNewDatabase(nil, scdComun, bddDiaria);
  TwoCommitTransaction.AddDatabase(BDComun);
  IBSQLComun := TIBSQL.Create(nil);
  IBSQLComun.Database := BDComun;
  IBSQLComun.Transaction := TwoCommitTransaction;
  if Diario then begin
    BDDiario := BD.GetNewDatabase(nil, scdDatos, bddDiaria);
    TwoCommitTransaction.AddDatabase(BDDiario);
    IBSQLDiario := TIBSQL.Create(nil);
    IBSQLDiario.Database := BDDiario;
    IBSQLDiario.Transaction := TwoCommitTransaction;
  end
  else begin
    BDDiario := nil;
    IBSQLDiario := nil;
  end;
  if Semanal then begin
    BDSemanal := BD.GetNewDatabase(nil, scdDatos, bddSemanal);
    TwoCommitTransaction.AddDatabase(BDSemanal);
    IBSQLSemanal := TIBSQL.Create(nil);
    IBSQLSemanal.Database := BDSemanal;
    IBSQLSemanal.Transaction := TwoCommitTransaction;
  end
  else begin
    BDSemanal := nil;
    IBSQLSemanal := nil;
  end;
  Importar := TImportarDatos.Create(nil, IBSQLDiario, IBSQLSemanal, IBSQLComun);
end;

procedure TActualizarDatos.DescargarDatos(const LoginState: TLoginState);
begin
  Descargar := TDescargarDatos.Create(nil);
  try
    Descargar.AssignLoginState(LoginState);
    Descargar.PerCentWindowReceiver := FPerCentWindowReceiver;
    DataFileName := descargar.Descargar(BDDiario, BDSemanal, BDComun, FDiario, FSemanal);
  finally
    FreeAndNil(Descargar);
  end;
end;

destructor TActualizarDatos.Destroy;
begin
  Importar.Free;
  if DataFileName <> '' then
    DeleteFile(PAnsiChar(DataFileName));

  if BDDiario <> nil then begin
    BDDiario.Close;
    IBSQLDiario.Free;
  end;
  if BDSemanal <> nil then begin
    BDSemanal.Close;
    IBSQLSemanal.Free;
  end;
  BDComun.Close;
  IBSQLComun.Free;

  TwoCommitTransaction.Free;
  if BDDiario <> nil then
    BDDiario.Free;
  if BDSemanal <> nil then
    BDSemanal.Free;
  BDComun.Free;
  inherited;
end;

end.
