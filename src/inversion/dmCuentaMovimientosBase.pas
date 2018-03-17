unit dmCuentaMovimientosBase;

interface

uses
  SysUtils, Classes, DB, kbmMemTable, Tipos, dmThreadDataModule;

resourcestring
  ERROR_INTERNO_VENTA = 'Error interno en la venta de acciones: %d';

type
  TMovimientoInversion = (miAnadirCapital, miRetirarCapital, miCompraAcciones,
    miVentaAcciones);

  TCuentaMovimientosBase = class(TThreadDataModule)
    CuentaMovimientos: TkbmMemTable;
    CuentaMovimientosNUM_MOVIMIENTO: TIntegerField;
    CuentaMovimientosFECHA_HORA: TDateTimeField;
    CuentaMovimientosTIPO: TStringField;
    CuentaMovimientosOR_VALOR: TSmallintField;
    CuentaMovimientosNOMBRE: TStringField;
    CuentaMovimientosSIMBOLO: TStringField;
    CuentaMovimientosOID_MERCADO: TIntegerField;
    CuentaMovimientosMERCADO: TStringField;
    CuentaMovimientosNUM_ACCIONES: TIntegerField;
    CuentaMovimientosCAMBIO: TBCDField;
    CuentaMovimientosCOMISION: TBCDField;
    CuentaMovimientosPOSICION: TStringField;
    CuentaMovimientosOR_NUM_MOVIMIENTO: TIntegerField;
    CuentaMovimientosGANANCIA: TBCDField;
    CuentaMovimientosBROKER_ID: TIntegerField;
    CuentaMovimientosOID_MONEDA: TSmallintField;
    CuentaMovimientosMONEDA: TStringField;
    CuentaMovimientosMONEDA_VALOR: TBCDField;
    CuentaMovimientosGANANCIA_MONEDA_BASE: TBCDField;
    CuentaMovimientosCOSTE: TCurrencyField;
  private
    FOnCapitalRecalculado: TNotificacion;
    FDescOIDMoneda: string;
    procedure SetCapital(const Value: currency);
  protected
    FCapital: currency;
    FOIDMoneda: integer;
    procedure Inicializar; virtual;
    procedure CargarMovimientos; virtual;
    procedure InicializarCapital; virtual;
    function GetNumMovimiento: integer; virtual; abstract;
    procedure AsignarCamposDescripcionValor(
      const FieldOID_VALOR: TIntegerField;
      const FieldNOMBRE, FieldSIMBOLO: TStringField;
      const FieldOID_MERCADO: TIntegerField; FieldMERCADO: TStringField;
      const FieldOID_MONEDA: TIntegerField; const FieldMONEDA: TStringField);
    function GetCambioMoneda(const OIDMoneda: integer): currency; virtual; abstract;
    function GetCoste: currency;
    function GetCosteMoneda: currency; overload;
    function GetCosteMoneda(const coste: currency): currency; overload;
    function GetMovimientoInversion: TMovimientoInversion; overload;
    function GetMovimientoInversion(const cad: string): TMovimientoInversion; overload;
    procedure RecalcularCapital;
    procedure SetOIDMoneda(const OIDMoneda: integer);
  public
    constructor Create(const AOwner: TComponent; const OIDMoneda: integer); reintroduce;
    procedure AnadirCapital(const cantidad: currency); overload; virtual;
    procedure AnadirCapital(const fecha: TDateTime; const cantidad: currency); overload; virtual;
    procedure RetirarCaptial(const cantidad: currency); overload; virtual;
    procedure RetirarCapital(const fecha: TDateTime; const cantidad: currency); overload; virtual;
    function CompraAcciones(const fecha: TDateTime; const OIDValor: integer;
      const NumAcciones: cardinal; Cambio, Comision: currency; const EsPosicionLarga: boolean;
      const MonedaValor: currency): integer; overload; virtual;
    function CompraAcciones(const BrokerID: integer; const fecha: TDateTime;
      const OIDValor: integer; const NumAcciones: cardinal; Cambio, Comision: currency;
      const EsPosicionLarga: boolean; const MonedaValor: currency): integer; overload; virtual;
    procedure VentaAcciones(const fecha: TDateTime; const OIDMovimientoCompra: integer;
      const cambio, comision, MonedaValor: currency); overload; virtual;
    procedure VentaAcciones(const BrokerID: integer; const fecha: TDateTime;
      const OIDMovimientoCompra: integer; const cambio, comision, MonedaValor: currency); overload; virtual;
    property OIDMoneda: integer read FOIDMoneda;
    property DescOIDMoneda: string read FDescOIDMoneda;
    property Capital: currency read FCapital write SetCapital;
    property OnCapitalRecalculado: TNotificacion read FOnCapitalRecalculado write FOnCapitalRecalculado;
  end;


