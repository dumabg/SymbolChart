unit UtilGrid;

interface

uses
  SysUtils, Classes, ActnList, Menus, TB2Item, JvDBGrid, 
  kbmMemTable, JvDBUltimGrid, SpTBXItem, dmThreadDataModule, Dialogs;

type
  TUtilGridColumnasVisibles = class(TThreadDataModule)
    GridPopup: TSpTBXPopupMenu;
    ActionList: TActionList;
    AutoSize: TAction;
    SeleccionarCol: TAction;
    RestaurarCol: TAction;
    TBXItem1: TSpTBXItem;
    TBXItem2: TSpTBXItem;
    TBXItem3: TSpTBXItem;
    TBXSeparatorItem1: TSpTBXSeparatorItem;
    procedure AutoSizeExecute(Sender: TObject);
    procedure SeleccionarColExecute(Sender: TObject);
    procedure RestaurarColExecute(Sender: TObject);
    procedure GridPopupPopup(Sender: TObject);
  private
    FGrid: TJvDBGrid;
    ColWidths: array of integer;
  public
    constructor Create(Grid: TJvDBGrid); reintroduce;
  end;

  TUtilGridSort = class(TComponent)
  private
    Grid: TJvDBUltimGrid;
    procedure GridUserSort(Sender: TJvDBUltimGrid;
      var FieldsToSort: TSortFields; SortString: string; var SortOK: Boolean);
  public
    constructor Create(aGrid: TJvDBUltimGrid); reintroduce;
  end;

  TUtilGridCSV = class(TComponent)
  private
    Grid: TJvDBUltimGrid;
    FDefaultFileName: string;
    procedure ExportarClick(Sender: TObject);
  public
    constructor Create(aGrid: TJvDBUltimGrid); reintroduce;
    procedure CreatePopupItem;
    function Exportar: boolean;
    property DefaultFileName: string read FDefaultFileName write FDefaultFileName;
  end;

implementation

{$R *.dfm}

uses Windows, UtilDB, DB;

resourcestring
  SELECT_COL_CAPTION = 'Seleccionar columnas visibles';
  SELECT_COL_NO_SELECTION = 'Por lo menos debe haber una columna visible';
  SELECT_COL_OK = '&Aceptar';

  CAPTION_CSV = 'Exportar a CSV';

procedure TUtilGridColumnasVisibles.AutoSizeExecute(Sender: TObject);
var i: integer;
begin
  AutoSize.Checked := not AutoSize.Checked;
  FGrid.AutoSizeColumns := AutoSize.Checked;
  // Si se está en una columna en la cual se ha hecho scroll a la derecha porque
  // no se veia, al cambiar al autosize pinta mal. Se debe mover la posición a
  // la primera celda para que repinte bien.
  i := FGrid.Col;
  FGrid.Col := 0;
  FGrid.Col := i;
end;

constructor TUtilGridColumnasVisibles.Create(Grid: TJvDBGrid);
var i, num: integer;
begin
  inherited Create(Grid);
  FGrid := Grid;
  FGrid.PopupMenu := GridPopUp;
  num := FGrid.Columns.Count;
  SetLength(ColWidths, num);
  dec(num);
  for i := 0 to num do
    ColWidths[i] := FGrid.Columns[i].Width;
end;

procedure TUtilGridColumnasVisibles.GridPopupPopup(Sender: TObject);
begin
  FGrid := (Sender as TSpTBXPopupMenu).PopupComponent as TJvDBGrid;
end;

procedure TUtilGridColumnasVisibles.RestaurarColExecute(Sender: TObject);
var i, num: integer;
begin
  if AutoSize.Checked then
    AutoSizeExecute(nil);
  num := FGrid.Columns.Count - 1;
  for i := 0 to num do
    FGrid.Columns[i].Width := ColWidths[i];
end;

procedure TUtilGridColumnasVisibles.SeleccionarColExecute(Sender: TObject);
begin
  FGrid.SelectColumnsDialogStrings.Caption := SELECT_COL_CAPTION;
  FGrid.SelectColumnsDialogStrings.NoSelectionWarning := SELECT_COL_NO_SELECTION;
  FGrid.SelectColumnsDialogStrings.OK := SELECT_COL_OK;
  FGrid.SelectColumn := scGrid;
  FGrid.ShowColumnsDialog;
  // Por si está el autosize activado.
  AutoSize.Checked := not AutoSize.Checked;
  AutoSizeExecute(nil);
