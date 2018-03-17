unit fmPanelRecorrido;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmPanelGrafico, StdCtrls, dmPanelRecorrido, Grafico, ImgList,
  TB2Item, SpTBXItem, Menus, ExtCtrls, GraficoZoom;

type
  TfrPanelRecorrido = class(TfrPanelGrafico)
  private
    Niveles: array of currency;
    PanelRecorrido: TPanelRecorrido;
  protected
    procedure OnAfterSetData; override;
    procedure SetNuevoGraficoPrincipal(const GraficoPrincipal: TZoomGrafico); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;


implementation

{$R *.dfm}

uses DatosGrafico, UtilDB;

{ TfrPanelRecorrido }

constructor TfrPanelRecorrido.Create(AOwner: TComponent);
begin
  inherited;
  PanelRecorrido := TPanelRecorrido.Create(Self);
  PanelRecorrido.GraficoPrincipal := GraficoPrincipal;
  PanelRecorrido.Grafico := Grafico;
  Grafico.ShowPositions := true;
  //MUY IMPORTANTE. Si no se hace un SetLength, por ejemplo se declara un array[0..3]
  //y se pasa la @ de ese array, el puntero que se pasa es incorrecto y cualquier
  //acceso da un Access Violation. Con SetLength, funciona perfecto.
  SetLength(Niveles, 4);
  Niveles[0] := 80;
  Niveles[1] := -80;
  Niveles[2] := 20;
  Niveles[3] := -20;
  Grafico.FixedYValues := @Niveles;
end;

procedure TfrPanelRecorrido.OnAfterSetData;
begin
  inherited;
  PanelRecorrido.LaunchQuery;
  PanelRecorrido.LoadData;
end;

procedure TfrPanelRecorrido.SetNuevoGraficoPrincipal(const GraficoPrincipal: TZoomGrafico);
begin
  inherited;
  PanelRecorrido.GraficoPrincipal := GraficoPrincipal;
  PanelRecorrido.LoadData;  
end;

end.
