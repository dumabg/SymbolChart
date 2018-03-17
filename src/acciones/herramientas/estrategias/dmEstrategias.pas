unit dmEstrategias;

interface

uses
  SysUtils, Classes, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, eventos, UtilDB;

type
  TTipoEstrategia = (teApertura, teAperturaPosicionado, teCierre, teCierrePosicionado);

  TEstrategias = class(TDataModule)
    qEstrategias: TIBQuery;
    qEstrategiasOID_ESTRATEGIA: TSmallintField;
    qEstrategiasNOMBRE: TIBStringField;
    qEstrategiasDESCRIPCION: TMemoField;
    uEstrategias: TIBUpdateSQL;
    qEstrategiasTIPO: TIBStringField;
    qEstrategiasESTRATEGIA_APERTURA: TMemoField;
    qEstrategiasESTRATEGIA_CIERRE: TMemoField;
    qEstrategiasESTRATEGIA_APERTURA_POSICIONADO: TMemoField;
    qEstrategiasESTRATEGIA_CIERRE_POSICIONADO: TMemoField;
    qEstudios: TIBQuery;
    qEstudiosOID_ESTUDIO: TSmallintField;
    qEstudiosOR_CUENTA: TSmallintField;
    procedure DataModuleCreate(Sender: TObject);
    procedure qEstrategiasBeforeScroll(DataSet: TDataSet);
    procedure qEstrategiasFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure qEstrategiasAfterScroll(DataSet: TDataSet);
  private
    FBeforeScroll: TNotificacionEvent;
    FSoloProductivas: boolean;
    FAfterScroll: TNotificacionEvent;
    OIDGenerator: TOIDGenerator;
    procedure SetSoloProductivas(const Value: boolean);
  public
    destructor Destroy; override;
    function isProductivo: boolean;
    function hasEstrategia: boolean;
    function hasEstudios: boolean;
    procedure ToggleStatus;
    procedure ModificarEstrategia(const estrategia: string; const tipo: TTipoEstrategia);
    procedure AnadirEstrategia(const nombre: string);
    procedure GuardarEstrategias;
    procedure Borrar;
    procedure Duplicar;
    procedure IrA(const OIDEstrategia: integer);
    function IsEmpty: boolean;
    function GetEstrategia(tipo: TTipoEstrategia): string;
    property BeforeScroll: TNotificacionEvent read FBeforeScroll write FBeforeScroll;
    property AfterScroll: TNotificacionEvent read FAfterScroll write FAfterScroll;
    property SoloProductivas: boolean read FSoloProductivas write SetSoloProductivas;
  end;

implementation

uses dmBD, UtilDBSC;

{$R *.dfm}

const
  ESTRATEGIA_EXPERIMENTAL = 'E';
  ESTRATEGIA_PRODUCTIVA = 'P';
  ESTRATEGIA_POR_DEFECTO = 'begin' + sLineBreak +  sLineBreak + 'end.';

{ TEstrategias }

procedure TEstrategias.AnadirEstrategia(const nombre: string);
begin
  qEstrategias.Append;
  qEstrategiasOID_ESTRATEGIA.Value := OIDGenerator.NextOID;
  qEstrategiasNOMBRE.Value := nombre;
  qEstrategiasESTRATEGIA_APERTURA.Value := ESTRATEGIA_POR_DEFECTO;
  qEstrategiasESTRATEGIA_CIERRE.Value := ESTRATEGIA_POR_DEFECTO;
  qEstrategiasESTRATEGIA_APERTURA_POSICIONADO.Value := ESTRATEGIA_POR_DEFECTO;
  qEstrategiasESTRATEGIA_CIERRE_POSICIONADO.Value := ESTRATEGIA_POR_DEFECTO;
  qEstrategiasTIPO.Value := ESTRATEGIA_EXPERIMENTAL;
  qEstrategias.Post;
  BD.IBTransactionUsuario.CommitRetaining;
end;

procedure TEstrategias.Borrar;
begin
  qEstrategias.Delete;
  BD.IBTransactionUsuario.CommitRetaining;
end;

procedure TEstrategias.DataModuleCreate(Sender: TObject);
begin
  qEstrategias.Open;
  OIDGenerator := TOIDGenerator.Create(scdUsuario, 'ESTRATEGIA');
end;

destructor TEstrategias.Destroy;
begin
  OIDGenerator.Free;
  inherited;
end;

procedure TEstrategias.Duplicar;
var nombre, desc, estrategiaApertura, estrategiaCierre,
  estrategiaAperturaPos, estrategiaCierrePos, tipo: string;
