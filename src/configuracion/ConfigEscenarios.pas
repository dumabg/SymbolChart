unit ConfigEscenarios;

interface

type
  TConfigEscenarios = class
  private
    function GetDesviacionAutomatico: boolean;
    function GetDesviacionPerCent: currency;
    function GetIntentos: integer;
    function GetSintonizacion: integer;
    procedure SetDesviacionAutomatico(const Value: boolean);
    procedure SetDesviacionPerCent(const Value: currency);
    procedure SetIntentos(const Value: integer);
    procedure SetSintonizacion(const Value: integer);
  public
    property Intentos: integer read GetIntentos write SetIntentos;
    property DesviacionPerCent: currency read GetDesviacionPerCent write SetDesviacionPerCent;
    property DesviacionAutomatico: boolean read GetDesviacionAutomatico write SetDesviacionAutomatico;
    property Sintonizacion: integer read GetSintonizacion write SetSintonizacion;    
  end;

implementation

uses dmConfiguracion;

const
  SECCION: string = 'Configuracion.Escenarios';

{ TConfigEscenarios }

function TConfigEscenarios.GetDesviacionAutomatico: boolean;
begin
  result := Configuracion.ReadBoolean(SECCION, 'DesviacionAutomatico', true);
end;

function TConfigEscenarios.GetDesviacionPerCent: currency;
begin
  result := Configuracion.ReadCurrency(SECCION, 'DesviacionPerCent', 0);
end;

function TConfigEscenarios.GetIntentos: integer;
begin
  result := Configuracion.ReadInteger(SECCION, 'Intentos', 50);
end;

function TConfigEscenarios.GetSintonizacion: integer;
begin
  result := Configuracion.ReadInteger(SECCION, 'Sintonizacion', 5);
end;

procedure TConfigEscenarios.SetDesviacionAutomatico(const Value: boolean);
begin
  Configuracion.WriteBoolean(SECCION, 'DesviacionAutomatico', Value);
end;

procedure TConfigEscenarios.SetDesviacionPerCent(const Value: currency);
begin
  Configuracion.WriteCurrency(SECCION, 'DesviacionPerCent', Value);
end;

procedure TConfigEscenarios.SetIntentos(const Value: integer);
begin
  Configuracion.WriteInteger(SECCION, 'Intentos', Value);
end;

procedure TConfigEscenarios.SetSintonizacion(const Value: integer);
begin
  Configuracion.WriteInteger(SECCION, 'Sintonizacion', Value);
end;

end.
