unit dmAccionesValor;

interface

uses
  SysUtils, Classes, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, Valores,
  BusCommunication, IBSQL;

type
  MessageMercadoGrupoCambiado = class(TBusMessage);

  TDataAccionesValor = class(TDataModule)
    Grupos: TIBQuery;
    GruposOID_GRUPO: TIntegerField;
    GruposNOMBRE: TIBStringField;
    uGrupos: TIBUpdateSQL;
    OIDGrupo: TIBQuery;
    OIDGrupoMIN: TIntegerField;
    Indices: TIBQuery;
    IndicesOID_INDICE: TSmallintField;
    IndicesNOMBRE: TIBStringField;
    IndicesOR_MERCADO: TSmallintField;
    IndicesOR_VALOR: TIntegerField;
    IndicesNUM_VALORES: TIntegerField;
    Carteras: TIBQuery;
    CarterasOID_CARTERA: TSmallintField;
    CarterasNOMBRE: TIBStringField;
    dGrupoValor: TIBSQL;
    procedure DataModuleCreate(Sender: TObject);
  private
    FOnValorGrupoActivoBorrado: TNotifyEvent;
    function GetNombreAgrupacionValores: string;
    function GetDescMercadoIndicesActivo: string;
    function GetDescMercadoActivo: string;
  public
    procedure BorrarGrupo(OID: integer);
    function ResetGrupo(const nombre: string): integer;
    function ExisteGrupo(const nombre: string): boolean;
    function AnadirGrupo(nombre: string): integer;
    procedure ActivarMercadoIndices(const mi: TMercadoIndices);
//    procedure ActivarMercado(const nombre: string); overload;
    procedure ActivarMercado(OID: integer); //overload;
    procedure ActivarTodos;
    procedure ActivarTodosPaises;
    procedure ActivarPais(const pais: string);
    procedure ActivarGrupo(OID: integer);
    procedure ActivarIndice(OID: integer);
    procedure ActivarCartera(OID: integer; pendiente: boolean);
    procedure ValoresGrupoModificados(const OIDGrupo: integer);
    property NombreAgrupacionValores: string read GetNombreAgrupacionValores;
//    property OnValorGrupoActivoBorrado: TNotifyEvent read FOnValorGrupoActivoBorrado write FOnValorGrupoActivoBorrado;
  end;

{var
  DataAccionesValor: TDataAccionesValor;}

implementation

uses dmBD, UtilDB, dmData, dmDataComun;

resourcestring
  TODOS_DESC = 'Todos';
  TODOS_PAISES_DESC = 'Todos los países';

{$R *.dfm}

{procedure TDataAccionesValor.ActivarMercado(const nombre: string);
begin
  ActivarMercado(DataComun.FindMercadoNombre(nombre)^.OIDMercado);
end;}

procedure TDataAccionesValor.ActivarMercado(OID: integer);
var LastPosOIDValor: integer;
begin
  LastPosOIDValor := Data.OIDValor;
  Data.ValoresActivator.ActivarMercado(OID);
  Bus.SendEvent(MessageMercadoGrupoCambiado);
  Data.IrAValor(LastPosOIDValor);
end;

procedure TDataAccionesValor.ActivarMercadoIndices(const mi: TMercadoIndices);
var LastPosOIDValor: integer;
begin
  LastPosOIDValor := Data.OIDValor;
  Data.ValoresActivator.ActivarMercadoIndices(mi);
  Bus.SendEvent(MessageMercadoGrupoCambiado);
  Data.IrAValor(LastPosOIDValor);
end;

procedure TDataAccionesValor.ActivarPais(const pais: string);
var LastPosOIDValor: integer;
begin
  LastPosOIDValor := Data.OIDValor;
  Data.ValoresActivator.ActivarPais(pais);
  Bus.SendEvent(MessageMercadoGrupoCambiado);
  Data.IrAValor(LastPosOIDValor);
end;

procedure TDataAccionesValor.ActivarTodos;
var LastPosOIDValor: integer;
begin
  LastPosOIDValor := Data.OIDValor;
  Data.ValoresActivator.ActivarTodos;
  Bus.SendEvent(MessageMercadoGrupoCambiado);
  Data.IrAValor(LastPosOIDValor);
end;

procedure TDataAccionesValor.ActivarTodosPaises;
var LastPosOIDValor: integer;
begin
  LastPosOIDValor := Data.OIDValor;
  Data.ValoresActivator.ActivarTodosPaises;
  Bus.SendEvent(MessageMercadoGrupoCambiado);
  Data.IrAValor(LastPosOIDValor);
end;

function TDataAccionesValor.AnadirGrupo(nombre: string): integer;
begin
  OIDGrupo.Close;
  OpenDataSet(OIDGrupo);
  Grupos.Append;
  // Los grupos creados por el usuario tendrán el valor OID negativo.
  // Al conectar con el servidor, se comprueba si hay nuevos grupos compartidos.
  // Los grupos compartidos tienen los OID positivos.
  GruposOID_GRUPO.Value := OIDGrupoMIN.Value - 1;
  OIDGrupo.Close;
  GruposNOMBRE.Value := nombre;
  Grupos.Post;
  BD.IBTransactionUsuario.CommitRetaining;
  Result := GruposOID_GRUPO.Value;
