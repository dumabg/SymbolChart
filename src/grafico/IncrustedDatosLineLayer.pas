unit IncrustedDatosLineLayer;

interface

uses GraficoZoom, GR32, Contnrs, Grafico, LinePainter;

type
  TIncrustedDatosLineLayer = class(TIncrustedDatosZoomLayer)
  private
    LinePainter: TLinePainter;
    procedure SetColor(const Value: TColor32);
    function GetColor: TColor32;
  protected
    procedure Paint(Buffer: TBitmap32); override;
  public
    constructor Create(const Grafico: TGrafico; const layerBefore: boolean); override;
    destructor Destroy; override;
    property Color: TColor32 read GetColor write SetColor;
  end;


implementation

uses Tipos;

{ TIncrustedDatosLineLayer }

constructor TIncrustedDatosLineLayer.Create(const Grafico: TGrafico; const layerBefore: boolean);
begin
  inherited;
  LinePainter := TLinePainter.Create;
  LinePainter.Datos := DatosLayer;
end;

destructor TIncrustedDatosLineLayer.Destroy;
begin
  LinePainter.Free;
  inherited;
end;

function TIncrustedDatosLineLayer.GetColor: TColor32;
begin
  Result := LinePainter.Color;
end;

procedure TIncrustedDatosLineLayer.Paint(Buffer: TBitmap32);
var iDesde, iHasta: integer;
begin
  if Grafico is TZoomGrafico then begin
    with TZoomGrafico(Grafico).ZoomInterval do begin
      iDesde := ZoomFrom;
      iHasta := ZoomTo;
    end;
  end
  else begin
    iDesde := 0;
    iHasta := DatosLayer.DataCount - 1;
  end;
  LinePainter.Paint(Buffer, iDesde, iHasta);
end;

procedure TIncrustedDatosLineLayer.SetColor(const Value: TColor32);
begin
  LinePainter.Color := Value;
  if PDatosLayer <> nil then
    Update;
end;

end.
