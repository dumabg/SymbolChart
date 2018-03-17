unit UtilDB;

interface
uses SysUtils, DB, IBSQL, IBQuery, IBDatabase, kbmMemTable, Contnrs;

type
  TDataSetEvents = array of TDataSetNotifyEvent;

  TInspectDataSet = record
    events: TDataSetEvents;
    bookmark: Pointer;
    dataSet: TDataSet;
  end;


  TAttachObjectDataset = class
  private
    DataSet: TDataSet;
    objects: array of TObject;
  public
    constructor Create(const DataSet: TDataSet);
    procedure Refresh;
    procedure Attach(const obj: TObject; const FreeIfExist: boolean = true);
    function Detach: TObject;
    procedure DetachAndFree;
    function Get: TObject;
  end;

  TInspectDataSets = array of TInspectDataSet;

  EQueryException = class(Exception);

  TAssignParams = class
  private
    paramSrc: array of TIBXSQLVAR;
    fieldDest: array of TField;
  public
    constructor Create(const src: TDataSet; const dest: TIBSQL);
    destructor Destroy; override;
    procedure Assign;
  end;

  TOIDGenerator = class
  private
    q: TIBSQL;
  public
    constructor Create(const database: TIBDatabase; const tableName, OIDColumnName: string); overload;
    constructor Create(const database: TIBDatabase; const tableName: string); overload;
    destructor Destroy; override;
    function NextOID: integer;
    function LastOID: integer;
  end;

  function ExisteRegistro(const DataSet: TDataSet; const KeyFields: string;
    const KeyValues: Variant): boolean; overload;
  function ExisteRegistro(const Field: TField; const KeyValues: Variant): boolean; overload;

  function Locate(const DataSet: TDataSet; const KeyFields: string;
    const KeyValues: Variant; Options: TLocateOptions): Boolean;

  // Ver TAssignParams
  procedure AssignParams(const src: TDataSet; const dest: TIBSQL);
  procedure AssignParamsField(const Param: TIBXSQLVar; const Field: TField); inline;
  procedure AssignFields(const FieldSrc: TField; const FieldDest: TField); inline;

  //Activa o desactiva los eventos de un dataset
  function DisableEventsDataSet(const DataSet: TDataSet;
    const DoBeforeScroll: boolean = false): TDataSetEvents;
  procedure EnableEventsDataSet(const DataSet: TDataSet;
    const events: TDataSetEvents; const DoAfterScroll: boolean = false);

  //Al realizar Start desactiva los eventos de un dataset y guarda la posición del cursor.
  function StartInspectDataSet(const DataSet: TDataSet): TInspectDataSet;
  function StartInspectDataSets(const DataSets: array of TDataSet): TInspectDataSets;
  //Al realizar End posiciona el cursor en la posición guardada y activa los eventos.
  procedure EndInspectDataSet(const inspect: TInspectDataSet);
  procedure EndInspectDataSets(const inspect: TInspectDataSets);

  procedure Post(const IBQuery: TIBQuery; const commit: boolean);
  procedure Delete(const IBQuery: TIBQuery; const commit: boolean);
  procedure ExecQuery(const IBSQL: TIBSQL; const commit: boolean);
  procedure OpenDataSet(const DataSet: TDataSet);
  procedure OpenDataSetRecordCount(const DataSet: TDataSet);
  procedure OpenDatabase(const database: TIBDatabase);
  procedure CloseDatabase(const database: TIBDatabase);

  function ExisteTabla(const database: TIBDatabase; const tableName: string): boolean;

  procedure LoadIBSQLtoMemtable(const IBSQL: TIBSQL; const MemTable: TkbmMemTable);

//  procedure CreateNewDBTransactions(const dataModule: TDataModule);


implementation

