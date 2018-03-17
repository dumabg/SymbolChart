unit UtilString;

interface

uses Classes;

  procedure Split(const Delimiter: Char; const Input: string; const Destination: TStrings);
  function FormatCurr(const Curr: currency): string;
  function CreateName(const seed: string): string;
  procedure ReplaceLastChar(var s: string; const oldChar, newChar: char);

implementation

uses SysUtils, StrUtils;

procedure ReplaceLastChar(var s: string; const oldChar, newChar: char);
var i: Integer;
begin
  for i := length(s) downto 1 do begin
    if s[i] = oldChar then begin
      s[i] := newChar;
      exit;
    end;
  end;
end;

function CreateName(const seed: string): string;
var i, num, count: integer;
  c: char;
begin
  num := length(seed);
  SetLength(result, num);
  count := 0;
  for i := 1 to num do begin
    c := seed[i];
    if c in ['A'..'Z', 'a'..'z'] then begin
      inc(count);
      result[count] := c;      
    end;
  end;
  SetLength(result, count);
end;

function FormatCurr(const Curr: currency): string;
begin
  result := FloatToStrF(Curr, ffCurrency, 10, CurrencyDecimals);
end;

procedure Split(const Delimiter: Char; const Input: string; const Destination: TStrings);
  var i, j: integer;
    cad: string;
  begin
     Assert(Assigned(Destination));
     Destination.Clear;
     i := 1;
     j := Pos(Delimiter, Input);
     if j = 0 then begin
      cad := Input;
      if cad <> '' then
        Destination.Add(cad);
     end
     else begin
       repeat
          cad := Copy(Input, i, j - i);
          if cad <> '' then
            Destination.Add(cad);
          i := j + 1;
          j := PosEx(Delimiter, Input, i);
       until j = 0;
       if i < length(Input) then begin
         cad := Copy(Input, i, length(Input));
         Destination.Add(cad);
       end;
     end;
  end;


end.
