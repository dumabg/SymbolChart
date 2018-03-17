unit GraficoLineasLayer;

interface

uses GR32_Layers, Controls, Classes, Types, Graphics, GraficoZoom, GR32, Grafico,
  Contnrs;

type
  TInSelectedResizer = (isrA, isrB, isrCenter, isrNone);

  TLinePoint = packed record
    x: TDate;
    y: currency;
  end;

  TLine = class;
  TGraficoLinesLayer = class;

  TLineEvent = procedure (Line: TLine) of object;

  TLineType = (ltNormal, ltHorizontal, ltVertical);

  TLine = class
  private
    FHasStipple: boolean;
    FColor: TColor32;
    Grafico: TGraficoLinesLayer;
    FPointA: TLinePoint;
    FPointB: TLinePoint;
    FSensibility: integer;
    a, b: single;
    xLeft, xRight, yTop, yBottom: integer;
    FStipple: TArrayOfColor32;
    function GetColor: TColor;
    procedure SetColor(const Value: TColor);
    procedure SetStipple(const Value: TArrayOfColor32);
  protected
    procedure CalculateProperties; virtual;
    procedure SetPointB(const Value: TLinePoint); virtual;
    procedure SetPointA(const Value: TLinePoint); virtual;
    function CanBorrar: boolean; virtual;
    property HasStipple: boolean read FHasStipple;
  public
    constructor Create(const Grafico: TGraficoLinesLayer; const InitialPoint: TLinePoint); virtual;
    procedure Resize; inline;
    function isPointInLine(p: TPoint): boolean; virtual;
    procedure SetPoints(PointA, PointB: TLinePoint); virtual;
    property PointA: TLinePoint read FPointA write SetPointA;
    property PointB: TLinePoint read FPointB write SetPointB;
    property sensibility: integer read FSensibility write FSensibility;
    property Color: TColor read GetColor write SetColor;
    property Stipple: TArrayOfColor32 read FStipple write SetStipple;
  end;

  THorizontalLine = class(TLine)
  protected
    procedure SetPointB(const Value: TLinePoint); override;
    procedure SetPointA(const Value: TLinePoint); override;
  public
    constructor Create(const Grafico: TGraficoLinesLayer; const y: currency); reintroduce;
    procedure SetY(const y: currency);
    procedure SetPoints(PointA, PointB: TLinePoint); override;
  end;

  TVerticalLine = class(TLine)
  protected
    procedure SetPointB(const Value: TLinePoint); override;
    procedure SetPointA(const Value: TLinePoint); override;
  public
    constructor Create(const Grafico: TGraficoLinesLayer; const x: TDate); reintroduce;
    procedure SetX(const x: TDate);
    procedure SetPoints(PointA, PointB: TLinePoint); override;
  end;

  TGraficoLinesLayer = class(TGraficoDatosLayer)
  private
    Grafico: TZoomGrafico;
    FLines: TObjectList;
    Line: TLine;
    ClipRect: TRect;
    MovingX, MovingY, MovingXA, MovingXB, MovingYA, MovingYB: integer;
    ResizingSelectedLine: TInSelectedResizer;
    FIndexSelectedLine: integer;
    FLineSelectionSensibility: integer;
    FColorLines: TColor32;
    FColorSelectedLine: TColor32;
