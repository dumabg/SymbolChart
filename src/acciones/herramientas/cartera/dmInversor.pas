unit dmInversor;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, dmEstrategiaInterpreter,
  dmBroker, dmCuentaBase, Script_Log, dmData;

type
  TInversor = class(TDataModule)
    dsPosiciones: TDataSource;
    dsPosicionesMercado: TDataSource;
    qEstrategias: TIBQuery;
    qEstrategiasOID_ESTRATEGIA: TSmallintField;
    qEstrategiasNOMBRE: TIBStringField;
    qEstrategiasDESCRIPCION: TMemoField;
    qEstrategiasESTRATEGIA_APERTURA: TMemoField;
    qEstrategiasTIPO: TIBStringField;
    qEstrategiasESTRATEGIA_CIERRE: TMemoField;
    procedure DataModuleCreate(Sender: TObject);
  private
    FValores: TDataSet;
    FBroker: TBroker;
    FOnLog: TOnLogEvent;
    function GetHayPosicionesMercado: boolean;
    function GetCuenta: TCuentaBase;
    function GetCapital: currency;
    function GetHayPosicionesAbiertas: boolean;
    procedure SetOIDEstrategia(const Value: integer);
  protected
    Estrategia: TEstrategiaInterpreter;
    function GetPaquetes: integer; virtual; abstract;
    property Cuenta: TCuentaBase read GetCuenta;
    function GetEstrategia(const OIDEstrategia: integer): TEstrategiaInterpreter; virtual; abstract;
  public
    function GetNumAcciones(const OIDValor: integer; const limitada: boolean; const limite: currency): integer; virtual;
    procedure AnadirCapital(const capital: currency);
    procedure RetirarCapital(const capital: currency);
    function Posicionar: boolean; virtual;
    function PosicionarTodos: boolean;
    procedure BuscarPosiciones(const antesAbrir, posicionados: boolean);
    procedure RefrescarEstrategias;
{    procedure CambiarStop(const tipo: TTipoCotizacion);
    procedure CambiarStops(const tipo: TTipoCotizacion);}
    procedure CancelarBusquedaPosiciones;
    property Broker: TBroker read FBroker write FBroker;
    property Valores: TDataSet read FValores write FValores;
    property HayPosicionesMercado: boolean read GetHayPosicionesMercado;
    property HayPosicionesAbiertas: boolean read GetHayPosicionesAbiertas;
    property Capital: currency read GetCapital;
    property Paquetes: integer read GetPaquetes;
    property OIDEstrategia: integer write SetOIDEstrategia;
    property OnLog: TOnLogEvent read FOnLog write FOnLog;
  end;


implementation

uses UtilDB, Forms, dmBD;

{$R *.dfm}

procedure TInversor.AnadirCapital(const capital: currency);
begin
  Cuenta.AnadirCapital(capital);
end;

procedure TInversor.BuscarPosiciones(const antesAbrir, posicionados: boolean);
var inspect: TInspectDataSet;
  posiciones: TDataSet;
  posicionesOID_VALOR: TIntegerField;
  OIDValor: integer;
  stop: currency;
begin
  Estrategia.InicializarPosicionado;
  posiciones := Cuenta.PosicionesAbiertas;
  posicionesOID_VALOR := Cuenta.PosicionesAbiertasOR_VALOR;
  inspect := StartInspectDataSet(posiciones);
  try
    posiciones.First;
    while not posiciones.Eof do begin
      Estrategia.AnadirPosicionado(posicionesOID_VALOR.Value);
      posiciones.Next;
    end;
  finally
    EndInspectDataSet(inspect);
  end;

  try
    Estrategia.OnLog := FOnLog;
    if antesAbrir then begin
      if posicionados then
        Estrategia.AntesAbrirSesionPosicionados;
      Estrategia.AntesAbrirSesion;
    end
    else begin
      if posicionados then
        Estrategia.AntesCerrarSesionPosicionados;
      Estrategia.AntesCerrarSesion;
    end;
  finally
    dsPosiciones.DataSet := Estrategia.Posiciones;
  end;

  //Actualizar stops
  Estrategia.Posicionados.First;
  while not Estrategia.Posicionados.Eof do begin
    OIDValor := Estrategia.PosicionadosOID_VALOR.Value;
    if posiciones.Locate('OR_VALOR', OIDValor, []) then begin
      posiciones.Edit;
      stop := Estrategia.PosicionadosSTOP.Value;
      Cuenta.PosicionesAbiertasSTOP_DIARIO.Value := stop;
      posiciones.Post;
      Broker.CambiarStop(OIDValor,
        Cuenta.PosicionesAbiertasBROKER_ID.Value,
        Cuenta.PosicionesAbiertasPOSICION.Value = 'L',
        Cuenta.PosicionesAbiertasNUM_ACCIONES.Value,
        stop);
    end;
    Estrategia.Posicionados.Next;
  end;
