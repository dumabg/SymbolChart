unit ConfigVersion;

interface

type
  TConfigVersion = class
  private
    function GetVersionNuevaAlArrancar: boolean;
    procedure SetVersionNuevaAlArrancar(const Value: boolean);
  public
    property VersionNuevaAlArrancar: boolean read GetVersionNuevaAlArrancar write SetVersionNuevaAlArrancar;
  end;

implementation

uses dmConfiguracion;

{ TConfigVersion }

function TConfigVersion.GetVersionNuevaAlArrancar: boolean;
begin
  result := Configuracion.ReadBoolean('Configuracion.Version', 'VersionNuevaAlArrancar', true);
end;


procedure TConfigVersion.SetVersionNuevaAlArrancar(const Value: boolean);
begin
  Configuracion.WriteBoolean('Configuracion.Version', 'VersionNuevaAlArrancar', Value);
end;

end.
