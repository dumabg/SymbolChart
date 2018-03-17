unit uAccionesVer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uAcciones, ActnList, ImgList,
  JvComponentBase, JvBalloonHint, UtilDock, uPanel, SpTBXItem, TB2Item, TB2Dock,
  TB2Toolbar, StdCtrls, BusCommunication, GraficoBolsa;

type
  MessageVistaGuardando = class(TBusMessage);
  MessageVistaCargando = class(TBusMessage);

  TDocks = array[TDockPositions] of TSpTBXDock;

  TAccionesVer = class(TAcciones)
    TBXSubmenuItem1: TSpTBXSubmenuItem;
    MenuItemVistasMenu: TSpTBXSubmenuItem;
    TBXSeparatorItem15: TSpTBXSeparatorItem;
    MenuVerPaneles: TSpTBXLabelItem;
    TBXSeparatorItem8: TSpTBXSeparatorItem;
    MenuVerBarras: TSpTBXLabelItem;
    TBXSeparatorItem10: TSpTBXSeparatorItem;
    TBXItemFijar: TSpTBXItem;
    ActionListPaneles: TActionList;
    FijarBarras: TAction;
    JvBalloonHint: TJvBalloonHint;
    ActionListBarras: TActionList;
    aGuardarVista: TAction;
    aBorrarVista: TAction;
    TBXItem116: TSpTBXItem;
    TBXItem117: TSpTBXItem;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    SpTBXSkinGroupItem1: TSpTBXSkinGroupItem;
    SpTBXSubmenuItem1: TSpTBXSubmenuItem;
    VistaSeleccionadaItem: TSpTBXSubmenuItem;
    VistaNinguna: TSpTBXItem;
    SpTBXItem4: TSpTBXItem;
    aVista: TAction;
    procedure FijarBarrasExecute(Sender: TObject);
    procedure aGuardarVistaExecute(Sender: TObject);
    procedure aBorrarVistaExecute(Sender: TObject);
    procedure aVistaExecute(Sender: TObject);
    procedure VistaSeleccionadaItemClick(Sender: TObject);
    procedure aBorrarVistaUpdate(Sender: TObject);
  private
    Docks: TDocks;
    GraficoBolsa: TGraficoBolsa;
    procedure GuardarVistas;
    procedure CargarVistas;
    procedure CargarSkin;
    function ExisteVista(vista: string): boolean;
    procedure AnadirVistaMenu(const vista: string);
    procedure CargarVista(const vista: string);
    procedure GuardarVista(const vista: string);
    procedure Paneles;
    procedure Barras;
    procedure MenuSelectPanel(Sender: TTBCustomItem; Viewer: TTBItemViewer; Selecting: Boolean);
    procedure MenuSelectBarra(Sender: TTBCustomItem; Viewer: TTBItemViewer; Selecting: Boolean);
    procedure ActualizarFijacionPanelesBarras(const fijar: boolean);
//    procedure RestaurarPanel(const panel: TfrPanel);
//    procedure RestaurarBarra(const barra: TBarra);
//    procedure RestaurarPanelesBarras;
    function IsPanelClassVisible(const panelClass: TfrPanelClass): boolean;
    procedure CargarPanel(const panel: TfrPanel);
    procedure GuardarPanel(const seccion: string; const panel: TfrPanel);
    procedure GuardarBarra(const seccion: string; const barra: TBarra);
    procedure CargarBarra(const seccion: string; const barra: TBarra);
    function CrearPanel(const panelClass: TfrPanelClass): TfrPanel;
    procedure VerPanelExecute(Sender: TObject);
    procedure OnClosePanel(Sender: TObject);
    procedure OnCloseBarra(Sender: TObject);
    procedure VerBarraExecute(Sender: TObject);
    procedure Recordatorio(const isPanel: boolean; const caption: string);
    procedure CargarPanelesBarras;
    procedure GuardarPanelesBarras;
    function GetRecordatorioCerrarPanel: boolean;
    procedure SetRecordatorioCerrarPanel(const Value: boolean);
    property RecordatorioCerrarPanel: boolean read GetRecordatorioCerrarPanel write SetRecordatorioCerrarPanel;
  public
    constructor Create(const GraficoBolsa: TGraficoBolsa; const Docks: TDocks); reintroduce;
    destructor Destroy; override;
    function GetBarras: TBarras; override;
    procedure MostrarPanel(const panelClass: TfrPanelClass);
    function GetPanel(const panelClass: TfrPanelClass): TfrPanel;
  end;

