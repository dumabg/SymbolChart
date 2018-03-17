unit UserServerCalls;

interface

uses Classes, dmInternalServer, SysUtils, DB, Controls;

type
  TUserServerCall = class(TServerCall)
  protected
    function GetURLConnection: string; override;
  public
  end;

  TLoginUserServerCallResult = (lOK, lErrorPermission, lErrorUsuarioNotFound, lErrorServidor);
  TLoginUserServerCall = class(TUserServerCall)
  private
    FClave: string;
    FStateless: Boolean;
  public
    function Call(const usuario, password, GUID, version: string): TLoginUserServerCallResult;
    property Stateless: Boolean read FStateless;
    property Clave: string read FClave;
  end;

  TLogoutUserServerCall = class(TUserServerCall)
    procedure Call;
  end;

  TDatosUserServerCall = class(TUserServerCall)
    function Call(const diario, semanal: boolean;
      const OIDValor, OIDCotizacionDiario, OIDCotizacionSemanal, OIDSesionDiario,
      OIDSesionSemanal, OIDRentabilidadDiario, OIDRentabilidadSemanal,
      OIDModificacionC, OIDModificacionD, OIDModificacionS, OIDMensaje, OIDFrase: integer;
      const logout: boolean): TFileName;
  end;

  TCommitUserServerCall = class(TUserServerCall)
    procedure Commit(const diarios, semanales: boolean);
  end;

  TVersionUserServerCall = class(TUserServerCall)
    function Call: string;
  end;

  TMensajeServerCall = class(TUserServerCall)
    function Call: string;
    function CallEntrada: string;
  end;


  TStatusResult = (srError, srAlDia, srSinCredito, srDatos);
  TStatusServerCall = class(TUserServerCall)
  private
    FFechaDiario: TDate;
    FCosteDiario: integer;
    FHaySemanal: boolean;
    FFechaSemanal: TDate;
    FCreditos: integer;
    FFechaCaducidad: TDate;
    FCosteSemanal: integer;
    FHayDiario: boolean;
  public
    function Call(const OIDSesionDiario, OIDSesionSemanal: integer): TStatusResult;
    property FechaDiario: TDate read FFechaDiario;
    property FechaSemanal: TDate read FFechaSemanal;
    property HaySemanal: boolean read FHaySemanal;
    property HayDiario: boolean read FHayDiario;
    property CosteDiario: integer read FCosteDiario;
    property CosteSemanal: integer read FCosteSemanal;
    property Creditos: integer read FCreditos;
    property FechaCaducidad: TDate read FFechaCaducidad;
  end;

  TEstadoCuentaServerCall = class(TUserServerCall)
  private
    FCaducidad: TDate;
  public
    procedure Call(const Operacion, Transaccion: TDataSet);
    property Caducidad: TDate read FCaducidad;
  end;

  TBugServerCall = class(TServerCall)
  protected
    function GetURLConnection: string; override;
  public
    procedure Call(const GUID, msg: string);
  end;

  TCorreoServerCall = class(TServerCall)
  protected
    function GetURLConnection: string; override;
  public
    function Call(const id: integer): TDataFile;
  end;

  TCambioMonedaCall = class(TServerCall)
  protected
    function GetURLConnection: string; override;
  public
    function GetCambioMoneda(const fromMoneda, toMoneda: string): currency;
  end;


implementation

uses ServerURLs;

const
  SERVICE_DATOS: string = 'Datos.do';
  SERVICE_COMMIT: string = 'Commit.do';
  SERVICE_LOGIN: string = 'Login.do';
  SERVICE_LOGOUT: string = 'Logout.do';
  SERVICE_VERSION: string = 'Version.do';
  SERVICE_MENSAJE: string = 'Mensaje.do';
  SERVICE_BUG: string = 'Bug.do';
  SERVICE_STATUS: string = 'Status.do';
  SERVICE_CONFIRMAR: string = 'Confirmar.do';
  SERVICE_ESTADO_CUENTA: string = 'EstadoCuenta.do';

resourcestring
  ERROR_LOGIN = 'Error de comunicación con el servidor.' + #13 +
    'Al hacer la identificación el servidor ha devuelto algo inesperado:' + #13 +
    '%s';


//uses dmConfiguracion;


{ TFPServerCall }

  function getParam(const Mercados, DataSet: TDataSet): string;
  var fieldCot, fieldMer: TIntegerField;
    first: boolean;
  var OIDMercado, OIDCotizacion: integer;
  begin
    fieldCot := DataSet.FieldByName('OID_COTIZACION') as TIntegerField;
    fieldMer := Mercados.FieldByName('OID_MERCADO') as TIntegerField;
    result := '';
    first := true;
    Mercados.First;
    while not Mercados.eof do begin
      OIDMercado := fieldMer.AsInteger;
      if DataSet.Locate('OID_MERCADO', OIDMercado, []) then begin
        OIDCotizacion := fieldCot.Value
      end
      else begin
        OIDCotizacion := 0;
      end;
      if first then
        first := false
      else
        result := result + ',';
      result := result + IntToStr(OIDMercado) + '-' + IntToStr(OIDCotizacion);
      Mercados.Next;
    end;
  end;


