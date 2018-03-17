unit dmBaseBuscar;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, kbmMemTable;

const
  TAG_BANDERA = -1;
  TAG_BUSQUEDA = 1;

type
  TBaseBuscar = class(TDataModule)
    Valores: TkbmMemTable;
    ValoresOID_VALOR: TSmallintField;
    ValoresOID_MERCADO: TSmallintField;
    ValoresNOMBRE: TIBStringField;
    ValoresSIMBOLO: TIBStringField;
    ValoresDECIMALES: TSmallintField;
    ValoresMERCADO: TIBStringField;
    procedure ValoresFilterRecord(DataSet: TDataSet; var Accept: Boolean);
  private
    Busqueda: string;
    Fields: array of TField;
    procedure SetFiltrado(const Value: boolean);
    function GetFiltrado: boolean;
  protected
    procedure LoadValores; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure BuscarFiltrado(busqueda: string);
    property Filtrado: boolean read GetFiltrado write SetFiltrado;
  end;


implementation

uses dmData;

{$R *.dfm}

{ TBaseBuscarValor }

{ TBaseBuscar }

procedure TBaseBuscar.BuscarFiltrado(busqueda: string);
begin
  Self.Busqueda := UpperCase(busqueda);
  if Valores.Filtered then
    Valores.Refresh
  else
    Valores.Filtered := true;
end;

constructor TBaseBuscar.Create(AOwner: TComponent);
var i, num, numFields: integer;
  field: TField;
begin
  inherited Create(AOwner);
  LoadValores;
  ValoresMERCADO.Tag := TAG_BANDERA;
  ValoresNOMBRE.Tag := TAG_BUSQUEDA;
  ValoresSIMBOLO.Tag := TAG_BUSQUEDA;

  num := Valores.Fields.Count - 1;
  numFields := 0;
  for i := 0 to num do begin
    field := Valores.Fields[i];
    if field.Tag = 1 then begin
      inc(numFields);
      SetLength(Fields, numFields);
      Fields[numFields - 1] := field;
    end;
  end;
end;

function TBaseBuscar.GetFiltrado: boolean;
begin
  result := Valores.Filtered;
end;

procedure TBaseBuscar.LoadValores;
begin
  Valores.AttachedTo := Data.Valores;
  Valores.Open;
end;

procedure TBaseBuscar.SetFiltrado(const Value: boolean);
begin
  Valores.Filtered := Value;
end;

procedure TBaseBuscar.ValoresFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
var i, num: integer;
begin
  Accept := false;
  num := length(Fields) - 1;
  for i := 0 to num do begin
    Accept := Pos(busqueda, UpperCase(Fields[i].AsString)) > 0;
    if Accept then
      exit;
  end;
end;

end.