implementation

{$R *.dfm}

uses SCMain, fmRecordatorio, fmBaseNuevo,
  ConfigVisual, dmConfiguracion, UtilForms, SpTBXSkins;

resourcestring
  PANEL = 'Panel';
  BARRA = 'Barra';
  BORRAR_VISTA_CAPTION = 'Borrar vista';
  BORRAR_VISTA_MSG = 'Desea borrar la vista %s';
  GUARDAR_VISTA_CAPTION = 'Guardar vista';
  GUARDAR_VISTA_MSG = 'Ya existe otra vista con el nombre %s. ' + sLineBreak +
              '¿Desea sobreescribirla?';

const
  SECCION_ACCIONES_VER = 'AccionesVer';
  INDEX_VISTA_POR_DEFECTO = 1;
  SEPARADOR_VISTAS: Char = #127;

type
  TActionPanel = class(TAction)
  private
    FPanelClass: TfrPanelClass;
    FPanel: TfrPanel;
  public
    property PanelClass: TfrPanelClass read FPanelClass;
    property Panel: TfrPanel read FPanel;
  end;

  TActionBarra = class(TAction)
  private
    FBarra: TBarra;
  public
    property Barra: TBarra read FBarra;
  end;

  TTBCustomDockableWindowCracked = class(TTBCustomDockableWindow)
  public
    property OnClose;
  end;

{ TAccionesVer }

procedure TAccionesVer.aBorrarVistaUpdate(Sender: TObject);
begin
  inherited;
  aBorrarVista.Enabled := VistaSeleccionadaItem.Tag > 1;
end;

procedure TAccionesVer.ActualizarFijacionPanelesBarras(const fijar: boolean);
var i: integer;
  c: TComponent;
begin
  for i := 0 to fSCMain.ComponentCount - 1 do begin
    c := fSCMain.Components[i];
    if c is TSpTBXDock then
      TSpTBXDock(c).AllowDrag := not fijar;
  end;
end;

procedure TAccionesVer.Barras;
var aAcciones: TAAcciones;
  acciones: TAcciones;
  actionBarra: TActionBarra;
  i, iMenu, j: integer;
  menu: TSpTBXItem;
  action: TBasicAction;
  nombre: string;
  barras: TBarras;
  barra: TBarra;

  procedure CrearBarra(barra: TBarra);
  begin
    actionBarra := TActionBarra.Create(Self);
    actionBarra.ActionList := ActionListBarras;
    actionBarra.FBarra := barra;
    actionBarra.Caption := barra.Toolbar.Caption;
    actionBarra.OnExecute := VerBarraExecute;
    actionBarra.Checked := true;
    menu := TSpTBXItem.Create(Self);
    menu.Action := actionBarra;
    menu.OnSelect := MenuSelectBarra;
    iMenu := MenuVerBarras.Parent.IndexOf(MenuVerBarras) + 1;
    action := MenuVerBarras.Parent.Items[iMenu].Action;
    while (action is TActionBarra) and (TActionBarra(action).Caption < nombre) do begin
      inc(iMenu);
      action := MenuVerBarras.Parent.Items[iMenu].Action;
    end;
    MenuVerBarras.Parent.Insert(iMenu, menu);
  end;
begin
  aAcciones := GetAccionesRegistradas;
  for i := Low(aAcciones) to High(aAcciones) do begin
    acciones := aAcciones[i];
    barras := acciones.GetBarras;
    for j := Low(barras) to High(barras) do begin
      barra := barras[j];
      CrearBarra(barra);
    end;
  end;
  // Creamos las barras definidas aquí, en accionesVer
  barras := GetBarras;
  for j := Low(barras) to High(barras) do begin
    barra := barras[j];
    CrearBarra(barra);
  end;
end;

procedure TAccionesVer.aBorrarVistaExecute(Sender: TObject);
var vista: string;
begin
  if VistaSeleccionadaItem.Tag > 0 then
    vista := VistaSeleccionadaItem.Caption;
    if ShowMensaje(BORRAR_VISTA_CAPTION, Format(BORRAR_VISTA_MSG, [vista]),
    mtConfirmation, [mbYes, mbNo]) = mrYes then begin
      Configuracion.DeleteSubseccion(vista);
      VistaSeleccionadaItem.Items[VistaSeleccionadaItem.Tag].Free;
      GuardarVistas;
      aVistaExecute(VistaNinguna);
  end;
