unit dmCalendarioValor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmCalendario, DB, IBCustomDataSet, IBQuery;

type
  TCalendarioValor = class(TCalendario)
  private
    FOIDValor: integer;
  protected
    procedure BuscarFechas; override;
  public
    constructor Create(const AOwner: TComponent; const OIDValor: integer); reintroduce;
    property OIDValor: integer read FOIDValor;
  end;


implementation

uses dmBD;

{$R *.dfm}

{ TCalendarioValor }

procedure TCalendarioValor.BuscarFechas;
begin
  qDias.ParamByName('OID_VALOR').AsInteger := OIDValor;
  qMaxDate.ParamByName('OID_VALOR').AsInteger := OIDValor;
  qMinDate.ParamByName('OID_VALOR').AsInteger := OIDValor;
  qMaxDate.Open;
  qMinDate.Open;
  qMinDate.Last;
  FMinDate := qMinDateFECHA.Value;
  qMinDate.Close;
end;

constructor TCalendarioValor.Create(const AOwner: TComponent; const OIDValor: integer);
begin
  FOIDValor := OIDValor;
  inherited Create(AOwner);
end;

end.