//    FOnLineChange: TLineEvent;
//    FOnCreateLine: TLineEvent;
//    FOnDeleteLine: TLineEvent;
    FCursorPainting: TCursor;
    FActive: boolean;
    FLineType: TLineType;
    function inSelectedLineResizer(X, Y: Integer): TInSelectedResizer;
    function getLineInPosition(X, Y: Integer): integer;
    procedure SetLineSelectionSensibility(const Value: integer);
    procedure SetCursorPainting(const Value: TCursor);
    procedure SetActive(const Value: boolean);
    function GetColorLines: TColor;
    function GetColorSelectedLine: TColor;
    procedure SetColorLines(const Value: TColor);
    procedure SetColorSelectedLine(const Value: TColor);
  protected
    procedure Paint(Buffer: TBitmap32); override;
    function DoHitTest(X, Y: Integer): Boolean; override;

    procedure DoKeyUp(var Key: Word;  Shift: TShiftState); override;
    procedure RecalculateTransformados(const fromPos, toPos: integer); override;

    procedure SelectLine(i: integer);

    function GetXScreen(const logicalX: TDate): integer; virtual;
    function GetYScreen(const yLogico: currency): integer; virtual;
    function GetXLogical(const screenX: integer): TDate; virtual;
    function GetYLogical(const screenY: integer): currency; virtual;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    function CreateNewLine(const x, y: Integer): TLine;
  public
    constructor Create(Grafico: TZoomGrafico); reintroduce;
    destructor Destroy; override;
    procedure BorrarLineaSeleccionada;
    procedure BorrarLineas(const todas: boolean);
    procedure BorrarLinea(const line: TLine);
    function HayLineas: boolean;
    function HayLineaSeleccionada: boolean;
    function AddHorizontalLine(const y: currency): THorizontalLine;
    function AddVerticalLine(const x: TDate): TVerticalLine;
    procedure AddLine(const line: TLine);
    property LineSelectionSensibility: integer read FLineSelectionSensibility write SetLineSelectionSensibility default 5;
  {  property OnLineChange: TLineEvent read FOnLineChange write FOnLineChange;
    property OnCreateLine: TLineEvent read FOnCreateLine write FOnCreateLine;
    property OnDeleteLine: TLineEvent read FOnDeleteLine write FOnDeleteLine;}
    property ColorLines: TColor read GetColorLines write SetColorLines;
    property ColorSelectedLine: TColor read GetColorSelectedLine write SetColorSelectedLine;
    property CursorPainting: TCursor read FCursorPainting write SetCursorPainting;
    property Active: boolean read FActive write SetActive default true;
    property Lineas: TObjectList read FLines;
    property LineType: TLineType read FLineType write FLineType;
  end;


implementation

uses Windows, Forms, Tipos, SysUtils, DateUtils, DatosGrafico, dmData;

const
  fpcGraficoDibujarLinea = 2;
  RESIZER_SENSIBILITY = 3;
  NINGUNA_LINEA_SELECCIONADA = -1;
  INFINITO_NEG: integer = Low(integer);
  INFINITO_POS: integer = High(integer);


function PointLine(const x: TDate; const y: currency): TLinePoint; inline;
begin
  result.x := x;
  result.y := y;
end;

{ TLine }

procedure TLine.CalculateProperties;
var X1, X2, Y1, Y2: integer;
begin
  // aX1 - Y1 = aX2 - Y2 --> a = (Y1 - Y2) / (X1 - X2)
  X1 := Grafico.GetXScreen(FPointA.x);
  Y1 := Grafico.GetYScreen(FPointA.y);
  Y2 := Grafico.GetYScreen(FPointB.y);

  X2 := Grafico.GetXScreen(FPointB.x);
  if X1 = X2 then
    a := 0
  else
    a := ((Y1 - Y2)) / ((X1 - X2));
  // b = Y1 - aX1;
  b := Y1 - a * X1;

  ///////////////

  if X1 > X2 then begin
    xLeft := X2;
    xRight := X1;
  end
  else begin
    xLeft := X1;
    xRight := X2;
  end;

  if Y1 >= Y2 then begin
    YTop := Y1;
    YBottom := Y2;
  end
  else begin
    YTop := Y2;
    YBottom := Y1;
  end;
end;

function TLine.CanBorrar: boolean;
begin
  result := true;
end;

constructor TLine.Create(const Grafico: TGraficoLinesLayer; const InitialPoint: TLinePoint);
begin
  inherited Create;
  Self.Grafico := Grafico;
  FSensibility := Grafico.LineSelectionSensibility;
  FPointA := InitialPoint;
  FPointB := InitialPoint;
  FHasStipple := false;
  FColor := Grafico.FColorLines;
end;

function TLine.GetColor: TColor;
begin
  result := WinColor(FColor);
end;

