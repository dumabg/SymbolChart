unit Script_Datos;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, Controls,
  Script_Mensaje, ScriptObject, IBDatabase, IBSQL, kbmMemTable,
  ScriptDataCacheVertical, ScriptDataCache, Contnrs, ScriptEngine;

type
  ESesionNotFound = class(Exception);

   {$METHODINFO ON}
  TTipoSesion = (tsDiaria, tsSemanal);

  TZona = (zSinZona = 0, zAMenos, zAMas, zABMenos, zABMas, zBMenos, zBMas, zOMenos, zOMas);

  TAmbienteIntradia = (aiSinAmbiente = 0, aiAlcistaContradiccionesSospechosas,
    aiContinuidadPlana, aiRetrocesoTecnico, aiReboteTecnico, aiLigeraPresionAlcista,
    aiBajadaMenorEsperada, aiPresionAlcista, aiDebilidadOrientadaBaja,
    aiPresionBajista, aiAlzaEnganosa, aiDebilidadOrientadaAlza, aiBajaEnganosa,
    aiPresionAlcistaCreciente, aiPresionAlcistaLatenteContenida,
    aiBajaSubirMas, aiDecididamenteAlcista, aiIndecisionBandazosAlzaBaja,
    aiVolatilidadInclinadaBaja, aiVolatilidadOrientadaAlza,
    aiContinuidadCiertaOrientacionBajista, aiPresionBajistaAumento,
    aiAlzaPresionBajistaLatente, aiIndefinicionMaxima, aiOrientacionBajistaContradicciones,
    aiIndefinicionDecantadaAlza, aiRepeticionPerspectivasBajistas,
    aiOrientacionClaramenteBajista);

  TDatos = class(TScriptObjectInstance)
  private
    DataCacheFactory: TScriptDataCacheFactory;
    Sesiones: array of integer;
    DatosSesionNum: TStringList;
    DatosToClean: TStringList;
    Cursor: TScriptDataCache;
    ScriptDatosEngine: TScriptEngine;
    procedure ClearDatosSesionNum;
    procedure ClearDatosToClean;
    procedure InitializeSesiones;
    function GetSesionNum(Index: Integer): TDatos;
    function GetIDSesion: integer;
    function GetIDValor: integer;
    function GetTipoSesion: TTipoSesion;
    procedure SetIDSesion(const Value: integer);
    procedure SetIDValor(const Value: integer);
    procedure SetTipoSesion(const Value: TTipoSesion);
  public
    constructor Create(const ScriptDatosEngine: TScriptEngine; const DataCacheFactory: TScriptDataCacheFactory);
    destructor Destroy; override;
    function Mensaje: TMensaje;
    function AmbienteIntradia: TAmbienteIntradia;
    function BandaAlta: currency;
    function BandaBaja: currency;
    function Cierre: currency;
    function Apertura: currency;
    function Volumen: integer;
    function CambioAlzaDoble: currency;
    function CambioAlzaSimple: currency;
    function CambioBajaDoble: currency;
    function CambioBajaSimple: currency;
    function Correlacion: integer;
    function DiasSeguidosNum: integer;
    function DiasSeguidosPerCent: single;
    function DimensionFractal: currency;
    function Dinero: currency;
    function DineroAlzaDoble: currency;
    function DineroAlzaSimple: currency;
    function DineroBajaDoble: currency;
    function DineroBajaSimple: currency;
    function Dobson10: integer;
    function Dobson100: integer;
    function Dobson130: integer;
    function Dobson40: integer;
    function Dobson70: integer;
    function DobsonAlto10: integer;
    function DobsonAlto100: integer;
    function DobsonAlto130: integer;
    function DobsonAlto40: integer;
    function DobsonAlto70: integer;
    function DobsonBajo10: integer;
    function DobsonBajo100: integer;
    function DobsonBajo130: integer;
    function DobsonBajo40: integer;
    function DobsonBajo70: integer;
    function Maximo: currency;
    function MaximoPrevisto: currency;
    function MaximoPrevistoAprox: single;
    function MaximoSePrevino: currency;
    function Media200: currency;
    function Minimo: currency;
    function MinimoPrevisto: currency;
    function MinimoPrevistoAprox: single;
    function MinimoSePrevino: currency;
    function DobsonNivelActual: integer;
    function DobsonNivelBaja: integer;
    function DobsonNivelSube: integer;
    function IDCotizacion: integer;
    function Papel: currency;
    function PapelAlzaDoble: currency;
    function PapelAlzaSimple: currency;
    function PapelBajaDoble: currency;
    function PapelBajaSimple: currency;
    function PercentAlzaSimple: currency;
    function PercentBajaSimple: currency;
    function PivotPoint: currency;
    function PivotPointR1: currency;
    function PivotPointR2: currency;
    function PivotPointR3: currency;
    function PivotPointS1: currency;
    function PivotPointS2: currency;
    function PivotPointS3: currency;
    function PotencialFractal: integer;
    function RentabilidadAbierta: single;
    function Rsi14: integer;
    function Rsi140: integer;
    function Stop: currency;
    function Posicionado: currency;
    function Variabilidad: single;
    function Variacion: single;
    function Volatilidad: single;
    function Zona: TZona;
    function ZonaAlzaDoble: TZona;
    function ZonaAlzaSimple: TZona;
    function ZonaBajaDoble: TZona;
    function ZonaBajaSimple: TZona;
    function Riesgo: Single;
    function PresionVertical: Single;
    function PresionVerticalAlzaSimple: Single;
    function PresionVerticalAlzaDoble: Single;
    function PresionVerticalBajaSimple: Single;
    function PresionVerticalBajaDoble: Single;
    function PresionLateral: Single;
    function PresionLateralAlzaSimple: Single;
    function PresionLateralAlzaDoble: Single;
    function PresionLateralBajaSimple: Single;
    function PresionLateralBajaDoble: Single;
  published
    property IDValor: integer read GetIDValor write SetIDValor;
    property IDSesion: integer read GetIDSesion write SetIDSesion;
    property TipoSesion: TTipoSesion read GetTipoSesion write SetTipoSesion;
  public
    property SesionNum[Index: Integer]: TDatos read GetSesionNum; default;
  end;
   {$METHODINFO OFF}

  TScriptDatos = class(TScriptObject)
  private
    ScriptMensaje: TScriptMensaje;
    FOIDSesion: integer;
    ScriptDataCacheFactory: TScriptDataCacheFactory;
    ScriptDatosEngine: TScriptEngine;
    FTipoSesion: TTipoSesion;
    function GetMensaje: TMensaje;
    procedure SetOIDSesion(const Value: integer);
    procedure SetTipoSesion(const Value: TTipoSesion);
    function GetOIDValor: Integer;
    procedure SetOIDValor(const Value: Integer);
    property Mensaje: TMensaje read GetMensaje;
  protected
    function GetScriptInstance: TScriptObjectInstance; override;
    function GetTipoSesion: TTipoSesion; virtual;
  public
    //No podemos pasar un TScriptDatosEngine porque sino se produce una referencia circular
    constructor Create(const scriptDatosEngine: TScriptEngine; const verticalCache: boolean); reintroduce;
    destructor Destroy; override;
    property OIDValor: Integer read GetOIDValor write SetOIDValor;
    property OIDSesion: integer read FOIDSesion write SetOIDSesion;
    property TipoSesion: TTipoSesion read GetTipoSesion write SetTipoSesion;
  end;


