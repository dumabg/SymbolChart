unit dmGrupos;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet,
  IBQuery, IBUpdateSQL, IBSQL, ComCtrls, Dialogs,
  kbmMemTable, dmAccionesValor;

type
  CabeceraException = class(Exception);
  GrupoExistenteException = class(Exception);

  TGrupos = class(TDataModule)
    dsGrupos: TDataSource;
    qMercados: TIBQuery;
    dsMercados: TDataSource;
    qValorMercados: TIBQuery;
    iGrupoValor: TIBSQL;
    dValoresGrupo: TIBSQL;
    Valores: TkbmMemTable;
    ValoresOID_VALOR: TIntegerField;
    ValoresNOMBRE: TStringField;
    ValoresSIMBOLO: TStringField;
    qValorMercadosNOMBRE: TIBStringField;
    qMercadosNOMBRE: TIBStringField;
    qMercadosOID_MERCADO: TSmallintField;
    uMercadosDummy: TIBUpdateSQL;
    DialogExportar: TSaveDialog;
    DialogImportar: TOpenDialog;
    ValoresGrupo: TkbmMemTable;
    ValoresGrupoOID_VALOR: TSmallintField;
    ValoresGrupoNOMBRE: TIBStringField;
    ValoresGrupoSIMBOLO: TIBStringField;
    ValoresOID_MERCADO: TSmallintField;
    ValoresDECIMALES: TSmallintField;
    ValoresMERCADO: TIBStringField;
    ValoresGrupoOID_MERCADO: TIntegerField;
    ValoresGrupoMERCADO: TStringField;
    ValoresGrupoDECIMALES: TSmallintField;
    procedure qMercadosAfterOpen(DataSet: TDataSet);
    procedure ValoresFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure qMercadosAfterScroll(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
  private
    DataAccionesValor: TDataAccionesValor;
    FSelectedValues: TListView;
    abriendoMercados: boolean;
    FCambiosEnGrupo: boolean;
    procedure CargarValores;
    procedure SetOrderByNombre(const Value: boolean);
    function GetOIDGrupo: integer;
    property OIDGrupo: integer read GetOIDGrupo;
  public
    constructor Create(const Owner: TComponent; const DataAccionesValor: TDataAccionesValor); reintroduce;
    procedure Commit;
    procedure BorrarValor(oid: integer);
    procedure CrearGrupo(nombre: string);
    procedure AnadirActualAlGrupo;
    procedure BorrarGrupoActual;
    function Exportar: boolean;
    function Importar(var grupo: string): boolean;
    procedure CargarValoresGrupo;
    function GetMercados(const OIDValor: integer): string;
    procedure RefrescarDisponibles;
    function HayGrupos: boolean;
    function ExisteGrupo(const grupo: string): boolean;
    property CambiosEnGrupo: boolean read FCambiosEnGrupo;
    property SelectedValues: TListView read FSelectedValues write FSelectedValues;
    property OrderByNombre: boolean write SetOrderByNombre;
  end;


implementation

uses dmBD, variants, UtilDB, dmDataComun, Valores;

const CABECERA_VIEJO = 'FPG 1.0';
  CABECERA_NUEVO = 'SCG 1';
  OID_MERCADO_TODOS = -9999;

resourcestring
  GRUPO_YA_EXISTENTE =
    'No se puede importar porque ya existe un grupo con el nombre %s.';
  FICHERO_INCORRECTO_GRUPO =
    'El fichero no es un fichero de grupo válido.';
  TODOS = 'Todos';

{$R *.dfm}

function TGrupos.ExisteGrupo(const grupo: string): boolean;
begin
  result := Locate(dsGrupos.DataSet, 'NOMBRE', grupo, [loCaseInsensitive]);
end;

function TGrupos.Exportar: boolean;
var fichero: TStringList;
  inspect: TInspectDataSet;
begin
  CargarValoresGrupo;
  DialogExportar.FileName := DataAccionesValor.GruposNOMBRE.Value + '.scg';
  result := DialogExportar.Execute;
  if result then begin
    fichero := TStringList.Create;
    try
      fichero.Add(CABECERA_NUEVO);
      fichero.Add(DataAccionesValor.GruposNOMBRE.Value);
      inspect := StartInspectDataSet(ValoresGrupo);
      try
        ValoresGrupo.First;
        while not ValoresGrupo.Eof do begin
          fichero.Add(ValoresGrupoOID_VALOR.AsString);
          ValoresGrupo.Next;
        end;
      finally
        EndInspectDataSet(inspect);
      end;
      fichero.SaveToFile(DialogExportar.FileName);
    finally
      fichero.Free;
    end;
  end;
end;

procedure TGrupos.CrearGrupo(nombre: string);
begin
  DataAccionesValor.AnadirGrupo(nombre);
end;

constructor TGrupos.Create(const Owner: TComponent; const DataAccionesValor: TDataAccionesValor);
begin
  inherited Create(Owner);
  Self.DataAccionesValor := DataAccionesValor;
end;

procedure TGrupos.DataModuleCreate(Sender: TObject);
begin
  dsGrupos.DataSet := DataAccionesValor.Grupos;
  DataAccionesValor.Grupos.First;
  abriendoMercados := true;
  qMercados.Open;
  abriendoMercados := false;
  ValoresGrupo.Open;
end;

procedure TGrupos.BorrarValor(oid: integer);
begin
  if Locate(ValoresGrupo, 'OID_VALOR', oid, []) then begin
    ValoresGrupo.Delete;
    FCambiosEnGrupo := true;
  end;
end;

procedure TGrupos.AnadirActualAlGrupo;
begin
  ValoresGrupo.Append;
  ValoresGrupoOID_VALOR.Value := ValoresOID_VALOR.Value;
  ValoresGrupoNOMBRE.Value := ValoresNOMBRE.Value;
  ValoresGrupoSIMBOLO.Value := ValoresSIMBOLO.Value;
  ValoresGrupo.Post;
  FCambiosEnGrupo := true;
end;

procedure TGrupos.BorrarGrupoActual;
begin
  DataAccionesValor.BorrarGrupo(OIDGrupo);
end;

procedure TGrupos.Commit;
begin
  ValoresGrupo.DisableControls;
  dValoresGrupo.ParamByName('OID_GRUPO').AsInteger := OIDGrupo;
  ExecQuery(dValoresGrupo, false);
  ValoresGrupo.First;
  while not ValoresGrupo.Eof do begin
    iGrupoValor.ParamByName('OID_VALOR').AsInteger := ValoresGrupoOID_VALOR.Value;
    iGrupoValor.ParamByName('OID_GRUPO').AsInteger := OIDGrupo;
    ExecQuery(iGrupoValor, false);
    ValoresGrupo.Next;
  end;
  DataAccionesValor.ValoresGrupoModificados(OIDGrupo);
end;

function TGrupos.GetMercados(const OIDValor: integer): string;
begin
  qValorMercados.Close;
  qValorMercados.ParamByName('OID_VALOR').AsInteger := OIDValor;
  qValorMercados.Open;
  qValorMercados.Last;
  result := '';
  while not qValorMercados.Bof do begin
    if result <> '' then
      result := result + ', ';
    result := result + qValorMercadosNOMBRE.Value;
    qValorMercados.Prior;
  end;
end;

procedure TGrupos.CargarValores;
var valoresLoader: TValores;
begin
  valoresLoader := TValores.Create(Valores);
  try
    if qMercadosOID_MERCADO.Value = OID_MERCADO_TODOS then begin
      valoresLoader.ActivarTodos;
    end
    else begin
      valoresLoader.ActivarMercado(qMercadosOID_MERCADO.Value);
    end;
  finally
    valoresLoader.Free;
  end;
end;

procedure TGrupos.CargarValoresGrupo;
var valoresLoader: TValores;
begin
  valoresLoader := TValores.Create(ValoresGrupo);
  try
    valoresLoader.ActivarGrupo(OIDGrupo);
  finally
    valoresLoader.Free;
  end;
end;

function TGrupos.GetOIDGrupo: integer;
begin
  result := DataAccionesValor.GruposOID_GRUPO.Value;
end;

function TGrupos.HayGrupos: boolean;
begin
  result := DataAccionesValor.Grupos.RecordCount > 0;
end;

function TGrupos.Importar(var grupo: string): boolean;
var fichero: TStringList;
  i: integer;
begin
  result := DialogImportar.Execute;
  if result then begin
    fichero := TStringList.Create;
    try
      fichero.LoadFromFile(DialogImportar.FileName);
      if (fichero[0] = CABECERA_NUEVO) or (fichero[0] = CABECERA_VIEJO) then begin
        grupo := fichero[1];
        if DataAccionesValor.ExisteGrupo(grupo) then
          raise GrupoExistenteException.Create(Format(GRUPO_YA_EXISTENTE, [grupo]));
        if not BD.IBTransactionUsuario.InTransaction then
          BD.IBTransactionUsuario.StartTransaction;
        try
          CrearGrupo(grupo);
          CargarValoresGrupo;
          for i := 2 to fichero.Count - 1 do begin
            if Valores.Locate('OID_VALOR', fichero[i], []) then
              AnadirActualAlGrupo;
          end;
          Commit;
          ValoresGrupo.Close;
          BD.IBTransactionUsuario.CommitRetaining;
        except
          BD.IBTransactionUsuario.RollbackRetaining;
          raise;
        end;
      end
      else begin
        raise CabeceraException.Create(FICHERO_INCORRECTO_GRUPO);
      end;
    finally
      fichero.Free;
    end;
  end;
end;

procedure TGrupos.qMercadosAfterOpen(DataSet: TDataSet);
begin
  qMercados.Append;
  qMercadosNOMBRE.Value := TODOS;
  qMercadosOID_MERCADO.Value := OID_MERCADO_TODOS;
  qMercados.Post;
  CargarValores;
end;

procedure TGrupos.qMercadosAfterScroll(DataSet: TDataSet);
begin
  if not abriendoMercados then
    CargarValores;
end;

procedure TGrupos.RefrescarDisponibles;
var OIDValor: integer;
begin
  OIDValor := ValoresOID_VALOR.Value;
  Valores.Filtered := False;
  Valores.Filtered := True;
  if not Valores.Locate('OID_VALOR', OIDValor, []) then
    Valores.Last;
end;

procedure TGrupos.SetOrderByNombre(const Value: boolean);
var OIDValor: integer;
begin
  OIDValor := ValoresOID_VALOR.Value;
  if Value then begin
    Valores.IndexName := 'ValoresIndexNombre';
  end
  else begin
    Valores.IndexName := 'ValoresIndexSimbolo';
  end;
  Valores.Locate('OID_VALOR', OIDValor, []);
end;

procedure TGrupos.ValoresFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  if FSelectedValues <> nil then
    Accept := FSelectedValues.FindCaption(0, ValoresNOMBRE.Value, false,
        true, false) = nil;
end;

end.