end;

procedure TAccionesVer.CargarBarra(const seccion: string; const barra: TBarra);
var nombre: string;
  currentDock: string;
  defaultDock: TDefaultDock;
  toolbar: TSpTBXToolbar;
begin
  defaultDock := barra.Dock;
  toolbar := barra.Toolbar;
  toolbar.OnClose := OnCloseBarra;
  nombre := toolbar.Owner.ClassName + '.' + toolbar.Name;
  currentDock := ConfiguracionVisual.ReadString(seccion, nombre + '.CurrentDock', '');
  if currentDock = '' then
    toolbar.CurrentDock := Docks[barra.Dock.Position]
  else
    toolbar.CurrentDock := fSCMain.FindComponent(currentDock) as TTBDock;
  toolbar.FloatingPosition :=
    Point(ConfiguracionVisual.ReadInteger(seccion, nombre + '.Floating.X', defaultDock.X),
          ConfiguracionVisual.ReadInteger(seccion, nombre + '.Floating.Y', defaultDock.Y));
  toolbar.Floating := ConfiguracionVisual.ReadBoolean(seccion, nombre + '.Floating', defaultDock.Position = dpFlotando);
  toolbar.DockPos := ConfiguracionVisual.ReadInteger(seccion, nombre + '.DockPos', defaultDock.Pos);
  toolbar.DockRow := ConfiguracionVisual.ReadInteger(seccion, nombre + '.DockRow', defaultDock.Row);
  toolbar.Visible := ConfiguracionVisual.ReadBoolean(seccion, nombre + '.Visible', true);
end;

procedure TAccionesVer.CargarPanel(const panel: TfrPanel);
var seccion, nombre: string;
  window: TTBCustomDockableWindow;
  point: TPoint;
  defaultDock: TDefaultDock;
  currentDock: string;
begin
  seccion := 'Panel';
  nombre := panel.ClassName;
  window := panel.Window;
  defaultDock := panel.DefaultDock;
  if panel.DefaultDock.Position = dpFlotando then
    window.Parent := Docks[defaultDock.Parent]
  else
    Window.Parent := Docks[defaultDock.Position];

  currentDock := ConfiguracionVisual.ReadString(seccion, nombre + '.CurrentDock', '');
  if currentDock = '' then
    window.CurrentDock := Docks[defaultDock.Position]
  else
    window.CurrentDock := fSCMain.FindComponent(currentDock) as TTBDock;
  window.DockPos := ConfiguracionVisual.ReadInteger(seccion, nombre + '.DockPos', defaultDock.Pos);
  window.DockRow := ConfiguracionVisual.ReadInteger(seccion, nombre + '.DockRow', defaultDock.Row);
  point.X := ConfiguracionVisual.ReadInteger(seccion, nombre + '.Floating.X', defaultDock.X);
  point.Y := ConfiguracionVisual.ReadInteger(seccion, nombre + '.Floating.Y', defaultDock.Y);
  window.FloatingPosition := point;
  window.Floating := ConfiguracionVisual.ReadBoolean(seccion, nombre + '.Floating', defaultDock.Position = dpFlotando);
  if (window is TSpTBXToolWindow) and (TSpTBXToolWindow(window).Stretch) then begin
    window.Width := ConfiguracionVisual.ReadInteger(seccion, nombre + '.Floating.Width', window.Width);
    window.Height := ConfiguracionVisual.ReadInteger(seccion, nombre + '.Floating.Height', window.Height);
  end;
  window.Visible := ConfiguracionVisual.ReadBoolean(seccion, nombre + '.Visible', true);
end;

procedure TAccionesVer.CargarPanelesBarras;
var seccion: string;
  i: integer;
  actionBarra: TActionBarra;
  actionPanel: TActionPanel;
  panel: TfrPanel;
  visible: boolean;
begin
  seccion := 'Barra';

  for i := 0 to ActionListBarras.ActionCount - 1 do begin
    actionBarra := ActionListBarras.Actions[i] as TActionBarra;
    CargarBarra(seccion, actionBarra.Barra);
    actionBarra.Checked := actionBarra.Barra.Toolbar.Visible;
  end;

  for i := 0 to ActionListPaneles.ActionCount - 1 do begin
    actionPanel := ActionListPaneles.Actions[i] as TActionPanel;
    panel := actionPanel.Panel;
    visible := IsPanelClassVisible(actionPanel.PanelClass);
    if panel = nil then begin
      if visible then begin
        panel := CrearPanel(actionPanel.PanelClass);
        actionPanel.FPanel := panel;
        actionPanel.Checked := panel.Visible;
      end;
    end
    else begin
      if visible then  // Recargamos el panel, ya que es visible en la vista a cargar
        CargarPanel(panel)
      else begin  // En la vista a cargar el panel no está visible
        FreeAndNil(actionPanel.FPanel);
        actionPanel.Checked := false;
      end;
    end;
  end;
