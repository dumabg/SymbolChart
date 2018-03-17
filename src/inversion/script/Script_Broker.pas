unit Script_Broker;

interface

uses Classes, ScriptObject;

type
  TOnAbrirPosicionMercadoEvent = procedure (const puntos: integer; const largo: boolean;
    const stop: currency) of object;
  TOnAbrirPosicionLimitadaEvent = procedure (const puntos: integer;
    const largo: boolean; const stop: currency; const limite: currency) of object;
  TOnModificarStop = procedure (stop: currency) of object;
  TOnCerrarPosicion = procedure of object;
  TOnCambioEntrada = procedure (var cambio: currency) of object;

  TScriptBroker = class(TScriptObject)
  private
    FOnAbrirPosicionMercado: TOnAbrirPosicionMercadoEvent;
    FOnAbrirPosicionLimitada: TOnAbrirPosicionLimitadaEvent;
    FOnModificarStop: TOnModificarStop;
    FOnCerrarPosicion: TOnCerrarPosicion;
    FOnCambioEntrada: TOnCambioEntrada;
  protected
    function GetScriptInstance: TScriptObjectInstance; override;
  public
    property OnAbrirPosicionMercado: TOnAbrirPosicionMercadoEvent read FOnAbrirPosicionMercado write FOnAbrirPosicionMercado;
    property OnAbrirPosicionLimitada: TOnAbrirPosicionLimitadaEvent read FOnAbrirPosicionLimitada write FOnAbrirPosicionLimitada;
    property OnModificarStop: TOnModificarStop read FOnModificarStop write FOnModificarStop;
    property OnCerrarPosicion: TOnCerrarPosicion read FOnCerrarPosicion write FOnCerrarPosicion;
    property OnCambioEntrada: TOnCambioEntrada read FOnCambioEntrada write FOnCambioEntrada;
  end;

  {$METHODINFO ON}
  TBroker = class(TScriptObjectInstance)
    procedure AbrirPosicionMercado(puntos: integer; largos: boolean; stop: currency);
    procedure AbrirPosicionLimitada(puntos: integer; largos: boolean; stop, limite: currency);
    procedure ModificarStop(stop: currency);
    procedure CerrarPosicion;
    function CambioEntrada: currency;
  end;
  {$METHODINFO OFF}

implementation


{ TScriptBroker }


{ TBroker }

procedure TBroker.AbrirPosicionLimitada(puntos: integer; largos: boolean; stop,
  limite: currency);
begin
  TScriptBroker(FScriptObject).FOnAbrirPosicionLimitada(puntos, largos, stop, limite);
end;

procedure TBroker.AbrirPosicionMercado(puntos: integer; largos: boolean;
  stop: currency);
begin
  TScriptBroker(FScriptObject).FOnAbrirPosicionMercado(puntos, largos, stop);
end;

function TBroker.CambioEntrada: currency;
var cambio: currency;
begin
  TScriptBroker(FScriptObject).FOnCambioEntrada(cambio);
  result := cambio;
end;

procedure TBroker.CerrarPosicion;
begin
  TScriptBroker(FScriptObject).FOnCerrarPosicion;
end;

procedure TBroker.ModificarStop(stop: currency);
begin
  TScriptBroker(FScriptObject).FOnModificarStop(stop);
end;

{ TScriptBroker }

function TScriptBroker.GetScriptInstance: TScriptObjectInstance;
begin
  result := TBroker.Create;
end;

end.
