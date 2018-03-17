unit dmConsulta;

interface

uses
  SysUtils, Classes, DB, kbmMemTable, IBCustomDataSet, IBQuery,
  ScriptEditorCodigoDatos, Tipos, UtilThread, Messages, Windows,
  dmTareas, IBSQL;

const
  WM_NEW_ROW = WM_USER + 12;
  WM_FINISH_SEARCH = WM_USER + 13;

type
  TConsulta = class;

  TColumnScript = class(TScriptEditorCodigoDatos)
  private
    ColumnCompiledCode: string;
  end;

  TConsultaThread = class(TTarea)
  private
    MustRecalcular: boolean;
    idSearch, idSearchRecalcular: integer;
    Data: TConsulta;
    OIDSesion: integer;
    Valores: TArrayInteger;
    NuevosValores: PArrayInteger;
    Fields: array of TField;
    NumFields: Integer;
    MostrarSimbolo, MostrarNombre: boolean;
    ColumnsScript: array of TColumnScript;
    ScriptSearch: TScriptEditorCodigoDatos;
    procedure AnadirValor(OIDValor: integer);
  protected
    constructor Create(const Data: TConsulta; const OIDSesion: integer;
      const Valores: PArrayInteger; const idSearch: integer); reintroduce;
    procedure InternalExecute; override;
    procedure InitializeResources; override;
    procedure FreeResources; override;
    procedure InternalCancel; override;
  public
    procedure Recalcular(const nuevosValores: PArrayInteger; const nuevoIdSearch: integer);
    procedure CrearGrupo(const nombre: string);
  end;

  TOnNewRow = procedure(NumRows: integer) of object;

  TConsulta = class(TDataModule)
    qColumnas: TIBQuery;
    qColumnasOR_CONSULTA: TIntegerField;
    qColumnasPOSICION: TSmallintField;
    qColumnasNOMBRE: TIBStringField;
    qColumnasTIPO: TSmallintField;
    qColumnasCODIGO: TMemoField;
    Consulta: TkbmMemTable;
    qCaracteristica: TIBQuery;
    qCaracteristicaCODIGO: TMemoField;
    qColumnasANCHO: TSmallintField;
    qConsulta: TIBQuery;
    qConsultaOR_FS: TIntegerField;
    qConsultaTIPO: TIBStringField;
    qConsultaOR_CARACTERISTICA: TIntegerField;
    qConsultaCODIGO: TMemoField;
    ConsultaOID_VALOR: TIntegerField;
    qConsultaCOLUMNA_SIMBOLO: TIBStringField;
    qConsultaCOLUMNA_NOMBRE: TIBStringField;
    ConsultaSIMBOLO: TStringField;
    ConsultaNOMBRE: TStringField;
    qConsultaCODIGO_COMPILED: TMemoField;
    qColumnasCODIGO_COMPILED: TMemoField;
    qConsultaCONTAR_VALORES: TIBStringField;
    qConsultaNOMBRE: TIBStringField;
    qValoresSesion: TIBSQL;
    procedure ConsultaAfterInsert(DataSet: TDataSet);
  private
    rows: integer;
    ConsultaThread: TConsultaThread;
    MostrarSimbolo, MostrarNombre: boolean;
    FValores: TArrayInteger;
    FHandleNotification: HWND;
    OIDSesion: integer;
    ValoresSesion: TArrayInteger;
    CompiledCode: string;
    ThreadTerminated: boolean;
    procedure OnTerminateThread(Sender: TObject);
    procedure CreateColumns(const OIDConsulta: integer);
//    procedure ExecuteCaracteristica(const OIDConsulta: integer);
    procedure ExecuteCodigo(const idSearch: integer);
    function NormalizeName(const nombre: string): string;
    function CreateField(const tipo: integer): TField;
    function GetCount: integer;
    procedure OnFinish(const idSearch: integer);
    function GetValores: PArrayInteger;
    procedure SetValores(const Value: PArrayInteger);
  public
    destructor Destroy; override;
    procedure Load(const OIDConsulta: integer);
    procedure Reset;
    procedure Search(const idSearch: integer);
    function HayColumnas: boolean;
    procedure Cancel;
    property Count: integer read GetCount;
    property Valores: PArrayInteger read GetValores write SetValores;
    property HandleNotification: HWND read FHandleNotification write FHandleNotification;
  end;



implementation