implementation

uses dmDataComun, Script, dmBD, dmDataComunSesion, UtilDB, ScriptDataCacheHorizontal,
  ScriptDatosEngine;

resourcestring
  NO_HAY_DATOS = 'No hay datos para el valor %s - %s en la fecha %s';
  SESION_NOT_FOUND = 'No se ha encontrado la sesión %d';

{ TScriptDatos }

//No podemos pasar un TScriptDatosEngine porque sino se produce una referencia circular
constructor TScriptDatos.Create(const scriptDatosEngine: TScriptEngine; const verticalCache: boolean);
begin
  inherited Create;
  FTipoSesion := tsDiaria;
  if verticalCache then
    ScriptDataCacheFactory := TScriptDataCacheVerticalFactory.Create
  else
    ScriptDataCacheFactory := TScriptDataCacheHorizontalFactory.Create;
  Self.ScriptDatosEngine := ScriptDatosEngine;
  ScriptMensaje := TScriptMensaje.Create;
end;

destructor TScriptDatos.Destroy;
begin
  ScriptMensaje.Free;
  inherited;
  // El inherited hará un Free del ObjectInstance, y ese ObjectInstance, que es un
  // TDatos, utiliza la referencia al ScriptDataCacheFactory para realizar un
  // ReleaseCursor, por lo que si no hacemos el Free del ScriptDataCacheFactory
  // después del inherited, habrá un access violation.
  ScriptDataCacheFactory.Free;
end;

