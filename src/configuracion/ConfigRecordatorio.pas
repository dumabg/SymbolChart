unit ConfigRecordatorio;

interface

type
  TConfigRecordatorio = class
  private
    function GetMostrarAlIniciar: boolean;
    procedure SetMostrarAlIniciar(const Value: boolean);
  public
    property MostrarAlIniciar: boolean read GetMostrarAlIniciar write SetMostrarAlIniciar;
  end;

implementation

uses dmConfiguracion;

const
  SECCION: string = 'Configuracion.Recordatorio';

{ TConfigRecordatorio }

function TConfigRecordatorio.GetMostrarAlIniciar: boolean;
begin
  result := Configuracion.ReadBoolean(SECCION, 'MostrarAlIniciar', true);
end;

procedure TConfigRecordatorio.SetMostrarAlIniciar(const Value: boolean);
begin
  Configuracion.WriteBoolean(SECCION, 'MostrarAlIniciar', Value);
end;

end.
