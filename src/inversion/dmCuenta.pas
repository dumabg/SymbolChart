unit dmCuenta;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmCuentaBase, DB, IBCustomDataSet, IBQuery, IBSQL,
  kbmMemTable, UtilDB;

const
  SIN_CUENTA = Low(Integer);
    
type
  TCuenta = class(TCuentaBase)
    qMaxNumMov: TIBQuery;
    qMaxNumMovMAX: TIntegerField;
    qCuentaMovimientos: TIBQuery;
    iCrearCuenta: TIBSQL;
    qCuenta: TIBQuery;
    qCuentaOID_CUENTA: TSmallintField;
    qCuentaOR_MONEDA: TSmallintField;
    qCuentaMovimientosOR_CUENTA: TSmallintField;
    qCuentaMovimientosNUM_MOVIMIENTO: TIntegerField;
    qCuentaMovimientosFECHA_HORA: TDateTimeField;
    qCuentaMovimientosTIPO: TIBStringField;
    qCuentaMovimientosOR_VALOR: TSmallintField;
    qCuentaMovimientosCAMBIO: TIBBCDField;
    qCuentaMovimientosCOMISION: TIBBCDField;
    qCuentaMovimientosPOSICION: TIBStringField;
    qCuentaMovimientosOR_NUM_MOVIMIENTO: TIntegerField;
    qCuentaMovimientosGANANCIA: TIBBCDField;
    qCuentaMovimientosBROKER_ID: TIntegerField;
    qCuentaMovimientosMONEDA_VALOR: TIBBCDField;
    qCuentaMovimientosMONEDA: TIBStringField;
    qCuentaMovimientosNOMBRE: TIBStringField;
    qCuentaMovimientosSIMBOLO: TIBStringField;
    qCuentaMovimientosOID_MERCADO: TSmallintField;
    qCuentaMovimientosMERCADO: TIBStringField;
    qCuentaMovimientosOR_MONEDA: TSmallintField;
    qCuentaMovimientosGANANCIA_MONEDA_BASE: TIBBCDField;
    qCuentaMovimientosCOSTE: TCurrencyField;
//    uCuentaMovimientos: TIBUpdateDataSet;
    qCuentaMovimientosNUM_ACCIONES: TIntegerField;
    qCuentaMovimientosOID_MONEDA: TSmallintField;
    iCuentaMovimientos: TIBSQL;
    uCuentaMovimientos: TIBSQL;
    dCuentaMovimientos: TIBSQL;
    procedure qCuentaAfterOpen(DataSet: TDataSet);
    procedure qCuentaMovimientosCalcFields(DataSet: TDataSet);
    procedure CuentaMovimientosBeforeDelete(DataSet: TDataSet);
    procedure CuentaMovimientosBeforePost(DataSet: TDataSet);
{    procedure uCuentaMovimientosBeforeExecureSQL(UpdateKind: TUpdateKind;
      q: TIBSQL);}
  private
    FOIDCuenta: integer;
    OIDGenerator: TOIDGenerator;
  protected
    procedure InicializarNumMovimiento;
    procedure CargarMovimientos; override;
  public
    constructor Create(const AOwner: TComponent); overload; virtual;
    destructor Destroy; override;
//    function CerrarMonedas: TCerrarMonedasResult; override;
//    function CambiarCambioMoneda: TCerrarMonedasResult; override;
    function Crear(const OIDMonedaBase: integer): integer;
    procedure Cargar(const OIDCuenta: integer);
    property OIDCuenta: integer read FOIDCuenta;
  end;

implementation

uses dmBD, dmCuentaMovimientosBase, dmDataComun, Math, UtilDBSC;

{$R *.dfm}

const MONEDA_POR_DEFECTO = 1;

{ TCuentaBaseBD }