{ TDatosServerCall }

function TDatosUserServerCall.Call(const diario, semanal: boolean;
      const OIDValor, OIDCotizacionDiario, OIDCotizacionSemanal, OIDSesionDiario,
      OIDSesionSemanal, OIDRentabilidadDiario, OIDRentabilidadSemanal,
      OIDModificacionC, OIDModificacionD, OIDModificacionS, OIDMensaje, OIDFrase: integer;
      const logout: boolean): TFileName;
var params: TStringList;
begin
//  private static final String INPUT_DIARIO = "D";
//  private static final String INPUT_SEMANAL = "S";
//  private static final String INPUT_OID_VALOR = "v";
//  private static final String INPUT_OID_COT_DIARIO = "cd";
//  private static final String INPUT_OID_COT_SEMANAL = "cs";
//  private static final String INPUT_OID_SESION_DIARIO = "sd";
//  private static final String INPUT_OID_SESION_SEMANAL = "ss";
//  private static final String INPUT_OID_SESION_RENT_DIARIO = "rd";
//  private static final String INPUT_OID_SESION_RENT_SEMANAL = "rs";
//  private static final String INPUT_OID_MODIFICACION_COMUN = "moc";
//  private static final String INPUT_OID_MODIFICACION_DIARIO = "mod";
//  private static final String INPUT_OID_MODIFICACION_SEMANAL = "mos";
//  private static final String INPUT_OID_MENSAJE = "m";
//  private static final String INPUT_OID_FRASE = "f";


  params := TStringList.Create;
  params.Add('v=' + IntToStr(OIDValor));
  if diario then begin
    params.Add('D=true');
    params.Add('cd=' + IntToStr(OIDCotizacionDiario));
    params.Add('sd=' + IntToStr(OIDSesionDiario));
    params.Add('rd='+ IntToStr(OIDRentabilidadDiario));
    params.Add('mod='+ IntToStr(OIDModificacionD));
  end
  else
    params.Add('D=false');
  if semanal then begin
    params.Add('S=true');
    params.Add('cs=' + IntToStr(OIDCotizacionSemanal));
    params.Add('ss='+ IntToStr(OIDSesionSemanal));
    params.Add('rs='+ IntToStr(OIDRentabilidadSemanal));
    params.Add('mos='+ IntToStr(OIDModificacionS));
  end
  else
    params.Add('S=false');
  params.Add('moc='+ IntToStr(OIDModificacionC));
  params.Add('m='+ IntToStr(OIDMensaje));
  params.Add('f='+ IntToStr(OIDFrase));
  if logout then
    params.Add('logout=true')
  else
    params.Add('logout=false');
  result := CallAsTFileName(SERVICE_DATOS, params, '');
end;

{ TLoginUserServerCall }

function TLoginUserServerCall.Call(const usuario, password, GUID, version: string): TLoginUserServerCallResult;
var params, response: TStringList;
begin
  params := TStringList.Create;
  params.Add('usuario=' + usuario);
  params.Add('password=' + password);
  params.Add('GUID=' + GUID);
  params.Add('version=' + version);
  params.Add('idioma=ES'); //+ ConfiguracionFP.Idioma);
  response := CallAsTStringList(SERVICE_LOGIN, params, '');
  try
    if response[0] = 'OK' then begin
      Result := lOK;
      FStateless := response.Count > 1;
      if FStateless then
        FClave := response[1];
    end
    else begin
      if response[1] = 'Permission' then
        result := lErrorPermission
      else begin
        if response[1] = 'UsuarioNotFound' then
          result := lErrorUsuarioNotFound
        else begin
          result := lErrorServidor;
          raise Exception.Create(Format(ERROR_LOGIN, [response.Text]));
        end;
      end;
    end;
  finally
    response.Free;
  end;
end;

{ TLogoutUserServerCall }

procedure TLogoutUserServerCall.Call;
begin
  CallAsVoid(SERVICE_LOGOUT, nil, '');
end;

{ TVersionUserServerCall }

function TVersionUserServerCall.Call: string;
begin
  result := CallAsString(SERVICE_VERSION, nil, '');
end;


function TUserServerCall.GetURLConnection: string;
begin
  result := URL_SERVICIOS;
end;

{ TMensajeServerCall }

function TMensajeServerCall.Call: string;
begin
  result := CallAsString(SERVICE_MENSAJE, nil, '');
end;

function TMensajeServerCall.CallEntrada: string;
var params: TStringList;
begin
  params := TStringList.Create;
  params.Add('av=1'); //av --> aviso
  result := CallAsString(SERVICE_MENSAJE, params, '');
