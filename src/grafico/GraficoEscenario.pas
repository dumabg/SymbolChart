unit GraficoEscenario;

interface

uses GraficoLineas, Tipos, GR32, Graphics, Classes, Escenario, frCargando,
  GraficoZoom, DatosGrafico;

type
  TGraficoEscenario = class(TGraficoLineas)
  private
    FPenLastLine: TPen;
    FPenEscenario: TPen;
    FColorLastLine: TColor32;
    cargando: TfCargando;
    FVerNube: boolean;
    FShowMedia: boolean;
    procedure SetPenLastLine(const Value: TPen);
    procedure SetShowMedia(const Value: boolean);
    procedure SetColorLastLine(const Value: TColor);
    function GetColorLastLine: TColor;
    procedure SetCreando(const Value: boolean);
    function GetHayEscenario: boolean;
    procedure SetVerNube(const Value: boolean);
  protected
    procedure PaintZoomGrafico(const iFrom, iTo: integer); override;
    function CreateDatosGrafico: TDatosGrafico; override;
    procedure AssignZoomData(zoomGrafico: TZoomGrafico); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DefaultProperties;
    procedure Borrar;
    property ColorLastLine: TColor read GetColorLastLine write SetColorLastLine default clGray;
    property PenEscenario: TPen read FPenEscenario write FPenEscenario;
    property ShowMedia: boolean read FShowMedia write SetShowMedia default false;
    property VerNube: boolean read FVerNube write SetVerNube default true;
    property Creando: boolean write SetCreando;
    property HayEscenario: boolean read GetHayEscenario;
  end;

  TDatosGraficoEscenario = class(TDatosGrafico)
    private
      FUltimoIData: integer;
      FDatosEscenario: TArrayCurrency;
      FFechasEscenario: TArrayDate;
      YEscenariosMultiplesTransformado: array of array of integer;
      FEscenarioMultiple: TEscenarioMultiple;
      FEscenario: TEscenario;
      procedure SetEscenarioMultiple(const Value: TEscenarioMultiple);
    protected
      procedure Borrar;
    public
      procedure SetData(const PCambios: PArrayCurrency; const PFechas: PArrayDate); override;
      procedure RecalculateTransformados(const fromPos, toPos: integer); override;
      procedure ActivateEscenario(const multiple: boolean);
      property UltimoIData: integer read FUltimoIData;
      property EscenarioMultiple: TEscenarioMultiple read FEscenarioMultiple write SetEscenarioMultiple;
      property Escenario: TEscenario read FEscenario write FEscenario;
  end;


implementation

uses Controls, DateUtils, SysUtils, Grafico, GraficoBolsa,
  LinePainter, GraficoEscenarioPositionLayer, dmData;

{ TGraficoEscenario }

procedure TGraficoEscenario.AssignZoomData(zoomGrafico: TZoomGrafico);
var zoom: TZoom;
  ultimoIData, num: integer;
begin
  inherited;
  ultimoIData := TDatosGraficoEscenario(Datos).UltimoIData;
  zoom := ZoomHistoryData[ZoomHistoryPos - 1];
  if zoom.ZoomTo = ultimoIData then begin
    num := TDatosGraficoEscenario(Datos).DataCount - 1;
    ZoomHistoryData[ZoomHistoryPos - 1].ZoomTo := num;
    ZoomHistoryData[ZoomHistoryPos - 1].ZoomFrom := num - ultimoIData;
  end;
end;

procedure TGraficoEscenario.Borrar;
var positionLayer: TEscenarioGraficoPositionLayer;
begin
  positionLayer := TEscenarioGraficoPositionLayer(GetLayerByType(TEscenarioGraficoPositionLayer));
  if positionLayer <> nil then
    positionLayer.Active := false;
  TDatosGraficoEscenario(Datos).Borrar;
  Recalculate;
  InvalidateGrafico;
  if positionLayer <> nil then begin
    positionLayer.Position := TDatosGraficoEscenario(Datos).UltimoIData;
    positionLayer.Active := true;
  end;
end;

constructor TGraficoEscenario.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DefaultProperties;
  cargando := TfCargando.Create(Self);
  cargando.Visible := false;
  cargando.Left := Width - cargando.Width - 50;
  cargando.Top := 0;
  cargando.Anchors := [akRight, akTop];
  cargando.Parent := Self;
end;

function TGraficoEscenario.CreateDatosGrafico: TDatosGrafico;
begin
  result := TDatosGraficoEscenario.Create;
end;

procedure TGraficoEscenario.DefaultProperties;
begin
  FColorLastLine := clGray32;
  FVerNube := true;
end;

