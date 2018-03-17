unit Escenario;

interface

uses Tipos;

const
   NUM_CAMBIOS_DEFAULT = 134;

type
  TDiaAnterior = (daHaSubido, daHaBajado, daIgual);

  TEscenario = class
  private
    FCambios: TArrayCurrency;
    FMin: currency;
    FMax: currency;
    FSintonizacion: integer;
    FDistanciaMin: integer;
    FDistanciaMax: integer;
    FDesviacionSintonizacion: currency; // (Objetivo máximo - cambio actual / cambio actual) * 100;
    function GetCambio(i: integer): currency; inline;
    function GetCambios: PArrayCurrency; inline;
  protected
    constructor Create(numCambios: integer);
  public
    property DesviacionSintonizacion: currency read FDesviacionSintonizacion;
    property Sintonizacion: integer read FSintonizacion;
    property Cambios: PArrayCurrency read GetCambios;
    property Max: currency read FMax;
    property Min: currency read FMin;
    property DistanciaMax: integer read FDistanciaMax;
    property DistanciaMin: integer read FDistanciaMin;
    property Cambio[i: integer]: currency read GetCambio;
  end;


  TEscenarioMultiple = class
  private
    FNitidezMinima: integer;
    FNumCambios: integer;
    FNumEscenarios: integer;
    FCoeficienteVariacionMin: currency;
    FCoeficienteVariacionMax: currency;
    FBandaAltaMax: currency;
    FBandaAltaMin: currency;
    FBandaBajaMax: currency;
    FBandaBajaMin: currency;
    FMediaEscenarios: TArrayCurrency;
    FIntentos: integer;
    FNitidezEscenarios: currency;
    FCambiosEscenarios: array of TArrayCurrency;
    maxEscenarios, minEscenarios: TArrayCurrency;
    FRiesgo: currency;
    FPlusvaliaMaxima: currency;
    FObjetivoMaximo: currency;
    FObjetivoMinimo: currency;
    FMaxMediaEscenarios: currency;
    FMinMediaEscenarios: currency;
    FMaxOptimista: currency;
    FMinPesimista: currency;
    function GetMediaEscenario(i: integer): currency; inline;
    function GetCambioEscenario(i, j: integer): currency; inline;
    function GetPCambiosEscenario(i: integer): PArrayCurrency;
    function GetMediaEscenarios: PArrayCurrency;
  protected
  public
    property NitidezMinima: integer read FNitidezMinima; // Nitidez mínima deseada
    property NitidezEscenarios: currency read FNitidezEscenarios; // Nitidez que se ha obtenido
    property NumCambios: integer read FNumCambios;
    property NumEscenarios: integer read FNumEscenarios;
    property Intentos: integer read FIntentos write FIntentos; // Num intentos antes de bajar la nitidez
    property ObjetivoMaximo: currency read FObjetivoMaximo;
    property ObjetivoMinimo: currency read FObjetivoMinimo;
    property CoeficienteVariacionMin: currency read FCoeficienteVariacionMin;
    property CoeficienteVariacionMax: currency read FCoeficienteVariacionMax;
    property BandaBajaMax: currency read FBandaBajaMax;
    property BandaAltaMax: currency read FBandaAltaMax;
    property BandaBajaMin: currency read FBandaBajaMin;
    property BandaAltaMin: currency read FBandaAltaMin;
    property MaxOptimista: currency read FMaxOptimista;
    property MinPesimista: currency read FMinPesimista;
    property MaxMediaEscenarios: currency read FMaxMediaEscenarios;
    property MinMediaEscenarios: currency read FMinMediaEscenarios;
    property PlusvaliaMaxima: currency read FPlusvaliaMaxima;
    property Riesgo: currency read FRiesgo;
    property MediaEscenario[i: integer]: currency read GetMediaEscenario;
    property MediaEscenarios: PArrayCurrency read GetMediaEscenarios;
    property CambioEscenario[i, j: integer]: currency read GetCambioEscenario;
    property PCambiosEscenario[i: integer]: PArrayCurrency read GetPCambiosEscenario;
  end;

  TEscenarioCreatorBase = class abstract
  private
    FCambios: PArrayCurrency;
    Cancelado: boolean;
    NumSesiones: integer;
    procedure SetCambios(const Value: PArrayCurrency);
  protected
    procedure GetRandomValorValorAnt(var valor, valorAnt: currency);
    function GetDiaAnterior: TDiaAnterior;
    function GetPorcentaje: currency;
    function GetValor(valor: currency): currency;
    function GetUltimoValorGrafico: currency; inline;
  public
    constructor Create;
    property Cambios: PArrayCurrency read FCambios write SetCambios;
    procedure Cancelar;
    procedure Initialize; virtual;
  end;

  TEscenarioMultipleCreator = class(TEscenarioCreatorBase)
  private
    FEscenarioMultiple: TEscenarioMultiple;
    procedure InternalCrearEscenarioMultiple;
  public
    procedure Initialize; override;
    procedure CrearEscenarioMultiple; overload;
    procedure CrearEscenarioMultiple(NitidezMinima: integer; NumCambios: integer;
      NumEscenarios: integer; Intentos: integer); overload;
    property EscenarioMultiple: TEscenarioMultiple read FEscenarioMultiple;
  end;

  TEscenarioCreator = class(TEscenarioCreatorBase)
  private
    FSintonizacion: integer;
    FIntentosSintonizacion: integer;
    FDesviacionSintonizacion: currency;
    FEscenario: TEscenario;
    FNoEncontrado: boolean;
  public
    procedure CrearEscenario(const EscenarioMultiple: TEscenarioMultiple);
    procedure Initialize; override;
    property Sintonizacion: integer read FSintonizacion write FSintonizacion;
    property IntentosSintonizacion: integer read FIntentosSintonizacion write FIntentosSintonizacion;
    property DesviacionSintonizacion: currency read FDesviacionSintonizacion write FDesviacionSintonizacion;
    property Escenario: TEscenario read FEscenario;
    property NoEncontrado: boolean read FNoEncontrado;
  end;