function TScriptDatos.GetMensaje: TMensaje;
begin
  try
    ScriptMensaje.DataFlags := TDatos(FScriptInstance).Cursor.GetMensajeFlags;
    result := TMensaje(ScriptMensaje.ScriptInstance);
  except
    on e: EDatoNoEncontrado do begin
      raise;
    end;
    on e: Exception do begin
      result := nil;
    end;
  end;
end;

function TScriptDatos.GetOIDValor: Integer;
begin
  result := TDatos(FScriptInstance).Cursor.OIDValor;
end;

function TScriptDatos.GetScriptInstance: TScriptObjectInstance;
begin
  result := TDatos.Create(ScriptDatosEngine, ScriptDataCacheFactory);
end;

function TScriptDatos.GetTipoSesion: TTipoSesion;
begin
  result := FTipoSesion;
end;

procedure TScriptDatos.SetOIDSesion(const Value: integer);
begin
  FOIDSesion := Value;
  TDatos(FScriptInstance).IDSesion := Value;
end;

procedure TScriptDatos.SetOIDValor(const Value: Integer);
begin
  TDatos(FScriptInstance).IDValor := Value;
end;

procedure TScriptDatos.SetTipoSesion(const Value: TTipoSesion);
begin
  if FTipoSesion <> Value then begin
    FTipoSesion := Value;
    ScriptDataCacheFactory.InitializeCache;
  end;
end;

{ TDatos }


function TDatos.AmbienteIntradia: TAmbienteIntradia;
var ambiente: string;
  id: integer;
begin
  try
    ambiente := Cursor.GetAmbienteIntradia;
    if ambiente = '' then
      result := aiSinAmbiente
    else begin
      if ambiente = '0' then
        result := aiAlcistaContradiccionesSospechosas
       else begin
         id := Ord(ambiente[1]) - Ord('A') + 2; // + 2 --> A = aiContinuidadPlana = 2
         result := TAmbienteIntradia(id);
       end;
    end;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := aiSinAmbiente;
    end;
  end;
end;

function TDatos.Apertura: currency;
begin
  try
    result := Cursor.GetApertura;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.BandaAlta: currency;
begin
  try
    result := Cursor.GetBandaAlta;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.BandaBaja: currency;
begin
  try
    result := Cursor.GetBandaBaja;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.CambioAlzaDoble: currency;
begin
  try
    result := Cursor.GetCambioAlzaDoble;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.CambioAlzaSimple: currency;
begin
  try
    result := Cursor.GetCambioAlzaSimple;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.CambioBajaDoble: currency;
begin
  try
    result := Cursor.GetCambioBajaDoble;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.CambioBajaSimple: currency;
begin
  try
    result := Cursor.GetCambioBajaSimple;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.Cierre: currency;
begin
  try
    result := Cursor.GetCierre;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

procedure TDatos.ClearDatosSesionNum;
var i: integer;
begin
  for i := DatosSesionNum.Count - 1 downto 0 do
    DatosSesionNum.Objects[i].Free;
  DatosSesionNum.Clear;
end;

procedure TDatos.ClearDatosToClean;
var i: integer;
begin
  for i := DatosToClean.Count - 1 downto 0 do
    DatosToClean.Objects[i].Free;
  DatosToClean.Clear;
end;

function TDatos.Correlacion: integer;
begin
  try
    result := Cursor.GetCorrelacion;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

constructor TDatos.Create(const ScriptDatosEngine: TScriptEngine;
  const DataCacheFactory: TScriptDataCacheFactory);
begin
  inherited Create;
  Self.ScriptDatosEngine := ScriptDatosEngine;
  Self.DataCacheFactory := dataCacheFactory;
  Cursor := DataCacheFactory.GetCursor;
  DatosToClean := TStringList.Create;
end;

destructor TDatos.Destroy;
begin
  if DatosSesionNum <> nil then begin
    ClearDatosSesionNum;
    DatosSesionNum.Free;
  end;
  DataCacheFactory.ReleaseCursor(Cursor);
  ClearDatosToClean;
  DatosToClean.Free;
  inherited Destroy;
end;

function TDatos.DiasSeguidosNum: integer;
begin
  try
    result := Cursor.GetDiasSeguidosNum;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.DiasSeguidosPerCent: single;
begin
  try
    result := Cursor.GetDiasSeguidosPerCent;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.DimensionFractal: currency;
begin
  try
    result := Cursor.GetDimensionFractal;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.Dinero: currency;
begin
  try
    result := Cursor.GetDinero;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.DineroAlzaDoble: currency;