uses Variants, Base64;

  function GetExceptionMsgIBSQL(const e: Exception; const IBSQL: TIBSQL): string;
  var i, num: integer;
  begin
    result := ExtractFileName(IBSQL.Database.DatabaseName) + sLineBreak +
     e.ClassName + sLineBreak + e.Message;
    if IBSQL.Owner <> nil then
      result := result + sLineBreak + IBSQL.Owner.Name;
    result := result + sLineBreak + IBSQL.Name + sLineBreak + IBSQL.SQL.Text + sLineBreak;
    try
      num := IBSQL.Params.Count - 1;
      for i := 0 to num do
        result := result + IntToStr(i) + ' = ' + IBSQL.Params[i].AsString + sLineBreak;
    except
      on e: Exception do;
    end;
  end;

  function GetExceptionMsgIBQuery(const e: Exception; const IBQuery: TIBQuery): string;
  var i, num: integer;
  begin
    result := ExtractFileName(IBQuery.Database.DatabaseName) + sLineBreak +
     e.ClassName + sLineBreak + e.Message;
    if IBQuery.Owner <> nil then
      result := result + sLineBreak + IBQuery.Owner.Name;
    result := result + sLineBreak + IBQuery.Name + sLineBreak + IBQuery.SQL.Text + sLineBreak;
    try
      num := IBQuery.Params.Count - 1;
      for i := 0 to num do
        result := result + IntToStr(i) + ' = ' + IBQuery.Params[i].AsString + sLineBreak;
    except
      on e: Exception do;
    end;
  end;


  procedure LoadIBSQLtoMemtable(const IBSQL: TIBSQL; const MemTable: TkbmMemTable);
  var i, numFieldsIBSQL: integer;
    iMemtableFields: array of integer;
    inspect: TInspectDataSet;
  begin
    inspect := StartInspectDataSet(Memtable);
    try
      //Buscar los fields de IBSQL donde estan en MemTable
      numFieldsIBSQL := IBSQL.FieldCount;
      SetLength(iMemtableFields, numFieldsIBSQL);
      dec(numFieldsIBSQL); //zero based
      for i := 0 to numFieldsIBSQL do
        iMemtableFields[i] := Memtable.FindField(IBSQL.Fields[i].Name).Index;

      while not IBSQL.Eof do begin
        Memtable.Append;
        for i := 0 to numFieldsIBSQL do
          Memtable.Fields[iMemtableFields[i]].Value := IBSQL.Fields[i].Value;
        IBSQL.Next;
        Memtable.Post;
      end;
    finally
      EndInspectDataSet(inspect);
    end;
  end;


  function ExisteTabla(const database: TIBDatabase; const tableName: string): boolean;
  var q: TIBQuery;
  begin
    q := TIBQuery.Create(nil);
    try
      q.Database := database;
      q.SQL.Text := 'SELECT 1 FROM ' + tableName;
      try
        q.Open;
        result := true;
      except
        result := false;
      end;
    finally
      try
        q.Close;
      finally
        q.Free;
      end;
    end;
  end;

  procedure CloseDatabase(const database: TIBDatabase);
  begin
    database.Close;
    // Necesario borrar los params de la database, ya que al hacer de nuevo un
    // OpenDatabase, se volverán a configurar
    database.Params.Clear;
  end;

  procedure OpenDatabase(const database: TIBDatabase);
  var s, s2: string;
    i: integer;

    // Seguridad en usuario y password
    function getThis(const u: boolean): string;
    begin
      if u then  // Se pide usuario --> user_name=sysdba
        // En Base 64: dXNlcl9uYW1lPXN5c2RiYQ==
        // En las posiciones pares se ponen valores aleatorios y el == final se quita
        result := 'd,X1Nnlacel495uhYyWy1ylaPsXeNw5ech2bRzidYsQÑ'
      else  // Se pide el password --> password=00masterkey00
        // En Base 64: cGFzc3dvcmQ9MDBtYXN0ZXJrZXkwMA==
        // En las posiciones pares se ponen valores aleatorios y el == final se quita
        result := 'c1GqFpzoca3sddvrctmvQ192M8D8B8tmY.XkNl0ñZaX-J:rsZeX5k%waMdA,';
    end;

  begin
    database.Params.Clear;
    database.LoginPrompt := false;
    s := getThis(true);
    for i := 1 to length(s) do begin
      if (i mod 2 = 1) then
        s2 := s2 + s[i];
    end;
    database.Params.Add(Base64ToStr(s2 + '=='));
    s2 := '';
    s := getThis(false);
    for i := 1 to length(s) do begin
      if (i mod 2 = 1) then
        s2 := s2 + s[i];
    end;
    database.Params.Add(Base64ToStr(s2 + '=='));
    database.Open;
  end;

  procedure OpenDataSetRecordCount(const DataSet: TDataSet);
  begin
    OpenDataSet(DataSet);
    // Si se hace last, se cargan todos los datos y el recordcount es correcto
    // sino siempre devuelve 1.
    DataSet.Last;
    DataSet.First;
  end;

  procedure OpenDataSet(const DataSet: TDataSet);
  var msg: string;
  begin
    try
      if DataSet.Active then
        DataSet.Close;
      DataSet.Open;
    except
      on e: Exception do begin
        msg := e.ClassName + sLineBreak + e.Message;
        if DataSet.Owner <> nil then
          msg := msg + sLineBreak + DataSet.Owner.Name;
        msg := msg + sLineBreak + DataSet.Name;
        raise EQueryException.Create(msg);
      end;
    end;
  end;

  procedure Delete(const IBQuery: TIBQuery; const commit: boolean);
  var transaction: TIBTransaction;
  begin
    transaction := IBQuery.Database.DefaultTransaction;
    if not transaction.InTransaction then
      transaction.StartTransaction;
    try
      IBQuery.Delete;
      if commit then
        transaction.CommitRetaining;
    except
      on e: Exception do begin
        if commit then
          transaction.RollbackRetaining;
        raise EQueryException.Create(GetExceptionMsgIBQuery(e, IBQuery));
      end;
    end;
  end;

  procedure Post(const IBQuery: TIBQuery; const commit: boolean);
  var transaction: TIBTransaction;
  begin
    transaction := IBQuery.Database.DefaultTransaction;
    if not transaction.InTransaction then
      transaction.StartTransaction;
    try
      IBQuery.Post;
      if commit then
        transaction.CommitRetaining;
    except
      on e: Exception do begin
        if commit then
          transaction.RollbackRetaining;
        raise EQueryException.Create(GetExceptionMsgIBQuery(e, IBQuery));
      end;
    end;
  end;

  procedure ExecQuery(const IBSQL: TIBSQL; const commit: boolean);
  var transaction: TIBTransaction;
  begin
    transaction := IBSQL.Transaction;
    if not transaction.InTransaction then
      transaction.StartTransaction;
    try
      IBSQL.ExecQuery;
      if commit then
        transaction.CommitRetaining;
    except
      on e: Exception do begin
        if commit then
          transaction.RollbackRetaining;
        raise EQueryException.Create(GetExceptionMsgIBSQL(e, IBSQL));
      end;
    end;
  end;

  procedure AssignParams(const src: TDataSet; const dest: TIBSQL);
  var i, num: integer;
    param: TIBXSQLVAR;
    field: TField;
  begin
    num := dest.Params.Count - 1;
    for i := 0 to num do begin
      param := dest.Params[i];
      field := src.FindField(param.Name);
      if field <> nil then
        AssignParamsField(param, field);
    end;
  end;

  procedure AssignFields(const FieldSrc: TField; const FieldDest: TField);
  begin
    if FieldSrc.IsNull then
      FieldDest.Clear
    else
      FieldDest.Value := FieldSrc.Value;
  end;

  procedure AssignParamsField(const Param: TIBXSQLVar; const Field: TField);
  begin
    if Field.IsNull then
      Param.Clear
    else
      Param.Value := Field.Value;
  end;


  function DisableEventsDataSet(const DataSet: TDataSet;
    const DoBeforeScroll: boolean): TDataSetEvents;
  begin
    if (DoBeforeScroll) and (Assigned(DataSet.BeforeScroll)) then
      DataSet.BeforeScroll(DataSet);
    SetLength(result, 2);
    result[0] := DataSet.BeforeScroll;
    result[1] := DataSet.AfterScroll;
    DataSet.BeforeScroll := nil;
    DataSet.AfterScroll := nil;
    DataSet.DisableControls;
  end;

  procedure EnableEventsDataSet(const DataSet: TDataSet; const events: TDataSetEvents;
    const DoAfterScroll: boolean);
  begin
    DataSet.BeforeScroll := events[0];
    DataSet.AfterScroll := events[1];
    DataSet.EnableControls;
    if (DoAfterScroll) and (Assigned(DataSet.AfterScroll)) then
      DataSet.AfterScroll(DataSet);
  end;


  function Locate(const DataSet: TDataSet; const KeyFields: string;
    const KeyValues: Variant; Options: TLocateOptions): Boolean;
  var events: TDataSetEvents;
  begin
    if Assigned(DataSet.BeforeScroll) then
      DataSet.BeforeScroll(DataSet);
    events := DisableEventsDataSet(DataSet);
    try
      result := DataSet.Locate(KeyFields, KeyValues, Options);
    finally
      EnableEventsDataSet(DataSet, events, true);
    end;
  end;

  function ExisteRegistro(const Field: TField; const KeyValues: Variant): boolean;
  begin
    result := ExisteRegistro(Field.DataSet, Field.FieldName, KeyValues);
  end;

  function ExisteRegistro(const DataSet: TDataSet; const KeyFields: string;
    const KeyValues: Variant): boolean;
  var data: Variant;
  begin
    data := DataSet.LookUp(KeyFields, KeyValues, KeyFields);
    result := not VarIsEmpty(data);
  end;

  function StartInspectDataSet(const DataSet: TDataSet): TInspectDataSet;
  begin
    result.DataSet := DataSet;
    result.bookmark := DataSet.GetBookmark;
    result.events := DisableEventsDataSet(DataSet);
  end;

  function StartInspectDataSets(const DataSets: array of TDataSet): TInspectDataSets;
  var i: integer;
  begin
    SetLength(result, length(DataSets));
    for i := Low(DataSets) to High(DataSets) do begin
       result[i] := StartInspectDataSet(DataSets[i]);
    end;
  end;

  procedure EndInspectDataSet(const inspect: TInspectDataSet);
  var DataSet: TDataSet;
    bookmark: Pointer;
  begin
    DataSet := inspect.DataSet;
    bookmark := inspect.bookmark;
    if (bookmark <> nil) and (DataSet.BookmarkValid(bookmark)) then begin
      try
        DataSet.GotoBookmark(bookmark);
      except
      end;
    end;
    DataSet.FreeBookmark(bookmark);
    EnableEventsDataSet(DataSet, inspect.events);
  end;

  procedure EndInspectDataSets(const inspect: TInspectDataSets);
  var i: integer;
  begin
    for i := Low(inspect) to High(inspect) do begin
      EndInspectDataSet(inspect[i]);
    end;
  end;


