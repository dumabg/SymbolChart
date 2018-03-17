unit uEstrategia;

interface

uses Tipos;

type

  TSugerencia = (tSin, tLargo, tCorto, tEsperar);

  TEstrategiaResult = record
    iLAL, iLAC, iLBL, iLBC, iLZL, iLZC: integer;
    SA, SB, SZ: string;
    NCalculado: currency;
    A11, B11, Z11, A13, A9: Currency;
//    resultado: currency;
    NM22, NM23: Currency;
    NMC: Currency;
    Msg, SubMsg: string;
    sugerencia: TSugerencia;
    DA, DSA, DFA, LDA, DB, DSB, DFB, LDB, DZ, DSZ, DFZ, LDZ, LAL, LAC, LBL, LBC, LZL, LZC: Currency;
    RA, RB, RZ: currency;
    LMA13, LMA12, LMA11, LMI13, LMI12, LMI11: currency;
    DMAX, DFMAX, DMAI, DFMAI, DMBX, DFMBX, DMBI, DFMBI, DMZX, DFMZX, DMZI, DFMZI: currency;
    DSXA, DSIA, DSXB, DSIB, DSXZ, DSIZ: currency;
    RXA, RIA, RXB, RIB: currency;
    LDXA, LDIA, LDXB, LDIB{, LDA1, LDA2, LDB1, LDB2, LDXZ, LDIZ, LDZ1, LDZ2}: currency;
    PRUA, PRDA: currency;
    PRUB, PRDB: Currency;
    PRUZ, PRDZ: Currency;
    OSA, OSB, OSZ: Currency;
    CODI: array[0..6] of Integer;
    RSIA, RSIB: currency;
    VOLA, VOLB, VOLZ, IPU: currency;
    VMA, VMB, VMZ, VTA, VTB, VTZ: Currency;
    A: array[1..21] of currency;
    mHRA, mHRB, mHRC, rHRA, rHRB, rHRC, HRA, HRB, HRC: integer;
  end;


  TEstrategia = class
  private
    K, A, B, Z, MA, MI, DXA, DIA, DXB, DIB, XA, IA, XB, IB,
      DXZ, DIZ, XZ, IZ: TArrayCurrency;
    Resultado: TEstrategiaResult;
    FEXB: currency;
    FEXA: currency;
    FEB: currency;
    FEIB: currency;
    FEA: currency;
    FEIA: currency;
    FEZ: currency;
    FEXZ: currency;
    FEIZ: currency;
    LALAnt, LACAnt, LBCAnt, LBLAnt: currency;
    FActivarInversaLDB: Boolean;
    FActivarInversaLDA: Boolean;
    FActivarInversaLDZ: Boolean;
    procedure Ajustar;
    procedure SortDesc(var A: TArrayCurrency);    
    procedure Sort(var A: TArrayCurrency);
    procedure CalcularTablasXI;
    procedure CalcularS;
    procedure CalcularRSI;
    procedure CalcularVariabilidad;
    procedure CalcularVariabilidadMaxMin;
    procedure CalcularLD;
    procedure CalcularLAC;
    procedure CalcularLAL;
    procedure CalcularLBC;
    procedure CalcularLBL;
    procedure CalcularLZL;
    procedure CalcularLZC;
    procedure CalcularResultado;
    procedure CalcularDesviaciones;
    procedure CalcularRecorrido;
    procedure CalcularPRUA;
    procedure CalcularCODI;
    procedure CalcularVOL;
    procedure CalcularHR;
    function GetMsg: string;
    function GetSubMsg: string;
  public
    constructor Create;
    function Calculate(const PCambios, PMaximos, PMinimos: PArrayCurrency; const i: integer;
      const LALAnt, LACAnt, LBCAnt, LBLAnt: currency): TEstrategiaResult;
    property EA: currency read FEA write FEA;
    property EB: currency read FEB write FEB;
    property EXA: currency read FEXA write FEXA;
    property EIA: currency read FEIA write FEIA;
    property EXB: currency read FEXB write FEXB;
    property EIB: currency read FEIB write FEIB;
    property EZ: currency read FEZ write FEZ;
    property EXZ: currency read FEXZ write FEXZ;
    property EIZ: currency read FEIZ write FEIZ;
    property ActivarInversaLDA: Boolean read FActivarInversaLDA write FActivarInversaLDA;
    property ActivarInversaLDB: Boolean read FActivarInversaLDB write FActivarInversaLDB;
    property ActivarInversaLDZ: Boolean read FActivarInversaLDZ write FActivarInversaLDZ;
  end;


implementation

uses SysUtils;

procedure TEstrategia.Ajustar;
var i, j: integer;
  K_, KAnt, condicion, coeficiente: currency;
begin
  for i := 22 downto 1 do begin
    K_ := K[i];
    KAnt := K[i - 1];
    if K_ > KAnt then begin
      condicion := (K_ - KAnt) / KAnt;
      coeficiente := condicion;
    end
    else begin
      if K_ < KAnt then begin
        condicion := (KAnt - K_) / K_;
        coeficiente := 1 / condicion;
      end
      else
        condicion := 0;
    end;
    if condicion >= 0.35 then begin
      for j := i - 1 to 0 do begin
        K[j] := K[j] * coeficiente;
        MA[j] := MA[j] * coeficiente;
        MI[j] := MI[j] * coeficiente;
      end;
    end;
  end;
end;

procedure TEstrategia.CalcularLAC;
var A11_LDA: Currency;
  j, j1: integer;
begin
  A11_LDA := A[10] - Resultado.LDA;
  for j := 10 downto 1 do begin
    j1 := j - 1;
    if (A11_LDA <= A[j]) and (A11_LDA >= A[j1]) then begin
      Resultado.LAC := A[j1];
      Resultado.iLAC := j1;
      exit;
    end;
  end;
  if (A11_LDA <= A[0]) then begin
    Resultado.LAC := A[0];
    Resultado.iLAC := 0;
  end
  else begin
    Resultado.LAC := A[10];
    Resultado.iLAC := 10;
  end;
end;

procedure TEstrategia.CalcularLAL;
var A11_LDA: Currency;
  j, j1: integer;
