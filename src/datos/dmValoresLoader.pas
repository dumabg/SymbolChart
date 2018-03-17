unit dmValoresLoader;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, IBSQL, UtilDBSC;

type
  TValoresLoader = class(TDataModule)
    qValores: TIBQuery;
    qValoresOID_VALOR: TSmallintField;
  private
    procedure InitializeDiarioSemanal(const DiarioSemanalQuery: TDiarioSemanalDatosQuery);
  protected
    procedure LoadData; virtual;
  public
    constructor Create; reintroduce;
    procedure Load;
  end;

implementation

uses dmBD, UtilDB;

{$R *.dfm}

{ TValoresLoader }


constructor TValoresLoader.Create;
begin
  inherited Create(nil);
end;

procedure TValoresLoader.InitializeDiarioSemanal(const DiarioSemanalQuery: TDiarioSemanalDatosQuery);
begin
  DiarioSemanalQuery.SQL := 'delete from VALOR_ACTIVO';
  DiarioSemanalQuery.ExecQuery;

  DiarioSemanalQuery.SQL := 'insert into VALOR_ACTIVO (OR_VALOR) values (:OID_VALOR)';
  qValores.First;
  while not qValores.Eof do begin
    DiarioSemanalQuery.SetParam(0, qValoresOID_VALOR.Value);
    DiarioSemanalQuery.ExecQuery;
    qValores.Next;
  end;
end;

procedure TValoresLoader.Load;
var DiarioSemanalQuery: TDiarioSemanalDatosQuery;
begin
  DiarioSemanalQuery := TDiarioSemanalDatosQuery.Create;
  try
    DiarioSemanalQuery.Transaction.StartTransaction;
    try
      LoadData;
      InitializeDiarioSemanal(DiarioSemanalQuery);
      DiarioSemanalQuery.Transaction.Commit;
    except
      DiarioSemanalQuery.Transaction.Rollback;
      raise;
    end;
  finally
    DiarioSemanalQuery.Free;
  end;
end;

procedure TValoresLoader.LoadData;
begin
  qValores.Close;
  qValores.Open;
end;

end.
