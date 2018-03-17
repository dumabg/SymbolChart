unit dmFiltroFactory;

interface

uses
  SysUtils, Classes, dmFiltro, DB,  
  IBCustomDataSet, IBQuery, dmEstadoValoresFactory, dmEstadoValores, controls;

type
  TFiltroClass = class of TFiltro;

  TFiltrosFactory = class(TEstadoValoresFactory)
    procedure DataModuleDestroy(Sender: TObject);
    procedure ValoresAfterOpen(DataSet: TDataSet);
    procedure dsCotizacionEstadoDataChange(Sender: TObject; Field: TField);
  private
    filtros: TStringList;
    fecha: TDate;
  protected
    procedure recalculate;
  public
    constructor Create(AOwner: TComponent); override;
    function getFiltro(FiltroClass: TFiltroClass): TFiltro;
    procedure Clear;
  end;


function getFiltrosFactory: TFiltrosFactory;
procedure deleteFiltros;

implementation

uses dmBD, dialogs, dmData;

{$R *.dfm}

function getFiltrosFactory: TFiltrosFactory;
begin
  result := TFiltrosFactory(getEstadoValoresFactory(TFiltrosFactory));
end;

procedure deleteFiltros;
begin
  deleteEstadoValoresFactory;
end;

{ TFiltrosFactory }

function TFiltrosFactory.getFiltro(FiltroClass: TFiltroClass): TFiltro;
var className: string;
  pos: integer;
begin
  className := FiltroClass.ClassName;
  pos := filtros.IndexOf(className);
  if pos = -1 then begin
    result := FiltroClass.Create(Self);
    result.MasterData := Valores;
    filtros.AddObject(className, result);
  end
  else
    result := filtros.Objects[pos] as TFiltro;
  if not result.ValoresFiltrados.Active then
    result.calculate;
end;

procedure TFiltrosFactory.DataModuleDestroy(Sender: TObject);
begin
  filtros.Free;
  inherited;
end;


procedure TFiltrosFactory.ValoresAfterOpen(DataSet: TDataSet);
begin
  inherited;
  recalculate;
end;


procedure TFiltrosFactory.dsCotizacionEstadoDataChange(Sender: TObject;
  Field: TField);
{var filtro: TFiltro;
 i: integer;}
begin
  inherited;
{  if data.CotizacionFECHA.Value <> fecha then begin
    i := 0;
    while i < filtros.Count do begin
      filtro := filtros.Objects[i] as TFiltro;
      if not filtro.Enabled then begin
        filtro.Free;
        filtros.Delete(i);
      end
      else
        inc(i);
    end;
    if filtros.Count > 0 then begin
      reloadValores;
      recalculate;
    end;
    while filtros.Count > 0 do begin
      filtros.Objects[0].Free;
      filtros.Delete(0);
    end;
    getEstadoValoresFactory(TFiltrosFactory).Clear;
    fecha := data.CotizacionFECHA.Value;
  end;}
end;

constructor TFiltrosFactory.Create(AOwner: TComponent);
begin
  filtros := TStringList.Create;
  fecha := Data.Sesion;
  inherited;
end;

procedure TFiltrosFactory.recalculate;
var i, num: integer;
  filtro: TFiltro;
begin
  inherited;
  num := filtros.Count - 1;
  for i:=0 to num do begin
    filtro := filtros.Objects[i] as TFiltro;
    filtro.MasterData := Valores;
    filtro.calculate;
  end;
end;


procedure TFiltrosFactory.Clear;
begin
  while filtros.Count > 0 do begin
    filtros.Objects[0].Free;
    filtros.Delete(0);
  end;
  deleteEstadoValoresFactory;
end;

end.
