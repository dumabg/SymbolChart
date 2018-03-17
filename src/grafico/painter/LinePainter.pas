unit LinePainter;

interface

uses DatosGrafico, GR32;

type
  TLinePainter = class
  private
    FDatos: TDatosGrafico;
    FColor: TColor32;
  public
    procedure Paint(const Bitmap: TBitmap32; const iFrom, iTo: integer); 
    property Datos: TDatosGrafico read FDatos write FDatos;
    property Color: TColor32 read FColor write FColor;
  end;

implementation

uses Tipos, Types;

{ TLinePainter }

procedure TLinePainter.Paint(const Bitmap: TBitmap32; const iFrom,
  iTo: integer);
var auxTo, i, num: integer;
  lastX, lastY: integer;
  lastConCambio: boolean;
begin
  num := Datos.DataCount - 1;
  if num > 0 then begin
    auxTo := iTo;
    if auxTo < num then
      inc(auxTo);
    if Datos.IsCambio[iFrom] then begin
      lastX := Datos.XTransformados[iFrom];
      lastY := Datos.YTransformados[iFrom];
      lastConCambio := true;
    end
    else
      lastConCambio := false;
    i := iFrom + 1;
    while i <= auxTo do begin
      if Datos.IsCambio[i] then begin
        if lastConCambio then
          Bitmap.LineAS(lastX, lastY,  Datos.XTransformados[i], Datos.YTransformados[i], FColor, true)
        else
          lastConCambio := true;
        lastX := Datos.XTransformados[i];
        lastY := Datos.YTransformados[i];
      end
      else begin
        lastConCambio := false;
      end;
      inc(i);
    end;
  end;
end;

end.