uses dmBD, BDConstants, UtilDB,
  dmData, fmConsultas, BusCommunication, dmDataComun, ScriptEngine,
  dmConsultaGrupo, Forms;

{$R *.dfm}

resourcestring
  CONSULTA_TITLE = 'Listado';

{ TConsulta }

procedure TConsulta.ConsultaAfterInsert(DataSet: TDataSet);
begin
  PostMessage(HandleNotification, WM_NEW_ROW, rows, 0);
  inc(rows);
end;

procedure TConsulta.CreateColumns(const OIDConsulta: integer);
    procedure CreateColumn;
    var field: TField;
      nombre: string;
    begin
      field := CreateField(qColumnasTIPO.Value);
      nombre := qColumnasNOMBRE.Value;
      field.FieldName := NormalizeName(nombre);
      field.DataSet := Consulta;
      field.DisplayLabel := nombre;
      field.DisplayWidth := qColumnasANCHO.Value;
      field.Tag := qColumnas.RecNo;
    end;
begin
  qColumnas.Close;
  qColumnas.Params[0].AsInteger := OIDConsulta;
  OpenDataSetRecordCount(qColumnas);
  while not qColumnas.Eof do begin
    CreateColumn;
    qColumnas.Next;
  end;
  Consulta.Active := HayColumnas;
end;

function TConsulta.CreateField(const tipo: integer): TField;
begin
  case TResultType(tipo) of
    rtBoolean: result := TBooleanField.Create(Self);
    rtString: begin
      result := TStringField.Create(Self);
      result.Size := 255;
    end;
    rtInteger: result := TIntegerField.Create(Self);
    rtCurrency: result := TCurrencyField.Create(Self);
    else raise Exception.Create('Tipo de field incorrecto');
  end;
end;

destructor TConsulta.Destroy;
begin
  Cancel;
  inherited;
end;

{procedure TConsulta.ExecuteCaracteristica(const OIDConsulta: integer);
var script: TScriptCaracteristicas;
begin
  qCaracteristica.Close;
  qCaracteristica.Params[0].AsInteger := OIDConsulta;
  qCaracteristica.Open;
  script := TScriptCaracteristicas.Create(nil);
  try
    script.ResultType := rtBoolean;
    script.Code.Text := qCaracteristicaCODIGO.Value;
    if script.Compile then
      script.Execute;
  finally
    script.Free;
  end;
end;}

procedure TConsulta.ExecuteCodigo(const idSearch: integer);
var reloaded: boolean;

  procedure ReloadValoresSesion;
  var i, j, num: integer;
    field: TIBXSQLVAR;
    OIDValor: integer;
  begin
    qValoresSesion.Close;
    qValoresSesion.Params[0].AsInteger := OIDSesion;
    qValoresSesion.ExecQuery;
    num := Length(FValores);
    SetLength(ValoresSesion, num);
    i := 0;
    dec(num);
    field := qValoresSesion.Fields[0];
    while not qValoresSesion.Eof do begin
      OIDValor := field.Value;
      for j := 0 to num do begin
        if OIDValor = FValores[j] then begin
          ValoresSesion[i] := OIDValor;
          Inc(i);
          break;
        end;
      end;
      qValoresSesion.Next;
    end;
    SetLength(ValoresSesion, i);
    qValoresSesion.Close;
  end;
begin
  if compiledCode <> '' then begin
    if OIDSesion <> Data.OIDSesion then begin
      OIDSesion := Data.OIDSesion;
      ReloadValoresSesion;
      reloaded := true;
    end
    else
      reloaded := false;
    if ConsultaThread <> nil then begin
      ConsultaThread.OIDSesion := OIDSesion;
      if reloaded then
        ConsultaThread.Recalcular(@ValoresSesion, idSearch)
      else
        ConsultaThread.Recalcular(nil, idSearch);
    end
    else begin
      ThreadTerminated := false;
      ConsultaThread := TConsultaThread.Create(Self, OIDSesion, @ValoresSesion, idSearch);
      ConsultaThread.OnTerminate := OnTerminateThread;
      ConsultaThread.Resume;
//      Tareas.EjecutarTarea(ConsultaThread, CONSULTA_TITLE, qConsultaNOMBRE.Value);
    end;
  end;
end;

function TConsulta.GetCount: integer;
begin
  result := Consulta.RecordCount;
end;

function TConsulta.GetValores: PArrayInteger;
begin
  Result := @FValores;
