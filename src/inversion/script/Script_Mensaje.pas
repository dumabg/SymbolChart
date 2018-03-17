unit Script_Mensaje;

interface

uses
  flags, Classes, ScriptObject;

type
  TTipoMensaje = (tmInicioCiclo, tmInicioCicloVirtual, tmMantener,
    tmPrimeraAdvertencia, tmPrimeraAdvertenciaVirtual, tmAdvertencia,
    tmResistenciaPura, tmFranjaResistencia, tmAreasResistencia,
    tmSoportePuro, tmFranjaSoporte, tmAreasSoporte,
    tmAcumulacion, tmPreparandoAcumulacion, tmDistribucion, tmPreparandoDistribucion,
    tmRemontar, tmAgregar, tmAlza, tmFalsaAlarma, tmSeguridad, tmSiempreCuando,
    tmSueloInminente, tmSueloBusqueda, tmSueloProvisional,
    tmTechoInminente, tmTechoBusqueda, tmTechoProvisional);

  TScriptMensaje = class(TScriptObject)
  private
    Flags: TFlags;
    procedure SetDataFlags(const Value: integer);
    function GetDataFlags: integer;
  protected
    function GetScriptInstance: TScriptObjectInstance; override;
  public
    constructor Create; 
    destructor Destroy; override;
    property DataFlags: integer read GetDataFlags write SetDataFlags;
  end;

  {$METHODINFO ON}
  TMensaje = class(TScriptObjectInstance)
    function Es(tipo: TTipoMensaje): boolean;
  end;
  {$METHODINFO OFF}

implementation

uses SysUtils, Script;

constructor TScriptMensaje.Create;
begin
  inherited;
  Flags := TFlags.Create;
end;

destructor TScriptMensaje.Destroy;
begin
  Flags.Free;
  inherited;
end;

function TScriptMensaje.GetDataFlags: integer;
begin
  result := Flags.Flags;
end;

function TScriptMensaje.GetScriptInstance: TScriptObjectInstance;
begin
  result := TMensaje.Create;
end;

procedure TScriptMensaje.SetDataFlags(const Value: integer);
begin
  Flags.Flags := Value;
end;

{ TMensaje }

function TMensaje.Es(tipo: TTipoMensaje): boolean;
begin
  result := TScriptMensaje(FScriptObject).Flags.Es(TCaracteristicaFlag(tipo));
end;

initialization
  RegisterEnumeration('TTipoMensaje', TypeInfo(TTipoMensaje));

end.
