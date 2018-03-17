unit dmRanquing;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery;

type
//  TResultado = array [1..47] of boolean;

  TPosicion = record
    OIDValor: integer;
//    Resultado: TResultado;
    Puntos: integer;
//    ResultadoAnt: TResultado;
    PuntosAnt: integer;
    Incremento: integer;
  end;

  TPosiciones = array of TPosicion;

  TRanquing = class(TDataModule)
    qData: TIBQuery;
    qSesionAnt: TIBQuery;
    qSesionAntFECHA: TDateField;
    qDataOR_VALOR: TSmallintField;
    qDataDINERO: TIBBCDField;
    qDataPAPEL: TIBBCDField;
    procedure DataModuleCreate(Sender: TObject);
  private
    FPosiciones: TPosiciones;
//    OMas, OMenos, AMas, AMenos, ABMas, ABMenos, BMas, BMenos: integer;
//    function GetResultado: TResultado;
  public
    procedure Calculate;
    procedure IrA(const i: integer);
    property resultado: TPosiciones read FPosiciones;
  end;

implementation

uses dmDataComun, dmBD, UtilDB, dmData, Controls;

{$R *.dfm}

{ TRanquing }

procedure TRanquing.Calculate;
var i, num: integer;
  sesion: TDate;

//  function GetPuntos(resultado: TResultado): integer;
//  var j: integer;
//  begin
//    result := 0;
//    for j := Low(TResultado) to High(TResultado) do begin
//      if Resultado[j] then
//        Inc(result);
//    end;
//  end;

    function GetPuntos: integer;
    var m, p, dinero, papel: currency;
    begin
//10 REM STRATEGICS POSITIONS (EP)
//20 EP=259560
//30 INPUT "MONEY";MON:IF MON>180 OR MON< O.25 THEN 30
//40 INPUT"PAPER"; PAP:IF PAP<O.25 OR PAP>180 THEN 40
//50 FOR M=180 TO 0.25 STEP - 0.25
//60 FOR P=0.25 TO 180 STEP + 0.25
//70 IF M+P>180.25 THEN 100
//80 IF M=MON AND P=PAP THEN CAPTURE=EP:GOTO 120
//90 EP=EP-1
//100 NEXT P
//110 NEXT M
//120 PRINT "ESTRATEGIC POSITION =";CAPTURE
      result := 259560;
      dinero := qDataDINERO.Value;
      papel := qDataPAPEL.Value;
      m := 180;
      while m >= 0.25 do begin
        p := 0.25;
        while p <= 180 do begin
          if m + p <= 180.25 then begin
            if (m = dinero) and (p = papel) then
              exit;
            dec(result);
          end;
          p := p + 0.25;
        end;
        m := m - 0.25;
      end;
    end;

begin
  sesion := Data.Sesion;
  qData.Close;
  qData.Params[0].AsDate := sesion;
  OpenDataSetRecordCount(qData);
  num := qData.RecordCount;
  SetLength(FPosiciones, num);
  dec(num);
  for i := 0 to num do begin
    FPosiciones[i].OIDValor := qDataOR_VALOR.Value;
//    FPosiciones[i].Resultado := GetResultado;
//    FPosiciones[i].Puntos := GetPuntos(FPosiciones[i].Resultado);
    FPosiciones[i].Puntos := GetPuntos;
    qData.Next;
  end;

  qSesionAnt.Params[0].AsDate := sesion;
  OpenDataSet(qSesionAnt);
  qData.Close;
  qData.Params[0].AsDate := qSesionAntFECHA.Value;
  OpenDataSet(qData);
  for i := 0 to num do begin
    if qData.Locate('OR_VALOR', FPosiciones[i].OIDValor, []) then begin
//      FPosiciones[i].ResultadoAnt := GetResultado;
  //    FPosiciones[i].PuntosAnt := GetPuntos(FPosiciones[i].ResultadoAnt);
      FPosiciones[i].PuntosAnt := GetPuntos;
      FPosiciones[i].Incremento := FPosiciones[i].Puntos - FPosiciones[i].PuntosAnt;
    end
    else begin
      FPosiciones[i].PuntosAnt := 0;
      FPosiciones[i].Incremento := 0;
    end;
  end;
  qData.Close;
end;

procedure TRanquing.DataModuleCreate(Sender: TObject);
begin
//  OMenos := DataComun.FindZona('0-');
//  OMas := DataComun.FindZona('0+');
//  BMenos := DataComun.FindZona('B-');
//  BMas := DataComun.FindZona('B+');
//  AMas := DataComun.FindZona('A+');
//  AMenos := DataComun.FindZona('A-');
//  ABMas := DataComun.FindZona('AB+');
//  ABMenos := DataComun.FindZona('AB-');
end;