function TGraficoEscenario.GetColorLastLine: TColor;
begin
  result := WinColor(FColorLastLine);
end;

function TGraficoEscenario.GetHayEscenario: boolean;
begin
  result := TDatosGraficoEscenario(Datos).Escenario <> nil;
end;

procedure TGraficoEscenario.PaintZoomGrafico(const iFrom, iTo: integer);
var x: integer;
 i, j, numEscenarios, jFrom, jTo, UltimoIData: integer;
 Datos: TDatosGraficoEscenario;
 lastX, lastY, newX, newY: integer;
begin
  Datos := TDatosGraficoEscenario(Self.Datos);
  UltimoIData := Datos.UltimoIData;
  if (FVerNube) and (Datos.YEscenariosMultiplesTransformado <> nil) then begin
    if iTo > UltimoIData then begin
        numEscenarios := length(Datos.YEscenariosMultiplesTransformado) - 1;

        if iFrom > UltimoIData then
          jFrom := iFrom - UltimoIData
        else
          jFrom := 0;
         jTo := iTo - UltimoIData - 1;

        for i := 0 to numEscenarios do begin
          if jFrom = 0 then begin
            lastX := Datos.XTransformados[UltimoIData];
            lastY := Datos.YTransformados[UltimoIData];
          end
          else begin
            lastX := Datos.XTransformados[UltimoIData + jFrom];
            lastY := Datos.YEscenariosMultiplesTransformado[i][jFrom - 1];
          end;
          for j := jFrom to jTo do begin
            newX := Datos.XTransformados[UltimoIData + j + 1];
            newY := Datos.YEscenariosMultiplesTransformado[i][j];
            Bitmap.LineAS(lastX, lastY, newX, newY, clDimGray32);
            lastX := newX;
            lastY := newY;
          end;
        end;
    end;
  end;
  inherited PaintZoomGrafico(iFrom, iTo);
  if (iFrom < UltimoIData) and (iTo > UltimoIData) then begin
    x := Datos.XTransformados[UltimoIData];
    Bitmap.SetStipple([FColorLastLine, FColorLastLine, FColorLastLine, FColorLastLine, 0, 0]);
    Bitmap.VertLineTSP(x, 0, Height);
  end;
end;

procedure TGraficoEscenario.SetColorLastLine(const Value: TColor);
begin
  FColorLastLine := Color32(Value);
end;

procedure TGraficoEscenario.SetCreando(const Value: boolean);
var posLayer: TEscenarioGraficoPositionLayer;
begin
  //Cuando se crea un nuevo escenario puede ser que el usuario ya haya creado
  //otro y esté posicionado en el último valor del escenario, con lo que si
  //ahora el escenario resultante tiene menos cambios (debido a la sintonización),
  //la posición del cursor dara un EIntegerOverflow, ya que estará intentado
  //posicionarse a una posición que ya no existe.
  //Para solucionarlo se desactiva el position layer antes de empezar a crear el
  //nuevo escenario (con lo que se evita problemas mientras se está creando) y
  //posteriormente cuando se acaba la creación se posiciona al UltimoIData (el
  //primer cambio del gráfico antes del primer cambio del escenario) antes de
  //volver a activar el position layer.
  posLayer := TEscenarioGraficoPositionLayer(GetLayerByType(TEscenarioGraficoPositionLayer));
  if not Value then
    posLayer.Position := TDatosGraficoEscenario(Datos).UltimoIData;
  posLayer.Active := not Value;
  cargando.Visible := Value;
end;

procedure TGraficoEscenario.SetPenLastLine(const Value: TPen);
begin
  FPenLastLine := Value;
end;

procedure TGraficoEscenario.SetShowMedia(const Value: boolean);
begin
  FShowMedia := Value;
  TDatosGraficoEscenario(Datos).ActivateEscenario(FShowMedia);
  Recalculate;
  InvalidateGrafico;
end;


procedure TGraficoEscenario.SetVerNube(const Value: boolean);
begin
  FVerNube := Value;
  InvalidateGrafico;
end;

{ TDatosGraficoEscenario }

procedure TDatosGraficoEscenario.ActivateEscenario(const multiple: boolean);
var i, num, j: integer;
  CambiosEscenario: PArrayCurrency;
begin
  if multiple then
    CambiosEscenario := FEscenarioMultiple.MediaEscenarios
  else
    CambiosEscenario := FEscenario.Cambios;
  num := UltimoIData + length(CambiosEscenario^);
  j := 0;
  for i := UltimoIData + 1 to num do begin
    FDatosEscenario[i] := CambiosEscenario^[j];
    inc(j);
  end;
  inherited SetData(@FDatosEscenario, @FFechasEscenario);
