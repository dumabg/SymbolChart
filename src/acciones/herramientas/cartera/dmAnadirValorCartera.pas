unit dmAnadirValorCartera;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, dmCartera, kbmMemTable;

type
  TAnadirValorCartera = class(TDataModule)
    Cuentas: TkbmMemTable;
    CuentasOR_CUENTA: TSmallintField;
    CuentasNOMBRE: TIBStringField;
  private
    procedure SetCartera(const Value: TCartera);
  public
    property Cartera: TCartera write SetCartera;
  end;


implementation

uses UtilDB;

{$R *.dfm}

procedure TAnadirValorCartera.SetCartera(const Value: TCartera);
var inspect: TInspectDataSet;
begin
  Cuentas.Close;
  Cuentas.Open;
  inspect := StartInspectDataSet(Value.qCartera);
  try
    with Value do begin
      qCartera.First;
      while not qCartera.Eof do begin
        Cuentas.Append;
        CuentasOR_CUENTA.Value := qCarteraOR_CUENTA.Value;
        CuentasNOMBRE.Value := qCarteraNOMBRE.Value;
        Cuentas.Post;
        qCartera.Next;
      end;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
  Cuentas.Locate('OR_CUENTA', Value.qCarteraOR_CUENTA.Value, []);
end;

end.