begin
  nombre := qEstrategiasNOMBRE.Value;
  desc := qEstrategiasDESCRIPCION.Value;
  estrategiaApertura := qEstrategiasESTRATEGIA_APERTURA.Value;
  estrategiaCierre := qEstrategiasESTRATEGIA_CIERRE.Value;
  estrategiaAperturaPos := qEstrategiasESTRATEGIA_APERTURA_POSICIONADO.Value;
  estrategiaCierrePos := qEstrategiasESTRATEGIA_CIERRE_POSICIONADO.Value;
  tipo := qEstrategiasTIPO.Value;
  qEstrategias.Append;
  qEstrategiasOID_ESTRATEGIA.Value := OIDGenerator.NextOID;
  qEstrategiasNOMBRE.Value := 'Nueva ' + nombre;
  qEstrategiasDESCRIPCION.Value := desc;
  qEstrategiasESTRATEGIA_APERTURA.Value := estrategiaApertura;
  qEstrategiasESTRATEGIA_CIERRE.Value := estrategiaCierre;
  qEstrategiasESTRATEGIA_APERTURA_POSICIONADO.Value := estrategiaAperturaPos;
  qEstrategiasESTRATEGIA_CIERRE_POSICIONADO.Value := estrategiaCierrePos;
  qEstrategiasTIPO.Value := tipo;
  qEstrategias.Post;
  BD.IBTransactionUsuario.CommitRetaining;
end;

function TEstrategias.GetEstrategia(tipo: TTipoEstrategia): string;
begin
  case tipo of
    teApertura: result := qEstrategiasESTRATEGIA_APERTURA.Value;
    teAperturaPosicionado: result := qEstrategiasESTRATEGIA_APERTURA_POSICIONADO.Value;
    teCierre: result := qEstrategiasESTRATEGIA_CIERRE.Value;
    teCierrePosicionado: result := qEstrategiasESTRATEGIA_CIERRE_POSICIONADO.Value;
  end;
end;

procedure TEstrategias.GuardarEstrategias;
begin
  if qEstrategias.State in dsEditModes then begin
    qEstrategias.Post;
    BD.IBTransactionUsuario.CommitRetaining;
  end;
end;

function TEstrategias.hasEstrategia: boolean;
begin
  result := ((not qEstrategiasESTRATEGIA_APERTURA.IsNull) and
    (qEstrategiasESTRATEGIA_APERTURA.Value <> ESTRATEGIA_POR_DEFECTO)) or
    ((not qEstrategiasESTRATEGIA_CIERRE.IsNull) and
    (qEstrategiasESTRATEGIA_CIERRE.Value <> ESTRATEGIA_POR_DEFECTO)) or
    ((not qEstrategiasESTRATEGIA_APERTURA_POSICIONADO.IsNull) and
    (qEstrategiasESTRATEGIA_APERTURA_POSICIONADO.Value <> ESTRATEGIA_POR_DEFECTO)) or
    ((not qEstrategiasESTRATEGIA_CIERRE_POSICIONADO.IsNull) and
    (qEstrategiasESTRATEGIA_CIERRE_POSICIONADO.Value <> ESTRATEGIA_POR_DEFECTO));
end;

function TEstrategias.hasEstudios: boolean;
begin
  qEstudios.Close;
  qEstudios.Params[0].AsInteger := qEstrategiasOID_ESTRATEGIA.Value;
  qEstudios.Open;
  result := not qEstudios.IsEmpty;
end;

procedure TEstrategias.IrA(const OIDEstrategia: integer);
begin
  qEstrategias.Locate('OID_ESTRATEGIA', OIDEstrategia, []);
end;

function TEstrategias.IsEmpty: boolean;
begin
  result := qEstrategias.IsEmpty;
end;

function TEstrategias.isProductivo: boolean;
begin
  result := qEstrategiasTIPO.Value = ESTRATEGIA_PRODUCTIVA;
end;

procedure TEstrategias.ModificarEstrategia(const estrategia: string; const tipo: TTipoEstrategia);
begin
  if not (qEstrategias.State in dsEditModes) then
    qEstrategias.Edit;
  case tipo of
    teApertura: qEstrategiasESTRATEGIA_APERTURA.Value := estrategia;
    teAperturaPosicionado: qEstrategiasESTRATEGIA_APERTURA_POSICIONADO.Value := estrategia;
    teCierre: qEstrategiasESTRATEGIA_CIERRE.Value := estrategia;
    teCierrePosicionado: qEstrategiasESTRATEGIA_CIERRE_POSICIONADO.Value := estrategia;
  end;
  qEstrategias.Post;
  BD.IBTransactionUsuario.CommitRetaining;
end;

procedure TEstrategias.qEstrategiasAfterScroll(DataSet: TDataSet);
begin
  if Assigned(FAfterScroll) then
    FAfterScroll;
end;

procedure TEstrategias.qEstrategiasBeforeScroll(DataSet: TDataSet);
begin
  if Assigned(FBeforeScroll) then
    FBeforeScroll;
end;

procedure TEstrategias.qEstrategiasFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := qEstrategiasTIPO.Value = ESTRATEGIA_PRODUCTIVA;
end;

procedure TEstrategias.SetSoloProductivas(const Value: boolean);
begin
  FSoloProductivas := Value;
  qEstrategias.Filtered := FSoloProductivas;
end;

procedure TEstrategias.ToggleStatus;
begin
  if not (qEstrategias.State in dsEditModes) then
    qEstrategias.Edit;
  if qEstrategiasTIPO.Value = ESTRATEGIA_EXPERIMENTAL then
    qEstrategiasTIPO.Value := ESTRATEGIA_PRODUCTIVA
  else
    qEstrategiasTIPO.Value := ESTRATEGIA_EXPERIMENTAL;
end;

end.
