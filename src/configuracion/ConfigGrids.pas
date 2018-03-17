unit ConfigGrids;

interface

uses DBGrids, Controls;

type
  TConfigGrids = class
  private
    function GetParentOwner(const control: TControl): TControl;
  public
    procedure SaveColumns(const grid: TDBGrid);
    procedure LoadColumns(const grid: TDBGrid);
  end;

implementation

uses dmConfiguracion, SysUtils;

{ TConfigGrids }

function TConfigGrids.GetParentOwner(const control: TControl): TControl;
begin
  if control.Parent = nil then
    result := TControl(control.Owner)
  else
    result := GetParentOwner(control.Parent);
end;

procedure TConfigGrids.LoadColumns(const grid: TDBGrid);
var columns: TDBGridColumns;
  i, num, width: integer;
  column: TColumn;
  nombre: string;
begin
  nombre := GetParentOwner(grid).ClassName;
  columns := grid.Columns;
  num := columns.Count - 1;
  for i := 0 to num do begin
    column := columns[i];
    width := Configuracion.ReadInteger(nombre, grid.Name + '.Column.' + IntToStr(i), -1);
    if width <> -1 then
      column.Width := width;
  end;
end;

procedure TConfigGrids.SaveColumns(const grid: TDBGrid);
var columns: TDBGridColumns;
  i, num: integer;
  column: TColumn;
  nombre: string;
begin
  nombre := GetParentOwner(grid).ClassName;
  columns := grid.Columns;
  num := columns.Count - 1;
  for i := 0 to num do begin
    column := columns[i];
    Configuracion.WriteInteger(nombre, grid.Name + '.Column.' + IntToStr(i), column.Width);
  end;
end;

end.
