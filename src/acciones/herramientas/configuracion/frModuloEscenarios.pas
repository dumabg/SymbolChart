unit frModuloEscenarios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, frModulo, ImgList, JvComponentBase,
  JvErrorIndicator, JvExControls, JvLinkLabel, BusCommunication;

type
  MessageConfiguracionEscenarios = class(TBusMessage);

  TfModuloEscenarios = class(TfModulo)
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    eSintonizacion: TEdit;
    eDesviacionPerCent: TEdit;
    eIntentos: TEdit;
    cbDesviacionAutomatico: TCheckBox;
    Label8: TLabel;
    AyudaQueSon: TJvLinkLabel;
    procedure cbDesviacionAutomaticoClick(Sender: TObject);
    procedure NumeroKeyPress(Sender: TObject; var Key: Char);
    procedure AyudaQueSonLinkClick(Sender: TObject; LinkNumber: Integer;
      LinkText, LinkParam: string);
  private
  public
    constructor Create(AOwner: TComponent); override;
    procedure Guardar; override;
    class function Titulo: string; override;
  end;

implementation

uses dmConfiguracion, ServerURLs, Web;

resourcestring
  TITULO_MODULO = 'Escenarios';

{$R *.dfm}

constructor TfModuloEscenarios.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  eSintonizacion.Text := IntToStr(Configuracion.Escenarios.Sintonizacion);
  eDesviacionPerCent.Text := CurrToStr(Configuracion.Escenarios.DesviacionPerCent);
  cbDesviacionAutomatico.Checked := Configuracion.Escenarios.DesviacionAutomatico;
  eIntentos.Text := IntToStr(Configuracion.Escenarios.Intentos);
end;

procedure TfModuloEscenarios.Guardar;
begin
  Configuracion.Escenarios.Sintonizacion := StrToInt(eSintonizacion.Text);
  Configuracion.Escenarios.DesviacionPerCent := StrToCurr(eDesviacionPerCent.Text);
  Configuracion.Escenarios.DesviacionAutomatico := cbDesviacionAutomatico.Checked;
  Configuracion.Escenarios.Intentos := StrToInt(eIntentos.Text);
  Bus.SendEvent(MessageConfiguracionEscenarios);
end;

procedure TfModuloEscenarios.AyudaQueSonLinkClick(Sender: TObject;
  LinkNumber: Integer; LinkText, LinkParam: string);
begin
  inherited;
  AbrirURL(Configuracion.Sistema.URLServidor + URL_CONFIG_ESCENARIO);
end;

procedure TfModuloEscenarios.cbDesviacionAutomaticoClick(Sender: TObject);
begin
//  cbDesviacionAutomatico.Checked := not cbDesviacionAutomatico.Checked;
  eDesviacionPerCent.Enabled := not cbDesviacionAutomatico.Checked;
  if not cbDesviacionAutomatico.Checked then
    eDesviacionPerCent.SetFocus;
end;

procedure TfModuloEscenarios.NumeroKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9', #8]) then begin
    if (Sender as TEdit).Tag = 0 then
      Key := #0
    else
      if (key = ',') then begin
        if Pos(',', (Sender as TEdit).Text) <> 0 then
          key := #0;
      end
      else
        Key := #0;
  end;
end;

class function TfModuloEscenarios.Titulo: string;
begin
  result := TITULO_MODULO;
end;

end.
