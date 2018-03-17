unit dmConsultas;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, IBSQL, BDConstants,
  dmEditFS, kbmMemTable, dmFS, Contnrs;

const
  SIN_CARACTERISTICA = Low(integer);

type
  TColumna = class
  private
    FCodigo: string;
    FTipo: TResultType;
    FAncho: integer;
    FCodigoCompiled: string;
    FNombre: string;
    function GetHasCodigoCompiled: boolean;
    function GetTipoAsString: string;
  public
    property Nombre: string read FNombre write FNombre;
    property Codigo: string read FCodigo write FCodigo;
    property CodigoCompiled: string read FCodigoCompiled write FCodigoCompiled;
    property Tipo: TResultType read FTipo write FTipo;
    property Ancho: integer read FAncho write FAncho;
    property HasCodigoCompiled: boolean read GetHasCodigoCompiled;
    property TipoAsString: string read GetTipoAsString;
  end;

  TTipoConsulta = (tcCaracteristica, tcCodigo);

  TConsultas = class(TEditFS)
    qConsulta: TIBQuery;
    qConsultaOR_FS: TIntegerField;
    qConsultaOR_CARACTERISTICA: TIntegerField;
    qConsultaCARACTERISTICA: TIBStringField;
    uiConsulta: TIBSQL;
    iConsultaColumna: TIBSQL;
    dConsultaColumnas: TIBSQL;
    qColumnas: TIBQuery;
    qColumnasOR_CONSULTA: TIntegerField;
    qColumnasPOSICION: TSmallintField;
    qColumnasNOMBRE: TIBStringField;
    qColumnasTIPO: TSmallintField;
    qColumnasCODIGO: TMemoField;
    qColumnasANCHO: TSmallintField;
    qConsultaTIPO: TIBStringField;
    qConsultaCODIGO: TMemoField;
    qConsultaCOLUMNA_SIMBOLO: TIBStringField;
    qConsultaCOLUMNA_NOMBRE: TIBStringField;
    qConsultaCODIGO_COMPILED: TMemoField;
    qColumnasCODIGO_COMPILED: TMemoField;
    uConsultaCodigoCompiled: TIBSQL;
    qConsultaCONTAR_VALORES: TIBStringField;
    qConsultasMenu: TIBQuery;
    qConsultasMenuOR_FS: TIntegerField;
    qConsultasMenuCONTAR_VALORES: TIBStringField;
    qConsultasMenuCODIGO_COMPILED: TMemoField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    Columnas: TObjectList;
    function GetOIDCaracteristica: integer;
    function GetCaracteristica: string;
    function GetTipo: TTipoConsulta;
    function GetCodigo: string;
    function GetColumnaNombre: boolean;
    function GetColumnaSimbolo: boolean;
    function GetCodigoCompiled: string;
    function GetContarValores: boolean;
    function GetColumnasCount: integer;
    function GetColumna(i: integer): TColumna;
  protected
    function GetFileSystemName: string; override;
    procedure GuardarColumnas(const OIDFS: integer);
  public
    procedure Load(const OIDFS: integer);
    procedure AddColumn(const nombre: string; const tipo: TResultType);
    procedure DeleteColumn(const col: integer);
    procedure Guardar(const tipo: TTipoConsulta;
      const OIDFS, OIDCaracteristica: integer; const codigo: string;
      const ColumnaSimbolo, ColumnaNombre, ContarValores: boolean);
    procedure UpdateCodigoCompiledBusqueda(const OIDFS: integer; const codigoCompiled: string);
    procedure MoveColumna(const iFrom, iTo: integer);
    function HayColumnas: boolean;
    function HasCodigoCompiled(const OIDFS: integer): boolean;
    function DebeContar(const OIDFS: Integer): Boolean;
    property OIDCaracteristica: integer read GetOIDCaracteristica;
    property Caracteristica: string read GetCaracteristica;
    property ColumnasCount: integer read GetColumnasCount;
    property Columna[i: integer]: TColumna read GetColumna;
    property Tipo: TTipoConsulta read GetTipo;
    property Codigo: string read GetCodigo;
    property CodigoCompiled: string read GetCodigoCompiled;
    property ColumnaSimbolo: boolean read GetColumnaSimbolo;
    property ColumnaNombre: boolean read GetColumnaNombre;
    property ContarValores: boolean read GetContarValores;
  end;

