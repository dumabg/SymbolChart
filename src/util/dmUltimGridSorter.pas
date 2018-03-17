unit dmUltimGridSorter;

interface

uses
  SysUtils, Classes, kbmMemTable, JvDBUltimGrid, dmDataSetSelector;

type
  TUltimGridSorter = class(TDataSetSelector)
  private
    { Private declarations }
  public
    procedure Sort(const Data: TKbmMemTable; const FieldsToSort: TSortFields);
  end;


implementation

{$R *.dfm}

uses DB;

{ TUltimGridSorter }

procedure TUltimGridSorter.Sort(const Data: TKbmMemTable;
  const FieldsToSort: TSortFields);
var indexName, fields, descFields: string;
  index: TIndexDef;
  i: integer;
begin
  indexName := '';
  for i := Low(FieldsToSort) to High(FieldsToSort) do begin
    indexName := indexName + FieldsToSort[i].Name + '-';
    if FieldsToSort[i].Order then
      indexName := indexName + 'A-';
  end;
  try
    Data.IndexDefs.Find(indexName);
  except
    on EDatabaseError do begin //No se ha encontrado el indice
      index := Data.IndexDefs.AddIndexDef;
      index.Name := indexName;
      fields := '';
      descFields := '';
      for i := Low(FieldsToSort) to High(FieldsToSort) do begin
        fields := fields + FieldsToSort[i].Name;
        if not FieldsToSort[i].Order then begin
          if descFields <> '' then
            descFields := descFields + ';';
          descFields := descFields + FieldsToSort[i].Name;
        end;
        if i < High(FieldsToSort) then
          fields := fields + ';'
      end;
      index.Fields := fields;
      index.DescFields := descFields;
    end;
  end;
  Data.IndexName := indexName;
end;

end.