begin
  A11_LDA := A[10] + Resultado.LDA;
  for j := 10 to 19 do begin
    j1 := j + 1;
    if (A11_LDA >= A[j]) and (A11_LDA <= A[j1]) then begin
      Resultado.LAL := A[j1];
      Resultado.iLAL := j1;
      exit;
    end;
  end;
  if (A11_LDA >= A[20]) then begin
    Resultado.LAL := A[20];
    Resultado.iLAL := 20;
  end
  else begin
    Resultado.LAL := A[10];
    Resultado.iLAL := 10;
  end;
end;

procedure TEstrategia.CalcularLBC;
var B11_LDB: Currency;
  j, j1: integer;
begin
  B11_LDB := B[10] - Resultado.LDB;
  for j := 10 downto 1 do begin
    j1 := j - 1;
    if (B11_LDB <= B[j]) and (B11_LDB >= B[j1]) then begin
      Resultado.LBC := B[j1];
      Resultado.iLBC := j1;
      Exit;
    end;
  end;
  if (B11_LDB <= B[0]) then begin
    Resultado.LBC := B[0];
    Resultado.iLBC := 0;
  end
  else begin
    Resultado.LBC := B[10];
    Resultado.iLBC := 10;
  end;
end;

procedure TEstrategia.CalcularLBL;
var B11_LDB: Currency;
  j, j1: integer;
begin
  B11_LDB := B[10] + Resultado.LDB;
  for j := 10 to 19 do begin
    j1 := j + 1;
    if (B11_LDB >= B[j]) and (B11_LDB <= B[j1]) then begin
      Resultado.LBL := B[j1];
      Resultado.iLBL := j1;
      Exit;
    end;
  end;
  if (B11_LDB >= B[20]) then begin
    Resultado.LBL := B[20];
    Resultado.iLBL := 20;
  end
  else begin
    Resultado.LBL := B[10];
    Resultado.iLBL := 10;
  end;
end;

procedure TEstrategia.CalcularCODI;
var i, j: Integer;
  datos, datosOrden: TArrayCurrency;
  aux: currency;
  num: integer;
const N: integer = 7;
begin
  SetLength(datos, N);
  datos := Copy(K, 23 - N, N);
  datosOrden := Copy(datos, 0, N);
  SortDesc(datosOrden);
  i := 0;
  num := 7;
  while i < N do begin
    aux := datosOrden[i];
    for j := 0 to N - 1 do begin
      if datos[j] = aux then
        Resultado.CODI[N - 1 - j] := num;
    end;
    dec(num);
    Inc(i);
    while (i < N) and (datosOrden[i] = aux) do
      Inc(i);
  end;
end;

procedure TEstrategia.CalcularDesviaciones;
var MTB, MTA, MTZ, VTB, VTA, VTZ, MTXZ, MTIZ, aux: double;
  MTXA, MTIA, MTXB, MTIB, VTXA, VTIA, VTXB, VTIB, VTXZ, VTIZ: double;
  i: integer;
begin
  MTA := A[0];
  MTB := B[0];
  MTZ := Z[0];
//  MTXA := XA[0];
//  MTXB := XB[0];
//  MTIA := IA[0];
//  MTIB := IB[0];
//  MTXZ := XZ[0];
//  MTIZ := IZ[0];
  for i := 1 to 20 do begin
    MTA := MTA + A[i];
    MTB := MTB + B[i];
    MTZ := MTZ + Z[i];
//    MTXA := MTXA + XA[i];
//    MTXB := MTXB + XB[i];
//    MTIA := MTIA + IA[i];
//    MTIB := MTIB + IB[i];
//    MTXZ := MTXZ + XZ[i];
//    MTIZ := MTIZ + IZ[i];
  end;
  MTA := MTA / 21;
  MTB := MTB / 21;
  MTZ := MTZ / 21;
//  MTXA := MTXA / 21;
//  MTXB := MTXB / 21;
//  MTIA := MTIA / 21;
//  MTIB := MTIB / 21;
//  MTXZ := MTXZ / 21;
//  MTIZ := MTIZ / 21;

  VTA := 0;
  VTB := 0;
  VTZ := 0;
//  VTXA := 0;
//  VTXB := 0;
//  VTIA := 0;
//  VTIB := 0;
//  VTXZ := 0;
//  VTIZ := 0;
  for i := 0 to 20 do begin
    aux := A[i] - MTA;
    VTA := VTA + (aux * aux);
    aux := B[i] - MTB;
    VTB := VTB + (aux * aux);
    aux := Z[i] - MTZ;
    VTZ := VTZ + (aux * aux);
//    aux := XA[i] - MTXA;
//    VTXA := VTXA + (aux * aux);
//    aux := XB[i] - MTXB;
//    VTXB := VTXB + (aux * aux);
//    aux := IA[i] - MTIA;
//    VTIA := VTIA + (aux * aux);
//    aux := IB[i] - MTIB;
//    VTIB := VTIB + (aux * aux);
//    aux := XZ[i] - MTXZ;
//    VTXZ := VTXZ + (aux * aux);
//    aux := IZ[i] - MTIZ;
//    VTIZ := VTIZ + (aux * aux);
  end;
  VTA := VTA / 21;
  VTB := VTB / 21;
  VTZ := VTZ / 21;
  Resultado.VTA := VTA;
  Resultado.VTB := VTB;
  Resultado.VTZ := VTZ;
//  VTXA := VTXA / 21;
//  VTXB := VTXB / 21;
//  VTIA := VTIA / 21;
//  VTIB := VTIB / 21;
//  VTXZ := VTXZ / 21;
//  VTIZ := VTIZ / 21;

  Resultado.DSA := Sqrt(VTA);
  Resultado.DSB := Sqrt(VTB);
  Resultado.DSZ := Sqrt(VTZ);
//  Resultado.DSXA := Sqrt(VTXA);
//  Resultado.DSXB := Sqrt(VTXB);
//  Resultado.DSIA := Sqrt(VTIA);
//  Resultado.DSIB := Sqrt(VTIB);
//  Resultado.DSXZ := Sqrt(VTXZ);
//  Resultado.DSIZ := Sqrt(VTIZ);
end;

