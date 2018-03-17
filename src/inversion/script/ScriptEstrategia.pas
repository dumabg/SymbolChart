unit ScriptEstrategia;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ScriptDatosEngine, uPSComponent, Script_Mensaje, Script_Broker,
    Script_Log, DB,  Script_Util, Script, IBDatabase;

type
  TScriptEstrategia = class(TScriptDatosEngine)
  private
    Broker: TScriptBroker;
    Log: TScriptLog;
    Util: TScriptUtil;
    function GetOnAbrirPosicionLimitada: TOnAbrirPosicionLimitadaEvent;
    function GetOnAbrirPosicionMercado: TOnAbrirPosicionMercadoEvent;
    procedure SetOnAbrirPosicionLimitada(
      const Value: TOnAbrirPosicionLimitadaEvent);
    procedure SetOnAbrirPosicionMercado(
      const Value: TOnAbrirPosicionMercadoEvent);
    function GetOnLog: TOnLogEvent;
    procedure SetOnLog(const Value: TOnLogEvent);
    function GetOnModificarStop: TOnModificarStop;
    procedure SetOnModificarStop(const Value: TOnModificarStop);
    function GetOnCerrarPosicion: TOnCerrarPosicion;
    procedure SetOnCerrarPosicion(const Value: TOnCerrarPosicion);
    function GetOnCambioEntrada: TOnCambioEntrada;
    procedure SetOnCambioEntrada(const Value: TOnCambioEntrada);
  protected
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    property OnAbrirPosicionMercado: TOnAbrirPosicionMercadoEvent read GetOnAbrirPosicionMercado write SetOnAbrirPosicionMercado;
    property OnAbrirPosicionLimitada: TOnAbrirPosicionLimitadaEvent read GetOnAbrirPosicionLimitada write SetOnAbrirPosicionLimitada;
    property OnModificarStop: TOnModificarStop read GetOnModificarStop write SetOnModificarStop;
    property OnCerrarPosicion: TOnCerrarPosicion read GetOnCerrarPosicion write SetOnCerrarPosicion;
    property OnCambioEntrada: TOnCambioEntrada read GetOnCambioEntrada write SetOnCambioEntrada;
    property OnLog: TOnLogEvent read GetOnLog write SetOnLog;
  end;

implementation

uses uPSI_Broker, upSI_Datos, upSI_Log, upSI_Util;


constructor TScriptEstrategia.Create;
begin
  inherited Create(true);
  // MUY IMPORTANTE el orden de registro de los plugin si un plugin usa
  // tipos definidos en otro plugin
  RegisterPlugin(TPSImport_Broker, TScriptBroker);
  RegisterPlugin(TPSImport_Log, TScriptLog);
  RegisterPlugin(TPSImport_Util, TScriptUtil);

  Broker := TScriptBroker.Create;
  Log := TScriptLog.Create;
  Util := TScriptUtil.Create;

  RegisterScriptRootClass('Broker', Broker);
  RegisterScriptRootClass('Log', Log);
  RegisterScriptRootClass('Util', Util);
end;

destructor TScriptEstrategia.Destroy;
begin
  Broker.Free;
  Log.Free;
  Util.Free;
  inherited;
end;

function TScriptEstrategia.GetOnAbrirPosicionLimitada: TOnAbrirPosicionLimitadaEvent;
begin
  result := Broker.OnAbrirPosicionLimitada;
end;

function TScriptEstrategia.GetOnAbrirPosicionMercado: TOnAbrirPosicionMercadoEvent;
begin
  result := Broker.OnAbrirPosicionMercado;
end;

function TScriptEstrategia.GetOnCambioEntrada: TOnCambioEntrada;
begin
  result := Broker.OnCambioEntrada;
end;

function TScriptEstrategia.GetOnCerrarPosicion: TOnCerrarPosicion;
begin
  result := Broker.OnCerrarPosicion;
end;

function TScriptEstrategia.GetOnLog: TOnLogEvent;
begin
  result := Log.OnLog;
end;

function TScriptEstrategia.GetOnModificarStop: TOnModificarStop;
begin
  result := Broker.OnModificarStop;
end;

procedure TScriptEstrategia.SetOnAbrirPosicionLimitada(
  const Value: TOnAbrirPosicionLimitadaEvent);
begin
  Broker.OnAbrirPosicionLimitada := Value;
end;

procedure TScriptEstrategia.SetOnAbrirPosicionMercado(
  const Value: TOnAbrirPosicionMercadoEvent);
begin
  Broker.OnAbrirPosicionMercado := Value;
end;

procedure TScriptEstrategia.SetOnCambioEntrada(const Value: TOnCambioEntrada);
begin
  Broker.OnCambioEntrada := Value;
end;

procedure TScriptEstrategia.SetOnCerrarPosicion(const Value: TOnCerrarPosicion);
begin
  Broker.OnCerrarPosicion := Value;
end;

procedure TScriptEstrategia.SetOnLog(const Value: TOnLogEvent);
begin
  Log.OnLog := Value;
end;

procedure TScriptEstrategia.SetOnModificarStop(const Value: TOnModificarStop);
begin
  Broker.OnModificarStop := Value;
end;

end.



