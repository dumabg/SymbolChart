unit UtilWeb;

interface

uses UtilThread, WinInet, Classes, SysUtils;

type
  EHTTP = class(Exception);

  ETimeOut = class(EHTTP);
  EHTTPNoHeaders = class(EHTTP);
  EHTTPInternetOpen = class(EHTTP);
  EHTTPInternetConnect = class(EHTTP);
  EHTTPOpenRequest = class(EHTTP);
  EHTTPSendRequest = class(EHTTP);
  EHTTPInternetReadFile = class(EHTTP);
  EHTTPSearchStatus = class(EHTTP);

  EHTTPClass = class of EHTTP;
  THTTP = class;
  THTTPThread = class (TProtectedThread)
  private
    FHttp: THTTP;
    FServer: string;
    FVerb: string;
    FURI: string;
    FParams: string;
    Port: Word;
    FHttpErrorCode: integer;
    FHttpErrorMsg: string;
    FHttpErrorClass: EHTTPClass;
    FHttpErrorInetMsg: string;
    FHttpError: boolean;
    FHttpStatus: integer;
    FHeaders: string;
    Buffer: TStream;
    constructor Create(const http: THTTP; const Server, Verb, URI, Params: string);
    procedure SearchHttpStatus(const hRequest: HINTERNET);
    procedure DownloadResponse(const hRequest: HINTERNET);
    procedure AcceptRequest(const hRequest: HINTERNET);
    procedure InformAcceptedRequest;
    procedure InformReceivedData;
  protected
    procedure InternalCancel; override;
    procedure InternalExecute; override;
    procedure FreeResources; override;
    procedure DoRequest;
  end;

  TOnAcceptedRequest = procedure (const headers: string) of object;

  THTTP = class
  private
    tiempoFinal: TDateTime;
    ThreadHandle: THandle;
    HTTPThread: THTTPThread;
    FHttpStatus: Integer;
    FHttpError: boolean;
    FHttpErrorCode: integer;
    FHttpErrorMsg: string;
    FCanceled: Boolean;
    FTimeOut: Cardinal;
    FOnAcceptedRequest: TOnAcceptedRequest;
    FOnHttpEnd: TNotifyEvent;
    FHttpErrorClass: EHTTPClass;
    FHttpErrorInetMsg: string;
    procedure AcceptedRequest(const headers: string);
    procedure ReceivedData;
  public
    constructor Create(const Server, Verb, URI, Params: string); overload;
    constructor Create(const Server, Verb, URI: string; const Params: TStringList); overload;
    constructor Create(const Server, Verb, URI: string); overload;
    destructor Destroy; override;
    procedure ExecuteSincrono(const Buffer: TStream; const TimeOut: Cardinal = 40000);
    procedure ExecuteAsincrono(const Buffer: TStream);
//    procedure WaitForThread;
    procedure Cancel;
    property Canceled: Boolean read FCanceled;
    property HttpErrorClass: EHTTPClass read FHttpErrorClass;
    property HttpErrorMsg: string read FHttpErrorMsg;
    property HttpErrorCode: integer read FHttpErrorCode;
    property HttpErrorInetMsg: string read FHttpErrorInetMsg;
    property HttpError: boolean read FHttpError;
    property HttpStatus: Integer read FHttpStatus;
    property OnAcceptedRequest: TOnAcceptedRequest read FOnAcceptedRequest write FOnAcceptedRequest;
    property OnHttpEnd: TNotifyEvent read FOnHttpEnd write FOnHttpEnd;
  end;

  THTTPPOST = class(THTTP)
  public
    constructor Create(const Server, URI, Params: string); reintroduce; overload;
    constructor Create(const Server, URI: string; const Params: TStringList); reintroduce; overload;
    constructor Create(const Server, URI: string); reintroduce; overload;
  end;

implementation

uses Windows, Forms, DateUtils;

//http://stackoverflow.com/questions/1823542/how-to-send-a-http-post-request-in-delphi-using-wininet-api