function TLine.isPointInLine(p: TPoint): boolean;
var x, y: single;
begin
  result := (YTop + FSensibility >= p.y) and (YBottom - FSensibility <= p.Y);

  if result then begin
    if a = 0 then begin // La linea esta a 0 grados o 90 grados - o | respectivamente.
      result := ((xLeft < p.x + FSensibility) and (xRight >= p.x - FSensibility)) or
          ((yTop < p.Y - FSensibility) and (yBottom > p.y + FSensibility));
    end
    else begin
      // Busco la x correspondiente a la y
      // ax - y + b = 0 --> y = ax + b  --> x = (y -b) / a
      x := (p.Y - b) / a;
      // La linea está mas recta |
      result := (x <= p.x + FSensibility) and (x >= p.x - FSensibility);
      if not result then begin
         y := (p.X * a) + b; // La línea está mas plana -
         result := (y <= p.Y + FSensibility) and (y >= p.y - FSensibility);
      end;
    end;
  end;
end;

procedure TLine.Resize;
begin
  CalculateProperties;
end;

procedure TLine.SetColor(const Value: TColor);
begin
  FColor := Color32(Value);
end;

procedure TLine.SetPointA(const Value: TLinePoint);
begin
  FPointA := Value;
  CalculateProperties;
end;

procedure TLine.SetPointB(const Value: TLinePoint);
begin
  FPointB := Value;
  CalculateProperties;
end;

procedure TLine.SetPoints(PointA, PointB: TLinePoint);
begin
  FPointA := PointA;
  FPointB := PointB;
  CalculateProperties;
end;

procedure TLine.SetStipple(const Value: TArrayOfColor32);
begin
  FStipple := Value;
  FHasStipple := true;
end;

{ TGraficoLinesLayer }

function TGraficoLinesLayer.AddHorizontalLine(
  const y: Currency): THorizontalLine;
begin
  result := THorizontalLine.Create(Self, y);
  FLines.Add(result);
  Update;
end;

procedure TGraficoLinesLayer.AddLine(const line: TLine);
begin
  FLines.Add(line);
  Update;
end;

function TGraficoLinesLayer.AddVerticalLine(const x: TDate): TVerticalLine;
begin
  result := TVerticalLine.Create(Self, x);
  FLines.Add(result);
  Update;
end;

procedure TGraficoLinesLayer.BorrarLinea(const line: TLine);
var i: integer;
begin
  i := FLines.IndexOf(line);
  if i <> -1 then
    FLines.Delete(i);
  Grafico.Invalidate;
end;

procedure TGraficoLinesLayer.BorrarLineas(const todas: boolean);
var line: TLine;
  i: integer;
begin
  FIndexSelectedLine := -1;
  if todas then begin
    FLines.Clear;
    FIndexSelectedLine := NINGUNA_LINEA_SELECCIONADA;
  end
  else begin
    i := 0;
    while i < FLines.Count do begin
      line := TLine(FLines[i]);
      if line.CanBorrar then begin
        FLines.Delete(i);
      end
      else
        inc(i);
    end;
  end;
  Grafico.Invalidate;
end;

procedure TGraficoLinesLayer.BorrarLineaSeleccionada;
begin
  if FIndexSelectedLine <> NINGUNA_LINEA_SELECCIONADA then begin
    FLines.Delete(FIndexSelectedLine);
    FIndexSelectedLine := NINGUNA_LINEA_SELECCIONADA;
{    if Assigned(OnDeleteLine) then
      OnDeleteLine(line);}
    Grafico.Cursor := FCursorPainting;
    Grafico.Invalidate;
  end;
end;

constructor TGraficoLinesLayer.Create(Grafico: TZoomGrafico);
begin
  inherited Create(Grafico);
  Self.Grafico := Grafico;
  FColorLines := clWhite;
  FColorSelectedLine := clYellow;
  FLines := TObjectList.Create;
  FLines.OwnsObjects := true;
  FIndexSelectedLine := NINGUNA_LINEA_SELECCIONADA;
  resizingSelectedLine := isrNone;
  FLineSelectionSensibility := 5;
  Line := nil;
  FActive := false;
  FCursorPainting := fpcGraficoDibujarLinea;
  FLineType := ltNormal;
  ClipRect := Rect(1, 1, Grafico.Ancho, Grafico.Alto);  
end;

function TGraficoLinesLayer.CreateNewLine(const x, y: Integer): TLine;
begin
  case FLineType of
    ltHorizontal: result := THorizontalLine.Create(Self, GetYLogical(Y));
    ltVertical: result := TVerticalLine.Create(Self, GetXLogical(X));
    else result := TLine.Create(Self, PointLine(GetXLogical(X), GetYLogical(Y)));
  end;
  result.FColor := FColorLines;
