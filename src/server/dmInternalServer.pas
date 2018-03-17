unit dmInternalServer;

interface

uses
  SysUtils, Classes, AbUnzper, DB, kbmMemTable, dmThreadDataModule, UtilWeb,
  UtilException;

type
  EInternalServer = class(ESymbolChart);

  EConnectionStatus = class(EInternalServer)
  private
    FHTTPStatus: integer;
  protected
    function GetTechnicalInfo: string; override;
  public
    constructor Create(const status: Integer); reintroduce;
    property HTTPStatus: integer read FHTTPStatus;
  end;

  EConnection = class(EInternalServer)
  private
    techInfoMsg: string;
  protected
    function GetTechnicalInfo: string; override;
  public
    constructor Create(const Msg: string; ErrorCode: integer; ErrorMsg, ErrorClassName: string); reintroduce;
  end;

  EConnectionRead = class(EConnection);

  EDataFile = class(EInternalServer);

  TDataFile = class
  private
    ZIP: TAbUnZipper;
    procedure DeleteZIP;
  public
    destructor Destroy; override;
    constructor Create(const fileName: TFileName);
    function GetData(nombre: string): TStringStream;
  end;

  TInternalServer = class;

  ECurrency = class(EInternalServer);

  TServerCall = class abstract
  protected
    Server: TInternalServer;
    function GetURLConnection: string; virtual; abstract;
    function CallAsCurrency(const operation: string; params: TStringList;
      const attach: TFileName): currency;
    function CallAsString(const operation: string; params: TStringList;
      const attach: TFileName): string;
    procedure CallAsVoid(const operation: string; params: TStringList;
      const attach: TFileName);
    function CallAsTStringList(const operation: string; params: TStringList;
      const attach: TFileName): TStringList;
    function CallAsBoolean(const operation: string; params: TStringList;
      const attach: TFileName): boolean;
    function CallAsTFileName(const operation: string; params: TStringList;
      const attach: TFileName): TFileName;
    function CallAsTDataFile(const operation: string; params: TStringList;
      const attach: TFileName): TDataFile;
    function CallAsTMemTable(const operation, id: string;
      params: TStringList; const attach: TFileName): TkbmMemTable; overload;
    procedure CallAndFillDataSet(DataSet: TDataSet;
      const operation, id: string; params: TStringList;
      const attach: TFileName); overload;
  public
    constructor Create(const server: TInternalServer); overload;
    constructor Create; overload;
    procedure Cancel;
  end;


  TInternalServer = class(TThreadDataModule)
  private
    FOnCancelCurrentOperation: TNotifyEvent;
    FOnConnect: TNotifyEvent;
  protected
    http: THTTPPOST;
    Canceled: Boolean;
    procedure ConnectSincrono(const URLConnection: string; const buffer: TStream;
      const operation: string; params: TStringList; const attach: TFileName); virtual;
    procedure OnAcceptedRequest(const headers: string); virtual;
    procedure OnHttpEnd(Sender: TObject); virtual;
  public
    class var URLServidor: string;
    procedure CancelCurrentOperation; virtual;
    property OnConnect: TNotifyEvent read FOnConnect write FOnConnect;
    property OnCancelCurrentOperation: TNotifyEvent read FOnCancelCurrentOperation write FOnCancelCurrentOperation;
  end;


//  function getDatos(data: TStringStream): TStringList;
//  function getDatosMemTable(data: TStringStream): TkbmMemTable;
  procedure DatosToDataSet(DataSet: TDataSet; dataFile: TDataFile; dataName: string; freeDataFile: boolean); overload;
  procedure DatosToDataSet(DataSet: TDataSet; data: TStringStream; freeData: boolean); overload;

const SEPARADOR_LINEA: char = '~';
    SEPARADOR_COLUMNA: char = '|';

implementation

uses StrUtils, forms, windows, AbUtils, WinInet, ABExcept,
  DateUtils, UtilFiles, dmConfigSistema;

{$R *.dfm}

