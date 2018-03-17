unit dmMensajeria;

interface

uses
  SysUtils, Classes, Dialogs, JvBaseDlg, JvDesktopAlert, JvComponentBase,
  Graphics, IBSQL, IBDatabase, DB, IBCustomDataSet, IBQuery,
  kbmMemTable, Messages, dmHandledDataModule;

const
  WM_CHEQUEAR_CORREO = WM_USER + 1;

type
  TMensajeria = class(THandledDataModule)
    JvDesktopAlert: TJvDesktopAlert;
    JvDesktopAlertStack: TJvDesktopAlertStack;
    iCorreo: TIBSQL;
    qCorreo: TIBQuery;
    qCorreoOID_CORREO: TIntegerField;
    CorreoData: TkbmMemTable;
    CorreoDataOID_CORREO: TIntegerField;
    CorreoDataFECHA_HORA: TDateTimeField;
    CorreoDataTITULO: TIBStringField;
    CorreoDataMENSAJE: TMemoField;
    CorreoDataREMITENTE: TStringField;
  private
    FHayNuevosCorreos: boolean;
  protected
    procedure WndMethod(var Msg: TMessage); override;
  public
    procedure MostrarMensaje(const msg: string); overload;
    procedure MostrarMensaje(const titulo, msg: string); overload;
    procedure ChequearCorreo;
    property HayNuevosCorreos: boolean read FHayNuevosCorreos;
  end;

var
  Mensajeria: TMensajeria;

  procedure GlobalInitialization;
  procedure GlobalFinalization;

implementation

{$R *.dfm}

uses dmConfiguracion, UserServerCalls, dmInternalServer, dmBD,
  UtilDB, Syncobjs, uServices, Windows, UtilThread;

type
  TMensajeriaServidor = class(TService)
  private
    FSleepEvent: TEvent;
    MiliSegundos: integer;
  protected
    procedure InternalExecute; override;
    procedure InternalCancel; override;
  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
  end;


{ TMensajeria }

procedure TMensajeria.MostrarMensaje(const msg: string);
begin
  MostrarMensaje('', msg);
end;

procedure TMensajeria.ChequearCorreo;
var OIDCorreo: integer;
  call: TCorreoServerCall;
  dataFile: TDataFile;

    procedure ProcessData;
    var OID: integer;
    begin
      if not CorreoData.IsEmpty then begin
        CorreoData.First;
        qCorreo.Close;
        while not CorreoData.eof do begin
          OID := CorreoDataOID_CORREO.Value;
          qCorreo.Params[0].AsInteger := OID;
          OpenDataSet(qCorreo);
          if qCorreo.IsEmpty then begin
            iCorreo.ParamByName('OID_CORREO').AsInteger := OID;
            iCorreo.ParamByName('FECHA_HORA').AsDateTime := CorreoDataFECHA_HORA.Value;
            iCorreo.ParamByName('TITULO').AsString := CorreoDataTITULO.Value;
            iCorreo.ParamByName('MENSAJE').AsString := CorreoDataMENSAJE.Value;
            ExecQuery(iCorreo, false);
            MostrarMensaje(CorreoDataREMITENTE.Value, CorreoDataTITULO.Value);
          end;
          if OID > OIDCorreo then
            OIDCorreo := OID;
          qCorreo.Close;
          CorreoData.Next;
        end;
      end;
    end;

begin
  inherited;
  FHayNuevosCorreos := false;
  call := TCorreoServerCall.Create;
  try
    CorreoData.Close;
    CorreoData.Open;
    OIDCorreo := Configuracion.Sistema.OIDCorreo;
    dataFile := call.Call(OIDCorreo);
    try
      DatosToDataSet(CorreoData, dataFile, 'data', true);
      FHayNuevosCorreos := not CorreoData.IsEmpty;
      if FHayNuevosCorreos then begin
        ProcessData;
        Configuracion.Sistema.OIDCorreo := OIDCorreo;
      end;
    finally
      CorreoData.Close;
    end;
  finally
    call.Free;
  end;
end;

procedure TMensajeria.MostrarMensaje(const titulo, msg: string);
var mensaje: TJvDesktopAlert;
  mem: TMemoryStream;
begin
  // Creamos un nuevo TJvDesktopAlert a partir del que hay en este datamodule
  mem := TMemoryStream.Create;
  try
    mem.WriteComponent(JvDesktopAlert);
    mem.Position := 0;
    mensaje := TJvDesktopAlert.Create(nil);
    mem.ReadComponent(mensaje);
  finally
    mem.Free;
  end;
  mensaje.HeaderText := titulo;
  mensaje.MessageText := msg;
  mensaje.Execute;
  //TJvDesktopAlert tiene AutoFree
end;

procedure TMensajeria.WndMethod(var Msg: TMessage);
begin
  inherited;
  if Msg.Msg = WM_CHEQUEAR_CORREO then begin
    try
      ChequearCorreo;
    except
      on e: Exception do begin
      end;
    end;
  end;
end;

{ TMensajeriaServidor }

procedure TMensajeriaServidor.AfterConstruction;
var minutos: integer;
begin
  minutos := Configuracion.ReadInteger('Correo', 'Minutos', 30);
  MiliSegundos := minutos * 60 * 1000;
  FSleepEvent := TEvent.Create(nil, True, False, '');
  inherited;
end;

destructor TMensajeriaServidor.Destroy;
begin
  FSleepEvent.Free;
  inherited;
end;

procedure TMensajeriaServidor.InternalCancel;
begin
  inherited;
  FSleepEvent.SetEvent;
end;

procedure TMensajeriaServidor.InternalExecute;
begin
  while not Terminated do begin
    PostMessage(Mensajeria.Handle, WM_CHEQUEAR_CORREO, 0, 0);
    FSleepEvent.WaitFor(MiliSegundos);
  end;
end;

procedure GlobalInitialization;
begin
  Mensajeria := TMensajeria.Create(nil);
  PostMessage(Mensajeria.Handle, WM_CHEQUEAR_CORREO, 0, 0);
//  Services.RegisterService(TMensajeriaServidor);
end;

procedure GlobalFinalization;
begin
  Mensajeria.Free;
end;


end.
