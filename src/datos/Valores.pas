unit Valores;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, kbmMemTable, dmValoresLoader;

type
  TMercadoIndices = (miTodos, miEuropa, miAsia, miAmerica);

  TTipoAgrupacionValores = (tavTodos, tavGrupo, tavMercado, tavIndice,
    tavMercadoIndices, tavCarteraPendientes, tavCarteraAbiertas, tavTodosPaises,
    tavPais);

  TValores = class (TObject)
  private
    MemTableToPopulate: TkbmMemTable;
    FTipoAgrupacionValores: TTipoAgrupacionValores;
    FMercadoIndicesActivo: TMercadoIndices;
    FOIDAgrupacionActiva: integer;
    FPaisActivo: string;
    procedure Todos;
    procedure Grupo(const OIDGrupo: integer);
    procedure Mercado(const OIDMercado: integer);
    procedure Indice(const OIDIndice: integer);
    procedure MercadoIndices(const mi: TMercadoIndices);
    procedure CarteraPendientes(const OIDCartera: integer);
    procedure CarteraAbiertas(const OIDCartera: integer);
    procedure TodosPaises;
  protected
    procedure Populate(const ValoresLoader: TValoresLoader); virtual;
  public
    constructor Create(MemTableToPopulate: TkbmMemTable);
    procedure LoadConfiguracion;
    procedure SaveConfiguracion;
    procedure ActivarMercadoIndices(const mi: TMercadoIndices);
    procedure ActivarMercado(OID: integer);
    procedure ActivarTodos;
    procedure ActivarTodosPaises;
    procedure ActivarPais(const pais: string);
    procedure ActivarGrupo(OID: integer);
    procedure ActivarIndice(OID: integer);
    procedure ActivarCartera(OID: integer; pendiente: boolean);
    procedure Reload;
    property TipoAgrupacionValores: TTipoAgrupacionValores read FTipoAgrupacionValores;
    property OIDAgrupacionActiva: integer read FOIDAgrupacionActiva;
    property MercadoIndicesActivo: TMercadoIndices read FMercadoIndicesActivo;
    property PaisActivo: string read FPaisActivo;
  end;

implementation

uses UtilDB, dmDataComun, dmValoresLoaderCarteraAbiertas,
  dmValoresLoaderCarteraPendientes, dmValoresLoaderGrupo, dmValoresLoaderIndice,
  dmValoresLoaderMercado, dmValoresLoaderMercadoIndices, dmValoresLoaderTodos,
  dmValoresLoaderTodosPaises, dmConfiguracion, dmValoresLoaderPais;

{ TValores }

procedure TValores.ActivarCartera(OID: integer; pendiente: boolean);
begin
  if pendiente then begin
    CarteraPendientes(OID);
    FTipoAgrupacionValores := tavCarteraPendientes;
  end
  else begin
    CarteraAbiertas(OID);
    FTipoAgrupacionValores := tavCarteraAbiertas;
  end;
  FOIDAgrupacionActiva := OID;
end;

procedure TValores.ActivarGrupo(OID: integer);
begin
  Grupo(OID);
  FTipoAgrupacionValores := tavGrupo;
  FOIDAgrupacionActiva := OID;
end;

procedure TValores.ActivarIndice(OID: integer);
begin
  Indice(OID);
  FTipoAgrupacionValores := tavIndice;
  FOIDAgrupacionActiva := OID;
end;

procedure TValores.ActivarMercado(OID: integer);
begin
  Mercado(OID);
  FTipoAgrupacionValores := tavMercado;
  FOIDAgrupacionActiva := OID;
end;

procedure TValores.ActivarMercadoIndices(const mi: TMercadoIndices);
begin
  MercadoIndices(mi);
  FTipoAgrupacionValores := tavMercadoIndices;
  FMercadoIndicesActivo := mi;
end;

procedure TValores.ActivarPais(const pais: string);
var loader: TValoresLoaderPais;
begin
  FPaisActivo := pais;
  FTipoAgrupacionValores := tavPais;
  loader := TValoresLoaderPais.Create(pais);
  try
    Populate(loader);
  finally
    loader.Free;
  end;