implementation

uses util, calculos, dialogs, forms, SysUtils, DatosGrafico;

const
   NITIDEZ_MINIMA_DEFAULT = 30;
   NUM_ESCENARIOS_DEFAULT = 33;
   NUM_INTENTOS_DEFAULT = 50;

{ TEscenario }

constructor TEscenario.Create(numCambios: integer);
begin
  inherited Create;
  SetLength(FCambios, numCambios);
end;

function TEscenario.GetCambio(i: integer): currency;
begin
  result := FCambios[i];
end;


function TEscenario.GetCambios: PArrayCurrency;
begin
  result := @FCambios;
end;


function TEscenarioMultiple.GetCambioEscenario(i, j: integer): currency;
begin
  result := FCambiosEscenarios[i, j];
end;

function TEscenarioMultiple.GetPCambiosEscenario(i: integer): PArrayCurrency;
begin
  result := @FCambiosEscenarios[i];
end;

function TEscenarioMultiple.GetMediaEscenario(i: integer): currency;
begin
  result := FMediaEscenarios[i];
end;

function TEscenarioMultiple.GetMediaEscenarios: PArrayCurrency;
begin
  result := @FMediaEscenarios;
end;

{ TEscenarioCreator }

procedure TEscenarioCreatorBase.Cancelar;
begin
  cancelado := true;
end;

constructor TEscenarioCreatorBase.Create;
begin
  inherited;
  Initialize;
end;

function TEscenarioCreatorBase.GetDiaAnterior: TDiaAnterior;
var valor, valorAnt: currency;
begin
  GetRandomValorValorAnt(valor, valorAnt);
  if valor > valorAnt then
    result := daHaSubido
  else
    if valor < valorAnt then
      result := daHaBajado
    else
      result := daIgual;
end;

function TEscenarioCreatorBase.GetPorcentaje: currency;
var valor, valorAnt: currency;
begin
  GetRandomValorValorAnt(valor, valorAnt);
  if valor < valorAnt then
    result := (valor / valorAnt - 1) * 100
  else
    result := (valorAnt / valor - 1) * 100;
end;

procedure TEscenarioCreatorBase.GetRandomValorValorAnt(var valor,
  valorAnt: currency);
var i: integer;
begin
  i := Random(NumSesiones - 1) + 1;
  valor := Cambios^[i];
  valorAnt := Cambios^[i - 1];
end;

function TEscenarioCreatorBase.GetUltimoValorGrafico: currency;
begin
  result := Cambios^[NumSesiones - 1];
end;

function TEscenarioCreatorBase.GetValor(valor: currency): currency;
var porcentaje: currency;
begin
  case GetDiaAnterior of
    daHaSubido : begin
                 porcentaje := GetPorcentaje;
                 result := valor - (valor * porcentaje / 100);
                 end;
    daHaBajado : begin
                 porcentaje := GetPorcentaje;
                 result := valor + (valor * porcentaje / 100);
                 end;
    else result := valor;
  end;
end;

