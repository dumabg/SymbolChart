unit dmBroker;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery,
  IBUpdateSQL, dmCuenta, IBSQL, dmThreadDataModule, UtilDB;

type
  TTipoOrden = (toMercado, toLimitada, toStop);

  TOrden = class abstract
  private
    FOIDValor: integer;
    FLargo: boolean;
    FNumAcciones: cardinal;
    FStop: currency;
    FHasStop: boolean;
//    FFechaHoraActivacion: TDateTime;
    function GetTipoAsString: string; virtual; abstract;
    procedure SetStop(const Value: currency);
  public
    property OIDValor: integer read FOIDValor write FOIDValor;
    property Largo: boolean read FLargo write FLargo;
    property NumAcciones: cardinal read FNumAcciones write FNumAcciones;
    property Stop: currency read FStop write SetStop;
    property HasStop: boolean read FHasStop;
//    property FechaHoraActivacion: TDateTime read FFechaHoraActivacion write FFechaHoraActivacion;
  end;

  TOrdenCambio = class abstract(TOrden)
  private
    FCambio: currency;
  public
    property Cambio: currency read FCambio write FCambio;
  end;

  TOrdenMercado = class (TOrden)
  private
    function GetTipoAsString: string; override;
  end;

{  TOrdenStop = class (TOrdenCambio)
  private
    function GetTipoAsString: string; override;
  end;}

  TOrdenLimitada = class(TOrdenCambio)
  private
    function GetTipoAsString: string; override;
  end;

  EBroker = class(Exception);
  EFunctionalityNotSupported = class(EBroker);

{  TOnPosicionCerrada = procedure(const BrokerIDAbierta, BrokerIDCerrada: integer; const cambio, comision: currency) of object;
  TOnPosicionAbierta = procedure(const BrokerID: integer; const cambio, comision: currency) of object;
  TOnPosicionCancelada = procedure(const BrokerID: integer) of object;

  TOnBrokerError = procedure (const BrokerID: integer; const msg: string) of object;
  TOnBrokerMsg = procedure (const msg: string) of object;}

  TBroker = class (TThreadDataModule)
    qBrokerPosiciones: TIBQuery;
    uBrokerPosiciones: TIBUpdateSQL;
    qBrokerPosicionesOID_BROKER_POSICIONES: TIntegerField;
    qBrokerPosicionesOR_BROKER: TSmallintField;
    qBrokerPosicionesOR_CUENTA: TSmallintField;
    qBrokerPosicionesBROKER_ID: TIntegerField;
    qBrokerPosicionesESTADO: TIBStringField;
    qBrokerPosicionesFECHA_HORA: TDateTimeField;
    qBrokerPosicionesOR_VALOR: TSmallintField;
    qBrokerPosicionesTIPO_ORDEN: TIBStringField;
    qBrokerPosicionesOPERACION: TIBStringField;
    qBrokerPosicionesCAMBIO: TIBBCDField;
    qBrokerPosicionesMENSAJE: TMemoField;
    uBrokerPosicionEstado: TIBSQL;
    qBrokerPosicionesNUM_ACCIONES: TIntegerField;
    qBrokerPosicionesSIMBOLO: TIBStringField;
    qBrokerPosicionesNOMBRE: TIBStringField;
    qBrokerPosicionesMERCADO: TIBStringField;
    procedure qBrokerPosicionesFilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
    procedure qBrokerPosicionesCalcFields(DataSet: TDataSet);
  private
//    FOnPosicionCerrada: TOnPosicionCerrada;
    FOID: integer;
{    FOnPosicionCancelada: TOnPosicionCancelada;
    FOnPosicionAbierta: TOnPosicionAbierta;
    FOnError: TOnBrokerError;
    FOnMessage: TOnBrokerMsg;}
    OIDGenerator: TOIDGenerator;
    FCuenta: TCuenta;
    function GetTipoOrden: TTipoOrden;
  protected
{    function GetIDValorBroker(const OIDValor: integer): string; virtual; abstract;
    function InternalAbrirPosicionLimitada(
      const IDValorBroker: string; const NumAcciones: integer;
      const largo: boolean; const stop, limite: currency): integer; virtual; abstract;
    function InternalAbrirPosicionMercado(
      const IDValorBroker: string; const NumAcciones: integer;
      const largo: boolean; const stop: currency): integer; virtual; abstract;
 }
    procedure PosicionAbierta(const FechaHora: TDateTime;
      const BrokerID: integer; const cambio, comision: currency; const MonedaValor: currency);
    procedure PosicionCerrada(const FechaHora: TDateTime;
      const BrokerID: integer; const cambio, comision, MonedaValor: currency);
    procedure InternalAbrirPosicion(const Orden: TOrden;
      var FechaHora: TDateTime; var BrokerID: integer; var mensaje: string); virtual; abstract;
  public
    constructor Create(const AOwner: TComponent; const OID: integer; const Cuenta: TCuenta); reintroduce; virtual;
    destructor Destroy; override;
    procedure ReloadPosiciones;
    function GetCierre(const OIDValor: integer): currency; virtual; abstract;
{    function AbrirPosicionLimitada(const OIDValor, NumAcciones: integer;
      const largo: boolean; const stop, limite: currency): integer;
    function AbrirPosicionMercado(const OIDValor, NumAcciones: integer;
      const largo: boolean; const stop: currency): integer;  }

    procedure CambiarStop(const OIDValor: integer; const OrdenID: integer;
      const largo: boolean; const NumAcciones: cardinal; const stop: currency); virtual; abstract;