{function TCuenta.CambiarCambioMoneda: TCerrarMonedasResult;
begin
  result := inherited CambiarCambioMoneda;
  case result of
    cmrCancelado: CuentaMovimientos.CancelUpdates;
    cmrCambiado: CuentaMovimientos.ApplyUpdates(0);
  end;
end;
}
procedure TCuenta.Cargar(const OIDCuenta: integer);
begin
  // Si la cuenta ya se ha utilizado y se recarga, tendrá los eventos asignados
  // y dará error, los inicializamos.
  OnAnadirCurvaCapital := nil;
  OnAfterScrollCurvaCapital := nil;
  OnCapitalRecalculado := nil;
  OnInicializarCurvaCapital := nil;

  qCuenta.Close;
  qCuenta.Params[0].AsInteger := OIDCuenta;
  qCuenta.Open;
  SetOIDMoneda(qCuentaOR_MONEDA.Value);
  InicializarNumMovimiento;
end;

procedure TCuenta.CargarMovimientos;
begin
  if not CuentaMovimientos.Active then
    CuentaMovimientos.Open;
end;

{
function TCuenta.CerrarMonedas: TCerrarMonedasResult;
begin
  result := inherited CerrarMonedas;
  case result of
    cmrCancelado: CuentaMovimientos.CancelUpdates;
    cmrCambiado: CuentaMovimientos.ApplyUpdates(0);
  end;
end;
}

function TCuenta.Crear(const OIDMonedaBase: integer): integer;
begin
  if OIDGenerator = nil then
    OIDGenerator := TOIDGenerator.Create(scdUsuario, 'CUENTA');
  result := OIDGenerator.NextOID;
  iCrearCuenta.ParamByName('OID_CUENTA').AsInteger := result;
  iCrearCuenta.ParamByName('OR_MONEDA').AsInteger := OIDMonedaBase;
  iCrearCuenta.ExecQuery;
  FOIDMoneda := OIDMonedaBase;
  FOIDCuenta := result;
  // Si creamos una cuenta, inicializamos los movimientos, ya que Inicializar
  // no inicializa los movimientos, sino que a partir de los movimientos crea
  // las posiciones abiertas y cerradas
  CuentaMovimientos.Close;
  CuentaMovimientos.Open;
  Inicializar;
end;

constructor TCuenta.Create(const AOwner: TComponent);
begin
  inherited Create(AOwner, MONEDA_POR_DEFECTO);
  FOIDCuenta := SIN_CUENTA;
end;

procedure TCuenta.CuentaMovimientosBeforeDelete(DataSet: TDataSet);
begin
  inherited;
  dCuentaMovimientos.ParamByName('OR_CUENTA').AsInteger := FOIDCuenta;
  dCuentaMovimientos.ParamByName('NUM_MOVIMIENTO').AsInteger := CuentaMovimientosNUM_MOVIMIENTO.Value;
  ExecQuery(dCuentaMovimientos, true);
end;

