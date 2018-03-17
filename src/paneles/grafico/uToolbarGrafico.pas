unit uToolbarGrafico;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uPanelNotificaciones, Grafico, TB2Item, SpTBXItem, ImgList, TB2Dock,
  TB2Toolbar, ActnList, Menus, SpTBXFormPopupMenu, IncrustedItems,
  dmToolbarGrafico, Contnrs, GraficoPositionLayer, GraficoBolsa, UtilFS;

type
  TBotonItem = class(TSpTBXSubmenuItem)
  public
    Grafico: TGraficoItem;
    Titulo: string;
    VerGrafico: boolean;
    OID: integer;
  end;

  TfrToolbarGrafico = class(TfrPanelNotificaciones)
    ActionList: TActionList;
    Administrar: TAction;
    Toolbar: TSpTBXToolbar;
    ImageList: TImageList;
    MenuGeneral: TSpTBXSubmenuItem;
    ColorPalette: TSpTBXColorPalette;
    Ver: TAction;
    SpTBXItem2: TSpTBXItem;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    Quitar: TAction;
    mgQuitar: TSpTBXItem;
    MenuAnadir: TSpTBXSubmenuItem;
    SpTBXItem1: TSpTBXItem;
    SpTBXSeparatorItem2: TSpTBXSeparatorItem;
    MenuOsciladores: TSpTBXSubmenuItem;
    SpTBXItem4: TSpTBXItem;
    aAnadirValor: TAction;
    procedure AdministrarExecute(Sender: TObject);
    procedure ColorPaletteChange(Sender: TObject);
    procedure VerExecute(Sender: TObject);
    procedure MenuGeneralPopup(Sender: TTBCustomItem; FromLink: Boolean);
    procedure QuitarExecute(Sender: TObject);
    procedure MenuOsciladoresPopup(Sender: TTBCustomItem; FromLink: Boolean);
    procedure aAnadirValorExecute(Sender: TObject);
  private
    botones: TObjectList;
    MenuCreated: boolean;
    ToolbarGrafico: TToolbarGrafico;
    FGraficoBolsa: TGraficoBolsa;
    procedure OnCalculated(Sender: TGraficoItem; itemToNotify: TTBCustomItem;
      stopped: boolean);
    procedure OnAdministrarOsciladorChangeColor(const OID: Integer; const color: TColor);
    procedure OnAdministrarOsciladorDeleted(const OID: integer);
    procedure OnAdministrarOsciladorChangeName(const OID: integer; const name: string);
    procedure AnadirOscilador(Sender: TObject);
    procedure AnadirOsciladorItem(const osciladorItem: TMenuFSItem);
    procedure AnadirValor(const OIDValor: integer);
    function GetGrafico: TGrafico;
    function GetColor: TColor;
    procedure SetColor(const Value: TColor);
    procedure OnShowParent(Sender: TObject);
  protected
    procedure SaveConfigVisual;
    procedure LoadConfigVisual;
    procedure OnCotizacionCambiada; override;
    property Grafico: TGrafico read GetGrafico;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetNombre: string; override;
    procedure AnadirGrafico(const item: TBotonItem; const graficoItem: TGraficoItem;
      const color: TColor);
    procedure QuitarBoton(boton: TSpTBXSubmenuItem);      
    property GraficoBolsa: TGraficoBolsa read FGraficoBolsa write FGraficoBolsa;
    property Color: TColor read GetColor write SetColor;
  end;

implementation

uses UtilDock, fmOsciladores, dmOsciladores, UtilForms, dmFS, frFS,
  dmData, fmBaseBuscar, dmDataComun, GraficoValor, GraficoOscilador,
  DatosGrafico, GraficoLineas, BusCommunication, uAccionesVer, ConfigVisual;

{$R *.dfm}

const
  INDEX_CALCULATING = 2;

type
  TBotonOsciladorItem = class;

  TMenuOsciladorItem = class(TMenuFSItem)
  private
    Color: TColor;
    BotonOscilador: TBotonOsciladorItem;
    CodigoCompiled: string;
    OID: integer;
  end;

  TBotonOsciladorItem = class(TBotonItem)
  private
    MenuItem: TMenuOsciladorItem;
  end;

