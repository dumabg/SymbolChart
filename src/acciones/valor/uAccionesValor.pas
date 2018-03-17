unit uAccionesValor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uAcciones, ActnList, ImgList, DBActns, dmAccionesValor, TB2Item,
  SpTBXItem, TB2Dock, TB2Toolbar;

type
  TAccionesValor = class(TAcciones)
    TBXItem24: TSpTBXItem;
    TBXItem23: TSpTBXItem;
    TBXItem27: TSpTBXItem;
    TBXItem28: TSpTBXItem;
    GruposMenuItem: TSpTBXSubmenuItem;
    TBXSeparatorItem7: TSpTBXSeparatorItem;
    TBXItem3: TSpTBXItem;
    TBXSeparatorItem18: TSpTBXSeparatorItem;
    TBXItem29: TSpTBXItem;
    TBXSubmenuItem1: TSpTBXSubmenuItem;
    TBXItem2: TSpTBXItem;
    TBXItem4: TSpTBXItem;
    TBXItem5: TSpTBXItem;
    TBXItem6: TSpTBXItem;
    MenuCartera: TSpTBXSubmenuItem;
    MenuCarteraAbiertas: TSpTBXSubmenuItem;
    MenuCarteraPendientes: TSpTBXSubmenuItem;
    TBXSeparatorItem36: TSpTBXSeparatorItem;
    MenuMisGrupos: TSpTBXSubmenuItem;
    TBXItem30: TSpTBXItem;
    TBXSeparatorItem5: TSpTBXSeparatorItem;
    TBXItem21: TSpTBXItem;
    TBXSeparatorItem37: TSpTBXSeparatorItem;
    mDivisas: TSpTBXItem;
    mFuturos: TSpTBXItem;
    mIndices: TSpTBXSubmenuItem;
    TBXItem94: TSpTBXItem;
    TBXItem91: TSpTBXItem;
    TBXItem92: TSpTBXItem;
    TBXItem93: TSpTBXItem;
    mMateriasPrimas: TSpTBXItem;
    TBXSeparatorItem27: TSpTBXSeparatorItem;
    TBXItem119: TSpTBXItem;
    TBXSubmenuItem2: TSpTBXSubmenuItem;
    ValorSiguiente: TDataSetNext;
    ValorAnterior: TAction;
    BuscarValor: TAction;
    VisualizarGrupo: TAction;
    MapaValores: TAction;
    Filtros: TAction;
    MensajeComentario: TAction;
    ActionMisGrupos: TAction;
    MercadoIndicesAmerica: TAction;
    MercadoIndicesEuropa: TAction;
    MercadoIndicesAsia: TAction;
    MercadoIndicesTodos: TAction;
    MercadoForex: TAction;
    MercadoMateriasPrimas: TAction;
    ActionCartera: TAction;
    MercadoTodosPaises: TAction;
    siDiarioSemanal: TSpTBXSubmenuItem;
    SpTBXItem1: TSpTBXItem;
    SpTBXItem2: TSpTBXItem;
    Diario: TAction;
    Semanal: TAction;
    AnadirFavorito: TAction;
    SpTBXItem3: TSpTBXItem;
    MercadoETFUSA: TAction;
    mETF: TSpTBXSubmenuItem;
    SpTBXItem4: TSpTBXItem;
    SpTBXItem5: TSpTBXItem;
    MercadoETFEuropa: TAction;
    MercadoBitcoin: TAction;
    mBitcoin: TSpTBXItem;
    procedure ValorSiguienteExecute(Sender: TObject);
    procedure ValorAnteriorExecute(Sender: TObject);
    procedure BuscarValorExecute(Sender: TObject);
    procedure VisualizarGrupoExecute(Sender: TObject);
    procedure MapaValoresExecute(Sender: TObject);
    procedure MensajeComentarioExecute(Sender: TObject);
    procedure MensajeComentarioUpdate(Sender: TObject);
    procedure ModificarGruposExecute(Sender: TObject);
    procedure ActionMisGruposExecute(Sender: TObject);
    procedure MercadoIndicesAmericaExecute(Sender: TObject);
    procedure MercadoIndicesEuropaExecute(Sender: TObject);
    procedure MercadoIndicesAsiaExecute(Sender: TObject);
    procedure MercadoIndicesTodosExecute(Sender: TObject);
    procedure MercadoFuturosExecute(Sender: TObject);
    procedure MercadoForexExecute(Sender: TObject);
    procedure MercadoMateriasPrimasExecute(Sender: TObject);
    procedure ActionCarteraExecute(Sender: TObject);
    procedure MercadoTodosPaisesExecute(Sender: TObject);
    procedure GruposTodosExecute(Sender: TObject);
    procedure DiarioExecute(Sender: TObject);
    procedure SemanalExecute(Sender: TObject);
    procedure ValorSiguienteUpdate(Sender: TObject);
    procedure FiltrosExecute(Sender: TObject);
    procedure AnadirFavoritoExecute(Sender: TObject);
    procedure AnadirFavoritoUpdate(Sender: TObject);
    procedure MercadoETFUSAExecute(Sender: TObject);
    procedure MercadoETFEuropaExecute(Sender: TObject);
    procedure MercadoBitcoinExecute(Sender: TObject);
  private
    FDataAccionesValor: TDataAccionesValor;
    procedure ActivarMercadoClick(Sender: TObject);
    procedure ActivarIndiceClick(Sender: TObject);
    procedure ActivarGrupoClick(Sender: TObject);
    procedure ActivarCarteraClick(Sender: TObject);
    procedure ActivarPaisClick(Sender: TObject);
    procedure OnMercadoGrupoCambiado;
    procedure CreateGruposCartera;
    procedure CrearMenuMercados;
    procedure FormBuscarValor(const charInicial: Char);
  public
    constructor Create(AOwner: TComponent); override;
    function GetBarras: TBarras; override;
    procedure CreateMisGrupos;    
    procedure DoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState); override;
    property MenuGrupos: TSpTBXSubmenuItem read GruposMenuItem;
    property DataAccionesValor: TDataAccionesValor read FDataAccionesValor;
  end;


