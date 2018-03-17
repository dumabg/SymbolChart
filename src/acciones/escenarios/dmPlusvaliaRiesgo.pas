unit dmPlusvaliaRiesgo;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery;

type
  TDataPlusvaliaRiesgo = record
    OIDValor: Integer;
    plusvalia: Currency;
    riesgo: Currency;
  end;

  TArrayDataPlusvaliaRiesgo= array of TDataPlusvaliaRiesgo;
  PArrayDataPlusvaliaRiesgo = ^TArrayDataPlusvaliaRiesgo;

  TPlusvaliaRiesgo = class(TDataModule)
    Cotizacion: TIBQuery;
    CotizacionCIERRE: TIBBCDField;
  private
    ArrayData: TArrayDataPlusvaliaRiesgo;
    function GetPDataPlusvaliaRiesgo: PArrayDataPlusvaliaRiesgo;
    function GetCount: integer;
    procedure calcularPlusvaliaRiesgo(const i: integer);
  public
    procedure calculate;
    procedure IrA(const i: integer);
    property PDataPlusvaliaRiesgo: PArrayDataPlusvaliaRiesgo read GetPDataPlusvaliaRiesgo;
    property Count: integer read GetCount;
  end;


implementation

uses dmBD, dmData, UtilDB, Tipos, Escenario;

{$R *.dfm}

{ TPlusvaliaRiesgo }

procedure TPlusvaliaRiesgo.calcularPlusvaliaRiesgo(const i: integer);
var cambios: TArrayCurrency;
  j, num: integer;
  fieldCierre: TCurrencyField;
  escenarioMultipleCreator: TEscenarioMultipleCreator;
  escenarioMultiple: TEscenarioMultiple;
begin
  num := Cotizacion.RecordCount;
  SetLength(cambios, num);
  dec(num);
  //Minimo numero de cambios
  if num <= 30 then begin
    ArrayData[i].plusvalia := 0;
    ArrayData[i].riesgo := 0;
  end
  else begin
    fieldCierre := TCurrencyField(Cotizacion.Fields[0]);
    Cotizacion.First;
    for j := 0 to num do begin
      cambios[j] := fieldCierre.Value;
      Cotizacion.Next;
    end;
    escenarioMultipleCreator := TEscenarioMultipleCreator.Create;
    try
      escenarioMultipleCreator.Cambios := @cambios;
      escenarioMultipleCreator.CrearEscenarioMultiple;
      escenarioMultiple := escenarioMultipleCreator.EscenarioMultiple;
      try
        ArrayData[i].plusvalia := escenarioMultiple.PlusvaliaMaxima;
        ArrayData[i].riesgo := escenarioMultiple.Riesgo;
      finally
        escenarioMultiple.Free;
      end;
    finally
      escenarioMultipleCreator.Free;
    end;
  end;
end;

procedure TPlusvaliaRiesgo.calculate;
var dataSet: TDataSet;
  inspect: TInspectDataSet;
  i, num, OIDValor: integer;
  fieldOIDValor: TIntegerField;
  paramOIDValor: TParam;
begin
  dataSet := Data.Valores;
  inspect := StartInspectDataSet(dataSet);
  try
    fieldOIDValor := TIntegerField(dataSet.FieldByName('OID_VALOR'));
    paramOIDValor := Cotizacion.Params[0];
    num := dataSet.RecordCount;
    SetLength(ArrayData, num);
    dec(num);
    dataSet.First;
    for i := 0 to num do begin
      OIDValor := fieldOIDValor.Value;
      ArrayData[i].OIDValor := OIDValor;
      Cotizacion.Close;
      paramOIDValor.AsInteger := OIDValor;
      OpenDataSetRecordCount(Cotizacion);
      calcularPlusvaliaRiesgo(i);
      dataSet.Next;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;


function TPlusvaliaRiesgo.GetCount: integer;
begin
  result := length(ArrayData);
end;

function TPlusvaliaRiesgo.GetPDataPlusvaliaRiesgo: PArrayDataPlusvaliaRiesgo;
begin
  Result := @ArrayData;
end;

procedure TPlusvaliaRiesgo.IrA(const i: integer);
var OIDValor: integer;
begin
  OIDValor := ArrayData[i].OIDValor;
  if Data.OIDValor <> OIDValor then
    Data.IrAValor(OIDValor);
end;

end.