function CrearMenuItem(const AOwner: TComponent; const FS: TFS;
  const data: TBasicNodeData): TSpTBXItem;
var i, OID: Integer;
  botones: TObjectList;
  botonItem: TBotonOsciladorItem;
begin
  OID := data.OID;
  TOsciladores(FS).Load(OID);
  if TOsciladores(FS).HasCodigoCompiled then begin
    result := TMenuOsciladorItem.Create(AOwner);
    result.Caption := data.Caption;
    TMenuOsciladorItem(result).OID := OID;
    TMenuOsciladorItem(result).BotonOscilador := nil;
    TMenuOsciladorItem(result).Color := TOsciladores(FS).Color;
    TMenuOsciladorItem(result).CodigoCompiled := TOsciladores(FS).CodigoCompiled;
    botones := TfrToolbarGrafico(AOwner).botones;
    for i := botones.Count - 1 downto 0 do begin
      botonItem := TBotonOsciladorItem(botones[i]);
      if botonItem.OID = OID then begin
        botonItem.MenuItem := TMenuOsciladorItem(result);
        TMenuOsciladorItem(result).BotonOscilador := botonItem;
        TMenuOsciladorItem(result).Checked := true;
        exit;
      end;
    end;
  end
  else
    result := nil;
end;


{ TfrPanelNotificaciones1 }

procedure TfrToolbarGrafico.AnadirGrafico(const item: TBotonItem;
  const graficoItem: TGraficoItem; const color: TColor);
begin
  item.Images := ImageList;
  item.DisplayMode := nbdmImageAndText;
  item.Caption := item.Titulo;
  item.Options := [tboDropdownArrow];
  item.LinkSubitems := MenuGeneral;
  item.FontSettings.Color := color;
  item.VerGrafico := true;
  item.Grafico := graficoItem;
  graficoItem.Color := color;
  graficoItem.Visible := True;
  graficoItem.ItemImageIndexCalculating := INDEX_CALCULATING;
  graficoItem.OnCalculated := OnCalculated;
  Toolbar.Items.Add(item);
  botones.Add(item);
  graficoItem.Run;
end;

procedure TfrToolbarGrafico.AnadirOscilador(Sender: TObject);
var osciladorItem: TMenuOsciladorItem;
begin
  if Sender is TMenuOsciladorItem then begin
    osciladorItem := TMenuOsciladorItem(Sender);
    if osciladorItem.Checked then begin
      QuitarBoton(osciladorItem.BotonOscilador);
    end
    else
      AnadirOsciladorItem(osciladorItem);
  end;
end;

procedure TfrToolbarGrafico.AnadirOsciladorItem(const osciladorItem: TMenuFSItem);
var item: TBotonOsciladorItem;
  Oscilador: TGraficoOscilador;
begin
  osciladorItem.Checked := true;
  item := TBotonOsciladorItem.Create(Self);
  item.OID := osciladorItem.OID;
//  item.Images := ImageList;
//  item.DisplayMode := nbdmImageAndText;
  item.Titulo := osciladorItem.Caption;
//  item.Caption := item.Titulo;
//  item.Options := [tboDropdownArrow];
//  item.LinkSubitems := MenuGeneral;
//  item.FontSettings.Color := TMenuOsciladorItem(osciladorItem).Color;
  item.MenuItem := TMenuOsciladorItem(osciladorItem);
//  item.VerGrafico := true;
//  Toolbar.Items.Add(item);
//  botones.Add(item);
  TMenuOsciladorItem(osciladorItem).BotonOscilador := item;
  Oscilador := TGraficoOscilador.Create(Grafico,
    TMenuOsciladorItem(osciladorItem).CodigoCompiled, item);