begin
  try
    result := Cursor.GetDineroAlzaDoble;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.DineroAlzaSimple: currency;
begin
  try
    result := Cursor.GetDineroAlzaSimple;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.DineroBajaDoble: currency;
begin
  try
    result := Cursor.GetDineroBajaDoble;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.DineroBajaSimple: currency;
begin
  try
    result := Cursor.GetDineroBajaSimple;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.Dobson10: integer;
begin
  try
    result := Cursor.GetDobson10;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.Dobson100: integer;
begin
  try
    result := Cursor.GetDobson100;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.Dobson130: integer;
begin
  try
    result := Cursor.GetDobson130;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.Dobson40: integer;
begin
  try
    result := Cursor.GetDobson40;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.Dobson70: integer;
begin
  try
    result := Cursor.GetDobson70;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.DobsonAlto10: integer;
begin
  try
    result := Cursor.GetDobsonAlto10;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.DobsonAlto100: integer;
begin
  try
    result := Cursor.GetDobsonAlto100;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.DobsonAlto130: integer;
begin
  try
    result := Cursor.GetDobsonAlto130;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.DobsonAlto40: integer;
begin
  try
    result := Cursor.GetDobsonAlto40;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.DobsonAlto70: integer;
begin
  try
    result := Cursor.GetDobsonAlto40;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.DobsonBajo10: integer;
begin
  try
    result := Cursor.GetDobsonBajo10;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.DobsonBajo100: integer;
begin
  try
    result := Cursor.GetDobsonBajo100;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.DobsonBajo130: integer;
begin
  try
    result := Cursor.GetDobsonBajo130;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.DobsonBajo40: integer;
begin
  try
    result := Cursor.GetDobsonBajo40;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.DobsonBajo70: integer;
begin
  try
    result := Cursor.GetDobsonBajo70;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.Maximo: currency;
begin
  try
    result := Cursor.GetMaximo;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.MaximoPrevisto: currency;
begin
  try
    result := Cursor.GetMaximoPrevisto;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.MaximoPrevistoAprox: single;
begin
  try
    result := Cursor.GetMaximoPrevistoAprox;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.MaximoSePrevino: currency;
begin
  try
    result := Cursor.GetMaximoSePrevino;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.Media200: currency;
begin
  try
    result := Cursor.GetMedia200;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.Mensaje: TMensaje;
begin
  try
    result := TScriptDatos(FScriptObject).Mensaje;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := nil;
    end;
  end;
end;

function TDatos.Minimo: currency;
begin
  try
    result := Cursor.GetMinimo;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.MinimoPrevisto: currency;
begin
  try
    result := Cursor.GetMinimoPrevisto;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.MinimoPrevistoAprox: single;
begin
  try
    result := Cursor.GetMinimoPrevistoAprox;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.MinimoSePrevino: currency;
begin
  try
    result := Cursor.GetMinimoSePrevino;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.DobsonNivelActual: integer;
var nivel: string;
begin
  try
    nivel := Cursor.GetNivelActual;
    if nivel = 'A' then
      result := 10
    else
      if nivel = '' then
        result := -1
      else
        result := StrToInt(nivel);
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.DobsonNivelBaja: integer;
var nivel: string;
begin
  try
    nivel := Cursor.GetNivelBaja;
    if nivel = 'A' then
      result := 10
    else
      if nivel = '' then
        result := -1
      else
        result := StrToInt(nivel);
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.DobsonNivelSube: integer;
var nivel: string;
begin
  try
    nivel := Cursor.GetNivelSube;
    if nivel = 'A' then
      result := 10
    else
      if nivel = '' then
        result := -1
      else
        result := StrToInt(nivel);
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.GetIDSesion: integer;
begin
  result := Cursor.OIDSesion;
end;

function TDatos.GetIDValor: integer;
begin
  result := Cursor.OIDValor;
end;

function TDatos.GetSesionNum(Index: Integer): TDatos;
var i, datosI: integer;
  scriptDatos: TScriptDatos;
  sI: string;
  verticalCache: boolean;

  function FindIndexIDSesion: integer;
  var i, num, OIDSesion: integer;
  begin
    num := Length(Sesiones) - 1;
    OIDSesion := IDSesion;
    for i := 0 to num do begin
      if Sesiones[i] = OIDSesion then begin
        result := i;
        Exit;
      end;
    end;
//    raise ESesionNotFound.Create(Format(SESION_NOT_FOUND, [OIDSesion]));
    result := -1;
  end;
