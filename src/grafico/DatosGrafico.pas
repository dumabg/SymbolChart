unit DatosGrafico;

interface

uses Tipos, Controls;

const
  SIN_FECHA : TDate = 0;
  SIN_CAMBIO : integer = Low(integer);
  SIN_CAMBIO_TRANSFORMADO: integer = Low(integer);

type
  TDatosGrafico = class
  private
    FPCambios: PArrayCurrency;
    FPFechas: PArrayDate;
    FXTransformados, FYTransformados: TArrayInteger;
    FIsSinCambios: TArrayBoolean;
    FIsDataNulls: TArrayBoolean;
    FIsCambios: TArrayBoolean;
    FAncho: integer;
    FAlto: integer;
    FTop: integer;
    FDataCount: integer;
    FLeft: Integer;
    FPixelSize: byte;
    FDataSinCambio: integer;
    FDataNull: integer;
    FMaximoManual: currency;
    FMinimoManual: currency;
    function GetPXTransformados: PArrayInteger; inline;
    function GetCambio(index: integer): currency; inline;
    function GetFechas(index: integer): TDate; inline;
    function GetIsCambio(index: integer): boolean; inline;
    function GetIsDataNull(index: integer): boolean; inline;
    function GetIsSinCambio(index: integer): boolean; inline;
    function GetXTransformados(index: integer): integer; inline;
    function GetYTransformados(index: integer): integer; inline;
    function GetPYTransformados: PArrayInteger; inline;
    procedure SetDataSinCambio(const Value: integer);
  protected
    FMax, FMin: currency;
  public
    constructor Create;
    procedure RecalculateMaxMin(const fromPos, toPos: integer); virtual;    
    procedure SetData(const PCambios: PArrayCurrency; const PFechas: PArrayDate); virtual;
    procedure RecalculateTransformados(const fromPos, toPos: integer); overload; virtual;
    procedure RecalculateTransformados; overload;
    procedure Recalculate(const fromPos, toPos: integer); overload;
    procedure Recalculate; overload;
    procedure Clear;
    property DataCount: integer read FDataCount;
    property PCambios: PArrayCurrency read FPCambios;
    property PFechas: PArrayDate read FPFechas;
    property PXTransformados: PArrayInteger read GetPXTransformados;
    property PYTransformados: PArrayInteger read GetPYTransformados;
    property Cambio[index: integer]: currency read GetCambio;
    property Fechas[index: integer]: TDate read GetFechas;
    property IsDataNull[index: integer]: boolean read GetIsDataNull;
    property IsSinCambio[index: integer]: boolean read GetIsSinCambio;
    property IsCambio[index: integer]: boolean read GetIsCambio;
    property XTransformados[index: integer]: integer read GetXTransformados;
    property YTransformados[index: integer]: integer read GetYTransformados;
    property DataNull: integer read FDataNull write FDataNull;
    property DataSinCambio: integer read FDataSinCambio write SetDataSinCambio;
    property Maximo: currency read FMax;
    property Minimo: currency read FMin;
    property MaximoManual: currency read FMaximoManual write FMaximoManual;
    property MinimoManual: currency read FMinimoManual write FMinimoManual;
    property Ancho: integer read FAncho write FAncho;
    property Alto: integer read FAlto write FAlto;
    property Left: Integer read FLeft write FLeft;
    property Top: integer read FTop write FTop;
    property PixelSize: byte read FPixelSize write FPixelSize default 1;
  end;

implementation

{ TDatosGrafico }

procedure TDatosGrafico.Clear;
begin
  FPCambios := nil;
  FPFechas := nil;
  FDataCount := 0;

  SetLength(FXTransformados, 0);
  SetLength(FYTransformados, 0);

  SetLength(FIsSinCambios, 0);
  SetLength(FIsDataNulls, 0);
  SetLength(FIsCambios, 0);
end;

constructor TDatosGrafico.Create;
begin
  inherited;
  FPixelSize := 1;
  FDataNull := 0;
  FDataCount := 0;
  FPCambios := nil;
  FDataSinCambio := SIN_CAMBIO;
  FMaximoManual := SIN_CAMBIO;
  FMinimoManual := SIN_CAMBIO;
end;

function TDatosGrafico.GetCambio(index: integer): currency;
begin
  result := FPCambios^[index];
end;

function TDatosGrafico.GetFechas(index: integer): TDate;
begin
  result := FPFechas^[index];
end;

function TDatosGrafico.GetIsCambio(index: integer): boolean;
begin
  result := FIsCambios[index];
end;

function TDatosGrafico.GetIsDataNull(index: integer): boolean;
begin
  result := FIsDataNulls[index];