end;

{ TBugServerCall }

procedure TBugServerCall.Call(const GUID, msg: string);
var params: TStringList;
begin
  params := TStringList.Create;
  params.Add('GUID=' + GUID);
  params.Add('msg=' + msg);
  CallAsVoid(SERVICE_BUG, params, '');
end;

function TBugServerCall.GetURLConnection: string;
begin
  result := URL_BUG_SERVER;
end;

{ TBonosServerCall }

function TStatusServerCall.Call(const OIDSesionDiario, OIDSesionSemanal: integer): TStatusResult;
var params, resultado: TStringList;
  status, fs, fd: string;
begin
//  private static final String INPUT_OID_SESION_DIARIO = "d";
//  private static final String INPUT_OID_SESION_SEMANAL = "s";

  params := TStringList.Create;
  params.Add('d='+ IntToStr(OIDSesionDiario));
  params.Add('s=' + IntToStr(OIDSesionSemanal));
  resultado := CallAsTStringList(SERVICE_STATUS, params, '');

  try
//  private static final String OUTPUT_STATUS_AL_DIA = "OK";
//  private static final String OUTPUT_STATUS_SIN_CREDITO = "NO_CREDIT";
//  private static final String OUTPUT_STATUS_DATOS = "DATA";

  status := resultado[0];
  if status = 'OK' then
    result := srAlDia
  else begin
    if status = 'NO_CREDIT' then
      result := srSinCredito
    else begin
      if status = 'DATA' then
        result := srDatos
      else begin
        result := srError;
      end;
    end;
  end;

  if result = srDatos then begin
//    private static final String OUTPUT_FECHA_DIARIO = "fd=";
//    private static final String OUTPUT_FECHA_SEMANAL = "fs=";
//    private static final String OUTPUT_COSTE_DIARIO = "cd=";
//    private static final String OUTPUT_COSTE_SEMANAL = "cs=";
//    private static final String OUTPUT_CREDITOS_DISPONIBLES = "c=";
//    private static final String OUTPUT_CREDITOS_CADUCIDAD = "cc=";
    fd := resultado.Values['fd'];
    FHayDiario := fd <> '';
    if FHayDiario then begin
      FFechaDiario := StrToDate(fd);
      FCosteDiario := StrToInt(resultado.Values['cd']);
    end;
    fs := resultado.Values['fs'];
    FHaySemanal := fs <> '';
    if FHaySemanal then begin
      FFechaSemanal := StrToDate(fs);
      FCosteSemanal := StrToInt(resultado.Values['cs']);
    end;
    FCreditos := StrToInt(resultado.Values['c']);
    FFechaCaducidad := StrToDate(resultado.Values['cc']);
  end;
  finally
    resultado.Free;
  end;
end;


{ TEstadoCuentaServerCall }

procedure TEstadoCuentaServerCall.Call(const Operacion, Transaccion: TDataSet);
var dataFile: TDataFile;
  caducidadData: TStringStream;
begin
  dataFile := CallAsTDataFile(SERVICE_ESTADO_CUENTA, nil, '');
  try
  DatosToDataSet(Operacion, dataFile.GetData('operacion'), true);
  DatosToDataSet(Transaccion, dataFile.GetData('transaccion'), true);
  caducidadData := dataFile.GetData('caducidad');
  try
    FCaducidad := StrToDate(caducidadData.DataString);
  finally
    caducidadData.Free;
  end;
  finally
    dataFile.Free;
  end;
end;

{ TCommitUserServerCall }

procedure TCommitUserServerCall.Commit(const diarios, semanales: boolean);
var params: TStringList;
  cad: string;
begin
  // private static final String INPUT_TIPO = "t";
  params := TStringList.Create;
  cad := 't=';
  if diarios then
    cad := cad + 'D';
  if semanales then
    cad := cad + 'S';
  params.Add(cad);
  CallAsVoid(SERVICE_COMMIT, params, '');
end;

{ TCorreoServerCall }

function TCorreoServerCall.Call(const id: integer): TDataFile;
var params: TStringList;
begin
  params := TStringList.Create;
  params.Add('id=' + IntToStr(id));
  result := CallAsTDataFile('get', params, '');
end;

function TCorreoServerCall.GetURLConnection: string;
begin
  result := URL_CORREO;
end;

{ TCambioMonedaCall }

function TCambioMonedaCall.GetCambioMoneda(const fromMoneda,
  toMoneda: string): currency;
var params: TStringList;
begin
  params := TStringList.Create;
  params.Add('f=' + fromMoneda);
  params.Add('t=' + toMoneda);
  result := CallAsCurrency('Conversor', params, '');
end;

function TCambioMonedaCall.GetURLConnection: string;
begin
  result := URL_CAMBIO_MONEDA;
end;

end.