resourcestring
  S_ABORTED = 'Acción abortada';
  S_HTTP_STATUS = 'Se ha podido contactar con el servidor pero se ha producido un error en él.' +  sLineBreak +
    'Ya se ha enviado un mensaje al departamento técnico para que puedan arreglar lo acontecido.' + sLineBreak + sLineBreak +
    'Rogamos disculpen las molestias y vuelvan a intentarlo más tarde.';


procedure DatosToDataSet(DataSet: TDataSet; data: TStringStream; freeData: boolean); overload;
var campos: TStringList;
  j, numCampos: integer;
  valor, linea, campo: string;
  position, positionValor: integer;
  finalDatos: boolean;
  field: TField;
  ano, mes, dia, hora, minuto, segundo, milisegundo: word;

    function getLinea: string;
    var i: integer;
    begin
      i := PosEx(SEPARADOR_LINEA, data.DataString, position);
      if i = 0 then begin
        finalDatos := true;
        i := data.Size + 1;
      end;
      result := Copy(data.DataString, position, i - position);
      position := i + 1;
    end;

    function getSiguienteValor(linea: string): string;
    var i: integer;
    begin
      i := PosEx(SEPARADOR_COLUMNA, linea, positionValor);
      if i = 0 then
        i := length(linea) + 1;
      result := Copy(linea, positionValor, i - positionValor);
      positionValor := i + 1;
    end;

    procedure CodificarFecha(const cad: string);
    // Formato yyyy/mm/dd
    begin
      dia := StrToInt(Copy(cad, 9, 2));
      mes := StrToInt(Copy(cad, 6, 2));
      ano := StrToInt(Copy(cad, 0, 4));
    end;

    procedure CodificarHora(const cad: string);
    // Formato hh:mm:ss:mm
    begin
      hora := StrToInt(Copy(cad, 0, 2));
      minuto := StrToInt(Copy(cad, 4, 2));
      if length(cad) >= 7 then
        segundo := StrToInt(Copy(cad, 7, 2))
      else
        segundo := 0;
      if length(cad) >= 10 then
        milisegundo := StrToInt(Copy(cad, 10, 2))
      else
        milisegundo := 0;
    end;

begin
  finalDatos := false;
  position := 1;
  DataSet.Active := true;

  campos := TStringList.Create;
  try
    campos.Delimiter := SEPARADOR_COLUMNA;
    campos.DelimitedText := getLinea; //lineas[0];
    numCampos := campos.Count - 1; // zero based

    while not finalDatos do begin
      linea := getLinea;
      if linea <> '' then begin
        DataSet.Append;
        positionValor := 1;
        for j := 0 to numCampos do begin
          valor := getSiguienteValor(linea);
          campo := UpperCase(campos[j]);
          field := DataSet.FieldByName(campo);
          if valor = '<null>' then
            field.Clear
          else begin
            if (field is TBCDField) or (field is TFloatField) then
              field.AsString := StringReplace(valor, '.', DecimalSeparator, [])
            else
              if field is TDateField then begin
                CodificarFecha(valor);
                field.AsDateTime := EncodeDate(ano, mes, dia);
              end
              else
                if field is TTimeField then begin
                  CodificarHora(valor);
                  field.AsDateTime := EncodeTime(hora, minuto, segundo, milisegundo);
                end
                else
                  if field is TDateTimeField then begin
                    CodificarFecha(valor);
                    CodificarHora(Copy(valor, 12, length(valor)));
                    field.AsDateTime := EncodeDateTime(ano, mes, dia, hora, minuto,
                      segundo, milisegundo);
                  end
                  else
                    field.AsString := valor;
          end;
        end;
        DataSet.Post;
      end;
    end;
  finally
    campos.Free;
  end;

  if freeData then
    data.Free;
end;

procedure DatosToDataSet(DataSet: TDataSet; dataFile: TDataFile; dataName: string; freeDataFile: boolean); overload;
var data: TStringStream;
begin
  try
    data := dataFile.GetData(dataName);
    DatosToDataSet(DataSet, data, true);
  finally
    if freeDataFile then
      dataFile.Free;
  end;
end;

{ TInternalServer }