//    procedure CerrarPosicions(const OIDValor: integer; const

    procedure AbrirPosicion(const Orden: TOrden); virtual;
    property Cuenta: TCuenta read FCuenta;
    property TipoOrden: TTipoOrden read GetTipoOrden;

{    property OnPosicionCerrada: TOnPosicionCerrada read FOnPosicionCerrada write FOnPosicionCerrada;
    property OnPosicionCancelada: TOnPosicionCancelada read FOnPosicionCancelada write FOnPosicionCancelada;
    property OnPosicionAbierta: TOnPosicionAbierta read FOnPosicionAbierta write FOnPosicionAbierta;
    property OnError: TOnBrokerError read FOnError write FOnError;
    property OnMessage: TOnBrokerMsg read FOnMessage write FOnMessage;}
  end;


//  function BrokerFactory(const AOwner: TComponent; const BrokerOID: integer): TBroker;

{const
   EstadoOrdenCerrada: TEstadoOrdenCerrada = [eoCerrada, eoNoEntroEnMercado, eoStopRoto];}

implementation

uses dmBD, dmDataComun, IB, UtilDBSC;

{$R *.dfm}

{function BrokerFactory(const AOwner: TComponent; const BrokerOID: integer): TBroker;
var q: TIBQuery;
  className: string;
type
  TBrokerClass = class of TBroker;
begin
  q := TIBQuery.Create(nil);
  try
    q.Database := BD.IBDatabase;
    q.Transaction := BD.IBTransaction;
    q.SQL.Text := 'select CLASSNAME from BROKER where OID_BROKER=:OID_BROKER';
    q.Params[0].AsInteger := BrokerOID;
    q.Open;
    if q.IsEmpty then
      raise Exception.Create('No se ha encontrado el broker ' + IntToStr(BrokerOID));
    className := q.Fields[0].AsString;
  finally
    q.Free;
  end;
  result := TBrokerClass(FindClass(className)).Create(AOwner);
  result.FOID := BrokerOID;
end;}

{ TBroker }

procedure TBroker.AbrirPosicion(const Orden: TOrden);
var FechaHora: TDateTime;
  BrokerID: integer;
  mensaje: string;
begin
  InternalAbrirPosicion(Orden, FechaHora, BrokerID, mensaje);
  qBrokerPosiciones.Append;
  qBrokerPosicionesOID_BROKER_POSICIONES.Value := OIDGenerator.NextOID;
  qBrokerPosicionesOR_BROKER.Value := FOID;
  qBrokerPosicionesOR_CUENTA.Value := FCuenta.OIDCuenta;
  qBrokerPosicionesNUM_ACCIONES.Value := Orden.NumAcciones;
  qBrokerPosicionesFECHA_HORA.Value := FechaHora;
  qBrokerPosicionesTIPO_ORDEN.Value := Orden.GetTipoAsString;
  qBrokerPosicionesBROKER_ID.Value := BrokerID;
  qBrokerPosicionesESTADO.Value := 'B';
  if Orden is TOrdenCambio then
    qBrokerPosicionesCAMBIO.Value := TOrdenCambio(Orden).Cambio;
  if Orden.Largo then
    qBrokerPosicionesOPERACION.Value := 'C'
  else
    qBrokerPosicionesOPERACION.Value := 'V';
  if mensaje <> '' then
    qBrokerPosicionesMENSAJE.Value := mensaje;
  DataComun.AssignDataSet(Orden.OIDValor, qBrokerPosicionesOR_VALOR,
    qBrokerPosicionesNOMBRE, qBrokerPosicionesSIMBOLO, nil, qBrokerPosicionesMERCADO);
  qBrokerPosiciones.Post;
  qBrokerPosiciones.Transaction.CommitRetaining;
end;

{function TBroker.AbrirPosicionLimitada(const OIDValor, NumAcciones: integer;
  const largo: boolean; const stop, limite: currency): integer;
begin
  result := InternalAbrirPosicionLimitada(GetIDValorBroker(OIDValor),
    NumAcciones, largo, stop, limite);
end;

function TBroker.AbrirPosicionMercado(const OIDValor, NumAcciones: integer;
  const largo: boolean; const stop: currency): integer;
begin
  result := InternalAbrirPosicionMercado(GetIDValorBroker(OIDValor),
          NumAcciones, largo, stop);
end;
}

