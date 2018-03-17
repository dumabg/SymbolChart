unit dmEstrategiaInterpreter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmEstrategiaBase, DB,
  ScriptEstrategia, Script_Log, dmEstrategias, IBDatabase, kbmMemTable;

type
  EScriptExecution = class(Exception)
  private
    FColumna: integer;
    FFila: integer;
    FMensaje: string;
    FTipoEstrategia: TTipoEstrategia;
  public
    property mensaje: string read FMensaje;
    property fila: integer read FFila;
    property columna: integer read FColumna;
    property tipoEstrategia: TTipoEstrategia read FTipoEstrategia;
  end;

  EScriptCompile = class(Exception);


  TEstrategiaInterpreter = class(TEstrategiaBase)
  private
    ScriptEstrategiaApertura, ScriptEstrategiaCierre,
    ScriptEstrategiaAperturaPosicionado, ScriptEstrategiaCierrePosicionado: TScriptEstrategia;
    FOnLog: TOnLogEvent;
    procedure OnAbrirPosicion(const puntos: integer; const largo: boolean; const stop: currency);
    procedure OnAbrirPosicionLimitada(const puntos: integer; const largo: boolean;
      const stop: currency; const limite: currency);
    procedure OnCerrarPosicion;
    procedure OnModificarStop(stop: currency);
    procedure OnCambioEntrada(var cambio: currency);
    procedure SetEstrategiaApertura(const Value: string);
    function GetEstrategiaApertura: string;
    procedure SetOnLog(const Value: TOnLogEvent);
    function GetEstrategiaCierre: string;
    procedure SetEstrategiaCierre(const Value: string);
    function GetEstrategiaAperturaPosicionado: string;
    function GetEstrategiaCierrePosicionado: string;
    procedure SetEstrategiaAperturaPosicionado(const Value: string);
    procedure SetEstrategiaCierrePosicionado(const Value: string);
    procedure ExecEstrategia(const OIDValor: integer; const OIDSesion: integer;
      const ScriptEstrategia: TScriptEstrategia; const TipoEstrategia: TTipoEstrategia);
    function TipoEstrategiaToStr(const tipo: TTipoEstrategia): string;
    procedure Compile(const ScriptEstrategia: TScriptEstrategia; const TipoEstrategia: TTipoEstrategia);
  protected
    OIDValorExecuting: integer;
    procedure ExecEstrategiaApertura(const OIDValor: integer; const OIDSesion: integer);
    procedure ExecEstrategiaCierre(const OIDValor: integer; const OIDSesion: integer);
    procedure ExecEstrategiaAperturaPosicionado(const OIDValor: integer; const OIDSesion: integer);
    procedure ExecEstrategiaCierrePosicionado(const OIDValor: integer; const OIDSesion: integer);
  public
    destructor Destroy; override;
    procedure AntesAbrirSesion; override;
    procedure AntesCerrarSesion; override;
    procedure AntesAbrirSesionPosicionados; override;
    procedure AntesCerrarSesionPosicionados; override;
    property EstrategiaApertura: string read GetEstrategiaApertura write SetEstrategiaApertura;
    property EstrategiaCierre: string read GetEstrategiaCierre write SetEstrategiaCierre;
    property EstrategiaAperturaPosicionado: string read GetEstrategiaAperturaPosicionado write SetEstrategiaAperturaPosicionado;
    property EstrategiaCierrePosicionado: string read GetEstrategiaCierrePosicionado write SetEstrategiaCierrePosicionado;
    property OnLog: TOnLogEvent read FOnLog write SetOnLog;
  end;


  procedure GlobalInitialization;

implementation

uses dmDataComun, fmScriptError, uExceptionsManager, ScriptEngine;

{$R *.dfm}

resourcestring
  COMPILE_ERROR = 'El código del apartado %s de la estrategia es incorrecto.' + sLineBreak +
  'Vaya al apartado de Estrategias y revise el código.';
  APERTURA = 'Apertura';
  APERTURA_POSICIONADO = 'Apertura posicionado';
  CIERRE = 'Cierre';
  CIERRE_POSICIONADO = 'Cierre posicionado';