procedure TCuenta.CuentaMovimientosBeforePost(DataSet: TDataSet);
  procedure insertar;
  begin
    AssignParams(CuentaMovimientos, iCuentaMovimientos);
    iCuentaMovimientos.ParamByName('OR_CUENTA').AsInteger := FOIDCuenta;
    iCuentaMovimientos.ParamByName('OR_MONEDA').AsInteger := CuentaMovimientosOID_MONEDA.Value;
{    iCuentaMovimientos.ParamByName('NUM_MOVIMIENTO').AsInteger := CuentaMovimientosNUM_MOVIMIENTO.Value;
    iCuentaMovimientos.ParamByName('FECHA_HORA').AsDateTime := CuentaMovimientosFECHA_HORA.Value;
    iCuentaMovimientos.ParamByName('TIPO').AsString := CuentaMovimientosTIPO.Value;
    iCuentaMovimientos.ParamByName('OR_VALOR').AsInteger := CuentaMovimientosOR_VALOR.Value;
    iCuentaMovimientos.ParamByName('NUM_ACCIONES').AsInteger := CuentaMovimientosNUM_ACCIONES.Value;
    iCuentaMovimientos.ParamByName('CAMBIO').AsCurrency := CuentaMovimientosCAMBIO.Value;
    iCuentaMovimientos.ParamByName('COMISION').AsCurrency := CuentaMovimientosCOMISION.Value;
    if CuentaMovimientosPOSICION.IsNull then
      iCuentaMovimientos.ParamByName('POSICION').Clear
    else
      iCuentaMovimientos.ParamByName('POSICION').AsString := CuentaMovimientosPOSICION.Value;
    iCuentaMovimientos.ParamByName('OR_NUM_MOVIMIENTO').AsInteger := CuentaMovimientosOR_NUM_MOVIMIENTO.Value;
    iCuentaMovimientos.ParamByName('GANANCIA').AsCurrency := CuentaMovimientosGANANCIA.Value;
    iCuentaMovimientos.ParamByName('BROKER_ID').AsInteger := CuentaMovimientosBROKER_ID.Value;
    iCuentaMovimientos.ParamByName('OR_MONEDA').AsInteger := CuentaMovimientosOID_MONEDA.Value;
    iCuentaMovimientos.ParamByName('MONEDA_VALOR').AsCurrency := CuentaMovimientosMONEDA_VALOR.Value;
    iCuentaMovimientos.ParamByName('GANANCIA_MONEDA_BASE').AsCurrency := CuentaMovimientosGANANCIA_MONEDA_BASE.Value;}
    ExecQuery(iCuentaMovimientos, true);
  end;

  procedure modificar;
  begin
    AssignParams(CuentaMovimientos, uCuentaMovimientos);
{    uCuentaMovimientos.ParamByName('OR_NUM_MOVIMIENTO').AsInteger := CuentaMovimientosOR_NUM_MOVIMIENTO.Value;
    uCuentaMovimientos.ParamByName('MONEDA_VALOR').AsCurrency := CuentaMovimientosMONEDA_VALOR.Value;
    uCuentaMovimientos.ParamByName('GANANCIA').AsCurrency := CuentaMovimientosGANANCIA.Value;
    uCuentaMovimientos.ParamByName('GANANCIA_MONEDA_BASE').AsCurrency := CuentaMovimientosGANANCIA_MONEDA_BASE.Value;
    uCuentaMovimientos.ParamByName('NUM_MOVIMIENTO').AsInteger := CuentaMovimientosNUM_MOVIMIENTO.Value;}
    uCuentaMovimientos.ParamByName('OR_CUENTA').AsInteger := FOIDCuenta;
    ExecQuery(uCuentaMovimientos, true);
  end;

begin
  inherited;
  if CuentaMovimientos.State = dsInsert then begin
    insertar;
  end
  else begin
    if CuentaMovimientos.State = dsEdit then
      modificar;
  end;
end;

destructor TCuenta.Destroy;
begin
  if OIDGenerator <> nil then  
    OIDGenerator.Free;
  inherited;
end;

procedure TCuenta.InicializarNumMovimiento;
begin
  qMaxNumMov.Close;
  qMaxNumMov.Params[0].AsInteger := OIDCuenta;
  qMaxNumMov.Open;
  OIDNumMovimiento := qMaxNumMovMAX.Value;
  qMaxNumMov.Close;
end;