implementation

uses fmBuscarValor, UtilForms, fmMapaValores, UtilDock, fmComentario,
  UtilDB, BusCommunication, dmDataComun, fmGrupos, dmData, Valores,
  fmFiltros, SCMain, uPanelFavoritos, ConstantsDatosBD, Contnrs;

resourcestring
  TITULO_DIARIO = 'Diario';
  TITULO_SEMANAL = 'Semanal';

{$R *.dfm}

procedure TAccionesValor.ActionCarteraExecute(Sender: TObject);
begin
  // No borrar, sino el menu Cartera de Grupos se pondrá en gris
end;

procedure TAccionesValor.ActionMisGruposExecute(Sender: TObject);
begin
  //No borrar, sino el menú se pondrá en gris al no haber execute en la action
end;

procedure TAccionesValor.ActivarCarteraClick(Sender: TObject);
var oid: integer;
  menuItem: TSpTBXItem;
begin
  inherited;
  menuItem := Sender as TSpTBXItem;
  oid := integer(menuItem.Tag);
  DataAccionesValor.ActivarCartera(oid, menuItem.Parent = MenuCarteraPendientes);
end;

procedure TAccionesValor.ActivarGrupoClick(Sender: TObject);
var oid: integer;
  menuItem: TSpTBXItem;
begin
  inherited;
  menuItem := Sender as TSpTBXItem;
  oid := integer(menuItem.Tag);
  DataAccionesValor.ActivarGrupo(oid);
end;

procedure TAccionesValor.ActivarIndiceClick(Sender: TObject);
var oid: integer;
  menuItem: TSpTBXItem;
begin
  inherited;
  menuItem := Sender as TSpTBXItem;
  oid := integer(menuItem.Tag);
  DataAccionesValor.ActivarIndice(oid);
end;

