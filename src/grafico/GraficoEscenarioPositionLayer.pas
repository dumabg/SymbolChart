unit GraficoEscenarioPositionLayer;

interface

uses GraficoPositionLayer, Classes;

type
  TOnEscenarioPositionChange = procedure (position: integer) of object;

  TEscenarioGraficoPositionLayer = class(TDefaultGraficoPositionLayer)
  private
  protected
    procedure PositionChange; override;
    procedure DoKeyUp(var Key: Word;  Shift: TShiftState); override;
  public
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure ChangeEscenarioPosition(position: integer);
    class var OnEscenarioPositionChange: TOnEscenarioPositionChange;
    class var EscenarioGraficoPositionLayer: TEscenarioGraficoPositionLayer;
  end;


implementation

uses GraficoEscenario, Windows;

{ TEscenarioGraficoPositionLayer }

procedure TEscenarioGraficoPositionLayer.AfterConstruction;
begin
  inherited;
  EscenarioGraficoPositionLayer := Self;
end;

procedure TEscenarioGraficoPositionLayer.ChangeEscenarioPosition(
  position: integer);
begin
  Self.Position := TDatosGraficoEscenario(Grafico.Datos).UltimoIData + 1 + position;
end;

destructor TEscenarioGraficoPositionLayer.Destroy;
begin
  EscenarioGraficoPositionLayer := nil;
  inherited;
end;

procedure TEscenarioGraficoPositionLayer.DoKeyUp(var Key: Word;
  Shift: TShiftState);
var ultimoIData: integer;
begin
  case Key of
    VK_END: begin
      if TGraficoEscenario(Grafico).HayEscenario then begin
        ultimoIData := TDatosGraficoEscenario(Grafico.Datos).UltimoIData;
        if Position >= ultimoIData then
          inherited
        else begin
          Position := ultimoIData;
          Key := 0;
        end;
      end
      else
        inherited;
    end;
    VK_HOME: begin
      ultimoIData := TDatosGraficoEscenario(Grafico.Datos).UltimoIData;
      if Position > ultimoIData then begin
        Position := ultimoIData;
        Key := 0;
      end
      else
        inherited;
    end
    else
     inherited;
  end;
end;

procedure TEscenarioGraficoPositionLayer.PositionChange;
var ultimoIData: integer;
begin
  ultimoIData := TDatosGraficoEscenario(Grafico.Datos).UltimoIData;
  if Position <= ultimoIData then
    inherited
  else begin
    if Assigned(OnEscenarioPositionChange) then
      OnEscenarioPositionChange(Position - ultimoIData - 1);
  end;
end;

end.
