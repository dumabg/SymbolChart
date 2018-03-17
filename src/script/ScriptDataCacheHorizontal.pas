unit ScriptDataCacheHorizontal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ScriptDataCache, dmThreadDataModule, DB, IBCustomDataSet, IBQuery,
  IBSQL;

type
  DataCacheInteger = record
    OIDSesion: Integer;
    Valor: integer;
  end;
  TArrayDataCacheInteger = array of DataCacheInteger;
  PArrayDataCacheInteger = ^TArrayDataCacheInteger;

  DataCacheCurrency = record
    OIDSesion: Integer;
    Valor: Currency;
  end;
  TArrayDataCacheCurrency = array of DataCacheCurrency;
  PArrayDataCacheCurrency = ^TArrayDataCacheCurrency;

  DataCacheSingle = record
    OIDSesion: Integer;
    Valor: Single;
  end;
  TArrayDataCacheSingle = array of DataCacheSingle;
  PArrayDataCacheSingle = ^TArrayDataCacheSingle;

  DataCacheString = record
    OIDSesion: Integer;
    Valor: string;
  end;
  TArrayDataCacheString = array of DataCacheString;
  PArrayDataCacheString = ^TArrayDataCacheString;


  TScriptDataCacheHorizontal = class(TScriptDataCache)
  protected
    procedure SetOIDValor(const Value: integer); override;
  public
    function GetIDCotizacion: integer; override;
    function GetCierre: currency; override;
    function GetApertura: currency; override;
    function GetVolumen: integer; override;
    function GetDiasSeguidosNum: integer; override;
    function GetDiasSeguidosPerCent: single; override;
    function GetMaximo: currency; override;
    function GetMinimo: currency; override;
    function GetVariacion: single; override;

    function GetMensajeFlags: integer; override;
    function GetAmbienteIntradia: string; override;
    function GetBandaAlta: currency; override;
    function GetBandaBaja: currency; override;
    function GetCorrelacion: integer; override;
    function GetDimensionFractal: currency; override;
    function GetDinero: currency; override;
    function GetDineroAlzaDoble: currency; override;
    function GetDineroAlzaSimple: currency; override;
    function GetDineroBajaDoble: currency; override;
    function GetDineroBajaSimple: currency; override;
    function GetDobson10: integer; override;
    function GetDobson100: integer; override;
    function GetDobson130: integer; override;
    function GetDobson40: integer; override;
    function GetDobson70: integer; override;
    function GetDobsonAlto10: integer; override;
    function GetDobsonAlto100: integer; override;
    function GetDobsonAlto130: integer; override;
    function GetDobsonAlto40: integer; override;
    function GetDobsonAlto70: integer; override;
    function GetDobsonBajo10: integer; override;
    function GetDobsonBajo100: integer; override;
    function GetDobsonBajo130: integer; override;
    function GetDobsonBajo40: integer; override;
    function GetDobsonBajo70: integer; override;
    function GetMaximoPrevisto: currency; override;
    function GetMaximoPrevistoAprox: single; override;
    function GetMaximoSePrevino: currency; override;
    function GetMedia200: currency; override;
    function GetMinimoPrevisto: currency; override;
    function GetMinimoPrevistoAprox: single; override;
    function GetMinimoSePrevino: currency; override;
    function GetNivelActual: string; override;
    function GetNivelBaja: string; override;
    function GetNivelSube: string; override;
    function GetPapel: currency; override;
    function GetPapelAlzaDoble: currency; override;
    function GetPapelAlzaSimple: currency; override;
    function GetPapelBajaDoble: currency; override;
    function GetPapelBajaSimple: currency; override;
    function GetPercentAlzaSimple: currency; override;
    function GetPercentBajaSimple: currency; override;
    function GetPivotPoint: currency; override;
    function GetPivotPointR1: currency; override;
    function GetPivotPointR2: currency; override;
    function GetPivotPointR3: currency; override;
    function GetPivotPointS1: currency; override;
    function GetPivotPointS2: currency; override;
    function GetPivotPointS3: currency; override;
    function GetPotencialFractal: integer; override;
    function GetRentabilidadAbierta: single; override;
    function GetRsi14: integer; override;
    function GetRsi140: integer; override;
    function GetStop: currency; override;
    function GetPosicionado: currency; override;
    function GetVariabilidad: single; override;
    function GetVolatilidad: single; override;
    function GetZona: string; override;
    function GetZonaAlzaDoble: string; override;
    function GetZonaAlzaSimple: string; override;
    function GetZonaBajaDoble: string; override;
    function GetZonaBajaSimple: string; override;
    function GetRiesgo: Single; override;
    function GetPresionVertical: Single; override;
    function GetPresionVerticalAlzaSimple: Single; override;
    function GetPresionVerticalAlzaDoble: Single; override;
    function GetPresionVerticalBajaSimple: Single; override;
    function GetPresionVerticalBajaDoble: Single; override;
    function GetPresionLateral: Single; override;
    function GetPresionLateralAlzaSimple: Single; override;
    function GetPresionLateralAlzaDoble: Single; override;
    function GetPresionLateralBajaSimple: Single; override;
    function GetPresionLateralBajaDoble: Single; override;
    function GetCambioAlzaSimple: currency; override;
    function GetCambioAlzaDoble: currency; override;
    function GetCambioBajaSimple: currency; override;
    function GetCambioBajaDoble: currency; override;
  end;

  TScriptDataCacheHorizontalFactory = class(TScriptDataCacheFactory)
  private
    criticalSection: TRTLCriticalSection;
    lastOIDSesion: integer;
    FOIDValor: integer;
    IDCotizacionCache: TArrayDataCacheInteger;
    CierreCache: TArrayDataCacheCurrency;
    AperturaCache: TArrayDataCacheCurrency;
    VolumenCache: TArrayDataCacheInteger;
    DiasSeguidosNumCache: TArrayDataCacheInteger;
    DiasSeguidosPerCentCache: TArrayDataCacheSingle;
    MaximoCache: TArrayDataCacheCurrency;
    MinimoCache: TArrayDataCacheCurrency;
    VariacionCache: TArrayDataCacheSingle;
    MensajeFlagsCache: TArrayDataCacheInteger;
    AmbienteIntradiaCache: TArrayDataCacheString;
    BandaAltaCache: TArrayDataCacheCurrency;
    BandaBajaCache: TArrayDataCacheCurrency;
    CorrelacionCache: TArrayDataCacheInteger;
    DimensionFractalCache: TArrayDataCacheCurrency;
    DineroCache: TArrayDataCacheCurrency;
    DineroAlzaDobleCache: TArrayDataCacheCurrency;
    DineroAlzaSimpleCache: TArrayDataCacheCurrency;
    DineroBajaDobleCache: TArrayDataCacheCurrency;
    DineroBajaSimpleCache: TArrayDataCacheCurrency;
    Dobson10Cache: TArrayDataCacheInteger;
    Dobson100Cache: TArrayDataCacheInteger;
    Dobson130Cache: TArrayDataCacheInteger;
    Dobson40Cache: TArrayDataCacheInteger;
    Dobson70Cache: TArrayDataCacheInteger;
    DobsonAlto10Cache: TArrayDataCacheInteger;
    DobsonAlto100Cache: TArrayDataCacheInteger;
    DobsonAlto130Cache: TArrayDataCacheInteger;
    DobsonAlto40Cache: TArrayDataCacheInteger;
    DobsonAlto70Cache: TArrayDataCacheInteger;
    DobsonBajo10Cache: TArrayDataCacheInteger;
    DobsonBajo100Cache: TArrayDataCacheInteger;
    DobsonBajo130Cache: TArrayDataCacheInteger;
    DobsonBajo40Cache: TArrayDataCacheInteger;
    DobsonBajo70Cache: TArrayDataCacheInteger;
    MaximoPrevistoCache: TArrayDataCacheCurrency;
    MaximoPrevistoAproxCache: TArrayDataCacheSingle;
    MaximoSePrevinoCache: TArrayDataCacheCurrency;
    Media200Cache: TArrayDataCacheCurrency;
    MinimoPrevistoCache: TArrayDataCacheCurrency;
    MinimoPrevistoAproxCache: TArrayDataCacheSingle;
    MinimoSePrevinoCache: TArrayDataCacheCurrency;
    NivelActualCache: TArrayDataCacheString;
    NivelBajaCache: TArrayDataCacheString;
    NivelSubeCache: TArrayDataCacheString;
    PapelCache: TArrayDataCacheCurrency;
    PapelAlzaDobleCache: TArrayDataCacheCurrency;
    PapelAlzaSimpleCache: TArrayDataCacheCurrency;
    PapelBajaDobleCache: TArrayDataCacheCurrency;
    PapelBajaSimpleCache: TArrayDataCacheCurrency;
    PercentAlzaSimpleCache: TArrayDataCacheCurrency;
    PercentBajaSimpleCache: TArrayDataCacheCurrency;
    PivotPointCache: TArrayDataCacheCurrency;
    PivotPointR1Cache: TArrayDataCacheCurrency;
    PivotPointR2Cache: TArrayDataCacheCurrency;
    PivotPointR3Cache: TArrayDataCacheCurrency;
    PivotPointS1Cache: TArrayDataCacheCurrency;
    PivotPointS2Cache: TArrayDataCacheCurrency;
    PivotPointS3Cache: TArrayDataCacheCurrency;
    PotencialFractalCache: TArrayDataCacheInteger;
    RentabilidadAbiertaCache: TArrayDataCacheSingle;
    Rsi14Cache: TArrayDataCacheInteger;
    Rsi140Cache: TArrayDataCacheInteger;
    StopCache: TArrayDataCacheCurrency;
    PosicionadoCache: TArrayDataCacheCurrency;
    VariabilidadCache: TArrayDataCacheSingle;
    VolatilidadCache: TArrayDataCacheSingle;
    ZonaCache: TArrayDataCacheString;
    ZonaAlzaDobleCache: TArrayDataCacheString;
    ZonaAlzaSimpleCache: TArrayDataCacheString;
    ZonaBajaDobleCache: TArrayDataCacheString;
    ZonaBajaSimpleCache: TArrayDataCacheString;
    RiesgoCache: TArrayDataCacheSingle;
    PresionVerticalCache: TArrayDataCacheSingle;
    PresionVerticalAlzaSimpleCache: TArrayDataCacheSingle;
    PresionVerticalAlzaDobleCache: TArrayDataCacheSingle;
    PresionVerticalBajaSimpleCache: TArrayDataCacheSingle;
    PresionVerticalBajaDobleCache: TArrayDataCacheSingle;
    PresionLateralCache: TArrayDataCacheSingle;
    PresionLateralAlzaSimpleCache: TArrayDataCacheSingle;
    PresionLateralAlzaDobleCache: TArrayDataCacheSingle;
    PresionLateralBajaSimpleCache: TArrayDataCacheSingle;
    PresionLateralBajaDobleCache: TArrayDataCacheSingle;
    CambioAlzaSimpleCache: TArrayDataCacheCurrency;
    CambioAlzaDobleCache: TArrayDataCacheCurrency;
    CambioBajaSimpleCache: TArrayDataCacheCurrency;
    CambioBajaDobleCache: TArrayDataCacheCurrency;
    procedure SetOIDValor(const Value: integer);