const
  SIN_MONEDA_VALOR = -1;

implementation

{$R *.dfm}

uses Variants, dmDataComun, UtilDB;

const
  SIN_BROKER: integer = -1;

resourcestring
  ERROR_FALTA_MOV_COMPRA = 'No está en la cartera el movimiento de compra %d';
  GANANCIA_MONEDA_BASE_CAPTION = 'Ganancia %s';

const
  MovimientoInversionChar : array[TMovimientoInversion] of char = ('A','R','C','V');

{ TMovimientosInversion }

procedure TCuentaMovimientosBase.AnadirCapital(const cantidad: currency);
begin
  AnadirCapital(now, cantidad);
end;

procedure TCuentaMovimientosBase.AnadirCapital(const fecha: TDateTime;
  const cantidad: currency);
begin
  CuentaMovimientos.First;
  CuentaMovimientos.Insert;
  CuentaMovimientosNUM_MOVIMIENTO.Value := GetNumMovimiento;
  CuentaMovimientosFECHA_HORA.Value := fecha;
  CuentaMovimientosTIPO.Value := MovimientoInversionChar[miAnadirCapital];
  CuentaMovimientosGANANCIA.Value := cantidad;
  CuentaMovimientosOID_MONEDA.Value := FOIDMoneda;
  CuentaMovimientosMONEDA.Value := DataComun.FindMoneda(FOIDMoneda)^.Nombre;
  CuentaMovimientosGANANCIA_MONEDA_BASE.Value := cantidad;
  CuentaMovimientos.Post;
  Capital := Capital + cantidad;
end;


procedure TCuentaMovimientosBase.AsignarCamposDescripcionValor(
      const FieldOID_VALOR: TIntegerField;
      const FieldNOMBRE, FieldSIMBOLO: TStringField;
      const FieldOID_MERCADO: TIntegerField; FieldMERCADO: TStringField;
      const FieldOID_MONEDA: TIntegerField; const FieldMONEDA: TStringField);
var valor: PDataComunValor;
  mercado: PDataComunMercado;
begin
  valor := DataComun.FindValor(FieldOID_VALOR.Value);
  mercado := valor^.Mercado;
  FieldOID_MERCADO.Value := mercado^.OIDMercado;
  FieldNOMBRE.Value := valor^.Nombre;
  FieldSIMBOLO.Value := valor^.Simbolo;
  FieldMERCADO.Value := mercado^.Nombre;
  FieldOID_MONEDA.Value := mercado^.Moneda^.OIDMoneda;
  FieldMONEDA.Value := mercado^.Moneda^.Nombre;
end;

function TCuentaMovimientosBase.CompraAcciones(const BrokerID: integer;
  const fecha: TDateTime; const OIDValor: integer; const NumAcciones: cardinal; Cambio,
  Comision: currency; const EsPosicionLarga: boolean; const MonedaValor: currency): integer;
var OIDCuentaMovimientos: integer;
  coste: currency;
