unit dmPanelRanquing;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmThreadDataModule, Grafico, DB, IBCustomDataSet, IBQuery, Tipos;

type
  TPanelRanquing = class(TThreadDataModule)
    qRanquing: TIBQuery;
    qRanquingDINERO: TIBBCDField;
    qRanquingPAPEL: TIBBCDField;
    qRanquingFECHA: TDateField;
  private
    Cambios: TArrayCurrency;
    FGrafico: TGrafico;
    FGraficoPrincipal: TGrafico;
    procedure SetGrafico(const Value: TGrafico);
    function GetPuntuacion: integer;
  public
    procedure LaunchQuery;
    procedure LoadData;
    property Grafico: TGrafico read FGrafico write SetGrafico;
    property GraficoPrincipal: TGrafico read FGraficoPrincipal write FGraficoPrincipal;
  end;

implementation

uses dmData, DatosGrafico, UtilDB, dmDataComun;

{$R *.dfm}


{ TPanelRanquing }

function TPanelRanquing.GetPuntuacion: integer;
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
      dinero := qRanquingDINERO.Value;
      papel := qRanquingPAPEL.Value;
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

procedure TPanelRanquing.LaunchQuery;
begin
  qRanquing.Close;
  qRanquing.Params[0].AsInteger := Data.OIDValor;
  qRanquing.Open;
end;

procedure TPanelRanquing.LoadData;
var i, num: integer;
  pFechas: PArrayDate;
  fecha: TDate;
  inspect: TInspectDataSet;
begin
  num := GraficoPrincipal.Datos.DataCount;
  SetLength(Cambios, num);
  pFechas := GraficoPrincipal.Datos.PFechas;
  i := 0;
  inspect := StartInspectDataSet(qRanquing);
  try
    while (not qRanquing.Eof) and (i < num) do begin
      fecha := qRanquingFECHA.Value;
      if pFechas^[i] = fecha then begin
        Cambios[i] := GetPuntuacion;
        inc(i);
        qRanquing.Next;
      end
      else begin
        if pFechas^[i] < fecha then begin
          Cambios[i] := SIN_CAMBIO;
          inc(i);
        end
        else
          qRanquing.Next;
      end;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
  while i < num do begin
    Cambios[i] := SIN_CAMBIO;
    inc(i);
  end;
  Grafico.SetData(@Cambios, pFechas);
end;

procedure TPanelRanquing.SetGrafico(const Value: TGrafico);
begin
  FGrafico := Value;
end;

end.