//    procedure OnTipoCotizacionCambiada;
    function GetCurrency(const arrayCurrency: PArrayDataCacheCurrency; const OIDSesion: integer): Currency;
    function GetInteger(const arrayInteger: PArrayDataCacheInteger; const OIDSesion: integer): integer;
    function GetSingle(const arraySingle: PArrayDataCacheSingle; const OIDSesion: integer): single;
    function GetString(const arrayString: PArrayDataCacheString; const OIDSesion: integer): string;
    function LoadCotizacion(const qData: TIBSQL; const OIDValor: Integer; const campo: string): Integer; overload;
    procedure LoadCotizacion(const OIDValor: Integer; const campo: string; const arrayCurrency: PArrayDataCacheCurrency); overload;
    procedure LoadCotizacion(const OIDValor: Integer; const campo: string; const arrayInteger: PArrayDataCacheInteger); overload;
    procedure LoadCotizacion(const OIDValor: Integer; const campo: string; const arraySingle: PArrayDataCacheSingle); overload;
    function LoadCotizacionEstado(const qData: TIBSQL; const OIDValor: Integer; const campo: string): Integer; overload;
    procedure LoadCotizacionEstado(const OIDValor: Integer; const campo: string; const arrayCurrency: PArrayDataCacheCurrency); overload;
    procedure LoadCotizacionEstado(const OIDValor: Integer; const campo: string; const arrayInteger: PArrayDataCacheInteger); overload;
    procedure LoadCotizacionEstado(const OIDValor: Integer; const campo: string; const arraySingle: PArrayDataCacheSingle); overload;
    procedure LoadCotizacionEstado(const OIDValor: Integer; const campo: string; const arrayString: PArrayDataCacheString); overload;
    procedure LoadCotizacionMensaje(const OIDValor: integer; const arrayInteger: PArrayDataCacheInteger);
    function GetIDCotizacion(const instance: TScriptDataCacheHorizontal): integer;
    function GetCierre(const instance: TScriptDataCacheHorizontal): currency;
    function GetApertura(const instance: TScriptDataCacheHorizontal): currency;
    function GetVolumen(const instance: TScriptDataCacheHorizontal): integer;
    function GetDiasSeguidosNum(const instance: TScriptDataCacheHorizontal): integer;
    function GetDiasSeguidosPerCent(const instance: TScriptDataCacheHorizontal): single;
    function GetMaximo(const instance: TScriptDataCacheHorizontal): currency;
    function GetMinimo(const instance: TScriptDataCacheHorizontal): currency;
    function GetVariacion(const instance: TScriptDataCacheHorizontal): single;
    function GetMensajeFlags(const instance: TScriptDataCacheHorizontal): integer;
    function GetAmbienteIntradia(const instance: TScriptDataCacheHorizontal): string;
    function GetBandaAlta(const instance: TScriptDataCacheHorizontal): currency;
    function GetBandaBaja(const instance: TScriptDataCacheHorizontal): currency;
    function GetCorrelacion(const instance: TScriptDataCacheHorizontal): integer;
    function GetDimensionFractal(const instance: TScriptDataCacheHorizontal): currency;
    function GetDinero(const instance: TScriptDataCacheHorizontal): currency;
    function GetDineroAlzaDoble(const instance: TScriptDataCacheHorizontal): currency;
    function GetDineroAlzaSimple(const instance: TScriptDataCacheHorizontal): currency;
    function GetDineroBajaDoble(const instance: TScriptDataCacheHorizontal): currency;
    function GetDineroBajaSimple(const instance: TScriptDataCacheHorizontal): currency;
    function GetDobson10(const instance: TScriptDataCacheHorizontal): integer;
    function GetDobson100(const instance: TScriptDataCacheHorizontal): integer;
    function GetDobson130(const instance: TScriptDataCacheHorizontal): integer;
    function GetDobson40(const instance: TScriptDataCacheHorizontal): integer;
    function GetDobson70(const instance: TScriptDataCacheHorizontal): integer;
    function GetDobsonAlto10(const instance: TScriptDataCacheHorizontal): integer;
    function GetDobsonAlto100(const instance: TScriptDataCacheHorizontal): integer;
    function GetDobsonAlto130(const instance: TScriptDataCacheHorizontal): integer;
    function GetDobsonAlto40(const instance: TScriptDataCacheHorizontal): integer;
    function GetDobsonAlto70(const instance: TScriptDataCacheHorizontal): integer;
    function GetDobsonBajo10(const instance: TScriptDataCacheHorizontal): integer;
    function GetDobsonBajo100(const instance: TScriptDataCacheHorizontal): integer;
    function GetDobsonBajo130(const instance: TScriptDataCacheHorizontal): integer;
    function GetDobsonBajo40(const instance: TScriptDataCacheHorizontal): integer;
    function GetDobsonBajo70(const instance: TScriptDataCacheHorizontal): integer;
    function GetMaximoPrevisto(const instance: TScriptDataCacheHorizontal): currency;
    function GetMaximoPrevistoAprox(const instance: TScriptDataCacheHorizontal): single;
    function GetMaximoSePrevino(const instance: TScriptDataCacheHorizontal): currency;
    function GetMedia200(const instance: TScriptDataCacheHorizontal): currency;
    function GetMinimoPrevisto(const instance: TScriptDataCacheHorizontal): currency;
    function GetMinimoPrevistoAprox(const instance: TScriptDataCacheHorizontal): single;
    function GetMinimoSePrevino(const instance: TScriptDataCacheHorizontal): currency;
    function GetNivelActual(const instance: TScriptDataCacheHorizontal): string;
    function GetNivelBaja(const instance: TScriptDataCacheHorizontal): string;
    function GetNivelSube(const instance: TScriptDataCacheHorizontal): string;
    function GetPapel(const instance: TScriptDataCacheHorizontal): currency;
    function GetPapelAlzaDoble(const instance: TScriptDataCacheHorizontal): currency;
    function GetPapelAlzaSimple(const instance: TScriptDataCacheHorizontal): currency;
    function GetPapelBajaDoble(const instance: TScriptDataCacheHorizontal): currency;
    function GetPapelBajaSimple(const instance: TScriptDataCacheHorizontal): currency;
    function GetPercentAlzaSimple(const instance: TScriptDataCacheHorizontal): currency;
    function GetPercentBajaSimple(const instance: TScriptDataCacheHorizontal): currency;
    function GetPivotPoint(const instance: TScriptDataCacheHorizontal): currency;
    function GetPivotPointR1(const instance: TScriptDataCacheHorizontal): currency;
    function GetPivotPointR2(const instance: TScriptDataCacheHorizontal): currency;
    function GetPivotPointR3(const instance: TScriptDataCacheHorizontal): currency;
    function GetPivotPointS1(const instance: TScriptDataCacheHorizontal): currency;
    function GetPivotPointS2(const instance: TScriptDataCacheHorizontal): currency;
    function GetPivotPointS3(const instance: TScriptDataCacheHorizontal): currency;
    function GetPotencialFractal(const instance: TScriptDataCacheHorizontal): integer;
    function GetRentabilidadAbierta(const instance: TScriptDataCacheHorizontal): single;
    function GetRsi14(const instance: TScriptDataCacheHorizontal): integer;
    function GetRsi140(const instance: TScriptDataCacheHorizontal): integer;
    function GetStop(const instance: TScriptDataCacheHorizontal): currency;
    function GetPosicionado(const instance: TScriptDataCacheHorizontal): currency;
    function GetVariabilidad(const instance: TScriptDataCacheHorizontal): single;
    function GetVolatilidad(const instance: TScriptDataCacheHorizontal): single;
    function GetZona(const instance: TScriptDataCacheHorizontal): string;
    function GetZonaAlzaDoble(const instance: TScriptDataCacheHorizontal): string;
    function GetZonaAlzaSimple(const instance: TScriptDataCacheHorizontal): string;
    function GetZonaBajaDoble(const instance: TScriptDataCacheHorizontal): string;
    function GetZonaBajaSimple(const instance: TScriptDataCacheHorizontal): string;
    function GetRiesgo(const instance: TScriptDataCacheHorizontal): Single;
    function GetPresionVertical(const instance: TScriptDataCacheHorizontal): Single;
    function GetPresionVerticalAlzaSimple(const instance: TScriptDataCacheHorizontal): Single;
    function GetPresionVerticalAlzaDoble(const instance: TScriptDataCacheHorizontal): Single;
    function GetPresionVerticalBajaSimple(const instance: TScriptDataCacheHorizontal): Single;
    function GetPresionVerticalBajaDoble(const instance: TScriptDataCacheHorizontal): Single;
    function GetPresionLateral(const instance: TScriptDataCacheHorizontal): Single;
    function GetPresionLateralAlzaSimple(const instance: TScriptDataCacheHorizontal): Single;
    function GetPresionLateralAlzaDoble(const instance: TScriptDataCacheHorizontal): Single;
    function GetPresionLateralBajaSimple(const instance: TScriptDataCacheHorizontal): Single;
    function GetPresionLateralBajaDoble(const instance: TScriptDataCacheHorizontal): Single;
    function GetCambioAlzaSimple(const instance: TScriptDataCacheHorizontal): currency;
    function GetCambioAlzaDoble(const instance: TScriptDataCacheHorizontal): currency;
    function GetCambioBajaSimple(const instance: TScriptDataCacheHorizontal): currency;
    function GetCambioBajaDoble(const instance: TScriptDataCacheHorizontal): currency;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure InitializeCache; override;    
  end;