{ TAttachObjectDataset }

procedure TAttachObjectDataset.Attach(const obj: TObject; const FreeIfExist: boolean);
var i: integer;
begin
  i := DataSet.RecNo - 1;
  if FreeIfExist then
    Get.Free;
  objects[i] := obj;
end;

constructor TAttachObjectDataset.Create(const DataSet: TDataSet);
begin
  Self.DataSet := DataSet;
  Refresh;
end;

function TAttachObjectDataset.Detach: TObject;
var i: integer;
begin
  i := DataSet.RecNo - 1;
  result := objects[i];
  objects[i] := nil;
end;

procedure TAttachObjectDataset.DetachAndFree;
begin
  Detach.Free;
end;

function TAttachObjectDataset.Get: TObject;
var i: integer;
begin
  i := DataSet.RecNo - 1;
  result := objects[i];
end;

procedure TAttachObjectDataset.Refresh;
var inspect: TInspectDataSet;
  i: integer;
begin
  for i := 0 to High(objects) - 1 do
    if objects[i] <> nil then
      FreeAndNil(objects[i]);
  inspect := StartInspectDataSet(DataSet);
  try
    DataSet.Last;
    SetLength(objects, DataSet.RecordCount);
    for i := 0 to High(objects) - 1 do
      objects[i] := nil;
  finally
    EndInspectDataSet(inspect);
  end;
