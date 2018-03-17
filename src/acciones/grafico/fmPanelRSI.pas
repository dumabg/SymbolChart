unit fmPanelRSI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmPanelGrafico, ImgList, TB2Item, SpTBXItem, Menus, dmPanelRSI,
  IncrustedDatosLineLayer, ExtCtrls, GraficoZoom;

type
  TfPanelRSI = class(TfrPanelGrafico)
  private
    RSI140IncrustedLayer: TIncrustedDatosLineLayer;
    PanelRSI: TPanelRSI;
    Niveles: array of currency;
  protected
    procedure OnColorChanged; override;  
    procedure OnAfterSetData; override;
    procedure SetNuevoGraficoPrincipal(const GraficoPrincipal: TZoomGrafico); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses GR32;

{ TfPanelRSI }

constructor TfPanelRSI.Create(AOwner: TComponent);
begin
  inherited;
  PanelRSI := TPanelRSI.Create(Self);
  PanelRSI.GraficoPrincipal := GraficoPrincipal;
  PanelRSI.Grafico := Grafico;
  RSI140IncrustedLayer := TIncrustedDatosLineLayer.Create(Grafico, false);
  RSI140IncrustedLayer.Color := Color32(GraficoBolsa.ColorLines);
  RSI140IncrustedLayer.SetVisibleWithoutUpdate(True);
  PanelRSI.RSI140IncrustedLayer := RSI140IncrustedLayer;
  Grafico.ShowPositions := true;
  //MUY IMPORTANTE. Si no se hace un SetLength, por ejemplo se declara un array[0..3]
  //y se pasa la @ de ese array, el puntero que se pasa es incorrecto y cualquier
  //acceso da un Access Violation. Con SetLength, funciona perfecto.
  SetLength(Niveles, 3);
  Niveles[0] := 70;
  Niveles[1] := 50;
  Niveles[2] := 30;
  Grafico.FixedYValues := @Niveles;
end;

procedure TfPanelRSI.OnAfterSetData;
begin
  inherited;
  PanelRSI.LaunchQuery;
  PanelRSI.LoadData;
end;

procedure TfPanelRSI.OnColorChanged;
begin
  inherited;
  if RSI140IncrustedLayer <> nil then
    RSI140IncrustedLayer.Color := Color32(GraficoBolsa.ColorLines);
end;

procedure TfPanelRSI.SetNuevoGraficoPrincipal(
  const GraficoPrincipal: TZoomGrafico);
begin
  inherited;
  PanelRSI.GraficoPrincipal := GraficoPrincipal;
  PanelRSI.LoadData;
end;

end.
