unit dmFiltros;

interface

uses
  SysUtils, Classes, DB, dmFiltro, kbmMemTable;

type
  TFiltroClass = class of TFiltro;

  TFiltros = class(TDataModule)
    dsFiltrosFiltroValores: TDataSource;
    dsValoresFiltroValores: TDataSource;
    dsFiltrosValorFiltros: TDataSource;
    dsValoresValorFiltros: TDataSource;
    dsMasterDetail: TDataSource;
    FiltrosFiltroValores: TkbmMemTable;
    FiltrosFiltroValoresDESCRIPCION: TStringField;
    FiltrosFiltroValoresFILTRO: TIntegerField;
    FiltrosFiltroValoresTIENE_DATOS: TBooleanField;
    FiltrosValorFiltros: TkbmMemTable;
    FiltrosValorFiltrosOR_VALOR: TIntegerField;
    FiltrosValorFiltrosDESCRIPCION: TStringField;
    ValoresValorFiltros: TkbmMemTable;
    ValoresValorFiltrosOID_VALOR: TIntegerField;
    ValoresValorFiltrosNOMBRE: TStringField;
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure FiltrosFiltroValoresAfterScroll(DataSet: TDataSet);
  public
    constructor Create(AOwner: TComponent); override;
  end;

  procedure RegisterFiltro(filtro: TFiltroClass);
  function getFiltros: TList;


implementation

{$R *.dfm}

uses dmFiltroFactory;


var filtros: TList;

function getFiltros: TList;
begin
  result := filtros;
end;

procedure RegisterFiltro(filtro: TFiltroClass);
begin
  filtros.Add(filtro);
end;


{ TFiltros}

constructor TFiltros.Create(AOwner: TComponent);
var i, OR_VALOR: integer;
  filtrosRegistrados: TList;
  filtro: TFiltro;
begin
  inherited;
  FiltrosFiltroValores.Open;
  ValoresValorFiltros.Open;
  FiltrosValorFiltros.Open;

  filtrosRegistrados := getFiltros;
  for i:=0 to filtrosRegistrados.Count - 1 do begin
    filtro := getFiltrosFactory.getFiltro(TFiltroClass(filtrosRegistrados.Items[i]));
    FiltrosFiltroValores.Append;
    FiltrosFiltroValoresDESCRIPCION.Value := filtro.Descripcion;
    FiltrosFiltroValoresFILTRO.Value := integer(filtro);
    FiltrosFiltroValoresTIENE_DATOS.Value := filtro.HasData;
    FiltrosFiltroValores.Post;

    with filtro do begin
      ValoresFiltrados.First;
      while not ValoresFiltrados.EOF do begin
        OR_VALOR := ValoresFiltradosOR_VALOR.Value;
        if not ValoresValorFiltros.Locate('OID_VALOR', OR_VALOR, []) then begin
          ValoresValorFiltros.Append;
          ValoresValorFiltrosOID_VALOR.Value := OR_VALOR;
          ValoresValorFiltrosNOMBRE.Value := filtro.ValoresFiltradosNOMBRE.Value;
          ValoresValorFiltros.Post;
        end;
        FiltrosValorFiltros.Append;
        FiltrosValorFiltrosOR_VALOR.Value := OR_VALOR;
        FiltrosValorFiltrosDESCRIPCION.Value := filtro.Descripcion;
        FiltrosValorFiltros.Post;
        ValoresFiltrados.Next;
      end;
    end;
  end;

  FiltrosFiltroValores.AfterScroll := FiltrosFiltroValoresAfterScroll;
  FiltrosFiltroValores.First;
  ValoresValorFiltros.First;
end;

procedure TFiltros.FiltrosFiltroValoresAfterScroll(DataSet: TDataSet);
begin
  dsValoresFiltroValores.DataSet := TFiltro(FiltrosFiltroValoresFILTRO.Value).ValoresFiltrados;
  dsValoresFiltroValores.DataSet.First;
end;

procedure TFiltros.DataModuleDestroy(Sender: TObject);
begin
  getFiltrosFactory.Clear;
end;


initialization
  filtros := TList.Create;
finalization
  while filtros.Count > 0 do begin
    filtros.Delete(0);
  end;
  filtros.Free;
end.