procedure TAccionesValor.ActivarMercadoClick(Sender: TObject);
var oid: integer;
  menuItem: TSpTBXItem;
begin
  inherited;
  menuItem := Sender as TSpTBXItem;
  oid := integer(menuItem.Tag);
  DataAccionesValor.ActivarMercado(oid);
end;

procedure TAccionesValor.ActivarPaisClick(Sender: TObject);
var oid: integer;
  menuItem: TSpTBXItem;
begin
  inherited;
  menuItem := Sender as TSpTBXItem;
  oid := integer(menuItem.Tag);
  DataAccionesValor.ActivarPais(DataComun.FindMercado(oid)^.Pais);
end;

procedure TAccionesValor.AnadirFavoritoExecute(Sender: TObject);
begin
  inherited;
  TfrPanelFavoritos(fSCMain.AccionesVer.GetPanel(TfrPanelFavoritos)).AnadirFavoritos.Execute;
end;

procedure TAccionesValor.AnadirFavoritoUpdate(Sender: TObject);
var favoritoPanel: TfrPanelFavoritos;
begin
  inherited;
  favoritoPanel := TfrPanelFavoritos(fSCMain.AccionesVer.GetPanel(TfrPanelFavoritos));
  AnadirFavorito.Enabled := (favoritoPanel <> nil) and (favoritoPanel.AnadirFavoritos.Enabled);
end;