procedure TEscenarioCreatorBase.Initialize;
begin
  Cancelado := False;
end;

procedure TEscenarioCreatorBase.SetCambios(const Value: PArrayCurrency);
begin
  FCambios := Value;
  NumSesiones := length(FCambios^);
end;

{ TEscenarioCreator }

procedure TEscenarioCreator.CrearEscenario(
  const EscenarioMultiple: TEscenarioMultiple);
var
  i, num: integer;
  valor: currency;
  salir: boolean;
  max, min: currency;
  maxMedia: currency;
  minMedia: currency;
  cambioActual: currency;
  intentos: integer;
  A,B,C,D,X,M: currency;
  distanciaMax, distanciaMin: integer;
  numCambios: integer;
  auxSintonizacion: integer;

    function EstaSintonizado(PCambios: PArrayCurrency): boolean;
    var salir: boolean;
      pos, sinPos, sint: integer;
      valor, perCent: currency;
    begin
      pos := 0;
      result := true;
      sinPos := Low(PCambios^) + auxSintonizacion - 1;
      sint := auxSintonizacion;
      salir := false;
      while not salir do begin
        if cancelado then
          raise EAbort.Create('Escenario cancelado');
        valor := PCambios^[pos];
//        inc(pos);
        perCent := abs(PCambios^[sinPos] / valor - 1) * 100;
        result := (result) and (perCent <= DesviacionSintonizacion);
        dec(sint);
        dec(sinPos);
        inc(pos);
        salir := not ((result) and (sint > 0));
      end;
    end;

begin
  intentos := IntentosSintonizacion;
  auxSintonizacion := Sintonizacion;
  FEscenario := TEscenario.Create(EscenarioMultiple.FNumCambios);
  salir := false;
  cambioActual := GetUltimoValorGrafico;
  num := 1;

  maxMedia := calculos.maximo(EscenarioMultiple.FMediaEscenarios);
  minMedia := calculos.minimo(EscenarioMultiple.FMediaEscenarios);
  numCambios := EscenarioMultiple.FNumCambios - 1; //zero based
  while not salir do begin
    if cancelado then
      raise EAbort.Create('Escenario cancelado');
    // Tiramos un escenario
    valor := cambioActual;
    max := valor;
    min := valor;
    for i := 0 to numCambios do begin
      valor := GetValor(valor);
      FEscenario.FCambios[i] := valor;
      if valor > max then begin
        max := valor;
      end;
      if valor < min then begin
        min := valor;
      end;
    end;


  // Para que sea un escenario válido, debe cumplir:
{Banda baja máximo = A
Máximo media 33    = B
Banda alta mínimo   = C
mínimo media 33     = D
------(Resultados)-----------
Maximo del fractal   = X
mínimo del fractal    = M}

    A := EscenarioMultiple.BandaAltaMin;
    B := maxMedia;
    C := EscenarioMultiple.BandaBajaMax;
    D := minMedia;
    X := max;
    M := min;

{Si (A>B y C>D) y (X<=A y X>=B) y (M<=C y M>=D)
Si (A>B y C<D) y (X<=A y X>=B) y (M<=D y M>=C)
Si (A<B y C>D) y (X<=B y X>=A) y (M<=C y M>=D)
Si (A<B y C<D) y (X<=B y X>=A) y (M<=D y M>=C)}


  salir :=
   ((A>B) and (C>D) and (X<=A) and (X>=B) and (M<=C) and (M>=D)) or
   ((A>B) and (C<D) and (X<=A) and (X>=B) and (M<=D) and (M>=C)) or
   ((A<B) and (C>D) and (X<=B) and (X>=A) and (M<=C) and (M>=D)) or
   ((A<B) and (C<D) and (X<=B) and (X>=A) and (M<=D) and (M>=C));

    if salir then begin
      if auxSintonizacion > 0 then begin
        salir := EstaSintonizado(@FEscenario.FCambios);
      end;
    end;

    if not salir then begin
      Inc(num);
      if intentos = num then begin
        salir := auxSintonizacion = 0;
        if salir then begin
          FNoEncontrado := true;
        end
        else begin
          dec(auxSintonizacion);
          intentos := IntentosSintonizacion;
          num := 0;
        end;
      end;
    end;
  end;

  if FNoEncontrado then begin
    FreeAndNil(FEscenario);
  end
  else begin
    FEscenario.FSintonizacion := auxSintonizacion;
    FEscenario.FDesviacionSintonizacion := DesviacionSintonizacion;
    // Borramos los sintonizados
  //  FEscenario.FCambios := Copy(FEscenario.FCambios, auxSintonizacion, numCambios + 1);
    numCambios := numCambios - auxSintonizacion;