{ TEstrategiaInterpreter }

procedure TEstrategiaInterpreter.AntesAbrirSesion;
begin
  if ScriptEstrategiaApertura <> nil then
    inherited;
end;

procedure TEstrategiaInterpreter.AntesAbrirSesionPosicionados;
begin
  if ScriptEstrategiaAperturaPosicionado <> nil then
    inherited;
end;

procedure TEstrategiaInterpreter.AntesCerrarSesion;
begin
  if ScriptEstrategiaCierre <> nil then
    inherited;
end;

procedure TEstrategiaInterpreter.AntesCerrarSesionPosicionados;
begin
  if ScriptEstrategiaCierrePosicionado <> nil then
    inherited;
end;

procedure TEstrategiaInterpreter.Compile(const ScriptEstrategia: TScriptEstrategia;
  const TipoEstrategia: TTipoEstrategia);
var e: EScriptCompile;
  msg: string;
  tipo: string;
begin
  if not ScriptEstrategia.Compile then begin
    tipo := TipoEstrategiaToStr(TipoEstrategia);
    msg := Format(COMPILE_ERROR, [tipo]);
    e := EScriptCompile.Create(msg);
    raise e;
  end;
end;

destructor TEstrategiaInterpreter.Destroy;
begin
  if ScriptEstrategiaApertura <> nil then
    ScriptEstrategiaApertura.Free;
  if ScriptEstrategiaCierre <> nil then
    ScriptEstrategiaCierre.Free;
  if ScriptEstrategiaAperturaPosicionado <> nil then
    ScriptEstrategiaAperturaPosicionado.Free;
  if ScriptEstrategiaCierrePosicionado <> nil then
    ScriptEstrategiaCierrePosicionado.Free;
  inherited;
end;

procedure TEstrategiaInterpreter.ExecEstrategia(const OIDValor: integer;
  const OIDSesion: integer; const ScriptEstrategia: TScriptEstrategia;
    const TipoEstrategia: TTipoEstrategia);

  function CreateEScriptExecution(const excep: boolean): EScriptExecution;
  var msg: string;
    pValor: PDataComunValor;
  begin
    msg := TipoEstrategiaToStr(TipoEstrategia);
    pValor := DataComun.FindValor(OIDValor);
    msg := msg + sLineBreak + pValor^.Simbolo + ' - ' + pValor^.Nombre + sLineBreak +
      DateToStr(DataComun.FindFecha(OIDSesion)) + sLineBreak +
      IntToStr(ScriptEstrategia.ExecuteErrorRow) + ':' + IntToStr(ScriptEstrategia.ExecuteErrorCol) + sLineBreak;
    if excep then
      msg := msg + ScriptEstrategia.ExceptionObj + ': ' + ScriptEstrategia.ExceptionMsg
    else
      msg := msg + ScriptEstrategia.ExecuteErrorMsg;
    result := EScriptExecution.Create(msg);
    result.FColumna := ScriptEstrategia.ExecuteErrorCol;
    result.FFila := ScriptEstrategia.ExecuteErrorRow;
    if excep then
      result.FMensaje := ScriptEstrategia.ExceptionObj + ': ' + ScriptEstrategia.ExceptionMsg
    else
      result.FMensaje := ScriptEstrategia.ExecuteErrorMsg;
    result.FTipoEstrategia := TipoEstrategia;
  end;
begin
  inherited;
  OIDValorExecuting := OIDValor;
  ScriptEstrategia.Load(OIDValor, OIDSesion);
  try
    if not ScriptEstrategia.Execute then
      raise CreateEScriptExecution(ScriptEstrategia.HasExceptionError);
  except
    on e: EStopScript do
      if not ScriptEstrategia.EDatoNotFound then
        raise;
  end;
end;

procedure TEstrategiaInterpreter.ExecEstrategiaApertura(const OIDValor: integer;
  const OIDSesion: integer);