procedure TInternalServer.CancelCurrentOperation;
begin
  Canceled := true;
  if http <> nil then
    http.Cancel;
  if Assigned(FOnCancelCurrentOperation) then
    FOnCancelCurrentOperation(Self);
end;


procedure TInternalServer.ConnectSincrono(const URLConnection: string;
  const buffer: TStream; const operation: string;
  params: TStringList; const attach: TFileName);
begin
  if attach <> '' then
    raise Exception.Create('parámetro attach no soportado en ConnectSincrono');

  if Assigned(FOnConnect) then
    FOnConnect(Self);

  http := THTTPPOST.Create(URLServidor, URLConnection + '/' + operation, params);
  try
    http.OnAcceptedRequest := OnAcceptedRequest;
    http.OnHttpEnd := OnHttpEnd;
    http.ExecuteSincrono(buffer, 40000);
    if http.Canceled then
      raise EAbort.Create(S_ABORTED);
    if http.HttpError then begin
      if http.HttpErrorClass = EHTTPInternetReadFile then
        raise EConnectionRead.Create(http.HttpErrorMsg, http.HTTPErrorCode, http.HttpErrorInetMsg,
          http.HttpErrorClass.ClassName)
      else
        raise EConnection.Create(http.HttpErrorMsg, http.HTTPErrorCode, http.HttpErrorInetMsg,
          http.HttpErrorClass.ClassName);
    end;
    if http.HttpStatus <> HTTP_STATUS_OK then
      raise EConnectionStatus.Create(http.HttpStatus);
  finally
    FreeAndNil(http);
  end;

//  if iseConnLost in FError then
//    raise EConnectionLost.Create('Connection lost');
//  if FError <> [] then begin
//    if iseWaitTimeoutExpired in FError then
//      raise ETimeOutConnection.Create('Se ha superado el tiempo de espera de respuesta del servidor')
//    else
//      raise EConnection.Create('Error de conexión');
//  end;
end;

procedure TInternalServer.OnAcceptedRequest(const headers: string);
begin

end;

procedure TInternalServer.OnHttpEnd(Sender: TObject);
begin

end;

//function getDatos(data: TStringStream): TStringList;
//begin
//  result := TStringList.Create;
//  result.Delimiter := SEPARADOR_LINEA;
//  result.DelimitedText := data.DataString;
//end;

function getDatosMemTable(data: TStringStream): TkbmMemTable;
var campos: TStringList;
  i, numCampos: integer;
  field: TField;

    function getLinea: string;
    var i: integer;
    begin
      i := PosEx(SEPARADOR_LINEA, data.DataString);
      if i = 0 then
        i := data.Size + 1;
      result := Copy(data.DataString, 0, i - 1);
    end;

begin
  campos := TStringList.Create;
  campos.Delimiter := SEPARADOR_COLUMNA;
  campos.DelimitedText := getLinea; //lineas[0];
  numCampos := campos.Count - 1; // zero based

  result := TkbmMemTable.Create(nil);
  for i := 0 to numCampos do begin
    field := TStringField.Create(result);
    field.Size := 1000;
    field.FieldName := campos[i];
    field.Name := result.Name + field.FieldName;
    field.Index := result.FieldCount;
    field.DataSet := result;
  end;
  result.Open;
  data.Seek(0, soFromBeginning);
  DatosToDataSet(result, data, false);
end;

{ EConnection }

constructor EConnection.Create(const Msg: string; ErrorCode: integer; ErrorMsg, ErrorClassName: string);
begin
  inherited Create(Msg);
  techInfoMsg := 'ClassName: ' + ErrorClassName + sLineBreak +
    'ErrorMsg: ' + ErrorMsg + sLineBreak +
    'ErrorCode: ' + IntTostr(ErrorCode);
end;

