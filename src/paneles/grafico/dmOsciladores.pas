unit dmOsciladores;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, dmEditFS, IBSQL, IBUpdateSQL,
  Graphics, dmFS;

type
  TOnDelete = procedure (const OID: integer) of object;
  TOnUpdate = procedure (const OID: Integer; const name: string) of object;

  TOsciladores = class(TEditFS)
    qOscilador: TIBQuery;
    qOsciladorOR_FS: TIntegerField;
    qOsciladorCODIGO: TMemoField;
    qOsciladorCODIGO_COMPILED: TMemoField;
    qOsciladorCOLOR: TIntegerField;
    uOscilador: TIBUpdateSQL;
    iOscilador: TIBSQL;
  private
    FOnDelete: TOnDelete;
    FOnUpdate: TOnUpdate;
    function GetCodigo: string;
    function GetCodigoCompiled: string;
    function GetColor: TColor;
    procedure SetCodigo(const Value: string);
    procedure SetCodigoCompiled(const Value: string);
    procedure SetColor(const Value: TColor);
  protected
    function GetFileSystemName: string; override;
    function Add(const OIDPadre: integer; const nombre: string;
      const tipo: TFSType; const data: pointer): integer; override;
  public
    procedure Delete(const OID: integer); override;
    procedure Update(const OID, OIDPadre: integer; const nombre: string); override;
    procedure Load(const OIDFS: integer);
    procedure BeginGuardar(const OIDFS: Integer);
    procedure EndGuardar;
    function HasCodigoCompiled: boolean;
    property Codigo: string read GetCodigo write SetCodigo;
    property CodigoCompiled: string read GetCodigoCompiled write SetCodigoCompiled;
    property Color: TColor read GetColor write SetColor;
    property OnDelete: TOnDelete read FOnDelete write FOnDelete;
    property OnUpdate: TOnUpdate read FOnUpdate write FOnUpdate;
  end;


implementation

uses dmBD, UtilDB;

{$R *.dfm}

const
  OSCILADOR_FS = 'OSCILADOR_FS';

{ TOscilador }

function TOsciladores.Add(const OIDPadre: integer; const nombre: string;
  const tipo: TFSType; const data: pointer): integer;
begin
  result := inherited Add(OIDPadre, nombre, tipo, data);
  if tipo = fstFile then begin
    iOscilador.ParamByName('OR_FS').AsInteger := result;
    iOscilador.ParamByName('COLOR').AsInteger := clBlue;
    ExecQuery(iOscilador, true);
  end;
end;

procedure TOsciladores.BeginGuardar(const OIDFS: Integer);
begin
  qOscilador.Edit;
  qOsciladorOR_FS.Value := OIDFS;
end;

procedure TOsciladores.Delete(const OID: integer);
begin
  inherited Delete(OID);
  if Assigned(FOnDelete) then
    FOnDelete(OID);
end;

procedure TOsciladores.EndGuardar;
begin
  qOscilador.Post;
  qOscilador.Transaction.CommitRetaining;
end;

function TOsciladores.GetCodigo: string;
begin
  result := qOsciladorCODIGO.Value;
end;

function TOsciladores.GetCodigoCompiled: string;
begin
  result := qOsciladorCODIGO_COMPILED.Value;
end;

function TOsciladores.GetColor: TColor;
begin
  result := TColor(qOsciladorCOLOR.Value);
end;

function TOsciladores.GetFileSystemName: string;
begin
  result := OSCILADOR_FS;
end;

function TOsciladores.HasCodigoCompiled: boolean;
begin
  result := qOsciladorCODIGO_COMPILED.Value <> '';
end;

procedure TOsciladores.Load(const OIDFS: integer);
begin
  qOscilador.Close;
  qOscilador.Params[0].AsInteger := OIDFS;
  OpenDataSet(qOscilador);
end;

procedure TOsciladores.SetCodigo(const Value: string);
begin
  qOsciladorCODIGO.Value := Value;
end;

procedure TOsciladores.SetCodigoCompiled(const Value: string);
begin
  qOsciladorCODIGO_COMPILED.Value := Value;
end;

procedure TOsciladores.SetColor(const Value: TColor);
begin
  qOsciladorCOLOR.Value := Value;
end;

procedure TOsciladores.Update(const OID, OIDPadre: integer;
  const nombre: string);
begin
  inherited Update(OID, OIDPadre, nombre);
  if Assigned(FOnUpdate) then
    FOnUpdate(OID, nombre);
end;

end.