procedure TEstrategia.CalcularHR;

  procedure pesoOrden(var desordenado: array of currency; var ordenado: array of integer);
  var i, j, num: Integer;
    current: Currency;
  begin
    for i := 0 to 5 do begin
      current := desordenado[i];
      num := 0;
      for j := 0 to 5 do begin
        if (j <> i) and (desordenado[j] < current) then begin
          inc(num);
        end;
      end;
      ordenado[i] := num + 1;
    end;
  end;

  procedure calculate(i: integer; var HR, mHR, rHR: integer);
  var j, offset, pow10: integer;
    mc: currency;
    m, r: array[0..5] of Currency;
    mo, ro: array[0..5] of integer;
  begin
  //22 + 21 + 20
    offset := 3 * 6 + i;
    mc := (K[offset] + K[offset + 1] +  K[offset + 2]) / 3;
    // 4 + 3 + 2
    // 7 + 6 + 5
    // 10 + 9 + 8
    // 13 + 12 + 11
    // 16 + 15 + 14
    // 19 + 18 + 17
    for j := 0 to 5 do begin
      offset := j * 3 + i;
      m[j] := (K[offset] + K[offset + 1] + K[offset + 2]) / 3;
      r[j] := mc - m[j];
    end;
    pesoOrden(m, mo);
    pesoOrden(r, ro);
    for j := 0 to 5 do
      ro[j] := 7 - ro[j];

    mHR := 0;
    rHR := 0;
    pow10 := 1;
    for j := 0 to 5 do begin
      mHR := mHR + mo[j] * pow10;
      rHR := rHR + ro[5 - j] * pow10;
      pow10 := pow10 * 10;
    end;
    HR := mHR - rHR;
  end;

begin
  calculate(2, Resultado.HRA, Resultado.mHRA, Resultado.rHRA);
  calculate(1, Resultado.HRB, Resultado.mHRB, Resultado.rHRB);
  calculate(0, Resultado.HRC, Resultado.mHRC, Resultado.rHRC);
end;

procedure TEstrategia.CalcularLD;
begin
  Resultado.LDA := ((Resultado.DA + Resultado.DSA) / Resultado.DFA);
  if FActivarInversaLDA then
    Resultado.LDA := (Resultado.LDA / Resultado.DFA);
  Resultado.LDB := ((Resultado.DB + Resultado.DSB) / Resultado.DFB);
  if FActivarInversaLDB then
    Resultado.LDB := Resultado.LDB /Resultado.DFB;
  Resultado.LDZ := ((Resultado.DZ + Resultado.DSZ) / Resultado.DFZ);
  if FActivarInversaLDZ then
    Resultado.LDZ := (Resultado.LDZ / Resultado.DFZ);
//  Resultado.LDXA := FEXA * ((Resultado.DMAX + Resultado.DSXA) / Resultado.DFMAX);
//  Resultado.LDIA := FEIA * ((Resultado.DMAI + Resultado.DSIA) / Resultado.DFMAI);
//  Resultado.LDXB := FEXB * ((Resultado.DMBX + Resultado.DSXB) / Resultado.DFMBX);
//  Resultado.LDIB := FEIB * ((Resultado.DMBI + Resultado.DSIB) / Resultado.DFMBI);
//  Resultado.LDXZ := FEXZ * ((Resultado.DMZX + Resultado.DSXZ) / Resultado.DFMZX);
//  Resultado.LDIZ := FEIZ * ((Resultado.DMZI + Resultado.DSIZ) / Resultado.DFMZI);
//  Resultado.LDA1 := Abs(Resultado.LDA) + Abs(Resultado.LDXA);
//  Resultado.LDA2 := Abs(Resultado.LDA) + Abs(Resultado.LDIA);
//  Resultado.LDB1 := Abs(Resultado.LDB) + Abs(Resultado.LDXB);
//  Resultado.LDB2 := Abs(Resultado.LDB) + Abs(Resultado.LDIB);
//  Resultado.LDZ1 := Abs(Resultado.LDZ) + Abs(Resultado.LDXZ);
//  Resultado.LDZ2 := Abs(Resultado.LDZ) + Abs(Resultado.LDIZ);
end;

procedure TEstrategia.CalcularLZC;
var Z11_LDZ: Currency;
  j, j1: integer;
begin
  Z11_LDZ := Z[10] - Resultado.LDZ;
  for j := 10 downto 1 do begin
    j1 := j - 1;
    if (Z11_LDZ <= Z[j]) and (Z11_LDZ >= Z[j1]) then begin
      Resultado.LZC := Z[j1];
      Resultado.iLZC := j1;
      exit;
    end;
  end;
  if (Z11_LDZ <= Z[0]) then begin
    Resultado.LZC := Z[0];
    Resultado.iLZC := 0;
  end
  else begin
    Resultado.LZC := Z[10];
    Resultado.iLZC := 10;
  end;
end;

procedure TEstrategia.CalcularLZL;
var Z11_LDZ: Currency;
  j, j1: integer;
begin
  Z11_LDZ := Z[10] + Resultado.LDZ;
  for j := 10 to 19 do begin
    j1 := j + 1;
    if (Z11_LDZ >= Z[j]) and (Z11_LDZ <= Z[j1]) then begin
      Resultado.LZL := Z[j1];
      Resultado.iLZL := j1;
      Exit;
    end;
  end;
  if (Z11_LDZ >= Z[20]) then begin
    Resultado.LZL := Z[20];
    Resultado.iLZL := 20;
  end
  else begin
    Resultado.LZL := Z[10];
    Resultado.iLZL := 10;
  end;
end;

procedure TEstrategia.CalcularPRUA;
var PRDZ, PRUZ: Currency;
begin
  Resultado.PRDA := (Resultado.LAL - K[22]) / (Resultado.LAL - Resultado.LAC) * 100;
  Resultado.PRUA := (K[22] - Resultado.LAC) / (Resultado.LAL - Resultado.LAC) * 100;
  Resultado.PRDB := (Resultado.LBL - K[21]) / (Resultado.LBL - Resultado.LBC) * 100;
  Resultado.PRUB := (K[21] - Resultado.LBC) / (Resultado.LBL - Resultado.LBC) * 100;
  Resultado.OSA := Resultado.PRUA - Resultado.PRDA;
  Resultado.OSB := Resultado.PRUB - Resultado.PRDB;
  Resultado.PRDZ := (Resultado.LZL - K[20]) / (Resultado.LZL - Resultado.LZC) * 100;
  Resultado.PRUZ := (K[20] - Resultado.LZC) / (Resultado.LZL - Resultado.LZC) * 100;
  Resultado.OSZ := Resultado.PRUZ - Resultado.PRDZ;
