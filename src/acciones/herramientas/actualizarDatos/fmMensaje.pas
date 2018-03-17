unit fmMensaje;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBaseServer, ActnList, Buttons, Readhtml, FramView,
  FramBrwz, JvExControls, ExtCtrls, JvXPCore,
  JvXPButtons;

type
  TfMensaje = class(TfBaseServer)
    Panel2: TPanel;
    FrameBrowser: TFrameBrowser;
    Hecho: TJvXPButton;
  private
    procedure SetURI(const Value: string);
  public
    property URI: string write SetURI;
  end;


implementation

uses dmConfiguracion, Web;

{$R *.dfm}

{ TfMensaje }

procedure TfMensaje.SetURI(const Value: string);
var URL: string;
begin
  URL := Configuracion.Sistema.URLServidor + Value;
  TWebFrameBrowser.Create(FrameBrowser).LoadURL(URL);
end;


end.
