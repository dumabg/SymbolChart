unit ScriptDataCache;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmThreadDataModule, Contnrs;

type
  EDatoNoEncontrado = class(Exception);

  TScriptDataCacheFactory = class;

  TScriptDataCache = class
  protected
    Factory: TScriptDataCacheFactory;
    FOIDValor: integer;
    FOIDSesion: integer;
    procedure SetOIDSesion(const Value: integer); virtual;
    procedure SetOIDValor(const Value: integer); virtual;
    procedure OnTipoCotizacionCambiada;
  public
    constructor Create;
    destructor Destroy; override;
    function GetIDCotizacion: integer; virtual; abstract;
    function GetCierre: currency; virtual; abstract;
    function GetApertura: currency; virtual; abstract;
    function GetVolumen: integer; virtual; abstract;
    function GetDiasSeguidosNum: integer; virtual; abstract;
    function GetDiasSeguidosPerCent: single; virtual; abstract;
    function GetMaximo: currency; virtual; abstract;
    function GetMinimo: currency; virtual; abstract;
    function GetVariacion: single; virtual; abstract;
    function GetMensajeFlags: integer; virtual; abstract;
    function GetAmbienteIntradia: string; virtual; abstract;
    function GetBandaAlta: currency; virtual; abstract;
    function GetBandaBaja: currency; virtual; abstract;
    function GetCorrelacion: integer; virtual; abstract;
    function GetDimensionFractal: currency; virtual; abstract;
    function GetDinero: currency; virtual; abstract;
    function GetDineroAlzaDoble: currency; virtual; abstract;
    function GetDineroAlzaSimple: currency; virtual; abstract;
    function GetDineroBajaDoble: currency; virtual; abstract;
    function GetDineroBajaSimple: currency; virtual; abstract;
    function GetDobson10: integer; virtual; abstract;
    function GetDobson100: integer; virtual; abstract;
    function GetDobson130: integer; virtual; abstract;
    function GetDobson40: integer; virtual; abstract;
    function GetDobson70: integer; virtual; abstract;
    function GetDobsonAlto10: integer; virtual; abstract;
    function GetDobsonAlto100: integer; virtual; abstract;
    function GetDobsonAlto130: integer; virtual; abstract;
    function GetDobsonAlto40: integer; virtual; abstract;
    function GetDobsonAlto70: integer; virtual; abstract;
    function GetDobsonBajo10: integer; virtual; abstract;
    function GetDobsonBajo100: integer; virtual; abstract;
    function GetDobsonBajo130: integer; virtual; abstract;
    function GetDobsonBajo40: integer; virtual; abstract;
    function GetDobsonBajo70: integer; virtual; abstract;
    function GetMaximoPrevisto: currency; virtual; abstract;
    function GetMaximoPrevistoAprox: single; virtual; abstract;
    function GetMaximoSePrevino: currency; virtual; abstract;
    function GetMedia200: currency; virtual; abstract;
    function GetMinimoPrevisto: currency; virtual; abstract;
    function GetMinimoPrevistoAprox: single; virtual; abstract;
    function GetMinimoSePrevino: currency; virtual; abstract;
    function GetNivelActual: string; virtual; abstract;
    function GetNivelBaja: string; virtual; abstract;
    function GetNivelSube: string; virtual; abstract;
    function GetPapel: currency; virtual; abstract;
    function GetPapelAlzaDoble: currency; virtual; abstract;
    function GetPapelAlzaSimple: currency; virtual; abstract;
    function GetPapelBajaDoble: currency; virtual; abstract;
    function GetPapelBajaSimple: currency; virtual; abstract;
    function GetPercentAlzaSimple: currency; virtual; abstract;
    function GetPercentBajaSimple: currency; virtual; abstract;
    function GetPivotPoint: currency; virtual; abstract;
    function GetPivotPointR1: currency; virtual; abstract;
    function GetPivotPointR2: currency; virtual; abstract;
    function GetPivotPointR3: currency; virtual; abstract;
    function GetPivotPointS1: currency; virtual; abstract;
    function GetPivotPointS2: currency; virtual; abstract;
    function GetPivotPointS3: currency; virtual; abstract;
    function GetPotencialFractal: integer; virtual; abstract;
    function GetRentabilidadAbierta: single; virtual; abstract;
    function GetRsi14: integer; virtual; abstract;
    function GetRsi140: integer; virtual; abstract;
    function GetStop: currency; virtual; abstract;
    function GetPosicionado: currency; virtual; abstract;
    function GetVariabilidad: single; virtual; abstract;
    function GetVolatilidad: single; virtual; abstract;
    function GetZona: string; virtual; abstract;
    function GetZonaAlzaDoble: string; virtual; abstract;
    function GetZonaAlzaSimple: string; virtual; abstract;
    function GetZonaBajaDoble: string; virtual; abstract;
    function GetZonaBajaSimple: string; virtual; abstract;
    function GetRiesgo: Single; virtual; abstract;
    function GetPresionVertical: Single; virtual; abstract;
    function GetPresionVerticalAlzaSimple: Single; virtual; abstract;
    function GetPresionVerticalAlzaDoble: Single; virtual; abstract;
    function GetPresionVerticalBajaSimple: Single; virtual; abstract;
    function GetPresionVerticalBajaDoble: Single; virtual; abstract;
    function GetPresionLateral: Single; virtual; abstract;
    function GetPresionLateralAlzaSimple: Single; virtual; abstract;
    function GetPresionLateralAlzaDoble: Single; virtual; abstract;
    function GetPresionLateralBajaSimple: Single; virtual; abstract;
    function GetPresionLateralBajaDoble: Single; virtual; abstract;
    function GetCambioAlzaSimple: currency; virtual; abstract;
    function GetCambioAlzaDoble: currency; virtual; abstract;
    function GetCambioBajaSimple: currency; virtual; abstract;
    function GetCambioBajaDoble: currency; virtual; abstract;
    property OIDValor: integer read FOIDValor write SetOIDValor;
    property OIDSesion: integer read FOIDSesion write SetOIDSesion;
  end;

  TScriptDataCacheClass = class of TScriptDataCache;

  TScriptDataCacheFactory = class(TObject)
  private
    FScriptDataCacheClass: TScriptDataCacheClass;
  protected
    Cursores: TObjectList;
    property ScriptDataCacheClass: TScriptDataCacheClass read FScriptDataCacheClass write FScriptDataCacheClass;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function GetCursor: TScriptDataCache; virtual;
    procedure ReleaseCursor(const cursor: TScriptDataCache); virtual;
    procedure InitializeCache; virtual; abstract;
  end;


