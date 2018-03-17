unit fmAnadirValorCartera;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, JvExMask, JvSpin,
  JvExStdCtrls, JvCombobox, JvDBSearchComboBox, DB, ExtCtrls, ComCtrls,
  Buttons, DBCtrls, fmBasePrecio,
  dmAnadirValorCartera, frCambioMoneda, fmBaseCabeceraValor,
  dmInversorCartera, JvGIF;

type
  TfAnadirValorCartera = class(TfBasePrecio)
    dtpFecha: TDateTimePicker;
    lFecha: TLabel;
    rbLargo: TRadioButton;
    iLargo: TImage;
    rbCorto: TRadioButton;
    iCorto: TImage;
    Label1: TLabel;
    Label2: TLabel;
    eNumAcciones: TJvSpinEdit;
    sCartera: TJvDBSearchComboBox;
    Label3: TLabel;
    dsCuentas: TDataSource;
    Label6: TLabel;
    cbEn: TJvComboBox;
    procedure eNumAccionesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sCarteraChange(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure cbEnChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Inversor: TInversorCartera;
    AnadirValorCartera: TAnadirValorCartera;
    function GetOIDCartera: integer;
    function GetEnPosicionesPendientes: boolean;
    procedure SetEnPosicionesPendientes(const Value: boolean);
  protected
    function GetOIDMonedaBase: integer; override;
    function GetNumAcciones: integer; override;
  public
    property OIDCartera: integer read GetOIDCartera;
    property enPosicionesPendientes: boolean read GetEnPosicionesPendientes write SetEnPosicionesPendientes;
  end;

implementation

uses dmData, dmConfiguracion, fmCartera, dmCuentaMovimientosBase, UtilDB,
  dmBroker, flags, dmBrokerCartera, SCMain;

{$R *.dfm}

resourcestring
  CAPTION_PRECIO_EN_POSICIONES_ABIERTAS = 'Precio';
  CAPTION_PRECIO_NO_EN_POSICIONES_ABIERTAS = 'Precio límite';

procedure TfAnadirValorCartera.bOKClick(Sender: TObject);
var monedaValor: currency;
  orden: TOrdenLimitada;
begin
  inherited;
  Inversor.Cartera.Cargar(AnadirValorCartera.CuentasOR_CUENTA.Value);
  if enPosicionesPendientes then begin
    orden := TOrdenLimitada.Create;
    try
      orden.Cambio := ePrecio.Value;
      orden.OIDValor := Data.OIDValor;
      orden.Largo := rbLargo.Checked;
      orden.NumAcciones := eNumAcciones.AsInteger;
      Inversor.Broker.AbrirPosicion(orden);
    finally
      orden.Free;
    end;
  end
  else begin
    if cbCambioMoneda.Checked then
      monedaValor := fCambioMoneda.MonedaValor
    else
      monedaValor := SIN_MONEDA_VALOR;
    Inversor.Cartera.CompraAcciones(dtpFecha.DateTime, Data.OIDvalor, eNumAcciones.AsInteger,
      GetPrecio, eComision.Value, rbLargo.Checked, monedaValor);
  end;
  ModalResult := mrOk;
  Configuracion.WriteInteger('Nuevo cartera', 'ORCuenta', Inversor.Cartera.qCarteraOR_CUENTA.Value);
end;

procedure TfAnadirValorCartera.cbEnChange(Sender: TObject);
var enPosicionesAbiertas: boolean;
begin
  inherited;
  enPosicionesAbiertas := cbEn.ItemIndex = 1;
  lFecha.Visible := enPosicionesAbiertas;
  dtpFecha.Visible := enPosicionesAbiertas;
  lComision.Visible := enPosicionesAbiertas;
  eComision.Visible := enPosicionesAbiertas;
  cbComisionIncluida.Visible := enPosicionesAbiertas;
  if enPosicionesAbiertas then begin
    lPrecioMedio.Visible := cbComisionIncluida.Checked;;
    fCambioMoneda.Visible := cbCambioMoneda.Checked;
    lPrecio.Caption := CAPTION_PRECIO_EN_POSICIONES_ABIERTAS;
    iComisionGBP.Visible := iPrecioGBP.Visible;
    iPrecioGBP.Left := 144;
    Height := 419;
    fCambioMoneda.Visible := true;
    cbCambioMoneda.Visible := true;
    RefrescarCambioMoneda;
  end
  else begin
    lPrecioMedio.Visible := false;
    fCambioMoneda.Visible := false;
    cbCambioMoneda.Visible := false;
    iComisionGBP.Visible := false;
    iPrecioGBP.Left := 172;
    lPrecio.Caption := CAPTION_PRECIO_NO_EN_POSICIONES_ABIERTAS;
    Height := 282;
  end;
end;

procedure TfAnadirValorCartera.eNumAccionesChange(Sender: TObject);
begin
  inherited;
  RefrescarPrecio;
end;

procedure TfAnadirValorCartera.FormCreate(Sender: TObject);
var posValor: TPosicionamientoValor;
  OIDCuenta: integer;
//  fCartera: TfCartera;
  posicionado: currency;
begin
  AnadirValorCartera := TAnadirValorCartera.Create(Self);

//  fCartera := SCMain.FindComponent(TFORMCARTERA_INTERNAL_NAME) as TfCartera;
//  if fCartera <> nil then
//    Inversor := fCartera.Inversor
//  else
//    Inversor := TInversorCartera.Create(Self);
  if Owner is TfCartera then
    Inversor := TfCartera(Owner).Inversor
  else
    Inversor := TInversorCartera.Create(Self);

  AnadirValorCartera.Cartera := Inversor.Cartera;
  dtpFecha.Date := now;
  dtpFecha.MaxDate := now;
  posValor := Data.PosicionamientoValor;
  rbLargo.Checked := posValor = pvLargo;
  rbCorto.Checked := posValor = pvCorto;
  OIDValor := Data.ValoresOID_VALOR.Value;
  OIDCuenta := Configuracion.ReadInteger('Nuevo cartera', 'OIDCuenta', -1);
  Locate(Inversor.Cartera.qCartera, 'OR_CUENTA', OIDCuenta, []);
  posicionado := Data.Posicionado;
  if posicionado = 0 then begin
    ePrecio.Value := Data.CotizacionCIERRE.Value;
  end
  else
    ePrecio.Value := posicionado;
end;

procedure TfAnadirValorCartera.FormShow(Sender: TObject);
begin
  inherited;
  sCarteraChange(nil);
  cbEnChange(nil);
end;

function TfAnadirValorCartera.GetEnPosicionesPendientes: boolean;
begin
  result := cbEn.ItemIndex = 0;
end;

function TfAnadirValorCartera.GetNumAcciones: integer;
begin
  result := eNumAcciones.AsInteger;
end;

function TfAnadirValorCartera.GetOIDCartera: integer;
begin
  result := Inversor.Cartera.OIDCuenta;
end;

function TfAnadirValorCartera.GetOIDMonedaBase: integer;
begin
  result := Inversor.Cartera.OIDMoneda;
end;

procedure TfAnadirValorCartera.sCarteraChange(Sender: TObject);
var OIDValor: integer;
  numAcciones: cardinal;
  precio: currency;
begin
  inherited;
//  if Data.FlagsMensajes.EsOR([cInicioCiclo, cInicioCicloVirtual{,
//    cPrimeraAdvertencia, cPrimeraAdvertenciaVirtual}]) then begin
    OIDValor := Data.OIDValor;
    precio := ePrecio.Value;
    numAcciones := Inversor.GetNumAcciones(OIDValor, true, precio);
    eNumAcciones.Value := numAcciones;
    if not enPosicionesPendientes then
      eComision.Value := (Inversor.Broker as TBrokerCartera).GetComision(OIDValor, numAcciones,
        precio * numAcciones, rbLargo.Checked, true);
//  end;
  if not enPosicionesPendientes then
    RefrescarCambioMoneda;
end;


procedure TfAnadirValorCartera.SetEnPosicionesPendientes(const Value: boolean);
begin
  if Value then
    cbEn.ItemIndex := 0
  else
    cbEn.ItemIndex := 1;
end;

end.