{
qData

select c.*, ce.* from cotizacion c, cotizacion_estado ce, sesion s
where
c.oid_cotizacion = ce.or_cotizacion and
c.or_sesion = s.oid_sesion and
s.fecha = :FECHA


function TRanquing.GetResultado: TResultado;
var RSILargo, RSICorto: integer;
  RelVolVar: Double;
  papel, papelAlzaSimple, papelAlzaDoble, papelBajaSimple, papelBajaDoble: Currency;
  dinero, dineroAlzaSimple, dineroAlzaDoble, dineroBajaSimple, dineroBajaDoble: Currency;
  zona: integer;
  dobson130, dobson100, dobson70, dobson40, dobson10: integer;
  dobsonBajo130, dobsonBajo100, dobsonBajo70, dobsonBajo40, dobsonBajo10: integer;
  sumaDobson130, sumaDobson100, sumaDobson70, sumaDobson40, sumaDobson10: integer;

    function estaEnZonaNegativa(const zona: integer): Boolean;
    begin
      Result := (zona = OMenos) or (zona = AMenos) or (zona = ABMenos) or (zona = BMenos);
    end;

    function getNivel(const nivel: string): Integer;
    begin
      if nivel = 'A' then
        result := 10
      else
        result := StrToInt(nivel);
    end;
begin
    result[1] := qDataCIERRE.Value > qDataPIVOT_POINT.Value;
    result[2] := qDataMAXIMO.Value > qDataPIVOT_POINT_R1.Value;
    result[3] := qDataMINIMO.Value > qDataPIVOT_POINT_S1.Value;
    result[4] := qDataMAXIMO_PREVISTO_APROX.Value > 99.8;
    result[5] := qDataDIAS_SEGUIDOS_NUM.Value < 7;
    result[6] := false;
    result[7] := false;
    result[8] := false;
    result[9] := qDataDIMENSION_FRACTAL.Value > 1.46;
    result[10] := (not qDataPOTENCIAL_FRACTAL.IsNull) and
      (qDataPOTENCIAL_FRACTAL.Value >= 0);
    RSILargo := qDataRSI_140.Value;
    RSICorto := qDataRSI_14.Value;
    result[11] := (RSILargo > 50) and (RSICorto > RSILargo);
    result[12] := (RSILargo < 50) and (RSICorto < 30);
    result[13] := qDataCIERRE.Value > qDataMEDIA_200.Value;
    result[14] := false;
    result[15] := qDataBANDA_BAJA.Value < qDataMINIMO.Value;
    result[16] := qDataBANDA_ALTA.Value < qDataMAXIMO.Value;
    RelVolVar := qDataRELACION_VOL_VAR.Value;
    result[17] := (RelVolVar <= 1.01) and (RelVolVar >= 0.99);
    result[18] := (qDataVOLATILIDAD.Value > 1) and (qDataVARIABILIDAD.Value > 1);
    result[19] := false;
    result[20] := (getNivel(qDataNIVEL_SUBE.Value) + getNivel(qDataNIVEL_ACTUAL.Value) +
      getNivel(qDataNIVEL_BAJA.Value)) / 3 > 6;
    result[21] := false;
    papel := qDataPAPEL.Value;
    papelAlzaSimple := qDataPAPEL_ALZA_SIMPLE.Value;
    papelAlzaDoble := qDataPAPEL_ALZA_DOBLE.Value;
    papelBajaSimple := qDataPAPEL_BAJA_SIMPLE.Value;
    papelBajaDoble := qDataPAPEL_BAJA_DOBLE.Value;
    result[22] := (papel = 0.25) and (papelAlzaSimple = 0.25) and (papelAlzaDoble = 0.25) and
      (papelBajaSimple = 0.25) and (papelBajaDoble = 0.25);
    dinero := qDataDINERO.Value;
    dineroAlzaSimple := qDataDINERO_ALZA_SIMPLE.Value;
    dineroAlzaDoble := qDataDINERO_ALZA_DOBLE.Value;
    dineroBajaSimple := qDataDINERO_BAJA_SIMPLE.Value;
    dineroBajaDoble := qDataDINERO_BAJA_DOBLE.Value;
    result[23] := (result[22]) and (dineroAlzaSimple > dinero) and (dineroAlzaDoble > dinero);
    zona := qDataZONA.AsInteger;
    result[24] := ((zona = OMas) or (zona = AMas) or (zona = AMenos)) and
      (dinero >= 174) and (papel <= 6.25);
    result[25] := (zona = AMas) and (dinero > 120) and (dinero <= 172) and (papel <= 6.25);
    result[26] := (zona = ABMas) and (dinero <= 66.25) and (papel <= 6.25);
    result[27] := (zona = BMas) and (
      ((dinero = 0.5) and (papel = 106.25)) or ((dinero = 0.25) and (papel = 106.5)));
    result[28] := (zona = ABMenos) and (papel < 66.25) and (papel >= 6.25) and (dinero < 6.25);
    result[29] := (zona = ABMenos) and (dinero < 90.25) and (papel < 6.25);
    result[30] := (zona = AMenos) and (dinero > 120) and (dinero < 150);
    result[31] := (qDataPRESION_VERTICAL_BAJA_SIMPLE.Value = 0) and
      (qDataPRESION_VERTICAL_BAJA_DOBLE.Value = 0) and
      (qDataPRESION_LATERAL_BAJA_SIMPLE.Value = 0) and
      (qDataPRESION_LATERAL_BAJA_DOBLE.Value = 0);
    result[32] := (qDataPRESION_VERTICAL_ALZA_DOBLE.Value > qDataPRESION_VERTICAL.Value) and
      (qDataPRESION_LATERAL_ALZA_DOBLE.Value < qDataPRESION_LATERAL.Value);
    result[33] := (dinero > 0.25) and (dinero = dineroAlzaSimple) and
      (dinero = dineroAlzaDoble) and (dinero = dineroBajaSimple) and (dinero = dineroBajaDoble) and
      (papel > dinero) and (papelAlzaSimple > dineroAlzaSimple) and
      (papelAlzaDoble > dineroAlzaDoble) and (papelBajaSimple > dineroBajaSimple) and
      (papelBajaDoble > dineroBajaDoble);
    dobson130 := qDataDOBSON_130.Value;
    dobson100 := qDataDOBSON_100.Value;
    dobson70 := qDataDOBSON_70.Value;
    dobson40 := qDataDOBSON_40.Value;
    dobson10 := qDataDOBSON_10.Value;
    result[34] := (dobson130 > dobson100) and (dobson100 > dobson70) and
      (dobson70 > dobson40) and (dobson40 > dobson10);
    dobsonBajo130 := qDataDOBSON_BAJO_130.Value;
    dobsonBajo100 := qDataDOBSON_BAJO_100.Value;
    dobsonBajo70 := qDataDOBSON_BAJO_70.Value;
    dobsonBajo40 := qDataDOBSON_BAJO_40.Value;
    dobsonBajo10 := qDataDOBSON_BAJO_10.Value;
    result[35] := (dobsonBajo130 > dobsonBajo100) and (dobsonBajo100 > dobsonBajo70) and
      (dobsonBajo70 > dobsonBajo40) and (dobsonBajo40 > dobsonBajo10);
    result[36] := False;
    result[37] := false;
    result[38] := (estaEnZonaNegativa(zona)) and
      (not estaEnZonaNegativa(qDataZONA_ALZA_SIMPLE.AsInteger)) and
      (not estaEnZonaNegativa(qDataZONA_ALZA_DOBLE.AsInteger));
    result[39] := false;
    result[40] := false;
    result[41] := false;
    result[42] := false;
    result[43] := false;
    result[44] := false;
    result[45] := false; // ¿ELIMINADO?
    result[46] := false;
    sumaDobson130 := dobson130 + dobsonBajo130 + qDataDOBSON_ALTO_130.Value;
    sumaDobson100 := dobson100 + dobsonBajo100 + qDataDOBSON_ALTO_100.Value;
    sumaDobson70 := dobson70 + dobsonBajo70 + qDataDOBSON_ALTO_70.Value;
    sumaDobson40 := dobson40 + dobsonBajo40 + qDataDOBSON_ALTO_40.Value;
    sumaDobson10 := dobson10 + dobsonBajo10 + qDataDOBSON_ALTO_10.Value;
    result[47] := (sumaDobson130 > sumaDobson100) and (sumaDobson100 > sumaDobson70) and
      (sumaDobson70 > sumaDobson40) and (sumaDobson40 > sumaDobson10);
end;
}

procedure TRanquing.IrA(const i: integer);
begin
  Data.IrAValor(FPosiciones[i].OIDValor);
end;

//procedure TRanquing.qDataCalcFields(DataSet: TDataSet);
//var variabilidad: currency;
//begin
//  variabilidad := qDataVARIABILIDAD.Value;
//  if variabilidad = 0 then
//    qDataRELACION_VOL_VAR.Clear
//  else
//    qDataRELACION_VOL_VAR.Value := qDataVOLATILIDAD.Value / variabilidad;
//end;

end.