//procedure TInternalServer.auHTTPHeaderInfo(Sender: TObject;
//  ErrorCode: Integer; const RawHeaderssLineBreakLF, ContentType, ContentLanguage,
//  ContentEncoding: String; ContentLength: Integer; const Location: String;
//  const Date, LastModified, Expires: TDateTime; const ETag: String;
//  var ContinueDownload: Boolean);
//var aux: TStringList;
//  i: integer;
//begin
//  Cookies.Clear;
//  aux := TStringList.Create;
//  try
//    aux.Text := RawHeaderssLineBreakLF;
//    for i := 0 to aux.Count - 1 do begin
//      if AnsiStartsStr('Set-Cookie:', aux[i]) then
//        Cookies.Add(aux[i])
//      else
//        if (ErrorCode <> HTTP_STATUS_OK) and (AnsiStartsStr('HTTP/1.1', aux[i])) then begin
//          if HTTPErrorText <> '' then
//            HTTPErrorText := HTTPErrorText + sLineBreak;
//          HTTPErrorText := HTTPErrorText + Trim(Copy(aux[i], length('HTTP/1.1') + 5, length(aux[i])));
//        end;
//    end;
//  finally
//    aux.Free;
//  end;
//end;


function EConnection.GetTechnicalInfo: string;
begin
  result := techInfoMsg;
end;

{ TServerCall }

function TServerCall.CallAsBoolean(const operation: string; params: TStringList;
  const attach: TFileName): boolean;
begin
  result := CallAsString(operation, params, attach) = 'OK';
end;

function TServerCall.CallAsCurrency(const operation: string;
  params: TStringList; const attach: TFileName): currency;
var aux: string;
begin
  aux := StringReplace(CallAsString(operation, params, attach), '.', ',', []);
  if aux = '' then
    raise ECurrency.Create('');
  try
    result := StrToCurr(aux);
  except
    on e: Exception do begin
      raise ECurrency.Create(aux);
    end;
  end;
end;

function TServerCall.CallAsString(const operation: string; params: TStringList;
  const attach: TFileName): string;
var buffer: TStringStream;
begin
  buffer := TStringStream.Create('');
  try
    try
      Server.ConnectSincrono(GetURLConnection, buffer, operation, params, attach);
    finally
      FreeAndNil(params);
    end;
    result := buffer.DataString;
  finally
    FreeAndNil(buffer);
  end;
end;

function TServerCall.CallAsTMemTable(const operation: string; const id: string;
  params: TStringList; const attach: TFileName): TkbmMemTable;
var datos: TStringStream;
  DataFile: TDataFile;
  i: integer;
  multiple, found: boolean;
  fichero: string;
begin
  DataFile := CallAsTDataFile(operation, params, attach);
  try
    fichero := id;
    found := DataFile.ZIP.FindFile(fichero) <> -1;
    multiple := false;
    if not found then begin
      fichero := id + '_0';
      found := DataFile.ZIP.FindFile(fichero) <> -1;
      multiple := found;
    end;
    if found then begin
      datos := DataFile.GetData(fichero);
      try
        if datos.DataString = '' then
          result := nil
        else
          result := getDatosMemTable(datos);
      finally
        datos.Free;
      end;
      if (multiple) and (result <> nil) then begin
        i := 1;
        fichero := id + '_' + IntToStr(i);
        while DataFile.ZIP.FindFile(fichero) <> -1 do begin
          try
            datos := DataFile.GetData(id);
            try
              if datos.DataString <> '' then
                DatosToDataSet(result, DataFile.GetData(fichero), false);
            finally
              datos.Free;
            end;
          except
            on e: Exception do begin
              e.Message := e.Message + sLineBreak + 'File=' + fichero;
              raise;
            end;
          end;
          inc(i);
          fichero := id + '_' + IntToStr(i);
        end;
      end;
    end
    else
      result := nil;
  finally
    DataFile.Free;
  end;
end;

procedure TServerCall.CallAndFillDataSet(DataSet: TDataSet;
  const operation, id: string; params: TStringList; const attach: TFileName);
var datos: TStringStream;
  DataFile: TDataFile;
  i: integer;
  multiple, found: boolean;
  fichero: string;
