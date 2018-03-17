unit SCMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus,
  TB2Item, ImgList, DBActns, ActnList,  ActnMan, ExtCtrls,
  ActnMenus, GraficoBolsa, AppEvnts, uAccionesVer,
  SpTBXItem, TB2Dock,
  TB2Toolbar, XPStyleActnCtrls, BusCommunication, fmBaseFormVisualConfig, fmBase,
  fmBaseFormConfig, StdCtrls, uToolbarGrafico;

const
  WM_AFTER_SHOW = WM_USER + 1;

type
  MessageSCShowed = class(TBusMessage);
  MessageSCBeforeClose = class(TBusMessage);

  TfSCMain = class(TfBaseFormVisualConfig)
    PanelGrafico: TPanel;
    DockArribaCentro: TSpTBXDock;
    DockAbajoCentro: TSpTBXDock;
    DockIzquierdaCentro: TSpTBXDock;
    DockDerechaCentro: TSpTBXDock;
    DockArribaBotones: TSpTBXDock;
    DockMenu: TSpTBXDock;
    DockArriba: TSpTBXDock;
    DockAbajoBotones: TSpTBXDock;
    DockAbajo: TSpTBXDock;
    ApplicationEvents: TApplicationEvents;
    ToolbarMenu: TSpTBXToolbar;
    PanelCentro: TPanel;
    PanelGraficoTop: TPanel;
    procedure ApplicationEventsDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FPanelOsciladoresVisible: Boolean;
    FToolBarOsciladores: TfrToolbarGrafico;
    FGrafico: TGraficoBolsa;
    FAccionesVer: TAccionesVer;
    procedure OnValorCambiado;
    procedure CrearMenusBarras;
    procedure OnAfterShow(var message: TMessage); message WM_AFTER_SHOW;
    procedure OnTipoGraficoChange;
    procedure OnColorGraficoChanged;
    procedure SetPanelOsicladoresVisible(const Value: Boolean);
  protected
    procedure DoShow; override;
    procedure LoadFormConfig; override;
    procedure SaveFormConfig; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    property Grafico: TGraficoBolsa read FGrafico;
    property AccionesVer: TAccionesVer read FAccionesVer;
    property PanelOsicladoresVisible: Boolean read FPanelOsciladoresVisible write SetPanelOsicladoresVisible;
    property ToolBarOsciladores: TfrToolbarGrafico read FToolBarOsciladores;
  end;

  var fSCMain: TfSCMain;


implementation

uses dmData, UtilDock, uAcciones, Grafico, dmConfiguracion, ConfigVisual;

{$R *.dfm}


procedure TfSCMain.AfterConstruction;
begin
  Bus.RegisterEvent(MessageValorCambiado, OnValorCambiado);
  inherited;
  FGrafico.GetGraficoPositionLayer.Ultimo(false);
  FGrafico.Visible := true;
end;

procedure TfSCMain.ApplicationEventsDeactivate(Sender: TObject);
begin
  FGrafico.CancelHint;
end;

procedure TfSCMain.CrearMenusBarras;
var aAcciones: TAAcciones;
  i: integer;
  docks: TDocks;

  procedure CrearAcciones(const acciones: TAcciones);
{  var b: TSpTBXSubmenuItem;
    i, num: integer;
    rootItem: TTBRootItem;}
  begin
    if acciones.ToolbarMenu.Visible then begin
{      rootItem := acciones.ToolbarMenu.Items;
      num := rootItem.Count;
      for i := 0 to num - 1 do begin
        b := TSpTBXSubmenuItem.Create(Self);
        b.Caption := rootItem[i].Caption;
        b.Images := rootItem[i].Images;
        b.ImageIndex := rootItem[i].ImageIndex;
        b.LinkSubitems := rootItem[i];
        ToolbarMenu.Items.Add(b);
      end;}
      acciones.ToolbarMenu.Parent := ToolbarMenu;
    end;
  end;