resourcestring
  S_EHTTP_GENERAL = 'No se ha podido establecer contacto con el servidor.' + sLineBreak + sLineBreak +
    'Esto puede ser debido a varias causas: ' + sLineBreak +
    ' - No está conectado a Internet.' + sLineBreak +
    ' - El servidor no está disponible en estos momentos.' + sLineBreak + sLineBreak +
    'Compruebe que su conexión a Internet funcione correctamente y si fuera así vuelva a intentarlo más tarde.';
  S_EHTTP_READ = 'Se pudo conectar al servidor pero se ha perdido la conexión.';
  S_TIMEOUT = 'Se ha superado el tiempo de espera máximo para que el servidor respondiera.' + sLineBreak +
    'Compruebe que su conexión a Internet funcione correctamente y si fuera así vuelva a intentarlo más tarde.';


const
//  USER_AGENT = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.3) Gecko/20090824 Firefox/3.5.3';
  USER_AGENT = 'SymbolChart UtilWeb';
  winetdll = 'wininet.dll';


function GetWinInetError(ErrorCode:Cardinal): string;
var
  Len: Integer;
  Buffer: PChar;
begin
  Len := FormatMessage(
  FORMAT_MESSAGE_FROM_HMODULE or FORMAT_MESSAGE_FROM_SYSTEM or
  FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_IGNORE_INSERTS or  FORMAT_MESSAGE_ARGUMENT_ARRAY,
  Pointer(GetModuleHandle(winetdll)), ErrorCode, 0, @Buffer, 0, nil);
  try
    while (Len > 0) and {$IFDEF UNICODE}(CharInSet(Buffer[Len - 1], [#0..#32, '.'])) {$ELSE}(Buffer[Len - 1] in [#0..#32, '.']) {$ENDIF} do Dec(Len);
    SetString(Result, Buffer, Len);
  finally
    LocalFree(HLOCAL(Buffer));
  end;
end;


{ THTTPThread }

procedure THTTPThread.AcceptRequest(const hRequest: HINTERNET);
const
  HEADER_BUFFER_SIZE = 4096;
var
  dwBufLen, dwIndex: DWord;
  HeaderData: Array[0..HEADER_BUFFER_SIZE - 1] of Char;
begin
  dwIndex := 0;
  dwBufLen := HEADER_BUFFER_SIZE;
  if HttpQueryInfo(hRequest, HTTP_QUERY_RAW_HEADERS_CRLF, @HeaderData, dwBufLen, dwIndex) then begin
    FHeaders := HeaderData;
    if not Canceled then    
      Synchronize(InformAcceptedRequest);
  end
  else
    raise EHTTPNoHeaders.Create(S_EHTTP_GENERAL);
end;

constructor THTTPThread.Create(const http: THTTP; const Server, Verb, URI, Params: string);
var i: integer;
begin
  inherited Create(true);
  FHttp := http;
  FVerb := Verb;
  FURI := URI;
  FParams := Params;
  i := Pos(':', Server);
  if i > 0 then begin
    Port := StrToInt(Copy(Server, i + 1, length(Server)));
    FServer := Copy(Server, 1, i - 1);
  end
  else begin
    Port := INTERNET_DEFAULT_HTTP_PORT;
    FServer := Server;
  end;
end;

procedure THTTPThread.DoRequest;
const
//  accept: packed array[0..1] of LPWSTR = (PChar('*/*'), nil);
  header: string = 'Content-Type: application/x-www-form-urlencoded';
var
  hSession, hConnect, hRequest: HINTERNET;
  AcceptTypes: Array[0..1] of PChar;
  Flags: Cardinal;
begin
  if Canceled then
      raise ETerminateThread.Create;

  hSession := InternetOpen(PChar(USER_AGENT), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  try
    if hSession = nil then
      raise EHTTPInternetOpen.Create(S_EHTTP_GENERAL);
    if Canceled then
      raise ETerminateThread.Create;

    hConnect := InternetConnect(hSession, PChar(FServer), Port, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
    try
      if hConnect = nil then
        raise EHTTPInternetConnect.Create(S_EHTTP_GENERAL);
      if Canceled then
        raise ETerminateThread.Create;

        // Preparing the request
      AcceptTypes[0] := PChar('*/*');
      AcceptTypes[1] := nil;
      // Flags
      Flags := 0;
      Inc(Flags, INTERNET_FLAG_RELOAD);
      Inc(Flags, INTERNET_FLAG_HYPERLINK);
      Inc(Flags, INTERNET_FLAG_RESYNCHRONIZE);
      Inc(Flags, INTERNET_FLAG_PRAGMA_NOCACHE);
      Inc(Flags, INTERNET_FLAG_NO_CACHE_WRITE);
      hRequest := HttpOpenRequest(hConnect, PChar(FVerb), PChar(FURI), nil, nil, @AcceptTypes, Flags, 0);
      try
        if hRequest = nil then
          raise EHTTPOpenRequest.Create(S_EHTTP_GENERAL);
        if Canceled then
          raise ETerminateThread.Create;

        if not HttpSendRequest(hRequest, PChar(header), length(header), PChar(FParams), length(FParams)) then
          raise EHTTPSendRequest.Create(S_EHTTP_GENERAL);

        SearchHttpStatus(hRequest);
        AcceptRequest(hRequest);

        if Canceled then
          raise ETerminateThread.Create;

        DownloadResponse(hRequest);
      finally
        InternetCloseHandle(hRequest);
      end;
    finally
      InternetCloseHandle(hConnect);
    end;
  finally
    InternetCloseHandle(hSession);
  end;
end;

procedure THTTPThread.DownloadResponse(const hRequest: HINTERNET);
var aBuffer: Array[0..4096] of Char;
  BytesRead: Cardinal;
begin
  if Canceled then
    raise ETerminateThread.Create;

  if not InternetReadFile(hRequest, @aBuffer, SizeOf(aBuffer), BytesRead) then
    raise EHTTPInternetReadFile.Create(S_EHTTP_READ);
  while BytesRead > 0 do begin
    if Canceled then
      raise ETerminateThread.Create;
    Synchronize(Self, InformReceivedData);
    if Canceled then
      raise ETerminateThread.Create;
    Buffer.Write(aBuffer, BytesRead);
    if not InternetReadFile(hRequest, @aBuffer, SizeOf(aBuffer), BytesRead) then
      raise EHTTPInternetReadFile.Create(S_EHTTP_READ);
  end;
end;

procedure THTTPThread.FreeResources;
begin
  inherited;
  if (FHttp <> nil) and (not Canceled) then begin
    FHttp.FHttpStatus := FHttpStatus;
    FHttp.FHttpError := FHttpError;
    FHttp.FHttpErrorCode := FHttpErrorCode;
    FHttp.FHttpErrorMsg := FHttpErrorMsg;
    FHttp.FHttpErrorClass := FHttpErrorClass;
    FHttp.FHttpErrorInetMsg := FHttpErrorInetMsg;
  end;
end;

procedure THTTPThread.InformAcceptedRequest;
begin
  FHttp.AcceptedRequest(FHeaders);
end;

procedure THTTPThread.InformReceivedData;
begin
  FHttp.ReceivedData;
end;

procedure THTTPThread.InternalCancel;
begin
  inherited;
  FHttp.OnAcceptedRequest := nil;
  FHttp.OnHttpEnd := nil;
end;

procedure THTTPThread.InternalExecute;
begin
  try
    DoRequest;
  except
    on e: EHTTP do begin
      FHttpError := true;
      FHttpErrorMsg := e.Message;
      FHttpErrorClass := EHTTPClass(e.ClassType);
      FHttpErrorInetMsg := GetWinInetError(GetLastError);
    end;
  end;
end;


procedure THTTPThread.SearchHttpStatus(const hRequest: HINTERNET);
const
  HEADER_BUFFER_SIZE = 4096;
var
  dwBufLen, dwIndex: DWord;
  HeaderData: Array[0..HEADER_BUFFER_SIZE - 1] of Char;
begin
  dwIndex := 0;
  dwBufLen := HEADER_BUFFER_SIZE;
  if HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_CODE, @HeaderData, dwBufLen, dwIndex) then begin
    FHttpStatus := StrToIntDef(HeaderData, 0);
  end
  else
    raise EHTTPSearchStatus.Create(S_EHTTP_GENERAL);
end;

{ THTTP }

constructor THTTP.Create(const Server, Verb, URI, Params: string);
begin
  inherited Create;
  HTTPThread := THTTPThread.Create(Self, Server, Verb, URI, Params);
  HTTPThread.SetNilOnFree(@HTTPThread);
  HTTPThread.FreeOnTerminate := true;
end;

procedure THTTP.AcceptedRequest(const headers: string);
begin
  tiempoFinal := IncMilliSecond(Now, FTimeOut);
  if Assigned(FOnAcceptedRequest) then
    FOnAcceptedRequest(headers);
end;

procedure THTTP.Cancel;
begin
  if HTTPThread <> nil then
    HTTPThread.Cancel;
  FCanceled := True;
end;

constructor THTTP.Create(const Server, Verb, URI: string);
begin
  Create(Server, Verb, URI, '');
end;

destructor THTTP.Destroy;
var WaitResult: Cardinal;
begin
  if HTTPThread <> nil then begin
    HTTPThread.Cancel;
    repeat
     WaitResult := MsgWaitForMultipleObjects(1, ThreadHandle, False, 4000, QS_ALLINPUT);
      if WaitResult = WAIT_TIMEOUT then begin
        HTTPThread.Free;
      end
      else
        Application.ProcessMessages;
    until (WaitResult <> WAIT_OBJECT_0 + 1) or Application.Terminated;
    repeat
     WaitResult := MsgWaitForMultipleObjects(1, ThreadHandle, False, 4000, QS_ALLINPUT);
      if WaitResult = WAIT_TIMEOUT then begin
        TerminateThread(ThreadHandle, 0);
      end
      else
        Application.ProcessMessages;
    until (WaitResult <> WAIT_OBJECT_0 + 1) or Application.Terminated;
  end;
  inherited;
end;

constructor THTTP.Create(const Server, Verb, URI: string; const Params: TStringList);
var i, num: integer;
  cad: string;
begin
  cad := '';
  num := Params.Count - 1;
  if num >= 0 then begin
    cad := Params[num];
    dec(num);
    for i := 0 to num do begin
      cad := cad + '&' + Params[i];
    end;
  end;
  Create(Server, Verb, URI, cad);
end;

procedure THTTP.ExecuteAsincrono(const Buffer: TStream);
begin
  FTimeOut := 0;
  HTTPThread.Buffer := Buffer;
  HTTPThread.SetNilOnFree(@HTTPThread);
  HTTPThread.Resume;
end;

procedure THTTP.ExecuteSincrono(const Buffer: TStream; const TimeOut: Cardinal);
begin
  FTimeOut := TimeOut;
  HTTPThread.Buffer := Buffer;
  HTTPThread.SetNilOnFree(@HTTPThread);
  ThreadHandle := HTTPThread.Handle;
  HTTPThread.Resume;

  tiempoFinal := IncMilliSecond(Now, TimeOut);
  repeat
    Application.ProcessMessages;
  until (HTTPThread = nil) or (tiempoFinal < now);
  if HTTPThread <> nil then begin
    HTTPThread.Cancel;
    raise ETimeOut.Create(S_TIMEOUT);
  end;
  if Assigned(FOnHttpEnd) then
    FOnHttpEnd(Self);
end;

procedure THTTP.ReceivedData;
begin
  tiempoFinal := IncMilliSecond(Now, FTimeOut);
end;

{
procedure THTTP.WaitForThread;
begin
  tiempoFinal := IncMilliSecond(Now, 3000);
  while (HTTPThread <> nil) and (tiempoFinal < now) do;
end;
 }
{ THTTPPOST }

constructor THTTPPOST.Create(const Server, URI, Params: string);
begin
  inherited Create(Server, 'POST', URI, Params);
end;

constructor THTTPPOST.Create(const Server, URI: string;
  const Params: TStringList);
begin
  inherited Create(Server, 'POST', URI, Params);
end;

constructor THTTPPOST.Create(const Server, URI: string);
begin
  inherited Create(Server, 'POST', URI);
end;

end.
