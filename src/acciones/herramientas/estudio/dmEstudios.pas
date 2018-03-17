unit dmEstudios;

interface

uses
  SysUtils, Classes, IBCustomDataSet, IBUpdateSQL, IBQuery, Controls, dmBrokerEstudio,
  dmCuentaEstudio, tipos, IBSQL, dmInversorEstudio, dmEstudio,
  kbmMemTable, dmEditFS, DB, dmFS;

type
  TCalculandoSesionEvent = procedure (const fecha: TDate) of object;
  TOnStartingCalculandoSesion = procedure (const num: integer) of object;

  TEstudios = class(TEditFS)
    qSesiones: TIBQuery;
    qSesionesFECHA: TDateField;
    dCuenta: TIBSQL;
    dsEstudio: TDataSource;
    qMensajes: TIBQuery;
    qMensajesOR_ESTUDIO: TIntegerField;
    qMensajesMENSAJE: TMemoField;
    qMensajesPOSICION: TIntegerField;
    uMensajes: TIBUpdateSQL;
    qEstudio: TIBQuery;
    qEstudioOID_ESTUDIO: TSmallintField;
    qEstudioOR_CUENTA: TSmallintField;
    qEstudioOR_ESTRATEGIA: TSmallintField;
    qEstudioNOMBRE: TIBStringField;
    qEstudioDESDE: TDateField;
    qEstudioHASTA: TDateField;
    qEstudioCAPITAL: TIntegerField;
    qEstudioPAQUETES: TIntegerField;
    qEstudioUSA100: TIBStringField;
    qEstudioGRUPO: TIBStringField;
    qEstudioNOMBRE_ESTRATEGIA: TIBStringField;
    qEstudioDESCRIPCION_ESTRATEGIA: TMemoField;
    qEstudioESTRATEGIA_APERTURA: TMemoField;
    qEstudioESTRATEGIA_CIERRE: TMemoField;
    qEstudioDESCRIPCION: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    FEstudio: TEstudio;
    ParamOnEstudioCreated, ParamOnEstudioCanceled: TEstudioNotify;
    FCuenta: TCuentaEstudio;
    FEstaCalculando: boolean;
    function GetCuenta: TCuentaEstudio;
  protected
    function Add(const OIDPadre: integer; const nombre: string;
      const tipo: TFSType; const data: pointer): integer; override;
    procedure OnEstudioCreated(const OID: integer);
    procedure OnEstudioCanceled(const OID: integer);
    function GetFileSystemName: string; override;
  public
    procedure Delete(const OID: integer); override;
    procedure LoadEstudio(const OID: integer);
    procedure Cancelar;
    function HayEstudios: boolean;
    property EstaCalculando: boolean read FEstaCalculando;
    property Cuenta: TCuentaEstudio read GetCuenta;
  end;

implementation

uses dmBD, Forms, Variants, UtilDB, SCMain, uAcciones,
  uAccionesValor, dmAccionesValor;

const
  SIN_CUENTA = -1;

{$R *.dfm}

function TEstudios.Add(const OIDPadre: integer; const nombre: string;
  const tipo: TFSType; const data: pointer): integer;
begin
  try
    result := inherited Add(OIDPadre, nombre, tipo, data);
    if tipo = fstFile then begin
      BD.IBTransactionUsuario.CommitRetaining;
      ParamOnEstudioCreated := PTEstudioParams(data)^.OnEstudioCreated;
      PTEstudioParams(data)^.OnEstudioCreated := OnEstudioCreated;
      ParamOnEstudioCanceled := PTEstudioParams(data)^.OnEstudioCanceled;
      PTEstudioParams(data)^.OnEstudioCanceled := OnEstudioCanceled;
      FEstudio := TEstudio.Create;
      FEstudio.Run(result, data);
    end;
  finally
    Dispose(data);
  end;
end;

procedure TEstudios.Cancelar;
begin
  if FEstudio <> nil then
    FEstudio.Cancel;
end;

procedure TEstudios.DataModuleCreate(Sender: TObject);
begin
  OpenDataSet(qMensajes);
  FCuenta := TCuentaEstudio.Create(Self);
end;

procedure TEstudios.Delete(const OID: integer);
begin
  inherited;
  dCuenta.Params[0].AsInteger := qEstudioOR_CUENTA.Value;
  ExecQuery(dCuenta, true);
end;

function TEstudios.GetCuenta: TCuentaEstudio;
begin
  if qEstudioOR_CUENTA.IsNull then
    result := nil
  else begin
    if FCuenta.OIDCuenta <> qEstudioOR_CUENTA.Value then
      FCuenta.Cargar(qEstudioOR_CUENTA.Value);
    result := FCuenta;
  end;
end;

function TEstudios.GetFileSystemName: string;
begin
  Result := 'ESTUDIO_FS';
end;

function TEstudios.HayEstudios: boolean;
begin
  result := qEstudio.RecordCount > 0;
end;

procedure TEstudios.LoadEstudio(const OID: integer);
begin
  qEstudio.Close;
  qEstudio.Params[0].AsInteger := OID;
  OpenDataSet(qEstudio);
end;

procedure TEstudios.OnEstudioCanceled(const OID: integer);
begin
  FEstudio.Free;
  ParamOnEstudioCanceled(OID);
end;

procedure TEstudios.OnEstudioCreated(const OID: integer);
begin
  FEstudio.Free;
  ParamOnEstudioCreated(OID);
end;

end.
