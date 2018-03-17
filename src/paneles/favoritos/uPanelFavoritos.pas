unit uPanelFavoritos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uPanelNotificaciones, ActnList, ImgList, JvTabBar,
  uPanel, Menus, ActnPopup, TB2Item, SpTBXItem, TB2Toolbar,
  TB2Dock, dmDataComun, JvComponentBase, JvFormPlacement;

const
  WM_SELECCIONAR_TAB_FAVORITOS = WM_USER + 1;
  WM_CERRAR_TAB_FAVORITOS = WM_USER + 2;

type
  TfrPanelFavoritos = class(TfrPanelNotificaciones)
    ToolWindowFavoritos: TSpTBXToolWindow;
    Favoritos: TJvTabBar;
    ToolBarAnadirFavoritos: TSpTBXToolbar;
    TBXItem22: TSpTBXItem;
    ActionList: TActionList;
    ImageList: TImageList;
    AnadirFavoritos: TAction;
    CerrarTodasFavoritos: TAction;
    PopupFavoritos: TPopupActionBar;
    Cerrartodas1: TMenuItem;
    MostrarNombre: TAction;
    MostrarSimbolo: TAction;
    MostrarBandera: TAction;
    Bandera1: TMenuItem;
    N1: TMenuItem;
    Smbolo1: TMenuItem;
    Nombre1: TMenuItem;
    procedure AnadirFavoritosExecute(Sender: TObject);
    procedure FavoritosTabClosed(Sender: TObject; Item: TJvTabBarItem);
    procedure CerrarTodasFavoritosExecute(Sender: TObject);
    procedure FavoritosTabSelected(Sender: TObject; Item: TJvTabBarItem);
    procedure FavoritosMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FavoritosTabClosing(Sender: TObject; Item: TJvTabBarItem;
      var AllowClose: Boolean);
    procedure ToolWindowFavoritosDockChanged(Sender: TObject);
    procedure MostrarNombreExecute(Sender: TObject);
    procedure MostrarSimboloExecute(Sender: TObject);
    procedure MostrarBanderaExecute(Sender: TObject);
  private
    cerrandoTabFavoritos: boolean;
    procedure AnadirTab(const OIDValor: integer);
    procedure CargarFavoritos;
    procedure SeleccionarDeseleccionarValor;
    procedure OnSeleccionarTabFavoritos(var message: TMessage); message WM_SELECCIONAR_TAB_FAVORITOS;
    procedure OnTabCerrada(var message: TMessage); message WM_CERRAR_TAB_FAVORITOS;
    procedure AnadirFavorito(const OIDValor: integer; const valor, hintValor: string;
      const seleccionar: boolean; const imageIndex: integer);
    procedure OnMostradoChange;
    procedure LoadConfigVisual;
    procedure SaveConfigVisual;
  protected
    function GetTitulo(const valorData: PDataComunValor): string;
    procedure OnValorCambiado; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Anadir;
    class function GetNombre: string; override;
  end;

implementation

{$R *.dfm}

uses UtilDock, dmConfiguracion, dmData, ConfigVisual, BusCommunication, uAccionesVer,
  uAccionesValor, uAcciones, dmAccionesValor;

resourcestring
  NOMBRE = 'Favoritos';
  HINT_TAB = 'Cambiar al valor %s';

procedure TfrPanelFavoritos.AnadirFavorito(const OIDValor: integer;
  const valor, hintValor: string; const seleccionar: boolean; const imageIndex: integer);
var tab: TJvTabBarItem;
begin
  tab := Favoritos.AddTab(valor);
  tab.Hint := Format(HINT_TAB, [hintValor]);
  tab.ShowHint := true;
  tab.Selected := seleccionar;
  tab.Tag := OIDValor;
  tab.ImageIndex := imageIndex;
end;

procedure TfrPanelFavoritos.Anadir;
begin
  AnadirFavoritos.Execute;
end;

procedure TfrPanelFavoritos.AnadirFavoritosExecute(Sender: TObject);
var OIDValor: integer;
begin
  OIDValor := data.OIDValor;
  AnadirTab(OIDValor);
  SeleccionarDeseleccionarValor;
end;

procedure TfrPanelFavoritos.AnadirTab(const OIDValor: integer);
var iBandera: integer;
  valorData: PDataComunValor;
begin
  valorData := DataComun.FindValor(OIDValor);
  if MostrarBandera.Checked then
    iBandera := valorData^.Mercado.BanderaImageIndex
  else
    iBandera := -1;
  AnadirFavorito(OIDValor, GetTitulo(valorData),
    valorData^.Simbolo + ' - ' + valorData^.Nombre,
    true, iBandera);