constructor TBroker.Create(const AOwner: TComponent; const OID: integer; const Cuenta: TCuenta);
begin
  inherited Create(AOwner);
  OIDGenerator := TOIDGenerator.Create(scdUsuario, 'BROKER_POSICIONES');
  FOID := OID;
  FCuenta := Cuenta;
  ReloadPosiciones;
end;

destructor TBroker.Destroy;
begin
  OIDGenerator.Free;
  inherited;
end;

function TBroker.GetTipoOrden: TTipoOrden;
var tipo: string;
begin
  tipo := qBrokerPosicionesTIPO_ORDEN.Value;
  if tipo = 'MKT' then
    result := toMercado
  else
    if tipo = 'LMT' then
      result := toLimitada
    else
      if tipo = 'STP' then
        result := toStop
      else
        raise Exception.Create('Tipo de orden desconocida: ' + tipo);
end;

{function TBroker.GetCambio(const OIDValor: integer): currency;
begin
  raise EFunctionalityNotSupported.Create('');
end;
}
procedure TBroker.PosicionAbierta(const FechaHora: TDateTime;
  const BrokerID: integer; const cambio, comision: currency; const MonedaValor: currency);
begin
  if qBrokerPosiciones.Locate('BROKER_ID', BrokerID, []) then begin
    FCuenta.CompraAcciones(BrokerID, FechaHora, qBrokerPosicionesOR_VALOR.Value,
      qBrokerPosicionesNUM_ACCIONES.Value, cambio, comision,
      qBrokerPosicionesOPERACION.Value = 'C', MonedaValor);
    qBrokerPosiciones.Edit;
    qBrokerPosicionesESTADO.Value := 'M';
    qBrokerPosiciones.Post;
  end;
end;

procedure TBroker.PosicionCerrada(const FechaHora: TDateTime;
  const BrokerID: integer; const cambio, comision, MonedaValor: currency);
begin
  if qBrokerPosiciones.Locate('BROKER_ID', BrokerID, []) then begin
    qBrokerPosiciones.Edit;
    qBrokerPosicionesESTADO.Value := 'C';
    qBrokerPosiciones.Post;
  end
  else begin
    uBrokerPosicionEstado.ParamByName('ESTADO').AsString := 'C';
    uBrokerPosicionEstado.ParamByName('BROKER_ID').AsInteger := BrokerID;
    uBrokerPosicionEstado.ParamByName('OID_CUENTA').AsInteger := Cuenta.OIDCuenta;
    uBrokerPosicionEstado.ParamByName('OID_BROKER').AsInteger := FOID;
    ExecQuery(uBrokerPosicionEstado, false);
  end;
  FCuenta.VentaAcciones(BrokerID, FechaHora, cambio, comision, MonedaValor);
end;

procedure TBroker.qBrokerPosicionesCalcFields(DataSet: TDataSet);
var data: PDataComunValor;
begin
  if (not qBrokerPosicionesOR_VALOR.IsNull) and (qBrokerPosicionesSIMBOLO.IsNull) then begin
    data := DataComun.FindValor(qBrokerPosicionesOR_VALOR.Value);
    qBrokerPosicionesSIMBOLO.Value := data^.Simbolo;
    qBrokerPosicionesNOMBRE.Value := data^.Nombre;
    qBrokerPosicionesMERCADO.Value := data^.Mercado^.Pais;
  end;
end;

procedure TBroker.qBrokerPosicionesFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := qBrokerPosicionesESTADO.Value = 'B';
end;

procedure TBroker.ReloadPosiciones;
var OIDCuenta: integer;
begin
  OIDCuenta := FCuenta.OIDCuenta;
  if OIDCuenta <> SIN_CUENTA then begin
    qBrokerPosiciones.Close;
    qBrokerPosiciones.ParamByName('OID_BROKER').AsInteger := FOID;
    qBrokerPosiciones.ParamByName('OID_CUENTA').AsInteger := OIDCuenta;
    qBrokerPosiciones.Open;
  end;
end;

{ TOrdenMercado }

function TOrdenMercado.GetTipoAsString: string;
begin
  result := 'MKT';
end;

{ TOrdenStop }

{function TOrdenStop.GetTipoAsString: string;
begin
  result := 'STP';
end;}

{ TOrdenLimitada }

function TOrdenLimitada.GetTipoAsString: string;
begin
  result := 'LMT';
end;

{ TOrden }

{ TOrden }

procedure TOrden.SetStop(const Value: currency);
begin
  FStop := Value;
  FHasStop := true;
end;

end.
