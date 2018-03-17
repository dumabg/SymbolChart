unit dmEditFS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFS, IBSQL, DB, IBCustomDataSet, IBQuery, UtilDB;

type
  TEditFS = class(TFS)
    iFS: TIBSQL;
    uFS: TIBSQL;
    dFS: TIBSQL;
  private
    OIDGenerator: TOIDGenerator;
  protected
    function Add(const OIDPadre: integer; const nombre: string; const tipo: TFSType;
      const Data: Pointer): integer; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddRootDirectory(const nombre: string): integer;
    function AddRootFile(const nombre: string; const data: Pointer): integer;
    function AddDirectory(const OIDPadre: integer; const nombre: string): integer;
    function AddFile(const OIDPadre: integer; const nombre: string; const data: Pointer): integer; virtual;
    procedure Delete(const OID: integer); virtual;
    procedure Update(const OID, OIDPadre: integer; const nombre: string); virtual;
  end;

implementation

uses dmBD, UtilDBSC, StrUtils;

{$R *.dfm}

{ TEditFS }

function TEditFS.Add(const OIDPadre: integer; const nombre: string;
  const tipo: TFSType; const Data: Pointer): integer;
var OID: integer;
begin
  //No se hace nada con el Data. Sencillamente se pasa por si alguna clase
  // derivada la utiliza para alguna cosa.
  OID := OIDGenerator.NextOID;
  iFS.ParamByName('OID_FS').AsInteger := OID;
  iFS.ParamByName('NOMBRE').AsString := nombre;
  iFS.ParamByName('OR_PADRE').AsInteger := OIDPadre;
  iFS.ParamByName('TIPO').AsString := FSTypeToString(tipo);
  ExecQuery(iFS, false);
  result := OID;
end;

function TEditFS.AddDirectory(const OIDPadre: integer;
  const nombre: string): integer;
begin
  result := Add(OIDPadre, nombre, fstDirectory, nil);
end;

function TEditFS.AddFile(const OIDPadre: integer;
  const nombre: string; const data: Pointer): integer;
begin
  result := Add(OIDPadre, nombre, fstFile, data);
end;

function TEditFS.AddRootDirectory(const nombre: string): integer;
begin
  result := AddDirectory(OIDRoot, nombre);
end;

function TEditFS.AddRootFile(const nombre: string; const data: Pointer): integer;
begin
  result := AddFile(OIDRoot, nombre, data);
end;

constructor TEditFS.Create(AOwner: TComponent);
var FSName: string;
begin
  inherited;
  FSName := GetFileSystemName;
  OIDGenerator := TOIDGenerator.Create(scdUsuario, FSName, 'OID_FS');
  iFS.SQL.Text := ReplaceStr(iFS.SQL.Text, '<TABLE>', FSName);
  uFS.SQL.Text := ReplaceStr(uFS.SQL.Text, '<TABLE>', FSName);
  dFS.SQL.Text := ReplaceStr(dFS.SQL.Text, '<TABLE>', FSName);
end;

procedure TEditFS.Delete(const OID: integer);
begin
  dFS.Params[0].AsInteger := OID;
  ExecQuery(dFS, true);
end;

destructor TEditFS.Destroy;
begin
  OIDGenerator.Free;
  inherited;
end;

procedure TEditFS.Update(const OID, OIDPadre: integer; const nombre: string);
begin
  uFS.ParamByName('OID_FS').AsInteger := OID;
  uFS.ParamByName('NOMBRE').AsString := nombre;
  uFS.ParamByName('OR_PADRE').AsInteger := OIDPadre;
  ExecQuery(uFS, true);
end;

end.