end;

destructor TfrPanelFavoritos.Destroy;
var i, num: integer;
begin
  Bus.UnregisterEvent(MessageVistaGuardando, SaveConfigVisual);
  Bus.UnregisterEvent(MessageVistaCargando, LoadConfigVisual);
  SaveConfigVisual;
  num := Favoritos.Tabs.Count;
  Configuracion.WriteInteger('TfrPanelFavoritos', 'TabsCount', num);
  for i := 1 to num do
    Configuracion.WriteInteger('TfrPanelFavoritos', 'Tabs.' + IntToStr(i), Favoritos.Tabs[i - 1].Tag);
  inherited;
end;

procedure TfrPanelFavoritos.CargarFavoritos;
var OIDValor, i, num: integer;
begin
  Favoritos.Tabs.BeginUpdate;
  try
    Favoritos.OnTabSelected := nil;
    num := Configuracion.ReadInteger('TfrPanelFavoritos', 'TabsCount', -1);
    for i := 1 to num do begin
      OIDValor := Configuracion.ReadInteger('TfrPanelFavoritos', 'Tabs.' + IntToStr(i), -1);
      if OIDValor <> -1 then
        AnadirTab(OIDValor);
    end;
    SeleccionarDeseleccionarValor;
  finally
    Favoritos.OnTabSelected := FavoritosTabSelected;
    Favoritos.Tabs.EndUpdate;
  end;
end;

procedure TfrPanelFavoritos.CerrarTodasFavoritosExecute(Sender: TObject);
begin
  Favoritos.Tabs.Clear;
  PostMessage(Handle, WM_CERRAR_TAB_FAVORITOS, 0, 0);
end;

constructor TfrPanelFavoritos.Create(AOwner: TComponent);
var defaultDock: TDefaultDock;
begin
  defaultDock.Position := dpAbajoCentro;
  defaultDock.Pos := 0;
  defaultDock.Row := 0;
  inherited CreatePanelNotificaciones(AOwner, defaultDock, [pnValorCambiado]);
  Bus.RegisterEvent(MessageVistaGuardando, SaveConfigVisual);
  Bus.RegisterEvent(MessageVistaCargando, LoadConfigVisual);
  LoadConfigVisual;
  // Importante realizar CargarFavoritos despues de OnValorCambiado, ya que sino
  // cuando se pulsa por primera vez una pestaña la variable seleccionandoValorTabFavoritos
  // está a true y no se selecciona
  CargarFavoritos;
end;

procedure TfrPanelFavoritos.FavoritosMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  cerrandoTabFavoritos := false;
end;

procedure TfrPanelFavoritos.FavoritosTabClosed(Sender: TObject;
  Item: TJvTabBarItem);
begin
  PostMessage(Handle, WM_CERRAR_TAB_FAVORITOS, 0, 0);
end;

procedure TfrPanelFavoritos.FavoritosTabClosing(Sender: TObject;
  Item: TJvTabBarItem; var AllowClose: Boolean);
begin
  cerrandoTabFavoritos := true;
  AllowClose := true;
end;

procedure TfrPanelFavoritos.FavoritosTabSelected(Sender: TObject;
  Item: TJvTabBarItem);
begin
  if Item = nil then
    exit;
{  if seleccionandoValorTabFavoritos then
    seleccionandoValorTabFavoritos := false
  else}
    PostMessage(Handle, WM_SELECCIONAR_TAB_FAVORITOS, 0, 0);
end;

class function TfrPanelFavoritos.GetNombre: string;
begin
  result := NOMBRE;
end;

function TfrPanelFavoritos.GetTitulo(const valorData: PDataComunValor): string;
begin
    result := '';
    if MostrarSimbolo.Checked then
      result := valorData^.Simbolo;
    if MostrarNombre.Checked then begin
      if result <> '' then
        result := result + ' - ';
      result := result + valorData^.Nombre;
    end;
end;

procedure TfrPanelFavoritos.LoadConfigVisual;
begin
  MostrarNombre.Checked := ConfiguracionVisual.ReadBoolean('TfrPanelFavoritos', 'MostrarNombre', true);
  MostrarSimbolo.Checked := ConfiguracionVisual.ReadBoolean('TfrPanelFavoritos', 'MostrarSimbolo', true);
  MostrarBandera.Checked := ConfiguracionVisual.ReadBoolean('TfrPanelFavoritos', 'MostrarBandera', true);
