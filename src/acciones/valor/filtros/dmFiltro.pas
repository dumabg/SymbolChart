unit dmFiltro;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet,
  IBQuery, dmEstadoValores, kbmMemTable;

type
  TFiltro = class(TEstadoValores)
    ValoresFiltrados: TkbmMemTable;
    ValoresFiltradosOR_VALOR: TIntegerField;
    ValoresFiltradosSIMBOLO: TStringField;
    ValoresFiltradosNOMBRE: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    Calculated: boolean;
    procedure ValorSeleccionado;
  protected
    procedure InternalCalculate; virtual;
    function ValorInFilter: boolean; virtual; abstract;
    function GetDescripcion: string; virtual; abstract;
  public
    procedure calculate;
    function HasData: boolean;
    property Descripcion: string read getDescripcion;
  end;


implementation

uses dmFiltroFactory, dmData, Variants, UtilDB, dmDataComun;

{$R *.dfm}

{ TFiltro }

procedure TFiltro.calculate;
begin
  InternalCalculate;
  calculated := true;
end;

function TFiltro.HasData: boolean;
begin
  if not Calculated then
    InternalCalculate;
  result := (ValoresFiltrados <> nil) and (not (ValoresFiltrados.Eof and ValoresFiltrados.Bof));
end;

procedure TFiltro.InternalCalculate;
var oidField: TField;
  mainData: TDataSet;
  aux: Variant;
  inspect: TInspectDataSets;
begin
  mainData := data.Valores;
  inspect := StartInspectDataSets([ValoresFiltrados, mainData, MasterData]);
  try
    ValoresFiltrados.Close;
    ValoresFiltrados.Open;
    MasterData.First;
    oidField := MasterData.FieldByName('OR_VALOR');
    while not MasterData.Eof do begin
      aux := mainData.Lookup('OID_VALOR', oidField.AsInteger, 'OID_VALOR');
      if  aux <> Null then
        if ValorInFilter then
          ValorSeleccionado;
      MasterData.Next;
    end;
    Calculated := true;
  finally
    EndInspectDataSets(inspect);
  end;
end;

procedure TFiltro.ValorSeleccionado;
var filtroField, field: TField;
  num, i: integer;
  pDataComun: PDataComunValor;
begin
  ValoresFiltrados.Append;
  num := ValoresFiltrados.Fields.Count - 1;
  for i:=0 to num do begin
    filtroField := ValoresFiltrados.Fields[i];
    field := MasterData.FindField(filtroField.FieldName);
    if field <> nil then
      filtroField.Value := field.Value;
  end;
  pDataComun := DataComun.FindValor(ValoresFiltradosOR_VALOR.Value);
  ValoresFiltradosSIMBOLO.Value := pDataComun^.Simbolo;
  ValoresFiltradosNOMBRE.Value := pDataComun^.Nombre;
  ValoresFiltrados.Post;
end;

procedure TFiltro.DataModuleCreate(Sender: TObject);
begin
  Calculated := false;
end;



end.