end;

procedure TDatosGraficoEscenario.Borrar;
var i, num, ini: integer;
begin
  ini := length(FDatosEscenario) - 1;
  num := ini - NUM_CAMBIOS_DEFAULT + 1;
  for i := ini downto num do
    FDatosEscenario[i] := SIN_CAMBIO;

  FEscenario := nil;
  FEscenarioMultiple := nil;
  YEscenariosMultiplesTransformado := nil;

  //Se debe realizar el SetData para que se vuelvan a calcular los datos, ya
  //que ahora han cambiado. Es muy importante que recalcule el IsSinCambio (que
  //se hace en el SetData), sino se cree que hay cambio en la parte del escenario
  //(que está borrado), con lo cual al hacer clic sobre la parte del escenario o
  //al pulsar End daría error, ya que se intentaría posicionar sobre un cambio
  //que ya no existe
  inherited SetData(@FDatosEscenario, @FFechasEscenario);
end;

procedure TDatosGraficoEscenario.RecalculateTransformados(const fromPos,
  toPos: integer);
var i, j, num, numEscenarios, izq: integer;
  DatosGrafico: TDatosGrafico;
begin
  inherited RecalculateTransformados(fromPos, toPos);
  if YEscenariosMultiplesTransformado <> nil then begin
    DatosGrafico := TDatosGrafico.Create;
    try
      if UltimoIData < toPos then begin
        if fromPos > UltimoIData then
          izq := 0
        else
          izq := XTransformados[UltimoIData];
        DatosGrafico.MaximoManual := FMax;
        DatosGrafico.MinimoManual := FMin;
        DatosGrafico.Left := izq;
        DatosGrafico.Top := 0;
        DatosGrafico.Ancho := Ancho;
        DatosGrafico.Alto := Alto;
        numEscenarios := FEscenarioMultiple.NumEscenarios - 1;
        for i := 0 to numEscenarios do begin
          //calculo.
          DatosGrafico.SetData(FEscenarioMultiple.PCambiosEscenario[i], nil);
          DatosGrafico.Recalculate(0, DatosGrafico.DataCount - 1);
          num := length(FEscenarioMultiple.PCambiosEscenario[i]^) - 1;
          for j := 0 to num do begin
            YEscenariosMultiplesTransformado[i][j] := {calculo.}DatosGrafico.YTransformados[j];
          end;
        end;
      end;
    finally
      DatosGrafico.Free;
    end;
  end;
end;

procedure TDatosGraficoEscenario.SetData(const PCambios: PArrayCurrency;
  const PFechas: PArrayDate);
var i, num, total: integer;
  fecha: TDate;
  diaSemana: Word;
  diario: boolean;
begin
  num := length(PCambios^);
  total := num + NUM_CAMBIOS_DEFAULT;
  SetLength(FDatosEscenario, total);
  SetLength(FFechasEscenario, total);
  dec(num); //zero based
  for i := 0 to num do begin
    FDatosEscenario[i] := PCambios^[i];
    FFechasEscenario[i] := PFechas^[i];
  end;

  diario := Data.TipoCotizacion = tcDiaria;
  if diario then
    fecha := IncDay(FFechasEscenario[num], 1)
  else
    fecha := IncDay(FFechasEscenario[num], 7);
  dec(total); // zero based
  for i := num + 1 to total do begin
    FDatosEscenario[i] := SIN_CAMBIO;
    if diario then begin
      diaSemana := DayOfTheWeek(fecha);
      if diaSemana = DaySaturday then
        fecha := IncDay(fecha, 2)
      else
        if diaSemana = DaySunday then
          fecha := IncDay(fecha, 1);
      FFechasEscenario[i] := fecha;
      fecha := IncDay(fecha, 1);
    end
    else begin
      while DayOfTheWeek(fecha) <> DayFriday do
        fecha := IncDay(fecha, 1);
      FFechasEscenario[i] := fecha;
      fecha := IncDay(fecha, 7);
    end;
  end;

  FUltimoIData := num;
  inherited SetData(@FDatosEscenario, @FFechasEscenario);
end;

procedure TDatosGraficoEscenario.SetEscenarioMultiple(
  const Value: TEscenarioMultiple);
var numCambios, numEscenarios: integer;
begin
  FEscenarioMultiple := Value;
  if Value = nil then begin
    SetLength(YEscenariosMultiplesTransformado, 0);
  end
  else begin
    numCambios := FEscenarioMultiple.NumCambios;
    numEscenarios := FEscenarioMultiple.NumEscenarios;
    SetLength(YEscenariosMultiplesTransformado, numEscenarios, numCambios);
  end;
end;

end.
