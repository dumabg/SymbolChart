unit dmInversorCartera;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmInversor, DB, IBCustomDataSet, IBQuery, dmCartera,
  dmEstrategiaInterpreter;

type
  TInversorCartera = class(TInversor)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure OnCarteraChange;
  protected
    FCartera: TCartera;
    function GetPaquetes: integer; override;
    function GetEstrategia(const OIDEstrategia: integer): TEstrategiaInterpreter; override;
  public
    procedure BorrarCuenta;
    function HayCuentas: boolean;
    procedure CrearCartera(const nombre: string; const CapitalInicial, Paquetes: integer;
      USA100: boolean; const OIDMoneda, OIDBroker: integer; const broker: string);
    procedure Confirmar(const cambio, comision: currency; const MonedaValor: currency);
    procedure Descartar;
    procedure DescartarTodos;
    procedure CerrarPosicion(const OIDMovimiento: integer; const fecha: TDateTime;
      const cambio, comision, MonedaValor: currency);
    property Cartera: TCartera read FCartera;
  end;

implementation

{$R *.dfm}

uses dmBrokerCartera, dmBD, dmEstrategiaCartera, dmConfiguracion;

const
  CONFIG_SECCION = 'InversorCartera';
  CONFIG_CLAVE_OID_ESTRATEGIA = 'OIDEstrategia';

procedure TInversorCartera.BorrarCuenta;
begin
  try
    FCartera.BorrarCartera;
    BD.IBTransactionUsuario.CommitRetaining;
  except
    BD.IBTransactionUsuario.RollbackRetaining;
    raise;
  end;
end;

procedure TInversorCartera.CerrarPosicion(const OIDMovimiento: integer;
  const fecha: TDateTime; const cambio, comision, MonedaValor: currency);
begin
  try
    TBrokerCartera(Broker).CerrarPosicion(OIDMovimiento, fecha, cambio, comision, MonedaValor);
    BD.IBTransactionUsuario.CommitRetaining;
  except
    BD.IBTransactionUsuario.RollbackRetaining;
    raise;
  end;
end;

procedure TInversorCartera.Confirmar(const cambio, comision: currency; const MonedaValor: currency);
begin
  try
    TBrokerCartera(Broker).Confirmar(cambio, comision, MonedaValor);
    BD.IBTransactionUsuario.CommitRetaining;
  except
    BD.IBTransactionUsuario.RollbackRetaining;
    raise;
  end;
end;

procedure TInversorCartera.CrearCartera(const nombre: string;
  const CapitalInicial, Paquetes: integer; USA100: boolean;
  const OIDMoneda, OIDBroker: integer; const broker: string);
begin
  try
    FCartera.CrearCartera(nombre, CapitalInicial, Paquetes, USA100, OIDMoneda, OIDBroker, broker);
    AnadirCapital(CapitalInicial);
    BD.IBTransactionUsuario.CommitRetaining;
  except
    BD.IBTransactionUsuario.RollbackRetaining;
    raise;
  end;
end;

procedure TInversorCartera.DataModuleCreate(Sender: TObject);
var OIDEstrategia: integer;
begin
  inherited;
  FCartera := TCartera.Create(Self);
  FCartera.OnCarteraChange := OnCarteraChange;
  OnCarteraChange;
  OIDEstrategia := Configuracion.ReadInteger(CONFIG_SECCION, CONFIG_CLAVE_OID_ESTRATEGIA, -1);
  qEstrategias.Locate('OID_ESTRATEGIA', OIDEstrategia, []);
end;

procedure TInversorCartera.DataModuleDestroy(Sender: TObject);
var OIDEstrategia: integer;
begin
  inherited;
  OIDEstrategia := qEstrategiasOID_ESTRATEGIA.Value;
  Configuracion.WriteInteger(CONFIG_SECCION, CONFIG_CLAVE_OID_ESTRATEGIA, OIDEstrategia);
end;

procedure TInversorCartera.Descartar;
begin
  try
    TBrokerCartera(Broker).Descartar;
    BD.IBTransactionUsuario.CommitRetaining;
  except
    BD.IBTransactionUsuario.RollbackRetaining;
    raise;
  end;
end;

procedure TInversorCartera.DescartarTodos;
begin
  try
    TBrokerCartera(Broker).DescartarTodos;
    BD.IBTransactionUsuario.CommitRetaining;
  except
    BD.IBTransactionUsuario.RollbackRetaining;
    raise;
  end;
end;

function TInversorCartera.GetEstrategia(
  const OIDEstrategia: integer): TEstrategiaInterpreter;
begin
  result := TEstrategiaCartera.Create(Self, Valores, OIDEstrategia);
end;

function TInversorCartera.GetPaquetes: integer;
begin
  result := FCartera.Paquetes;
end;

function TInversorCartera.HayCuentas: boolean;
begin
  result := FCartera.HayCarteras;
end;

procedure TInversorCartera.OnCarteraChange;
begin
  if Broker <> nil then
    Broker.Free;
  Broker := TBrokerCartera.Create(Self, FCartera.OIDBroker, FCartera);
  dsPosicionesMercado.DataSet := Broker.qBrokerPosiciones;
end;

end.
