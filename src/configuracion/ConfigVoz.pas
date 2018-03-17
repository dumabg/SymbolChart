unit ConfigVoz;

interface

type
  TConfigVoz = class
  private
    function GetActiva: integer;
    function GetVelocidad: integer;
    function GetVolumen: integer;
    procedure SetActiva(const Value: integer);
    procedure SetVelocidad(const Value: integer);
    procedure SetVolumen(const Value: integer);
  public
    property Velocidad: integer read GetVelocidad write SetVelocidad;
    property Volumen: integer read GetVolumen write SetVolumen;
    property Activa: integer read GetActiva write SetActiva;
  end;

implementation

uses dmConfiguracion;

const
  SECCION: string = 'Configuracion.Voz';

{ TConfigVoz }

function TConfigVoz.GetActiva: integer;
begin
  result := Configuracion.ReadInteger(SECCION, 'Activa', 0);
end;

function TConfigVoz.GetVelocidad: integer;
begin
  result := Configuracion.ReadInteger(SECCION, 'Velocidad', 0);
end;

function TConfigVoz.GetVolumen: integer;
begin
  result := Configuracion.ReadInteger(SECCION, 'Volumen', 100);
end;

procedure TConfigVoz.SetActiva(const Value: integer);
begin
  Configuracion.WriteInteger(SECCION, 'Activa', Value);
end;

procedure TConfigVoz.SetVelocidad(const Value: integer);
begin
  Configuracion.WriteInteger(SECCION, 'Velocidad', Value);
end;

procedure TConfigVoz.SetVolumen(const Value: integer);
begin
  Configuracion.WriteInteger(SECCION, 'Volumen', Value);
end;

end.