implementation

uses dmBD, UtilDB;

{$R *.dfm}

const
  CONSULTA_FS = 'CONSULTA_FS';
  DEFAULT_ANCHO = 65;

function TConsultas.GetCaracteristica: string;
begin
  if qConsulta.IsEmpty then
    result := ''
  else
    result := qConsultaCARACTERISTICA.Value;
end;

function TConsultas.GetCodigo: string;
begin
  result := qConsultaCODIGO.Value;
end;

function TConsultas.GetCodigoCompiled: string;
begin
  result := qConsultaCODIGO_COMPILED.Value;
end;

function TConsultas.GetColumna(i: integer): TColumna;
begin
  result := TColumna(Columnas[i]);
end;

function TConsultas.GetColumnaNombre: boolean;
begin
  if qConsulta.IsEmpty then
    result := True
  else
    result := qConsultaCOLUMNA_NOMBRE.Value = 'S';
end;

function TConsultas.GetColumnasCount: integer;
begin
  result := Columnas.Count;
end;

function TConsultas.GetColumnaSimbolo: boolean;
begin
  if qConsulta.IsEmpty then
    result := True
  else
    result := qConsultaCOLUMNA_SIMBOLO.Value = 'S';
end;

function TConsultas.GetContarValores: boolean;
begin
  Result := qConsultaCONTAR_VALORES.Value = 'S';
end;

function TConsultas.GetFileSystemName: string;
begin
  result := CONSULTA_FS;
end;

function TConsultas.GetOIDCaracteristica: integer;
begin
  if qConsulta.IsEmpty then
    result := SIN_CARACTERISTICA
  else
    result := qConsultaOR_CARACTERISTICA.Value;
end;

function TConsultas.GetTipo: TTipoConsulta;
begin
  if qConsultaTIPO.Value = CONSULTA_TIPO_CODIGO then
    result := tcCodigo
  else
    result := tcCaracteristica;
end;

procedure TConsultas.GuardarColumnas(const OIDFS: integer);
var i: integer;
  columna: TColumna;
begin
  dConsultaColumnas.Params[0].AsInteger := OIDFS;
  ExecQuery(dConsultaColumnas, false);
  for i := 0 to Columnas.Count - 1 do begin
    iConsultaColumna.ParamByName('OR_CONSULTA').AsInteger := OIDFS;
    iConsultaColumna.ParamByName('POSICION').AsInteger := i;
    columna := TColumna(Columnas[i]);
    iConsultaColumna.ParamByName('NOMBRE').AsString := columna.Nombre;
    iConsultaColumna.ParamByName('TIPO').AsInteger := integer(columna.Tipo);
    iConsultaColumna.ParamByName('CODIGO').AsString := columna.Codigo;
    iConsultaColumna.ParamByName('CODIGO_COMPILED').AsString := columna.CodigoCompiled;
    iConsultaColumna.ParamByName('ANCHO').AsInteger := columna.Ancho;
    ExecQuery(iConsultaColumna, false);
  end;
end;

procedure TConsultas.Guardar(const tipo: TTipoConsulta;
  const OIDFS, OIDCaracteristica: integer; const codigo: string;
  const ColumnaSimbolo, ColumnaNombre, ContarValores: boolean);
begin
  try
    uiConsulta.ParamByName('OR_FS').AsInteger := OIDFS;
    if Tipo = tcCaracteristica then
      uiConsulta.ParamByName('TIPO').AsString := CONSULTA_TIPO_CARACTERISTICA
    else
      uiConsulta.ParamByName('TIPO').AsString := CONSULTA_TIPO_CODIGO;
    if OIDCaracteristica = SIN_CARACTERISTICA then
      uiConsulta.ParamByName('OR_CARACTERISTICA').Clear
    else
      uiConsulta.ParamByName('OR_CARACTERISTICA').AsInteger := OIDCaracteristica;
    if codigo = '' then
      uiConsulta.ParamByName('CODIGO').Clear
    else
      uiConsulta.ParamByName('CODIGO').AsString := codigo;
    if ColumnaSimbolo then
      uiConsulta.ParamByName('COLUMNA_SIMBOLO').AsString := 'S'
    else
      uiConsulta.ParamByName('COLUMNA_SIMBOLO').AsString := 'N';
    if ColumnaNombre then
      uiConsulta.ParamByName('COLUMNA_NOMBRE').AsString := 'S'
    else
      uiConsulta.ParamByName('COLUMNA_NOMBRE').AsString := 'N';
    if ContarValores then
      uiConsulta.ParamByName('CONTAR_VALORES').AsString := 'S'
    else
      uiConsulta.ParamByName('CONTAR_VALORES').AsString := 'N';
    ExecQuery(uiConsulta, false);

    GuardarColumnas(OIDFS);

    BD.IBTransactionUsuario.CommitRetaining;
  except
    BD.IBTransactionUsuario.RollbackRetaining;
    raise;
  end;