begin
  CuentaMovimientos.First;
  CuentaMovimientos.Insert;
  OIDCuentaMovimientos := GetNumMovimiento;
  CuentaMovimientosNUM_MOVIMIENTO.Value := OIDCuentaMovimientos;
  CuentaMovimientosOR_VALOR.Value := OIDValor;
  CuentaMovimientosFECHA_HORA.Value := fecha;
  CuentaMovimientosTIPO.Value := MovimientoInversionChar[miCompraAcciones];
  CuentaMovimientosNUM_ACCIONES.Value := NumAcciones;
  CuentaMovimientosCAMBIO.Value := Cambio;
  CuentaMovimientosCOMISION.Value := Comision;
  if EsPosicionLarga then
    CuentaMovimientosPOSICION.Value := 'L'
  else
    CuentaMovimientosPOSICION.Value := 'C';
  AsignarCamposDescripcionValor(CuentaMovimientosOR_VALOR, CuentaMovimientosNOMBRE,
    CuentaMovimientosSIMBOLO, CuentaMovimientosOID_MERCADO, CuentaMovimientosMERCADO,
    CuentaMovimientosOID_MONEDA, CuentaMovimientosMONEDA);
  if BrokerID = SIN_BROKER then
    CuentaMovimientosBROKER_ID.Clear
  else
    CuentaMovimientosBROKER_ID.Value := BrokerID;

  coste := GetCoste;
  if (CuentaMovimientosOID_MONEDA.Value = FOIDMoneda) or (MonedaValor = SIN_MONEDA_VALOR) then begin
    CuentaMovimientosMONEDA_VALOR.Clear;
    Capital := Capital - coste;
  end
  else begin
    Capital := Capital - MonedaValor;
    CuentaMovimientosMONEDA_VALOR.Value := MonedaValor;
  end;

  CuentaMovimientosCOSTE.Value := -coste;
  CuentaMovimientos.Post;
  result := OIDCuentaMovimientos;
end;

constructor TCuentaMovimientosBase.Create(const AOwner: TComponent;
  const OIDMoneda: integer);
begin
  inherited Create(AOwner);
  SetOIDMoneda(OIDMoneda);
  FCapital := 0;
end;

function TCuentaMovimientosBase.GetCoste: currency;
begin
  result := (CuentaMovimientosNUM_ACCIONES.Value * CuentaMovimientosCAMBIO.Value);
  if GetMovimientoInversion = miVentaAcciones then
    result := result - CuentaMovimientosCOMISION.Value
  else
    result := result + CuentaMovimientosCOMISION.Value;
  if CuentaMovimientosMONEDA.Value = 'GBP' then
    result := result / 100;
end;

function TCuentaMovimientosBase.GetCosteMoneda(const coste: currency): currency;
begin
  if CuentaMovimientosOID_MONEDA.Value = FOIDMoneda then begin
    result := coste;
  end
  else begin
    if CuentaMovimientosMONEDA_VALOR.IsNull then
      result := coste / GetCambioMoneda(CuentaMovimientosOID_MONEDA.Value)
    else
      result := coste / CuentaMovimientosMONEDA_VALOR.Value;
  end;
end;

function TCuentaMovimientosBase.GetMovimientoInversion(
  const cad: string): TMovimientoInversion;
var i: TMovimientoInversion;
begin
  for i := Low(MovimientoInversionChar) to High(MovimientoInversionChar) do
    if cad = MovimientoInversionChar[i] then begin
      result := i;
      exit;
    end;
  raise Exception.Create('MovimientoInversion not found: ' + cad);
end;

function TCuentaMovimientosBase.GetCosteMoneda: currency;
begin
  result := GetCosteMoneda(GetCoste);
end;

function TCuentaMovimientosBase.GetMovimientoInversion: TMovimientoInversion;
begin
  result := GetMovimientoInversion(CuentaMovimientosTIPO.Value);
end;

procedure TCuentaMovimientosBase.CargarMovimientos;
begin
  if not CuentaMovimientos.Active then
//    CuentaMovimientos.CreateDataSet;
  CuentaMovimientos.Open;
end;

function TCuentaMovimientosBase.CompraAcciones(const fecha: TDateTime;
  const OIDValor: integer; const NumAcciones: cardinal; Cambio, Comision: currency;
  const EsPosicionLarga: boolean; const MonedaValor: currency): integer;
begin
  result := CompraAcciones(SIN_BROKER, fecha, OIDValor, NumAcciones,
    Cambio, Comision, EsPosicionLarga, MonedaValor);
end;

procedure TCuentaMovimientosBase.Inicializar;
begin
  CargarMovimientos;
  InicializarCapital;