begin
  aAcciones := GetAccionesRegistradas;
  for i := Low(aAcciones) to High(aAcciones) do
    CrearAcciones(aAcciones[i]);

  // Las acciones de ver son especiales, ya que controlan la visibilidad de las
  // barras de todas las otras acciones, por lo que se debe crear aparte.
  docks[dpArriba] := DockArriba;
  docks[dpAbajo] := DockAbajo;
  docks[dpArribaBotones] := DockArribaBotones;
  docks[dpAbajoBotones] := DockAbajoBotones;
  docks[dpArribaCentro] := DockArribaCentro;
  docks[dpAbajoCentro] := DockAbajoCentro;
  docks[dpIzquierdaCentro] := DockIzquierdaCentro;
  docks[dpDerechaCentro] := DockDerechaCentro;
  docks[dpMenu] := DockMenu;
  docks[dpFlotando] := nil;
  FAccionesVer := TAccionesVer.Create(FGrafico, docks);
  CrearAcciones(FAccionesVer);
  RegisterAcciones(FAccionesVer, TAccionesVer);
end;

constructor TfSCMain.Create(AOwner: TComponent);
begin
  inherited;
  PanelOsicladoresVisible := true;
  FormConfig := [fcWindowState, fcPosition];
  DefaultWidth := 1024;
  DefaultHeight := 768;
  DefaultLeft := 0;
  DefaultTop := 0;
  DefaultWindowState := wsMaximized;
  Bus.RegisterEvent(MessageTipoGraficoChange, OnTipoGraficoChange);
  FGrafico := TGraficoBolsa.Create(Self);
  FGrafico.RegisterEvent(MessageColorChanged, OnColorGraficoChanged);  
  FToolBarOsciladores := TfrToolbarGrafico.Create(Self);
  FToolBarOsciladores.GraficoBolsa := FGrafico;
  FToolBarOsciladores.Parent := PanelGraficoTop;
  FGrafico.Parent := PanelGrafico;
  FGrafico.Visible := false;
  try
    FGrafico.Cursor := crDefault;
    FGrafico.Align := alClient;
    FGrafico.AlignWithMargins := true;
    FGrafico.FieldCierre := Data.CotizacionCIERRE;
    FGrafico.FieldMaximo := Data.CotizacionMAXIMO;
    FGrafico.FieldMinimo := Data.CotizacionMINIMO;
    FGrafico.FieldFecha := Data.CotizacionFECHA;
    FGrafico.ShowDataHint := false;
  finally
    FGrafico.Visible := true;
  end;
  CreateAcciones(Self);
  CrearMenusBarras;
//  CrearIndicadores;
  Caption := Caption + ' 4.4'; //+ Configuracion.Sistema.Version;
end;

procedure TfSCMain.DoShow;
begin
  inherited;
  PostMessage(Handle, WM_AFTER_SHOW, 0, 0);
end;

procedure TfSCMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  Bus.SendEvent(MessageSCBeforeClose);
end;

procedure TfSCMain.FormDestroy(Sender: TObject);
begin
  // Importante destruirlo antes que ninguno, ya que controla la apariencia
  // de los otros paneles y éstos deben estar creados para que pueda guardar
  // su configuración
  accionesVer.Free;

  Bus.UnregisterEvent(MessageTipoGraficoChange, OnTipoGraficoChange);
  FGrafico.UnregisterEvent(MessageColorChanged, OnColorGraficoChanged);
  Bus.UnRegisterEvent(MessageValorCambiado, OnValorCambiado);
  // El Gráfico tiene como parent PanelGrafico, pero al destruirse los objetos
  // primero se destruye el gráfico y después el panel, con lo que cuando el
  // PanelGrafico se destruye, intenta notificarlo al Gráfico, ya que es su Parent,
  // que ya está destruido y se produce una memory leak. Para evitarlo,
  // ponemos el parent a nil antes de que se destruya
  FGrafico.Parent := nil;
end;

procedure TfSCMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Key := 0;
end;

procedure TfSCMain.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var aAcciones: TAAcciones;
  i: integer;
