unit dmEstrategiaEstudio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmEstrategiaInterpreterBD, DB, IBCustomDataSet, IBQuery, 
  dmData, dmCuentaEstudio, dmBrokerEstudio, kbmMemTable;

type
  TEstrategiaEstudio = class(TEstrategiaInterpreterBD)
    qCotizaciones: TIBQuery;
    qCotizacionesOR_VALOR: TSmallintField;
  private
    Cuenta: TCuentaEstudio;
    Broker: TBrokerEstudio;
    FFecha: TDate;
    OIDSesion: integer;
    procedure SetFecha(const Value: TDate);
  protected
    function CambioEntrada: currency; override;
    procedure CerrarPosicion; override;
    procedure AntesAbrirSesionValor(const OIDValor: integer); override;
    procedure AntesCerrarSesionValor(const OIDValor: integer); override;
    procedure AntesAbrirSesionPosicionadoValor(const OIDValor: integer); override;
    procedure AntesCerrarSesionPosicionadoValor(const OIDValor: integer); override;
  public
    constructor Create(const AOwner: TComponent; const Valores: TDataSet;
      const OIDEstrategia: integer;  const Cuenta: TCuentaEstudio;
      const Broker: TBrokerEstudio); reintroduce;
    property Fecha: TDate read FFecha write SetFecha;
  end;

implementation

uses dmBD, dmDataComun;

{$R *.dfm}

{ TEstrategiaEstudio }

procedure TEstrategiaEstudio.AntesAbrirSesionPosicionadoValor(
  const OIDValor: integer);
begin
  if qCotizaciones.Locate('OR_VALOR', OIDValor, []) then
    ExecEstrategiaAperturaPosicionado(OIDValor, OIDSesion);
end;

procedure TEstrategiaEstudio.AntesAbrirSesionValor(const OIDValor: integer);
begin
  if qCotizaciones.Locate('OR_VALOR', OIDValor, []) then
    ExecEstrategiaApertura(OIDValor, OIDSesion);
end;

procedure TEstrategiaEstudio.AntesCerrarSesionPosicionadoValor(
  const OIDValor: integer);
begin
  if qCotizaciones.Locate('OR_VALOR', OIDValor, []) then
    ExecEstrategiaCierrePosicionado(OIDValor, OIDSesion);
end;

procedure TEstrategiaEstudio.AntesCerrarSesionValor(const OIDValor: integer);
begin
  if qCotizaciones.Locate('OR_VALOR', OIDValor, []) then
    ExecEstrategiaCierre(OIDValor, OIDSesion);
end;

function TEstrategiaEstudio.CambioEntrada: currency;
begin
  if Broker.PosicionesAbiertas.Locate('OID_VALOR', OIDValorExecuting, []) then
    result := Broker.PosicionesAbiertasCAMBIO.Value
  else
    result := 0;
end;

procedure TEstrategiaEstudio.CerrarPosicion;
begin
  if Broker.PosicionesAbiertas.Locate('OID_VALOR', OIDValorExecuting, []) then begin
    if Broker.PosicionesAbiertasES_LARGO.Value then
      ModificarStop(100000)
    else
      ModificarStop(0.00001);
  end;
end;

constructor TEstrategiaEstudio.Create(const AOwner: TComponent;
  const Valores: TDataSet; const OIDEstrategia: integer;
  const Cuenta: TCuentaEstudio;
  const Broker: TBrokerEstudio);
begin
  inherited Create(AOwner, Valores, OIDEstrategia);
  Self.Broker := Broker;
  Self.Cuenta := Cuenta;
end;

procedure TEstrategiaEstudio.SetFecha(const Value: TDate);
begin
  FFecha := Value;
  OIDSesion := DataComun.FindOIDSesion(FFecha);
  qCotizaciones.Close;
  qCotizaciones.Params[0].AsInteger := OIDSesion;
  qCotizaciones.Open;
end;

end.
