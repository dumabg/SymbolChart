unit dmBrokers;

interface

uses
  SysUtils, Classes, IBCustomDataSet, IBUpdateSQL, DB, IBQuery,
    IBSQL, kbmMemTable, UtilDB;

type
  EComprobar = class(Exception)
  private
    FColumna: TField;
    FMercado: string;
  public
    property Mercado: string read FMercado;
    property Columna: TField read FColumna;
  end;

  TBrokers = class(TDataModule)
    qBroker: TIBQuery;
    qBrokerOID_BROKER: TSmallintField;
    qBrokerNOMBRE: TIBStringField;
    qBrokerComision: TIBQuery;
    dsBroker: TDataSource;
    uBroker: TIBUpdateSQL;
    qBrokerComisionENTRADA: TMemoField;
    qBrokerComisionENTRADA_MAXIMO: TMemoField;
    qBrokerComisionENTRADA_MINIMO: TMemoField;
    qBrokerComisionSALIDA: TMemoField;
    qBrokerComisionSALIDA_MAXIMO: TMemoField;
    qBrokerComisionSALIDA_MINIMO: TMemoField;
    dTodo: TIBSQL;
    iComision: TIBSQL;
    dComision: TIBSQL;
    qBrokerCartera: TIBQuery;
    qBrokerCarteraNOMBRE: TIBStringField;
    qBrokerEstudios: TIBQuery;
    qBrokerEstudiosNOMBRE: TIBStringField;
    mBrokerComision: TkbmMemTable;
    mBrokerComisionOID_MERCADO: TSmallintField;
    mBrokerComisionMERCADO: TIBStringField;
    mBrokerComisionENTRADA: TMemoField;
    mBrokerComisionENTRADA_MAXIMO: TMemoField;
    mBrokerComisionENTRADA_MINIMO: TMemoField;
    mBrokerComisionSALIDA: TMemoField;
    mBrokerComisionSALIDA_MAXIMO: TMemoField;
    mBrokerComisionSALIDA_MINIMO: TMemoField;
    qBrokerComisionOR_BROKER: TSmallintField;
    qBrokerComisionOR_MERCADO: TSmallintField;
    procedure DataModuleCreate(Sender: TObject);
    procedure mBrokerComisionAfterPost(DataSet: TDataSet);
    procedure qBrokerAfterScroll(DataSet: TDataSet);
    procedure qBrokerBeforeScroll(DataSet: TDataSet);
    procedure DataModuleDestroy(Sender: TObject);
  private
    Entrada, EntradaMaximo, EntradaMinimo, Salida, SalidaMaximo, SalidaMinimo: string;
    OIDGenerator: TOIDGenerator;
    procedure LoadBrokerComision;
  public
    procedure AnadirBroker(const nombre: string);
    function BorrarBroker: boolean;
    procedure BorrarTodo;
    procedure Borrar;
    procedure CopiarTodos;
    procedure CopiarES;
    procedure CopiarSE;
    procedure Copiar;
    procedure Pegar;
    procedure Comprobar;
    procedure SeleccionarBroker(const OIDBroker: integer);
  end;


implementation

uses dmBD, ScriptComision, UtilDBSC, dmDataComun;

{$R *.dfm}

procedure TBrokers.AnadirBroker(const nombre: string);
var OIDBroker: integer;
begin
  OIDBroker := OIDGenerator.NextOID;
  qBroker.Append;
  qBrokerOID_BROKER.Value := OIDBroker;
  qBrokerNOMBRE.Value := nombre;
  qBroker.Post;
  BD.IBTransactionUsuario.CommitRetaining;
end;

procedure TBrokers.Borrar;
begin
  mBrokerComision.Edit;
  mBrokerComisionENTRADA.Clear;
  mBrokerComisionENTRADA_MAXIMO.Clear;
  mBrokerComisionENTRADA_MINIMO.Clear;
  mBrokerComisionSALIDA.Clear;
  mBrokerComisionSALIDA_MAXIMO.Clear;
  mBrokerComisionSALIDA_MINIMO.Clear;
  mBrokerComision.Post;
end;

function TBrokers.BorrarBroker: boolean;
begin
  qBrokerCartera.Close;
  qBrokerCartera.Params[0].AsInteger := qBrokerOID_BROKER.Value;
  qBrokerCartera.Open;
  qBrokerEstudios.Close;
  qBrokerEstudios.Params[0].AsInteger := qBrokerOID_BROKER.Value;
  qBrokerEstudios.Open;
  result := qBrokerCartera.IsEmpty and qBrokerEstudios.IsEmpty;
  if result then begin
    qBroker.Delete;
    BD.IBTransactionUsuario.CommitRetaining;
  end;