end;

procedure TCuentaMovimientosBase.InicializarCapital;
begin
end;

procedure TCuentaMovimientosBase.RecalcularCapital;
var inspect: TInspectDataSet;
begin
  inspect := StartInspectDataSet(CuentaMovimientos);
  try
    FCapital := 0;
    CuentaMovimientos.Last;
    while not CuentaMovimientos.Bof do begin
      case GetMovimientoInversion of
        miAnadirCapital, miRetirarCapital:
          // En caso del retiro de capital, la ganacia ya es negativa
          FCapital := FCapital + CuentaMovimientosGANANCIA.Value;
        miCompraAcciones:
          if CuentaMovimientosPOSICION.Value = 'L' then
            FCapital := FCapital - GetCosteMoneda
          else begin
            if CuentaMovimientosOR_NUM_MOVIMIENTO.IsNull then  //No tiene asociado venta
              FCapital := FCapital - GetCosteMoneda
            else
              // Como es corto, debe restarse al revés cuando se cierra la posición
              FCapital := FCapital + GetCosteMoneda;
          end;
        miVentaAcciones:
          if CuentaMovimientosPOSICION.Value = 'L' then
            FCapital := FCapital + GetCosteMoneda
          else
            FCapital := FCapital - GetCosteMoneda;
      end;
      CuentaMovimientos.Prior;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
  if Assigned(FOnCapitalRecalculado) then
    FOnCapitalRecalculado;
end;

procedure TCuentaMovimientosBase.RetirarCapital(const fecha: TDateTime;
  const cantidad: currency);
begin
  CuentaMovimientos.First;
  CuentaMovimientos.Insert;
  CuentaMovimientosNUM_MOVIMIENTO.Value := GetNumMovimiento;
  CuentaMovimientosFECHA_HORA.Value := fecha;
  CuentaMovimientosTIPO.Value := MovimientoInversionChar[miRetirarCapital];
  CuentaMovimientosGANANCIA.Value := -cantidad;
  CuentaMovimientosOID_MONEDA.Value := FOIDMoneda;
  CuentaMovimientosMONEDA.Value := DataComun.FindMoneda(FOIDMoneda)^.Nombre;
  CuentaMovimientosGANANCIA_MONEDA_BASE.Value := -cantidad;
  CuentaMovimientos.Post;
  Capital := Capital - cantidad;
end;

procedure TCuentaMovimientosBase.RetirarCaptial(const cantidad: currency);
begin
  RetirarCapital(now, cantidad);
end;

procedure TCuentaMovimientosBase.SetCapital(const Value: currency);
begin
  FCapital := Value;
  if Assigned(OnCapitalRecalculado) then
    OnCapitalRecalculado;
end;

procedure TCuentaMovimientosBase.SetOIDMoneda(const OIDMoneda: integer);
begin
  FOIDMoneda := OIDMoneda;
  FDescOIDMoneda := DataComun.FindMoneda(FOIDMoneda)^.Nombre;
  CuentaMovimientosGANANCIA_MONEDA_BASE.DisplayLabel :=
    Format(GANANCIA_MONEDA_BASE_CAPTION, [FDescOIDMoneda]);
end;

procedure TCuentaMovimientosBase.VentaAcciones(const BrokerID: integer;
  const fecha: TDateTime; const OIDMovimientoCompra: integer; const cambio,
  comision, MonedaValor: currency);
var //ganancia: currency;
  OIDValor, NumAcciones: integer;
  Posicion: string;
//  ComisionCompra, CambioCompra: currency;
  OIDCuentaMovimientos: integer;
//  movimiento: Variant;
  costeCompra, costeCompraMoneda, costeVenta, costeVentaMoneda, ganancia: currency;
  corto: boolean;
