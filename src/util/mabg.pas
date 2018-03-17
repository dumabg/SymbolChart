unit mabg;

interface

uses Tipos, SysUtils;

procedure calcular(const PCambios: PArrayCurrency; const PFechas: PArrayDate);
procedure transformar(PCambios: PArrayCurrency; PFechas: PArrayDate);

implementation

uses DatosGrafico, Classes;

type
  TData = class
    patron: Integer;
    subidas: integer;
    bajadas: integer;
  end;

const
  NUM_CAMBIOS: integer = 6;

procedure calcular(const PCambios: PArrayCurrency; const PFechas: PArrayDate);
var i, j, num: integer;
  cambio: Currency;
  patron: integer;
  salida: TextFile;
  list: TList;
  d: TData;

  function buscar(patron: Integer): TData;
  var i: integer;
    d: TData;
  begin
    for i := 0 to list.Count - 1 do begin
      d := TData(list.Items[i]);
      if (d.patron = patron) then begin
        result := d;
        exit;
      end;
    end;
    result := nil;
  end;

begin
  if not DirectoryExists('T:\mabg') then
    exit;
  num := Length(PCambios^);
  i := 0;
  while PCambios^[i] = SIN_CAMBIO do begin
    inc(i);
  end;
  for j := 0 to NUM_CAMBIOS do begin
    Inc(i);
  end;
  list := TList.Create;
  AssignFile(salida, 'T:\mabg\salida.txt');
  Rewrite(salida);
  dec(num);
  while i < num do begin
    cambio := PCambios^[i];
    patron := 0;
    for j := 1 to NUM_CAMBIOS do begin
//      if cambio > PCambios^[i - j] then begin
      if PCambios^[i - j + 1] > PCambios^[i - j] then begin
        patron := patron or (1 shl (NUM_CAMBIOS - j));
      end;
    end;
    Writeln(salida, DateToStr(PFechas^[i]) + ' ' + IntToStr(patron));
    d := buscar(patron);
    if d = nil then begin
      d := TData.Create;
      d.patron := patron;
      d.subidas := 0;
      d.bajadas := 0;
      list.Add(d);
    end;
    if cambio < PCambios^[i + 1] then
      d.subidas := d.subidas + 1
    else
      d.bajadas := d.bajadas + 1;
    Inc(i);
  end;

  Writeln(salida, '');
  Writeln(salida, '');

  for i := 0 to list.Count - 1 do begin
    d := TData(list[i]);
    Writeln(salida, IntToStr(d.patron) + #9 + IntToStr(d.subidas) + #9 +
      IntToStr(d.bajadas));
  end;

  CloseFile(salida);
end;


procedure transformar(PCambios: PArrayCurrency; PFechas: PArrayDate);
var num, i, j: integer;
  alcista: boolean;
  cambioAnt, cambio: Currency;
begin
  num := Length(PCambios^);
  if num = 0 then
    exit;
  i := 0;
  while PCambios^[i] = SIN_CAMBIO do begin
    inc(i);
  end;

  cambioAnt := PCambios^[i];
  alcista := true;
  inc(i);
  j := 0;
  while i < num do begin
    cambio := PCambios^[i];
    if alcista then begin
      if cambio < cambioAnt then begin
        PCambios^[j] := cambioAnt;
        PFechas^[j] := PFechas^[i];
        inc(j);
        alcista := false;
      end;
    end
    else begin
      if cambio > cambioAnt then begin
        PCambios^[j] := cambioAnt;
        PFechas^[j] := PFechas^[i];
        Inc(j);
        alcista := true;
      end;
    end;
    cambioAnt := cambio;
    inc(i);
  end;
  SetLength(PCambios^, j + 1);
  SetLength(PFechas^, j + 1);
end;

end.