end;

destructor TGraficoLinesLayer.Destroy;
begin
  if Line <> nil then
    Line.Free;
  FLines.Free;
  inherited;
end;

function TGraficoLinesLayer.DoHitTest(X, Y: Integer): Boolean;
begin
  result := (FActive) and (not Grafico.ZoomActive);
end;

procedure TGraficoLinesLayer.DoKeyUp(var Key: Word; Shift: TShiftState);
begin
  if Key = VK_DELETE then
    BorrarLineaSeleccionada;
end;

function TGraficoLinesLayer.GetColorLines: TColor;
begin
  Result := WinColor(FColorLines);
end;

function TGraficoLinesLayer.GetColorSelectedLine: TColor;
begin
  result := WinColor(FColorSelectedLine);
end;

function TGraficoLinesLayer.getLineInPosition(X, Y: Integer): integer;
var i, num : integer;
begin
  num := FLines.Count - 1;
  for i:=0 to num do begin
    if TLine(FLines[i]).isPointInLine(Point(X,Y)) then begin
      result := i;
      exit;
    end;
  end;
  result := NINGUNA_LINEA_SELECCIONADA;
end;

function TGraficoLinesLayer.GetXLogical(const screenX: integer): TDate;
var iFrom, iTo, xiTo, xiToAnt, i, j, den: integer;
  zoom: TZoom;
begin
  zoom := Grafico.ZoomInterval;
  iFrom := zoom.ZoomFrom;
  iTo := zoom.ZoomTo;
  while Datos.Fechas[iFrom] = SIN_FECHA do
    inc(iFrom);
  if screenX < 0 then begin
    den := Datos.XTransformados[iFrom + 1] - Datos.XTransformados[iFrom];
    i := iFrom - (-screenX div den);
    if i < 0 then
      i := 0;
    result := Datos.Fechas[i];
  end
  else begin
    if screenX > Datos.XTransformados[iTo] then begin
      xiTo := Datos.XTransformados[iTo];
      xiToAnt := Datos.XTransformados[iTo - 1];
      i := iTo + ((screenX - xiTo) div (xiTo - xiToAnt));
      if i >= Datos.DataCount then
        result := Datos.Fechas[Datos.DataCount - 1]
      else
        result := Datos.Fechas[i];
    end
    else begin
      for j := iFrom to iTo do begin
        if Datos.XTransformados[j] >= screenX  then begin
          i := j - 1;
          if i < 0 then
            i := 0;
          result := Datos.Fechas[i];
          exit;
        end;
      end;
      xiTo := Datos.XTransformados[iTo];
      xiToAnt := Datos.XTransformados[iTo - 1];
      i := iTo + ((screenX - xiTo) div (xiTo - xiToAnt));
      if i < 0 then
        i := 0;
      result := Datos.Fechas[i];
    end;
  end;
end;

function TGraficoLinesLayer.GetXScreen(const logicalX: TDate): integer;
var zoomFrom, zoomTo, den, i, num: integer;
  zoom: TZoom;
  fecha: TDate;
  diario: Boolean;