end;

procedure TAccionesVer.CargarSkin;
var skin: string;
begin
  skin := ConfiguracionVisual.ReadString('Ver', 'Skin', '');
  if skin = '' then
    SkinManager.SetToDefaultSkin
  else
    SkinManager.SetSkin(skin);
end;

procedure TAccionesVer.CargarVista(const vista: string);
begin
  ConfiguracionVisual.Vista := vista;
  CargarPanelesBarras;
  CargarSkin;
  Bus.SendEvent(MessageVistaCargando);
end;

procedure TAccionesVer.CargarVistas;
var i: integer;
  vista, vistas: string;
begin
  vistas := Configuracion.ReadString('Ver', 'Vistas', '');
  if vistas <> '' then begin
    i := 1;
    vista := '';
    while i <= Length(vistas) do begin
      if vistas[i] = SEPARADOR_VISTAS then begin
        AnadirVistaMenu(vista);
        vista := '';
      end
      else begin
        vista := vista + vistas[i];
      end;
      Inc(i);
    end;
    AnadirVistaMenu(vista);
  end;
end;

{procedure TAccionesVer.RestaurarPanelesBarras;
var i: integer;
  actionBarra: TActionBarra;
  actionPanel: TActionPanel;
  panel: TfrPanel;
begin
  for i := 0 to ActionListBarras.ActionCount - 1 do begin
    actionBarra := ActionListBarras.Actions[i] as TActionBarra;
    RestaurarBarra(actionBarra.Barra);
    actionBarra.Checked := actionBarra.Barra.Toolbar.Visible;
  end;

  // Al cargar una vista se deben guardar los paneles abiertos en la vista
  // por defecto y los que ya hay creados cargarlos con los nuevos valores
  // de la vista
  for i := 0 to ActionListPaneles.ActionCount - 1 do begin
    actionPanel := ActionListPaneles.Actions[i] as TActionPanel;
    panel := actionPanel.Panel;
    if panel = nil then begin
      if actionPanel.PanelClass.GetVisiblePorDefecto then begin
        panel := CrearPanel(actionPanel.PanelClass);
        actionPanel.FPanel := panel;
        actionPanel.Checked := panel.Visible;
      end;
    end
    else
      RestaurarPanel(panel)
  end;
end;}
{
procedure TAccionesVer.RestaurarBarra(const barra: TBarra);
var position: TDockPositions;
  toolbar: TSpTBXToolbar;
  dock: TDefaultDock;
  dockParent: TSpTBXDock;
  p: TPoint;
begin
  dock := barra.Dock;
  position := dock.Position;
  toolbar := barra.Toolbar;
  if position = dpFlotando then begin
    dockParent := Docks[dock.Parent];
    toolbar.Parent := dockParent;
    p := dockParent.ClientToScreen(Point(dock.Pos + 2, dockParent.Top + 2));
    toolbar.FloatingPosition := p;
    toolbar.Floating := true;
  end
  else begin
    toolbar.Parent := Docks[position];
    toolbar.Floating := false;
    toolbar.CurrentDock := Docks[position];
    toolbar.DockPos := dock.Pos;
    toolbar.DockRow := dock.Row;
  end;
  toolbar.OnClose := OnCloseBarra;
end;
}
function TAccionesVer.CrearPanel(const panelClass: TfrPanelClass): TfrPanel;
var Window: TTBCustomDockableWindowCracked;
begin
  result := CreatePanel(Self, panelClass.ClassName);
  Window := TTBCustomDockableWindowCracked(result.Window);
  Window.Visible := false; // Para que no haya flick, ya que por defecto es visible y en CargarPanel se configura el visible
  Window.OnClose := OnClosePanel;
  CargarPanel(result);
end;

