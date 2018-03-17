unit fmPanelRanquing;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmPanelGrafico, ImgList, TB2Item, SpTBXItem, Menus, ExtCtrls,
  dmPanelRanquing, GraficoZoom;

type
  TfrPanelRanquing = class(TfrPanelGrafico)
  private
    PanelRanquing: TPanelRanquing;
  protected
    procedure OnAfterSetData; override;
    procedure SetNuevoGraficoPrincipal(const GraficoPrincipal: TZoomGrafico); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;


implementation

{$R *.dfm}

{ TfrPanelRanquing }

constructor TfrPanelRanquing.Create(AOwner: TComponent);
begin
  inherited;
  PanelRanquing := TPanelRanquing.Create(Self);
  PanelRanquing.GraficoPrincipal := GraficoPrincipal;
  PanelRanquing.Grafico := Grafico;
  Grafico.ShowPositions := true;
end;

procedure TfrPanelRanquing.OnAfterSetData;
begin
  inherited;
  PanelRanquing.LaunchQuery;
  PanelRanquing.LoadData;
end;

procedure TfrPanelRanquing.SetNuevoGraficoPrincipal(
  const GraficoPrincipal: TZoomGrafico);
begin
  inherited;
  PanelRanquing.GraficoPrincipal := GraficoPrincipal;
  PanelRanquing.LoadData;
end;

end.
