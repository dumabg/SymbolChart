unit dmStopsManuales;

interface

uses
  SysUtils, Classes, IBCustomDataSet, DB, IBQuery, kbmMemTable,
  IBSQL, UtilDB;

type
  TStopsManuales = class(TDataModule)
    Valores: TkbmMemTable;
    ValoresOID_VALOR: TSmallintField;
    ValoresOID_MERCADO: TSmallintField;
    ValoresNOMBRE: TIBStringField;
    ValoresSIMBOLO: TIBStringField;
    ValoresDECIMALES: TSmallintField;
    ValoresMERCADO: TIBStringField;
    qStops: TIBQuery;
    qStopsOID_STOP: TIntegerField;
    qStopsLARGO_CORTO: TIBStringField;
    qStopsCAMBIO: TIBBCDField;
    qStopsSTOP: TIBBCDField;
    qStopsPER_CENT_GANA: TIntegerField;
    qStopsPER_CENT_PIERDE: TIntegerField;
    qStopsOR_VALOR: TIntegerField;
    qStopsPOSICION_INICIAL: TIBBCDField;
    uStops: TIBSQL;
    iStops: TIBSQL;
    dStops: TIBSQL;
    Stops: TkbmMemTable;
    StopsOID_STOP: TIntegerField;
    StopsLARGO_CORTO: TIBStringField;
    StopsCAMBIO: TIBBCDField;
    StopsSTOP: TIBBCDField;
    StopsPER_CENT_GANA: TIntegerField;
    StopsPER_CENT_PIERDE: TIntegerField;
    StopsOR_VALOR: TIntegerField;
    StopsPOSICION_INICIAL: TIBBCDField;
    StopsGANANCIA: TCurrencyField;
    StopsVALOR: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure ValoresAfterScroll(DataSet: TDataSet);
    procedure StopsNewRecord(DataSet: TDataSet);
    procedure DataModuleDestroy(Sender: TObject);
    procedure StopsBeforePost(DataSet: TDataSet);
    procedure StopsCalcFields(DataSet: TDataSet);
  private
    oidGenerator: TOIDGenerator;
    procedure FindValor;
    procedure CalcularGanancia;
  public
    procedure GuardarCambios;
    procedure AnadirStopManual(const largo: boolean);
    procedure BorrarStopManual;
  end;


implementation

uses dmBD, dmData, dmDataComun, UtilDBSC;

{$R *.dfm}

procedure TStopsManuales.AnadirStopManual(const largo: boolean);
begin
  if not (Stops.State in dsEditModes) then
    Stops.Edit;
  if largo then
    StopsLARGO_CORTO.Value := 'L'
  else
    StopsLARGO_CORTO.Value := 'C';
  StopsOR_VALOR.Value := ValoresOID_VALOR.Value;
  Stops.Post;
  AssignParams(Stops, iStops);
  ExecQuery(iStops, true);
end;

procedure TStopsManuales.BorrarStopManual;
begin
  AssignParams(Stops, dStops);
  Stops.Delete;
  ExecQuery(dStops, true);
end;

procedure TStopsManuales.CalcularGanancia;
begin
  if (StopsCAMBIO.IsNull) or (StopsPOSICION_INICIAL.IsNull) then
    StopsGANANCIA.Clear
  else
    if StopsLARGO_CORTO.Value = 'L' then
      StopsGANANCIA.Value :=  (StopsCAMBIO.Value / StopsPOSICION_INICIAL.Value - 1) * 100
    else
      StopsGANANCIA.Value :=  (StopsPOSICION_INICIAL.Value / StopsCAMBIO.Value - 1) * 100;
end;

procedure TStopsManuales.DataModuleCreate(Sender: TObject);
begin
  oidGenerator := TOIDGenerator.Create(scdUsuario, 'STOP');
  Valores.Open;
  qStops.Open;
  Stops.LoadFromDataSet(qStops, []);
  Stops.OnNewRecord := StopsNewRecord;
end;

procedure TStopsManuales.DataModuleDestroy(Sender: TObject);
begin
  oidGenerator.Free;
end;

procedure TStopsManuales.FindValor;
var valor: PDataComunValor;
begin
  if not StopsOR_VALOR.IsNull then begin
    valor := DataComun.FindValor(StopsOR_VALOR.Value);
    StopsVALOR.Value := valor^.Simbolo + ' - ' + valor^.Nombre;
  end;
end;

procedure TStopsManuales.StopsBeforePost(DataSet: TDataSet);
var variacion, perCent: currency;
begin
  if Stops.State = dsEdit then begin
    variacion := StopsCAMBIO.Value - StopsCAMBIO.OldValue;
    if ((StopsLARGO_CORTO.Value = 'L') and (variacion > 0)) or
       ((StopsLARGO_CORTO.Value = 'C') and (variacion < 0)) then
      perCent := variacion * StopsPER_CENT_GANA.Value / 100
    else
      if ((StopsLARGO_CORTO.Value = 'L') and (variacion < 0)) or
         ((StopsLARGO_CORTO.Value = 'C') and (variacion > 0)) then
        perCent := variacion * StopsPER_CENT_PIERDE.Value / 100
      else
        perCent := 0;
    if (perCent < 0) and (StopsLARGO_CORTO.Value = 'L') then
      perCent := - perCent
    else
      if (perCent > 0) and (StopsLARGO_CORTO.Value = 'C') then
        perCent := -perCent;
    StopsSTOP.Value := StopsSTOP.Value + perCent;
  end;
end;

procedure TStopsManuales.StopsCalcFields(DataSet: TDataSet);
begin
  CalcularGanancia;
  FindValor;
end;

procedure TStopsManuales.StopsNewRecord(DataSet: TDataSet);
begin
  StopsOR_VALOR.Value := ValoresOID_VALOR.Value;
  StopsLARGO_CORTO.Value := 'L';
  StopsOID_STOP.Value := oidGenerator.NextOID;
end;

procedure TStopsManuales.ValoresAfterScroll(DataSet: TDataSet);
begin
  if Stops.State in dsEditModes then
    StopsOR_VALOR.Value := ValoresOID_VALOR.Value;
end;

procedure TStopsManuales.GuardarCambios;
begin
  Stops.Post;
  uStops.ParamByName('CAMBIO').AsCurrency := StopsCAMBIO.Value;
  uStops.ParamByName('PER_CENT_GANA').AsInteger := StopsPER_CENT_GANA.AsInteger;
  uStops.ParamByName('PER_CENT_PIERDE').AsInteger := StopsPER_CENT_PIERDE.AsInteger;
  uStops.ParamByName('STOP').AsCurrency := StopsSTOP.Value;
  uStops.ParamByName('OID_STOP').AsInteger := StopsOID_STOP.Value;
  ExecQuery(uStops, true);
end;

end.
