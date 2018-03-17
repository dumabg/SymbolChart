unit fmEstadistica;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, dmEstadistica, Grids;

type
  TfEstadistica = class(TfBase)
    grid: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    Estadistica: TEstadistica;
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TfEstadistica.FormCreate(Sender: TObject);
var i, desde, hasta: integer;
  Dato: TDato;

  procedure Pintar(const x, y: Integer; const valor: integer); 
  begin
    if valor > 0 then
      grid.Cells[x, y] := IntToStr(valor);
  end;
begin
  inherited;
  Estadistica := TEstadistica.Create(Self);
  grid.Cells[0, 0] := '';
  grid.Cells[1, 0] := '+0%';
  grid.Cells[2, 0] := '+1%';
  grid.Cells[3, 0] := '+2%';
  grid.Cells[4, 0] := '+3%';
  grid.Cells[5, 0] := '+%';
  grid.Cells[6, 0] := '-0%';
  grid.Cells[7, 0] := '-1%';
  grid.Cells[8, 0] := '-2%';
  grid.Cells[9, 0] := '-3%';
  grid.Cells[10, 0] := '-%';
  hasta := High(Estadistica.Datos) + 1;
  grid.RowCount := hasta + 1;
  for i := 1 to hasta do begin
    Dato := Estadistica.Datos[i - 1];
    grid.Cells[0, i] := CurrToStr(Dato.Dinero) + ' - ' + CurrToStr(Dato.Papel) + ' - ' +
      IntToStr(Dato.Zona);
    Pintar(1, i, Dato.Mas_0);
    Pintar(2, i, Dato.Mas_1);
    Pintar(3, i, Dato.Mas_2);
    Pintar(4, i, Dato.Mas_3);
    Pintar(5, i, Dato.Mas);
    Pintar(6, i, Dato.Menos_0);
    Pintar(7, i, Dato.Menos_1);
    Pintar(8, i, Dato.Menos_2);
    Pintar(9, i, Dato.Menos_3);
    Pintar(10, i, Dato.Menos);
  end;
end;

end.