begin
  case Key of
    VK_PRIOR: Data.ValorSiguiente;
    VK_NEXT: Data.ValorAnterior;
    else begin
      aAcciones := GetAccionesRegistradas;
      for i := Low(aAcciones) to High(aAcciones) do begin
        aAcciones[i].DoKeyUp(Sender, Key, Shift);
        if Key = 0 then
          exit;
      end;
      Grafico.GetGrafico.DoKeyUp(Key, Shift);
    end;
  end;
end;

procedure TfSCMain.LoadFormConfig;
var //tipo: integer;
  seccion: string;
begin
  inherited;
{  tipo := ConfiguracionVisual.ReadInteger(ClassName, 'Grafico.Tipo', integer(tgbLineas));
  if (tipo < Integer(Low(TTipoGraficoBolsa))) or (tipo > Integer(High(TTipoGraficoBolsa))) then
    FGrafico.Tipo := TTipoGraficoBolsa(tgbLineas)
  else
    FGrafico.Tipo := TTipoGraficoBolsa(tipo);}
  // Si se crean osciladores y al cerrarse el programa estás en la vista de escenarios,
  // al arrancar el programa daba error, ya que se intentaba crear los osciladores
  // en la vista de escenarios. Para evitarlo, por defecto siempre arranca en
  // la vista de líneas.
  FGrafico.Tipo := TTipoGraficoBolsa(tgbLineas);
  seccion := 'GraficoBolsa';
  FGrafico.ColorBackgroud := ConfiguracionVisual.ReadInteger(seccion, 'ColorBackground', clBlack);
  FGrafico.ColorPositions := ConfiguracionVisual.ReadInteger(seccion, 'ColorPositions', clYellow);
  FGrafico.ColorLines := ConfiguracionVisual.ReadInteger(seccion, 'ColorLines', clGreen);
  FGrafico.ColorPosition := ConfiguracionVisual.ReadInteger(seccion, 'ColorPosition', clWhite);
  FGrafico.ColorDibujarLinea := ConfiguracionVisual.ReadInteger(seccion, 'ColorDibujarLinea', clYellow);
  FGrafico.ColorDibujarLineaSelec := ConfiguracionVisual.ReadInteger(seccion, 'ColorDibujarLineaSelec', clWhite);
end;

procedure TfSCMain.OnAfterShow(var message: TMessage);
begin
  Bus.SendEvent(MessageSCShowed);
end;

procedure TfSCMain.OnColorGraficoChanged;
var color: TColor;
begin
  color := FGrafico.ColorBackgroud;
  PanelGrafico.Color := Color;
  PanelGraficoTop.Color := color;
  ToolBarOsciladores.Color := Color;
end;

procedure TfSCMain.OnTipoGraficoChange;
begin
  if PanelOsicladoresVisible then
    PanelGraficoTop.Visible := FGrafico.Tipo = tgbLineas;
end;

procedure TfSCMain.OnValorCambiado;
begin
  FGrafico.LoadData;
end;


procedure TfSCMain.SaveFormConfig;
var seccion: string;
begin
  inherited;
//  ConfiguracionVisual.WriteInteger(ClassName, 'Grafico.Tipo', Integer(FGrafico.Tipo));
  seccion := 'GraficoBolsa';
  ConfiguracionVisual.WriteInteger(seccion, 'ColorBackground', FGrafico.ColorBackgroud);
  ConfiguracionVisual.WriteInteger(seccion, 'ColorPositions', FGrafico.ColorPositions);
  ConfiguracionVisual.WriteInteger(seccion, 'ColorLines', FGrafico.ColorLines);
  ConfiguracionVisual.WriteInteger(seccion, 'ColorPosition', FGrafico.ColorPosition);
  ConfiguracionVisual.WriteInteger(seccion, 'ColorDibujarLinea', FGrafico.ColorDibujarLinea);
  ConfiguracionVisual.WriteInteger(seccion, 'ColorDibujarLineaSelec', FGrafico.ColorDibujarLineaSelec);
end;

procedure TfSCMain.SetPanelOsicladoresVisible(const Value: Boolean);
begin
  FPanelOsciladoresVisible := Value;
  PanelGraficoTop.Visible := (FPanelOsciladoresVisible) and
    (FGrafico <> nil) and (FGrafico.Tipo = tgbLineas);
end;

end.
