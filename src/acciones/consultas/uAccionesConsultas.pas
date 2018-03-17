unit uAccionesConsultas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uAcciones, ActnList, ImgList, TB2Item, SpTBXItem, TB2Dock, TB2Toolbar,
  dmConsultasMenu;

const
  WM_MENU_COUNT = WM_USER + 1;

type
  TAccionesConsultas = class(TAcciones)
    Administrar: TAction;
    MenuConsultas: TSpTBXSubmenuItem;
    SpTBXItem1: TSpTBXItem;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    procedure AdministrarExecute(Sender: TObject);
    procedure MenuConsultasPopup(Sender: TTBCustomItem; FromLink: Boolean);
  private
    MustCalculateValores: boolean;
    MenuCreated: boolean;
    ConsultasMenu: TConsultasMenu;
    UltimaOIDSesion: integer;
    OIDValores: TArrayInteger;
    OIDConsultaMenus: TArrayInteger;
    procedure MenuCount(var Msg: TMessage); message WM_MENU_COUNT;
    procedure OnMercadoGrupoCambiado;
    procedure OnTipoCotizacionCambiada;
    procedure InicializarMenuCount;
    procedure CalculateValores;
    procedure UpdateMenuCount(const menu: TSpTBXItem; const num: Integer);
    procedure BuscarOIDConsultaMenus;
    procedure CreateMenus;
    procedure OnClikMenuConsulta(Sender: TObject);
    procedure CrearConsulta(const OID: integer; const nombre: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetBarras: TBarras; override;
  end;


implementation

uses uAccionesGrafico, UtilForms, fmConsultas, VirtualTrees, frFS, dmConsultas,
fmConsulta, dmData, BusCommunication, dmAccionesValor, UtilDB, dmFS, UtilFS, StrUtils;

{$R *.dfm}

type
  TMenuCountItem = class(TMenuFSItem)
  end;

const
  NUM_DESCONOCIDO: integer = -1;

function CrearMenuItem(const AOwner: TComponent; const FS: TFS;
  const data: TBasicNodeData): TSpTBXItem;
begin
  if TConsultas(FS).HasCodigoCompiled(data.OID) then begin
    if TConsultas(FS).DebeContar(data.OID) then begin
      result := TMenuCountItem.Create(AOwner);
      result.Caption := data.Caption + ' (?)';
    end
    else begin
      result := TMenuFSItem.Create(AOwner);
      result.Caption := data.Caption;
    end;
  end
  else
    result := nil;
end;


procedure TAccionesConsultas.AdministrarExecute(Sender: TObject);
begin
  inherited;
  ShowFormModal(TfConsultas);
  while MenuConsultas.Count > 2 do
    MenuConsultas.Delete(2);
  MenuCreated := false;
end;

procedure TAccionesConsultas.CalculateValores;
var inspect: TInspectDataSet;
  i: integer;
begin
  SetLength(OIDValores, Data.Valores.RecordCount);
  inspect := StartInspectDataSet(Data.Valores);
  try
    i := 0;
    Data.Valores.First;
    while not Data.Valores.Eof do begin
      OIDValores[i] := Data.ValoresOID_VALOR.Value;
      Data.Valores.Next;
      inc(i);
    end;
    MustCalculateValores := false;
  finally
    EndInspectDataSet(inspect);
  end;
end;

procedure TAccionesConsultas.CrearConsulta(const OID: integer; const nombre: string);
var fConsulta: TfConsulta;
  nameConsulta: string;
begin
  if OID < 0 then  
    nameConsulta := '_CONSULTA_' + IntToStr(-OID)
  else
    nameConsulta := '_CONSULTA' + IntToStr(OID);
  fConsulta := TfConsulta(FindForm(Self, nameConsulta));
  if fConsulta = nil then begin
    fConsulta := TfConsulta.Create(Self, OID, @OIDValores);
    fConsulta.Name := nameConsulta;
    fConsulta.Caption := nombre;
    fConsulta.Show;
    fConsulta.Buscar;
  end
  else
    fConsulta.Show;
end;

constructor TAccionesConsultas.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ConsultasMenu := TConsultasMenu.Create(Handle);
  UltimaOIDSesion := -1;
  MustCalculateValores := true;
  Bus.RegisterEvent(MessageMercadoGrupoCambiado, OnMercadoGrupoCambiado);
  Bus.RegisterEvent(MessageTipoCotizacionCambiada, OnTipoCotizacionCambiada);
end;

procedure TAccionesConsultas.CreateMenus;
begin
  Screen.Cursor := crHourGlass;
  try
    CreateMenuFormFS(Self, MenuConsultas, TConsultas, OnClikMenuConsulta, CrearMenuItem);
    BuscarOIDConsultaMenus;
  finally
    Screen.Cursor := crDefault;
  end;
  MenuCreated := true;
end;

destructor TAccionesConsultas.Destroy;
begin
  Bus.UnregisterEvent(MessageMercadoGrupoCambiado, OnMercadoGrupoCambiado);
  Bus.UnregisterEvent(MessageTipoCotizacionCambiada, OnTipoCotizacionCambiada);
  ConsultasMenu.Free;
  inherited;
end;

function TAccionesConsultas.GetBarras: TBarras;
begin
  result := nil;
end;

procedure TAccionesConsultas.InicializarMenuCount;
var i, num: integer;
  subItem: TSpTBXItem;

  procedure IniSubMenuCount(const item: TSpTBXItem);
  var i, num: integer;
    subItem: TSpTBXItem;
  begin
    num := item.Count - 1;
    for i := 0 to num do begin
      subItem := TSpTBXItem(item.Items[i]);
      if subItem is TMenuCountItem then
        UpdateMenuCount(subItem, NUM_DESCONOCIDO)
      else
        IniSubMenuCount(subItem);
    end;
  end;

begin
  num := MenuConsultas.Count - 1;
  for i := 2 to num do begin
    subItem := TSpTBXItem(MenuConsultas.Items[i]);
    if subItem is TMenuCountItem then
      UpdateMenuCount(subItem, NUM_DESCONOCIDO)
    else
      IniSubMenuCount(subItem);
  end;
end;

procedure TAccionesConsultas.MenuConsultasPopup(Sender: TTBCustomItem;
  FromLink: Boolean);
var OIDSesion: Integer;
begin
  inherited;
  if not MenuCreated then begin
    CreateMenus;
    // Si se recrean los menus, se debe volver a calcular los posibles counts.
    // Lo más rápido es simular que ha habido un cambio de sesión.
    UltimaOIDSesion := -1;
  end;
  OIDSesion := Data.OIDSesion;
  if (UltimaOIDSesion <> OIDSesion) or (MustCalculateValores) then begin
    InicializarMenuCount;
    if MustCalculateValores then
      CalculateValores;
    ConsultasMenu.Find(@OIDValores, @OIDConsultaMenus);
    UltimaOIDSesion := OIDSesion;
  end;
end;

procedure TAccionesConsultas.MenuCount(var Msg: TMessage);
var OIDConsulta: integer;
  item: TSpTBXItem;

  function FindSubMenu(const item: TSpTBXItem): TSpTBXItem;
  var i, num: integer;
    subItem: TSpTBXItem;
  begin
    num := item.Count - 1;
    for i := 0 to num do begin
      subItem := TSpTBXItem(item.Items[i]);
      if subItem.Count = 0 then begin
        if (subItem is TMenuCountItem) and (TMenuCountItem(subItem).OID = OIDConsulta) then begin
          result := subItem;
          exit;
        end;
      end
      else begin
        result := FindSubMenu(subItem);
        if result <> nil then
          exit;
      end;
    end;
    result := nil;
  end;

  function FindItem: TSpTBXItem;
  var i, num: integer;
    subItem: TSpTBXItem;
  begin
    num := MenuConsultas.Count - 1;
    for i := 2 to num do begin
      subItem := TSpTBXItem(MenuConsultas.Items[i]);
      if subItem.Count = 0 then begin
        if (subItem is TMenuCountItem) and (TMenuCountItem(subItem).OID = OIDConsulta) then begin
          result := subItem;
          exit;
        end;
      end
      else begin
        result := FindSubMenu(subItem);
        if result <> nil then
          exit;
      end;
    end;
    result := nil;
  end;

begin
  OIDConsulta := Msg.WParam;
  item := FindItem;
  if item <> nil then  
    UpdateMenuCount(item, Msg.LParam);
end;

procedure TAccionesConsultas.OnClikMenuConsulta(Sender: TObject);
begin
  if not (Sender is TSpTBXSubmenuItem) then
    with TMenuCountItem(Sender) do
      CrearConsulta(OID, Caption);
end;

procedure TAccionesConsultas.OnMercadoGrupoCambiado;
begin
  MustCalculateValores := true;
end;

procedure TAccionesConsultas.OnTipoCotizacionCambiada;
begin
  UltimaOIDSesion := -1;
end;

procedure TAccionesConsultas.BuscarOIDConsultaMenus;
var iList, i, num: integer;
  subItem: TSpTBXItem;

  procedure AddItem(const item: TMenuCountItem);
  begin
    Inc(iList);
    SetLength(OIDConsultaMenus, iList);
    OIDConsultaMenus[iList - 1] := item.OID;
  end;

  procedure RefrescarSubMenu(const item: TSpTBXItem);
  var i, num: integer;
    subItem: TSpTBXItem;
  begin
    // primer nivel
    num := item.Count - 1;
    for i := 0 to num do begin
      subItem := TSpTBXItem(item.Items[i]);
      if subItem is TMenuCountItem then
        AddItem(TMenuCountItem(subItem));
    end;
    // subniveles
    for i := 0 to num do begin
      subItem := TSpTBXItem(item.Items[i]);
      if subItem.Count > 0 then
        RefrescarSubMenu(subItem);
    end;
  end;

begin
  SetLength(OIDConsultaMenus, 0);
  iList := 0;
  num := MenuConsultas.Count - 1;
  for i := 2 to num do begin
    subItem := TSpTBXItem(MenuConsultas.Items[i]);
    if subItem is TMenuCountItem then begin
      AddItem(TMenuCountItem(subItem));
    end;
  end;
  // subniveles
  for i := 2 to num do begin
    subItem := TSpTBXItem(MenuConsultas.Items[i]);
    if subItem.Count > 0 then
      RefrescarSubMenu(subItem);
  end;
end;

procedure TAccionesConsultas.UpdateMenuCount(const menu: TSpTBXItem;
  const num: Integer);
var i: integer;
  sNum, caption: string;
begin
  caption := menu.Caption;
  i := length(caption);
  while (i > 0) and (caption[i] <> '(') do
    Dec(i);
  if i <> 0 then begin
    if num = NUM_DESCONOCIDO then
      sNum := '?'
    else
      sNum := IntToStr(num);
    menu.Caption := Copy(caption, 1, i) + sNum + ')';
    menu.Invalidate;
  end;
end;

initialization
  RegisterAccionesAfter(TAccionesConsultas, TAccionesGrafico);

end.