end;

function TConsultas.HasCodigoCompiled(const OIDFS: integer): boolean;
begin
  if qConsultasMenu.Locate('OR_FS', OIDFS, []) then
    result := qConsultasMenuCODIGO_COMPILED.Value <> ''
  else
    result := false;
end;

function TConsultas.HayColumnas: boolean;
begin
  result := Columnas.Count > 0;
end;

procedure TConsultas.AddColumn(const nombre: string; const tipo: TResultType);
var columna: TColumna;
begin
  columna := TColumna.Create;
  columna.Nombre := nombre;
  columna.Codigo := 'begin' + sLineBreak + 'Valor := ' + sLineBreak + 'end.';
  columna.CodigoCompiled := '';
  columna.Tipo := tipo;
  columna.Ancho := DEFAULT_ANCHO;
  columnas.Add(columna);
end;

procedure TConsultas.DataModuleCreate(Sender: TObject);
begin
  Columnas := TObjectList.Create(true);
  LoadRoot;
  OpenDataSet(qConsultasMenu);
end;

procedure TConsultas.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  Columnas.Free;
end;

function TConsultas.DebeContar(const OIDFS: Integer): Boolean;
begin
  if qConsultasMenu.Locate('OR_FS', OIDFS, []) then
    result := qConsultasMenuCONTAR_VALORES.Value = GetBooleanRepresentation(true)
  else
    result := false;
end;

procedure TConsultas.DeleteColumn(const col: integer);
begin
  Columnas.Delete(col);
end;

procedure TConsultas.Load(const OIDFS: integer);
var ancho: integer;
  columna: TColumna;
begin
  qConsulta.Close;
  qConsulta.Params[0].AsInteger := OIDFS;
  qConsulta.Open;

  Columnas.Clear;
  if not qConsulta.IsEmpty then begin
    qColumnas.Close;
    qColumnas.Params[0].AsInteger := OIDFS;
    qColumnas.Open;
    while not qColumnas.Eof do begin
      columna := TColumna.Create;
      columna.Nombre := qColumnasNOMBRE.Value;
      columna.Codigo := qColumnasCODIGO.Value;
      columna.CodigoCompiled := qColumnasCODIGO_COMPILED.Value;
      columna.Tipo := TResultType(qColumnasTIPO.Value);
      if not qColumnasANCHO.IsNull then begin
        ancho := qColumnasANCHO.Value;
        if ancho > 0 then
          columna.Ancho := ancho
        else
          columna.Ancho := DEFAULT_ANCHO;
      end;
      Columnas.Add(columna);
      qColumnas.Next;
    end;
  end;
end;

procedure TConsultas.MoveColumna(const iFrom, iTo: integer);
begin
  Columnas.Move(iFrom, iTo);
end;

procedure TConsultas.UpdateCodigoCompiledBusqueda(const OIDFS: integer; const codigoCompiled: string);
begin
  if codigoCompiled = '' then
    uConsultaCodigoCompiled.ParamByName('CODIGO_COMPILED').Clear
  else
    uConsultaCodigoCompiled.ParamByName('CODIGO_COMPILED').AsString := codigoCompiled;
  uConsultaCodigoCompiled.ParamByName('OID_FS').AsInteger := OIDFS;
  ExecQuery(uConsultaCodigoCompiled, true);
end;

{ TColumna }

function TColumna.GetHasCodigoCompiled: boolean;
begin
  result := FCodigoCompiled <> '';
end;

function TColumna.GetTipoAsString: string;
begin
  Result := GetResultTypeString(FTipo);
end;

end.
