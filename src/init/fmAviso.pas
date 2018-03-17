unit fmAviso;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, Readhtml, FramView, FramBrwz, Web;

type
  TfAviso = class(TfBase)
    FrameBrowser: TFrameBrowser;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    WebFrameBrowser: TWebFrameBrowser;
  public
    procedure Cargar(URL: string);
    destructor Destroy; override;
  end;

  procedure MostrarAvisoSiExiste;

implementation

uses UserServerCalls, dmConfiguracion;

type
  TAvisoThread = class(TThread)
  private
    FExisteAviso: boolean;
    URL: string;
    procedure Mostrar;
    procedure ExisteAviso;
  public
    procedure Execute; override;
  end;

{$R *.dfm}

procedure MostrarAvisoSiExiste;
var avisoThread: TAvisoThread;
begin
  avisoThread:= TAvisoThread.Create(true);
  avisoThread.FreeOnTerminate := true;
  avisoThread.Resume;
end;


procedure TfAviso.Cargar(URL: string);
begin
  WebFrameBrowser := TWebFrameBrowser.Create(FrameBrowser);
  WebFrameBrowser.LoadURL(Configuracion.Sistema.URLServidor + URL);
end;

destructor TfAviso.Destroy;
begin
  WebFrameBrowser.Free;
  inherited;
end;

procedure TfAviso.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

{ TAvisoThread }

procedure TAvisoThread.Execute;
begin
  try
    Synchronize(ExisteAviso);
    if FExisteAviso then
      Synchronize(Mostrar);
  except
  end;
end;


procedure TAvisoThread.ExisteAviso;
var serverCall: TMensajeServerCall;
begin
  serverCall := TMensajeServerCall.Create;
  try
    try
      URL := serverCall.CallEntrada;
      FExisteAviso := URL <> 'no';
    except
      FExisteAviso := false;
    end;
  finally
    serverCall.Free;
  end;
end;

procedure TAvisoThread.Mostrar;
var aviso: TfAviso;
begin
  aviso := TfAviso.Create(nil);
  try
    aviso.Cargar(URL);
    aviso.ShowModal;
  finally
    aviso.Free;
  end;
end;

end.
