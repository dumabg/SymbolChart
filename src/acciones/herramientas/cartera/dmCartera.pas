unit dmCartera;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, IBUpdateSQL,
  IBSQL, dmCuenta, tipos, kbmMemTable, UtilDB;

type
  TCarteraChange = TNotificacion;

  TCartera = class(TCuenta)
    qCartera: TIBQuery;
    uCartera: TIBUpdateSQL;
    qCarteraOID_CARTERA: TSmallintField;
    qCarteraCAPITAL: TIntegerField;
    qCarteraPAQUETES: TIntegerField;
    qCarteraUSA100: TIBStringField;
    qCarteraNOMBRE: TIBStringField;
    qCarteraOR_CUENTA: TSmallintField;
    qCarteraOR_BROKER: TSmallintField;
    qCarteraBROKER: TIBStringField;
    qCarteraOR_MONEDA: TSmallintField;
    qCarteraMONEDA: TStringField;
    dCuenta: TIBSQL;
    procedure qCarteraAfterScroll(DataSet: TDataSet);
    procedure DataModuleDestroy(Sender: TObject);
    procedure qCarteraCalcFields(DataSet: TDataSet);
  private
    FOnCarteraChange: TNotificacion;
    OIDGenerator: TOIDGenerator;
    function GetPaquetes: integer;
    function GetOIDBroker: integer;
  protected
  public
    constructor Create(const AOwner: TComponent); override;
    destructor Destroy; override;
    function CrearCartera(const descripcion: string; const CapitalInicial, Paquetes: integer;
      USA100: boolean; const OIDMoneda, OIDBroker: integer; const broker: string): integer;
    function HayCarteras: boolean;
    procedure BorrarCartera;
    property Paquetes: integer read GetPaquetes;
    property OIDBroker: integer read GetOIDBroker;
    property OnCarteraChange: TNotificacion read FOnCarteraChange write FOnCarteraChange;
  end;

implementation

uses dmBD, dmCuentaMovimientosBase, dmDataComun, dmConfiguracion, UtilDBSC;

{$R *.dfm}

procedure TCartera.BorrarCartera;
begin
  dCuenta.Params[0].AsInteger := OIDCuenta;
  //IMPORTANTE! Primero borrar la cartera, ya que tiene un foreign key con la
  //cuenta y si borramos primero la cuenta, se borra automáticamente la cartera,
  //con lo que el qCartera.Delete da error.
  qCartera.Delete;
  ExecQuery(dCuenta, true);
end;

function TCartera.CrearCartera(const descripcion: string;
  const CapitalInicial, Paquetes: integer; USA100: boolean;
  const OIDMoneda, OIDBroker: integer; const broker: string): integer;
var inspect: TInspectDataSet;
begin
  inspect := StartInspectDataSet(qCartera);
  try
    qCartera.Append;
    result := OIDGenerator.NextOID;
    qCarteraOID_CARTERA.Value := result;
    qCarteraNOMBRE.Value := descripcion;
    qCarteraCAPITAL.Value := CapitalInicial;
    qCarteraPAQUETES.Value := Paquetes;
    if USA100 then
      qCarteraUSA100.Value := 'S'
    else
      qCarteraUSA100.Value := 'N';
    Crear(OIDMoneda);
    qCarteraOR_CUENTA.Value := OIDCuenta;
    qCarteraOR_MONEDA.Value := OIDMoneda;
    qCarteraOR_BROKER.Value := OIDBroker;
    qCarteraBROKER.Value := broker;
    qCartera.Post;
  finally
    EndInspectDataSet(inspect);
  end;
end;

constructor TCartera.Create(const AOwner: TComponent);
var ultima: integer;
begin
  inherited Create(AOwner);
  OIDGenerator := TOIDGenerator.Create(scdUsuario, 'CARTERA');
  qCartera.Open;
  qCartera.AfterScroll := qCarteraAfterScroll;
  if qCartera.IsEmpty then
    Inicializar
  else begin
    ultima := Configuracion.ReadInteger('cartera', 'ultima', -1);
    if ultima <> -1 then
      qCartera.Locate('OID_CARTERA', ultima, []);
    qCarteraAfterScroll(nil);
  end;
end;

procedure TCartera.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  Configuracion.WriteInteger('cartera', 'ultima', qCarteraOID_CARTERA.Value);
end;

destructor TCartera.Destroy;
begin
  OIDGenerator.Free;
  inherited;
end;

function TCartera.GetOIDBroker: integer;
begin
  result := qCarteraOR_BROKER.Value;
end;

function TCartera.GetPaquetes: integer;
begin
  result := qCarteraPAQUETES.Value;
end;

function TCartera.HayCarteras: boolean;
begin
  result := not qCartera.IsEmpty;
end;


procedure TCartera.qCarteraAfterScroll(DataSet: TDataSet);
begin
  inherited;
  if not qCartera.IsEmpty then
    Cargar(qCarteraOR_CUENTA.Value);
  if Assigned(FOnCarteraChange) then
    FOnCarteraChange;
end;

procedure TCartera.qCarteraCalcFields(DataSet: TDataSet);
var OIDMoneda: integer;
begin
  inherited;
  if not qCarteraOR_MONEDA.IsNull then begin
    OIDMoneda := qCarteraOR_MONEDA.Value;
    qCarteraMONEDA.Value := DataComun.FindMoneda(OIDMoneda)^.Nombre;
  end;
end;

end.
