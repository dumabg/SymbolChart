unit dmSistemaStorage;

interface

uses
  Windows, SysUtils, Classes, JvComponentBase, JvAppStorage, JvAppDBStorage,
  IBCustomDataSet, IBUpdateSQL, DB, IBQuery, UtilDB, IBDatabase;

type
  TSistemaStorage = class(TDataModule)
    qSistema: TIBQuery;
    qSistemaOID_SISTEMA: TIntegerField;
    qSistemaSECCION: TIBStringField;
    qSistemaNOMBRE: TIBStringField;
    qSistemaVALOR: TMemoField;
    uSistema: TIBUpdateSQL;
    IBTransaction: TIBTransaction;
    IBDatabaseUsuario: TIBDatabase;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    OIDGenerator: TOIDGenerator;
    criticalSection: TRTLCriticalSection;
    procedure Write(const seccion: string; const clave: string; const valor: Variant);
  public
    procedure DeleteSeccion(const seccion: string);
    procedure Delete(const seccion, clave: string);
    procedure DeleteSubseccion(const subseccion: string);
    function ReadCurrency(const seccion: string; const clave: string; const default: currency): currency;
    function ReadString(const seccion: string; const clave: string; const default: string): string;
    function ReadInteger(const seccion: string; const clave: string; const default: integer): integer;
    function ReadBoolean(const seccion: string; const clave: string; const default: boolean): boolean;
    function ReadDateTime(const seccion: string; const clave: string; const default: TDateTime): TDateTime;
    procedure WriteCurrency(const seccion: string; const clave: string; const valor: currency);
    procedure WriteString(const seccion: string; const clave: string; const valor: string);
    procedure WriteInteger(const seccion: string; const clave: string; const valor: integer);
    procedure WriteBoolean(const seccion: string; const clave: string; const valor: boolean);
    procedure WriteDateTime(const seccion: string; const clave: string; const valor: TDateTime);
  end;


implementation

uses dmBD, StrUtils, Variants;

{$R *.dfm}

{ TSistemaStorage }

function TSistemaStorage.ReadBoolean(const seccion, clave: string;
  const default: boolean): boolean;
begin
  EnterCriticalSection(criticalSection);
  try
    if qSistema.Locate('SECCION;NOMBRE', VarArrayOf([seccion, clave]), []) then
      result := StrToBool(qSistemaVALOR.Value)
    else
      result := default;
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TSistemaStorage.ReadInteger(const seccion, clave: string;
  const default: integer): integer;
begin
  EnterCriticalSection(criticalSection);
  try
    if qSistema.Locate('SECCION;NOMBRE', VarArrayOf([seccion, clave]), []) then
      result := StrToInt(qSistemaVALOR.Value)
    else
      result := default;
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TSistemaStorage.ReadString(const seccion, clave,
  default: string): string;
begin
  EnterCriticalSection(criticalSection);
  try
    if qSistema.Locate('SECCION;NOMBRE', VarArrayOf([seccion, clave]), []) then
      result := qSistemaVALOR.AsString
    else
      result := default;
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

procedure TSistemaStorage.Write(const seccion, clave: string;
  const valor: Variant);
begin
  EnterCriticalSection(criticalSection);
  try
    try
      IBTransaction.Active := true;
      if qSistema.Locate('SECCION;NOMBRE', VarArrayOf([seccion, clave]), []) then begin
        qSistema.Edit;
      end
      else begin
        qSistema.Append;
        qSistemaOID_SISTEMA.Value := OIDGenerator.NextOID;
        qSistemaSECCION.Value := seccion;
        qSistemaNOMBRE.Value := clave;
      end;
      qSistemaVALOR.AsVariant := valor;
      qSistema.Post;
      IBTransaction.CommitRetaining;
    except
      IBTransaction.RollbackRetaining;
      raise;
    end;
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

procedure TSistemaStorage.WriteBoolean(const seccion, clave: string;
  const valor: boolean);
begin
  Write(seccion, clave, valor);
end;

procedure TSistemaStorage.WriteInteger(const seccion, clave: string;
  const valor: integer);
begin
  Write(seccion, clave, valor);
end;

procedure TSistemaStorage.WriteString(const seccion, clave, valor: string);
begin
  Write(seccion, clave, valor);
end;

procedure TSistemaStorage.DataModuleCreate(Sender: TObject);
begin
  BD.ConfigureDatabase(IBDatabaseUsuario, bddDiaria);
  OpenDatabase(IBDatabaseUsuario);
  InitializeCriticalSection(criticalSection);
  OIDGenerator := TOIDGenerator.Create(IBDatabaseUsuario, 'SISTEMA');
  qSistema.Open;
end;

procedure TSistemaStorage.DataModuleDestroy(Sender: TObject);
begin
  DeleteCriticalSection(criticalSection);
  OIDGenerator.Free;
end;

procedure TSistemaStorage.Delete(const seccion, clave: string);
begin
  EnterCriticalSection(criticalSection);
  try
    if qSistema.Locate('SECCION;NOMBRE', VarArrayOf([seccion, clave]), []) then
      qSistema.Delete;
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

procedure TSistemaStorage.DeleteSeccion(const seccion: string);
begin
  EnterCriticalSection(criticalSection);
  try
    while qSistema.Locate('SECCION', seccion, []) do
      qSistema.Delete;
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

procedure TSistemaStorage.DeleteSubseccion(const subseccion: string);
begin
  EnterCriticalSection(criticalSection);
  try
    qSistema.First;
    while not qSistema.Eof do begin
      if StartsText(subseccion, qSistemaSECCION.Value) then
        qSistema.Delete
      else
        qSistema.Next;
    end;
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TSistemaStorage.ReadCurrency(const seccion, clave: string;
  const default: currency): currency;
begin
  EnterCriticalSection(criticalSection);
  try
    if qSistema.Locate('SECCION;NOMBRE', VarArrayOf([seccion, clave]), []) then
      result := StrToCurr(qSistemaVALOR.Value)
    else
      result := default;
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TSistemaStorage.ReadDateTime(const seccion, clave: string;
  const default: TDateTime): TDateTime;
begin
  EnterCriticalSection(criticalSection);
  try
    if qSistema.Locate('SECCION;NOMBRE', VarArrayOf([seccion, clave]), []) then
      result := StrToDateTime(qSistemaVALOR.Value)
    else
      result := default;
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

procedure TSistemaStorage.WriteCurrency(const seccion, clave: string;
  const valor: currency);
begin
  Write(seccion, clave, valor);
end;

procedure TSistemaStorage.WriteDateTime(const seccion, clave: string;
  const valor: TDateTime);
begin
  Write(seccion, clave, valor);
end;


end.
