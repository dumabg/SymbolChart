unit dmBD;

interface

uses
  SysUtils, Classes, IBDatabase, DB, dmThreadDataModule;

type
  TSCDatabase = (scdUsuario, scdComun, scdDatos);

  TBDDatos = (bddDiaria, bddSemanal);

  TBD = class(TThreadDataModule)
    IBDatabaseComun: TIBDatabase;
    IBTransactionComun: TIBTransaction;
    IBDatabaseUsuario: TIBDatabase;
    IBTransactionUsuario: TIBTransaction;
    IBDatabaseDatos: TIBDatabase;
    IBTransactionDatos: TIBTransaction;
  private
    class var
    MainBD: TBD;
    BDsPath: string;
    var
    FBDDatos: TBDDatos;
    procedure SetBDDatos(const Value: TBDDatos);
    function GetDatabasePath(const tipo: TSCDatabase; BDDatos: TBDDatos): TFileName;
    procedure OnInternalBDDatosChange;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetDatabase(const tipo: TSCDatabase): TIBDatabase;
    function GetNewDatabase(const AOwner: TComponent; const tipo: TSCDatabase; BDDatos: TBDDatos): TIBDatabase;
    function GetTipoDatabase(const database: TIBDatabase): TSCDatabase;
    procedure ConfigureDatabase(const database: TIBDatabase; const BDDatos: TBDDatos);
    property BDDatos: TBDDatos read FBDDatos write SetBDDatos;
//    constructor Create(AOwner: TComponent; const databaseName: string); overload;
  end;

  function BD: TBD;

  procedure GlobalInitialization;

implementation

{$R *.dfm}

uses Forms, UtilDB, UtilThread, BusCommunication;

{constructor TBD.Create(AOwner: TComponent; const databaseName: string);
var path: string;
begin
  inherited Create(AOwner);
  path := ExtractFileDir(Application.ExeName);
  if (FileExists(path + '\' + databaseName)) then
    path := path + '\' + databaseName;

end;}

type
  MessageInternalBDDatosChange = class(TBusMessage);

function BD: TBD;
begin
  result := TBD(DataModuleManager.GetDataModule('BD'));
end;

procedure TBD.ConfigureDatabase(const database: TIBDatabase; const BDDatos: TBDDatos);
begin
  database.DatabaseName := GetDatabasePath(GetTipoDatabase(database), BDDatos);
end;

constructor TBD.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if MainBD = nil then begin
    MainBD := Self;
    BDsPath := ExtractFilePath(Application.ExeName);
    FBDDatos := bddDiaria;
  end
  else begin
    FBDDatos := MainBD.BDDatos;
    Bus.RegisterEvent(MessageInternalBDDatosChange, OnInternalBDDatosChange);
  end;
  IBDatabaseComun.DatabaseName := GetDatabasePath(scdComun, FBDDatos);
  IBDatabaseUsuario.DatabaseName := GetDatabasePath(scdUsuario, FBDDatos);
  IBDatabaseDatos.DatabaseName := GetDatabasePath(scdDatos, FBDDatos);
  OpenDatabase(IBDatabaseComun);
  OpenDatabase(IBDatabaseUsuario);
  OpenDatabase(IBDatabaseDatos);
end;

destructor TBD.Destroy;
begin
  if MainBD <> Self then
    Bus.UnregisterEvent(MessageInternalBDDatosChange, OnInternalBDDatosChange);
  inherited;
end;

function TBD.GetDatabase(const tipo: TSCDatabase): TIBDatabase;
begin
  case tipo of
    scdUsuario: result := IBDatabaseUsuario;
    scdComun: result := IBDatabaseComun;
    else result := IBDatabaseDatos;
  end;
end;

function TBD.GetDatabasePath(const tipo: TSCDatabase;
  BDDatos: TBDDatos): TFileName;

  function GetDBIdentifier: string;
  begin
    case tipo of
      scdUsuario: result := 'U';
      scdComun: result := 'C';
      scdDatos:
        if BDDatos = bddDiaria then
          result := 'DD'
        else
          result := 'DS';
    end;
  end;
begin
  result := BDsPath + 'SC' + GetDBIdentifier + '.dat';
end;

function TBD.GetNewDatabase(const AOwner: TComponent; const tipo: TSCDatabase;
  BDDatos: TBDDatos): TIBDatabase;
begin
  result := TIBDatabase.Create(AOwner);
  result.DefaultTransaction := TIBTransaction.Create(result);
  result.DatabaseName := GetDatabasePath(tipo, BDDatos);
  OpenDatabase(result);
end;

function TBD.GetTipoDatabase(const database: TIBDatabase): TSCDatabase;
var dbName: TIBFileName;
begin
  dbName := database.Name;
  if dbName = IBDatabaseDatos.Name then
    result := scdDatos
  else
    if dbName = IBDatabaseComun.Name then
      result := scdComun
    else
      if dbName = IBDatabaseUsuario.Name then
        result := scdUsuario
      else
        raise Exception.Create('database not found: ' + dbName);
end;

procedure TBD.OnInternalBDDatosChange;
begin
  SetBDDatos(MainBD.BDDatos);
end;

procedure TBD.SetBDDatos(const Value: TBDDatos);
begin
  if FBDDatos <> Value then begin
    FBDDatos := Value;
    IBDatabaseDatos.Close;
    IBDatabaseDatos.DatabaseName := GetDatabasePath(scdDatos, FBDDatos);
    OpenDatabase(IBDatabaseDatos);
    if MainBD = Self then
      Bus.SendEvent(MessageInternalBDDatosChange);
  end;
end;


procedure GlobalInitialization;
begin
  DataModuleManager.RegisterAutoCreateDataModule('BD', TBD);
end;

end.
