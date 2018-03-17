unit fmBasePrecio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBaseCabeceraValor, ExtCtrls, StdCtrls, Buttons, frCambioMoneda,
  Mask, JvExMask, JvSpin, JvGIF;

type
  TfBasePrecio = class(TfBaseCabeceraValor)
    lPrecio: TLabel;
    ePrecio: TJvSpinEdit;
    lComision: TLabel;
    eComision: TJvSpinEdit;
    cbComisionIncluida: TCheckBox;
    lPrecioMedio: TLabel;
    fCambioMoneda: TfCambioMoneda;
    bOK: TBitBtn;
    bCancelar: TBitBtn;
    Bevel2: TBevel;
    cbCambioMoneda: TCheckBox;
    iPrecioGBP: TImage;
    iComisionGBP: TImage;
    procedure eComisionChange(Sender: TObject);
    procedure ePrecioChange(Sender: TObject);
    procedure cbComisionIncluidaClick(Sender: TObject);
    procedure cbCambioMonedaClick(Sender: TObject);
    procedure fCambioMonedasbBuscarBDClick(Sender: TObject);
  private
    OIDMonedaValor: integer;
    function GetComision: currency;
    procedure SetComision(const Value: currency);
    procedure SetPrecio(const Value: currency);
    function GetMonedaValor: currency;
  protected
    procedure SetOIDValor(const Value: integer); override;
    procedure RefrescarCambioMoneda;
    procedure RefrescarPrecio;
    function GetPrecio: currency;
    function GetOIDMonedaBase: integer; virtual; abstract;
    function GetNumAcciones: integer; virtual; abstract;
  public
    property Precio: currency read GetPrecio write SetPrecio;
    property Comision: currency read GetComision write SetComision;
    property MonedaValor: currency read GetMonedaValor;
  end;

implementation

uses dmDataComun, dmCuentaMovimientosBase;

{$R *.dfm}

resourcestring
  PRECIO_REAL = 'Precio sin contar comisión = %.4m';

{ TfBasePrecio }

procedure TfBasePrecio.cbCambioMonedaClick(Sender: TObject);
begin
  inherited;
  if cbCambioMoneda.Checked then begin
    fCambioMoneda.Visible := true;
    Height := Height + fCambioMoneda.Height;
  end
  else begin
    fCambioMoneda.Visible := false;
    Height := Height - fCambioMoneda.Height;
  end;
end;

procedure TfBasePrecio.cbComisionIncluidaClick(Sender: TObject);
begin
  inherited;
  lPrecioMedio.Visible := cbComisionIncluida.Checked;
  RefrescarPrecio;
end;

procedure TfBasePrecio.eComisionChange(Sender: TObject);
begin
  inherited;
  RefrescarPrecio;
end;

procedure TfBasePrecio.ePrecioChange(Sender: TObject);
begin
  inherited;
  RefrescarPrecio;
end;

procedure TfBasePrecio.fCambioMonedasbBuscarBDClick(Sender: TObject);
begin
  inherited;
  fCambioMoneda.sbBuscarBDClick(Sender);

end;

function TfBasePrecio.GetComision: currency;
begin
  result := eComision.Value;
end;

function TfBasePrecio.GetMonedaValor: currency;
begin
  if cbCambioMoneda.Checked then
    result := fCambioMoneda.MonedaValor
  else
    result := SIN_MONEDA_VALOR;
end;

function TfBasePrecio.GetPrecio: currency;
var numAcciones: cardinal;
begin
  if cbComisionIncluida.Checked then begin
    numAcciones := GetNumAcciones;
    result := ((numAcciones * ePrecio.Value) - eComision.Value) / numAcciones;
  end
  else
    result := ePrecio.Value;
end;

procedure TfBasePrecio.RefrescarCambioMoneda;
var OIDMonedaBase: integer;
begin
  OIDMonedaBase := GetOIDMonedaBase;
  if OIDMonedaValor = OIDMonedaBase then begin
    if cbCambioMoneda.Visible then begin
      cbCambioMoneda.Visible := false;
      Height := Height - cbCambioMoneda.Height;
    end;
    if fCambioMoneda.Visible then begin
      fCambioMoneda.Visible := false;
      Height := Height - fCambioMoneda.Height;
    end;
  end
  else begin
    if not cbCambioMoneda.Visible then begin
      cbCambioMoneda.Visible := true;
      Height := Height + cbCambioMoneda.Height;
    end;
    if fCambioMoneda.Visible then begin
      if not cbCambioMoneda.Checked then begin
        fCambioMoneda.Visible := false;
        Height := Height - fCambioMoneda.Height;
      end;
    end
    else begin
      if cbCambioMoneda.Checked then begin
        fCambioMoneda.Visible := true;
        Height := Height + fCambioMoneda.Height;
      end;
    end;
    fCambioMoneda.MonedaTo := DataComun.FindMoneda(OIDMonedaValor)^.Nombre;
    fCambioMoneda.MonedaFrom := DataComun.FindMoneda(OIDMonedaBase)^.Nombre;
    if fCambioMoneda.MonedaValor = 0 then    
      fCambioMoneda.BuscarBD;
  end;
end;

procedure TfBasePrecio.RefrescarPrecio;
begin
  if cbComisionIncluida.Checked then
    lPrecioMedio.Caption :=  format(PRECIO_REAL, [GetPrecio]);
end;

procedure TfBasePrecio.SetComision(const Value: currency);
begin
  eComision.Value := Value;
  RefrescarPrecio;
end;

procedure TfBasePrecio.SetOIDValor(const Value: integer);
var isGBP: boolean;
  valor: PDataComunValor;
  moneda: PDataComunMoneda;
begin
  inherited SetOIDValor(Value);
  valor := DataComun.FindValor(Value);
  moneda := valor^.Mercado^.Moneda;
  OIDMonedaValor := Moneda^.OIDMoneda;
  isGBP := Moneda^.Nombre = 'GBP';
  RefrescarCambioMoneda;
  iPrecioGBP.Visible := isGBP;
  iComisionGBP.Visible := isGBP;
end;

procedure TfBasePrecio.SetPrecio(const Value: currency);
begin
  ePrecio.Value := Value;
  RefrescarPrecio;
end;

end.