end;

procedure TBrokers.BorrarTodo;
begin
  dTodo.Params[0].AsInteger := qBrokerOID_BROKER.Value;
  ExecQuery(dTodo, false);
  BD.IBTransactionUsuario.CommitRetaining;
  mBrokerComision.Close;
  mBrokerComision.Open;
end;

procedure TBrokers.Comprobar;
var inspect: TInspectDataSet;
  Evaluador: TScriptComision;
  e: EComprobar;
  bookmark: TBookmarkStr;

  procedure evaluar(const columna: TMemoField);
  var formula: string;
  begin
    formula := columna.Value;
    if formula <> '' then begin
      Evaluador.Expression := formula;
      if not Evaluador.Compile then begin
        e := EComprobar.Create(Evaluador.Messages.Text);
        e.FMercado := mBrokerComisionMERCADO.Value;
        e.FColumna := columna;
        bookmark := mBrokerComision.Bookmark;
        raise e;
      end;
    end;
  end;

begin
  inspect := StartInspectDataSet(mBrokerComision);
  try
    Evaluador := TScriptComision.Create;
    try
      mBrokerComision.First;
      while not mBrokerComision.Eof do begin
        evaluar(mBrokerComisionENTRADA);
        evaluar(mBrokerComisionENTRADA_MAXIMO);
        evaluar(mBrokerComisionENTRADA_MINIMO);
        evaluar(mBrokerComisionSALIDA);
        evaluar(mBrokerComisionSALIDA_MAXIMO);
        evaluar(mBrokerComisionSALIDA_MINIMO);
        mBrokerComision.Next;
      end;
    finally
      Evaluador.Free;
    end;
  finally
    EndInspectDataSet(inspect);
    if bookmark <> '' then
      mBrokerComision.Bookmark := bookmark;
  end;
end;

procedure TBrokers.Copiar;
begin
  Entrada := mBrokerComisionENTRADA.Value;
  EntradaMaximo := mBrokerComisionENTRADA_MAXIMO.Value;
  EntradaMinimo := mBrokerComisionENTRADA_MINIMO.Value;
  Salida := mBrokerComisionSALIDA.Value;
  SalidaMaximo := mBrokerComisionSALIDA_MAXIMO.Value;
  SalidaMinimo := mBrokerComisionSALIDA_MINIMO.Value;
end;

procedure TBrokers.CopiarES;
begin
  mBrokerComision.Edit;
  mBrokerComisionSALIDA.Value := mBrokerComisionENTRADA.Value;
  mBrokerComisionSALIDA_MAXIMO.Value := mBrokerComisionENTRADA_MAXIMO.Value;
  mBrokerComisionSALIDA_MINIMO.Value := mBrokerComisionENTRADA_MINIMO.Value;
  mBrokerComision.Post;
end;

procedure TBrokers.CopiarSE;
begin
  mBrokerComision.Edit;
  mBrokerComisionENTRADA.Value := mBrokerComisionSALIDA.Value;
  mBrokerComisionENTRADA_MAXIMO.Value := mBrokerComisionSALIDA_MAXIMO.Value;
  mBrokerComisionENTRADA_MINIMO.Value := mBrokerComisionSALIDA_MINIMO.Value;
  mBrokerComision.Post;
end;

procedure TBrokers.CopiarTodos;
var entrada, entradaMaximo, entradaMinimo, salida, salidaMaximo, salidaMinimo: Variant;
  inspect: TInspectDataSet;
begin
  entrada := mBrokerComisionENTRADA.Value;
  entradaMaximo := mBrokerComisionENTRADA_MAXIMO.Value;
  entradaMinimo := mBrokerComisionENTRADA_MINIMO.Value;
  salida := mBrokerComisionSALIDA.Value;
  salidaMaximo := mBrokerComisionSALIDA_MAXIMO.Value;
  salidaMinimo := mBrokerComisionSALIDA_MINIMO.Value;
  inspect := StartInspectDataSet(mBrokerComision);
  try
    mBrokerComision.First;
    while not mBrokerComision.Eof do begin
      mBrokerComision.Edit;
      mBrokerComisionENTRADA.Value := entrada;
      mBrokerComisionENTRADA_MAXIMO.Value := entradaMaximo;
      mBrokerComisionENTRADA_MINIMO.Value := entradaMinimo;
      mBrokerComisionSALIDA.Value := salida;
      mBrokerComisionSALIDA_MAXIMO.Value := salidaMaximo;
      mBrokerComisionSALIDA_MINIMO.Value := salidaMinimo;
      mBrokerComision.Post;
      mBrokerComision.Next;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;

