unit dmCambioMoneda;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, dmThreadDataModule;

type
  TCambioMoneda = class(TThreadDataModule)
    qCambio: TIBQuery;
    qCambioCIERRE: TIBBCDField;
  private
    { Private declarations }
  public
    function GetCambioBD(const fromMoneda, toMoneda: string): currency; overload;
    function GetCambioBD(const fromOIDMoneda, toOIDMoneda: integer): currency; overload;
    function GetCambioInternet(const fromMoneda, toMoneda: string): currency; overload;
    function GetCambioInternet(const fromOIDMoneda, toOIDMoneda: integer): currency; overload;
  end;


implementation

uses UserServerCalls, dmDataComun, dmBD;

{$R *.dfm}

{ TCambioMoneda }

function TCambioMoneda.GetCambioBD(const fromMoneda, toMoneda: string): currency;
var pValores: TPDataComunValores;
  inverso: boolean;
begin
  pValores := DataComun.FindValoresSimbolo(fromMoneda + toMoneda);
  inverso := Length(pValores) = 0;
  if inverso then
    pValores := DataComun.FindValoresSimbolo(toMoneda + fromMoneda);
  qCambio.Close;
  qCambio.Params[0].AsInteger := pValores[0]^.OIDValor;
  qCambio.Open;
  if inverso then
    result := 1 / qCambioCIERRE.Value
  else
    result := qCambioCIERRE.Value;
  qCambio.Close;
end;

function TCambioMoneda.GetCambioBD(const fromOIDMoneda,
  toOIDMoneda: integer): currency;
begin
  result := GetCambioBD(
    DataComun.FindMoneda(fromOIDMoneda)^.Nombre,
    DataComun.FindMoneda(toOIDMoneda)^.Nombre);
end;

function TCambioMoneda.GetCambioInternet(const fromOIDMoneda,
  toOIDMoneda: integer): currency;
begin
  result := GetCambioInternet(
    DataComun.FindMoneda(fromOIDMoneda)^.Nombre,
    DataComun.FindMoneda(toOIDMoneda)^.Nombre);
end;

function TCambioMoneda.GetCambioInternet(const fromMoneda,
  toMoneda: string): currency;
var ServerCall: TCambioMonedaCall;
begin
  ServerCall := TCambioMonedaCall.Create;
  result := ServerCall.GetCambioMoneda(fromMoneda, toMoneda);
end;

end.
