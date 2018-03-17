unit dmSaldo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  dmInternalUserServer, DB, dmInternalServer,
  UserServerCalls, IBCustomDataSet, IBQuery, SOAPHTTPTrans, auHTTP;

type
  TStatusResult = UserServerCalls.TStatusResult;

  TSaldo = class(TInternalUserServer)
    qSesion: TIBQuery;
    qSesionOID_SESION: TSmallintField;
    procedure DataModuleCreate(Sender: TObject);
  private
    canceled: boolean;
    StatusServerCall: TStatusServerCall;
    LastOIDSesionDiario, LastOIDSesionSemanal: Integer;
    FStatus: TStatusResult;
    function GetCosteDiario: integer;
    function GetCosteSemanal: integer;
    function GetCreditos: integer;
    function GetFechaCaducidad: TDate;
    function GetFechaDiario: TDate;
    function GetFechaSemanal: TDate;
    function GetHaySemanal: boolean;
    function GetHayDiario: boolean;
  public
    destructor Destroy; override;
    procedure LoadData;
    procedure Cancel;
    property Status: TStatusResult read FStatus;
    property FechaDiario: TDate read GetFechaDiario;
    property FechaSemanal: TDate read GetFechaSemanal;
    property HaySemanal: boolean read GetHaySemanal;
    property HayDiario: boolean read GetHayDiario;
    property CosteDiario: integer read GetCosteDiario;
    property CosteSemanal: integer read GetCosteSemanal;
    property Creditos: integer read GetCreditos;
    property FechaCaducidad: TDate read GetFechaCaducidad;
  end;


implementation

uses dmBD, IBDatabase;

{$R *.dfm}

{ TSaldo }


procedure TSaldo.Cancel;
begin
  canceled := true;
  if StatusServerCall <> nil then
    StatusServerCall.Cancel;
end;

procedure TSaldo.DataModuleCreate(Sender: TObject);
var database: TIBDatabase;
begin
  inherited;
  database := BD.GetNewDatabase(nil, scdDatos, bddDiaria);
  try
    qSesion.Database := database;
    qSesion.Transaction := database.DefaultTransaction;
    qSesion.Open;
    LastOIDSesionDiario := qSesionOID_SESION.Value;
    qSesion.Close;
  finally
    database.Free;
  end;

  database := BD.GetNewDatabase(nil, scdDatos, bddSemanal);
  try
    qSesion.Database := database;
    qSesion.Transaction := database.DefaultTransaction;
    qSesion.Open;
    LastOIDSesionSemanal := qSesionOID_SESION.Value;
    qSesion.Close;
  finally
    database.Free;
  end;

  StatusServerCall := TStatusServerCall.Create(Self);
end;


destructor TSaldo.Destroy;
begin
  StatusServerCall.Free;
  inherited;
end;

function TSaldo.GetCosteDiario: integer;
begin
  result := StatusServerCall.CosteDiario;
end;

function TSaldo.GetCosteSemanal: integer;
begin
  result := StatusServerCall.CosteSemanal;
end;

function TSaldo.GetCreditos: integer;
begin
  result := StatusServerCall.Creditos;
end;

function TSaldo.GetFechaCaducidad: TDate;
begin
  result := StatusServerCall.FechaCaducidad;
end;

function TSaldo.GetFechaDiario: TDate;
begin
  result := StatusServerCall.FechaDiario;
end;

function TSaldo.GetFechaSemanal: TDate;
begin
  result := StatusServerCall.FechaSemanal;
end;

function TSaldo.GetHayDiario: boolean;
begin
  result := StatusServerCall.HayDiario;
end;

function TSaldo.GetHaySemanal: boolean;
begin
  result := StatusServerCall.HaySemanal;
end;

procedure TSaldo.LoadData;
begin
  canceled := false;
  FStatus := StatusServerCall.Call(LastOIDSesionDiario, LastOIDSesionSemanal);
  if canceled then
    raise EAbort.Create('Cancelado por el usuario');
end;

end.