begin
  if logicalX = INFINITO_NEG then
    // -10 Para que no se vean los cuadros de redimensionar
    result := -10
  else begin
    if logicalX = INFINITO_POS then begin
      // + 10 Para que no se vean los cuadros de redimensionar
      result := Grafico.Width + 10;
    end
    else begin
      zoom := Grafico.ZoomInterval;
      zoomTo := zoom.ZoomTo;
      zoomFrom := zoom.ZoomFrom;
      while Datos.Fechas[zoomFrom] = SIN_FECHA do
        inc(zoomFrom);
      if logicalX < Datos.Fechas[zoomFrom] then begin
        i := zoomFrom - 1;
        den := Datos.XTransformados[zoomFrom + 1] - Datos.XTransformados[zoomFrom];
        while i >= 0 do begin
          if logicalX >= Datos.Fechas[i] then begin
            result := Datos.XTransformados[zoomFrom] - ((zoomFrom - i) * den);
            exit;
          end;
          dec(i);
        end;
        fecha := Datos.Fechas[0];
        //Los escenarios tiran la fecha al futuro, pero quitan los fines de semana
        //por lo que son 2 días por semana (sabado y domingo)
        i := - (DaysBetween(fecha, logicalX) - (WeeksBetween(fecha, logicalX) * 2) - 1);
        result := Datos.XTransformados[zoomFrom] - ((zoomFrom - i) * den);
      end
      else begin
        if logicalX > Datos.Fechas[zoomTo] then begin
          i := zoomTo + 1;
          num := Datos.DataCount;
          den := Datos.XTransformados[zoomFrom + 1] - Datos.XTransformados[zoomFrom];
          while i < num do begin //zero based
            if logicalX <= Datos.Fechas[i] then begin
              result := Datos.XTransformados[zoomTo] + ((i - zoomTo) * den);
              exit;
            end;
            inc(i);
          end;
          fecha := Datos.Fechas[num - 1];
          //Los escenarios tiran la fecha al futuro, pero quitan los fines de semana
          //por lo que son 2 días por semana (sabado y domingo)
{          i := num + DaysBetween(fecha, logicalX) - (WeeksBetween(fecha, logicalX) * 2) - 1;
          result := Datos.XTransformados[zoomTo] + ((i - zoomTo) * den);}
          diario := Data.TipoCotizacion = tcDiaria;
          if diario then          
            i := DaysBetween(fecha, logicalX) - (WeeksBetween(fecha, logicalX) * 2) - 1
          else
            i := WeeksBetween(fecha, logicalX);
          result := Datos.XTransformados[zoomTo] + (i * den);
        end
        else begin
          i := zoomFrom;
          while (i <= zoomTo) and (Datos.Fechas[i] < logicalX) do begin //zero based
            inc(i);
          end;
          result := Datos.XTransformados[i];
        end;
      end;

{      if logicalX > zoomTo then begin
        den := Datos.XTransformados[zoomFrom + 1] - Datos.XTransformados[zoomFrom];
        result := Datos.XTransformados[zoomTo] + ((logicalX - zoomTo) * den);
      end
      else begin
        if logicalX < zoomFrom then begin
          den := Datos.XTransformados[zoomFrom + 1] - Datos.XTransformados[zoomFrom];
          result := Datos.XTransformados[zoomFrom] - ((zoomFrom - logicalX) * den);
        end
        else
          result := Datos.XTransformados[logicalX];
      end;}
    end;
  end;
end;

function TGraficoLinesLayer.GetYLogical(const screenY: integer): currency;
begin
  result := Datos.Maximo - (((Datos.Maximo - Datos.Minimo) / Grafico.Alto) * screenY);
end;

function TGraficoLinesLayer.GetYScreen(const yLogico: currency): integer;
begin
  if yLogico = INFINITO_NEG then
    // Para que no se vean los cuadros de redimensionar
    result := -10
  else begin
    if yLogico = INFINITO_POS then
      result := Grafico.Height + 10
    else begin
      result := Round((yLogico - Datos.Maximo) / (((Datos.Minimo - Datos.Maximo) / Grafico.Alto)));
    end;
  end;
end;

function TGraficoLinesLayer.HayLineas: boolean;
begin
  result := FLines.Count > 0;
end;

function TGraficoLinesLayer.HayLineaSeleccionada: boolean;
begin
  result := FIndexSelectedLine <> NINGUNA_LINEA_SELECCIONADA;
end;

function TGraficoLinesLayer.inSelectedLineResizer(X,
  Y: Integer): TInSelectedResizer;
var selectedLine: TLine;
  XA, YA, XB, YB: integer;
begin
  if FIndexSelectedLine = NINGUNA_LINEA_SELECCIONADA then
    result := isrNone
  else begin
    if getLineInPosition(X, Y) = FIndexSelectedLine then begin
      selectedLine := TLine(FLines[FIndexSelectedLine]);
      XA := GetXScreen(selectedLine.PointA.x);
      YA := GetYScreen(selectedLine.PointA.y);
      XB := GetXScreen(selectedLine.PointB.x);
      YB := GetYScreen(selectedLine.PointB.y);
      if (((X > XA - RESIZER_SENSIBILITY) and (X < XA + RESIZER_SENSIBILITY) and
           (Y > YA - RESIZER_SENSIBILITY) and (Y < YA + RESIZER_SENSIBILITY))) then
        Result := isrA
      else
        if ((X > XB - RESIZER_SENSIBILITY) and (X < XB + RESIZER_SENSIBILITY) and
            (Y > YB - RESIZER_SENSIBILITY) and (Y < YB + RESIZER_SENSIBILITY)) then
          Result := isrB
        else
          Result := isrCenter;
    end
    else
      result := isrNone;
  end;