end;

{ TAssignParams }

procedure TAssignParams.Assign;
var i: integer;
begin
  for i := Low(paramSrc) to High(paramSrc) do
    AssignParamsField(paramSrc[i], fieldDest[i]);
end;

constructor TAssignParams.Create(const src: TDataSet; const dest: TIBSQL);
var i, num, total: integer;
  param: TIBXSQLVAR;
  field: TField;
begin
  inherited Create;
  num := dest.Params.Count;
  SetLength(paramSrc, num);
  SetLength(fieldDest, num);
  total := 0;
  for i := 0 to num - 1 do begin
    param := dest.Params[i];
    field := src.FindField(param.Name);
    if field <> nil then begin
      paramSrc[total] := param;
      fieldDest[total] := field;
      inc(total);
    end;
  end;
  if total <> num then begin
    SetLength(paramSrc, total);
    SetLength(fieldDest, total);
  end;
end;

destructor TAssignParams.Destroy;
begin
  paramSrc := nil;
  fieldDest := nil;
  inherited Destroy;
end;

{ TOIDGenerator }

constructor TOIDGenerator.Create(const database: TIBDatabase;
  const tableName: string);
begin
  Create(database, tableName, 'OID_' + tableName);
end;

constructor TOIDGenerator.Create(const database: TIBDatabase; const tableName,
  OIDColumnName: string);
begin
  inherited Create;
  q := TIBSQL.Create(nil);
  q.Database := database;
  q.SQL.Text := 'select MAX(' + OIDColumnName + ') from ' + tableName;
end;

destructor TOIDGenerator.Destroy;
begin
  q.Free;
  inherited;
end;

function TOIDGenerator.LastOID: integer;
begin
  q.ExecQuery;
  try
    result := q.Fields[0].AsInteger;
  finally
    q.Close;
  end;
end;

function TOIDGenerator.NextOID: integer;
begin
  result := LastOID + 1;
end;


end.
