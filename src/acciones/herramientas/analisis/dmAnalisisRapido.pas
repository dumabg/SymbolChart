unit dmAnalisisRapido;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, dmDataModuleBase;

type
  TAnalisisRapido = class(TDataModuleBase)
    qParams: TIBQuery;
    qParamsOR_VALOR: TSmallintField;
    qParamsFLAGS: TIntegerField;
    procedure qParamsBeforeOpen(DataSet: TDataSet);
  private
  public
    procedure Open;
  end;

implementation

uses dmData, dmBD, UtilDB;


{$R *.dfm}

procedure TAnalisisRapido.Open;
begin
  OpenDataSet(qParams);
end;

procedure TAnalisisRapido.qParamsBeforeOpen(DataSet: TDataSet);
begin
  qParams.ParamByName('OID_SESION').AsInteger := Data.OIDSesion;
end;

end.