end;

procedure TEstrategia.CalcularRecorrido;
const
  SN: integer = 231;
  SN2: Integer = 3311;
var
  SKA, SKB, SKZ, SK, SNA, SNB, SNZ, SK2A, SK2B, SK2Z : currency;
  SKXA, SKIA, SKXB, SKIB, SNXA, SNIA, SNXB, SNIB, SK2XA, SK2IA, SK2XB, SK2IB: currency;
  i: Integer;
begin
  SK := 0;
  SKXA := 0;
  SKIA := 0;
  SKXB := 0;
  SKIB := 0;
  for i := 2 to 20 do begin
    SK := SK + K[i];
    SKXA := SKXA + DXA[i];
    SKIA := SKIA + DIA[i];
    SKXB := SKXB + DXB[i];
    SKIB := SKIB + DIB[i];
  end;
  SKA := SK + K[21] + K[22];
  SKB := SK + K[1] + K[21];
  SKZ := SK + K[0] + K[1];
  SKXA := SKXA + DXA[0] + DXA[1];
  SKIA := SKIA + DIA[0] + DIA[1];
  SKXB := SKXB + DXB[0] + DXB[1];
  SKIB := SKIB + DIB[0] + DIB[1];

  SNA := 0;
  SNB := 0;
  SNZ := 0;
  SNXA := DXA[0];
  SNIA := DIA[0];
  SNXB := DXB[0];
  SNIB := DIB[0];
  for i := 1 to 20 do begin
    SNA := SNA + (i * K[i + 1]);
    SNB := SNB + (i * K[i]);
    SNZ := SNZ + (i * K[i - 1]);
    SNXA := SNXA + (i * DXA[i]);
    SNIA := SNIA + (i * DIA[i]);
    SNXB := SNXB + (i * DXB[i]);
    SNIB := SNIB + (i * DIB[i]);
  end;
  SNA := SNA + (21 * K[22]);
  SNB := SNB + (21 * K[21]);
  SNZ := SNZ + (21 * K[20]);

  SK2A := 0;
  SK2B := 0;
  SK2Z := 0;
  SK2XA := DXA[0] * DXA[0];
  SK2IA := DIA[0] * DIA[0];
  SK2XB := DXB[0] * DXB[0];
  SK2IB := DIB[0] * DIB[0];
  for i := 1 to 20 do begin
    SK2A := SK2A + (K[i + 1] * K[i + 1]);
    SK2B := SK2B + (K[i] * K[i]);
    SK2Z := SK2Z + (K[i - 1] * K[i - 1]);
    SK2XA := SK2XA + (DXA[i] * DXA[i]);
    SK2IA := SK2IA + (DIA[i] * DIA[i]);
    SK2XB := SK2XB + (DXB[i] * DXB[i]);
    SK2IB := SK2IB + (DIB[i] * DIB[i]);
  end;
  SK2A := SK2A + (K[22] * K[22]);
  SK2B := SK2B + (K[21] * K[21]);
  SK2Z := SK2Z + (K[20] * K[20]);

  Resultado.RA := (((21 * SNA) - (SN * SKA) ) / sqrt(((21 * SN2) - (SN * SN)) * ((21 * SK2A) - (SKA * SKA)))) * 100;
  Resultado.RB := (((21 * SNB) - (SN * SKB) ) / sqrt(((21 * SN2) - (SN * SN)) * ((21 * SK2B) - (SKB * SKB)))) * 100;
  Resultado.RZ := (((21 * SNZ) - (SN * SKZ) ) / sqrt(((21 * SN2) - (SN * SN)) * ((21 * SK2Z) - (SKZ * SKZ)))) * 100;
  Resultado.RXA := (((21 * SNXA) - (SN * SKXA) ) / sqrt(((21 * SN2) - (SN * SN)) * ((21 * SK2XA) - (SKXA * SKXA)))) * 100;
  Resultado.RIA := (((21 * SNIA) - (SN * SKIA) ) / sqrt(((21 * SN2) - (SN * SN)) * ((21 * SK2IA) - (SKIA * SKIA)))) * 100;
  Resultado.RXB := (((21 * SNXB) - (SN * SKXB) ) / sqrt(((21 * SN2) - (SN * SN)) * ((21 * SK2XB) - (SKXB * SKXB)))) * 100;
  Resultado.RIB := (((21 * SNIB) - (SN * SKIB) ) / sqrt(((21 * SN2) - (SN * SN)) * ((21 * SK2IB) - (SKIA * SKIB)))) * 100;
end;

procedure TEstrategia.CalcularResultado;
var LAC, LAL, LBC, LBL, NM22, NM23, L22, L23, aux: currency;
  res, resDecimales: integer;
  i, j, l, E22, E23, NMT: integer;

  function CalcI(K_, KSig: currency): Currency;
  begin
    //Nivel 1
    if K_ < LBC then begin
      res := 28;
    end
    else begin
      if K_ > LBC then
        res := 55
      else
        res := 1;
    end;

    //Nivel 2
    if K_ < LBL then begin
      res := res + 9;
    end
    else begin
      if K_ > LBL then begin
        res := res + 18;
      end;
    end;

    //Nivel 3
    if KSig < LAC then begin
      res := res + 3;
    end
    else begin
      if KSig > LAC then begin
        res := res + 6;
      end;
    end;

    //Nivel 4
    if KSig < LAL then begin
      res := res + 1;
    end
    else begin
      if KSig > LAL then begin
        res := res + 2;
      end;
    end;

    //Calcular decimales
    if KSig < LBC then begin
      resDecimales := 4;
    end
    else begin
      if KSig > LBC then begin
        resDecimales := 7;
      end
      else
        resDecimales := 0;
    end;

    if KSig < LBL then begin
      resDecimales := resDecimales + 1;
    end
    else begin
      if KSig > LBL then begin
        resDecimales := resDecimales + 2;
      end;
    end;
    result := res + (resDecimales / 10);
  end;