implementation

uses BusCommunication, dmData, GlobalSyncronization;

{ TScriptDataCache }

constructor TScriptDataCache.Create;
begin
  Bus.RegisterEvent(MessageTipoCotizacionCambiada, OnTipoCotizacionCambiada);
end;

destructor TScriptDataCache.Destroy;
begin
  Bus.UnregisterEvent(MessageTipoCotizacionCambiada, OnTipoCotizacionCambiada);
  inherited;
end;

procedure TScriptDataCache.OnTipoCotizacionCambiada;
begin
  FOIDSesion := -1;
  FOIDValor := -1;
  
end;

procedure TScriptDataCache.SetOIDSesion(const Value: integer);
begin
  FOIDSesion := Value;
end;

procedure TScriptDataCache.SetOIDValor(const Value: integer);
begin
  FOIDValor := Value;
end;

{ TScriptDataCacheFactory }

constructor TScriptDataCacheFactory.Create;
begin
  inherited Create;
  Cursores := TObjectList.Create(true);
end;

destructor TScriptDataCacheFactory.Destroy;
begin
  Cursores.Free;
  inherited;
end;

function TScriptDataCacheFactory.GetCursor: TScriptDataCache;
begin
  GlobalEnterCriticalSection;
  try
    result := FScriptDataCacheClass.Create;
    result.Factory := Self;
    Cursores.Add(result);
  finally
    GlobalLeaveCriticalSection;
  end;
end;

procedure TScriptDataCacheFactory.ReleaseCursor(const cursor: TScriptDataCache);
var i: Integer;
begin
  GlobalEnterCriticalSection;
  try
    i := Cursores.IndexOf(cursor);
    if i <> -1 then
      Cursores.Delete(i);
  finally
    GlobalLeaveCriticalSection;
  end;
end;

end.
