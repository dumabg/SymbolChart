unit fmPanelGrafico;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grafico, GraficoLineas, GraficoZoom, ImgList, TB2Item, SpTBXItem,
  Menus, GraficoPositionLayer, ExtCtrls, GraficoBolsa;

type
  TGraficoPanelGrafico = class(TGraficoLineas)
  private
    FGraficoPrincipal: TGrafico;
  protected
    procedure CalculateAnchoEjeY; override;
  public
    constructor Create(AOwner: TComponent; const GraficoPrincipal: TGrafico); reintroduce;
  end;

  TfrPanelGrafico = class(TFrame)
    MenuPanelGrafico: TSpTBXPopupMenu;
    MiCerrar: TSpTBXItem;
    ImageList: TImageList;
    Bevel1: TBevel;
    procedure MiCerrarClick(Sender: TObject);
  private
    ChangingPosition: Boolean;
    procedure RegisterGraficoPrincipal;
    procedure UnregisterGraficoPrincipal;
  protected
    PositionLayer: TGraficoPositionLayer;
    PositionLayerPrincipal: TGraficoPositionLayer;
    Grafico: TGraficoPanelGrafico;
    GraficoBolsa: TGraficoBolsa;
    GraficoPrincipal: TZoomGrafico;
    procedure OnAfterSetData; virtual; abstract;
    procedure OnAfterZoom;
    procedure OnPositionChange; virtual;
    procedure OnPositionChangePrincipal;
    procedure OnTipoGraficoChange;
    procedure OnColorChanged; virtual;
    procedure SetNuevoGraficoPrincipal(const GraficoPrincipal: TZoomGrafico); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
  end;

implementation

uses SCMain, BusCommunication;

{$R *.dfm}


{ TfrPanelGrafico }

procedure TfrPanelGrafico.AfterConstruction;
begin
  inherited;
  OnAfterSetData;
  Grafico.AssignZoom(GraficoPrincipal);
  Grafico.RegisterEvent(MessageGraficoPositionChange, OnPositionChange);
  OnPositionChangePrincipal;
end;

procedure TfrPanelGrafico.OnAfterZoom;
begin
  Grafico.AssignZoom(GraficoPrincipal);
end;

procedure TfrPanelGrafico.OnColorChanged;
begin
  Grafico.ColorBackgroud := GraficoBolsa.ColorBackgroud;
  Grafico.ColorPositions := GraficoBolsa.ColorPositions;
  Grafico.ColorLine := GraficoBolsa.ColorLines;
  positionLayer.ColorPosition := GraficoBolsa.ColorPosition;
end;

procedure TfrPanelGrafico.OnPositionChange;
begin
  if ChangingPosition then
    ChangingPosition := false
  else begin
    ChangingPosition := true;
    PositionLayerPrincipal.Position := PositionLayer.Position;
  end;
end;

procedure TfrPanelGrafico.OnPositionChangePrincipal;
begin
  if ChangingPosition then
    ChangingPosition := false
  else begin
    ChangingPosition := true;
    PositionLayer.Position := PositionLayerPrincipal.Position;
  end;
end;

procedure TfrPanelGrafico.OnTipoGraficoChange;
begin
  PositionLayer.Active := false;
  UnregisterGraficoPrincipal;
  SetNuevoGraficoPrincipal(fSCMain.Grafico.GetGrafico);
  RegisterGraficoPrincipal;
  PositionLayer.Position := PositionLayerPrincipal.Position;
  PositionLayer.Active := true;
end;

procedure TfrPanelGrafico.RegisterGraficoPrincipal;
begin
  GraficoPrincipal.RegisterEvent(MessageGraficoAfterSetData, OnAfterSetData);
  GraficoPrincipal.RegisterEvent(MessageGraficoAfterZoom, OnAfterZoom);
  GraficoPrincipal.RegisterEvent(MessageGraficoAfterScroll, OnAfterZoom);
  GraficoPrincipal.RegisterEvent(MessageGraficoPositionChange, OnPositionChangePrincipal);
end;

procedure TfrPanelGrafico.SetNuevoGraficoPrincipal(const GraficoPrincipal: TZoomGrafico);
begin
  Self.GraficoPrincipal := GraficoPrincipal;
  PositionLayerPrincipal := GraficoPrincipal.GetLayerByType(TGraficoPositionLayer) as TGraficoPositionLayer;
end;

procedure TfrPanelGrafico.UnregisterGraficoPrincipal;
begin
  GraficoPrincipal.UnregisterEvent(MessageGraficoPositionChange, OnPositionChangePrincipal);
  GraficoPrincipal.UnregisterEvent(MessageGraficoAfterSetData, OnAfterSetData);
  GraficoPrincipal.UnregisterEvent(MessageGraficoAfterZoom, OnAfterZoom);
  GraficoPrincipal.UnregisterEvent(MessageGraficoAfterScroll, OnAfterZoom);
end;

constructor TfrPanelGrafico.Create(AOwner: TComponent);
begin
  inherited;
  Parent := fSCMain.PanelGrafico;
  AlignWithMargins := true;
  GraficoBolsa := fSCMain.Grafico;
  PositionLayerPrincipal := GraficoBolsa.GetGraficoPositionLayer;
  GraficoPrincipal := GraficoBolsa.GetGrafico;
  Grafico := TGraficoPanelGrafico.Create(Self, GraficoPrincipal);
  Grafico.Parent := Self;
  Grafico.Align := alClient;
  Grafico.ShowX := false;
  Grafico.Padding := GraficoPrincipal.Padding;
  Grafico.ZoomActive := False;
  PopupMenu := MenuPanelGrafico;
  positionLayer := TGraficoPositionLayer.Create(Grafico);
  positionLayer.Active := true;
  Bus.RegisterEvent(MessageTipoGraficoChange, OnTipoGraficoChange);
  GraficoBolsa.RegisterEvent(MessageColorChanged, OnColorChanged);
  RegisterGraficoPrincipal;
  OnColorChanged;
end;

destructor TfrPanelGrafico.Destroy;
begin
  Bus.UnregisterEvent(MessageTipoGraficoChange, OnTipoGraficoChange);
  Grafico.UnregisterEvent(MessageGraficoPositionChange, OnPositionChange);
  GraficoBolsa.UnregisterEvent(MessageColorChanged, OnColorChanged);
  UnregisterGraficoPrincipal;
  inherited;
end;

procedure TfrPanelGrafico.MiCerrarClick(Sender: TObject);
begin
  Free;
end;

{ TGraficoPanelGrafico }

procedure TGraficoPanelGrafico.CalculateAnchoEjeY;
begin
  // Ni idea de porque sale desplazado. Le sumo 2 para que quede mejor.
  FAnchoEjeY := FGraficoPrincipal.AnchoEjeY;
end;

constructor TGraficoPanelGrafico.Create(AOwner: TComponent;
  const GraficoPrincipal: TGrafico);
begin
  FGraficoPrincipal := GraficoPrincipal;
  inherited Create(AOwner);
end;

end.
