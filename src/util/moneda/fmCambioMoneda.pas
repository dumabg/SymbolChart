unit fmCambioMoneda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, ExtCtrls, StdCtrls, Buttons, frCambioMoneda;

type
  TfCambioMoneda2 = class(TfBase)
    fCambioMoneda: TfCambioMoneda;
    bAceptar: TBitBtn;
    bCancelar: TBitBtn;
    Bevel2: TBevel;
    procedure fCambioMonedaeMonedaValorChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function GetMonedaFrom: string;
    function GetMonedaTo: string;
    function GetMonedaValor: currency;
    procedure SetMonedaFrom(const Value: string);
    procedure SetMonedaTo(const Value: string);
    procedure SetMonedaValor(const Value: currency);
    { Private declarations }
  public
    property MonedaValor: currency read GetMonedaValor write SetMonedaValor;
    property MonedaFrom: string read GetMonedaFrom write SetMonedaFrom;
    property MonedaTo: string read GetMonedaTo write SetMonedaTo;
  end;


implementation

{$R *.dfm}

resourcestring
  CAPTION_MONEDA = 'Cambio moneda';

{ TfCambioMoneda2 }

procedure TfCambioMoneda2.fCambioMonedaeMonedaValorChange(Sender: TObject);
begin
  inherited;
  bAceptar.Enabled := MonedaValor > 0;
end;

procedure TfCambioMoneda2.FormShow(Sender: TObject);
begin
  inherited;
  fCambioMoneda.BuscarBD;
end;

function TfCambioMoneda2.GetMonedaFrom: string;
begin
  result := fCambioMoneda.MonedaFrom;
end;

function TfCambioMoneda2.GetMonedaTo: string;
begin
  result := fCambioMoneda.MonedaTo;
end;

function TfCambioMoneda2.GetMonedaValor: currency;
begin
  result := fCambioMoneda.MonedaValor;
end;

procedure TfCambioMoneda2.SetMonedaFrom(const Value: string);
begin
  fCambioMoneda.MonedaFrom := Value;
end;

procedure TfCambioMoneda2.SetMonedaTo(const Value: string);
begin
  fCambioMoneda.MonedaTo := Value;
  Caption := CAPTION_MONEDA + ' ' + Value;
end;

procedure TfCambioMoneda2.SetMonedaValor(const Value: currency);
begin
  fCambioMoneda.MonedaValor := Value;
end;

end.
