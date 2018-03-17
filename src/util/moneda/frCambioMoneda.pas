unit frCambioMoneda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Mask, JvExMask, JvSpin, dmCambioMoneda;

type
  TfCambioMoneda = class(TFrame)
    lMonedaBase: TLabel;
    eMonedaValor: TJvSpinEdit;
    lMonedaNueva: TLabel;
    sbBuscarBD: TSpeedButton;
    sbBuscarInternet: TSpeedButton;
    procedure sbBuscarBDClick(Sender: TObject);
    procedure sbBuscarInternetClick(Sender: TObject);
  private
    FMonedaTo: string;
    FMonedaFrom: string;
    CambioMoneda: TCambioMoneda;
    function GetMonedaValor: currency;
    procedure SetMonedaFrom(const Value: string);
    procedure SetMonedaTo(const Value: string);
    procedure SetMonedaValor(const Value: currency);
  public
    constructor Create(AOwner: TComponent); override;
    procedure BuscarBD;
    property MonedaValor: currency read GetMonedaValor write SetMonedaValor;
    property MonedaFrom: string read FMonedaFrom write SetMonedaFrom;
    property MonedaTo: string read FMonedaTo write SetMonedaTo;
  end;

implementation

{$R *.dfm}

resourcestring
  CAMBIO_INTERNET_ERROR = 'No se ha podido recuperar el cambio desde Internet';
  CAMBIO_RECUPERADO = 'Cambio recuperado';

procedure TfCambioMoneda.BuscarBD;
begin
  eMonedaValor.Value := CambioMoneda.GetCambioBD(FMonedaFrom, FMonedaTo);
end;

constructor TfCambioMoneda.Create(AOwner: TComponent);
begin
  inherited;
  CambioMoneda := TCambioMoneda.Create(Self);
end;

function TfCambioMoneda.GetMonedaValor: currency;
begin
  result := eMonedaValor.Value;
end;

procedure TfCambioMoneda.SetMonedaFrom(const Value: string);
begin
  FMonedaFrom := Value;
  lMonedaBase.Caption := '1 ' + Value + ' = ';
end;

procedure TfCambioMoneda.SetMonedaTo(const Value: string);
begin
  FMonedaTo := Value;
  lMonedaNueva.Caption := Value;
end;

procedure TfCambioMoneda.SetMonedaValor(const Value: currency);
begin
  eMonedaValor.Value := Value;
end;

procedure TfCambioMoneda.sbBuscarBDClick(Sender: TObject);
begin
  BuscarBD;
  ShowMessage(CAMBIO_RECUPERADO);
end;

procedure TfCambioMoneda.sbBuscarInternetClick(Sender: TObject);
begin
  try
    eMonedaValor.Value := CambioMoneda.GetCambioInternet(FMonedaFrom, FMonedaTo);
    ShowMessage(CAMBIO_RECUPERADO);
  except
    ShowMessage(CAMBIO_INTERNET_ERROR);
  end;
end;

end.
