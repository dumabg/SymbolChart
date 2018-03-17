unit dmFS;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, 
  Controls, dmThreadDataModule;

type
  TFSType = (fstDirectory, fstFile);

  TFS = class(TThreadDataModule)
    qFS: TIBQuery;
    qFSOID_FS: TIntegerField;
    qFSOR_PADRE: TIntegerField;
    qFSTIPO: TIBStringField;
    qFSNOMBRE: TIBStringField;
    qFSChildCount: TIBQuery;
    qFSChildCountCOUNT: TIntegerField;
  private
    FOIDRoot: integer;
    FCount: integer;
    function GetNombreSize: integer;
    function GetNombre: string;
    function GetOID: integer;
    function GetOIDPadre: integer;
    function GetTipo: TFSType;
  protected
    const OID_ROOT: integer = 0;
    function FSTypeToString(const tipo: TFSType): string;
    function GetFileSystemName: string; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadRoot;
    procedure Load(const OID: integer);
    function Locate(const OID: integer): boolean;
    procedure Seek(const position: integer);
    procedure First;
    procedure Next;
    procedure Close;
    function ChildCount(const OIDPadre: integer): integer;
    function RootChildCount: integer;
    function Eof: boolean;
    property OIDRoot: integer read FOIDRoot write FOIDRoot;
    property Count: integer read FCount;
    property OID: integer read GetOID;
    property NombreSize: integer read GetNombreSize;
    property Nombre: string read GetNombre;
    property OIDPadre: integer read GetOIDPadre;
    property Tipo: TFSType read GetTipo;
  end;

implementation

uses dmBD, UtilDB, BDConstants, StrUtils, Variants;


{$R *.dfm}

{ TFS }

function TFS.ChildCount(const OIDPadre: integer): integer;
begin
  qFSChildCount.Close;
  qFSChildCount.Params[0].AsInteger := OIDPadre;
  qFSChildCount.Open;
  result := qFSChildCountCOUNT.Value;
end;

procedure TFS.Close;
begin
  qFS.Close;
end;

constructor TFS.Create(AOwner: TComponent);
var FSName: string;
begin
  inherited Create(AOwner);
  OIDRoot := OID_ROOT;
  FSName := GetFileSystemName;
  qFS.SQL.Text := ReplaceStr(qFS.SQL.Text, '<TABLE>', FSName);
  qFSChildCount.SQL.Text := ReplaceStr(qFSChildCount.SQL.Text, '<TABLE>', FSName);
end;

function TFS.Eof: boolean;
begin
  result := qFS.Eof;
end;

procedure TFS.First;
begin
  qFS.First;
end;

function TFS.FSTypeToString(const tipo: TFSType): string;
begin
  case tipo of
    fstDirectory: result := FS_TYPE_DIRECTORY;
    fstFile: result := FS_TYPE_FILE;
  end;
end;

function TFS.GetNombre: string;
begin
  result := qFSNOMBRE.Value;
end;

function TFS.GetNombreSize: integer;
begin
  result := qFSNOMBRE.Size;
end;

function TFS.GetOID: integer;
begin
  result := qFSOID_FS.Value;
end;

function TFS.GetOIDPadre: integer;
begin
  result := qFSOR_PADRE.Value;
end;

function TFS.GetTipo: TFSType;
begin
  if qFSTIPO.Value = FS_TYPE_DIRECTORY  then
    result := fstDirectory
  else
    result := fstFile;
end;

procedure TFS.Load(const OID: integer);
begin
  qFS.Close;
  qFS.Params[0].AsInteger := OID;
  OpenDataSet(qFS);
  qFS.Last;
  FCount := qFS.RecordCount;
end;

procedure TFS.LoadRoot;
begin
  Load(OIDRoot);
end;

function TFS.Locate(const OID: integer): boolean;
begin
  result := qFS.Locate('OID_FS', OID, []);
end;

procedure TFS.Next;
begin
  qFS.Next;
end;

function TFS.RootChildCount: integer;
begin
  result := ChildCount(OIDRoot);
end;

procedure TFS.Seek(const position: integer);
begin
  qFS.RecNo := position;
end;

end.