begin
  ExecEstrategia(OIDValor, OIDSesion, ScriptEstrategiaApertura, teApertura);
end;

procedure TEstrategiaInterpreter.ExecEstrategiaAperturaPosicionado(
  const OIDValor: integer; const OIDSesion: integer);
begin
  ExecEstrategia(OIDValor, OIDSesion, ScriptEstrategiaAperturaPosicionado, teAperturaPosicionado);
end;

procedure TEstrategiaInterpreter.ExecEstrategiaCierre(const OIDValor: integer;
  const OIDSesion: integer);
begin
  ExecEstrategia(OIDValor, OIDSesion, ScriptEstrategiaCierre, teCierre);
end;

procedure TEstrategiaInterpreter.ExecEstrategiaCierrePosicionado(
  const OIDValor: integer; const OIDSesion: integer);
begin
  ExecEstrategia(OIDValor, OIDSesion, ScriptEstrategiaCierrePosicionado, teCierrePosicionado);
end;

function TEstrategiaInterpreter.GetEstrategiaApertura: string;
begin
  result := ScriptEstrategiaApertura.Code;
end;

function TEstrategiaInterpreter.GetEstrategiaAperturaPosicionado: string;
begin
  result := ScriptEstrategiaAperturaPosicionado.Code;
end;

function TEstrategiaInterpreter.GetEstrategiaCierre: string;
begin
  result := ScriptEstrategiaCierre.Code;
end;

function TEstrategiaInterpreter.GetEstrategiaCierrePosicionado: string;
begin
  result := ScriptEstrategiaCierrePosicionado.Code;
end;

procedure TEstrategiaInterpreter.OnModificarStop(stop: currency);
begin
  ModificarStop(stop);
end;

procedure TEstrategiaInterpreter.OnAbrirPosicion(const puntos: integer;
  const largo: boolean; const stop: currency);
begin
  AbrirPosicion(puntos, false, largo, stop);
end;

procedure TEstrategiaInterpreter.OnAbrirPosicionLimitada(const puntos: integer;
  const largo: boolean; const stop, limite: currency);
begin
  AbrirPosicion(puntos, true, largo, stop, limite);
end;

procedure TEstrategiaInterpreter.OnCambioEntrada(var cambio: currency);
begin
  cambio := CambioEntrada;
end;

procedure TEstrategiaInterpreter.OnCerrarPosicion;
begin
  CerrarPosicion;
end;

procedure TEstrategiaInterpreter.SetEstrategiaApertura(const Value: string);
var HayScriptApertura: boolean;
begin
  HayScriptApertura := Value <> '';
  if HayScriptApertura then begin
    if ScriptEstrategiaApertura = nil then
      ScriptEstrategiaApertura := TScriptEstrategia.Create;
    ScriptEstrategiaApertura.OnAbrirPosicionMercado := OnAbrirPosicion;
    ScriptEstrategiaApertura.OnAbrirPosicionLimitada := OnAbrirPosicionLimitada;
    ScriptEstrategiaApertura.OnModificarStop := OnModificarStop;
    ScriptEstrategiaApertura.OnCerrarPosicion := OnCerrarPosicion;
    ScriptEstrategiaApertura.OnCambioEntrada := OnCambioEntrada;
    ScriptEstrategiaApertura.OnLog := OnLog;
    ScriptEstrategiaApertura.Code := Value;
    Compile(ScriptEstrategiaApertura, teApertura);
  end;
end;

procedure TEstrategiaInterpreter.SetEstrategiaAperturaPosicionado(
  const Value: string);
