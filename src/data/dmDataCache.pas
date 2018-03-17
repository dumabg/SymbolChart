unit dmDataCache;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery;

type
  TDataCache = class(TDataModule)
    qDatos: TIBQuery;
  private
    FOIDValor: integer;
    procedure SetOIDValor(const Value: integer);
  public

    property OIDValor: integer read FOIDValor write SetOIDValor;
  end;

var
  DataCache: TDataCache;

implementation

uses dmBD;

{$R *.dfm}

{ TDataCache }

procedure TDataCache.SetOIDValor(const Value: integer);
begin
  FOIDValor := Value;
end;

end.