begin
  if Length(Sesiones) = 0 then
    InitializeSesiones;
  i := FindIndexIDSesion - Index;
  if i < 0 then begin
    TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
    result := nil;
  end
  else begin
    verticalCache := DataCacheFactory is TScriptDataCacheVerticalFactory;
    sI := IntToStr(i);
    if verticalCache then begin
      datosI := DatosSesionNum.IndexOf(sI);
      if datosI >= 0 then begin
        scriptDatos := TScriptDatos(DatosSesionNum.Objects[datosI]);
        result := TDatos(scriptDatos.FScriptInstance);
      end
      else begin
        scriptDatos := TScriptDatos.Create(ScriptDatosEngine, verticalCache);
        result := TDatos(scriptDatos.FScriptInstance);
    //    result := TDatos.Create(ScriptDatosEngine, DataCacheFactory);
        result.SetIDValor(IDValor);
        result.SetIDSesion(Sesiones[i]);
        DatosSesionNum.AddObject(sI, scriptDatos);
      end;
    end
    else begin
      datosI := DatosToClean.IndexOf(sI);
      if datosI >= 0 then begin
        result := TDatos(DatosToClean.Objects[datosI]);
      end
      else begin
        result := TDatos.Create(ScriptDatosEngine, DataCacheFactory);
        DatosToClean.AddObject(sI, result);
        result.SetIDValor(IDValor);
        result.SetIDSesion(Sesiones[i]);
      end;
    end;
  end;
end;

function TDatos.GetTipoSesion: TTipoSesion;
begin
  result := TScriptDatos(FScriptObject).GetTipoSesion;
end;

function TDatos.IDCotizacion: integer;
begin
  try
    result := Cursor.GetIDCotizacion;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

procedure TDatos.InitializeSesiones;
var q: TIBSQL;
  i: Integer;
  field: TIBXSQLVAR;
begin
  q := TIBSQL.Create(nil);
  try
    q.Database := BD.GetNewDatabase(q, scdDatos, BD.BDDatos);
    q.SQL.Text := 'SELECT count(*) FROM SESION s, COTIZACION c where ' +
      '(c.OR_SESION = s.OID_SESION) and (not c.CIERRE is null) and (c.OR_VALOR=:OID_VALOR)';
    q.Params[0].AsInteger := IDValor;
    ExecQuery(q, false);
    SetLength(Sesiones, q.Fields[0].AsInteger);

    q.Close;
    q.SQL.Text := 'SELECT c.OR_SESION FROM SESION s, COTIZACION c where ' +
      '(c.OR_SESION = s.OID_SESION) and (not c.CIERRE is null) and (c.OR_VALOR=:OID_VALOR) order by s.fecha';
    q.Params[0].AsInteger := IDValor;
    ExecQuery(q, true);

    field := q.Fields[0];
    i := 0;
    while not q.EOF do begin
      Sesiones[i] := field.AsInteger;
      Inc(i);
      q.Next;
    end;
  finally
    q.Free;
  end;

  if DatosSesionNum = nil then
    DatosSesionNum := TStringList.Create
  else
    ClearDatosSesionNum;
  ClearDatosToClean;
end;

function TDatos.Papel: currency;
begin
  try
    result := Cursor.GetPapel;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PapelAlzaDoble: currency;
begin
  try
    result := Cursor.GetPapelAlzaDoble;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PapelAlzaSimple: currency;
begin
  try
    result := Cursor.GetPapelAlzaSimple;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PapelBajaDoble: currency;
begin
  try
    result := Cursor.GetPapelBajaDoble;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PapelBajaSimple: currency;
begin
  try
    result := Cursor.GetPapelBajaSimple;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PercentAlzaSimple: currency;
begin
  try
    result := Cursor.GetPercentAlzaSimple;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PercentBajaSimple: currency;
begin
  try
    result := Cursor.GetPercentBajaSimple;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PivotPoint: currency;
begin
  try
    result := Cursor.GetPivotPoint;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PivotPointR1: currency;
begin
  try
    result := Cursor.GetPivotPointR1;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PivotPointR2: currency;
begin
  try
    result := Cursor.GetPivotPointR2;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PivotPointR3: currency;
begin
  try
    result := Cursor.GetPivotPointR3;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PivotPointS1: currency;
begin
  try
    result := Cursor.GetPivotPointS1;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PivotPointS2: currency;
begin
  try
    result := Cursor.GetPivotPointS2;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PivotPointS3: currency;
