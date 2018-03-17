unit Web;

interface

uses
  SysUtils, Classes, auHTTP, FramBrwz, Htmlview, dmThreadDataModule;

type
  TWebAsync = class;

  TWebAsyncInternal = class(TThreadDataModule)
    auHTTP: TauHTTP;
    procedure auHTTPDone(Sender: TObject; const ContentType: string;
      FileSize: Integer; Stream: TStream);
  private
    WA: TWebAsync;
  end;

  TWebAsync = class(TThread)
  private
    WAI: TWebAsyncInternal;
    FData: TMemoryStream;
  protected
    procedure Execute; override;
  public
    constructor Create(const URL: string);
    destructor Destroy; override;
    property Data: TMemoryStream read FData;
  end;

  TWebFrameBrowser = class(TComponent)
  private
    FFrameBrowser: TFrameBrowser;
    PostStream: TMemoryStream;
    procedure OnGetPostRequestEx(Sender: TObject; IsGet: Boolean;
      const URL, Query, EncType, Referer: string; Reload: Boolean;
      var NewURL: string; var DocType: ThtmlFileType;
      var Stream: TMemoryStream);
    procedure OnHotSpotTargetClick(Sender: TObject; const Target,
      URL: string; var Handled: Boolean);
    procedure OnImageRequest(Sender: TObject; const SRC: string;
      var Stream: TMemoryStream);
    procedure OnLoadImage(Sender: TObject);
  public
    constructor Create(const FrameBrowser: TFrameBrowser); reintroduce;
    destructor Destroy; override;
    procedure LoadURL(const URL: string);
  end;


  procedure AbrirURL(URL: string);


implementation

uses Forms, Windows, ShellAPI, Controls, htmlun2;

{$R *.dfm}
type
  TWebAsyncViewer = class(TWebAsync)
  private
    FURL: string;
    FViewer: THTMLViewer;
  public
    constructor Create(const viewer: THTMLViewer; const URL: string);
    property URL: string read FURL;
    property Viewer: THTMLViewer read FViewer;
  end;


  procedure AbrirURL(URL: string);
  var
    Buf : array[0..1023] of Char;
  begin
    Screen.Cursor := crHourGlass;
    try
      if (URL[1] <> 'h') or (URL[2] <> 't') or (URL[3] <> 't') or (URL[4] <> 'p') then
        URL := 'http://' + URL;
      StrPLCopy(Buf, URL, SizeOf(Buf)-1);
      ShellExecute(0, 'open', Buf, '', '', SW_SHOWNORMAL);
    finally
      Screen.Cursor := crDefault;
    end;
  end;


{ TWebAsync }

constructor TWebAsync.Create(const URL: string);
begin
  inherited Create(true);
  FData := TMemoryStream.Create;
  WAI := TWebAsyncInternal.Create(nil);
  WAI.auHTTP.URL := URL;
  WAI.WA := Self;
end;

destructor TWebAsync.Destroy;
begin
  FData.Free;
  WAI.Free;
  inherited;
end;

procedure TWebAsync.Execute;
begin
  WAI.auHTTP.Read(true);
end;

procedure TWebAsyncInternal.auHTTPDone(Sender: TObject;
  const ContentType: string; FileSize: Integer; Stream: TStream);
begin
  WA.FData.CopyFrom(Stream, FileSize);
  WA.FData.Position := 0;
end;

{ TWebFrameBrowser }

constructor TWebFrameBrowser.Create(const FrameBrowser: TFrameBrowser);
begin
  inherited Create(FrameBrowser);
  FFrameBrowser := FrameBrowser;
  FFrameBrowser.OnGetPostRequestEx := OnGetPostRequestEx;
  FFrameBrowser.OnHotSpotTargetClick := OnHotSpotTargetClick;
  FFrameBrowser.OnImageRequest := OnImageRequest;
end;

destructor TWebFrameBrowser.Destroy;
begin
  if PostStream <> nil then
    PostStream.Free;
  inherited;
end;

procedure TWebFrameBrowser.LoadURL(const URL: string);
begin
  FFrameBrowser.LoadURL(URL);
end;

procedure TWebFrameBrowser.OnGetPostRequestEx(Sender: TObject; IsGet: Boolean;
  const URL, Query, EncType, Referer: string; Reload: Boolean;
  var NewURL: string; var DocType: ThtmlFileType; var Stream: TMemoryStream);
var ss: TStringStream;
  s: string;
begin
  inherited;
  s := HTTPReadString(URL);
  ss := TStringStream.Create(s);
  try
    if PostStream <> nil then
      PostStream.Free;
    PostStream := TMemoryStream.Create;
    Stream := PostStream;
    Stream.CopyFrom(ss, length(s));
  finally
    ss.Free;
  end;
end;

procedure TWebFrameBrowser.OnHotSpotTargetClick(Sender: TObject; const Target,
  URL: string; var Handled: Boolean);
begin
  AbrirURL(URL);
  Handled := true;
end;

procedure TWebFrameBrowser.OnImageRequest(Sender: TObject; const SRC: string;
  var Stream: TMemoryStream);
var web: TWebAsyncViewer;
begin
  inherited;
  web := TWebAsyncViewer.Create(Sender as THTMLViewer, src);
  web.OnTerminate := OnLoadImage;
  web.Resume;
  Stream := WaitStream;
end;

procedure TWebFrameBrowser.OnLoadImage(Sender: TObject);
begin
  with Sender as TWebAsyncViewer do
    FFrameBrowser.InsertImage(viewer, URL, Data);
end;

{ TWebAsyncViewer }

constructor TWebAsyncViewer.Create(const viewer: THTMLViewer;
  const URL: string);
begin
  inherited Create(URL);
  FURL := URL;
  FViewer := viewer;
end;

end.