//    Move(FEscenario.FCambios[auxSintonizacion], FEscenario.FCambios[0], numCambios + 1);
    for i := 0 to numCambios do
      FEscenario.FCambios[i] := FEscenario.FCambios[i + auxSintonizacion];
    for i := numCambios + 1 to Length(FEscenario.FCambios) - 1 do
      FEscenario.FCambios[i] := SIN_CAMBIO;

    valor := FEscenario.FCambios[0];
    distanciaMax := 1;
    distanciaMin := 1;
    max := valor;
    min := valor;
    for i := 0 to numCambios do begin
      valor := FEscenario.FCambios[i];
      if valor > max then begin
        max := valor;
        distanciaMax := i + 1;
      end;
      if valor < min then begin
        min := valor;
        distanciaMin := i + 1;
      end;
    end;
    FEscenario.FMin := min;
    FEscenario.FMax := max;
    FEscenario.FDistanciaMin := distanciaMin;
    FEscenario.FDistanciaMax := distanciaMax;
  end;
end;

procedure TEscenarioCreator.Initialize;
begin
  inherited;
  FEscenario := nil;
  FNoEncontrado := false;
end;

{ TEscenarioMultipleCreator }

procedure TEscenarioMultipleCreator.Initialize;
begin
  inherited;
  FEscenarioMultiple := nil;
end;

procedure TEscenarioMultipleCreator.InternalCrearEscenarioMultiple;
var auxIntentos, i, numCambios, numEscenarios, intentos: integer;
  valor, ultimoValorGrafico: currency;
  distanciaMaxEscenarios: array of currency;
  distanciaMinEscenarios: array of currency;
  salir: boolean;
  aux: currency;
  nitidez: currency;
  coeficienteCorrelacionMaximo: currency;

  procedure GenerarEscenarioMultiple;
  var i, j: integer;
  begin
    Randomize;

    inicializarArray(EscenarioMultiple.FMediaEscenarios);
//    inicializarArray(EscenarioMultiple.FCambiosEscenarios);

    for i:=0 to NumEscenarios - 1 do begin
      valor := ultimoValorGrafico;
      EscenarioMultiple.maxEscenarios[i] := valor;
      EscenarioMultiple.minEscenarios[i] := valor;
      distanciaMaxEscenarios[i] := 1;
      distanciaMinEscenarios[i] := 1;
      for j := 0 to numCambios - 1 do begin
        valor := GetValor(valor);
        EscenarioMultiple.FCambiosEscenarios[i, j] := valor;
        EscenarioMultiple.FMediaEscenarios[j] := valor + EscenarioMultiple.FMediaEscenarios[j];
        if valor > EscenarioMultiple.maxEscenarios[i] then begin
          EscenarioMultiple.maxEscenarios[i] := valor;
          distanciaMaxEscenarios[i] := j;
        end;
        if valor < EscenarioMultiple.minEscenarios[i] then begin
          EscenarioMultiple.minEscenarios[i] := valor;
          distanciaMinEscenarios[i] := j;
        end;
      end;
    end;
  end;

  function coeficienteVariacionCorrecto: boolean;
  begin
    EscenarioMultiple.FCoeficienteVariacionMin := coeficienteVariacion(EscenarioMultiple.minEscenarios);
    EscenarioMultiple.FCoeficienteVariacionMax := coeficienteVariacion(EscenarioMultiple.maxEscenarios);

    // Cada vegada que calculo, miro los coeficients de variació.
    // Si los 2 >= coeficienteCorrelacionMaximo torno a començar
    result := (EscenarioMultiple.FCoeficienteVariacionMin < coeficienteCorrelacionMaximo) and
              (EscenarioMultiple.FCoeficienteVariacionMax < coeficienteCorrelacionMaximo);
  end;

begin
  numCambios := EscenarioMultiple.FNumCambios;
  numEscenarios := EscenarioMultiple.FNumEscenarios;
  SetLength(EscenarioMultiple.FCambiosEscenarios, numEscenarios, numCambios);
  SetLength(EscenarioMultiple.FMediaEscenarios, numCambios);