implementation

uses UtilThread, dmBD, UtilDB, BusCommunication, IBDatabase, dmData;

resourcestring
  NO_ENCONTRADO = 'No se ha encontrado el valor para la sesión %d';

{ TScriptDataCacheHorizontalFactory }

constructor TScriptDataCacheHorizontalFactory.Create;
begin
  inherited;
  InitializeCriticalSection(criticalSection);
  ScriptDataCacheClass := TScriptDataCacheHorizontal;
end;

destructor TScriptDataCacheHorizontalFactory.Destroy;
begin
  DeleteCriticalSection(criticalSection);
  inherited;
end;

function TScriptDataCacheHorizontalFactory.GetAmbienteIntradia(
  const instance: TScriptDataCacheHorizontal): string;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(AmbienteIntradiaCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'AMBIENTE_INTRADIA', PArrayDataCacheString(@AmbienteIntradiaCache));
  result := GetString(@AmbienteIntradiaCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetApertura(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(AperturaCache) = 0 then
    LoadCotizacion(instance.OIDValor, 'APERTURA', PArrayDataCacheCurrency(@AperturaCache));
  result := GetCurrency(@AperturaCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetBandaAlta(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(BandaAltaCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'BANDA_ALTA', PArrayDataCacheCurrency(@BandaAltaCache));
  result := GetCurrency(@BandaAltaCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetBandaBaja(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(BandaBajaCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'BANDA_BAJA', PArrayDataCacheCurrency(@BandaBajaCache));
  result := GetCurrency(@BandaBajaCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetCambioAlzaDoble(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(CambioAlzaDobleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'CAMBIO_ALZA_DOBLE', PArrayDataCacheCurrency(@CambioAlzaDobleCache));
  result := GetCurrency(@CambioAlzaDobleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetCambioAlzaSimple(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(CambioAlzaSimpleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'CAMBIO_ALZA_SIMBLE', PArrayDataCacheCurrency(@CambioAlzaSimpleCache));
  result := GetCurrency(@CambioAlzaSimpleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetCambioBajaDoble(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(CambioBajaDobleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'CAMBIO_BAJA_DOBLE', PArrayDataCacheCurrency(@CambioBajaDobleCache));
  result := GetCurrency(@CambioBajaDobleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetCambioBajaSimple(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(CambioBajaSimpleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'CAMBIO_BAJA_SIMBLE', PArrayDataCacheCurrency(@CambioBajaSimpleCache));
  result := GetCurrency(@CambioBajaSimpleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetCierre(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(CierreCache) = 0 then
    LoadCotizacion(instance.OIDValor, 'CIERRE', PArrayDataCacheCurrency(@CierreCache));
  result := GetCurrency(@CierreCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetCorrelacion(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(CorrelacionCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'CORRELACION', PArrayDataCacheInteger(@CorrelacionCache));
  result := GetInteger(@CorrelacionCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetCurrency(
  const arrayCurrency: PArrayDataCacheCurrency; const OIDSesion: integer): Currency;
var i, num: integer;
begin
  EnterCriticalSection(criticalSection);
  num := Length(arrayCurrency^) - 1;
  if lastOIDSesion > num then
    lastOIDSesion := 0;
  if arrayCurrency^[lastOIDSesion].OIDSesion < OIDSesion then begin
    for i := lastOIDSesion + 1 to num do begin
      if arrayCurrency^[i].OIDSesion = OIDSesion then begin
        result := arrayCurrency^[i].Valor;
        lastOIDSesion := i;
        LeaveCriticalSection(criticalSection);
        exit;
      end;
    end;
    for i := lastOIDSesion downto 0 do begin
      if arrayCurrency^[i].OIDSesion = OIDSesion then begin
        result := arrayCurrency^[i].Valor;
        lastOIDSesion := i;
        LeaveCriticalSection(criticalSection);
        exit;
      end;
    end;
  end
  else begin
    for i := lastOIDSesion - 1 downto 0 do begin
      if arrayCurrency^[i].OIDSesion = OIDSesion then begin
        result := arrayCurrency^[i].Valor;
        lastOIDSesion := i;
        LeaveCriticalSection(criticalSection);
        exit;
      end;
    end;
    for i := lastOIDSesion to num do begin
      if arrayCurrency^[i].OIDSesion = OIDSesion then begin
        result := arrayCurrency^[i].Valor;
        lastOIDSesion := i;
        LeaveCriticalSection(criticalSection);
        exit;
      end;
    end;
  end;
  LeaveCriticalSection(criticalSection);
  raise EDatoNoEncontrado.Create(Format(NO_ENCONTRADO, [OIDSesion]));
end;


function TScriptDataCacheHorizontalFactory.GetDiasSeguidosNum(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(DiasSeguidosNumCache) = 0 then
    LoadCotizacion(instance.OIDValor, 'DIAS_SEGUIDOS_NUM', PArrayDataCacheInteger(@DiasSeguidosNumCache));
  result := GetInteger(@DiasSeguidosNumCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDiasSeguidosPerCent(
  const instance: TScriptDataCacheHorizontal): single;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(DiasSeguidosPerCentCache) = 0 then
    LoadCotizacion(instance.OIDValor, 'DIAS_SEGUIDOS_PERCENT', PArrayDataCacheSingle(@DiasSeguidosPerCentCache));
  result := GetSingle(@DiasSeguidosPerCentCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDimensionFractal(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(DimensionFractalCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DIMENSION_FRACTAL', PArrayDataCacheCurrency(@DimensionFractalCache));
  result := GetCurrency(@DimensionFractalCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDinero(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(DineroCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DINERO', PArrayDataCacheCurrency(@DineroCache));
  result := GetCurrency(@DineroCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDineroAlzaDoble(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(DineroAlzaDobleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DINERO_ALZA_DOBLE', PArrayDataCacheCurrency(@DineroAlzaDobleCache));
  result := GetCurrency(@DineroAlzaDobleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDineroAlzaSimple(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(DineroAlzaSimpleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DINERO_ALZA_SIMPLE', PArrayDataCacheCurrency(@DineroAlzaSimpleCache));
  result := GetCurrency(@DineroAlzaSimpleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDineroBajaDoble(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(DineroBajaDobleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DINERO_BAJA_DOBLE', PArrayDataCacheCurrency(@DineroBajaDobleCache));
  result := GetCurrency(@DineroBajaDobleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDineroBajaSimple(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(DineroBajaSimpleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DINERO_BAJA_SIMPLE', PArrayDataCacheCurrency(@DineroBajaSimpleCache));
  result := GetCurrency(@DineroBajaSimpleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDobson10(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(Dobson10Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DOBSON_10', PArrayDataCacheInteger(@Dobson10Cache));
  result := GetInteger(@Dobson10Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDobson100(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(Dobson100Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DOBSON_100', PArrayDataCacheInteger(@Dobson100Cache));
  result := GetInteger(@Dobson100Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDobson130(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(Dobson130Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DOBSON_130', PArrayDataCacheInteger(@Dobson130Cache));
  result := GetInteger(@Dobson130Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDobson40(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(Dobson40Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DOBSON_40', PArrayDataCacheInteger(@Dobson40Cache));
  result := GetInteger(@Dobson40Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDobson70(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(Dobson70Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DOBSON_70', PArrayDataCacheInteger(@Dobson70Cache));
  result := GetInteger(@Dobson70Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDobsonAlto10(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(DobsonAlto10Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DOBSON_ALTO_10', PArrayDataCacheInteger(@DobsonAlto10Cache));
  result := GetInteger(@DobsonAlto10Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDobsonAlto100(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(DobsonAlto100Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DOBSON_ALTO_100', PArrayDataCacheInteger(@DobsonAlto100Cache));
  result := GetInteger(@DobsonAlto100Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDobsonAlto130(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(DobsonAlto130Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DOBSON_ALTO_130', PArrayDataCacheInteger(@DobsonAlto130Cache));
  result := GetInteger(@DobsonAlto130Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDobsonAlto40(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(DobsonAlto40Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DOBSON_ALTO_40', PArrayDataCacheInteger(@DobsonAlto40Cache));
  result := GetInteger(@DobsonAlto40Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDobsonAlto70(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(DobsonAlto70Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DOBSON_ALTO_70', PArrayDataCacheInteger(@DobsonAlto70Cache));
  result := GetInteger(@DobsonAlto70Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDobsonBajo10(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(DobsonBajo10Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DOBSON_BAJO_10', PArrayDataCacheInteger(@DobsonBajo10Cache));
  result := GetInteger(@DobsonBajo10Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDobsonBajo100(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(DobsonBajo100Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DOBSON_BAJO_100', PArrayDataCacheInteger(@DobsonBajo100Cache));
  result := GetInteger(@DobsonBajo100Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDobsonBajo130(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(DobsonBajo130Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DOBSON_BAJO_130', PArrayDataCacheInteger(@DobsonBajo130Cache));
  result := GetInteger(@DobsonBajo130Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDobsonBajo40(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(DobsonBajo40Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DOBSON_BAJO_40', PArrayDataCacheInteger(@DobsonBajo40Cache));
  result := GetInteger(@DobsonBajo40Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetDobsonBajo70(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(DobsonBajo70Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'DOBSON_BAJO_70', PArrayDataCacheInteger(@DobsonBajo70Cache));
  result := GetInteger(@DobsonBajo70Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetIDCotizacion(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(IDCotizacionCache) = 0 then
    LoadCotizacion(instance.OIDValor, 'OID_COTIZACION', PArrayDataCacheInteger(@IDCotizacionCache));
  result := GetInteger(@IDCotizacionCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetInteger(
  const arrayInteger: PArrayDataCacheInteger;
  const OIDSesion: integer): integer;
var i, num: integer;
begin
  EnterCriticalSection(criticalSection);
  num := Length(arrayInteger^) - 1;
  if lastOIDSesion > num then
    lastOIDSesion := 0;
  if arrayInteger^[lastOIDSesion].OIDSesion < OIDSesion then begin
    for i := lastOIDSesion + 1 to num do begin
      if arrayInteger^[i].OIDSesion = OIDSesion then begin
        result := arrayInteger^[i].Valor;
        lastOIDSesion := i;
        LeaveCriticalSection(criticalSection);
        exit;
      end;
    end;
    for i := lastOIDSesion downto 0 do begin
      if arrayInteger^[i].OIDSesion = OIDSesion then begin
        result := arrayInteger^[i].Valor;
        lastOIDSesion := i;
        LeaveCriticalSection(criticalSection);
        exit;
      end;
    end;
  end
  else begin
    for i := lastOIDSesion - 1 downto 0 do begin
      if arrayInteger^[i].OIDSesion = OIDSesion then begin
        result := arrayInteger^[i].Valor;
        lastOIDSesion := i;
        LeaveCriticalSection(criticalSection);
        exit;
      end;
    end;
    for i := lastOIDSesion to num do begin
      if arrayInteger^[i].OIDSesion = OIDSesion then begin
        result := arrayInteger^[i].Valor;
        lastOIDSesion := i;
        LeaveCriticalSection(criticalSection);
        exit;
      end;
    end;
  end;
  LeaveCriticalSection(criticalSection);
  raise EDatoNoEncontrado.Create(Format(NO_ENCONTRADO, [OIDSesion]));
end;

function TScriptDataCacheHorizontalFactory.GetMaximo(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
    if Length(MaximoCache) = 0 then
      LoadCotizacion(instance.OIDValor, 'MAXIMO', PArrayDataCacheCurrency(@MaximoCache));
    result := GetCurrency(@MaximoCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetMaximoPrevisto(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(MaximoPrevistoCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'MAXIMO_PREVISTO', PArrayDataCacheCurrency(@MaximoPrevistoCache));
  result := GetCurrency(@MaximoPrevistoCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetMaximoPrevistoAprox(
  const instance: TScriptDataCacheHorizontal): single;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(MaximoPrevistoAproxCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'MAXIMO_PREVISTO_APROX', PArrayDataCacheSingle(@MaximoPrevistoAproxCache));
  result := GetSingle(@MaximoPrevistoAproxCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetMaximoSePrevino(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(MaximoSePrevinoCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'MAXIMO_SE_PREVINO', PArrayDataCacheCurrency(@MaximoSePrevinoCache));
  result := GetCurrency(@MaximoSePrevinoCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetMedia200(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(Media200Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'MEDIA_200', PArrayDataCacheCurrency(@Media200Cache));
  result := GetCurrency(@Media200Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetMensajeFlags(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(MensajeFlagsCache) = 0 then
    LoadCotizacionMensaje(instance.OIDValor, PArrayDataCacheInteger(@MensajeFlagsCache));
  result := GetInteger(@MensajeFlagsCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetMinimo(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
    if Length(MinimoCache) = 0 then
      LoadCotizacion(instance.OIDValor, 'MINIMO', PArrayDataCacheCurrency(@MinimoCache));
    result := GetCurrency(@MinimoCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetMinimoPrevisto(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(MinimoPrevistoCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'MINIMO_PREVISTO', PArrayDataCacheCurrency(@MinimoPrevistoCache));
  result := GetCurrency(@MinimoPrevistoCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetMinimoPrevistoAprox(
  const instance: TScriptDataCacheHorizontal): single;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(MinimoPrevistoAproxCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'MINIMO_PREVISTO_APROX', PArrayDataCacheSingle(@MinimoPrevistoAproxCache));
  result := GetSingle(@MinimoPrevistoAproxCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetMinimoSePrevino(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(MinimoSePrevinoCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'MINIMO_SE_PREVINO', PArrayDataCacheCurrency(@MinimoSePrevinoCache));
  result := GetCurrency(@MinimoSePrevinoCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetNivelActual(
  const instance: TScriptDataCacheHorizontal): string;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(NivelActualCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'NIVEL_ACTUAL', PArrayDataCacheString(@NivelActualCache));
  result := GetString(@NivelActualCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetNivelBaja(
  const instance: TScriptDataCacheHorizontal): string;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(NivelBajaCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'NIVEL_BAJA', PArrayDataCacheString(@NivelBajaCache));
  result := GetString(@NivelBajaCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetNivelSube(
  const instance: TScriptDataCacheHorizontal): string;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(NivelSubeCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'NIVEL_SUBE', PArrayDataCacheString(@NivelSubeCache));
  result := GetString(@NivelSubeCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPapel(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PapelCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PAPEL', PArrayDataCacheCurrency(@PapelCache));
  result := GetCurrency(@PapelCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPapelAlzaDoble(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PapelAlzaDobleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PAPEL_ALZA_DOBLE', PArrayDataCacheCurrency(@PapelAlzaDobleCache));
  result := GetCurrency(@PapelAlzaDobleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPapelAlzaSimple(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PapelAlzaSimpleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PAPEL_ALZA_SIMPLE', PArrayDataCacheCurrency(@PapelAlzaSimpleCache));
  result := GetCurrency(@PapelAlzaSimpleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPapelBajaDoble(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PapelBajaDobleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PAPEL_BAJA_DOBLE', PArrayDataCacheCurrency(@PapelBajaDobleCache));
  result := GetCurrency(@PapelBajaDobleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPapelBajaSimple(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PapelBajaSimpleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PAPEL_BAJA_SIMPLE', PArrayDataCacheCurrency(@PapelBajaSimpleCache));
  result := GetCurrency(@PapelBajaSimpleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPercentAlzaSimple(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PercentAlzaSimpleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PERCENT_ALZA_SIMPLE', PArrayDataCacheCurrency(@PercentAlzaSimpleCache));
  result := GetCurrency(@PercentAlzaSimpleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPercentBajaSimple(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PercentBajaSimpleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PERCENT_BAJA_SIMPLE', PArrayDataCacheCurrency(@PercentBajaSimpleCache));
  result := GetCurrency(@PercentBajaSimpleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPivotPoint(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PivotPointCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PIVOT_POINT', PArrayDataCacheCurrency(@PivotPointCache));
  result := GetCurrency(@PivotPointCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPivotPointR1(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PivotPointR1Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PIVOT_POINT_R1', PArrayDataCacheCurrency(@PivotPointR1Cache));
  result := GetCurrency(@PivotPointR1Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPivotPointR2(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PivotPointR2Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PIVOT_POINT_R2', PArrayDataCacheCurrency(@PivotPointR2Cache));
  result := GetCurrency(@PivotPointR2Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPivotPointR3(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PivotPointR3Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PIVOT_POINT_R3', PArrayDataCacheCurrency(@PivotPointR3Cache));
  result := GetCurrency(@PivotPointR3Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPivotPointS1(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PivotPointS1Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PIVOT_POINT_S1', PArrayDataCacheCurrency(@PivotPointS1Cache));
  result := GetCurrency(@PivotPointS1Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPivotPointS2(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PivotPointS2Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PIVOT_POINT_S2', PArrayDataCacheCurrency(@PivotPointS2Cache));
  result := GetCurrency(@PivotPointS2Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPivotPointS3(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PivotPointS3Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PIVOT_POINT_S3', PArrayDataCacheCurrency(@PivotPointS3Cache));
  result := GetCurrency(@PivotPointS3Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPosicionado(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PosicionadoCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'POSICIONADO', PArrayDataCacheCurrency(@PosicionadoCache));
  result := GetCurrency(@PosicionadoCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPotencialFractal(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PotencialFractalCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'POTENCIAL_FRACTAL', PArrayDataCacheInteger(@PotencialFractalCache));
  result := GetInteger(@PotencialFractalCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPresionLateral(
  const instance: TScriptDataCacheHorizontal): single;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PresionLateralCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PRESION_LATERAL', PArrayDataCacheSingle(@PresionLateralCache));
  result := GetSingle(@PresionLateralCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPresionLateralAlzaDoble(
  const instance: TScriptDataCacheHorizontal): single;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PresionLateralAlzaDobleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PRESION_LATERAL_ALZA_DOBLE', PArrayDataCacheSingle(@PresionLateralAlzaDobleCache));
  result := GetSingle(@PresionLateralAlzaDobleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPresionLateralAlzaSimple(
  const instance: TScriptDataCacheHorizontal): single;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PresionLateralAlzaSimpleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PRESION_LATERAL_ALZA_SIMPLE', PArrayDataCacheSingle(@PresionLateralAlzaSimpleCache));
  result := GetSingle(@PresionLateralAlzaSimpleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPresionLateralBajaDoble(
  const instance: TScriptDataCacheHorizontal): single;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PresionLateralBajaDobleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PRESION_LATERAL_BAJA_DOBLE', PArrayDataCacheSingle(@PresionLateralBajaDobleCache));
  result := GetSingle(@PresionLateralBajaDobleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPresionLateralBajaSimple(
  const instance: TScriptDataCacheHorizontal): single;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PresionLateralBajaSimpleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PRESION_LATERAL_BAJA_SIMPLE', PArrayDataCacheSingle(@PresionLateralBajaSimpleCache));
  result := GetSingle(@PresionLateralBajaSimpleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPresionVertical(
  const instance: TScriptDataCacheHorizontal): single;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PresionVerticalCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PRESION_VERTICAL', PArrayDataCacheSingle(@PresionVerticalCache));
  result := GetSingle(@PresionVerticalCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPresionVerticalAlzaDoble(
  const instance: TScriptDataCacheHorizontal): single;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PresionVerticalAlzaDobleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PRESION_VERTICAL_ALZA_DOBLE', PArrayDataCacheSingle(@PresionVerticalAlzaDobleCache));
  result := GetSingle(@PresionVerticalAlzaDobleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPresionVerticalAlzaSimple(
  const instance: TScriptDataCacheHorizontal): single;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PresionVerticalAlzaSimpleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PRESION_VERTICAL_ALZA_SIMPLE', PArrayDataCacheSingle(@PresionVerticalAlzaSimpleCache));
  result := GetSingle(@PresionVerticalAlzaSimpleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPresionVerticalBajaDoble(
  const instance: TScriptDataCacheHorizontal): single;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PresionVerticalBajaDobleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PRESION_VERTICAL_BAJA_DOBLE', PArrayDataCacheSingle(@PresionVerticalBajaDobleCache));
  result := GetSingle(@PresionVerticalBajaDobleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetPresionVerticalBajaSimple(
  const instance: TScriptDataCacheHorizontal): single;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(PresionVerticalBajaSimpleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'PRESION_VERTICAL_BAJA_SIMPLE', PArrayDataCacheSingle(@PresionVerticalBajaSimpleCache));
  result := GetSingle(@PresionVerticalBajaSimpleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetRentabilidadAbierta(
  const instance: TScriptDataCacheHorizontal): single;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(RentabilidadAbiertaCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'RENTABILIDAD_ABIERTA', PArrayDataCacheSingle(@RentabilidadAbiertaCache));
  result := GetSingle(@RentabilidadAbiertaCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetRiesgo(
  const instance: TScriptDataCacheHorizontal): single;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(RiesgoCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'RIESGO', PArrayDataCacheSingle(@RiesgoCache));
  result := GetSingle(@RiesgoCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetRsi14(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(Rsi14Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'RSI_14', PArrayDataCacheInteger(@Rsi14Cache));
  result := GetInteger(@Rsi14Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetRsi140(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(Rsi140Cache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'RSI_140', PArrayDataCacheInteger(@Rsi140Cache));
  result := GetInteger(@Rsi140Cache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetSingle(
  const arraySingle: PArrayDataCacheSingle; const OIDSesion: integer): single;
var i, num: integer;
begin
  EnterCriticalSection(criticalSection);
  num := Length(arraySingle^) - 1;
  if lastOIDSesion > num then
    lastOIDSesion := 0;
  if arraySingle^[lastOIDSesion].OIDSesion < OIDSesion then begin
    for i := lastOIDSesion + 1 to num do begin
      if arraySingle^[i].OIDSesion = OIDSesion then begin
        result := arraySingle^[i].Valor;
        lastOIDSesion := i;
        LeaveCriticalSection(criticalSection);
        exit;
      end;
    end;
    for i := lastOIDSesion downto 0 do begin
      if arraySingle^[i].OIDSesion = OIDSesion then begin
        result := arraySingle^[i].Valor;
        lastOIDSesion := i;
        LeaveCriticalSection(criticalSection);
        exit;
      end;
    end;
  end
  else begin
    for i := lastOIDSesion - 1 downto 0 do begin
      if arraySingle^[i].OIDSesion = OIDSesion then begin
        result := arraySingle^[i].Valor;
        lastOIDSesion := i;
        LeaveCriticalSection(criticalSection);
        exit;
      end;
    end;
    for i := lastOIDSesion to num do begin
      if arraySingle^[i].OIDSesion = OIDSesion then begin
        result := arraySingle^[i].Valor;
        lastOIDSesion := i;
        LeaveCriticalSection(criticalSection);
        exit;
      end;
    end;
  end;
  LeaveCriticalSection(criticalSection);
  raise EDatoNoEncontrado.Create(Format(NO_ENCONTRADO, [OIDSesion]));
end;

function TScriptDataCacheHorizontalFactory.GetStop(
  const instance: TScriptDataCacheHorizontal): currency;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(StopCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'STOP', PArrayDataCacheCurrency(@StopCache));
  result := GetCurrency(@StopCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetString(
  const arrayString: PArrayDataCacheString; const OIDSesion: integer): string;
var i, num: integer;
begin
  EnterCriticalSection(criticalSection);
  num := Length(arrayString^) - 1;
  if lastOIDSesion > num then
    lastOIDSesion := 0;
  if arrayString^[lastOIDSesion].OIDSesion < OIDSesion then begin
    for i := lastOIDSesion + 1 to num do begin
      if arrayString^[i].OIDSesion = OIDSesion then begin
        result := arrayString^[i].Valor;
        lastOIDSesion := i;
        LeaveCriticalSection(criticalSection);
        exit;
      end;
    end;
    for i := lastOIDSesion downto 0 do begin
      if arrayString^[i].OIDSesion = OIDSesion then begin
        result := arrayString^[i].Valor;
        lastOIDSesion := i;
        LeaveCriticalSection(criticalSection);
        exit;
      end;
    end;
  end
  else begin
    for i := lastOIDSesion - 1 downto 0 do begin
      if arrayString^[i].OIDSesion = OIDSesion then begin
        result := arrayString^[i].Valor;
        lastOIDSesion := i;
        LeaveCriticalSection(criticalSection);
        exit;
      end;
    end;
    for i := lastOIDSesion to num do begin
      if arrayString^[i].OIDSesion = OIDSesion then begin
        result := arrayString^[i].Valor;
        lastOIDSesion := i;
        LeaveCriticalSection(criticalSection);
        exit;
      end;
    end;
  end;
  LeaveCriticalSection(criticalSection);
  raise EDatoNoEncontrado.Create(Format(NO_ENCONTRADO, [OIDSesion]));
end;

function TScriptDataCacheHorizontalFactory.GetVariabilidad(
  const instance: TScriptDataCacheHorizontal): single;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(VariabilidadCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'VARIABILIDAD', PArrayDataCacheSingle(@VariabilidadCache));
  result := GetSingle(@VariabilidadCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetVariacion(
  const instance: TScriptDataCacheHorizontal): single;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(VariacionCache) = 0 then
    LoadCotizacion(instance.OIDValor, 'VARIACION', PArrayDataCacheSingle(@VariacionCache));
  result := GetSingle(@VariacionCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetVolatilidad(
  const instance: TScriptDataCacheHorizontal): single;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(VolatilidadCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'VOLATILIDAD', PArrayDataCacheSingle(@VolatilidadCache));
  result := GetSingle(@VolatilidadCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetVolumen(
  const instance: TScriptDataCacheHorizontal): integer;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(VolumenCache) = 0 then
    LoadCotizacion(instance.OIDValor, 'VOLUMEN', PArrayDataCacheInteger(@VolumenCache));
  result := GetInteger(@VolumenCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetZona(
  const instance: TScriptDataCacheHorizontal): string;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(ZonaCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'ZONA', PArrayDataCacheString(@ZonaCache));
  result := GetString(@ZonaCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetZonaAlzaDoble(
  const instance: TScriptDataCacheHorizontal): string;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(ZonaAlzaDobleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'ZONA_ALZA_DOBLE', PArrayDataCacheString(@ZonaAlzaDobleCache));
  result := GetString(@ZonaAlzaDobleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetZonaAlzaSimple(
  const instance: TScriptDataCacheHorizontal): string;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(ZonaAlzaSimpleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'ZONA_ALZA_SIMPLE', PArrayDataCacheString(@ZonaAlzaSimpleCache));
  result := GetString(@ZonaAlzaSimpleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetZonaBajaDoble(
  const instance: TScriptDataCacheHorizontal): string;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(ZonaBajaDobleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'ZONA_BAJA_DOBLE', PArrayDataCacheString(@ZonaBajaDobleCache));
  result := GetString(@ZonaBajaDobleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheHorizontalFactory.GetZonaBajaSimple(
  const instance: TScriptDataCacheHorizontal): string;
begin
  EnterCriticalSection(criticalSection);
  try
  if Length(ZonaBajaSimpleCache) = 0 then
    LoadCotizacionEstado(instance.OIDValor, 'ZONA_BAJA_SIMPLE', PArrayDataCacheString(@ZonaBajaSimpleCache));
  result := GetString(@ZonaBajaSimpleCache, instance.OIDSesion);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

procedure TScriptDataCacheHorizontalFactory.InitializeCache;
begin
  EnterCriticalSection(criticalSection);
  lastOIDSesion := 0;
  SetLength(IDCotizacionCache, 0);
  SetLength(CierreCache, 0);
  SetLength(AperturaCache, 0);
  SetLength(VolumenCache, 0);
  SetLength(DiasSeguidosNumCache, 0);
  SetLength(DiasSeguidosPerCentCache, 0);
  SetLength(MaximoCache, 0);
  SetLength(MinimoCache, 0);
  SetLength(VariacionCache, 0);
  SetLength(MensajeFlagsCache, 0);
  SetLength(AmbienteIntradiaCache, 0);
  SetLength(BandaAltaCache, 0);
  SetLength(BandaBajaCache, 0);
  SetLength(CorrelacionCache, 0);
  SetLength(DimensionFractalCache, 0);
  SetLength(DineroCache, 0);
  SetLength(DineroAlzaDobleCache, 0);
  SetLength(DineroAlzaSimpleCache, 0);
  SetLength(DineroBajaDobleCache, 0);
  SetLength(DineroBajaSimpleCache, 0);
  SetLength(Dobson10Cache, 0);
  SetLength(Dobson100Cache, 0);
  SetLength(Dobson130Cache, 0);
  SetLength(Dobson40Cache, 0);
  SetLength(Dobson70Cache, 0);
  SetLength(DobsonAlto10Cache, 0);
  SetLength(DobsonAlto100Cache, 0);
  SetLength(DobsonAlto130Cache, 0);
  SetLength(DobsonAlto40Cache, 0);
  SetLength(DobsonAlto70Cache, 0);
  SetLength(DobsonBajo10Cache, 0);
  SetLength(DobsonBajo100Cache, 0);
  SetLength(DobsonBajo130Cache, 0);
  SetLength(DobsonBajo40Cache, 0);
  SetLength(DobsonBajo70Cache, 0);
  SetLength(MaximoPrevistoCache, 0);
  SetLength(MaximoPrevistoAproxCache, 0);
  SetLength(MaximoSePrevinoCache, 0);
  SetLength(Media200Cache, 0);
  SetLength(MinimoPrevistoCache, 0);
  SetLength(MinimoPrevistoAproxCache, 0);
  SetLength(MinimoSePrevinoCache, 0);
  SetLength(NivelActualCache, 0);
  SetLength(NivelBajaCache, 0);
  SetLength(NivelSubeCache, 0);
  SetLength(PapelCache, 0);
  SetLength(PapelAlzaDobleCache, 0);
  SetLength(PapelAlzaSimpleCache, 0);
  SetLength(PapelBajaDobleCache, 0);
  SetLength(PapelBajaSimpleCache, 0);
  SetLength(PercentAlzaSimpleCache, 0);
  SetLength(PercentBajaSimpleCache, 0);
  SetLength(PivotPointCache, 0);
  SetLength(PivotPointR1Cache, 0);
  SetLength(PivotPointR2Cache, 0);
  SetLength(PivotPointR3Cache, 0);
  SetLength(PivotPointS1Cache, 0);
  SetLength(PivotPointS2Cache, 0);
  SetLength(PivotPointS3Cache, 0);
  SetLength(PotencialFractalCache, 0);
  SetLength(RentabilidadAbiertaCache, 0);
  SetLength(Rsi14Cache, 0);
  SetLength(Rsi140Cache, 0);
  SetLength(StopCache, 0);
  SetLength(PosicionadoCache, 0);
  SetLength(VariabilidadCache, 0);
  SetLength(VolatilidadCache, 0);
  SetLength(ZonaCache, 0);
  SetLength(ZonaAlzaDobleCache, 0);
  SetLength(ZonaAlzaSimpleCache, 0);
  SetLength(ZonaBajaDobleCache, 0);
  SetLength(ZonaBajaSimpleCache, 0);
  SetLength(RiesgoCache, 0);
  SetLength(PresionVerticalCache, 0);
  SetLength(PresionVerticalAlzaSimpleCache, 0);
  SetLength(PresionVerticalAlzaDobleCache, 0);
  SetLength(PresionVerticalBajaSimpleCache, 0);
  SetLength(PresionVerticalBajaDobleCache, 0);
  SetLength(PresionLateralCache, 0);
  SetLength(PresionLateralAlzaSimpleCache, 0);
  SetLength(PresionLateralAlzaDobleCache, 0);
  SetLength(PresionLateralBajaSimpleCache, 0);
  SetLength(PresionLateralBajaDobleCache, 0);
  SetLength(CambioAlzaSimpleCache, 0);
  SetLength(CambioAlzaDobleCache, 0);
  SetLength(CambioBajaSimpleCache, 0);
  SetLength(CambioBajaDobleCache, 0);
  LeaveCriticalSection(criticalSection);
end;

procedure TScriptDataCacheHorizontalFactory.LoadCotizacion(
  const OIDValor: Integer; const campo: string;
  const arraySingle: PArrayDataCacheSingle);
var fieldOIDSesion, fieldCampo: TIBXSQLVAR;
  i: integer;
  qData: TIBSQL;
  database: TIBDatabase;
begin
  database := BD.GetNewDatabase(nil, scdDatos, BD.BDDatos);
  try
    qData := TIBSQL.Create(nil);
    try
      qData.Database := database;
      qData.Transaction := database.DefaultTransaction;
    
      SetLength(arraySingle^, LoadCotizacion(qData, OIDValor, campo));
      fieldOIDSesion := qData.Fields[0];
      fieldCampo := qData.Fields[1];
      i := 0;
      while not qData.Eof do begin
        arraySingle^[i].OIDSesion := fieldOIDSesion.AsInteger;
        arraySingle^[i].Valor := fieldCampo.AsInteger;
        qData.Next;
        inc(i);
      end;
    finally
      qData.Free;
    end;
  finally
    database.Free;
  end;
end;

procedure TScriptDataCacheHorizontalFactory.LoadCotizacionEstado(
  const OIDValor: Integer; const campo: string;
  const arrayCurrency: PArrayDataCacheCurrency);
var fieldOIDSesion, fieldCampo: TIBXSQLVAR;
  i: integer;
  qData: TIBSQL;
  database: TIBDatabase;
begin
  database := BD.GetNewDatabase(nil, scdDatos, BD.BDDatos);
  try
    qData := TIBSQL.Create(nil);
    try
      qData.Database := database;
      qData.Transaction := database.DefaultTransaction;
    
      SetLength(arrayCurrency^, LoadCotizacionEstado(qData, OIDValor, campo));
      fieldOIDSesion := qData.Fields[0];
      fieldCampo := qData.Fields[1];
      i := 0;
      while not qData.Eof do begin
        arrayCurrency^[i].OIDSesion := fieldOIDSesion.AsInteger;
        arrayCurrency^[i].Valor := fieldCampo.AsCurrency;
        qData.Next;
        inc(i);
      end;
    finally
      qData.Free;
    end;
  finally
    database.Free;
  end;
end;

procedure TScriptDataCacheHorizontalFactory.LoadCotizacionEstado(
  const OIDValor: Integer; const campo: string;
  const arrayInteger: PArrayDataCacheInteger);
var fieldOIDSesion, fieldCampo: TIBXSQLVAR;
  i: integer;
  qData: TIBSQL;
  database: TIBDatabase;
begin
  database := BD.GetNewDatabase(nil, scdDatos, BD.BDDatos);
  try
    qData := TIBSQL.Create(nil);
    try
      qData.Database := database;
      qData.Transaction := database.DefaultTransaction;
    
      SetLength(arrayInteger^, LoadCotizacionEstado(qData, OIDValor, campo));
      fieldOIDSesion := qData.Fields[0];
      fieldCampo := qData.Fields[1];
      i := 0;
      while not qData.Eof do begin
        arrayInteger^[i].OIDSesion := fieldOIDSesion.AsInteger;
        arrayInteger^[i].Valor := fieldCampo.AsInteger;
        qData.Next;
        inc(i);
      end;
    finally
      qData.Free;
    end;
  finally
    database.Free;
  end;
end;

procedure TScriptDataCacheHorizontalFactory.LoadCotizacionEstado(
  const OIDValor: Integer; const campo: string;
  const arraySingle: PArrayDataCacheSingle);
var fieldOIDSesion, fieldCampo: TIBXSQLVAR;
  i: integer;
  qData: TIBSQL;
  database: TIBDatabase;
begin
  database := BD.GetNewDatabase(nil, scdDatos, BD.BDDatos);
  try
    qData := TIBSQL.Create(nil);
    try
      qData.Database := database;
      qData.Transaction := database.DefaultTransaction;
    
      SetLength(arraySingle^, LoadCotizacionEstado(qData, OIDValor, campo));
      fieldOIDSesion := qData.Fields[0];
      fieldCampo := qData.Fields[1];
      i := 0;
      while not qData.Eof do begin
        arraySingle^[i].OIDSesion := fieldOIDSesion.AsInteger;
        arraySingle^[i].Valor := fieldCampo.AsInteger;
        qData.Next;
        inc(i);
      end;
    finally
      qData.Free;
    end;
  finally
    database.Free;
  end;
end;

function TScriptDataCacheHorizontalFactory.LoadCotizacionEstado(
  const qData: TIBSQL; const OIDValor: Integer; const campo: string): Integer;
var sOIDValor: string;
begin
  sOIDValor := IntToStr(OIDValor);
  qData.SQL.Text := 'select count(*) from cotizacion c, cotizacion_estado ce where ' +
    'c.OR_VALOR=' + sOIDValor + ' and not c.CIERRE is null and c.OID_COTIZACION = ce.OR_COTIZACION';
  ExecQuery(qData, false);
  result := qData.Fields[0].AsInteger;

  qData.Close;
  qData.SQL.Text := 'select c.OR_SESION, ce.' + campo +
    ' from cotizacion c, cotizacion_estado ce, sesion s where ' +
    'c.OR_VALOR=' + sOIDValor + ' and not c.CIERRE is null and c.OID_COTIZACION = ce.OR_COTIZACION and ' +
    'c.OR_SESION = s.OID_SESION order by s.OID_SESION desc';
  ExecQuery(qData, true);
end;

procedure TScriptDataCacheHorizontalFactory.LoadCotizacion(
  const OIDValor: Integer; const campo: string;
  const arrayInteger: PArrayDataCacheInteger);
var fieldOIDSesion, fieldCampo: TIBXSQLVAR;
  i: integer;
  qData: TIBSQL;
  database: TIBDatabase;
begin
  database := BD.GetNewDatabase(nil, scdDatos, BD.BDDatos);
  try
    qData := TIBSQL.Create(nil);
    try
      qData.Database := database;
      qData.Transaction := database.DefaultTransaction;

      SetLength(arrayInteger^, LoadCotizacion(qData, OIDValor, campo));
      fieldOIDSesion := qData.Fields[0];
      fieldCampo := qData.Fields[1];
      i := 0;
      while not qData.Eof do begin
        arrayInteger^[i].OIDSesion := fieldOIDSesion.AsInteger;
        arrayInteger^[i].Valor := fieldCampo.AsInteger;
        qData.Next;
        inc(i);
      end;
    finally
      qData.Free;
    end;
  finally
    database.Free;
  end;
end;

function TScriptDataCacheHorizontalFactory.LoadCotizacion(
  const qData: TIBSQL; const OIDValor: Integer; const campo: string): integer;
var sOIDValor: string;
begin
  sOIDValor := IntToStr(OIDValor);
  qData.SQL.Text := 'select count(*) from cotizacion c where OR_VALOR=' + sOIDValor +
    ' and not CIERRE is null';
  ExecQuery(qData, false);
  result := qData.Fields[0].AsInteger;

  qData.Close;
  qData.SQL.Text := 'select c.OR_SESION, c.' + campo + ' from cotizacion c, sesion s where ' +
    'c.OR_VALOR=' + sOIDValor + ' and c.OR_SESION = s.OID_SESION and not c.CIERRE is null order by s.OID_SESION desc';
  ExecQuery(qData, true);
end;

procedure TScriptDataCacheHorizontalFactory.LoadCotizacion(
  const OIDValor: Integer; const campo: string;
  const arrayCurrency: PArrayDataCacheCurrency);
var fieldOIDSesion, fieldCampo: TIBXSQLVAR;
  i: integer;
  qData: TIBSQL;
  database: TIBDatabase;
begin
  database := BD.GetNewDatabase(nil, scdDatos, BD.BDDatos);
  try
    qData := TIBSQL.Create(nil);
    try
      qData.Database := database;
      qData.Transaction := database.DefaultTransaction;

      SetLength(arrayCurrency^, LoadCotizacion(qData, OIDValor, campo));
      fieldOIDSesion := qData.Fields[0];
      fieldCampo := qData.Fields[1];
      i := 0;
      while not qData.Eof do begin
        arrayCurrency^[i].OIDSesion := fieldOIDSesion.AsInteger;
        arrayCurrency^[i].Valor := fieldCampo.AsCurrency;
        qData.Next;
        inc(i);
      end;
    finally
      qData.Free;
    end;
  finally
    database.Free;
  end;
end;

procedure TScriptDataCacheHorizontalFactory.SetOIDValor(const Value: integer);
begin
  if FOIDValor <> Value then begin
    FOIDValor := Value;
    InitializeCache;
  end;
end;

procedure TScriptDataCacheHorizontalFactory.LoadCotizacionEstado(
  const OIDValor: Integer; const campo: string;
  const arrayString: PArrayDataCacheString);
var fieldOIDSesion, fieldCampo: TIBXSQLVAR;
  i: integer;
  qData: TIBSQL;
  database: TIBDatabase;
begin
  database := BD.GetNewDatabase(nil, scdDatos, BD.BDDatos);
  try
    qData := TIBSQL.Create(nil);
    try
      qData.Database := database;
      qData.Transaction := database.DefaultTransaction;
    
      SetLength(arrayString^, LoadCotizacionEstado(qData, OIDValor, campo));
      fieldOIDSesion := qData.Fields[0];
      fieldCampo := qData.Fields[1];
      i := 0;
      while not qData.Eof do begin
        arrayString^[i].OIDSesion := fieldOIDSesion.AsInteger;
        arrayString^[i].Valor := fieldCampo.AsString;
        qData.Next;
        inc(i);
      end;
    finally
      qData.Free;
    end;
  finally
    database.Free;
  end;
end;

procedure TScriptDataCacheHorizontalFactory.LoadCotizacionMensaje(
  const OIDValor: integer; const arrayInteger: PArrayDataCacheInteger);
var fieldOIDSesion, fieldCampo: TIBXSQLVAR;
  i, num: integer;
  qData: TIBSQL;
  database: TIBDatabase;
begin
  database := BD.GetNewDatabase(nil, scdDatos, BD.BDDatos);
  try
    qData := TIBSQL.Create(nil);
    try
      qData.Database := database;
      qData.Transaction := database.DefaultTransaction;

      qData.SQL.Text := 'select count(*) from cotizacion c, cotizacion_mensaje cm, sesion s where ' +
        'c.OR_VALOR=:OID_VALOR and not c.CIERRE is null and c.OID_COTIZACION = cm.OR_COTIZACION and ' +
        'c.OR_SESION = s.OID_SESION';
      qData.Params[0].Value := OIDValor;
      ExecQuery(qData, false);
      num := qData.Fields[0].AsInteger;

      qData.Close;
      qData.SQL.Text := 'select c.OR_SESION, cm.FLAGS from cotizacion c, cotizacion_mensaje cm, sesion s where ' +
        'c.OR_VALOR=:OID_VALOR and not c.CIERRE is null and c.OID_COTIZACION = cm.OR_COTIZACION and ' +
        'c.OR_SESION = s.OID_SESION order by s.FECHA desc';
      qData.Params[0].Value := OIDValor;
      ExecQuery(qData, true);

      SetLength(arrayInteger^, num);
      fieldOIDSesion := qData.Fields[0];
      fieldCampo := qData.Fields[1];
      i := 0;
      while not qData.Eof do begin
        arrayInteger^[i].OIDSesion := fieldOIDSesion.AsInteger;
        arrayInteger^[i].Valor := fieldCampo.AsInteger;
        qData.Next;
        inc(i);
      end;
    finally
      qData.Free;
    end;
  finally
    database.Free;
  end;
end;

{
procedure TScriptDataCacheHorizontalFactory.OnTipoCotizacionCambiada;
begin
  EnterCriticalSection(criticalSection);
  try
    InitializeCache;
    // Se debe de recalcular el valor
    FOIDValor := -1;
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;
}
{ TScriptDataCacheHorizontal }

function TScriptDataCacheHorizontal.GetAmbienteIntradia: string;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetAmbienteIntradia(Self);
end;

function TScriptDataCacheHorizontal.GetApertura: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetApertura(Self);
end;

function TScriptDataCacheHorizontal.GetBandaAlta: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetBandaAlta(Self);
end;

function TScriptDataCacheHorizontal.GetBandaBaja: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetBandaBaja(Self);
end;

function TScriptDataCacheHorizontal.GetCambioAlzaDoble: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetCambioAlzaDoble(Self);
end;

function TScriptDataCacheHorizontal.GetCambioAlzaSimple: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetCambioAlzaSimple(Self);
end;

function TScriptDataCacheHorizontal.GetCambioBajaDoble: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetCambioBajaDoble(Self);
end;

function TScriptDataCacheHorizontal.GetCambioBajaSimple: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetCambioBajaSimple(Self);
end;

function TScriptDataCacheHorizontal.GetCierre: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetCierre(Self);
end;

function TScriptDataCacheHorizontal.GetCorrelacion: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetCorrelacion(Self);
end;

function TScriptDataCacheHorizontal.GetDiasSeguidosNum: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDiasSeguidosNum(Self);
end;

function TScriptDataCacheHorizontal.GetDiasSeguidosPerCent: single;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDiasSeguidosPerCent(Self);
end;

function TScriptDataCacheHorizontal.GetDimensionFractal: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDimensionFractal(Self);
end;

function TScriptDataCacheHorizontal.GetDinero: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDinero(Self);
end;

function TScriptDataCacheHorizontal.GetDineroAlzaDoble: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDineroAlzaDoble(Self);
end;

function TScriptDataCacheHorizontal.GetDineroAlzaSimple: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDineroAlzaSimple(Self);
end;

function TScriptDataCacheHorizontal.GetDineroBajaDoble: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDineroBajaDoble(Self);
end;

function TScriptDataCacheHorizontal.GetDineroBajaSimple: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDineroBajaSimple(Self);
end;

function TScriptDataCacheHorizontal.GetDobson10: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDobson10(Self);
end;

function TScriptDataCacheHorizontal.GetDobson100: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDobson100(Self);
end;

function TScriptDataCacheHorizontal.GetDobson130: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDobson130(Self);
end;

function TScriptDataCacheHorizontal.GetDobson40: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDobson40(Self);
end;

function TScriptDataCacheHorizontal.GetDobson70: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDobson70(Self);
end;

function TScriptDataCacheHorizontal.GetDobsonAlto10: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDobsonAlto10(Self);
end;

function TScriptDataCacheHorizontal.GetDobsonAlto100: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDobsonAlto100(Self);
end;

function TScriptDataCacheHorizontal.GetDobsonAlto130: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDobsonAlto130(Self);
end;

function TScriptDataCacheHorizontal.GetDobsonAlto40: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDobsonAlto40(Self);
end;

function TScriptDataCacheHorizontal.GetDobsonAlto70: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDobsonAlto70(Self);
end;

function TScriptDataCacheHorizontal.GetDobsonBajo10: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDobsonBajo10(Self);
end;

function TScriptDataCacheHorizontal.GetDobsonBajo100: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDobsonBajo100(Self);
end;

function TScriptDataCacheHorizontal.GetDobsonBajo130: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDobsonBajo130(Self);
end;

function TScriptDataCacheHorizontal.GetDobsonBajo40: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDobsonBajo40(Self);
end;

function TScriptDataCacheHorizontal.GetDobsonBajo70: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetDobsonBajo70(Self);
end;

function TScriptDataCacheHorizontal.GetIDCotizacion: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetIDCotizacion(Self);
end;

function TScriptDataCacheHorizontal.GetMaximo: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetMaximo(Self);
end;

function TScriptDataCacheHorizontal.GetMaximoPrevisto: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetMaximoPrevisto(Self);
end;

function TScriptDataCacheHorizontal.GetMaximoPrevistoAprox: single;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetMaximoPrevistoAprox(Self);
end;

function TScriptDataCacheHorizontal.GetMaximoSePrevino: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetMaximoSePrevino(Self);
end;

function TScriptDataCacheHorizontal.GetMedia200: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetMedia200(Self);
end;

function TScriptDataCacheHorizontal.GetMensajeFlags: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetMensajeFlags(Self);
end;

function TScriptDataCacheHorizontal.GetMinimo: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetMinimo(Self);
end;

function TScriptDataCacheHorizontal.GetMinimoPrevisto: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetMinimoPrevisto(Self);
end;

function TScriptDataCacheHorizontal.GetMinimoPrevistoAprox: single;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetMinimoPrevistoAprox(Self);
end;

function TScriptDataCacheHorizontal.GetMinimoSePrevino: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetMinimoSePrevino(Self);
end;

function TScriptDataCacheHorizontal.GetNivelActual: string;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetNivelActual(Self);
end;

function TScriptDataCacheHorizontal.GetNivelBaja: string;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetNivelBaja(Self);
end;

function TScriptDataCacheHorizontal.GetNivelSube: string;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetNivelSube(Self);
end;

function TScriptDataCacheHorizontal.GetPapel: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPapel(Self);
end;

function TScriptDataCacheHorizontal.GetPapelAlzaDoble: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPapelAlzaDoble(Self);
end;

function TScriptDataCacheHorizontal.GetPapelAlzaSimple: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPapelAlzaSimple(Self);
end;

function TScriptDataCacheHorizontal.GetPapelBajaDoble: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPapelBajaDoble(Self);
end;

function TScriptDataCacheHorizontal.GetPapelBajaSimple: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPapelBajaSimple(Self);
end;

function TScriptDataCacheHorizontal.GetPercentAlzaSimple: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPercentAlzaSimple(Self);
end;

function TScriptDataCacheHorizontal.GetPercentBajaSimple: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPercentBajaSimple(Self);
end;

function TScriptDataCacheHorizontal.GetPivotPoint: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPivotPoint(Self);
end;

function TScriptDataCacheHorizontal.GetPivotPointR1: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPivotPointR1(Self);
end;

function TScriptDataCacheHorizontal.GetPivotPointR2: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPivotPointR2(Self);
end;

function TScriptDataCacheHorizontal.GetPivotPointR3: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPivotPointR3(Self);
end;

function TScriptDataCacheHorizontal.GetPivotPointS1: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPivotPointS1(Self);
end;

function TScriptDataCacheHorizontal.GetPivotPointS2: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPivotPointS2(Self);
end;

function TScriptDataCacheHorizontal.GetPivotPointS3: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPivotPointS3(Self);
end;

function TScriptDataCacheHorizontal.GetPosicionado: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPosicionado(Self);
end;

function TScriptDataCacheHorizontal.GetPotencialFractal: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPotencialFractal(Self);
end;

function TScriptDataCacheHorizontal.GetPresionLateral: Single;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPresionLateral(Self);
end;

function TScriptDataCacheHorizontal.GetPresionLateralAlzaDoble: Single;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPresionLateralAlzaDoble(Self);
end;

function TScriptDataCacheHorizontal.GetPresionLateralAlzaSimple: Single;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPresionLateralAlzaSimple(Self);
end;

function TScriptDataCacheHorizontal.GetPresionLateralBajaDoble: Single;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPresionLateralBajaDoble(Self);
end;

function TScriptDataCacheHorizontal.GetPresionLateralBajaSimple: Single;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPresionLateralBajaSimple(Self);
end;

function TScriptDataCacheHorizontal.GetPresionVertical: Single;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPresionVertical(Self);
end;

function TScriptDataCacheHorizontal.GetPresionVerticalAlzaDoble: Single;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPresionVerticalAlzaDoble(Self);
end;

function TScriptDataCacheHorizontal.GetPresionVerticalAlzaSimple: Single;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPresionVerticalAlzaSimple(Self);
end;

function TScriptDataCacheHorizontal.GetPresionVerticalBajaDoble: Single;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPresionVerticalBajaDoble(Self);
end;

function TScriptDataCacheHorizontal.GetPresionVerticalBajaSimple: Single;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetPresionVerticalBajaSimple(Self);
end;

function TScriptDataCacheHorizontal.GetRentabilidadAbierta: single;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetRentabilidadAbierta(Self);
end;

function TScriptDataCacheHorizontal.GetRiesgo: Single;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetRiesgo(Self);
end;

function TScriptDataCacheHorizontal.GetRsi14: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetRsi14(Self);
end;

function TScriptDataCacheHorizontal.GetRsi140: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetRsi140(Self);
end;

function TScriptDataCacheHorizontal.GetStop: currency;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetStop(Self);
end;

function TScriptDataCacheHorizontal.GetVariabilidad: single;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetVariabilidad(Self);
end;

function TScriptDataCacheHorizontal.GetVariacion: single;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetVariacion(Self);
end;

function TScriptDataCacheHorizontal.GetVolatilidad: single;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetVolatilidad(Self);
end;

function TScriptDataCacheHorizontal.GetVolumen: integer;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetVolumen(Self);
end;

function TScriptDataCacheHorizontal.GetZona: string;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetZona(Self);
end;

function TScriptDataCacheHorizontal.GetZonaAlzaDoble: string;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetZonaAlzaDoble(Self);
end;

function TScriptDataCacheHorizontal.GetZonaAlzaSimple: string;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetZonaAlzaSimple(Self);
end;

function TScriptDataCacheHorizontal.GetZonaBajaDoble: string;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetZonaBajaDoble(Self);
end;

function TScriptDataCacheHorizontal.GetZonaBajaSimple: string;
begin
  result := TScriptDataCacheHorizontalFactory(Factory).GetZonaBajaSimple(Self);
end;

procedure TScriptDataCacheHorizontal.SetOIDValor(const Value: integer);
begin
  inherited;
  TScriptDataCacheHorizontalFactory(Factory).SetOIDValor(Value);
end;


end.