begin
  LAC := LACAnt;
  LAL := LALAnt;
  LBC := LBCAnt;
  LBL := LBLAnt;
  NM22 := CalcI(K[20], K[21]);
  Resultado.NM22 := NM22;
  LAC := Resultado.LAC;
  LAL := Resultado.LAL;
  LBC := Resultado.LBC;
  LBL := Resultado.LBL;
  NM23 := CalcI(K[21], K[22]);
  Resultado.NM23 := NM23;

  l := 0;
  for j := 1 to 81 do begin
    for i := 1 to 9 do begin
      inc(l);
      aux := j + (i / 10);
      if NM22 = aux then
        L22 := l;
      if NM23 = aux then
        L23 := l;
    end;
  end;

  NMT := 0;
  for E22 := 1 to 729 do begin
    for E23 := 1 to 729 do begin
      inc(NMT);
      if (E22 = L22) and (E23 = L23) then begin
         Resultado.NMC := NMT / 1000;
         Exit;
      end;
    end;
  end;
end;

procedure TEstrategia.CalcularRSI;
    function getRSI(desde, hasta: Integer): Currency;
    var i, j: integer;
      resta, ut, dt: Currency;
      U, D: array [1..14] of Currency;
    begin
      j := 1;
      for i := desde to hasta do begin
        resta := K[i] - K[i - 1];
        if resta >= 0 then begin
          U[j] := resta;
          D[j] := 0;
        end
        else begin
          U[j] := 0;
          D[j] := Abs(resta);
        end;
        inc(j);
      end;

      dt := D[1];
      ut := U[1];
      for i := 2 to 14 do begin
        dt := dt + D[i];
        ut := ut + U[i];
      end;
      if dt = 0 then
        result := 100
      else
        result := 100 - (100 / (1 + (ut / dt)));
    end;
begin
  Resultado.RSIA := getRSI(9, 22);
  Resultado.RSIB := getRSI(8, 21);
end;

procedure TEstrategia.CalcularS;
var SA, SB, SZ: string;
begin
  if K[22] > A[5] then
    SA := '+'
  else
    if K[22] < A[5] then
      SA := '-'
    else
      SA := '=';

  Resultado.SA := SA;

  if K[21] > B[5] then
    SB := '+'
  else
    if K[21] < B[5] then
      SB := '-'
    else
      SB := '=';
  Resultado.SB := SB;

  if K[20] > Z[5] then
    SZ := '+'
  else
    if K[20] < Z[5] then
      SZ := '-'
    else
      SZ := '=';
  Resultado.SZ := SZ;
end;

procedure TEstrategia.CalcularTablasXI;
var i: integer;
begin
  SetLength(DXA, 21);
  SetLength(DIA, 21);
  SetLength(DXB, 21);
  SetLength(DIB, 21);
  SetLength(DXZ, 21);
  SetLength(DIZ, 21);
  for i := 0 to 20 do begin
    DXA[i] := MA[i + 2] - K[i + 2];
    DIA[i] := K[i + 2] - MI[i + 2];
    DXB[i] := MA[i + 1] - K[i + 1];
    DIB[i] := K[i + 1] - MI[i + 1];
    DXZ[i] := MA[i] - K[i];
    DIZ[i] := K[i] - MI[i];
  end;
  XA := Copy(DXA, 0, 21);
  IA := Copy(DIA, 0, 21);
  XB := Copy(DXB, 0, 21);
  IB := Copy(DIB, 0, 21);
  XZ := Copy(DXZ, 0, 21);
  IZ := Copy(DIZ, 0, 21);
  Sort(XA);
  Sort(IA);
  Sort(XB);
  Sort(IB);
  Sort(XZ);
  Sort(IZ);
end;

procedure TEstrategia.CalcularVariabilidad;
var j: integer;
  VMB, VMA, VMZ, KSig, VM: Currency;
begin
  if K[0] >= K[1] then
    VMZ := (K[0] - K[1]) / K[1]
  else
    VMZ := (K[1] - K[0]) / K[0];

  if K[1] >= K[2] then
    VMB := (K[1] - K[2]) / K[2]
  else
    VMB := (K[2] - K[1]) / K[1];
  VMZ := VMZ + VMB;

  VMA := 0;
  for j := 2 to 19 do begin
    KSig := K[j + 1];
    if K[j] >= KSig then
      VM := (K[j] - KSig) / KSig
    else
      VM := (KSig - K[j]) / K[j];
    VMA := VMA + VM;
    VMB := VMB + VM;
    VMZ := VMZ + VM;
  end;

  if K[20] >= K[21] then
    VM := (K[20] - K[21]) / K[21]
  else
    VM := (K[21] - K[20]) / K[20];
  VMA := VMA + VM;
  VMB := VMB + VM;

  if K[21] >= K[22] then
    VMA := VMA + (K[21] - K[22]) / K[22]
  else
    VMA := VMA + (K[22] - K[21]) / K[21];

  VMA := VMA / 20;
  VMB := VMB / 20;
  VMZ := VMZ / 20;
  Resultado.VMA := VMA;
  Resultado.VMB := VMB;
  Resultado.VMZ := VMZ;

  Resultado.DA := A[10] * VMA;
  Resultado.DFA := (A[20] + A[0]) / A[20];
  Resultado.DB := B[10] * VMB;
  Resultado.DFB := (B[20] + B[0]) / B[20];
  Resultado.DZ := Z[10] * VMZ;
  Resultado.DFZ := (Z[20] + Z[0]) / Z[20];

//  CalcularVariabilidadMaxMin;
end;

procedure TEstrategia.CalcularVariabilidadMaxMin;
var VM, actual, sig, suma: currency;
  i: integer;