end;

{procedure TInversor.CambiarStop(const tipo: TTipoCotizacion);
var stop: currency;
begin
  with Cuenta do begin
    if tipo = tcDiaria then
      stop := PosicionesAbiertasSTOP_DIARIO.Value
    else
      stop := PosicionesAbiertasSTOP_SEMANAL.Value;
    Broker.CambiarStop(PosicionesAbiertasOR_VALOR.Value,
      PosicionesAbiertasBROKER_ID.Value,
      PosicionesAbiertasPOSICION.Value = 'L',
      PosicionesAbiertasNUM_ACCIONES.Value,
      stop);
  end;
end;

procedure TInversor.CambiarStops(const tipo: TTipoCotizacion);
begin
  with Cuenta.PosicionesAbiertas do begin
    First;
    while not Eof do begin
      CambiarStop(tipo);
      Next;
    end;
  end;
end;
 }
procedure TInversor.CancelarBusquedaPosiciones;
begin
  if Estrategia <> nil then
    Estrategia.Cancel;
end;

procedure TInversor.DataModuleCreate(Sender: TObject);
begin
  OpenDataSet(qEstrategias);
  Estrategia := nil;
end;

function TInversor.GetCapital: currency;
begin
  result := Cuenta.Capital;
end;

function TInversor.GetCuenta: TCuentaBase;
begin
  result := Broker.Cuenta;
end;

function TInversor.GetHayPosicionesAbiertas: boolean;
begin
  result := not Cuenta.PosicionesAbiertas.IsEmpty;
end;

function TInversor.GetHayPosicionesMercado: boolean;
begin
  result := (Broker <> nil) and (not Broker.qBrokerPosiciones.IsEmpty);
end;


function TInversor.GetNumAcciones(const OIDValor: integer; const limitada: boolean;
  const limite: currency): integer;
var cierre: currency;
begin
  if limitada then begin
    if limite = 0 then
      result := 0
    else
      result := Round(GetPaquetes / limite);
  end
  else begin
    cierre := Broker.GetCierre(OIDValor);
    if cierre = 0 then
      result := 0
    else
      result := Round(GetPaquetes / cierre);
  end;
end;

function TInversor.Posicionar: boolean;
var OIDValor: integer;
  numAcciones: cardinal;
  limite: currency;
  Orden: TOrden;

    procedure AbrirPosicion(const Orden: TOrden);
    begin
      Orden.Stop := Estrategia.PosicionesSTOP.Value;
      Orden.OIDValor := OIDValor;
      Orden.NumAcciones := numAcciones;
      Orden.Largo := Estrategia.PosicionesPOSICION.Value = 'L';
      try
        Broker.AbrirPosicion(Orden);
      finally
        Orden.Free;
      end;
    end;
begin
  OIDValor := Estrategia.PosicionesOID_VALOR.Value;
  if Estrategia.PosicionesLIMITE.IsNull then begin
    numAcciones := GetNumAcciones(OIDValor, false, 0);
    if numAcciones <> 0 then begin
      Orden := TOrdenMercado.Create;
      AbrirPosicion(Orden);
    end;
  end
  else begin
    limite := Estrategia.PosicionesLIMITE.Value;
    numAcciones := GetNumAcciones(OIDValor, true, limite);
    if numAcciones <> 0 then begin
      Orden := TOrdenLimitada.Create;
      TOrdenLimitada(Orden).Cambio := limite;
      AbrirPosicion(Orden);
    end;
  end;
  result := numAcciones <> 0;
  if result then
    Estrategia.Posiciones.Delete
end;

function TInversor.PosicionarTodos: boolean;
var inspect: TInspectDataSet;
begin
  inspect := StartInspectDataSet(Estrategia.Posiciones);
  try
    Estrategia.Posiciones.First;
    result := true;
    while not Estrategia.Posiciones.Eof do begin
      if not Posicionar then begin
        result := false;
        Estrategia.Posiciones.Next;
      end;
      Application.ProcessMessages;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;

procedure TInversor.RefrescarEstrategias;
begin
  OpenDataSet(qEstrategias);
end;

procedure TInversor.RetirarCapital(const capital: currency);
begin
  Cuenta.RetirarCaptial(capital);
end;


procedure TInversor.SetOIDEstrategia(const Value: integer);
begin
  FreeAndNil(Estrategia);
  Estrategia := GetEstrategia(Value);
end;

end.

