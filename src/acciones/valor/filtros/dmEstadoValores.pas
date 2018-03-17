unit dmEstadoValores;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery;

type
  TEstadoValores = class(TDataModule)
  private
    FMasterData: TIBQuery;
    procedure SetMasterData(const Value: TIBQuery);
  protected
    ValoresOID_COTIZACION: TIntegerField;
    ValoresOR_VALOR: TIntegerField;
    ValoresCIERRE: TIBBCDField;
    ValoresOR_SESION: TIntegerField;
    ValoresOID1: TIntegerField;
    ValoresZONA_ALZA_DOBLE: TStringField;
    ValoresZONA_ALZA_SIMPLE: TStringField;
    ValoresZONA_BAJA_DOBLE: TStringField;
    ValoresZONA_BAJA_SIMPLE: TStringField;
    ValoresZONA: TStringField;
    ValoresVOLATILIDAD: TIBBCDField;
    ValoresVARIABILIDAD: TIBBCDField;
    ValoresBANDA_ALTA: TIBBCDField;
    ValoresBANDA_BAJA: TIBBCDField;
    ValoresRSI_140: TIntegerField;
    ValoresRSI_14: TIntegerField;
    ValoresDOBSON_ALTO_130: TIntegerField;
    ValoresDOBSON_ALTO_100: TIntegerField;
    ValoresDOBSON_ALTO_70: TIntegerField;
    ValoresDOBSON_ALTO_40: TIntegerField;
    ValoresDOBSON_ALTO_10: TIntegerField;
    ValoresDOBSON_130: TIntegerField;
    ValoresDOBSON_100: TIntegerField;
    ValoresDOBSON_70: TIntegerField;
    ValoresDOBSON_40: TIntegerField;
    ValoresDOBSON_10: TIntegerField;
    ValoresDOBSON_BAJO_130: TIntegerField;
    ValoresDOBSON_BAJO_100: TIntegerField;
    ValoresDOBSON_BAJO_70: TIntegerField;
    ValoresDOBSON_BAJO_40: TIntegerField;
    ValoresDOBSON_BAJO_10: TIntegerField;
    ValoresMAXIMO_PREVISTO: TIBBCDField;
    ValoresMINIMO_PREVISTO: TIBBCDField;
    ValoresMAXIMO: TIBBCDField;
    ValoresMINIMO: TIBBCDField;
    ValoresMAXIMO_SE_PREVINO: TIBBCDField;
    ValoresMINIMO_SE_PREVINO: TIBBCDField;
    ValoresOR_COTIZACION: TIntegerField;
    ValoresDINERO: TIBBCDField;
    ValoresDINERO_ALZA_DOBLE: TIBBCDField;
    ValoresDINERO_BAJA_DOBLE: TIBBCDField;
    ValoresDINERO_BAJA_SIMPLE: TIBBCDField;
    ValoresDINERO_ALZA_SIMPLE: TIBBCDField;
    ValoresPAPEL: TIBBCDField;
    ValoresPAPEL_ALZA_DOBLE: TIBBCDField;
    ValoresPAPEL_ALZA_SIMPLE: TIBBCDField;
    ValoresPAPEL_BAJA_DOBLE: TIBBCDField;
    ValoresPAPEL_BAJA_SIMPLE: TIBBCDField;
    ValoresOID2: TIntegerField;
  public
    property MasterData: TIBQuery read FMasterData write SetMasterData;
  end;


implementation

{$R *.dfm}