begin
  try
    result := Cursor.GetPivotPointS3;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PotencialFractal: integer;
begin
  try
    result := Cursor.GetPotencialFractal;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PresionLateral: single;
begin
  try
    result := Cursor.GetPresionLateral;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PresionLateralAlzaDoble: single;
begin
  try
    result := Cursor.GetPresionLateralAlzaDoble;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PresionLateralAlzaSimple: single;
begin
  try
    result := Cursor.GetPresionLateralAlzaSimple;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PresionLateralBajaDoble: single;
begin
  try
    result := Cursor.GetPresionLateralBajaDoble;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PresionLateralBajaSimple: single;
begin
  try
    result := Cursor.GetPresionLateralBajaSimple;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PresionVertical: single;
begin
  try
    result := Cursor.GetPresionVertical;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PresionVerticalAlzaDoble: single;
begin
  try
    result := Cursor.GetPresionVerticalAlzaDoble;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PresionVerticalAlzaSimple: single;
begin
  try
    result := Cursor.GetPresionVerticalAlzaSimple;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PresionVerticalBajaDoble: single;
begin
  try
    result := Cursor.GetPresionVerticalBajaDoble;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.PresionVerticalBajaSimple: single;
begin
  try
    result := Cursor.GetPresionVerticalBajaSimple;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.RentabilidadAbierta: single;
begin
  try
    result := Cursor.GetRentabilidadAbierta;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.Riesgo: single;
begin
  try
    result := Cursor.GetRiesgo;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.Rsi14: integer;
begin
  try
    result := Cursor.GetRsi14;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.Rsi140: integer;
begin
  try
    result := Cursor.GetRsi140;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

procedure TDatos.SetIDSesion(const Value: integer);
begin
{  if DatosSesionNum <> nil then
    ClearDatosSesionNum;}
  Cursor.OIDSesion := Value;
end;

procedure TDatos.SetIDValor(const Value: integer);
begin
  if Cursor.OIDValor <> Value then
    SetLength(Sesiones, 0);
  Cursor.OIDValor := Value;
end;

procedure TDatos.SetTipoSesion(const Value: TTipoSesion);
begin

end;

function TDatos.Stop: currency;
begin
  try
    result := Cursor.GetStop;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.Posicionado: currency;
begin
  try
    result := Cursor.GetPosicionado;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.Variabilidad: single;
begin
  try
    result := Cursor.GetVariabilidad;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.Variacion: single;
begin
  try
    result := Cursor.GetVariacion;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.Volatilidad: single;
begin
  try
    result := Cursor.GetVolatilidad;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.Volumen: integer;
begin
  try
    result := Cursor.GetVolumen;
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := 0;
    end;
  end;
end;

function TDatos.Zona: TZona;
var z: string;
begin
  try
    z := Cursor.GetZona;
    if z = '' then
      result := zSinZona
    else
      result := TZona(StrToInt(z));
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := zSinZona;
    end;
  end;
end;

function TDatos.ZonaAlzaDoble: TZona;
var z: string;
begin
  try
    z := Cursor.GetZonaAlzaDoble;
    if z = '' then
      result := zSinZona
    else
      result := TZona(StrToInt(z));
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := zSinZona;
    end;
  end;
end;

function TDatos.ZonaAlzaSimple: TZona;
var z: string;
begin
  try
    z := Cursor.GetZonaAlzaSimple;
    if z = '' then
      result := zSinZona
    else
      result := TZona(StrToInt(z));
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := zSinZona;
    end;
  end;
end;

function TDatos.ZonaBajaDoble: TZona;
var z: string;
begin
  try
    z := Cursor.GetZonaBajaDoble;
    if z = '' then
      result := zSinZona
    else
      result := TZona(StrToInt(z));
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := zSinZona;
    end;
  end;
end;

function TDatos.ZonaBajaSimple: TZona;
var z: string;
begin
  try
    z := Cursor.GetZonaBajaSimple;
    if z = '' then
      result := zSinZona
    else
      result := TZona(StrToInt(z));
  except
    on e: EDatoNoEncontrado do begin
      TScriptDatosEngine(ScriptDatosEngine).OnEDatoNotFound;
      result := zSinZona;
    end;
  end;
end;

initialization
  RegisterEnumeration('TZona', TypeInfo(TZona));
  RegisterEnumeration('TAmbienteIntradia', TypeInfo(TAmbienteIntradia));
  RegisterEnumeration('TTipoSesion', TypeInfo(TTipoSesion));
end.
