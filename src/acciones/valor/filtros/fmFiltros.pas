unit fmFiltros;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, DB, ExtCtrls, Grids, DBGrids, ComCtrls, dmFiltro,
  StdCtrls,  ActnMan, ActnColorMaps, ImgList,
  XPStyleActnCtrls, ActnList, ToolWin, ActnCtrls, dmFiltros, JvExDBGrids,
  JvDBUltimGrid, JvDBGrid;

type
  TfFiltros = class(TfBase)
    listaFiltros: TJvDBUltimGrid;
    PanelIzquierda: TPanel;
    ActionToolBar1: TActionToolBar;
    ActionManager: TActionManager;
    ImageList: TImageList;
    VerSoloTengan: TAction;
    PanelDerecha: TPanel;
    ActionToolBar2: TActionToolBar;
    Ir: TAction;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    GridFiltrosValorFiltros: TJvDBUltimGrid;
    ActionToolBar3: TActionToolBar;
    Panel2: TPanel;
    ActionToolBar4: TActionToolBar;
    IrValorFiltro: TAction;
    GridValoresValorFiltros: TJvDBUltimGrid;
    GridValores: TJvDBUltimGrid;
    procedure listaFiltrosGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure VerSoloTenganExecute(Sender: TObject);
    procedure IrExecute(Sender: TObject);
    procedure GridValoresDblClick(Sender: TObject);
    procedure IrUpdate(Sender: TObject);
    procedure IrValorFiltroExecute(Sender: TObject);
    procedure GridValoresValorFiltrosDblClick(Sender: TObject);
  private
    Filtros: TFiltros;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation


{$R *.dfm}

uses dmData;

constructor TfFiltros.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Filtros := TFiltros.Create(Self);
end;

procedure TfFiltros.listaFiltrosGetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; Highlight: Boolean);
begin
  inherited;
  if Filtros.FiltrosFiltroValoresTIENE_DATOS.Value then begin
    AFont.Color := clBlack;
    if Highlight then
      Background := $00EFD3C6
    else
      Background := clWindow;
  end
  else begin
    AFont.Color := clGray;
    BackGround := clWhite;
  end;
end;


procedure TfFiltros.VerSoloTenganExecute(Sender: TObject);
begin
  inherited;
  VerSoloTengan.Checked := not VerSoloTengan.Checked;
  Filtros.FiltrosFiltroValores.Filtered := VerSoloTengan.Checked;
end;

procedure TfFiltros.IrExecute(Sender: TObject);
var filtro: TFiltro;
begin
  inherited;
  filtro := TFiltro(Filtros.FiltrosFiltroValoresFILTRO.Value);
  Data.IrAValor(filtro.ValoresFiltrados.FieldByName('OR_VALOR').Value);
end;

procedure TfFiltros.GridValoresDblClick(Sender: TObject);
begin
  inherited;
  Ir.Execute;
end;

procedure TfFiltros.IrUpdate(Sender: TObject);
begin
  inherited;
  Ir.Enabled := Filtros.dsValoresFiltroValores.DataSet.RecordCount > 0;
end;

procedure TfFiltros.IrValorFiltroExecute(Sender: TObject);
begin
  inherited;
  data.Valores.Locate('OID_VALOR', Filtros.ValoresValorFiltrosOID_VALOR.Value, []);
end;

procedure TfFiltros.GridValoresValorFiltrosDblClick(Sender: TObject);
begin
  inherited;
  IrValorFiltro.Execute;
end;

end.