{procedure TCuenta.uCuentaMovimientosBeforeExecureSQL(UpdateKind: TUpdateKind;
  q: TIBSQL);
begin
  inherited;
  q.ParamByName('OR_CUENTA').Value := FOIDCuenta;

{  object uCuentaMovimientos: TIBUpdateDataSet
    ModifySQL.Strings = (
      'update CUENTA_MOVIMIENTOS'
      'set OR_NUM_MOVIMIENTO = :OR_NUM_MOVIMIENTO,'
      'MONEDA_VALOR = :MONEDA_VALOR,'
      'GANANCIA = :GANANCIA,'
      'GANANCIA_MONEDA_BASE = :GANANCIA_MONEDA_BASE'
      'where'
      'OR_CUENTA = :OR_CUENTA and'
      'NUM_MOVIMIENTO = :NUM_MOVIMIENTO')
    InsertSQL.Strings = (
      'insert into CUENTA_MOVIMIENTOS'

        '  (OR_CUENTA, NUM_MOVIMIENTO, FECHA_HORA, TIPO, OR_VALOR, NUM_AC' +
        'CIONES, CAMBIO,'

        '  COMISION, POSICION, OR_NUM_MOVIMIENTO, GANANCIA, BROKER_ID,OR_' +
        'MONEDA,'
      '  MONEDA_VALOR, GANANCIA_MONEDA_BASE)'
      'values'

        '  (:OR_CUENTA, :NUM_MOVIMIENTO, :FECHA_HORA, :TIPO, :OR_VALOR, :' +
        'NUM_ACCIONES, :CAMBIO,'

        '  :COMISION, :POSICION, :OR_NUM_MOVIMIENTO, :GANANCIA, :BROKER_I' +
        'D, :OID_MONEDA,'
      '  :MONEDA_VALOR, :GANANCIA_MONEDA_BASE)')
    DeleteSQL.Strings = (
      'delete from CUENTA_MOVIMIENTOS'
      'where'
      '  NUM_MOVIMIENTO = :NUM_MOVIMIENTO and'
      '  OR_CUENTA = :OR_CUENTA')
    DataSet = CuentaMovimientos
    OnBeforeExecureSQL = uCuentaMovimientosBeforeExecureSQL
    Left = 184
    Top = 128
  end }
//end;

procedure TCuenta.qCuentaAfterOpen(DataSet: TDataSet);
begin
  inherited;
  FOIDCuenta := qCuentaOID_CUENTA.Value;
  FOIDMoneda := qCuentaOR_MONEDA.Value;
  CuentaMovimientos.Close;
  qCuentaMovimientos.Params[0].AsInteger := OIDCuenta;
  // Antes de cargar los movimientos se tiene que desactivar el updateDataSet,
  // sino al cargar los datos hace insert y se tiran las querys
  CuentaMovimientos.BeforeDelete := nil;
  CuentaMovimientos.BeforePost := nil;
//  uCuentaMovimientos.DataSet := nil;
  CuentaMovimientos.LoadFromDataSet(qCuentaMovimientos, []);
//  uCuentaMovimientos.DataSet := CuentaMovimientos;
  CuentaMovimientos.BeforeDelete := CuentaMovimientosBeforeDelete;
  CuentaMovimientos.BeforePost := CuentaMovimientosBeforePost;

  Inicializar;
end;

procedure TCuenta.qCuentaMovimientosCalcFields(DataSet: TDataSet);
var mov: TMovimientoInversion;
  moneda: PDataComunMoneda;

  function GetCosteMovimiento: currency;
  begin
    result := (qCuentaMovimientosNUM_ACCIONES.Value * qCuentaMovimientosCAMBIO.Value);
    if mov = miVentaAcciones then
      result := result - qCuentaMovimientosCOMISION.Value
    else
      result := result + qCuentaMovimientosCOMISION.Value;
    if qCuentaMovimientosMONEDA.Value = 'GBP' then
      result := result / 100;
  end;

  procedure DescValor;
  var valor: PDataComunValor;
  begin
    valor := DataComun.FindValor(qCuentaMovimientosOR_VALOR.Value);
    qCuentaMovimientosSIMBOLO.Value := valor^.Simbolo;
    qCuentaMovimientosNOMBRE.Value := valor^.Nombre;
    qCuentaMovimientosOID_MERCADO.Value := valor^.Mercado^.OIDMercado;
    qCuentaMovimientosMERCADO.Value := valor^.Mercado^.Pais;
  end;

begin
  inherited;
  mov := GetMovimientoInversion(qCuentaMovimientosTIPO.Value);
  case mov of
    miCompraAcciones: begin
      qCuentaMovimientosCOSTE.Value := -GetCosteMovimiento;
      DescValor;
    end;
    miVentaAcciones: begin
      qCuentaMovimientosCOSTE.Value := GetCosteMovimiento;
      DescValor;
    end;
  end;
  moneda := DataComun.FindMoneda(qCuentaMovimientosOR_MONEDA.Value);
  qCuentaMovimientosOID_MONEDA.Value := moneda^.OIDMoneda;
  qCuentaMovimientosMONEDA.Value := moneda^.Nombre;
end;

end.

