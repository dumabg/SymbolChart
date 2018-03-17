unit dmNuevaCartera;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, kbmMemTable;

type
  TNuevaCartera = class(TDataModule)
    qBrokers: TIBQuery;
    qBrokersOID_BROKER: TSmallintField;
    qBrokersNOMBRE: TIBStringField;
    Monedas: TkbmMemTable;
    MonedasOID_MONEDA: TIntegerField;
    MonedasMONEDA: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses dmBD, dmDataComun;



{$R *.dfm}

procedure TNuevaCartera.DataModuleCreate(Sender: TObject);
var pMonedas: PDataComunMonedas;
  i, num: integer;
begin
  qBrokers.Open;

  Monedas.Open;
  pMonedas := DataComun.Monedas;
  num := DataComun.CountMonedas - 1;
  // La posición 0 no tiene nada, está en blanco
  for i := 1 to num do begin
    Monedas.Append;
    MonedasOID_MONEDA.Value := pMonedas^[i].OIDMoneda;
    MonedasMONEDA.Value := pMonedas^[i].Nombre;
    Monedas.Post;
  end;
  Monedas.First;
end;

end.
