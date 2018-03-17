unit frModuloVersion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, JvExControls, JvLinkLabel, frModulo, ImgList,
  JvComponentBase, JvErrorIndicator;

type
  TfModuloVersion = class(TfModulo)
    cbVersionNuevaAlArrancar: TCheckBox;
    bComprobar: TButton;
    LinkWeb: TJvLinkLabel;
    procedure bComprobarClick(Sender: TObject);
    procedure cbVersionNuevaAlArrancarClick(Sender: TObject);
    procedure LinkWebLinkClick(Sender: TObject; LinkNumber: Integer; LinkText,
      LinkParam: string);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    class function Titulo: string; override;
  end;

implementation

uses dmConfiguracion, Web;

resourcestring
  TITULO_MODULO = 'Versión';

{$R *.dfm}

procedure TfModuloVersion.cbVersionNuevaAlArrancarClick(Sender: TObject);
begin
  Configuracion.Version.VersionNuevaAlArrancar := not cbVersionNuevaAlArrancar.Checked;
end;

constructor TfModuloVersion.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  cbVersionNuevaAlArrancar.Checked := Configuracion.Version.VersionNuevaAlArrancar;
end;

procedure TfModuloVersion.LinkWebLinkClick(Sender: TObject; LinkNumber: Integer;
  LinkText, LinkParam: string);
begin
  AbrirURL('http://www.symbolchart.com');
end;

class function TfModuloVersion.Titulo: string;
begin
  result := TITULO_MODULO;
end;

procedure TfModuloVersion.bComprobarClick(Sender: TObject);
begin
  try
    bComprobar.Enabled := false;
    try
      Screen.Cursor := crAppStart;
{      ConfiguracionFP.auAutoUpgrader.ShowMessages := ConfiguracionFP.auAutoUpgrader.ShowMessages + [mNoUpdateAvailable];
      ConfiguracionFP.auAutoUpgrader.CheckUpdate;}
    finally
      Screen.Cursor := crDefault;
    end;
  finally
    bComprobar.Enabled := true;
  end;
end;

end.