end;

procedure TGraficoLinesLayer.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var lineAux: TLine;
  lineFound: integer;
begin
  if Button = mbLeft then begin
    // Si no se está creando ninguna línea
    resizingSelectedLine := inSelectedLineResizer(X, Y);
    if resizingSelectedLine = isrNone then begin
      lineFound := getLineInPosition(X, Y);
      if (lineFound = NINGUNA_LINEA_SELECCIONADA) then begin  // Si hacemos clic y no hay ninguna línea cerca
        Line := CreateNewLine(X, Y);
        FIndexSelectedLine := NINGUNA_LINEA_SELECCIONADA;
      end
      else
        SelectLine(lineFound);  // Hemos hecho clic cerca de una línea}
    end
    else begin   // Empezamos a arrastrar una línea
      lineAux := TLine(FLines[FIndexSelectedLine]);
      MovingXA := GetXScreen(lineAux.PointA.x);
      MovingYA := GetYScreen(lineAux.PointA.y);
      MovingXB := GetXScreen(lineAux.PointB.x);
      MovingYB := GetYScreen(lineAux.PointB.y);
      MovingX := X;
      MovingY := Y;
    end;
 end;
end;

procedure TGraficoLinesLayer.MouseMove(Shift: TShiftState; X, Y: Integer);
var lineAux: TLine;
  XA, XB, YA, YB, distanciaX, distanciaY: integer;
  resizer: TInSelectedResizer;
begin
  if ResizingSelectedLine = isrNone then begin
    if Line <> nil then begin  // creandose una línea
      if GetAsyncKeyState(VK_LBUTTON) <> 0 then begin //¿Esta pulsado el botón izquierdo?
        Line.pointB := PointLine(GetXLogical(X), GetYLogical(Y));
        Update;
      end
      else
        FreeAndNil(Line);
    end
    else begin // líneas creadas
      resizer := inSelectedLineResizer(X, Y);
      if resizer = isrNone then begin // Cambiar el cursor si pasa por encima de los resizers de la seleccionada
        if getLineInPosition(X, Y) <> NINGUNA_LINEA_SELECCIONADA then // Si pasamos cerca de una línea que podemos seleccionar
            Grafico.Cursor := crHandPoint
        else
          Grafico.Cursor := FCursorPainting;
      end
      else
        if resizer = isrCenter then
          Grafico.Cursor := crSizeAll
        else
          Grafico.Cursor := crSizeNWSE;
    end;
  end
  else begin  // Se está haciendo resizing de una línea
      lineAux := TLine(FLines[FIndexSelectedLine]);
      if resizingSelectedLine = isrA then begin
        lineAux.pointA := PointLine(GetXLogical(X), GetYLogical(Y));
      end
      else
        if resizingSelectedLine = isrB then begin
          lineAux.pointB := PointLine(GetXLogical(X), GetYLogical(Y));
        end
        else begin // Se ha cogido la línea del centro y se ha arrastrado
          if lineAux is THorizontalLine then begin
            distanciaY := Y - MovingY;
            THorizontalLine(lineAux).SetY(GetYLogical(MovingYA + distanciaY));
          end
          else begin
            if lineAux is TVerticalLine then begin
              distanciaX := X - MovingX;
              TVerticalLine(lineAux).SetX(GetXLogical(MovingXA + distanciaX));
            end
            else begin
              distanciaX := X - MovingX;
              distanciaY := Y - MovingY;
              XA := MovingXA + distanciaX;
              XB := MovingXB + distanciaX;
              YA := MovingYA + distanciaY;
              YB := MovingYB + distanciaY;
              lineAux.SetPoints(
                PointLine(GetXLogical(XA), GetYLogical(YA)),
                PointLine(GetXLogical(XB), GetYLogical(YB)));
            end;
          end;
        end;
      Update;
  end;
