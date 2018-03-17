unit dmEstudioNuevo;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, dmBrokers, 
  IBSQL, IBUpdateSQL, kbmMemTable;

type
  TEstudioNuevo = class(TBrokers)
    qEstrategias: TIBQuery;
    qEstrategiasNOMBRE: TIBStringField;
    qEstrategiasDESCRIPCION: TMemoField;
    qEstrategiasOID_ESTRATEGIA: TSmallintField;
    dsMonedas: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
  public
  end;


implementation

uses dmBD, dmDataComun, UtilDB;

{$R *.dfm}

procedure TEstudioNuevo.DataModuleCreate(Sender: TObject);
begin
  inherited;
  OpenDataSet(qEstrategias);
end;

end.