begin
  DataFile := CallAsTDataFile(operation, params, attach);
  try
    fichero := id;
    found := DataFile.ZIP.FindFile(fichero) <> -1;
    multiple := false;
    if not found then begin
      fichero := id + '_0';
      found := DataFile.ZIP.FindFile(fichero) <> -1;
      multiple := found;
    end;
    if found then begin
      datos := DataFile.GetData(fichero);
      try
        if datos.DataString = '' then
          multiple := false
        else
          DatosToDataSet(DataSet, datos, false);
      finally
        datos.Free;
      end;
      if multiple then begin
        i := 1;
        fichero := id + '_' + IntToStr(i);
        while DataFile.ZIP.FindFile(fichero) <> -1 do begin
          try
            datos := DataFile.GetData(id);
            try
              if datos.DataString <> '' then
                DatosToDataSet(DataSet, DataFile.GetData(fichero), false);
            finally
              datos.Free;
            end;
          except
            on e: Exception do begin
              e.Message := e.Message + sLineBreak + 'File=' + fichero;
              raise;
            end;
          end;
          inc(i);
          fichero := id + '_' + IntToStr(i);
        end;
      end;
    end;
  finally
    DataFile.Free;
  end;
end;

function TServerCall.CallAsTDataFile(const operation: string;
  params: TStringList; const attach: TFileName): TDataFile;
var fileName: TFileName;
begin
  fileName := CallAsTFileName(operation, params, attach);
  result := TDataFile.Create(fileName);
end;

function TServerCall.CallAsTFileName(const operation: string;
  params: TStringList; const attach: TFileName): TFileName;
var buffer: TFileStreamNamed;
begin
  buffer := TempFileStream;
  try
    try
      Server.ConnectSincrono(GetURLConnection, buffer, operation, params, attach);
    finally
      FreeAndNil(params);
    end;
    result := buffer.FileName;
  finally
    buffer.Free;
  end;
end;

function TServerCall.CallAsTStringList(const operation: string;
  params: TStringList; const attach: TFileName): TStringList;
begin
  result := TStringList.Create;
  try
    result.Text := CallAsString(operation, params, attach);
  except
    on e: Exception do begin
      result.Free;
      raise;
    end;
  end;
end;

procedure TServerCall.CallAsVoid(const operation: string; params: TStringList;
  const attach: TFileName);
var buffer: TStringStream;
begin
  buffer := TStringStream.Create('');
  try
    try
      Server.ConnectSincrono(GetURLConnection, buffer, operation, params, attach);
    finally
      FreeAndNil(params);
    end;
  finally
    FreeAndNil(buffer);
  end;
end;

procedure TServerCall.Cancel;
begin
  Server.CancelCurrentOperation;
end;

constructor TServerCall.Create;
begin
  Server := TInternalServer.Create(nil);
end;

constructor TServerCall.Create(const server: TInternalServer);
begin
  inherited Create;
  Self.Server := server;
end;

{ TDataFile }

constructor TDataFile.Create(const fileName: TFileName);
begin
  inherited Create;
  ZIP := TAbUnZipper.Create(nil);
  ZIP.ForceType := true;
  ZIP.ArchiveType := atZip;
  try
    ZIP.FileName := fileName;
  except
    on e: EAbFileNotFound do begin
      DeleteZIP;
      raise EDataFile.Create(e.ClassName + ': ' + e.Message);
    end;
  end;
  if ZIP.FindFile('OK') = -1 then begin
    DeleteZIP;
    raise EDataFile.Create('No se han recibido todos los datos');
  end;
end;

procedure TDataFile.DeleteZIP;
var fileName: TFileName;
begin
  fileName := ZIP.FileName;
  ZIP.Free;
  DeleteFile(PAnsiChar(fileName));
  ZIP := nil;
end;

destructor TDataFile.Destroy;
begin
  if ZIP <> nil then
    DeleteZIP;
  inherited Destroy;
end;

function TDataFile.GetData(nombre: string): TStringStream;
begin
  result := TStringStream.Create('');
  ZIP.ExtractToStream(nombre, result);
end;

{ EConnectionStatus }

constructor EConnectionStatus.Create(const status: Integer);
begin
  inherited Create(S_HTTP_STATUS);
  FHTTPStatus := status;
end;

function EConnectionStatus.GetTechnicalInfo: string;
begin
  Result := 'Status: ' + IntToStr(FHTTPStatus);
end;



end.
