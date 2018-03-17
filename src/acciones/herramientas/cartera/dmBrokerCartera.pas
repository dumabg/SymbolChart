unit dmBrokerCartera;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmBroker, DB, IBCustomDataSet, IBQuery, IBUpdateSQL, dmCuenta,
  IBSQL, ScriptComision;

type
  TBrokerCartera = class(TBroker)
    qMaxBrokerID: TIBQuery;
    qMaxBrokerIDMAX: TIntegerField;
    qCotizacion: TIBQuery;
    qBrokerComision: TIBQuery;
    qBrokerComisionOR_BROKER: TSmallintField;
    qBrokerComisionOR_MERCADO: TSmallintField;
    qBrokerComisionENTRADA: TMemoField;
    qBrokerComisionENTRADA_MAXIMO: TMemoField;
    qBrokerComisionENTRADA_MINIMO: TMemoField;
    qBrokerComisionSALIDA: TMemoField;
    qBrokerComisionSALIDA_MAXIMO: TMemoField;
    qBrokerComisionSALIDA_MINIMO: TMemoField;
    qCotizacionCIERRE: TIBBCDField;
  private
    id: integer;
    ScriptComision: TScriptComision;
  protected
    procedure InternalAbrirPosicion(const Orden: TOrden;
      var FechaHora: TDateTime; var BrokerID: integer; var mensaje: string); override;
  public
    constructor Create(const AOwner: TComponent; const OID: integer;
      const Cuenta: TCuenta); override;
    destructor Destroy; override;
    function GetCierre(const OIDValor: integer): currency; override;
    procedure CambiarStop(const OIDValor: integer; const OrdenID: integer;
      const largo: boolean; const NumAcciones: cardinal; const stop: currency); override;
    procedure Confirmar(const cambio, comision: currency; const MonedaValor: currency);
    function GetComision(const OIDValor: integer; const NumAcciones: cardinal;
      const efectivo: currency; const largo, entrada: boolean): currency;
    procedure Descartar;
    procedure DescartarTodos;
    procedure CerrarPosicion(const OIDMovimiento: integer; const fecha: TDateTime;
      const cambio, comision, MonedaValor: currency);
  end;


implementation

uses dmDataComun, dmBD;

{$R *.dfm}

{ TBrokerCartera }

procedure TBrokerCartera.CambiarStop(const OIDValor, OrdenID: integer;
  const largo: boolean; const NumAcciones: cardinal; const stop: currency);
begin
end;

procedure TBrokerCartera.CerrarPosicion(const OIDMovimiento: integer;
  const fecha: TDateTime; const cambio,
  comision, MonedaValor: currency);
begin
  Cuenta.VentaAcciones(fecha, OIDMovimiento, cambio, comision, MonedaValor);
end;

procedure TBrokerCartera.Confirmar(const cambio, comision: currency; const MonedaValor: currency);
begin
  PosicionAbierta(now, qBrokerPosicionesBROKER_ID.Value, cambio, comision, MonedaValor);
end;

constructor TBrokerCartera.Create(const AOwner: TComponent; const OID: integer;
  const Cuenta: TCuenta);
var OIDCuenta: integer;
begin
  inherited Create(AOwner, OID, Cuenta);

  OIDCuenta := Cuenta.OIDCuenta;
  if OIDCuenta <> SIN_CUENTA then begin
    qMaxBrokerID.ParamByName('OID_BROKER').AsInteger := OID;
    qMaxBrokerID.ParamByName('OID_CUENTA').AsInteger := OIDCuenta;
    qMaxBrokerID.Open;
    id := qMaxBrokerIDMAX.Value + 1;
    qMaxBrokerID.Close;

    ScriptComision := TScriptComision.Create;
    qBrokerComision.Params[0].AsInteger := OID;
    qBrokerComision.Open;
  end;
end;

procedure TBrokerCartera.Descartar;
begin
  qBrokerPosiciones.Delete;
end;

procedure TBrokerCartera.DescartarTodos;
begin
  while not qBrokerPosiciones.IsEmpty do
    Descartar;
end;

destructor TBrokerCartera.Destroy;
begin
  if ScriptComision <> nil then
    ScriptComision.Free;
  inherited;
end;

function TBrokerCartera.GetCierre(const OIDValor: integer): currency;
begin
  qCotizacion.Close;
  qCotizacion.ParamByName('OID_VALOR').AsInteger := OIDValor;
  qCotizacion.Open;
  result := qCotizacionCIERRE.Value;
  qCotizacion.Close;
end;

function TBrokerCartera.GetComision(const OIDValor: integer; const NumAcciones: cardinal;
  const efectivo: currency; const largo, entrada: boolean): currency;
var comision, maximo, minimo: currency;
  valor: PDataComunValor;

  function Evaluar(const Field: TMemoField): currency;
  begin
    if (Field.IsNull) or (Field.Value = '') then
      result := 0
    else begin
      ScriptComision.Expression := Field.Value;
      result := ScriptComision.Evaluate;
    end;
  end;
begin
  valor := DataComun.FindValor(OIDValor);
  if qBrokerComision.Locate('OR_MERCADO', valor^.Mercado^.OIDMercado, []) then begin
    if entrada then begin
      comision := Evaluar(qBrokerComisionENTRADA);
      maximo := Evaluar(qBrokerComisionENTRADA_MAXIMO);
      minimo := Evaluar(qBrokerComisionENTRADA_MINIMO);
    end
    else begin
      comision := Evaluar(qBrokerComisionSALIDA);
      maximo := Evaluar(qBrokerComisionSALIDA_MAXIMO);
      minimo := Evaluar(qBrokerComisionSALIDA_MINIMO);
    end;
    result := comision;
    if (maximo > 0) and (result > maximo) then
      result := maximo;
    if (minimo > 0) and (result < minimo) then
      result := minimo;
  end
  else
    result := 0;
end;

procedure TBrokerCartera.InternalAbrirPosicion(const Orden: TOrden;
  var FechaHora: TDateTime; var BrokerID: integer; var mensaje: string);
begin
  FechaHora := now;
  BrokerID := id;
  inc(id);
end;

end.