end;

procedure TGraficoLinesLayer.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
//var lineSelected: TLine;
begin
  if Button = mbLeft then begin
    // Se ha movido la linea por el centro
    if ResizingSelectedLine <> isrNone then begin
{      lineSelected := TLine(FLines[FIndexSelectedLine]);
      if (Assigned(OnLineChange)) and (lineSelected <> nil) then
        OnLineChange(lineSelected)}
    end
    else begin
      if Line <> nil then begin  // Se está creando una línea
        if (abs(GetXScreen(Line.PointA.x) - X) > 5) or
           (abs(GetYScreen(Line.PointA.y) - Y) > 5) then begin  // Si la línea tiene un tamaño mínimo de 5 pixels
          Line.pointB := PointLine(GetXLogical(X), GetYLogical(Y));
          FLines.Add(Line); // Añadimos el puntero de Line a la lista de líneas
          FIndexSelectedLine := FLines.Count - 1;
{          if Assigned(OnCreateLine) then
            OnCreateLine(Line);}
          Line := nil; // Se inicializa el puntero a la Line
        end
        else
          FreeAndNil(Line);
        Update;
      end;
    end;
    resizingSelectedLine := isrNone;
  end
  else
    FreeAndNil(Line);
end;


procedure TGraficoLinesLayer.Paint(Buffer: TBitmap32);
var num, i: integer;
  aux: TLine;
  color: TColor32;
  x, y, X1, Y1, X2, Y2: integer;
  oldClipRect: TRect;

    procedure drawRectangle(x, y: integer);
    begin
      Buffer.FillRectS(x - 3, y - 3, x + 3, y + 3, color);
    end;
begin
  num := FLines.Count - 1;
  if (Line <> nil) or (num >= 0) then begin
    oldClipRect := Buffer.ClipRect;
    Buffer.ClipRect := ClipRect;
    for i := 0 to num do begin
      aux := TLine(FLines[i]);
      if i = FIndexSelectedLine then
        color := FColorSelectedLine
      else
        color := aux.FColor;

      if aux.HasStipple then
        Buffer.SetStipple(aux.Stipple);

      if aux is THorizontalLine then begin
        y := GetYScreen(aux.PointA.Y);
        if aux.HasStipple then
          Buffer.HorzLineTSP(0, y, Grafico.Ancho)
        else
          Buffer.HorzLineS(0, y, Grafico.Ancho, color);
        Buffer.Font.Size := 8;
        Buffer.Font.Color := WinColor(color);
        Buffer.Textout(5, y, CurrToStrF(aux.PointA.Y, ffCurrency, CurrencyDecimals));
      end
      else begin
        if aux is TVerticalLine then begin
          x := GetXScreen(aux.PointA.X);
          if aux.HasStipple then
            Buffer.VertLineTSP(x, 0, Grafico.Alto)
          else
            Buffer.VertLineS(x, 0, Grafico.Alto, color);
        end
        else begin
          X1 := GetXScreen(aux.PointA.X);
          X2 := GetXScreen(aux.PointB.X);
          Y1 := GetYScreen(aux.PointA.Y);
          Y2 := GetYScreen(aux.PointB.Y);
          if aux.HasStipple then
            Buffer.LineXSP(X1, Y1, X2, Y2, true)
          else
            Buffer.LineAS(X1, Y1, X2, Y2, color, true);
          if i = FIndexSelectedLine then begin
            drawRectangle(X1, Y1);
            drawRectangle(X2, Y2);
          end;
        end;
      end;
    end;
    if Line <> nil then begin
      X1 := GetXScreen(line.PointA.X);
      X2 := GetXScreen(line.PointB.X);
      Y1 := GetYScreen(line.PointA.Y);
      Y2 := GetYScreen(line.PointB.Y);
      Buffer.LineS(X1, Y1, X2, Y2, FColorSelectedLine, true);
    end;
    Buffer.ClipRect := oldClipRect;
  end;
end;

procedure TGraficoLinesLayer.RecalculateTransformados(const fromPos,
  toPos: integer);