end;

function TConsulta.HayColumnas: boolean;
begin
  // Siempre hay 3, que es el OID_VALOR, NOMBRE y SIMBOLO
  result := (Consulta.FieldCount > 3) or (ConsultaSIMBOLO.Visible) or
    (ConsultaNOMBRE.Visible);
end;

procedure TConsulta.Load(const OIDConsulta: integer);
begin
  qConsulta.Close;
  qConsulta.Params[0].AsInteger := OIDConsulta;
  OpenDataSet(qConsulta);
  CompiledCode := qConsultaCODIGO_COMPILED.Value;
  MostrarSimbolo := qConsultaCOLUMNA_SIMBOLO.Value = 'S';
  MostrarNombre := qConsultaCOLUMNA_NOMBRE.Value = 'S';
  qConsulta.Close;
  ConsultaSIMBOLO.Visible := MostrarSimbolo;
  ConsultaNOMBRE.Visible := MostrarNombre;
  CreateColumns(OIDConsulta);
end;

function TConsulta.NormalizeName(const nombre: string): string;
var i: integer;
begin
  result := '_';
  for i := 1 to length(nombre) do
    if nombre[i] in ['a'..'z', 'A'..'Z', '0'..'9'] then
      result := result + nombre[i];

  i := 0;
  while i < Consulta.FieldCount do begin
    if Consulta.Fields[i].FieldName = result then begin
      result := result + '_';
      i := 0;
    end
    else
      inc(i);
  end;
end;

procedure TConsulta.OnFinish(const idSearch: integer);
begin
  Consulta.First;
  PostMessage(HandleNotification, WM_FINISH_SEARCH, idSearch , 0);
end;

procedure TConsulta.OnTerminateThread(Sender: TObject);
begin
  ThreadTerminated := true;
end;

procedure TConsulta.Reset;
begin
  OIDSesion := -1;
  Cancel;
end;

procedure TConsulta.Search(const idSearch: integer);
begin
{    if qConsultaTIPO.Value = CONSULTA_TIPO_CARACTERISTICA then
      ExecuteCaracteristica(OIDConsulta)
    else}
  if HayColumnas then begin
    rows := 0;
    ExecuteCodigo(idSearch);
  end;
end;

procedure TConsulta.SetValores(const Value: PArrayInteger);
begin
  FValores := Copy(Value^, 0, Length(Value^));
end;

procedure TConsulta.Cancel;
begin
  if ConsultaThread <> nil then begin
    ConsultaThread.Cancel;
    while not ThreadTerminated do
      Application.ProcessMessages;
    ConsultaThread := nil;
  end;
end;

{ TConsultaThread }

procedure TConsultaThread.AnadirValor(OIDValor: integer);
var i: integer;
  Script: TColumnScript;
  dataValor: PDataComunValor;
  executed: boolean;
begin
  Data.Consulta.Append;

  Fields[0].AsInteger := OIDValor;
  if MostrarSimbolo or MostrarNombre then begin
    dataValor := DataComun.FindValor(OIDValor);
    if MostrarSimbolo then
      Fields[1].AsString := dataValor^.Simbolo;
    if Data.MostrarNombre then
      Fields[2].AsString := dataValor^.Nombre;
  end;

  for i := 3 to NumFields do begin
    Script := ColumnsScript[i];
    Script.OIDValor := OIDValor;
    if Script.IsLoadedCompiledCode then begin
      try
        executed := Script.Execute;
        if executed then begin
          case Script.ResultType of
            rtBoolean: Fields[i].AsBoolean := Script.ValueBoolean;
            rtCurrency: Fields[i].AsCurrency := Script.ValueCurrency;
            rtInteger: Fields[i].AsInteger := Script.ValueInteger;
            rtString: Fields[i].AsString := Script.ValueString;
          end;
        end
        else begin
          Fields[i].Clear;
          Script.CompiledCode := Script.ColumnCompiledCode;
        end;
      except
        on EStopScript do begin
          if Script.EDatoNotFound then begin
            Fields[i].Clear;
            Script.CompiledCode := Script.ColumnCompiledCode;
          end
          else
            raise;
        end;
      end;
    end;
  end;

  Data.Consulta.Post;
end;

procedure TConsultaThread.CrearGrupo(const nombre: string);
var ConsultaGrupo: TConsultaGrupo;
begin

end;