constructor TAccionesVer.Create(const GraficoBolsa: TGraficoBolsa; const Docks: TDocks);
begin
  inherited Create(nil);
  Self.Docks := Docks;
  Self.GraficoBolsa := GraficoBolsa;
  Paneles;
  Barras;
  CargarSkin;
  CargarPanelesBarras;
  CargarVistas;
  FijarBarras.Checked := ConfiguracionVisual.ReadBoolean(SECCION_ACCIONES_VER, 'FijacionPanelesBarras', true);
  ActualizarFijacionPanelesBarras(FijarBarras.Checked);
end;

destructor TAccionesVer.Destroy;
begin
  GuardarPanelesBarras;
  ConfiguracionVisual.WriteBoolean(SECCION_ACCIONES_VER, 'FijacionPanelesBarras', FijarBarras.Checked);
  ConfiguracionVisual.WriteString('Ver', 'Skin', CurrentSkin.SkinName);
  inherited;
end;

function TAccionesVer.ExisteVista(vista: string): boolean;
var i, num: integer;
begin
  vista := UpperCase(vista);
  num := VistaSeleccionadaItem.Count - 1;
  for i := 2 to num do begin
    if UpperCase(VistaSeleccionadaItem.Items[i].Caption) = vista then begin
      result := true;
      exit;
    end;
  end;
  result := false;
end;

procedure TAccionesVer.FijarBarrasExecute(Sender: TObject);
var fijar: boolean;
begin
  JvBalloonHint.CancelHint;
  fijar := not FijarBarras.Checked;
  ActualizarFijacionPanelesBarras(fijar);
  FijarBarras.Checked := fijar;
end;

function TAccionesVer.GetBarras: TBarras;
begin
  result := inherited GetBarras;
  result[0].Dock.Position := dpArribaBotones;
  result[0].Dock.Pos := 300;
end;

function TAccionesVer.GetPanel(const panelClass: TfrPanelClass): TfrPanel;
var i, num: integer;
  action: TActionPanel;
begin
  num := ActionListPaneles.ActionCount - 1; //zero based
  for i := 0 to num do begin
    action := TActionPanel(ActionListPaneles.Actions[i]);
    if action.PanelClass = panelClass then begin
      result := action.Panel;
      exit;
    end;
  end;
  result := nil;
end;

function TAccionesVer.GetRecordatorioCerrarPanel: boolean;
begin
  result := Configuracion.ReadBoolean(SECCION_ACCIONES_VER, 'RecordatorioCerrarPanel', true);
end;

procedure TAccionesVer.GuardarBarra(const seccion: string; const barra: TBarra);
var nombre: string;
  aux: TTBDock;
  toolbar: TSpTBXToolbar;
begin
  toolbar := barra.Toolbar;
  nombre := toolbar.Owner.ClassName + '.' + toolbar.Name;
  aux := toolbar.CurrentDock;
  if aux = nil then
    ConfiguracionVisual.WriteString(seccion, nombre + '.CurrentDock', toolbar.LastDock.Name)
  else
    ConfiguracionVisual.WriteString(seccion, nombre + '.CurrentDock', aux.Name);
  ConfiguracionVisual.WriteBoolean(seccion, nombre + '.Floating', toolbar.Floating);
  ConfiguracionVisual.WriteInteger(seccion, nombre + '.Floating.X', toolbar.FloatingPosition.X);
  ConfiguracionVisual.WriteInteger(seccion, nombre + '.Floating.Y', toolbar.FloatingPosition.Y);
  ConfiguracionVisual.WriteInteger(seccion, nombre + '.DockPos', toolbar.DockPos);
  ConfiguracionVisual.WriteInteger(seccion, nombre + '.DockRow', toolbar.DockRow);
  ConfiguracionVisual.WriteBoolean(seccion, nombre + '.Visible', toolbar.Visible);
end;


procedure TAccionesVer.GuardarPanel(const seccion: string; const panel: TfrPanel);
var window: TTBCustomDockableWindow;
  aux: TTBDock;
  nombre: string;