begin
  suma := 0;
  for i := 0 to 19 do begin
    actual:= DXA[i];
    sig := DXA[i + 1];
    if actual >= sig then begin
      if sig = 0 then
        VM := 0
      else
        VM := (actual - sig) / sig;
    end
    else begin
      if actual = 0 then
        VM := 0
      else
        VM := (sig - actual) / actual;
    end;
    suma := suma + VM;
  end;
  Resultado.DMAX := XA[10] * (suma / 20);
  Resultado.DFMAX := (XA[20] + XA[0]) / XA[20];

  suma := 0;
  for i := 0 to 19 do begin
    actual := DIA[i];
    sig := DIA[i + 1];
    if actual >= sig then begin
      if sig = 0 then
        VM := 0
      else
        VM := (actual - sig) / sig;
    end
    else begin
      if actual = 0 then
        VM := 0
      else
        VM := (sig - actual) / actual;
    end;
    suma := suma + VM;
  end;
  Resultado.DMAI := IA[10] * (suma / 20);
  Resultado.DFMAI := (IA[20] + IA[0]) / IA[20];

  suma := 0;
  for i := 0 to 19 do begin
    actual := DXB[i];
    sig := DXB[i + 1];
    if actual >= sig then begin
      if sig = 0 then
        VM := 0
      else
        VM := (actual - sig) / sig
    end
    else begin
      if actual = 0 then
        VM := 0
      else
        VM := (sig - actual) / actual;
    end;
    suma := suma + VM;
  end;
  Resultado.DMBX := XB[10] * (suma / 20);
  Resultado.DFMBX := (XB[20] + XB[0]) / XB[20];

  suma := 0;
  for i := 0 to 19 do begin
    actual := DIB[i];
    sig := DIB[i + 1];
    if actual >= sig then begin
      if sig = 0 then
        VM := 0
      else
        VM := (actual - sig) / sig
    end
    else begin
      if actual = 0 then
        VM := 0
      else
        VM := (sig - actual) / actual;
    end;
    suma := suma + VM;
  end;
  Resultado.DMBI := IB[10] * (suma / 20);
  Resultado.DFMBI := (IB[20] + IB[0]) / IB[20];

  suma := 0;
  for i := 0 to 19 do begin
    actual := DXZ[i];
    sig := DXZ[i + 1];
    if actual >= sig then begin
      if sig = 0 then
        VM := 0
      else
        VM := (actual - sig) / sig
    end
    else begin
      if actual = 0 then
        VM := 0
      else
        VM := (sig - actual) / actual;
    end;
    suma := suma + VM;
  end;
  Resultado.DMZX := XZ[10] * (suma / 20);
  Resultado.DFMZX := (XZ[20] + XZ[0]) / XZ[20];


  suma := 0;
  for i := 0 to 19 do begin
    actual := DIZ[i];
    sig := DIZ[i + 1];
    if actual >= sig then begin
      if sig = 0 then
        VM := 0
      else
        VM := (actual - sig) / sig
    end
    else begin
      if actual = 0 then
        VM := 0
      else
        VM := (sig - actual) / actual;
    end;
    suma := suma + VM;
  end;
  Resultado.DMZI := IZ[10] * (suma / 20);
  Resultado.DFMZI := (IZ[20] + IZ[0]) / IZ[20];
end;

procedure TEstrategia.CalcularVOL;
var M7A, M7B, M7Z, VOLA, VOLB, VOLZ, aux: double;
  i: integer;
begin
  M7A := K[22];
  for i := 22 - 6 to 21 do begin
    M7A := M7A + K[i];
  end;
  M7A := M7A / 7;
  VOLA := 0;
  for i := 22 - 6 to 22 do begin
    aux := K[i] - M7A;
    VOLA := VOLA + (aux * aux);
  end;
  VOLA := VOLA /7;
  Resultado.VOLA := (Sqrt(VOLA) / M7A) * 100;

  M7B := K[21];
  for i := 21 - 6 to 20 do begin
    M7B := M7B + K[i];
  end;
  M7B := M7B / 7;
  VOLB := 0;
  for i := 21 - 6 to 21 do begin
    aux := K[i] - M7B;
    VOLB := VOLB + (aux * aux);
  end;
  VOLB := VOLB /7;
  Resultado.VOLB := (Sqrt(VOLB) / M7B) * 100;

  M7Z := K[20];
  for i := 20 - 6 to 19 do begin
    M7Z := M7Z + K[i];
  end;
  M7Z := M7Z / 7;
  VOLZ := 0;
  for i := 20 - 6 to 20 do begin
    aux := K[i] - M7Z;
    VOLZ := VOLZ + (aux * aux);
  end;
  VOLZ := VOLZ /7;
  Resultado.VOLZ := (Sqrt(VOLZ) / M7Z) * 100;

  Resultado.IPU := Abs(((K[22] - K[21]) / K[21]) * 100);
end;

function TEstrategia.Calculate(const PCambios, PMaximos, PMinimos: PArrayCurrency;
  const i: integer; const LALAnt, LACAnt, LBCAnt, LBLAnt: currency): TEstrategiaResult;
var j: integer;
begin
  Self.LALAnt := LALAnt;
  Self.LACAnt := LACAnt;
  Self.LBCAnt := LBCAnt;
  Self.LBLAnt := LBLAnt;
  K := Copy(PCambios^, i - 22, 23);
  MA := Copy(PMaximos^, i - 22, 23);
  MI := Copy(PMinimos^, i - 22, 23);
  Ajustar;

  A := Copy(K, 2, 21);
  Sort(A);
  B := Copy(K, 1, 21);
  Sort(B);
  Z := Copy(K, 0, 21);
  Sort(Z);

  CalcularVariabilidad;
  CalcularDesviaciones;
  CalcularLD;
  CalcularLAL;
  CalcularLAC;
  CalcularLBC;
  CalcularLBL;
  CalcularLZL;
  CalcularLZC;
  CalcularPRUA;

  CalcularHR;
//  CalcularTablasXI;
//
//  CalcularRSI;
//
//
//  CalcularRecorrido;
//
//  CalcularResultado;
//
//
//  CalcularCODI;
//  CalcularVOL;
//
////  Resultado.Msg := GetMsg;
//  CalcularS;
//  Resultado.SubMsg := GetMsg + sLineBreak + GetSubMsg;

  Resultado.A11 := A[10];
  Resultado.B11 := B[10];
  Resultado.Z11 := Z[10];
  Resultado.A13 := A[12];
  Resultado.A9 := A[8];

  for j := 0 to 20 do begin
    Resultado.A[j + 1] := A[j];
  end;
  Result := Resultado;
end;

constructor TEstrategia.Create;
begin
  FEA := 1;
  FEB := 1;
  FEXA := 1;
  FEIA := 1;
  FEXB := 1;
  FEIB := 1;
  FEZ := 1;
  FEXZ := 1;
  FEIZ := 1;
  FActivarInversaLDA := false;
  FActivarInversaLDB := false;
  FActivarInversaLDZ := false;