//  inicializarArray(EscenarioMultiple.FMediaEscenarios);
  SetLength(EscenarioMultiple.maxEscenarios, numEscenarios);
  SetLength(EscenarioMultiple.minEscenarios, numEscenarios);
  SetLength(distanciaMaxEscenarios, numEscenarios);
  SetLength(distanciaMinEscenarios, numEscenarios);

  ultimoValorGrafico := GetUltimoValorGrafico;
  salir := false;
  intentos := EscenarioMultiple.FIntentos;
  auxIntentos := intentos;
  aux := -1;
  nitidez := EscenarioMultiple.FNitidezMinima;
  coeficienteCorrelacionMaximo := 0.2;
  while not salir do begin
    if cancelado then
      raise EAbort.Create('Escenario cancelado');
    GenerarEscenarioMultiple;
    aux := calculos.nitidez(distanciaMaxEscenarios, distanciaMinEscenarios);
    // Si la nitidez calculada és < que nitidez, torno a començar.
    salir := (abs(aux) >= nitidez) and (coeficienteVariacionCorrecto);
    if not salir then begin
      dec(auxIntentos);
      // Si al probar-ho FIntentos vegades sempre surt < FNitidez,
      //torno a començar però baixo la nitidez en 1.
      if auxIntentos = 0 then begin
        auxIntentos := intentos;
        nitidez := nitidez - 1;
        if nitidez = -1 then begin
          nitidez := EscenarioMultiple.FNitidezMinima;
          coeficienteCorrelacionMaximo := coeficienteCorrelacionMaximo + 0.1;
        end;
      end;
    end;
  end;
  for i := 0 to numCambios - 1 do
    EscenarioMultiple.FMediaEscenarios[i] := EscenarioMultiple.FMediaEscenarios[i] / numEscenarios;

  EscenarioMultiple.FNitidezEscenarios := aux;

// Mínims banda alta de Student-Fischer dels màxims dels 33 escenaris
  EscenarioMultiple.FBandaAltaMax := BandaAltaStudentFischer(EscenarioMultiple.maxEscenarios);
  EscenarioMultiple.FBandaAltaMin := BandaBajaStudentFischer(EscenarioMultiple.maxEscenarios);

// Màxims banda baja de Student-Fischer dels mínims dels 33 escenaris
  EscenarioMultiple.FBandaBajaMax := BandaAltaStudentFischer(EscenarioMultiple.minEscenarios);
  EscenarioMultiple.FBandaBajaMin := BandaBajaStudentFischer(EscenarioMultiple.minEscenarios);

  // (Banda baixa Bollinger del màxim + màxim de la mitja dels 33 escenaris) / 2
  EscenarioMultiple.FObjetivoMaximo := (EscenarioMultiple.BandaAltaMin +
    calculos.maximo(EscenarioMultiple.FMediaEscenarios)) / 2;
  EscenarioMultiple.FObjetivoMinimo := (EscenarioMultiple.BandaBajaMin +
    calculos.minimo(EscenarioMultiple.FMediaEscenarios)) / 2;

  EscenarioMultiple.FPlusvaliaMaxima := abs((EscenarioMultiple.ObjetivoMaximo / GetUltimoValorGrafico - 1) * 100);
  EscenarioMultiple.FRiesgo := abs((EscenarioMultiple.ObjetivoMinimo / GetUltimoValorGrafico - 1) * 100);
  EscenarioMultiple.FMaxMediaEscenarios := calculos.maximo(EscenarioMultiple.FMediaEscenarios);
  EscenarioMultiple.FMinMediaEscenarios := calculos.minimo(EscenarioMultiple.FMediaEscenarios);
  EscenarioMultiple.FMaxOptimista := (EscenarioMultiple.BandaAltaMax + EscenarioMultiple.BandaAltaMin) / 2;
  EscenarioMultiple.FMinPesimista := (EscenarioMultiple.BandaBajaMax + EscenarioMultiple.BandaBajaMin) / 2;
end;

procedure TEscenarioMultipleCreator.CrearEscenarioMultiple;
begin
  CrearEscenarioMultiple(NITIDEZ_MINIMA_DEFAULT,
    NUM_CAMBIOS_DEFAULT, NUM_ESCENARIOS_DEFAULT, NUM_INTENTOS_DEFAULT);
end;

procedure TEscenarioMultipleCreator.CrearEscenarioMultiple(NitidezMinima,
  NumCambios, NumEscenarios, Intentos: integer);
begin
  FEscenarioMultiple := TEscenarioMultiple.Create;
  FEscenarioMultiple.FNitidezMinima := NitidezMinima;
  FEscenarioMultiple.FNumCambios := NumCambios;
  FEscenarioMultiple.FNumEscenarios := NumEscenarios;
  FEscenarioMultiple.FIntentos := Intentos;
  InternalCrearEscenarioMultiple;
end;


end.
