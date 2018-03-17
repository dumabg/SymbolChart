unit dmDataSetSelector;

interface

uses
  SysUtils, Classes, DBGrids, DB, dmThreadDataModule;

type
  TDataSetSelector = class(TThreadDataModule)
  private
    FDefaultField: TBooleanField;
  public
    procedure SeleccionarTodos(const filas: TBookmarkList = nil; Field: TBooleanField = nil);
    procedure SeleccionarNinguno(const filas: TBookmarkList = nil; Field: TBooleanField = nil);
    procedure SeleccionarInverso(const filas: TBookmarkList = nil; Field: TBooleanField = nil);
    procedure SeleccionarCampo(const valor: string; const CampoField: TField; Field: TBooleanField = nil);
    property DefaultField: TBooleanField read FDefaultField write FDefaultField;
  end;

implementation

{$R *.dfm}

uses UtilDB;

{ TDataSetSelector }

procedure TDataSetSelector.SeleccionarCampo(const valor: string;
  const CampoField: TField; Field: TBooleanField);
var inspect: TInspectDataSet;
  DataSet: TDataSet;
begin
  if Field = nil then
    Field := FDefaultField;
  DataSet := Field.DataSet;
  inspect := StartInspectDataSet(DataSet);
  try
    DataSet.First;
    while not DataSet.Eof do begin
      DataSet.Edit;
      Field.Value := CampoField.AsString = valor;
      DataSet.Post;
      DataSet.Next;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;

procedure TDataSetSelector.SeleccionarInverso(
  const filas: TBookmarkList; Field: TBooleanField);
var inspect: TInspectDataSet;
  DataSet: TDataSet;
  i: integer;
    procedure Apply;
    begin
      DataSet.Edit;
      Field.Value := not Field.Value;
      DataSet.Post;
    end;
begin
  if Field = nil then
    Field := FDefaultField;
  DataSet := Field.DataSet;
  inspect := StartInspectDataSet(DataSet);
  try
    if (filas = nil) or (filas.Count <= 1) then begin
      DataSet.First;
      while not DataSet.Eof do begin
        Apply;
        DataSet.Next;
      end;
    end
    else begin
      for I := 0 to filas.Count - 1 do begin
        DataSet.Bookmark := filas[i];
        Apply;
      end;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;

procedure TDataSetSelector.SeleccionarNinguno(
  const filas: TBookmarkList; Field: TBooleanField);
var inspect: TInspectDataSet;
  DataSet: TDataSet;
  i, num: integer;

    procedure Apply;
    begin
      DataSet.Edit;
      Field.Value := false;
      DataSet.Post;
    end;
begin
  if Field = nil then
    Field := FDefaultField;
  DataSet := Field.DataSet;
  inspect := StartInspectDataSet(DataSet);
  try
    if (filas = nil) or (filas.Count <= 1) then begin
      DataSet.First;
      while not DataSet.Eof do begin
        num := DataSet.RecordCount;
        Apply;
        if DataSet.RecordCount = num then
          DataSet.Next;
      end;
    end
    else begin
      for I := 0 to filas.Count - 1 do begin
        DataSet.Bookmark := filas[i];
        Apply;
      end;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;

procedure TDataSetSelector.SeleccionarTodos(
  const filas: TBookmarkList; Field: TBooleanField);
var inspect: TInspectDataSet;
  DataSet: TDataSet;
  i: integer;

    procedure Apply;
    begin
      DataSet.Edit;
      Field.Value := true;
      DataSet.Post;
    end;
begin
  if Field = nil then
    Field := FDefaultField;
  DataSet := Field.DataSet;
  inspect := StartInspectDataSet(DataSet);
  try
    DataSet.First;
    if (filas = nil) or (filas.Count <= 1) then begin
      DataSet.First;
      while not DataSet.Eof do begin
        Apply;
        DataSet.Next;
      end;
    end
    else begin
      for I := 0 to filas.Count - 1 do begin
        DataSet.Bookmark := filas[i];
        Apply;
      end;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;

end.