end;

function TEstrategia.GetMsg: string;
const cortos: array[1..14] of Currency = (11.5, 14.5, 17.5, 38.5, 41.1, 41.5,
  44.5, 65.1, 65.5, 68.1, 68.5, 71.5, 80.5, 81.6);
const esperar: array[1..36] of currency = (11.8, 14.8, 16.8, 17.1, 17.8, 18.8, 38.1, 38.8, 39.8, 41.8, 42.8,
  43.7, 43.8, 44.8, 45.8, 45.9, 56.8, 61.8, 62.7, 62.8, 63.8, 65.8, 68.8, 69.8, 70.7, 70.8, 71.7, 71.8,
  72.8, 74.8, 77.5, 77.8, 78.8, 79.8, 80.8, 81.8);
const largos: array[1..16] of currency = (18.9, 26.9, 39.9, 44.9, 61.9, 62.9, 63.9, 70.9,
  71.9, 72.7, 72.9, 79.7, 79.9, 80.7, 80.9, 81.9);
var i: Integer;
  msg: string;
  regla: currency;
begin
//  Exit;
//  if (K[11] > Resultado.LBC) AND (K[12] > Resultado.LAC) then
//    result := 'LARGO'
//  else
//    if (K[11] > Resultado.LBC) AND (K[12] <= Resultado.LAC) then
//      result := 'CERRAR LARGO'
//    else
//      if (K[11] <= Resultado.LBC) AND (K[12] <= Resultado.LAC) then
//        result := 'ESPERAR'
//      else
//        if (K[11] <= Resultado.LBC) AND (K[12] > Resultado.LAC) then
//          result := 'ENTRAR LARGO'
//        else
//          result := 'SIN MENSAJE';

//  if (K[11] < Resultado.LBL) AND (K[12] < Resultado.LAL) then
//    result := 'CORTO'
//  else
//    if (K[11] < Resultado.LBL) AND (K[12] >= Resultado.LAL) then
//      result := 'CERRAR CORTO'
//    else
//      if (K[11] >= Resultado.LBL) AND (K[12] > Resultado.LAL) then
//        result := 'ESPERAR'
//      else
//        if (K[11] >= Resultado.LBL) AND (K[12] < Resultado.LAL) then
//          result := 'ENTRAR CORTO'
//        else
//          result := 'SIN MENSAJE';
//  exit;

//  regla := Resultado.resultado;
  regla := Resultado.NM23;
  for i := Low(cortos) to High(cortos) do begin
    if regla = cortos[i] then begin
      Resultado.sugerencia := tCorto;
      result := 'CORTOS.' + ' CERRAR SI CIERRE > ' + CurrToStr(Resultado.LAC) + '.';
      exit;
    end;
  end;

  for i := Low(esperar) to High(esperar) do begin
    if regla = esperar[i] then begin
      Resultado.sugerencia := tEsperar;
      result := 'ESPERAR. CORTOS C < ' + CurrToStr(Resultado.LAC) +
      '. LARGOS C > ' + CurrToStr(Resultado.LAL) + '.';
      exit;
    end;
  end;

  for i := Low(largos) to High(largos) do begin
    if regla = largos[i] then begin
      Resultado.sugerencia := tLargo;
      result := 'LARGOS.' + ' CERRAR SI CIERRE < ' + CurrToStr(Resultado.LAL) + '.';
      exit;
    end;
  end;
  Resultado.sugerencia := tSin;
  result := 'SIN MENSAJE';
end;

function TEstrategia.GetSubMsg: string;
var msg: string;

  procedure SAMas;
  begin
    if Resultado.SB = '-' then begin
      if Resultado.SZ = '+' then begin
        msg := 'INDECISIÓN.';
//        if K[12] > K[11] then
//          msg := msg + ' ORIÉNTANDOSE AL ALZA.'
//        else
//          if K[12] < K[11] then
//            msg := msg + ' ORIÉNTANDOSE A LA BAJA.'
      end
      else begin
        if Resultado.SZ = '-' then begin
          msg := 'INTENTO DE GIRO ALCISTA.';
//          if K[12] < K[11] then
//            msg := msg + ' FALLIDO MOMENTÁNEAMENTE.'
        end
        else begin
          msg := 'INDECISIÓN.';
//          if K[12] > K[11] then
//            msg := msg + ' ORIENTÁNDOSE AL ALZA.'
        end;
      end;
    end
    else begin
      if Resultado.SB = '+' then begin
        if Resultado.SZ = '+' then begin
          msg := 'ALCISTA.';
//          if K[12] < K[11] then
//            msg := msg + ' CON REPAROS.';
//          if Resultado.R14 < 25 then
//            msg := msg + ' GRÁFICO SOBREVENDIDO.'
//          else begin
//            if Resultado.R14 > 75 then
//              msg := msg + ' PRECAUCIÓN: SOBRECOMPRADO.'
//          end;
        end
        else begin
          if Resultado.SZ = '-' then begin
            msg := 'GIRO ALCISTA.';
//            if K[12] < K[11] then
//              msg := msg + ' CON DUDAS MOMENTÁNEAS.'
          end
          else begin
            msg := 'GIRO ALCISTA DESDE SOPORTE.';
//            if K[12] < K[11] then
//              msg := msg + ' CON FALLO MOMENTÁNEO.'
          end;
        end;
      end
      else begin
        if Resultado.SZ = '+' then begin
          msg := 'INTENTO FALLIDO DE ROTURA DE SOPORTE.';
//          if K[12] < K[11] then
//            msg := msg + ' CON NUEVO INTENTO MOMENTÁNEO.'
        end
        else begin
          if Resultado.SZ = '-' then begin
            msg := 'INTENTO GIRO ALCISTA.';
//            if K[12] < K[11] then
//              msg := msg + ' DILUYÉNDOSE.'
          end
          else begin
            msg := 'ROTURA DE RESISTENCIA.';
//            if K[12] < K[11] then
//              msg := msg + ' CON BAJA MOMENTÁNEA.'
          end;
        end;
      end;
    end;
  end;

  procedure SAMenos;
  begin
    if Resultado.SB = '+' then begin
        if Resultado.SZ = '+' then begin
          msg := 'INTENTO DE GIRO BAJISTA.';