end;


procedure TDataAccionesValor.BorrarGrupo(OID: integer);
var valores: TValores;
begin
  valores := Data.ValoresActivator;
  if (valores.TipoAgrupacionValores = tavGrupo) and (valores.OIDAgrupacionActiva = OID) then begin
    Grupos.Delete;
    ActivarTodos;
  end
  else begin
    if Locate(Grupos, 'OID_GRUPO', OID, []) then
      Grupos.Delete;
  end;
  BD.IBTransactionUsuario.CommitRetaining;
end;

procedure TDataAccionesValor.DataModuleCreate(Sender: TObject);
begin
  FOnValorGrupoActivoBorrado := nil;
  OpenDataSet(Grupos);
  OpenDataSet(Indices);
  OpenDataSet(Carteras);
  case Data.ValoresActivator.TipoAgrupacionValores of
    tavGrupo: Grupos.Locate('OID_GRUPO', Data.ValoresActivator.OIDAgrupacionActiva, []);
    tavIndice: Indices.Locate('OID_INDICE', Data.ValoresActivator.OIDAgrupacionActiva, []);
    tavCarteraPendientes,
    tavCarteraAbiertas: Carteras.Locate('OID_CARTERA', Data.ValoresActivator.OIDAgrupacionActiva, []);
  end;
end;

function TDataAccionesValor.ExisteGrupo(const nombre: string): boolean;
begin
  result := Grupos.Locate('NOMBRE', nombre, [loCaseInsensitive]);
end;

function TDataAccionesValor.GetDescMercadoActivo: string;
var PMercado: PDataComunMercado;
begin
  PMercado := DataComun.FindMercado(Data.ValoresActivator.OIDAgrupacionActiva);
  result := PMercado^.Pais;
  if result = 'Estados Unidos' then
    result := result + ' - ' + PMercado^.Nombre;
end;

function TDataAccionesValor.GetDescMercadoIndicesActivo: string;
begin
  case Data.ValoresActivator.MercadoIndicesActivo of
    miTodos: result := 'Todos los índices';
    miEuropa: result := 'Indices Europa';
    miAsia: result := 'Indices Asia';
    miAmerica: result := 'Indices America';
  end;
end;

function TDataAccionesValor.GetNombreAgrupacionValores: string;
begin
  case Data.ValoresActivator.TipoAgrupacionValores of
    tavTodos : result := TODOS_DESC;
    tavTodosPaises: result := TODOS_PAISES_DESC;
    tavGrupo : result := GruposNOMBRE.Value;
    tavIndice : result := IndicesNOMBRE.Value;
    tavMercadoIndices : result := GetDescMercadoIndicesActivo;
    tavMercado : result := GetDescMercadoActivo;
    tavCarteraAbiertas : result := CarterasNOMBRE.Value + ' (A)';
    tavCarteraPendientes : result := CarterasNOMBRE.Value + ' (P)';
    tavPais: result := Data.ValoresActivator.PaisActivo;
  end;
  StringReplace(result, '&', '&&', [rfReplaceAll]);;
end;

function TDataAccionesValor.ResetGrupo(const nombre: string): integer;
begin
  if ExisteGrupo(nombre) then begin
    result := GruposOID_GRUPO.Value;
    dGrupoValor.Params[0].AsInteger := result;
    ExecQuery(dGrupoValor, true);
  end
  else
    result := -1;
end;

procedure TDataAccionesValor.ValoresGrupoModificados(const OIDGrupo: integer);
var valores: TValores;
begin
  valores := Data.ValoresActivator;
  if (valores.TipoAgrupacionValores = tavGrupo) and (valores.OIDAgrupacionActiva = OIDGrupo) then begin
    ActivarGrupo(OIDGrupo);
    if Assigned(FOnValorGrupoActivoBorrado) then
      FOnValorGrupoActivoBorrado(Self);
  end;
end;

procedure TDataAccionesValor.ActivarCartera(OID: integer; pendiente: boolean);
var LastPosOIDValor: integer;
begin
  if Carteras.Locate('OID_CARTERA', OID, []) then begin
    LastPosOIDValor := Data.OIDValor;
    Data.ValoresActivator.ActivarCartera(OID, pendiente);
    Bus.SendEvent(MessageMercadoGrupoCambiado);
    Data.IrAValor(LastPosOIDValor);
  end;
end;

procedure TDataAccionesValor.ActivarGrupo(OID: integer);
var LastPosOIDValor: integer;
begin
  if Grupos.Locate('OID_GRUPO', OID, []) then begin
    LastPosOIDValor := Data.OIDValor;
    Data.ValoresActivator.ActivarGrupo(OID);
    Bus.SendEvent(MessageMercadoGrupoCambiado);
    Data.IrAValor(LastPosOIDValor);
  end;
end;

procedure TDataAccionesValor.ActivarIndice(OID: integer);
var LastPosOIDValor: integer;
begin
  if Indices.Locate('OID_INDICE', OID, []) then begin
    LastPosOIDValor := Data.OIDValor;
    Data.ValoresActivator.ActivarIndice(OID);
    Bus.SendEvent(MessageMercadoGrupoCambiado);
    Data.IrAValor(LastPosOIDValor);
  end;
end;

end.