//  Oscilador.ItemImageIndexCalculating := INDEX_CALCULATING;
//  Oscilador.OnCalculated := OnCalculated;
//  Oscilador.Visible := true;
//  Oscilador.Color := TMenuOsciladorItem(osciladorItem).Color;
//  item.Grafico := Oscilador;
//  Oscilador.Run;

  AnadirGrafico(item, Oscilador, TMenuOsciladorItem(osciladorItem).Color);
end;

procedure TfrToolbarGrafico.AnadirValor(const OIDValor: integer);
var item: TBotonItem;
  ValorItem: TGraficoValor;
begin
  item := TBotonItem.Create(Self);
  item.OID := OIDValor;
  item.Titulo := DataComun.FindValor(OIDValor)^.Simbolo;
//  item.Images := ImageList;
//  item.DisplayMode := nbdmImageAndText;
//  item.Caption := item.Titulo;
//  item.Options := [tboDropdownArrow];
//  item.LinkSubitems := MenuGeneral;
//  item.FontSettings.Color := clWhite;
//  item.VerGrafico := true;
  ValorItem := TGraficoValor.Create(Grafico, item, OIDValor);
//  ValorItem.ItemImageIndexCalculating := INDEX_CALCULATING;
//  ValorItem.Visible := true;
  ValorItem.Color := clWhite;
//  ValorItem.OnCalculated := OnCalculated;
//  item.Grafico := ValorItem;
//  Toolbar.Items.Add(item);
//  botones.Add(item);
//  ValorItem.Run;
  AnadirGrafico(item, ValorItem, clWhite);
end;

procedure TfrToolbarGrafico.aAnadirValorExecute(Sender: TObject);
var BuscarValor: TfBaseBuscar;
  OIDValor: integer;
begin
  inherited;
  BuscarValor := TfBaseBuscar.Create(Self);
  try
    BuscarValor.ShowModal;
    OIDValor := BuscarValor.OID_VALOR;
  finally
    BuscarValor.Free;
  end;
  if OIDValor <> VALOR_NO_SELECTED then
    AnadirValor(OIDValor);
end;

procedure TfrToolbarGrafico.AdministrarExecute(Sender: TObject);
var osciladores: TfOsciladores;
begin
  osciladores := TfOsciladores.Create(nil);
  try
    osciladores.OnChangeColor := OnAdministrarOsciladorChangeColor;
    osciladores.OnDeleteItem := OnAdministrarOsciladorDeleted;
    osciladores.OnChangeName := OnAdministrarOsciladorChangeName;
    osciladores.ShowModal;
  finally
    osciladores.Free;
  end;

  while MenuOsciladores.Count > 2 do
    MenuOsciladores.Delete(2);
  MenuCreated := false;
end;

procedure TfrToolbarGrafico.ColorPaletteChange(Sender: TObject);
var color: TColor;
  item: TBotonItem;
begin
  inherited;
  item := TBotonItem((Sender as TSpTBXColorPalette).Tag);
  color := ColorPalette.Color;
  item.FontSettings.Color := color;
  item.Grafico.Color := color;
  if item is TBotonOsciladorItem then begin
    TBotonOsciladorItem(item).MenuItem.Color := Color;
    ToolbarGrafico.ModificarColor(TBotonOsciladorItem(item).MenuItem.OID, color);
  end;
end;

constructor TfrToolbarGrafico.Create(AOwner: TComponent);
var defaultDock: TDefaultDock;
begin
  defaultDock.Position := dpArribaCentro;
  inherited CreatePanelNotificaciones(AOwner, defaultDock, [pnCotizacionCambiada]);
  MenuCreated := false;
  ToolbarGrafico := TToolbarGrafico.Create(Self);
  botones := TObjectList.Create(False);
  (AOwner as TForm).OnShow := OnShowParent;
  Bus.RegisterEvent(MessageVistaGuardando, SaveConfigVisual);
  Bus.RegisterEvent(MessageVistaCargando, LoadConfigVisual);
end;