procedure TBrokers.DataModuleCreate(Sender: TObject);
begin
  qBroker.Open;
  OIDGenerator := TOIDGenerator.Create(scdUsuario, 'BROKER');
end;

procedure TBrokers.DataModuleDestroy(Sender: TObject);
begin
  if mBrokerComision.State in dsEditModes then
    mBrokerComision.Post;
  OIDGenerator.Free;
end;

procedure TBrokers.LoadBrokerComision;
var inspect: TInspectDataSet;
  mercados: PDataComunMercados;
  i, OIDMercado: integer;
begin
  inspect := StartInspectDataSet(mBrokerComision);
  try
    mBrokerComision.Close;
    mBrokerComision.Open;
    mercados := DataComun.Mercados;
    mBrokerComision.AfterPost := nil;
    try
      for i := Low(mercados^) to High(mercados^) do begin
        mBrokerComision.Append;
        OIDMercado := mercados^[i].OIDMercado;
        mBrokerComisionOID_MERCADO.Value := OIDMercado;
        mBrokerComisionMERCADO.Value := mercados^[i].Nombre;
        if qBrokerComision.Locate('OR_MERCADO', OIDMercado, []) then begin
          mBrokerComisionENTRADA.Value := qBrokerComisionENTRADA.Value;
          mBrokerComisionENTRADA_MAXIMO.Value := qBrokerComisionENTRADA_MAXIMO.Value;
          mBrokerComisionENTRADA_MINIMO.Value := qBrokerComisionENTRADA_MINIMO.Value;
          mBrokerComisionSALIDA.Value := qBrokerComisionSALIDA.Value;
          mBrokerComisionSALIDA_MAXIMO.Value := qBrokerComisionSALIDA_MAXIMO.Value;
          mBrokerComisionSALIDA_MINIMO.Value := qBrokerComisionSALIDA_MINIMO.Value;
        end;
        mBrokerComision.Post;
      end;
      mBrokerComision.First;
    finally
      mBrokerComision.AfterPost := mBrokerComisionAfterPost;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;

procedure TBrokers.mBrokerComisionAfterPost(DataSet: TDataSet);
var ORBroker, ORMercado: integer;
begin
  ORBroker := qBrokerOID_BROKER.Value;
  ORMercado := mBrokerComisionOID_MERCADO.Value;
  dComision.ParamByName('OR_BROKER').AsInteger := ORBroker;
  dComision.ParamByName('OR_MERCADO').AsInteger := ORMercado;
  ExecQuery(dComision, false);
  iComision.ParamByName('OR_BROKER').AsInteger := ORBroker;
  iComision.ParamByName('OR_MERCADO').AsInteger := ORMercado;
  iComision.ParamByName('ENTRADA').AsString := mBrokerComisionENTRADA.AsString;
  iComision.ParamByName('ENTRADA_MAXIMO').AsString := mBrokerComisionENTRADA_MAXIMO.AsString;
  iComision.ParamByName('ENTRADA_MINIMO').AsString := mBrokerComisionENTRADA_MINIMO.AsString;
  iComision.ParamByName('SALIDA').AsString := mBrokerComisionSALIDA.AsString;
  iComision.ParamByName('SALIDA_MAXIMO').AsString := mBrokerComisionSALIDA_MAXIMO.AsString;
  iComision.ParamByName('SALIDA_MINIMO').AsString := mBrokerComisionSALIDA_MINIMO.AsString;
  ExecQuery(iComision, false);
  BD.IBTransactionUsuario.CommitRetaining;
end;

procedure TBrokers.Pegar;
begin
  mBrokerComision.Edit;
  mBrokerComisionENTRADA.Value := Entrada;
  mBrokerComisionENTRADA_MAXIMO.Value := EntradaMaximo;
  mBrokerComisionENTRADA_MINIMO.Value := EntradaMinimo;
  mBrokerComisionSALIDA.Value := Salida;
  mBrokerComisionSALIDA_MAXIMO.Value := SalidaMaximo;
  mBrokerComisionSALIDA_MINIMO.Value := SalidaMinimo;
  mBrokerComision.Post;
end;

procedure TBrokers.qBrokerAfterScroll(DataSet: TDataSet);
begin
  qBrokerComision.Open;
  LoadBrokerComision;
  qBrokerComision.Close;
end;

procedure TBrokers.qBrokerBeforeScroll(DataSet: TDataSet);
begin
  if mBrokerComision.State in dsEditModes then
    mBrokerComision.Post;
end;

procedure TBrokers.SeleccionarBroker(const OIDBroker: integer);
begin
  qBroker.Locate('OID_BROKER', OIDBroker, []);
end;

end.