begin
{  movimiento := CuentaMovimientos.Lookup('NUM_MOVIMIENTO', OIDMovimientoCompra,
    'NUM_ACCIONES;OR_VALOR;CAMBIO;COMISION;POSICION');
  if not VarIsNull(movimiento) then begin}
  if CuentaMovimientos.Locate('NUM_MOVIMIENTO', OIDMovimientoCompra, []) then begin
    costeCompra := GetCoste;
    costeCompraMoneda := GetCosteMoneda(costeCompra);
{    NumAcciones := movimiento[0];
    OIDValor := movimiento[1];
    CambioCompra := movimiento[2];
    ComisionCompra := movimiento[3];
    Posicion := movimiento[4];}
    OIDValor := CuentaMovimientosOR_VALOR.Value;
    Posicion := CuentaMovimientosPOSICION.Value;
    corto := Posicion = 'C';
    NumAcciones := CuentaMovimientosNUM_ACCIONES.Value;
    OIDCuentaMovimientos := GetNumMovimiento;
    CuentaMovimientos.First;
    CuentaMovimientos.Insert;
    CuentaMovimientosNUM_MOVIMIENTO.Value := OIDCuentaMovimientos;
    CuentaMovimientosOR_NUM_MOVIMIENTO.Value := OIDMovimientoCompra;
    CuentaMovimientosFECHA_HORA.Value := fecha;
    CuentaMovimientosTIPO.Value := MovimientoInversionChar[miVentaAcciones];
    CuentaMovimientosOR_VALOR.Value := OIDValor;
    CuentaMovimientosNUM_ACCIONES.Value := NumAcciones;
    CuentaMovimientosCAMBIO.Value := cambio;
    CuentaMovimientosCOMISION.Value := comision;
    CuentaMovimientosPOSICION.Value := Posicion;
    AsignarCamposDescripcionValor(CuentaMovimientosOR_VALOR, CuentaMovimientosNOMBRE,
      CuentaMovimientosSIMBOLO, CuentaMovimientosOID_MERCADO, CuentaMovimientosMERCADO,
      CuentaMovimientosOID_MONEDA, CuentaMovimientosMONEDA);
    if (CuentaMovimientosOID_MONEDA.Value = FOIDMoneda) or (MonedaValor = SIN_MONEDA_VALOR) then begin
      CuentaMovimientosMONEDA_VALOR.Clear;
    end
    else
      CuentaMovimientosMONEDA_VALOR.Value := MonedaValor;

    if BrokerID = SIN_BROKER then
      CuentaMovimientosBROKER_ID.Clear
    else
      CuentaMovimientosBROKER_ID.Value := BrokerID;
    // MUY IMPORTANTE: GetCoste debe ejecutarse después de asignar MONEDA_VALOR
    // ya que si es moneda inglesa, se divide por 100 para pasar pences a pounds
    costeVenta := GetCoste;
    ganancia := costeVenta - costeCompra;
    if corto then
      ganancia := -ganancia;
    CuentaMovimientosGANANCIA.Value := ganancia;
    costeVentaMoneda := GetCosteMoneda(costeVenta);
    CuentaMovimientosCOSTE.Value := costeVenta;
    ganancia := costeVentaMoneda - costeCompraMoneda;
    if corto then
      ganancia := -ganancia
    else
      Capital := Capital + costeVentaMoneda;
    CuentaMovimientosGANANCIA_MONEDA_BASE.Value := ganancia;
    CuentaMovimientos.Post;
    if CuentaMovimientos.Locate('NUM_MOVIMIENTO', OIDMovimientoCompra, []) then begin
      CuentaMovimientos.Edit;
      CuentaMovimientosOR_NUM_MOVIMIENTO.Value := OIDCuentaMovimientos;
      CuentaMovimientos.Post;
      if corto then begin
        costeCompra := GetCosteMoneda;
        Capital := Capital + costeCompra - (costeVentaMoneda - costeCompra);
      end;
    end
    else
      raise Exception.Create(Format(ERROR_INTERNO_VENTA, [OIDMovimientoCompra]));
  end
  else
    raise Exception.Create(Format(ERROR_FALTA_MOV_COMPRA, [OIDMovimientoCompra]));
end;

procedure TCuentaMovimientosBase.VentaAcciones(const fecha: TDateTime;
  const OIDMovimientoCompra: integer; const cambio, comision, MonedaValor: currency);
begin
  VentaAcciones(SIN_BROKER, fecha, OIDMovimientoCompra, cambio, comision, MonedaValor);
end;

end.
