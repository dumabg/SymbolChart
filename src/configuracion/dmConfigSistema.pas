unit dmConfigSistema;

interface

uses
  SysUtils, Classes, IBCustomDataSet, IBUpdateSQL, DB, IBQuery;

type
  TConfigSistema = class(TDataModule)
    qSistema: TIBQuery;
    qSistemaOID_SISTEMA: TIntegerField;
    qSistemaSECCION: TIBStringField;
    qSistemaNOMBRE: TIBStringField;
    qSistemaVALOR: TMemoField;
    uSistema: TIBUpdateSQL;
    procedure DataModuleCreate(Sender: TObject);
  private
    FURLServidor: string;
    FGUID: string;
    function GetIdioma: string;
    function GetServidorModificacionComun: integer;
    function GetVersion: string;
    procedure SetServidorModificacionComun(const Value: integer);
    function GetCorreo: Integer;
    procedure SetCorreo(const Value: Integer);
    function GetServidorModificacionDiaria: integer;
    procedure SetServidorModificacionDiaria(const Value: integer);
    function GetServidorModificacionSemanal: integer;
    procedure SetServidorModificacionSemanal(const Value: integer);
  public
    procedure Commit;
    property Idioma: string read GetIdioma;
    property Version: string read GetVersion;
    property URLServidor: string read FURLServidor;
    property ServidorModificacionComun: integer read GetServidorModificacionComun write SetServidorModificacionComun;
    property ServidorModificacionDiaria: integer read GetServidorModificacionDiaria write SetServidorModificacionDiaria;
    property ServidorModificacionSemanal: integer read GetServidorModificacionSemanal write SetServidorModificacionSemanal;
    property GUID: string read FGUID write FGUID; //Solo se hace el write cuando es la primera vez, después de instalado
    property OIDCorreo: Integer read GetCorreo write SetCorreo;
  end;


implementation

uses dmBD, Variants, dmInternalServer;

{$R *.dfm}

resourcestring
  IDIOMA_PROGRAMA = 'ES';

const
  SERVER_SECCION = 'SERVER';
  VALOR_SERVER_HOST = 'HOST';
  VALOR_SERVER_MODIFICACION_COMUN = 'MODIFICACION_C';
  VALOR_SERVER_MODIFICACION_DIARIA = 'MODIFICACION_D';
  VALOR_SERVER_MODIFICACION_SEMANAL = 'MODIFICACION_S';

  SISTEMA_SECCION = 'SISTEMA';
  VALOR_SISTEMA_GUID = 'GUID';
  VALOR_CORREO_OID = 'OID_CORREO';

procedure TConfigSistema.Commit;
begin
  qSistema.Transaction.CommitRetaining;
end;

procedure TConfigSistema.DataModuleCreate(Sender: TObject);
begin
  qSistema.Open;
  if qSistema.Locate('SECCION;NOMBRE', VarArrayOf([SISTEMA_SECCION, VALOR_SISTEMA_GUID]), []) then
    FGUID := qSistemaVALOR.Value
  else
    FGUID := '';
  assert(qSistema.Locate('SECCION;NOMBRE', VarArrayOf([SERVER_SECCION, VALOR_SERVER_HOST]), []));
  FURLServidor := qSistemaVALOR.Value;
  TInternalServer.URLServidor := FURLServidor;
//  TInternalServer.TimeOut := 0;
end;

function TConfigSistema.GetCorreo: Integer;
begin
  assert(qSistema.Locate('SECCION;NOMBRE', VarArrayOf([SERVER_SECCION, VALOR_CORREO_OID]), []));
  // Los TMemoField no tienen sobrecargado AsInteger
  result := StrToInt(qSistemaVALOR.AsString);
end;

function TConfigSistema.GetIdioma: string;
begin
  result := IDIOMA_PROGRAMA;
end;

function TConfigSistema.GetServidorModificacionComun: integer;
begin
  assert(qSistema.Locate('SECCION;NOMBRE', VarArrayOf([SERVER_SECCION, VALOR_SERVER_MODIFICACION_COMUN]), []));
  // Los TMemoField no tienen sobrecargado AsInteger
  result := StrToInt(qSistemaVALOR.AsString);
end;

function TConfigSistema.GetServidorModificacionDiaria: integer;
begin
  assert(qSistema.Locate('SECCION;NOMBRE', VarArrayOf([SERVER_SECCION, VALOR_SERVER_MODIFICACION_DIARIA]), []));
  // Los TMemoField no tienen sobrecargado AsInteger
  result := StrToInt(qSistemaVALOR.AsString);
end;

function TConfigSistema.GetServidorModificacionSemanal: integer;
begin
  assert(qSistema.Locate('SECCION;NOMBRE', VarArrayOf([SERVER_SECCION, VALOR_SERVER_MODIFICACION_SEMANAL]), []));
  // Los TMemoField no tienen sobrecargado AsInteger
  result := StrToInt(qSistemaVALOR.AsString);
end;

function TConfigSistema.GetVersion: string;
begin
  result := '2012.3';
end;

procedure TConfigSistema.SetCorreo(const Value: Integer);
begin
  assert(qSistema.Locate('SECCION;NOMBRE', VarArrayOf([SERVER_SECCION, VALOR_CORREO_OID]), []));
  qSistema.Edit;
  qSistemaVALOR.Value := IntToStr(Value);
  qSistema.Post;
end;

procedure TConfigSistema.SetServidorModificacionComun(const Value: integer);
begin
  assert(qSistema.Locate('SECCION;NOMBRE', VarArrayOf([SERVER_SECCION, VALOR_SERVER_MODIFICACION_COMUN]), []));
  qSistema.Edit;
  qSistemaVALOR.Value := IntToStr(Value);
  qSistema.Post;
end;

procedure TConfigSistema.SetServidorModificacionDiaria(const Value: integer);
begin
  assert(qSistema.Locate('SECCION;NOMBRE', VarArrayOf([SERVER_SECCION, VALOR_SERVER_MODIFICACION_DIARIA]), []));
  qSistema.Edit;
  qSistemaVALOR.Value := IntToStr(Value);
  qSistema.Post;
end;

procedure TConfigSistema.SetServidorModificacionSemanal(const Value: integer);
begin
  assert(qSistema.Locate('SECCION;NOMBRE', VarArrayOf([SERVER_SECCION, VALOR_SERVER_MODIFICACION_SEMANAL]), []));
  qSistema.Edit;
  qSistemaVALOR.Value := IntToStr(Value);
  qSistema.Post;
end;

end.
