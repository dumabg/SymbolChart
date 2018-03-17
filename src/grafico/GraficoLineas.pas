unit GraficoLineas;

interface

uses GraficoZoom, GR32, Graphics, Classes, LinePainter;

type
  TGraficoLineas = class(TZoomGrafico)
  private
    LinePainter: TLinePainter;
    function GetColorLine: TColor;
    procedure SetColorLine(const Value: TColor);
  protected
    procedure PaintZoomGrafico(const iFrom, iTo: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ChangeColors;
    property ColorLine: TColor read GetColorLine write SetColorLine default clGreen;
  end;


implementation

uses Tipos;

{ TGraficoLineas }

procedure TGraficoLineas.ChangeColors;
begin
  InvalidateGrafico;
end;

constructor TGraficoLineas.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LinePainter := TLinePainter.Create;
  LinePainter.Datos := Datos;
  LinePainter.Color := clGreen32;
end;

destructor TGraficoLineas.Destroy;
begin
  LinePainter.Free;
  inherited;
end;

function TGraficoLineas.GetColorLine: TColor;
begin
  result := WinColor(LinePainter.Color);
end;

procedure TGraficoLineas.PaintZoomGrafico(const iFrom, iTo: integer);
begin
  LinePainter.Paint(Bitmap, iFrom, iTo);
end;

procedure TGraficoLineas.SetColorLine(const Value: TColor);
begin
  LinePainter.Color := Color32(Value);
  InvalidateGrafico;
end;



end.

