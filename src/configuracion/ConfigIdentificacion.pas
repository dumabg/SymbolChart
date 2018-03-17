unit ConfigIdentificacion;

interface

type
  TConfigIdentificacion = class
  private
    function GetAlEntrar: boolean;
    function GetContrasenaBloquear: string;
    function GetRellenoAutomatico: boolean;
    function GetUsuario: string;
    procedure SetAlEntrar(const Value: boolean);
    procedure SetRellenoAutomatico(const Value: boolean);
    procedure SetUsuario(const Value: string);
    procedure SetContrasenaBloquear(const Value: string);
    function GetUsuarioBloquear: string;
    procedure SetUsuarioBloquear(const Value: string);
    function GetBloquear: boolean;
    procedure SetBloquear(const Value: boolean);
  public
    property Usuario: string read GetUsuario write SetUsuario;
    property UsuarioBloquear: string read GetUsuarioBloquear write SetUsuarioBloquear;
    property ContrasenaBloquear: string read GetContrasenaBloquear write SetContrasenaBloquear;
    property Bloquear: boolean read GetBloquear write SetBloquear;
    property AlEntrar: boolean read GetAlEntrar write SetAlEntrar;
    property RellenoAutomatico: boolean read GetRellenoAutomatico write SetRellenoAutomatico;
  end;

implementation

uses dmConfiguracion;

const
  SECCION: string = 'Configuracion.Identificacion';

{ TConfigIdentificacion }

function TConfigIdentificacion.GetAlEntrar: boolean;
begin
  result := Configuracion.ReadBoolean(SECCION, 'AlEntrar', false);
end;

function TConfigIdentificacion.GetBloquear: boolean;
begin
  result := Configuracion.ReadBoolean(SECCION, 'Bloquear', false);
end;

function TConfigIdentificacion.GetContrasenaBloquear: string;
begin
  result := Configuracion.ReadString(SECCION, 'ContrasenaBloquear', '');
end;

function TConfigIdentificacion.GetRellenoAutomatico: boolean;
begin
  result := Configuracion.ReadBoolean(SECCION, 'RellenoAutomatico', false);
end;

function TConfigIdentificacion.GetUsuario: string;
begin
  result := Configuracion.ReadString(SECCION, 'Usuario', '');
end;

function TConfigIdentificacion.GetUsuarioBloquear: string;
begin
  Result := Configuracion.ReadString(SECCION, 'UsuarioBloquear', '');
end;

procedure TConfigIdentificacion.SetAlEntrar(const Value: boolean);
begin
  Configuracion.WriteBoolean(SECCION, 'AlEntrar', Value);
end;

procedure TConfigIdentificacion.SetBloquear(const Value: boolean);
begin
  Configuracion.WriteBoolean(SECCION, 'Bloquear', Value);
end;

procedure TConfigIdentificacion.SetContrasenaBloquear(const Value: string);
begin
  Configuracion.WriteString(SECCION, 'ContrasenaBloquear', Value);
end;

procedure TConfigIdentificacion.SetRellenoAutomatico(const Value: boolean);
begin
  Configuracion.WriteBoolean(SECCION, 'RellenoAutomatico', Value);
end;

procedure TConfigIdentificacion.SetUsuario(const Value: string);
begin
  Configuracion.WriteString(SECCION, 'Usuario', Value);
end;

procedure TConfigIdentificacion.SetUsuarioBloquear(const Value: string);
begin
  Configuracion.WriteString(SECCION, 'UsuarioBloquear', Value);
end;

end.
