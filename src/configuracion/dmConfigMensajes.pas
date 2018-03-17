unit dmConfigMensajes;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery;

const
  MENSAJE_PRINCIPAL: string = '###PRINCIPAL###';

type
  TConfigMensajes = class(TDataModule)
    TipoMensajes: TIBQuery;
    TipoMensajesOID_TIPO_MENSAJE: TSmallintField;
    TipoMensajesDESCRIPCION: TIBStringField;
    TipoMensajesPOSICION: TSmallintField;
    TipoMensajesCAMPO: TIBStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FMensajes: TStringList;
    function GetTituloMensajeMismaLinea: boolean;
    function GetSeparacionEntreMensajes: boolean;
    function GetTamanoFuente: integer;
    function GetVisible(i: integer): boolean;
    procedure SetVisible(i: integer; const Value: boolean);
    function GetIncrustar: boolean;
    procedure SetIncrustar(const Value: boolean);
    procedure SetSeparacionEntreMensajes(const Value: boolean);
    procedure SetTamanoFuente(const Value: integer);
    procedure SetTituloMensajeMismaLinea(const Value: boolean);
    function GetActualizarArrastrar: boolean;
    procedure SetActualizarArrastrar(const Value: boolean);
  public
    property Visible[i: integer]: boolean read GetVisible write SetVisible;
    property Mensajes: TStringList read FMensajes;
    property TituloMensajeMismaLinea: boolean read GetTituloMensajeMismaLinea write SetTituloMensajeMismaLinea;
    property SeparacionEntreMensajes: boolean read GetSeparacionEntreMensajes write SetSeparacionEntreMensajes;
    property Incrustar: boolean read GetIncrustar write SetIncrustar;
    property TamanoFuente: integer read GetTamanoFuente write SetTamanoFuente;
    property ActualizarArrastrar: boolean read GetActualizarArrastrar write SetActualizarArrastrar;
  end;


implementation

uses dmBD, UtilDB, dmConfiguracion;

{$R *.dfm}

const SECCION: string = 'Configuracion.Mensajes';

{ TConfigMensajes }

procedure TConfigMensajes.DataModuleCreate(Sender: TObject);
var nombre: string;
begin
  FMensajes := TStringList.Create;
  OpenDataSet(TipoMensajes);
  while not TipoMensajes.Eof do begin
    nombre := TipoMensajesDESCRIPCION.Value;
    if nombre <> MENSAJE_PRINCIPAL then
      FMensajes.AddObject(nombre, TObject(TipoMensajesOID_TIPO_MENSAJE.Value));
    TipoMensajes.Next;
  end;
  TipoMensajes.Close;
end;


procedure TConfigMensajes.DataModuleDestroy(Sender: TObject);
begin
  FMensajes.Free;
end;

function TConfigMensajes.GetActualizarArrastrar: boolean;
begin
  result := Configuracion.ReadBoolean(SECCION, 'ActualizarArrastrar', true);
end;

function TConfigMensajes.GetIncrustar: boolean;
begin
  result := Configuracion.ReadBoolean(SECCION, 'Incrustar', true);
end;

function TConfigMensajes.GetSeparacionEntreMensajes: boolean;
begin
  result := Configuracion.ReadBoolean(SECCION, 'SeparacionEntreMensajes', true);
end;

function TConfigMensajes.GetTamanoFuente: integer;
begin
  result := Configuracion.ReadInteger(SECCION, 'TamanoFuente', 6);
end;

function TConfigMensajes.GetTituloMensajeMismaLinea: boolean;
begin
  result := Configuracion.ReadBoolean(SECCION, 'TituloMensajeMismaLinea', false);
end;

function TConfigMensajes.GetVisible(i: integer): boolean;
begin
  result := Configuracion.ReadBoolean(SECCION, IntToStr(i), true);
end;

procedure TConfigMensajes.SetActualizarArrastrar(const Value: boolean);
begin
  Configuracion.WriteBoolean(SECCION, 'ActualizarArrastrar', Value);
end;

procedure TConfigMensajes.SetIncrustar(const Value: boolean);
begin
  Configuracion.WriteBoolean(SECCION, 'Incrustar', Value);
end;

procedure TConfigMensajes.SetSeparacionEntreMensajes(const Value: boolean);
begin
  Configuracion.WriteBoolean(SECCION, 'SeparacionEntreMensajes', Value);
end;

procedure TConfigMensajes.SetTamanoFuente(const Value: integer);
begin
  Configuracion.WriteInteger(SECCION, 'TamanoFuente', Value);
end;

procedure TConfigMensajes.SetTituloMensajeMismaLinea(const Value: boolean);
begin
  Configuracion.WriteBoolean(SECCION, 'TituloMensajeMismaLinea', Value);
end;

procedure TConfigMensajes.SetVisible(i: integer; const Value: boolean);
begin
  Configuracion.WriteBoolean(SECCION, IntToStr(i), Value);
end;

end.
