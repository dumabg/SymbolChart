unit GraficoVelas;

interface

uses GraficoZoom, GR32, Graphics, Classes, Tipos, DatosGrafico;

type
  TGraficoVelas = class(TZoomGrafico)
  private
    FColorAlcista: TColor32;
    FColorBajista: TColor32;
    function GetColorAlcista: TColor;
    function GetColorBajista: TColor;
    procedure SetColorAlcista(const Value: TColor);
    procedure SetColorBajista(const Value: TColor);
  protected
    procedure PaintZoomGrafico(const iFrom, iTo: integer); override;
    function CreateDatosGrafico: TDatosGrafico; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetData(const PCambios, PCambiosMaximo, PCambiosMinimo: PArrayCurrency;
      const PFechas: PArrayDate); reintroduce;
    property ColorAlcista: TColor read GetColorAlcista write SetColorAlcista default clGreen;
    property ColorBajista: TColor read GetColorBajista write SetColorBajista default clRed;
  end;

  TDatosGraficoVelas = class(TDatosGrafico)
  private
    FPCambiosMaximo, FPCambiosMinimo: PArrayCurrency;
    YMaxTransformados, YMinTransformados: TArrayInteger;
    function GetCambioMaximo(index: integer): currency;
    function GetCambioMinimo(index: integer): currency;
  protected
    procedure RecalculateMaxMin(const fromPos, toPos: integer); override;
  public
    procedure SetDataMaximoMinimo(const PCambiosMaximo, PCambiosMinimo: PArrayCurrency);
    procedure RecalculateTransformados(const fromPos, toPos: integer); overload; override;
    property CambioMaximo[index: integer]: currency read GetCambioMaximo;
    property CambioMinimo[index: integer]: currency read GetCambioMinimo;
    property PCambiosMaximo: PArrayCurrency read FPCambiosMaximo;
    property PCambiosMinimo: PArrayCurrency read FPCambiosMinimo;
  end;


implementation

uses Grafico;


{ TGraficoVelas }

constructor TGraficoVelas.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ColorAlcista := clGreen;
  ColorBajista := clRed;
  ShowPositions := true;
end;

function TGraficoVelas.GetColorAlcista: TColor;
begin
  result := WinColor(FColorAlcista);
end;

function TGraficoVelas.GetColorBajista: TColor;
begin
  result := WinColor(FColorBajista);
end;

function TGraficoVelas.CreateDatosGrafico: TDatosGrafico;
begin
  result := TDatosGraficoVelas.Create;
  result.PixelSize := 5;
end;

procedure TGraficoVelas.PaintZoomGrafico(const iFrom, iTo: integer);
var x, y, yAyer: integer;
  xLeft, xRight: integer;
  i, j: integer;
begin
  for i := iFrom + 1 to iTo do begin
    if Datos.IsCambio[i] then begin
      j := i - 1;
      while (j > 0) and (not Datos.IsCambio[j]) do
        dec(j);
      yAyer := Datos.YTransformados[j];
      x := Datos.XTransformados[i];
      y := Datos.YTransformados[i];
      xLeft := x - 1;
      xRight := x + 2;
      if Datos.Cambio[j] >= Datos.Cambio[i] then begin
        Bitmap.PenColor := FColorBajista;
        Bitmap.FillRectS(xLeft, yAyer, xRight, y, FColorBajista);
      end
      else begin
        Bitmap.PenColor := FColorAlcista;
        Bitmap.FillRectS(xLeft, y, xRight, yAyer, FColorAlcista);
      end;
      Bitmap.LineS(x, TDatosGraficoVelas(Datos).YMaxTransformados[i],
        x, TDatosGraficoVelas(Datos).YMinTransformados[i], Bitmap.PenColor);
    end;
  end;
end;


procedure TGraficoVelas.SetData(const PCambios, PCambiosMaximo,
  PCambiosMinimo: PArrayCurrency; const PFechas: PArrayDate);
begin
  TDatosGraficoVelas(Datos).SetDataMaximoMinimo(PCambiosMaximo, PCambiosMinimo);
  inherited SetData(PCambios, PFechas);
end;

procedure TGraficoVelas.SetColorAlcista(const Value: TColor);
begin
  FColorAlcista := Color32(Value);
end;

procedure TGraficoVelas.SetColorBajista(const Value: TColor);
begin
  FColorBajista := Color32(Value);
end;

{ TDatosGraficoVelas }

function TDatosGraficoVelas.GetCambioMaximo(index: integer): currency;
begin
  result := FPCambiosMaximo^[index];
end;

function TDatosGraficoVelas.GetCambioMinimo(index: integer): currency;
begin
  result := FPCambiosMinimo^[index];
end;

procedure TDatosGraficoVelas.RecalculateMaxMin(const fromPos, toPos: integer);
var i, from: integer;
  max, min: Currency;
begin
  from := fromPos;
  while (IsDataNull[from]) or (IsSinCambio[from]) or
    (FPCambiosMaximo^[from] = SIN_CAMBIO) or (FPCambiosMinimo^[from] = SIN_CAMBIO) or
    (FPCambiosMaximo^[from] = DataNull) or (FPCambiosMinimo^[from] = DataNull) do
    inc(from);
  FMax := FPCambiosMaximo^[from];
  FMin := FPCambiosMinimo^[from];
  for i := from to toPos do begin
    if IsCambio[i] then begin
      max := FPCambiosMaximo^[i];
      if (max <> DataNull) and (max <> SIN_CAMBIO) then begin
        min := FPCambiosMinimo^[i];
        if (min <> DataNull) and (min <> SIN_CAMBIO) then begin
          if FMax < max then
            FMax := max;
          if min < FMin then
            FMin := min;
        end;
      end;
    end;
  end;
end;

procedure TDatosGraficoVelas.RecalculateTransformados(const fromPos,
  toPos: integer);
var i: integer;
  den, min: currency;
begin
  inherited RecalculateTransformados(fromPos, toPos);
  min := Minimo;
  den := Maximo - min;
  for i := fromPos to toPos do begin
    if Cambio[i] = DataNull then begin
      YMaxTransformados[i] := DataNull;
      YMinTransformados[i] := DataNull;
    end
    else begin
      if (den = 0) or (IsSinCambio[i]) then begin
        YMaxTransformados[i] := SIN_CAMBIO_TRANSFORMADO;
        YMinTransformados[i] := SIN_CAMBIO_TRANSFORMADO;
      end
      else begin
        // Si Maximo - Minimo --> alto
        //    valor  - Minimo   --> ?
        // valor =  YMaxTransformados
          YMaxTransformados[i] := Alto -  // El eje Y es negativo
            Round((FPCambiosMaximo^[i] - min) * Alto / den) + Top;
        // valor =  YMinTransformados
          YMinTransformados[i] := Alto -  // El eje Y es negativo
            Round((FPCambiosMinimo^[i] - min) * Alto / den) + Top;
      end;
    end;
  end;
end;

procedure TDatosGraficoVelas.SetDataMaximoMinimo(const PCambiosMaximo,
  PCambiosMinimo: PArrayCurrency);
var num: integer;
begin
  FPCambiosMaximo := PCambiosMaximo;
  FPCambiosMinimo := PCambiosMinimo;
  num := length(PCambiosMaximo^);
  SetLength(YMaxTransformados, num);
  SetLength(YMinTransformados, num);
end;

end.