procedure TAccionesValor.BuscarValorExecute(Sender: TObject);
begin
  FormBuscarValor(#0);
end;

procedure TAccionesValor.CrearMenuMercados;
var i: integer;
  mercados: PDataComunMercados;
  menusAnadidos: TStringList;

    function CreaSubMenuIndices(OIDMercado: integer): TSpTBXItem;
    var childMenu: TSpTBXItem;
      inspectIndices: TInspectDataSet;
    begin
      result := nil;
      inspectIndices := StartInspectDataSet(DataAccionesValor.Indices);
      try
        if DataAccionesValor.Indices.RecordCount > 0 then begin
          DataAccionesValor.Indices.First;
          while not DataAccionesValor.Indices.Eof do begin
            if (DataAccionesValor.IndicesOR_MERCADO.Value = OIDMercado) and
              (DataAccionesValor.IndicesNUM_VALORES.Value > 0) then begin
              if result = nil then begin
                result := TSpTBXSubmenuItem.Create(Self);
                childMenu := TSpTBXItem.Create(Self);
                childMenu.Tag := OIDMercado;
                childMenu.OnClick := ActivarMercadoClick;
                childMenu.Caption := 'Todos';
                result.Add(childMenu);
              end;

              childMenu := TSpTBXItem.Create(Self);
              childMenu.OnClick := ActivarIndiceClick;
              childMenu.Caption := StringReplace(DataAccionesValor.IndicesNOMBRE.Value, '&', '&&', [rfReplaceAll]);
              childMenu.Tag := DataAccionesValor.IndicesOID_INDICE.Value;
              result.Add(childMenu);
            end;
            DataAccionesValor.Indices.Next;
          end;
        end;
      finally
        EndInspectDataSet(inspectIndices);
      end;
      if result = nil then begin
        result := TSpTBXItem.Create(Self);
        result.Tag := OIDMercado;
        result.OnClick := ActivarMercadoClick;
      end;
    end;

    procedure CreaMenuMercado(mercado: PDataComunMercado);
    var newMenu, menu, subMenu, menuTodos: TSpTBXItem;
      iBandera, i, num: integer;
    begin
      num := menusAnadidos.Count - 1;
      menu := nil;
      for i := 0 to num do begin
        if menusAnadidos[i] = mercado^.Pais then begin
          menu := TSpTBXItem(menusAnadidos.Objects[i]);
          Break;
        end;
      end;
      if menu = nil then begin
        menu := CreaSubMenuIndices(mercado^.OIDMercado);
        menu.Caption := mercado^.Pais;
        iBandera := mercado^.BanderaImageIndex;
        if iBandera <> -1 then begin
          menu.ImageIndex := iBandera;
          menu.Images := DataComun.ImageListBanderas;
        end;
        GruposMenuItem.Add(menu);
        menusAnadidos.AddObject(mercado^.Pais, menu);
      end
      else begin
        if menu is TSpTBXSubmenuItem then begin
          subMenu := CreaSubMenuIndices(mercado^.OIDMercado);
          subMenu.Caption := mercado^.Nombre;
          menu.Add(subMenu);
        end
        else begin
          GruposMenuItem.Remove(menu);
          menusAnadidos.Delete(i);
          subMenu := CreaSubMenuIndices(mercado^.OIDMercado);
          subMenu.Caption := mercado^.Nombre;
          newMenu := TSpTBXSubmenuItem.Create(Self);
          newMenu.Caption := mercado^.Pais;
          menu.ImageIndex := -1;
          menu.Caption := DataComun.FindMercado(menu.Tag)^.Nombre;
          menuTodos := TSpTBXItem.Create(Self);
          menuTodos.Tag := mercado^.OIDMercado;
          menuTodos.OnClick := ActivarPaisClick;
          menuTodos.Caption := 'Todos';
          newMenu.Add(menuTodos);
          newMenu.Add(menu);
          newMenu.Add(subMenu);
          iBandera := mercado^.BanderaImageIndex;
          if iBandera <> -1 then begin
            newMenu.ImageIndex := iBandera;
            newMenu.Images := DataComun.ImageListBanderas;
          end;
          GruposMenuItem.Add(newMenu);
          menusAnadidos.AddObject(mercado^.Pais, newMenu);
        end;
      end;
    end;

begin
  menusAnadidos := TStringList.Create;
  try
    mercados := DataComun.Mercados;
    for i := Low(mercados^) to High(mercados^) do begin
      if mercados^[i].Nombre <> mercados^[i].Pais then
        CreaMenuMercado(@DataComun.Mercados^[i]);
    end;
  finally
    menusAnadidos.Free;
  end;
end;

constructor TAccionesValor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataAccionesValor := TDataAccionesValor.Create(Self);
  mDivisas.Images := DataComun.ImageListBanderas;
  mDivisas.ImageIndex := DataComun.FindMercado(Mercado_Const.OID_Forex)^.BanderaImageIndex;
  mFuturos.Images := DataComun.ImageListBanderas;
  mFuturos.ImageIndex := DataComun.FindMercado(Mercado_Const.OID_Futuros)^.BanderaImageIndex;
  mIndices.Images := DataComun.ImageListBanderas;
  mIndices.ImageIndex := DataComun.FindMercado(Mercado_Const.OID_IndicesAmerica)^.BanderaImageIndex;
  mMateriasPrimas.Images := DataComun.ImageListBanderas;
  mMateriasPrimas.ImageIndex := DataComun.FindMercado(Mercado_Const.OID_MateriasPrimas)^.BanderaImageIndex;
  mETF.Images := DataComun.ImageListBanderas;
  mETF.ImageIndex := DataComun.FindMercado(Mercado_Const.OID_ETF_USA)^.BanderaImageIndex;
  mBitcoin.Images := DataComun.ImageListBanderas;
  mBitcoin.ImageIndex := DataComun.FindMercado(Mercado_Const.OID_Bitcoin)^.BanderaImageIndex;
  CrearMenuMercados;
  CreateMisGrupos;
  CreateGruposCartera;
  OnMercadoGrupoCambiado;
  Bus.RegisterEvent(MessageMercadoGrupoCambiado, OnMercadoGrupoCambiado);
end;

procedure TAccionesValor.CreateGruposCartera;
var inspect: TInspectDataSet;

    procedure CreaMenuCartera(const nombre: string; const OID: integer);
    var menu: TSpTBXItem;
    begin
      menu := TSpTBXItem.Create(Self);
      menu.Tag := OID;
      menu.Caption := nombre;
      menu.OnClick := ActivarCarteraClick;
      MenuCarteraPendientes.Add(menu);
      // No se puede añadir un mismo item a varios items, por lo que se ha
      // de cerar uno nuevo igual
      menu := TSpTBXItem.Create(Self);
      menu.Tag := OID;
      menu.Caption := nombre;
      menu.OnClick := ActivarCarteraClick;
      MenuCarteraAbiertas.Add(menu);
    end;

begin
  inspect := StartInspectDataSet(DataAccionesValor.Carteras);
  try
    while MenuCarteraPendientes.Count > 0 do
      MenuCarteraPendientes.Items[0].Free;

    DataAccionesValor.Carteras.First;
    while not DataAccionesValor.Carteras.Eof do begin
      CreaMenuCartera(DataAccionesValor.CarterasNOMBRE.Value, DataAccionesValor.CarterasOID_CARTERA.AsInteger);
      DataAccionesValor.Carteras.Next;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;

procedure TAccionesValor.CreateMisGrupos;
var inspect: TInspectDataSet;

    procedure CreaMenuGrupo(const nombre: string; const OID: integer);
    var menu: TSpTBXItem;
    begin
      menu := TSpTBXItem.Create(Self);
      menu.Tag := OID;
      menu.Caption := nombre;
      menu.OnClick := ActivarGrupoClick;
      MenuMisGrupos.Add(menu);
    end;

begin
  inspect := StartInspectDataSet(DataAccionesValor.Grupos);
  try
    while MenuMisGrupos.Count > 0 do
      MenuMisGrupos.Items[0].Free;

    DataAccionesValor.Grupos.First;
    while not DataAccionesValor.Grupos.Eof do begin
      CreaMenuGrupo(DataAccionesValor.GruposNOMBRE.Value, DataAccionesValor.GruposOID_GRUPO.AsInteger);
      DataAccionesValor.Grupos.Next;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;

procedure TAccionesValor.DiarioExecute(Sender: TObject);
begin
  inherited;
  siDiarioSemanal.Caption := TITULO_DIARIO;
  Data.TipoCotizacion := tcDiaria;
end;

procedure TAccionesValor.DoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Shift = [] then begin
    if (Key >= Ord('A')) and (Key <=Ord('Z')) then begin
      FormBuscarValor(Char(Key));
      Key := 0;
    end
    else begin
      if Key = VK_ADD then
        TfrPanelFavoritos(fSCMain.AccionesVer.GetPanel(TfrPanelFavoritos)).Anadir;
    end;
  end;
end;

procedure TAccionesValor.FiltrosExecute(Sender: TObject);
begin
  inherited;
  ShowFormModal(TfFiltros);
end;

procedure TAccionesValor.FormBuscarValor(const charInicial: Char);
var f: TfBuscarValor;
begin
  f := TfBuscarValor(ShowForm(TfBuscarValor, Self));
  f.Show;
  if charInicial <> #0 then
    f.AddChar(charInicial);
end;

function TAccionesValor.GetBarras: TBarras;
begin
  result := inherited GetBarras;
  result[0].Dock.Position := dpArribaBotones;
end;

procedure TAccionesValor.GruposTodosExecute(Sender: TObject);
begin
  DataAccionesValor.ActivarTodos;
end;

procedure TAccionesValor.MapaValoresExecute(Sender: TObject);
var mapaValores: TfMapaValores;
begin
  mapaValores := TfMapaValores.Create(nil);
  try
    try
      Screen.Cursor := crHourGlass;
      mapaValores.sesion := Data.CotizacionOR_SESION.Value;
    finally
      Screen.Cursor := crDefault;
    end;
    mapaValores.ShowModal;
  finally
    mapaValores.Free;
  end;
end;

procedure TAccionesValor.MensajeComentarioExecute(Sender: TObject);
var fComentario: TfComentario;
begin
  fComentario := TfComentario.Create(nil);
  try
    fComentario.Caption := fComentario.Caption + ' - ' + Data.ValoresSIMBOLO.Value +
      ' - ' + Data.ValoresNOMBRE.Value;
    fComentario.ShowModal;
  finally
    fComentario.Free;
  end;
end;

procedure TAccionesValor.MensajeComentarioUpdate(Sender: TObject);
begin
  MensajeComentario.Enabled :=
    (Data.CotizacionCIERRE.Value <> 0) and
    (not Data.CotizacionEstadoOR_COTIZACION.IsNull);
end;

procedure TAccionesValor.MercadoForexExecute(Sender: TObject);
begin
  DataAccionesValor.ActivarMercado(Mercado_Const.OID_Forex);
end;

procedure TAccionesValor.MercadoBitcoinExecute(Sender: TObject);
begin
  inherited;
    DataAccionesValor.ActivarMercado(Mercado_Const.OID_Bitcoin);
end;

procedure TAccionesValor.MercadoETFEuropaExecute(Sender: TObject);
begin
  inherited;
  DataAccionesValor.ActivarMercado(Mercado_Const.OID_ETF_Europa);
end;

procedure TAccionesValor.MercadoETFUSAExecute(Sender: TObject);
begin
  inherited;
  DataAccionesValor.ActivarMercado(Mercado_Const.OID_ETF_USA);
end;

procedure TAccionesValor.MercadoFuturosExecute(Sender: TObject);
begin
  DataAccionesValor.ActivarMercado(Mercado_Const.OID_Futuros);
end;

procedure TAccionesValor.MercadoIndicesAmericaExecute(Sender: TObject);
begin
  DataAccionesValor.ActivarMercadoIndices(miAmerica);
end;

procedure TAccionesValor.MercadoIndicesAsiaExecute(Sender: TObject);
begin
  inherited;
  DataAccionesValor.ActivarMercadoIndices(miAsia);
end;

procedure TAccionesValor.MercadoIndicesEuropaExecute(Sender: TObject);
begin
  inherited;
  DataAccionesValor.ActivarMercadoIndices(miEuropa);
end;

procedure TAccionesValor.MercadoIndicesTodosExecute(Sender: TObject);
begin
  inherited;
  DataAccionesValor.ActivarMercadoIndices(miTodos);
end;

procedure TAccionesValor.MercadoMateriasPrimasExecute(Sender: TObject);
begin
  DataAccionesValor.ActivarMercado(Mercado_Const.OID_MateriasPrimas);
end;

procedure TAccionesValor.MercadoTodosPaisesExecute(Sender: TObject);
begin
  DataAccionesValor.ActivarTodosPaises;
end;

procedure TAccionesValor.ModificarGruposExecute(Sender: TObject);
var fGrupos: TfGrupos;
begin
  fGrupos := TfGrupos.Create(nil, DataAccionesValor);
  try
    fGrupos.ShowModal;
    CreateMisGrupos;
  finally
    fGrupos.Free;
  end;
end;

procedure TAccionesValor.OnMercadoGrupoCambiado;
begin
  VisualizarGrupo.Caption := DataAccionesValor.NombreAgrupacionValores;
end;

procedure TAccionesValor.SemanalExecute(Sender: TObject);
begin
  inherited;
  siDiarioSemanal.Caption := TITULO_SEMANAL;
  Data.TipoCotizacion := tcSemanal;
end;

procedure TAccionesValor.ValorAnteriorExecute(Sender: TObject);
begin
  Data.ValorAnterior;
  ValorAnterior.Enabled := Data.hayValorAnterior;
end;

procedure TAccionesValor.ValorSiguienteExecute(Sender: TObject);
begin
  inherited;
  Data.ValorSiguiente;
end;

procedure TAccionesValor.ValorSiguienteUpdate(Sender: TObject);
begin
  inherited;
  ValorSiguiente.Enabled := Data.hayValorPosterior;
end;

procedure TAccionesValor.VisualizarGrupoExecute(Sender: TObject);
begin
//  Necesario para que la opción no esté deshabilitada
end;

initialization
  RegisterAccionesAfter(TAccionesValor, nil);

end.