begin
  window := panel.Window;
  nombre := panel.ClassName;
  aux := window.CurrentDock;
  if aux = nil then
    ConfiguracionVisual.WriteString(seccion, nombre + '.CurrentDock', window.LastDock.Name)
  else
    ConfiguracionVisual.WriteString(seccion, nombre + '.CurrentDock', aux.Name);
  ConfiguracionVisual.WriteBoolean(seccion, nombre + '.Floating', window.Floating);
  ConfiguracionVisual.WriteInteger(seccion, nombre + '.Floating.X', window.FloatingPosition.X);
  ConfiguracionVisual.WriteInteger(seccion, nombre + '.Floating.Y', window.FloatingPosition.Y);
  ConfiguracionVisual.WriteInteger(seccion, nombre + '.DockPos', window.DockPos);
  ConfiguracionVisual.WriteInteger(seccion, nombre + '.DockRow', window.DockRow);
  if (window is TSpTBXToolWindow) and (TSpTBXToolWindow(window).Stretch) then begin
    ConfiguracionVisual.WriteInteger(seccion, nombre + '.Floating.Width', window.Width);
    ConfiguracionVisual.WriteInteger(seccion, nombre + '.Floating.Height', window.Height);
  end;
  ConfiguracionVisual.WriteBoolean(seccion, nombre + '.Visible', window.Visible);
end;

procedure TAccionesVer.GuardarPanelesBarras;
var i: integer;
  actionBarra: TActionBarra;
  actionPanel: TActionPanel;
  panel: TfrPanel;
  seccion: string;
begin
  seccion := 'Barra';
  for i := 0 to ActionListBarras.ActionCount - 1 do begin
    actionBarra := ActionListBarras.Actions[i] as TActionBarra;
    GuardarBarra(seccion, actionBarra.Barra);
  end;

  seccion := 'Panel';
  for i := 0 to ActionListPaneles.ActionCount - 1 do begin
    actionPanel := ActionListPaneles.Actions[i] as TActionPanel;
    panel := actionPanel.Panel;
    if panel = nil then
      ConfiguracionVisual.WriteBoolean(seccion, actionPanel.PanelClass.ClassName + '.Visible', false)
    else
      GuardarPanel(seccion, panel);
  end;
end;

procedure TAccionesVer.GuardarVista(const vista: string);
begin
  VistaSeleccionadaItem.Caption := vista;
  GuardarVistas;
  ConfiguracionVisual.Vista := vista;
  Configuracion.DeleteSubseccion(ConfiguracionVisual.Vista + '.');
  GuardarPanelesBarras;
  ConfiguracionVisual.WriteString('Ver', 'Skin', CurrentSkin.SkinName);

  Bus.SendEvent(MessageVistaGuardando);
  // Una vez se haya guardado la vista seleccionada, se vuelve a seleccionar a VISTA_NINGUNA
  // ya que ahora los cambios que se pudieran realizar NO se deben guardar en la
  // vista seleccionada.
  ConfiguracionVisual.Vista := VISTA_NINGUNA;
end;

procedure TAccionesVer.GuardarVistas;
var i, num: integer;
  vistas: string;
begin
  num := VistaSeleccionadaItem.Count;
  if num = 2 then begin
    vistas := '';
  end
  else begin
    vistas := VistaSeleccionadaItem[2].Caption;
    Dec(num);
    for i := 3 to num do
      vistas := vistas + SEPARADOR_VISTAS + VistaSeleccionadaItem[i].Caption;
  end;
  Configuracion.WriteString('Ver', 'Vistas', vistas);
end;

procedure TAccionesVer.aGuardarVistaExecute(Sender: TObject);
var f: TfBaseNuevo;
  vista: string;
  done: boolean;
begin
  inherited;
  f := TfBaseNuevo.Create(nil);
  try
    f.Caption := 'Crear vista';
    f.Max := 20;
    done := false;
    while not done do begin
      if f.ShowModal = mrOk then begin
        vista := f.Nombre;
        if ExisteVista(vista) then begin
          if ShowMensaje(GUARDAR_VISTA_CAPTION, Format(GUARDAR_VISTA_MSG, [vista]),
            mtConfirmation, [mbYes, mbNo]) = mrYes
            then begin
              Configuracion.DeleteSubseccion(vista);
              GuardarVista(vista);
              done := true;
            end;
        end
        else begin
          AnadirVistaMenu(vista);
          GuardarVista(vista);
          done := true;
        end;
      end
      else
        done := true;
    end;
  finally
    f.Free;
  end;
end;

procedure TAccionesVer.AnadirVistaMenu(const vista: string);
var i, num: integer;
  upVista: string;
  
    function CreateItem: TSpTBXItem;
    begin
      result := TSpTBXItem.Create(Self);
      result.Caption := vista;
      result.OnClick := aVistaExecute;
    end;
begin
  upVista := UpperCase(vista);
  num := VistaSeleccionadaItem.Count - 1;
  for i := 2 to num do begin
    if UpperCase(VistaSeleccionadaItem.Items[i].Caption) > upVista then begin
      VistaSeleccionadaItem.Insert(i, CreateItem);
      exit;
    end;
  end;
  VistaSeleccionadaItem.Add(CreateItem);