end;

procedure TValores.ActivarTodos;
begin
  Todos;
  FTipoAgrupacionValores := tavTodos;
end;

procedure TValores.ActivarTodosPaises;
begin
  TodosPaises;
  FTipoAgrupacionValores := tavTodosPaises;
end;

procedure TValores.CarteraAbiertas(const OIDCartera: integer);
var loader: TValoresLoaderCarteraAbiertas;
begin
  loader := TValoresLoaderCarteraAbiertas.Create(OIDCartera);
  try
    Populate(loader);
  finally
    loader.Free;
  end;
end;

procedure TValores.CarteraPendientes(const OIDCartera: integer);
var loader: TValoresLoaderCarteraPendientes;
begin
  loader := TValoresLoaderCarteraPendientes.Create(OIDCartera);
  try
    Populate(loader);
  finally
    loader.Free;
  end;
end;

constructor TValores.Create(MemTableToPopulate: TkbmMemTable);
begin
  inherited Create;
  Self.MemTableToPopulate := MemTableToPopulate;
end;

procedure TValores.Grupo(const OIDGrupo: integer);
var loader: TValoresLoaderGrupo;
begin
  loader := TValoresLoaderGrupo.Create(OIDGrupo);
  try
    Populate(loader);
  finally
    loader.Free;
  end;
end;

procedure TValores.Indice(const OIDIndice: integer);
var loader: TValoresLoaderIndice;
begin
  loader := TValoresLoaderIndice.Create(OIDIndice);
  try
    Populate(loader);
  finally
    loader.Free;
  end;
end;

procedure TValores.LoadConfiguracion;
var tipo: string;
  aux: integer;
  auxPais: string;
begin
  tipo := Configuracion.ReadString('Grupo', 'Tipo', 'T');
  if tipo = 'G' then begin
    aux := Configuracion.ReadInteger('Grupo', 'Grupo', -1);
    ActivarGrupo(aux);
  end
  else
    if tipo = 'M' then begin
      aux := Configuracion.ReadInteger('Grupo', 'Mercado', -1);
      ActivarMercado(aux);
    end
    else begin
      if tipo = 'I' then begin
        aux := Configuracion.ReadInteger('Grupo', 'Indices', -1);
        ActivarIndice(aux);
      end
      else
        if tipo = 'MI' then begin
          aux := Configuracion.ReadInteger('Grupo', 'MercadoIndices', -1);
          ActivarMercadoIndices(TMercadoIndices(aux));
        end
        else begin
          if tipo = 'P' then begin
            auxPais := Configuracion.ReadString('Grupo', 'Pais', '');
            ActivarPais(auxPais);
          end
          else
            ActivarTodos;
        end;
    end;
end;

procedure TValores.Mercado(const OIDMercado: integer);
var loader: TValoresLoaderMercado;
begin
  loader := TValoresLoaderMercado.Create(OIDMercado);
  try
    Populate(loader);
  finally
    loader.Free;
  end;
end;

procedure TValores.MercadoIndices(const mi: TMercadoIndices);
var loader: TValoresLoaderMercadoIndices;
begin
  loader := TValoresLoaderMercadoIndices.Create(mi);
  try
    Populate(loader);
  finally
    loader.Free;
  end;
end;

procedure TValores.Populate(const ValoresLoader: TValoresLoader);
var events: TDataSetEvents;
  valor: PDataComunValor;
  OIDValor: integer;
  MemTableToPopulateOID_VALOR: TSmallintField;
  MemTableToPopulateOID_MERCADO: TSmallintField;
  MemTableToPopulateNOMBRE: TIBStringField;
  MemTableToPopulateSIMBOLO: TIBStringField;
  MemTableToPopulateDECIMALES: TSmallintField;
  MemTableToPopulateMERCADO: TIBStringField;