constructor TConsultaThread.Create(const Data: TConsulta;
  const OIDSesion: integer; const Valores: PArrayInteger; const idSearch: integer);
begin
  inherited Create;
  Self.Valores := Copy(Valores^, 0, Length(Valores^));
  Self.OIDSesion := OIDSesion;
  Self.Data := Data;
  Self.idSearch := idSearch;
  FreeOnTerminate := true;
end;

procedure TConsultaThread.FreeResources;
var i: Integer;
begin
  for i := 3 to NumFields do
    ColumnsScript[i].Free;
  if ScriptSearch <> nil then
    ScriptSearch.Free;
  inherited;
end;


procedure TConsultaThread.InitializeResources;
var i: integer;
  codigoCompiled: string;
  Script: TColumnScript;
begin
  MostrarSimbolo := Data.MostrarSimbolo;
  MostrarNombre := Data.MostrarNombre;

  numFields := Data.Consulta.Fields.Count;
  SetLength(Fields, NumFields);
  Dec(NumFields); //zero based
  for i := 0 to NumFields do
    Fields[i] := Data.Consulta.Fields[i];

  // + 3 del OID_VALOR, SIMBOLO y NOMBRE
  SetLength(ColumnsScript, Data.qColumnas.RecordCount + 3);
  for i := 3 to NumFields do begin
    Data.qColumnas.RecNo := Fields[i].Tag;
    Script := TColumnScript.Create(true);
    Script.ResultType := TResultType(Data.qColumnasTIPO.Value);
    Script.OutVariableName := OUT_VARIABLE_NAME_LISTADO;
    codigoCompiled := Data.qColumnasCODIGO_COMPILED.Value;
    if codigoCompiled <> '' then begin
      Script.CompiledCode := codigoCompiled;
      Script.ColumnCompiledCode := codigoCompiled;
    end;
    Script.OIDSesion := OIDSesion;
    ColumnsScript[i] := Script;
  end;

  ScriptSearch := TScriptEditorCodigoDatos.Create(true);
end;

procedure TConsultaThread.InternalExecute;
var i, num: Integer;
  OIDValor: integer;

  procedure MustRecalcularInit;
  begin
    if NuevosValores <> nil then begin
      Valores := Copy(NuevosValores^, 0, Length(NuevosValores^));
      NuevosValores := nil;
    end;
    idSearch := idSearchRecalcular;
  end;

begin
  ScriptSearch.ResultType := rtBoolean;
  ScriptSearch.OutVariableName := OUT_VARIABLE_NAME_BUSQUEDA;
  ScriptSearch.CompiledCode := Data.CompiledCode;

  MustRecalcular := true;
  while MustRecalcular do begin
    if Terminated then
      raise ETerminateThread.Create;
    num := length(Valores) - 1;
    MustRecalcular := False;

    ScriptSearch.OIDSesion := OIDSesion;
    for i := 3 to NumFields do
      ColumnsScript[i].OIDSesion := OIDSesion;

    Data.Consulta.EmptyTable;
    if Terminated then
      raise ETerminateThread.Create;
    for i := 0 to num do begin
      OIDValor := Valores[i];
      ScriptSearch.OIDValor := OIDValor;
      try
        if (ScriptSearch.Execute) and (ScriptSearch.ValueBoolean) then
          AnadirValor(OIDValor);
      except
        on EStopScript do;
      end;
      if MustRecalcular then
        break;
      if Terminated then
        raise ETerminateThread.Create;
    end;
    if MustRecalcular then begin
      MustRecalcularInit;
    end
    else begin
      Data.OnFinish(idSearch);
      Suspend;
      if MustRecalcular then
        MustRecalcularInit;
    end;
  end;
end;

procedure TConsultaThread.InternalCancel;
begin
  inherited;
  MustRecalcular := false;
  ScriptSearch.Stop;
end;

procedure TConsultaThread.Recalcular(const nuevosValores: PArrayInteger; const nuevoIdSearch: integer);
begin
  if Suspended then begin
    if nuevosValores <> nil then
      Valores := Copy(nuevosValores^, 0, Length(nuevosValores^));
    Self.NuevosValores := nil;
  end
  else begin
    Suspend;
    Self.NuevosValores := nuevosValores;
    ScriptSearch.Stop;
  end;
  idSearchRecalcular := nuevoIdSearch;
  MustRecalcular := true;
  Resume;
end;

end.