end;

function TDatosGrafico.GetIsSinCambio(index: integer): boolean;
begin
  result := FIsSinCambios[index];
end;

function TDatosGrafico.GetPXTransformados: PArrayInteger;
begin
  result := @FXTransformados;
end;

function TDatosGrafico.GetPYTransformados: PArrayInteger;
begin
  Result := @FYTransformados;
end;

function TDatosGrafico.GetXTransformados(index: integer): integer;
begin
  result := FXTransformados[index];
end;

function TDatosGrafico.GetYTransformados(index: integer): integer;
begin
  result := FYTransformados[index];
end;

procedure TDatosGrafico.Recalculate(const fromPos, toPos: integer);
begin
  RecalculateMaxMin(fromPos, toPos);
  RecalculateTransformados(fromPos, toPos);
end;

procedure TDatosGrafico.Recalculate;
begin
  Recalculate(0, DataCount - 1);
end;

procedure TDatosGrafico.RecalculateMaxMin(const fromPos, toPos: integer);
var i: integer;
  dato: currency;
begin
  if MaximoManual <> FDataSinCambio then begin
    FMax := FMaximoManual;
    FMin := FMinimoManual;
  end
  else begin
    FMax := FDataSinCambio;
    FMin := FDataSinCambio;
    for i := fromPos to toPos do begin
      dato := FPCambios^[i];
      if (dato = FDataNull) or (dato = FDataSinCambio) then begin
        // No creamos un and para que vaya más rápido
      end
      else begin
        if FMin = FDataSinCambio then
          FMin := dato
        else begin
          if dato < FMin then
            FMin := dato;
        end;
        if FMax < dato then
          FMax := dato;
      end;
    end;
  end;
end;

procedure TDatosGrafico.RecalculateTransformados;
begin
  RecalculateTransformados(0, DataCount - 1);
end;

procedure TDatosGrafico.RecalculateTransformados(const fromPos, toPos: integer);
var i, lon: integer;
  den, min, dato: currency;
  anchoDivLon, altoDivDen: Double;
  altoMasPaddingTop, auxTo: integer;
begin
  min := Minimo;
  den := Maximo - min;
  lon := toPos - fromPos + 1;
  anchoDivLon := (Ancho div PixelSize) / lon;
  altoDivDen := Alto / den;
  // + 4 porque sino cuando estás posicionado en el máximo, el cursor se ve cortado,
  // ya que sale del gráfico, al igual que el indicador de la derecha del cambio
  altoMasPaddingTop := Alto + Top + 4;
  auxTo := toPos;
  if toPos < DataCount - 1 then
    inc(auxTo);
  if auxTo >= DataCount then
    auxTo := DataCount - 1;
  for i := fromPos to auxTo do begin
    FXTransformados[i] := Round((i - fromPos) * anchoDivLon) * PixelSize + left;
    dato := PCambios^[i];
    if dato = FDataNull then
      FYTransformados[i] := FDataNull
    else begin
      if dato = FDataSinCambio then
        FYTransformados[i] := FDataSinCambio
      else begin
        if den = 0 then
          FYTransformados[i] := 0
        else begin
        // Si Maximo - Minimo --> alto
        //    valor  - Minimo   --> ?
          FYTransformados[i] := altoMasPaddingTop - Round((dato - min) * altoDivDen);
        end;
      end;
    end;
  end;
end;

procedure TDatosGrafico.SetData(const PCambios: PArrayCurrency;
  const PFechas: PArrayDate);
var i: integer;
begin
  FPCambios := PCambios;
  FPFechas := PFechas;
  FDataCount := length(FPCambios^);

  SetLength(FXTransformados, FDataCount);
  SetLength(FYTransformados, FDataCount);

  SetLength(FIsSinCambios, FDataCount);
  SetLength(FIsDataNulls, FDataCount);
  SetLength(FIsCambios, FDataCount);
  for i := FDataCount - 1 downto 0 do begin
    FIsSinCambios[i] := FPCambios^[i] = FDataSinCambio;
    FIsDataNulls[i] := FPCambios^[i] = FDataNull;
    FIsCambios[i] := (not FIsDataNulls[i]) and (not FIsSinCambios[i]);
  end;
end;

procedure TDatosGrafico.SetDataSinCambio(const Value: integer);
begin
  FDataSinCambio := Value;
  if FMaximoManual = SIN_CAMBIO then
    FMaximoManual := FDataSinCambio;
  if FMinimoManual = SIN_CAMBIO then
    FMinimoManual := FDataSinCambio;
end;

end.
