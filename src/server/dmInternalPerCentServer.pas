unit dmInternalPerCentServer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmInternalUserServer, UserMessages, UtilWeb;

type
  TPerCentStream = class(TStream)
  private
    dataReceived: string;
    FPerCentWindowReceiver: HWND;
    constructor Create(const PerCentWindowReceiver: HWND); reintroduce;
  public
    function Write(const Buffer; Count: Longint): Longint; override;
    function Read(var Buffer; Count: Longint): Longint; override;
  end;


  TInternalPerCentServer = class(TInternalUserServer)
  private
    httpPerCent: THTTPPOST;
    perCentStream: TPerCentStream;
    FPerCentWindowReceiver: HWND;
    SesionID: string;
    procedure SetPerCentWindowReceiver(const Value: HWND);
    procedure PerCent;
  protected
    procedure OnAcceptedRequest(const headers: string); override;
    procedure OnHttpEnd(Sender: TObject); override;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    procedure CancelPerCentOperation;
    procedure CancelCurrentOperation; override;
    property PerCentWindowReceiver: HWND read FPerCentWindowReceiver write SetPerCentWindowReceiver;
  end;

implementation

uses StrUtils, ServerURLs;

{$R *.dfm}

const
  SESSION_ID : string = 'JSESSIONID';


procedure TInternalPerCentServer.SetPerCentWindowReceiver(const Value: HWND);
begin
  FPerCentWindowReceiver := Value;
end;

procedure TInternalPerCentServer.PerCent;
begin
  httpPerCent := THTTPPOST.Create(URLServidor, URL_PERCENT, SESSION_ID + '=' + SesionID);
  perCentStream := TPerCentStream.Create(PerCentWindowReceiver);
  httpPerCent.ExecuteAsincrono(perCentStream);
end;


procedure TInternalPerCentServer.CancelCurrentOperation;
begin
  CancelPerCentOperation;
  inherited CancelCurrentOperation;
end;

procedure TInternalPerCentServer.CancelPerCentOperation;
begin
  if httpPerCent <> nil then
    httpPerCent.Cancel;
end;

constructor TInternalPerCentServer.Create(Owner: TComponent);
begin
  inherited;
  httpPerCent := nil;
  perCentStream := nil;
end;

destructor TInternalPerCentServer.Destroy;
begin
  CancelCurrentOperation;
  if httpPerCent <> nil then begin
//    httpPerCent.WaitForThread;
//    httpPerCent.Free//
    FreeAndNil(httpPerCent);
  end;
  if perCentStream <> nil then begin
    FreeAndNil(perCentStream);
//    perCentStream.Free;
//    perCentStream := nil;
  end;
  inherited;
end;

procedure TInternalPerCentServer.OnAcceptedRequest(const headers: string);
var i: Integer;
begin
  inherited;
  i := Pos(SESSION_ID, headers);
  if i <> 0 then begin
    i := PosEx('=', headers, i);
    SesionID := Copy(headers, i + 1, PosEx(';', headers, i + 1) - i - 1);
    SesionID:= Trim(SesionID);
    PerCent;
  end;
end;

procedure TInternalPerCentServer.OnHttpEnd(Sender: TObject);
begin
  CancelPerCentOperation;
end;


{ TPerCentStream }

constructor TPerCentStream.Create(const PerCentWindowReceiver: HWND);
begin
  inherited Create;
  FPerCentWindowReceiver := PerCentWindowReceiver;
end;

function TPerCentStream.Read(var Buffer; Count: Integer): Longint;
begin
  Result := Count;
end;

function TPerCentStream.Write(const Buffer; Count: Integer): Longint;
var
  S: PChar;
  i, num, perCent: integer;
begin
  S := PChar(@Buffer);
  num := Count - 1;
  for i := 0 to num do begin
    if S[i] = '|' then begin
      try
        perCent := StrToInt(dataReceived);
        PostMessage(FPerCentWindowReceiver, WM_PERCENT, perCent, 0);
      except
        on EConvertError do;
      end;
      dataReceived := '';
    end
    else
      dataReceived := dataReceived + S[i];
  end;
  Result := Count;
end;

end.