end;

{ TUtilGridSort }

constructor TUtilGridSort.Create(aGrid: TJvDBUltimGrid);
begin
  inherited Create(aGrid);
  Grid := aGrid;
  Grid.OnUserSort := GridUserSort;
  Grid.SortWith := swUserFunc;
  Grid.TitleButtons := true;
end;

procedure TUtilGridSort.GridUserSort(Sender: TJvDBUltimGrid;
  var FieldsToSort: TSortFields; SortString: string; var SortOK: Boolean);
var data: TkbmMemTable;
   i, num: integer;
   sortCad: string;

// Build field list from list of fieldnames.
// fld1;fld2;fld3...
// Each field can contain options:
// fldname:options
// Options can be either C for Caseinsensitive or D for descending or a combination.
//procedure TkbmCustomMemTable.BuildFieldList(Dataset:TDataset; List:TkbmFieldList; const FieldNames:string);
//               if pos('C',sopt)>0 then Include(opt,mtifoCaseInsensitive);
//               if pos('D',sopt)>0 then Include(opt,mtifoDescending);
//               if pos('N',sopt)>0 then Include(opt,mtifoIgnoreNull);
//               if pos('P',sopt)>0 then Include(opt,mtifoPartial);
//               if pos('L',sopt)>0 then Include(opt,mtifoIgnoreLocale);
begin
  sortCad := '';
  num := length(FieldsToSort) - 1;
  for i := 0 to  num do begin
    sortCad := sortCad + FieldsToSort[i].Name;
    if not FieldsToSort[i].Order then
       sortCad := sortCad + ':D';
    if i <> num then
      sortCad := sortCad + ';';
  end;
  data := Grid.DataSource.DataSet as TkbmMemTable;
  // Siempre se ordena con insensitive
  data.SortOn(sortCad, [mtcoCaseInsensitive]);
  SortOK := true;
end;

{ TUtilGridCSV }

constructor TUtilGridCSV.Create(aGrid: TJvDBUltimGrid);
begin
  inherited Create(aGrid);
  Grid := aGrid;
end;

procedure TUtilGridCSV.CreatePopupItem;
var menu: TPopupMenu;
  menuItem: TMenuItem;
begin
  menu := Grid.PopupMenu;
  if menu = nil then begin
    menu := TPopupMenu.Create(Grid.Owner);
    Grid.PopupMenu := menu;
  end;
  menuItem := menu.CreateMenuItem;
  menuItem.Caption := CAPTION_CSV;
  menuItem.OnClick := ExportarClick;
  menu.Items.Add(menuItem);
end;

function TUtilGridCSV.Exportar: boolean;
var saveDlg: TSaveDialog;
  i, num: Integer;
  f: TextFile;
  inspect: TInspectDataSet;
  dataSet: TDataSet;
  field: TField;
begin
  Result := false;
  saveDlg := TSaveDialog.Create(nil);
  try
    saveDlg.FileName := FDefaultFileName;
    saveDlg.DefaultExt := 'csv';
    saveDlg.Filter := 'csv|*.csv|Todos|*.*';
    saveDlg.Options := [ofPathMustExist, ofOverwritePrompt];
    if saveDlg.Execute then begin
      AssignFile(f, saveDlg.FileName);
      try
        Rewrite(f);
        num := Grid.Columns.Count - 1;
        for i := 0 to num do begin
          Write(f, Grid.Columns.Items[i].Title.Caption);
          if i = num then
            Write(f, sLineBreak)
          else
            Write(f, ',');
        end;
        dataSet := Grid.DataSource.DataSet;
        inspect := StartInspectDataSet(dataSet);
        try
          dataSet.First;
          while not dataSet.Eof do begin
            for i := 0 to num do begin
              field := Grid.Columns.Items[i].Field;
              Write(f, '"');
              Write(f, field.AsString);
              Write(f, '"');
              if i = num then
                Write(f, sLineBreak)
              else
                Write(f, ',');
            end;
            dataSet.Next;
          end;
        finally
          EndInspectDataSet(inspect);
        end;
      finally
        CloseFile(f);
      end;
      Result := true;
    end;
  finally
    saveDlg.Free;
  end;
end;

procedure TUtilGridCSV.ExportarClick(Sender: TObject);
begin
  Exportar;
end;

end.
