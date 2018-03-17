unit UtilColors;

interface

uses Graphics;

type
  TRGB = record
    B: byte;
    G: byte;
    R: byte;
  end;

  THLS = record
    H: byte;
    L: byte;
    S: byte;
  end;

  function RGBToHLS(PRGB: TRGB): THLS;
  function HLSToRGB(PHLS: THLS): TRGB;
  function RGBToColor(PR, PG, PB: Integer): TColor; overload;
  function RGBToColor(PRGB: TRGB): TColor; overload;
  function ColorToRGB(PColor: TColor): TRGB;
  function ColorToHLS(Color: TColor): THLS;
  function HLSToColor(HLS: THLS): TColor;
  function IncreaseColor(color: TColor): TColor;

implementation


function max3(P1, P2, P3: byte): byte;
begin
  if (P1 > P2) then
  begin
    if (P1 > P3) then
    begin
      Result := P1;
    end
    else
    begin
      Result := P3;
    end;
  end
  else if P2 > P3 then
  begin
    result := P2;
  end
  else
    result := P3;
end;

function min3(P1, P2, P3: byte): byte;
begin
  if (P1 < P2) then
  begin
    if (P1 < P3) then
    begin
      Result := P1;
    end
    else
    begin
      Result := P3;
    end;
  end
  else if P2 < P3 then
  begin
    result := P2;
  end
  else
    result := P3;
end;

function RGBToHLS(PRGB: TRGB): THLS;
var
  LR, LG, LB, LMin, LMax, LDif: byte;
  LH, LL, LS, LSum: integer;
begin
  LR := PRGB.R;
  LG := PRGB.G;
  LB := PRGB.B;
  LMin := min3(LR, LG, LB);
  LMax := max3(LR, LG, LB);
  LDif := LMax - LMin;
  LSum := LMax + LMin;
  LL := LSum shr 1;
  if LMin = LMax then
  begin
    LH := 0;
    LS := 0;
    Result.H := LH;
    Result.L := LL;
    Result.S := LS;
    exit;
  end;
  if LL < 128 then
    LS := LDif shl 8 div LSum
  else
    LS := LDif shl 8 div (512 - LSum);
  if LS > 255 then
    LS := 255;
  if LR = LMax then
    LH := (LG - LB) shl 8 div LDif
  else if LG = LMax then
    LH := 512 + (LB - LR) shl 8 div LDif
  else
    LH := 1024 + (LR - LG) shl 8 div LDif;
  Result.H := LH div 6;
  Result.L := LL;
  Result.S := LS;
end;

function HLSToRGB(PHLS: THLS): TRGB;
var
  LH, LL, LS: byte;
  LR, LG, LB, L1, L2, LDif, L6Dif: integer;
begin
  LH := PHLS.H;
  LL := PHLS.L;
  LS := PHLS.S;
  if LS = 0 then
  begin
    Result.R := LL;
    Result.G := LL;
    Result.B := LL;
    Exit;
  end;
  if LL < 128 then
    L2 := LL * (256 + LS) shr 8
  else
    L2 := LL + LS - LL * LS shr 8;
  L1 := LL shl 1 - L2;
  LDif := L2 - L1;
  L6Dif := LDif * 6;
  LR := LH + 85;
  if LR < 0 then
    Inc(LR, 256);
  if LR > 256 then
    Dec(LR, 256);
  if LR < 43 then
    LR := L1 + L6Dif * LR shr 8
  else if LR < 128 then
    LR := L2
  else if LR < 171 then
    LR := L1 + L6Dif * (170 - LR) shr 8
  else
    LR := L1;
  if LR > 255 then
    LR := 255;
  LG := LH;
  if LG < 0 then
    Inc(LG, 256);
  if LG > 256 then
    Dec(LG, 256);
  if LG < 43 then
    LG := L1 + L6Dif * LG shr 8
  else if LG < 128 then
    LG := L2
  else if LG < 171 then
    LG := L1 + L6Dif * (170 - LG) shr 8
  else
    LG := L1;
  if LG > 255 then
    LG := 255;
  LB := LH - 85;
  if LB < 0 then
    Inc(LB, 256);
  if LB > 256 then
    Dec(LB, 256);
  if LB < 43 then
    LB := L1 + L6Dif * LB shr 8
  else if LB < 128 then
    LB := L2
  else if LB < 171 then
    LB := L1 + L6Dif * (170 - LB) shr 8
  else
    LB := L1;
  if LB > 255 then
    LB := 255;
  Result.R := LR;
  Result.G := LG;
  Result.B := LB;
end;

function RGBToColor(PR, PG, PB: Integer): TColor;
begin
  Result := TColor((PB shl 16) + (PG shl 8) + PR);
end;

function ColorToRGB(PColor: TColor): TRGB;
begin
  Result.R := PColor and $000000FF;
  Result.G := (PColor and $0000FF00) shr 8;
  Result.B := (PColor and $00FF0000) shr 16;
end;

function RGBToColor(PRGB: TRGB): TColor;
begin
  Result := RGBToColor(PRGB.R, PRGB.G, PRGB.B);
end;

function ColorToHLS(Color: TColor): THLS;
begin
  result := RGBToHLS(ColorToRGB(color));
end;

function HLSToColor(HLS: THLS): TColor;
begin
  result := RGBToColor(HLSToRGB(HLS));
end;

function IncreaseColor(color: TColor): TColor;
var RGB: TRGB;
  function Get(c: integer): integer;
  begin
    c := c - 10;
    if c < 0 then
      c := 0;
    result := c;
  end;
begin
  RGB := ColorToRGB(color);
  RGB.B := Get(RGB.B);
  RGB.G := Get(RGB.G);
  RGB.R := Get(RGB.R);
  Result := RGBToColor(RGB);
end;

end.