end;

procedure TAccionesVer.aVistaExecute(Sender: TObject);
var i: integer;
  item: TSpTBXItem;
begin
  inherited;
  item := TSpTBXItem(Sender);
  i := VistaSeleccionadaItem.IndexOf(item);
  VistaSeleccionadaItem.Tag := i;
  VistaSeleccionadaItem.Caption := item.Caption;
  if i = 1 then
    CargarVista(VISTA_POR_DEFECTO)
  else begin
    if i > 1 then
      CargarVista(item.Caption)
    else
      VistaSeleccionadaItem.Tag := 0;
  end;
  // Una vez se haya cargado la vista seleccionada, se vuelve a seleccionar a VISTA_NINGUNA
  // ya que ahora los cambios que se pudieran realizar NO se deben guardar en la
  // vista seleccionada.
  ConfiguracionVisual.Vista := VISTA_NINGUNA;
  if not FijarBarras.Checked then
    FijarBarrasExecute(nil);
end;

function TAccionesVer.IsPanelClassVisible(
  const panelClass: TfrPanelClass): boolean;
var nombre: string;
begin
  nombre := panelClass.ClassName;
  result := ConfiguracionVisual.ReadBoolean('Panel', nombre + '.Visible', panelClass.GetVisiblePorDefecto);
end;

procedure TAccionesVer.MenuSelectBarra(Sender: TTBCustomItem;
  Viewer: TTBItemViewer; Selecting: Boolean);
var action: TActionBarra;
begin
  action := (Sender.Action as TActionBarra);
  if action.Checked then begin
    JvBalloonHint.ActivateHint(action.Barra.Toolbar, BARRA + ' ' + action.Caption)
  end
  else
    JvBalloonHint.CancelHint;
end;

procedure TAccionesVer.MenuSelectPanel(Sender: TTBCustomItem; Viewer: TTBItemViewer;
  Selecting: Boolean);
var action: TActionPanel;
begin
  action := (Sender.Action as TActionPanel);
  if action.Checked then begin
    JvBalloonHint.ActivateHint(action.Panel.Window, PANEL + ' ' + action.Caption)
  end
  else
    JvBalloonHint.CancelHint;
end;

procedure TAccionesVer.MostrarPanel(const panelClass: TfrPanelClass);
var i, num: integer;
  action: TActionPanel;
begin
  num := ActionListPaneles.ActionCount - 1; //zero based
  for i := 0 to num do begin
    action := TActionPanel(ActionListPaneles.Actions[i]);
    if action.PanelClass = panelClass then begin
      if action.Panel = nil then begin
        action.Checked := false;
        VerPanelExecute(action);
      end
      else
        action.Panel.Show;
      exit;
    end;
  end;
end;

procedure TAccionesVer.OnCloseBarra(Sender: TObject);
var toolbar: TSpTBXToolbar;
  i, num: integer;
  actionBarra: TActionBarra;
begin
  toolbar := TSpTBXToolbar(Sender);
  num := ActionListBarras.ActionCount;
  for i := 0 to num - 1 do begin
    actionBarra := ActionListBarras.Actions[i] as TActionBarra;
    if actionBarra.Barra.Toolbar = toolbar then begin
      VerBarraExecute(actionBarra);
      exit;
    end;
  end;
end;

procedure TAccionesVer.OnClosePanel(Sender: TObject);
var classPanel: TClass;
  i, num: integer;
  actionPanel: TActionPanel;
begin
  classPanel := TSpTBXToolWindow(Sender).Owner.ClassType;
  num := ActionListPaneles.ActionCount;
  for i := 0 to num - 1 do begin
    actionPanel := ActionListPaneles.Actions[i] as TActionPanel;
    if actionPanel.PanelClass = classPanel then begin
      VerPanelExecute(actionPanel);
      exit;
    end;
  end;
end;

procedure TAccionesVer.Paneles;
var panelClasses: TArrayPanelClass;
  actionPanel: TActionPanel;
  i, iMenu: integer;
  menu: TSpTBXItem;
  panelClass: TfrPanelClass;
  action: TBasicAction;
  nombre: string;
