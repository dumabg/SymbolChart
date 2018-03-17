unit GraficoDataHintLayer;

interface

uses GR32_Layers, GraficoPositionLayer, Grafico, JvBalloonHint, Classes;

type
  TGraficoDataHintLayer = class(TGraficoDatosLayer)
  private
    PositionLayer: TGraficoPositionLayer;
    MousePosition: array of integer;
    Hint: TJvBalloonHint;
    procedure CreateMouseMap(const fromPos, toPos: integer);
  protected
    function GetDataHintPosition(X, Y: integer): integer;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure RecalculateTransformados(const fromPos, toPos: integer); override;
    function GetHint(const position: integer): string;
    function DoHitTest(X, Y: Integer): Boolean; override;
  public
    constructor Create(const Grafico: TGrafico; const PositionLayer: TGraficoPositionLayer); reintroduce;
    destructor Destroy; override;
    procedure CancelHint;
  end;

implementation

uses SysUtils, GR32, Controls, Types, GraficoZoom, Tipos, DatosGrafico;

{ TGraficoDataHintLayer }

procedure TGraficoDataHintLayer.CancelHint;
begin
  Hint.CancelHint;
end;

constructor TGraficoDataHintLayer.Create(const Grafico: TGrafico; const PositionLayer: TGraficoPositionLayer);
var zoom: TZoom;
begin
  inherited Create(Grafico);
  Hint := TJvBalloonHint.Create(nil);
  Hint.CustomAnimationStyle := atNone;
  Self.PositionLayer := PositionLayer;
  if Grafico is TZoomGrafico then begin
    zoom := TZoomGrafico(Grafico).ZoomInterval;
    RecalculateTransformados(zoom.ZoomFrom, zoom.ZoomTo);
  end
  else
    RecalculateTransformados(0, Datos.DataCount - 1);
end;

procedure TGraficoDataHintLayer.CreateMouseMap(const fromPos, toPos: integer);
var i, x, y, xTrans, yTrans: integer;
  iMouse, tamano: LongWord;
begin
  tamano := Grafico.Width * Grafico.Height - Grafico.Padding.Left -
    Grafico.Padding.Top - Grafico.Padding.Bottom - Grafico.Padding.Right;
  SetLength(MousePosition, tamano);
  FillChar(MousePosition[Low(MousePosition)], length(MousePosition) * sizeof(integer), -1);
  for i := fromPos to toPos do begin
    for y := -1 to 1 do begin
      for x := -1 to 1 do begin
        if Datos.IsCambio[i] then begin
          xTrans := Datos.XTransformados[i];
          if xTrans <> SIN_CAMBIO_TRANSFORMADO then begin
            yTrans := Datos.YTransformados[i];
            if yTrans <> SIN_CAMBIO_TRANSFORMADO then begin
              iMouse := (yTrans + y) * Grafico.Width + xTrans + x;
              if (iMouse > 0) and (iMouse < tamano) then
                MousePosition[iMouse] := i;
            end;
          end;
        end;
      end;
    end;
  end;
end;

destructor TGraficoDataHintLayer.Destroy;
begin
  Hint.Free;
  inherited Destroy;
end;

function TGraficoDataHintLayer.DoHitTest(X, Y: Integer): Boolean;
begin
  result := true; //GetDataHintPosition(X, Y) <> -1;
end;

function TGraficoDataHintLayer.GetHint(const position: integer): string;
var actual, percent, from, incremento: currency;
  actualPosition: integer;
  fechaActual, fecha: TDate;
  sIncremento: string;
begin
  actualPosition := PositionLayer.Position;
  actual := Datos.Cambio[actualPosition];
  from := Datos.Cambio[position];
  fechaActual := Datos.Fechas[actualPosition];
  fecha := Datos.Fechas[position];
  if fechaActual > fecha then begin
    incremento := actual - from;
    percent := incremento / from * 100;
  end
  else begin
    incremento := from - actual;
    percent := incremento / actual * 100;
  end;
  sIncremento := CurrToStrF(incremento, ffCurrency, 2);
  if incremento > 0 then
    sIncremento := '+' + sIncremento;
  result := CurrToStr(from) + #13 + #13 +
    DateToStr(fechaActual) + #13 + CurrToStr(actual) + #13 + #13 +
    sIncremento + '   ' + CurrToStrF(percent, ffCurrency, 2) + '%';
end;

function TGraficoDataHintLayer.GetDataHintPosition(X, Y: integer): integer;
var index: integer;
begin
  index := Y * Grafico.Width + X;
  if (index >= 0) and (index < length(MousePosition)) then
    result := MousePosition[index]
  else
    result := -1;
end;

procedure TGraficoDataHintLayer.MouseMove(Shift: TShiftState; X, Y: Integer);
var pt: TPoint;
  position: integer;
begin
  inherited MouseMove(Shift, X, Y);
  position := GetDataHintPosition(X, Y);
  if position <> -1 then begin
    if (not Hint.Active) or (Hint.Tag <> position) then begin
      pt := Grafico.ClientToScreen(Point(Datos.XTransformados[position], Datos.YTransformados[position]));
      Hint.Tag := position;
      Hint.ActivateHintPos(nil, pt, DateToStr(Datos.Fechas[position]), GetHint(position),
        -1, ikNone);
    end;
  end;
end;

procedure TGraficoDataHintLayer.RecalculateTransformados(const fromPos,
  toPos: integer);
begin
  Hint.CancelHint;
  CreateMouseMap(fromPos, toPos);
end;

end.