destructor TfrToolbarGrafico.Destroy;
begin
  Bus.UnregisterEvent(MessageVistaGuardando, SaveConfigVisual);
  Bus.UnregisterEvent(MessageVistaCargando, LoadConfigVisual);
  SaveConfigVisual;
  while botones.Count > 0 do
    QuitarBoton(TBotonItem(botones[0]));
  botones.Free;
  inherited;
end;


function TfrToolbarGrafico.GetColor: TColor;
begin
  Result := inherited Color;
end;

function TfrToolbarGrafico.GetGrafico: TGrafico;
begin
  Result := FGraficoBolsa.GetGrafico(tgbLineas);
end;

class function TfrToolbarGrafico.GetNombre: string;
begin
  result := '';
end;

procedure TfrToolbarGrafico.LoadConfigVisual;
var i, num, OID: integer;
  sI, clase: string;
  menu: TMenuFSItem;
begin
  while botones.Count > 0 do
    QuitarBoton(TBotonItem(botones[0]));
  num := ConfiguracionVisual.ReadInteger(ClassName, 'Num', 0);
  for i := 0 to num do begin
    sI := IntToStr(i);
    clase := ConfiguracionVisual.ReadString(ClassName, 'ClassName.' + sI, '');
    OID := ConfiguracionVisual.ReadInteger(ClassName, 'OID.' + sI, -1);
    if clase = 'TBotonOsciladorItem' then begin
      menu := GetMenuItem(MenuOsciladores, OID);
      AnadirOsciladorItem(menu);
    end
    else begin
      if clase = 'TBotonItem' then begin
        AnadirValor(OID);
      end;
    end;
  end;
end;

procedure TfrToolbarGrafico.MenuGeneralPopup(Sender: TTBCustomItem;
  FromLink: Boolean);
var item: TBotonItem;
begin
  inherited;
  item := Sender as TBotonItem;
  Ver.Checked := item.VerGrafico;
  Ver.Tag := integer(item);
  Quitar.Tag := integer(item);
  ColorPalette.Tag := integer(item);
  ColorPalette.OnChange := nil;
  if item is TBotonOsciladorItem then
    ColorPalette.Color := TBotonOsciladorItem(item).MenuItem.Color
  else
    ColorPalette.Color := clWhite;
  ColorPalette.OnChange := ColorPaletteChange;
end;

procedure TfrToolbarGrafico.MenuOsciladoresPopup(Sender: TTBCustomItem;
  FromLink: Boolean);
begin
  inherited;
  if not MenuCreated then begin
    CreateMenuFormFS(Self, MenuOsciladores, TOsciladores, AnadirOscilador, CrearMenuItem);
    MenuCreated := true;
  end;
end;

procedure TfrToolbarGrafico.OnAdministrarOsciladorChangeColor(const OID: Integer;
  const color: TColor);
var menu: TMenuFSItem;
begin
  menu := GetMenuItem(MenuOsciladores, OID);
  if menu <> nil then begin
    assert(menu.ClassType = TMenuOsciladorItem);
    TMenuOsciladorItem(menu).Color := color;
    if TMenuOsciladorItem(menu).BotonOscilador <> nil then
      TMenuOsciladorItem(menu).BotonOscilador.FontSettings.Color := color;
  end;
end;

procedure TfrToolbarGrafico.OnAdministrarOsciladorChangeName(const OID: integer;
  const name: string);
var menu: TMenuFSItem;
begin
  menu := GetMenuItem(MenuOsciladores, OID);
  if menu <> nil then begin
    assert(menu.ClassType = TMenuOsciladorItem);
    if TMenuOsciladorItem(menu).BotonOscilador <> nil then
      TMenuOsciladorItem(menu).BotonOscilador.Caption := name;
  end;
end;

procedure TfrToolbarGrafico.OnAdministrarOsciladorDeleted(const OID: integer);
var menu: TMenuFSItem;
begin
  menu := GetMenuItem(MenuOsciladores, OID);
  if menu <> nil then begin
    assert(menu.ClassType = TMenuOsciladorItem);
    if TMenuOsciladorItem(menu).BotonOscilador <> nil then
      QuitarBoton(TMenuOsciladorItem(menu).BotonOscilador);
  end;