var HayScript: boolean;
begin
  HayScript := Value <> '';
  if HayScript then begin
    if ScriptEstrategiaAperturaPosicionado = nil then
      ScriptEstrategiaAperturaPosicionado := TScriptEstrategia.Create;
    ScriptEstrategiaAperturaPosicionado.OnAbrirPosicionMercado := OnAbrirPosicion;
    ScriptEstrategiaAperturaPosicionado.OnAbrirPosicionLimitada := OnAbrirPosicionLimitada;
    ScriptEstrategiaAperturaPosicionado.OnModificarStop := OnModificarStop;
    ScriptEstrategiaAperturaPosicionado.OnCerrarPosicion := OnCerrarPosicion;
    ScriptEstrategiaAperturaPosicionado.OnCambioEntrada := OnCambioEntrada;
    ScriptEstrategiaAperturaPosicionado.OnLog := OnLog;
    ScriptEstrategiaAperturaPosicionado.Code := Value;
    Compile(ScriptEstrategiaAperturaPosicionado, teAperturaPosicionado);
  end;
end;

procedure TEstrategiaInterpreter.SetEstrategiaCierre(const Value: string);
var HayScriptCierre: boolean;
begin
  HayScriptCierre := Value <> '';
  if HayScriptCierre then begin
    if ScriptEstrategiaCierre = nil then
      ScriptEstrategiaCierre := TScriptEstrategia.Create;
    ScriptEstrategiaCierre.OnAbrirPosicionMercado := OnAbrirPosicion;
    ScriptEstrategiaCierre.OnAbrirPosicionLimitada := OnAbrirPosicionLimitada;
    ScriptEstrategiaCierre.OnCerrarPosicion := OnCerrarPosicion;
    ScriptEstrategiaCierre.OnCambioEntrada := OnCambioEntrada;
    ScriptEstrategiaCierre.OnLog := OnLog;
    ScriptEstrategiaCierre.OnModificarStop := OnModificarStop;
    ScriptEstrategiaCierre.Code := Value;
    Compile(ScriptEstrategiaCierre, teCierre);
  end;
end;

procedure TEstrategiaInterpreter.SetEstrategiaCierrePosicionado(
  const Value: string);
var HayScript: boolean;
begin
  HayScript := Value <> '';
  if HayScript then begin
    if ScriptEstrategiaCierrePosicionado = nil then
      ScriptEstrategiaCierrePosicionado := TScriptEstrategia.Create;
    ScriptEstrategiaCierrePosicionado.OnAbrirPosicionMercado := OnAbrirPosicion;
    ScriptEstrategiaCierrePosicionado.OnAbrirPosicionLimitada := OnAbrirPosicionLimitada;
    ScriptEstrategiaCierrePosicionado.OnCerrarPosicion := OnCerrarPosicion;
    ScriptEstrategiaCierrePosicionado.OnCambioEntrada := OnCambioEntrada;
    ScriptEstrategiaCierrePosicionado.OnLog := OnLog;
    ScriptEstrategiaCierrePosicionado.OnModificarStop := OnModificarStop;
    ScriptEstrategiaCierrePosicionado.Code := Value;
    Compile(ScriptEstrategiaCierrePosicionado, teCierrePosicionado);
  end;
end;

procedure TEstrategiaInterpreter.SetOnLog(const Value: TOnLogEvent);
begin
  FOnLog := Value;
  if ScriptEstrategiaApertura <> nil then
    ScriptEstrategiaApertura.OnLog := FOnLog;
  if ScriptEstrategiaAperturaPosicionado <> nil then
    ScriptEstrategiaAperturaPosicionado.OnLog := FOnLog;
  if ScriptEstrategiaCierre <> nil then
    ScriptEstrategiaCierre.OnLog := FOnLog;
  if ScriptEstrategiaCierrePosicionado <> nil then
    ScriptEstrategiaCierrePosicionado.OnLog := FOnLog;
end;

function TEstrategiaInterpreter.TipoEstrategiaToStr(
  const tipo: TTipoEstrategia): string;
begin
  case tipo of
    teApertura: result := APERTURA;
    teAperturaPosicionado: result := APERTURA_POSICIONADO;
    teCierre: result := CIERRE;
    teCierrePosicionado: result := CIERRE_POSICIONADO;
  end;
end;

procedure GlobalInitialization;
begin
  exceptionManager.RegisterKnowExceptionClass(EScriptCompile);
end;

end.