begin
  panelClasses := GetPanelClasses;
  for i := Low(panelClasses) to High(panelClasses) do begin
    panelClass := panelClasses[i];
    actionPanel := TActionPanel.Create(Self);
    actionPanel.ActionList := ActionListPaneles;
    actionPanel.FPanelClass := panelClass;
    nombre := panelClass.GetNombre;
    actionPanel.Caption := nombre;
    actionPanel.OnExecute := VerPanelExecute;
    actionPanel.Checked := false;
    menu := TSpTBXItem.Create(Self);
    menu.Action := actionPanel;
    menu.OnSelect := MenuSelectPanel;
    iMenu := MenuVerPaneles.Parent.IndexOf(MenuVerPaneles) + 1;
    action := MenuVerPaneles.Parent.Items[iMenu].Action;
    while (action is TActionPanel) and (TActionPanel(action).Caption < nombre) do begin
      inc(iMenu);
      action := MenuVerPaneles.Parent.Items[iMenu].Action;
    end;
    MenuVerPaneles.Parent.Insert(iMenu, menu);
  end;
end;

procedure TAccionesVer.Recordatorio(const isPanel: boolean; const caption: string);
var recordatorio: TfRecordatorio;
begin
  if RecordatorioCerrarPanel then begin
    recordatorio := TfRecordatorio.Create(nil);
    try
      if isPanel then
        recordatorio.Tipo := ttPanel
      else
        recordatorio.Tipo := ttBarra;
      recordatorio.Nombre := caption;
      recordatorio.ShowModal;
      RecordatorioCerrarPanel := recordatorio.MostrarProximaVez;
    finally
      recordatorio.Free;
    end;
  end;
end;
{
procedure TAccionesVer.RestaurarPanel(const panel: TfrPanel);
var Window: TTBCustomDockableWindowCracked;
  defaultDockPosition: TDockPositions;
begin
    Window := TTBCustomDockableWindowCracked(panel.Window);
    defaultDockPosition := panel.DefaultDock.Position;
    if defaultDockPosition = dpFlotando then begin
      // Visible := false para evitar parpadeo al asignarle un Parent y después
      // hacer que flote.
      Window.Visible := false;
      Window.Parent := Docks[panel.DefaultDock.Parent];
      Window.FloatingPosition := Point(panel.DefaultDock.X, panel.DefaultDock.Y);
      Window.Floating := true;
      Window.Visible := true;
    end
    else begin
      Window.Floating := false;
      Window.Parent := Docks[defaultDockPosition];
      Window.DockPos := panel.DefaultDock.Pos;
      Window.DockRow := panel.DefaultDock.Row;
    end;
end;
}

procedure TAccionesVer.SetRecordatorioCerrarPanel(const Value: boolean);
begin
  Configuracion.WriteBoolean(SECCION_ACCIONES_VER, 'RecordatorioCerrarPanel', Value);
end;

procedure TAccionesVer.VerBarraExecute(Sender: TObject);
var actionBarra: TActionBarra;
begin
  JvBalloonHint.CancelHint;
  actionBarra := (Sender as TActionBarra);
  if actionBarra.Checked then begin
    Recordatorio(false, actionBarra.Caption);
    // Se esconde la barra para que cuando se guarde su configuración se guarde
    // el visible = false
    actionBarra.Barra.Toolbar.Visible := false;
    GuardarBarra('Barra', actionBarra.Barra);
    actionBarra.Checked := false;
  end
  else begin
    actionBarra.Checked := true;
    actionBarra.Barra.Toolbar.Visible := true;
  end;
end;

procedure TAccionesVer.VerPanelExecute(Sender: TObject);
var actionPanel: TActionPanel;
begin
  JvBalloonHint.CancelHint;
  actionPanel := (Sender as TActionPanel);
  if actionPanel.Checked then begin
    Recordatorio(true, actionPanel.Caption);
    // Se esconde el panel para que cuando se guarde su configuración se guarde
    // el visible = false
    actionPanel.Panel.Visible := false;
    GuardarPanel('Panel', actionPanel.Panel);
    FreeAndNil(actionPanel.FPanel);
    actionPanel.Checked := false;
  end
  else begin
    actionPanel.FPanel := CrearPanel(actionPanel.PanelClass);
    actionPanel.FPanel.Window.Visible := true;
    actionPanel.Checked := true;
  end;
end;

procedure TAccionesVer.VistaSeleccionadaItemClick(Sender: TObject);
begin
  inherited;
  aVistaExecute(VistaSeleccionadaItem.Items[VistaSeleccionadaItem.Tag]);
end;

end.
