unit ScriptDatosEngine;

interface

uses ScriptEngine, Script_Datos;

type
  TScriptDatosEngine = class(TScriptEngine)
  private
    FEDatoNotFound: boolean;
  protected
    Datos: TScriptDatos;
  public
    constructor Create(const VerticalCache: Boolean); reintroduce;
    destructor Destroy; override;
    procedure Load(const OIDValor: integer; const OIDSesion: integer);
    function Execute: boolean; override;
    procedure OnEDatoNotFound;
    property EDatoNotFound: boolean read FEDatoNotFound;
  end;

implementation

uses uPSI_Datos, uPSI_Mensaje, Script_Mensaje;


{ TScriptDatosEngine }

constructor TScriptDatosEngine.Create(const VerticalCache: Boolean);
begin
  inherited Create;
  RegisterPlugin(TPSImport_Mensaje, TScriptMensaje);
  RegisterPlugin(TPSImport_Datos, TScriptDatos);
  Datos := TScriptDatos.Create(Self, VerticalCache);
  RegisterScriptRootClass('Datos', Datos);
end;

destructor TScriptDatosEngine.Destroy;
begin
  Datos.Free;
  inherited;
end;

function TScriptDatosEngine.Execute: boolean;
begin
  FEDatoNotFound := false;
  Result := inherited Execute;
  if FEDatoNotFound then
    Result := false;
end;

procedure TScriptDatosEngine.Load(const OIDValor, OIDSesion: integer);
begin
  Datos.OIDValor := OIDValor;
  Datos.OIDSesion := OIDSesion;
end;

procedure TScriptDatosEngine.OnEDatoNotFound;
begin
  FEDatoNotFound := true;
  Stop;
end;

end.