end;

procedure TfrToolbarGrafico.OnCotizacionCambiada;
var i, position: integer;
  graficoItem: TGraficoItem;
  boton: TBotonItem;
  caption: string;
  cambio: currency;
  PositionLayer: TGraficoPositionLayer;
begin
  if Toolbar.Visible then begin
    for i := botones.Count - 1 downto 0 do begin
      boton := TBotonItem(botones.Items[i]);
      graficoItem := boton.Grafico;
      if graficoItem.Calculated then begin
        caption := boton.Titulo;
        PositionLayer := Grafico.GetLayerByType(TGraficoPositionLayer) as TGraficoPositionLayer;
        if PositionLayer <> nil then begin
          position := PositionLayer.Position;
          if position <> POSICION_INDEFINIDA then begin
            cambio := graficoItem.PDatos^[position];
            if cambio <> SIN_CAMBIO then
              caption := caption + sLineBreak + CurrToStr(cambio);
          end;
        end;
        boton.Caption := caption;
      end;
    end;
  end;
end;

procedure TfrToolbarGrafico.OnShowParent(Sender: TObject);
begin
  TForm(Owner).OnShow := nil;
  MenuOsciladoresPopup(nil, false);
  LoadConfigVisual;
end;

procedure TfrToolbarGrafico.OnCalculated(Sender: TGraficoItem;
  itemToNotify: TTBCustomItem; stopped: boolean);
begin
  if stopped then begin
    QuitarBoton(TBotonItem(itemToNotify));
  end
  else begin
    itemToNotify.Images := nil;
    itemToNotify.ImageIndex := -1;
    ToolBar.Invalidate;
    OnCotizacionCambiada;
  end;
end;

procedure TfrToolbarGrafico.QuitarBoton(boton: TSpTBXSubmenuItem);
var item: TBotonItem;
  i: integer;
  menuItem: TMenuOsciladorItem;
begin
  item := TBotonItem(boton);
  i := botones.IndexOf(item);
  if i <> -1 then
    botones.Delete(i);
  if item.Grafico <> nil then begin
    item.Grafico.Free;
    item.Grafico := nil;
  end;
  if item is TBotonOsciladorItem then begin
    menuItem := TBotonOsciladorItem(item).MenuItem;
    TMenuOsciladorItem(menuItem).BotonOscilador := nil;
    menuItem.Checked := false;
  end;
  item.Free;
  Grafico.InvalidateGrafico;
end;

procedure TfrToolbarGrafico.QuitarExecute(Sender: TObject);
begin
  inherited;
  QuitarBoton(TBotonOsciladorItem((Sender as TAction).Tag));
end;

procedure TfrToolbarGrafico.SaveConfigVisual;
var i, num: integer;
  sI: string;
  boton: TBotonItem;
begin
  ConfiguracionVisual.DeleteSeccion(ClassName);
  num := botones.Count;
  ConfiguracionVisual.WriteInteger(ClassName, 'Num', num);
  Dec(num);
  for i := 0 to num do begin
    sI := IntToStr(i);
    boton := TBotonItem(botones[i]);
    ConfiguracionVisual.WriteString(ClassName, 'ClassName.' + sI, boton.ClassName);
    ConfiguracionVisual.WriteInteger(ClassName, 'OID.' + sI, boton.OID);
  end;
end;

procedure TfrToolbarGrafico.SetColor(const Value: TColor);
begin
  inherited Color := Value;
  Toolbar.Color := Value;
end;

procedure TfrToolbarGrafico.VerExecute(Sender: TObject);
var item: TBotonItem;
begin
  inherited;
  Ver.Checked := not Ver.Checked;
  item := TBotonItem((Sender as TAction).Tag);
  item.VerGrafico := Ver.Checked;
  if Ver.Checked then
    item.FontSettings.Style := item.FontSettings.Style - [fsStrikeOut]
  else
    item.FontSettings.Style := item.FontSettings.Style + [fsStrikeOut];
  item.Grafico.Visible := Ver.Checked;
end;

end.
