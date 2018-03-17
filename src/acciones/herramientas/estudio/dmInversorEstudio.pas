unit dmInversorEstudio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmInversor, DB, IBCustomDataSet, IBQuery, dmCuentaEstudio,
  dmEstrategiaInterpreter;

type
  TInversorEstudio = class(TInversor)
  private
    FFechaActual: TDateTime;
    FCuentaEstudio: TCuentaEstudio;
    FPaquetes: integer;
    procedure SetFechaActual(const Value: TDateTime);
    procedure SetFechaFinal(const Value: TDateTime);
  protected
    function GetPaquetes: integer; override;
    function GetEstrategia(const OIDEstrategia: integer): TEstrategiaInterpreter; override;
  public
    constructor Create(AOwner: TComponent; const paquetes: integer); reintroduce;
    procedure CrearEstudio(const nombreCuenta: string; const OIDMoneda: integer);
    property FechaActual: TDateTime read FFechaActual write SetFechaActual;
    property FechaFinal: TDateTime write SetFechaFinal;
    property CuentaEstudio: TCuentaEstudio read FCuentaEstudio;
  end;

implementation

uses dmBrokerEstudio, dmEstrategiaEstudio;

{$R *.dfm}

procedure TInversorEstudio.CrearEstudio(const nombreCuenta: string; const OIDMoneda: integer);
begin
  // NO se pasa Self porque el estudio una vez creado se cachea la cuenta
  // Se pasa Owner porque pasa a ser owner de dmEstudios
  FCuentaEstudio := TCuentaEstudio.Create(Owner as TComponent, nombreCuenta, OIDMoneda);
  FCuentaEstudio.FechaActual := now;
  Broker := TBrokerEstudio.Create(Self, -1, FCuentaEstudio);
  dsPosicionesMercado.DataSet := Broker.qBrokerPosiciones;
end;

constructor TInversorEstudio.Create(AOwner: TComponent;
  const paquetes: integer);
begin
  inherited Create(AOwner);
  FPaquetes := paquetes;
end;

function TInversorEstudio.GetEstrategia(
  const OIDEstrategia: integer): TEstrategiaInterpreter;
begin
  result := TEstrategiaEstudio.Create(Self, Valores, OIDEstrategia,
    FCuentaEstudio, TBrokerEstudio(Broker));
end;

function TInversorEstudio.GetPaquetes: integer;
begin
  result := FPaquetes;
end;

procedure TInversorEstudio.SetFechaActual(const Value: TDateTime);
begin
  FFechaActual := Value;
  TBrokerEstudio(Broker).Fecha := Value;
  TEstrategiaEstudio(Estrategia).Fecha := Value;
end;

procedure TInversorEstudio.SetFechaFinal(const Value: TDateTime);
begin
  // En la cuenta estudio se establece la FechaActual para saber en que dia se
  // está y por lo tanto calcular los stops de los movimientos abiertos 
  FCuentaEstudio.FechaActual := Value;
end;

end.