var i: integer;
begin
  inherited;
  for i := 0 to FLines.Count - 1 do
    TLine(FLines[i]).Resize;
  ClipRect := Rect(1, 1, Grafico.Ancho, Grafico.Alto);
 end;

procedure TGraficoLinesLayer.SelectLine(i: integer);
begin
  FIndexSelectedLine := i;
  Update;
end;

procedure TGraficoLinesLayer.SetActive(const Value: boolean);
begin
  FActive := Value;
  if FActive then begin
    Grafico.Cursor := FCursorPainting;
  end
  else begin
    Grafico.Cursor := crDefault;
    FIndexSelectedLine := NINGUNA_LINEA_SELECCIONADA;
    Update;
  end;
end;

procedure TGraficoLinesLayer.SetColorLines(const Value: TColor);
var i, num: integer;
begin
  FColorLines := Color32(Value);
  num := FLines.Count - 1;
  for i := 0 to num do
    TLine(FLines[i]).FColor := FColorLines;
  Update;
end;

procedure TGraficoLinesLayer.SetColorSelectedLine(const Value: TColor);
begin
  FColorSelectedLine := Color32(Value);
  Update;
end;

procedure TGraficoLinesLayer.SetCursorPainting(const Value: TCursor);
begin
  FCursorPainting := Value;
  if Active then
    Grafico.Cursor := FCursorPainting;
end;


procedure TGraficoLinesLayer.SetLineSelectionSensibility(const Value: integer);
var i: integer;
begin
  FLineSelectionSensibility := Value;
  for i:=0 to FLines.Count - 1 do
     TLine(FLines[i]).sensibility := FLineSelectionSensibility;
end;


procedure LoadCursors;
var C: HCURSOR;
begin
    C := LoadCursor(HInstance, 'GRAFICO_DIBUJAR_LINEA');
    if C <> 0 then
      Screen.Cursors[fpcGraficoDibujarLinea] := C;
end;

{ THorizontalLine }

constructor THorizontalLine.Create(const Grafico: TGraficoLinesLayer;
  const y: currency);
begin
  inherited Create(Grafico, PointLine(INFINITO_NEG, y));
  FPointB := PointLine(INFINITO_POS, y);
  CalculateProperties;
end;

procedure THorizontalLine.SetPointA(const Value: TLinePoint);
begin
  inherited SetPoints(PointLine(INFINITO_NEG, Value.y), PointLine(INFINITO_POS, Value.y));
end;

procedure THorizontalLine.SetPointB(const Value: TLinePoint);
begin
  inherited SetPoints(PointLine(INFINITO_NEG, Value.y), PointLine(INFINITO_POS, Value.y));
end;

procedure THorizontalLine.SetPoints(PointA, PointB: TLinePoint);
begin
  inherited SetPoints(PointLine(INFINITO_NEG, PointA.y), PointLine(INFINITO_POS, PointA.y));
end;

procedure THorizontalLine.SetY(const y: currency);
begin
  inherited SetPoints(PointLine(INFINITO_NEG, y), PointLine(INFINITO_POS, y));
end;

{ TVerticalLine }

constructor TVerticalLine.Create(const Grafico: TGraficoLinesLayer;
  const x: TDate);
begin
  inherited Create(Grafico, PointLine(x, INFINITO_NEG));
  FPointB := PointLine(x, INFINITO_POS);
  CalculateProperties;
end;

procedure TVerticalLine.SetPointA(const Value: TLinePoint);
begin
  inherited SetPoints(PointLine(Value.x, INFINITO_NEG), PointLine(Value.x, INFINITO_POS));
end;

procedure TVerticalLine.SetPointB(const Value: TLinePoint);
begin
  inherited SetPoints(PointLine(Value.x, INFINITO_NEG), PointLine(Value.x, INFINITO_POS));
end;

procedure TVerticalLine.SetPoints(PointA, PointB: TLinePoint);
begin
  inherited SetPoints(PointLine(PointA.x, INFINITO_NEG), PointLine(PointA.x, INFINITO_POS));
end;

procedure TVerticalLine.SetX(const x: TDate);
begin
  inherited SetPoints(PointLine(x, INFINITO_NEG), PointLine(x, INFINITO_POS));
end;

initialization
  LoadCursors;

end.