procedure TEstadoValores.SetMasterData(const Value: TIBQuery);
begin
  FMasterData := Value;
  with FMasterData.Fields do begin
    ValoresOID_COTIZACION := TIntegerField(FieldByName('OID_COTIZACION'));
    ValoresOR_VALOR := TIntegerField(FieldByName('OR_VALOR'));
    ValoresCIERRE := TIBBCDField(FieldByName('CIERRE'));
    ValoresOR_SESION := TIntegerField(FieldByName('OR_SESION'));
    ValoresZONA_ALZA_DOBLE := TStringField(FieldByName('ZONA_ALZA_DOBLE'));
    ValoresZONA_ALZA_SIMPLE := TStringField(FieldByName('ZONA_ALZA_SIMPLE'));
    ValoresZONA_BAJA_DOBLE := TStringField(FieldByName('ZONA_BAJA_DOBLE'));
    ValoresZONA_BAJA_SIMPLE := TStringField(FieldByName('ZONA_BAJA_SIMPLE'));
    ValoresZONA := TStringField(FieldByName('ZONA'));
    ValoresVOLATILIDAD := TIBBCDField(FieldByName('VOLATILIDAD'));
    ValoresVARIABILIDAD := TIBBCDField(FieldByName('VARIABILIDAD'));
    ValoresBANDA_ALTA := TIBBCDField(FieldByName('BANDA_ALTA'));
    ValoresBANDA_BAJA := TIBBCDField(FieldByName('BANDA_BAJA'));
    ValoresRSI_140 := TIntegerField(FieldByName('RSI_140'));
    ValoresRSI_14 := TIntegerField(FieldByName('RSI_14'));
    ValoresDOBSON_ALTO_130 := TIntegerField(FieldByName('DOBSON_ALTO_130'));
    ValoresDOBSON_ALTO_100 := TIntegerField(FieldByName('DOBSON_ALTO_100'));
    ValoresDOBSON_ALTO_70 := TIntegerField(FieldByName('DOBSON_ALTO_70'));
    ValoresDOBSON_ALTO_40 := TIntegerField(FieldByName('DOBSON_ALTO_40'));
    ValoresDOBSON_ALTO_10 := TIntegerField(FieldByName('DOBSON_ALTO_10'));
    ValoresDOBSON_130 := TIntegerField(FieldByName('DOBSON_130'));
    ValoresDOBSON_100 := TIntegerField(FieldByName('DOBSON_100'));
    ValoresDOBSON_70 := TIntegerField(FieldByName('DOBSON_70'));
    ValoresDOBSON_40 := TIntegerField(FieldByName('DOBSON_40'));
    ValoresDOBSON_10 := TIntegerField(FieldByName('DOBSON_10'));
    ValoresDOBSON_BAJO_130 := TIntegerField(FieldByName('DOBSON_BAJO_130'));
    ValoresDOBSON_BAJO_100 := TIntegerField(FieldByName('DOBSON_BAJO_100'));
    ValoresDOBSON_BAJO_70 := TIntegerField(FieldByName('DOBSON_BAJO_70'));
    ValoresDOBSON_BAJO_40 := TIntegerField(FieldByName('DOBSON_BAJO_40'));
    ValoresDOBSON_BAJO_10 := TIntegerField(FieldByName('DOBSON_BAJO_10'));
    ValoresMAXIMO_PREVISTO := TIBBCDField(FieldByName('MAXIMO_PREVISTO'));
    ValoresMINIMO_PREVISTO := TIBBCDField(FieldByName('MINIMO_PREVISTO'));
    ValoresMAXIMO := TIBBCDField(FieldByName('MAXIMO'));
    ValoresMINIMO := TIBBCDField(FieldByName('MINIMO'));
    ValoresMAXIMO_SE_PREVINO := TIBBCDField(FieldByName('MAXIMO_SE_PREVINO'));
    ValoresMINIMO_SE_PREVINO := TIBBCDField(FieldByName('MINIMO_SE_PREVINO'));
    ValoresDINERO := TIBBCDField(FieldByName('DINERO'));
    ValoresDINERO_ALZA_DOBLE := TIBBCDField(FieldByName('DINERO_ALZA_DOBLE'));
    ValoresDINERO_BAJA_DOBLE := TIBBCDField(FieldByName('DINERO_BAJA_DOBLE'));
    ValoresDINERO_BAJA_SIMPLE := TIBBCDField(FieldByName('DINERO_BAJA_SIMPLE'));
    ValoresDINERO_ALZA_SIMPLE := TIBBCDField(FieldByName('DINERO_ALZA_SIMPLE'));
    ValoresPAPEL := TIBBCDField(FieldByName('PAPEL'));
    ValoresPAPEL_ALZA_DOBLE := TIBBCDField(FieldByName('PAPEL_ALZA_DOBLE'));
    ValoresPAPEL_ALZA_SIMPLE := TIBBCDField(FieldByName('PAPEL_ALZA_SIMPLE'));
    ValoresPAPEL_BAJA_DOBLE := TIBBCDField(FieldByName('PAPEL_BAJA_DOBLE'));
    ValoresPAPEL_BAJA_SIMPLE := TIBBCDField(FieldByName('PAPEL_BAJA_SIMPLE'));
  end;
end;

end.