end;

procedure TfrPanelFavoritos.MostrarBanderaExecute(Sender: TObject);
begin
  inherited;
  MostrarBandera.Checked := not MostrarBandera.Checked;
  OnMostradoChange;
end;

procedure TfrPanelFavoritos.MostrarNombreExecute(Sender: TObject);
begin
  inherited;
  MostrarNombre.Checked := not MostrarNombre.Checked;
  OnMostradoChange;
end;

procedure TfrPanelFavoritos.MostrarSimboloExecute(Sender: TObject);
begin
  inherited;
  MostrarSimbolo.Checked := not MostrarSimbolo.Checked;
  OnMostradoChange;
end;

procedure TfrPanelFavoritos.OnMostradoChange;
var i, num, OIDValor: integer;
  tab: TJvTabBarItem;
  pDataValor: PDataComunValor;
begin
  Favoritos.Tabs.BeginUpdate;
  try
    num := Favoritos.Tabs.Count - 1;
    for i := 0 to num do begin
      tab := Favoritos.Tabs[i];
      OIDValor := tab.Tag;
      pDataValor := DataComun.FindValor(OIDValor);
      tab.Caption := GetTitulo(pDataValor);
      if MostrarBandera.Checked then
        tab.ImageIndex := pDataValor^.Mercado.BanderaImageIndex
      else
        tab.ImageIndex := -1;
    end;
  finally
    Favoritos.Tabs.EndUpdate;
  end;
end;

procedure TfrPanelFavoritos.OnSeleccionarTabFavoritos(var message: TMessage);
var tab: TJvTabBarItem;
  OIDValor: integer;
  accionesValor: TAccionesValor;
  DataAccionesValor: TDataAccionesValor;
begin
  if not cerrandoTabFavoritos then begin
    tab := Favoritos.SelectedTab;
    if tab <> nil then begin
      OIDValor := tab.Tag;
      if not data.IrAValor(OIDValor) then begin
        accionesValor := GetAcciones(TAccionesValor) as TAccionesValor;
        DataAccionesValor := accionesValor.DataAccionesValor;
        DataAccionesValor.ActivarTodos;
        data.IrAValor(OIDValor);
      end;
    end;
  end;
  cerrandoTabFavoritos := false;
end;

procedure TfrPanelFavoritos.OnTabCerrada(var message: TMessage);
begin
  SeleccionarDeseleccionarValor;
end;

procedure TfrPanelFavoritos.OnValorCambiado;
begin
  favoritos.OnTabSelected := nil;
  try
    SeleccionarDeseleccionarValor;
  finally
    Favoritos.OnTabSelected := FavoritosTabSelected;
  end;
end;

procedure TfrPanelFavoritos.SaveConfigVisual;
begin
  ConfiguracionVisual.WriteBoolean('TfrPanelFavoritos', 'MostrarNombre', MostrarNombre.Checked);
  ConfiguracionVisual.WriteBoolean('TfrPanelFavoritos', 'MostrarSimbolo', MostrarSimbolo.Checked);
  ConfiguracionVisual.WriteBoolean('TfrPanelFavoritos', 'MostrarBandera', MostrarBandera.Checked);
end;

procedure TfrPanelFavoritos.SeleccionarDeseleccionarValor;
var tab: TJvTabBarItem;
  i, OIDValor: integer;
begin
  if Data.HayValores then begin
    AnadirFavoritos.Enabled := true;
    OIDValor := Data.OIDValor;
    for i := 0 to Favoritos.Tabs.Count - 1 do begin
      tab := Favoritos.Tabs.Items[i];
      if tab.Tag = OIDValor then begin
        tab.Selected := true;
        tab.ShowHint := false;
        AnadirFavoritos.Enabled := false;
      end
      else begin
        tab.Selected := false;
        tab.Visible := false;
        tab.Visible := true;
        tab.ShowHint := true;
      end;
    end;
  end
  else begin
    AnadirFavoritos.Enabled := false;
  end;
end;

procedure TfrPanelFavoritos.ToolWindowFavoritosDockChanged(Sender: TObject);
var position: TTBDockPosition;
  dock: TTBDock;
begin
  dock := ToolWindowFavoritos.CurrentDock;
  if dock <> nil then begin
    position := dock.Position;
    case position of
      dpTop : Favoritos.Orientation := toTop;
      dpBottom : Favoritos.Orientation := toBottom;
    end;
  end;
end;

initialization
  RegisterPanelClass(TfrPanelFavoritos);

end.