//          if K[12] > K[11] then
//            msg := msg + ' CON RECUPERACIÓN.'
        end
        else begin
          if Resultado.SZ = '-' then begin
            msg := 'INDECISIÓN.';
//            if K[12] > K[11] then
//              msg := msg + ' CON ALZA MOMENTÁNEA.'
          end
          else begin
            msg := 'INDECISIÓN A LA BAJA.';
//            if K[12] > K[11] then
//              msg := msg + ' DILUYÉNDOSE.'
          end;
        end;
    end
    else begin
      if Resultado.SB = '-' then begin
        if Resultado.SZ = '+' then begin
          msg := 'GIRO BAJISTA.';
//          if K[12] > K[11] then
//            msg := msg + ' CON RECUPERACIÓN MOMENTÁNEA.'
        end
        else begin
          if Resultado.SZ = '-' then begin
            msg := 'BAJISTA.';
//            if K[12] > K[11] then
//              msg := msg + ' CON REPAROS.';
//            if Resultado.R14 > 75 then
//              msg := msg + ' GRÁFICO SOBRECOMPRADO.'
//            else
//              if Resultado.R14 < 25 then
//                msg := msg + ' PRECAUCIÓN: SOBREVENDIDO.';
          end
          else begin
            msg := 'GIRO BAJISTA DESDE RESISTENCIA.';
//            if K[12] > K[11] then
//              msg := msg + ' CON RECUPERACIÓN MOMENTÁNEA.'
          end;
        end;
      end
      else begin
        if Resultado.SZ = '+' then begin
          msg := 'INTENTO DE GIRO BAJISTA.';
//          if K[12] > K[11] then
//            msg := msg + ' MOMENTÁNEAMENTE FALLIDO.'
        end
        else begin
          if Resultado.SZ = '-' then begin
            msg := 'INTENTO DE ROTURA RESISTENCIA.';
//            if K[12] < K[11] then
//              msg := msg + ' FALLIDO.';
          end
          else begin
            msg := 'ROTURA DE SOPORTE.';
//            if K[12] > K[11] then
//              msg := msg + ' RECUPERÁNDOSE MOMENTÁNEAMENTE.'
          end;
        end;
      end;
    end;
  end;

  procedure SAIgual;
  begin
    if Resultado.SB = '+' then begin
        if Resultado.SZ = '+' then begin
          msg := 'DETECTADO SOPORTE.';
//          if K[12] < K[11] then
//            msg := msg + ' CON INTENTO DE SER ATACADO.'
        end
        else begin
          if Resultado.SZ = '-' then begin
            msg := 'ATAQUE A SOPORTE.';
//            if K[12] > K[11] then
//              msg := msg + ' CON REBOTE AL ALZA.';
          end
          else begin
            msg := 'SOPORTE. INTENTO DE PERFORACIÓN.';
//            if K[12] > K[11] then
//              msg := msg + ' FALLIDO.'
          end;
        end;
    end
    else begin
      if Resultado.SB = '-' then begin
        if Resultado.SZ = '+' then begin
          msg := 'ATAQUE A RESISTENCIA.';
//          if K[12] < K[11] then
//            msg := msg + ' FALLIDA.'
        end
        else begin
          if Resultado.SZ = '-' then begin
            msg := 'DETECTADA RESISTENCIA.';
//            if K[12] > K[11] then
//              msg := msg + ' CON INTENTO DE SER ATACADA.';
          end
          else begin
            msg := 'RESISTENCIA. INTENTO DE ROTURA AL ALZA.';
//            if K[12] < K[11] then
//              msg := msg + ' FALLIDO MOMENTÁNEAMENTE.'
          end;
        end;
      end
      else begin
        if Resultado.SZ = '+' then begin
          msg := 'SOPORTE DINÁMICO.';
//          if K[12] < K[11] then
//            msg := msg + ' CON INTENTO DE ROTURA.'
        end
        else begin
          if Resultado.SZ = '-' then begin
            msg := 'RESISTENCIA DINÁMICA.';
//            if K[12] > K[11] then
//              msg := msg + ' CON INTENTO DE PERFORACIÓN.';
          end
          else begin
            msg := 'INDEFINICIÓN';
//            if K[12] > K[11] then
//              msg := msg + ' ORIENTÁNDOSE AL ALZA.'
//            else
//              if K[12] < K[11] then
//                msg := msg + ' ORIENTÁNDOSE A LA BAJA.'
          end;
        end;
      end;
    end;
  end;
begin
  if Resultado.SA = '+' then
    SAMas
  else
    if Resultado.SA = '-' then
      SAMenos
    else
      SAIgual;

  if (Resultado.OSB < -100) and (Resultado.OSA < -100) then
    msg := msg + ' ACELERACIÓN BAJISTA.'
  else begin
    if (Resultado.OSB > 100) and (Resultado.OSA > 100) then
      msg := msg + ' ACELERACIÓN ALCISTA.'
  end;
  if Resultado.RSIA < 25 then
    msg := msg + ' GRÁFICO SOBREVENDIDO.'
  else begin
    if Resultado.RSIA > 75 then
      msg := msg + ' GRÁFICO SOBRECOMPRADO.';
  end;
  result := msg;
end;

procedure TEstrategia.Sort(var A: TArrayCurrency);
var
  aux: currency;
  i, num: Integer;
  Check: Boolean;
begin
  num := Length(A);
  dec(num);
  repeat
    Check := False;
    i := 0;
    repeat
      if A[i] > A[i+1] then begin
        aux := A[i];
        A[i] := A[i+1];
        A[i+1] := aux;
        Check := True;
      end;
      Inc(i);
    until (i >= num);
  until (not Check);
end;

procedure TEstrategia.SortDesc(var A: TArrayCurrency);
var
  aux: currency;
  i, num: Integer;
  Check: Boolean;
begin
  num := Length(A);
  dec(num);
  repeat
    Check := False;
    i := 0;
    repeat
      if A[i] < A[i+1] then begin
        aux := A[i];
        A[i] := A[i+1];
        A[i+1] := aux;
        Check := True;
      end;
      Inc(i);
    until (i >= num);
  until (not Check);
end;

end.