begin
  ValoresLoader.Load;
  events := DisableEventsDataSet(MemTableToPopulate);
  try
    MemTableToPopulateOID_VALOR := TSmallintField(MemTableToPopulate.FindField('OID_VALOR'));
    MemTableToPopulateOID_MERCADO := TSmallintField(MemTableToPopulate.FindField('OID_MERCADO'));
    MemTableToPopulateNOMBRE := TIBStringField(MemTableToPopulate.FindField('NOMBRE'));
    MemTableToPopulateSIMBOLO := TIBStringField(MemTableToPopulate.FindField('SIMBOLO'));
    MemTableToPopulateDECIMALES := TSmallintField(MemTableToPopulate.FindField('DECIMALES'));
    MemTableToPopulateMERCADO := TIBStringField(MemTableToPopulate.FindField('MERCADO'));
    MemTableToPopulate.Close;
    MemTableToPopulate.Open;
    ValoresLoader.qValores.First;
    while not ValoresLoader.qValores.Eof do begin
      OIDValor := ValoresLoader.qValoresOID_VALOR.Value;
      MemTableToPopulate.Append;
      MemTableToPopulateOID_VALOR.Value := OIDValor;
      valor := DataComun.FindValor(OIDValor);
      MemTableToPopulateNOMBRE.Value := valor^.Nombre;
      MemTableToPopulateOID_MERCADO.Value := valor^.Mercado^.OIDMercado;
      MemTableToPopulateSIMBOLO.Value := valor^.Simbolo;
      MemTableToPopulateDECIMALES.Value := valor^.Mercado^.Decimales;
      MemTableToPopulateMERCADO.Value := valor^.Mercado^.Nombre;
      MemTableToPopulate.Post;
      ValoresLoader.qValores.Next;
    end;
    MemTableToPopulate.First;
  finally
    EnableEventsDataSet(MemTableToPopulate, events, false);
  end;
end;

procedure TValores.Reload;
begin
  case FTipoAgrupacionValores of
    tavTodos: ActivarTodos;
    tavGrupo: ActivarGrupo(FOIDAgrupacionActiva);
    tavMercado: ActivarMercado(FOIDAgrupacionActiva);
    tavIndice: ActivarIndice(FOIDAgrupacionActiva);
    tavMercadoIndices: ActivarMercadoIndices(FMercadoIndicesActivo);
    tavCarteraPendientes: ActivarCartera(FOIDAgrupacionActiva, true);
    tavCarteraAbiertas: ActivarCartera(FOIDAgrupacionActiva, false);
    tavTodosPaises: ActivarTodosPaises;
    tavPais: ActivarPais(FPaisActivo);
  end;
end;

procedure TValores.SaveConfiguracion;
var tipo: string;
begin
  case FTipoAgrupacionValores of
    tavGrupo: begin
      Configuracion.WriteInteger('Grupo', 'Grupo', OIDAgrupacionActiva);
      tipo := 'G';
      end;
    tavMercado: begin
      Configuracion.WriteInteger('Grupo', 'Mercado', OIDAgrupacionActiva);
      tipo := 'M';
      end;
    tavIndice: begin
      Configuracion.WriteInteger('Grupo', 'Indices', OIDAgrupacionActiva);
      tipo := 'I';
    end;
    tavMercadoIndices: begin
      Configuracion.WriteInteger('Grupo', 'MercadoIndices', integer(MercadoIndicesActivo));
      tipo := 'MI';
    end;
    tavPais: begin
      Configuracion.WriteString('Grupo', 'Pais', PaisActivo);
      tipo := 'P';
    end
    else tipo := 'T';
  end;
  Configuracion.WriteString('Grupo', 'Tipo', tipo);
end;

procedure TValores.Todos;
var loader: TValoresLoaderTodos;
begin
  loader := TValoresLoaderTodos.Create;
  try
    Populate(loader);
  finally
    loader.Free;
  end;
end;

procedure TValores.TodosPaises;
var loader: TValoresLoaderTodosPaises;
begin
  loader := TValoresLoaderTodosPaises.Create;
  try
    Populate(loader);
  finally
    loader.Free;
  end;
end;

end.
