unit frModuloMensajes;

interface

uses
  Windows, Messages, frModulo, Classes, ActnList, Forms, uPanel,
  uPanelNotificaciones, uPanelMensaje, TB2Item, SpTBXItem, Controls, TB2Dock,
  TB2Toolbar, StdCtrls, CheckLst, ComCtrls, JvExControls, JvLinkLabel, ImgList,
  JvComponentBase, JvErrorIndicator, BusCommunication;

type
  MessageConfiguracionMensaje = class(TBusMessage);

  TfModuloMensajes = class(TfModulo)
    ImageList: TImageList;
    TamanoFuente: TTrackBar;
    cbSeparacion: TCheckBox;
    cbIncrustar: TCheckBox;
    cbMismaLinea: TCheckBox;
    Label9: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ActionList: TActionList;
    Todos: TAction;
    Invertir: TAction;
    Ninguno: TAction;
    TBXToolbar1: TSpTBXToolbar;
    TBXItem1: TSpTBXItem;
    TBXItem2: TSpTBXItem;
    TBXItem3: TSpTBXItem;
    SignificadoMensajesURL: TJvLinkLabel;
    TextoMuestra: TfrPanelMensaje;
    Mensajes: TCheckListBox;
    procedure TodosExecute(Sender: TObject);
    procedure InvertirExecute(Sender: TObject);
    procedure NingunoExecute(Sender: TObject);
    procedure cbMismaLineaClick(Sender: TObject);
    procedure cbSeparacionClick(Sender: TObject);
    procedure TamanoFuenteChange(Sender: TObject);
    procedure MensajesClick(Sender: TObject);
    procedure MensajesClickCheck(Sender: TObject);
    procedure SignificadoMensajesURLLinkClick(Sender: TObject;
      LinkNumber: Integer; LinkText, LinkParam: string);
  private
    CheckClicked: boolean;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Guardar; override;
    class function Titulo: string; override;
  end;


implementation

uses dmConfiguracion, ServerURLs, Web;

resourcestring
  TITULO_MODULO = 'Mensajes';

{$R *.dfm}

procedure TfModuloMensajes.cbMismaLineaClick(Sender: TObject);
begin
  TextoMuestra.Mensajes.TitleSeparation := not TextoMuestra.Mensajes.TitleSeparation;
end;

procedure TfModuloMensajes.cbSeparacionClick(Sender: TObject);
begin
  TextoMuestra.Mensajes.ParagrahSeparation := not TextoMuestra.Mensajes.ParagrahSeparation;
end;

constructor TfModuloMensajes.Create(AOwner: TComponent);
var  i, num: integer;
begin
  inherited Create(AOwner);
  Mensajes.Items.Assign(Configuracion.Mensajes.Mensajes);
//  cbActualizarArrastrar.Checked := Configuracion.Mensajes.ActualizarArrastrar;
  cbIncrustar.Checked := Configuracion.Mensajes.Incrustar;
  cbSeparacion.Checked := Configuracion.Mensajes.SeparacionEntreMensajes;
  cbMismaLinea.Checked := Configuracion.Mensajes.TituloMensajeMismaLinea;
  num := Mensajes.Items.Count - 1;
  for i := 0 to num do
    Mensajes.Checked[i] := Configuracion.Mensajes.Visible[integer(Mensajes.Items.Objects[i])];
  TamanoFuente.Position := Configuracion.Mensajes.TamanoFuente div 2;
end;

procedure TfModuloMensajes.Guardar;
var i, num: integer;
begin
  num := Mensajes.Items.Count - 1;
  for i := 0 to num do
     Configuracion.Mensajes.Visible[integer(Mensajes.Items.Objects[i])] := Mensajes.Checked[i];
  Configuracion.Mensajes.TituloMensajeMismaLinea := cbMismaLinea.Checked;
  Configuracion.Mensajes.SeparacionEntreMensajes := cbSeparacion.Checked;
  Configuracion.Mensajes.Incrustar := cbIncrustar.Checked;
  Configuracion.Mensajes.TamanoFuente := TamanoFuente.Position * 2;
  Bus.SendEvent(MessageConfiguracionMensaje);
end;

procedure TfModuloMensajes.InvertirExecute(Sender: TObject);
var i, num: integer;
begin
  num := Mensajes.Count - 1;
  for i:=0 to num do
    Mensajes.Checked[i] := not Mensajes.Checked[i];
end;

procedure TfModuloMensajes.MensajesClick(Sender: TObject);
var index: integer;
begin
  inherited;
  if CheckClicked then begin
    CheckClicked := false;
  end
  else begin
    index := Mensajes.ItemIndex;
    if index <> -1 then
      Mensajes.Checked[index] := not Mensajes.Checked[index];
  end;
end;

procedure TfModuloMensajes.MensajesClickCheck(Sender: TObject);
begin
  CheckClicked := true;
end;

procedure TfModuloMensajes.NingunoExecute(Sender: TObject);
var i, num: integer;
begin
  num := Mensajes.Count - 1;
  for i:=0 to num do
    Mensajes.Checked[i] := false;
end;

procedure TfModuloMensajes.SignificadoMensajesURLLinkClick(Sender: TObject;
  LinkNumber: Integer; LinkText, LinkParam: string);
begin
  inherited;
  AbrirURL(Configuracion.Sistema.URLServidor + URL_SIGNIFICACION_MENSAJES);
end;

procedure TfModuloMensajes.TamanoFuenteChange(Sender: TObject);
begin
  TextoMuestra.Mensajes.TamanoFuente := TamanoFuente.Position * 2;
end;

class function TfModuloMensajes.Titulo: string;
begin
  result := TITULO_MODULO;
end;

procedure TfModuloMensajes.TodosExecute(Sender: TObject);
var i, num: integer;
begin
  num := Mensajes.Count - 1;
  for i:=0 to num do
    Mensajes.Checked[i] := true;
end;

end.
