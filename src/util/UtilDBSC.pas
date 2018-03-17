unit UtilDBSC;

interface

uses UtilDB, dmBD, IBDatabase, Classes, IBSQL;

type
  TOIDGeneratorHelper = class helper for TOIDGenerator
  public
    constructor Create(const database: TSCDatabase; const tableName: string); overload;
    constructor Create(const database: TSCDatabase; const tableName, OIDColumnName: string); overload;
  end;

  TDiarioSemanalDatosQuery = class
  private
    FTransaction: TIBTransaction;
    FBDDiaria, FBDSemanal: TIBDatabase;
    IBSQLDiaria, IBSQLSemanal: TIBSQL;
    procedure SetSQL(const Value: string);
    function GetSQL: string;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure ExecQuery;
    procedure SetParam(const index: integer; const param: Variant);
    procedure SetParamByName(const name: string; const param: Variant);
    property BDDiaria: TIBDatabase read FBDDiaria;
    property BDSemanal: TIBDatabase read FBDSemanal;
    property SQL: string read GetSQL write SetSQL;
    property Transaction: TIBTransaction read FTransaction;
  end;

{  procedure RedirectQuerysToNewDatabase(const datamodule: TDataModule;
    const BDDatos: TBDDatos; const closeOldDatabase: boolean);}

implementation



{procedure RedirectQuerysToNewDatabase(const datamodule: TDataModule;
  const BDDatos: TBDDatos; const closeOldDatabase: boolean);
var i, num: integer;
  icds: TIBCustomDataSet;
  c: TComponent;
  tipo: TFPDatabase;
  ibDB: TIBDatabase;
begin
  num := datamodule.ComponentCount - 1;
  for i := 0 to num do begin
    c := datamodule.Components[i];
    if c is TIBCustomDataSet then begin
      icds := TIBCustomDataSet(c);
      ibDB := icds.Database;
      if closeOldDatabase then
        CloseDatabase(ibDB);
      tipo := BD.GetTipoDatabase(ibDB);
      icds.Database := BD.GetNewDatabase(datamodule, tipo, BDDatos);
      icds.Transaction := icds.Database.DefaultTransaction;
    end;
  end;
end;}

{ TOIDGeneratorHelper }

constructor TOIDGeneratorHelper.Create(const database: TSCDatabase;
  const tableName: string);
begin
  inherited Create(BD.GetDatabase(database), tableName);
end;

constructor TOIDGeneratorHelper.Create(const database: TSCDatabase;
  const tableName, OIDColumnName: string);
begin
  inherited Create(BD.GetDatabase(database), tableName, OIDColumnName);
end;


{ TDiarioSemanalDatosQuery }

constructor TDiarioSemanalDatosQuery.Create;
begin
  inherited;
  FBDSemanal := BD.GetNewDatabase(nil, scdDatos, bddSemanal);
  FBDDiaria := BD.GetNewDatabase(nil, scdDatos, bddDiaria);
  FTransaction := TIBTransaction.Create(nil);
  FTransaction.AddDatabase(FBDDiaria);
  FTransaction.AddDatabase(FBDSemanal);
  IBSQLDiaria := TIBSQL.Create(nil);
  IBSQLDiaria.Database := FBDDiaria;
  IBSQLDiaria.Transaction := FTransaction;
  IBSQLSemanal := TIBSQL.Create(nil);
  IBSQLSemanal.Database := FBDSemanal;
  IBSQLSemanal.Transaction := FTransaction;
end;

destructor TDiarioSemanalDatosQuery.Destroy;
begin
  FBDDiaria.Close;
  FBDSemanal.Close;
  IBSQLDiaria.Free;
  IBSQLSemanal.Free;
  Transaction.Free;
  FBDSemanal.Free;
  FBDDiaria.Free;
  inherited Destroy;
end;


procedure TDiarioSemanalDatosQuery.ExecQuery;
begin
  // MUY IMPORTANTE: No se puede reutilizar IBSQL para lanzar una query a 2 base
  // de datos diferentes. Una vez se ha lanzado una query sobre una BD, siempre
  // va a lanzarla sobre esa base de datos, aunque le reasignemos el Database.
  // Por lo tanto, tenemos que crear una consulta limpia cada vez que tengamos
  // que tirar una query.
  UtilDB.ExecQuery(IBSQLDiaria, false);
  UtilDB.ExecQuery(IBSQLSemanal, false);
end;

function TDiarioSemanalDatosQuery.GetSQL: string;
begin
  result := IBSQLDiaria.SQL.Text;
end;

procedure TDiarioSemanalDatosQuery.SetParam(const index: integer;
  const param: Variant);
begin
  IBSQLDiaria.Params[index].Value := param;
  IBSQLSemanal.Params[index].Value := param;
end;

procedure TDiarioSemanalDatosQuery.SetParamByName(const name: string;
  const param: Variant);
begin
  IBSQLDiaria.ParamByName(name).Value := param;
  IBSQLSemanal.ParamByName(name).Value := param;
end;

procedure TDiarioSemanalDatosQuery.SetSQL(const Value: string);
begin
  IBSQLDiaria.SQL.Text := Value;
  IBSQLSemanal.SQL.Text := Value;
end;

end.
