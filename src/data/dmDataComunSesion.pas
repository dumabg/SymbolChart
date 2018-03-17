unit dmDataComunSesion;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, Controls;

type
  EDataComunSesion = class(Exception);

  TSesion = record
    OIDSesion: integer;
    Fecha: TDate;
  end;

  TDataComunSesion = class(TDataModule)
    qSesionFecha: TIBQuery;
    qSesionFechaOID_SESION: TSmallintField;
    qSesionFechaFECHA: TDateField;
  private
    SesionesFecha: array of TSesion;
  protected
    procedure LoadData; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    function GetFecha(const OIDSesion: integer): TDate;
    function GetFechaCursor(const cursor: integer): TDate;
    function GetOIDSesion(const fecha: TDate): integer; overload;
    function GetOIDSesion(const fecha: TDate; const seekNumDias: Integer): integer; overload;
    function GetOIDSesion(const OIDSesion: integer; const seekNumDias: Integer): integer; overload;
    function GetOIDSesionCursor(const cursor: integer): integer;
    procedure First(var cursor: integer);
    procedure Next(var cursor: integer);
    function Eof(const cursor: integer): boolean;
  end;

  TDataComunSesionDiario = class(TDataComunSesion)
  public
  end;

  TDataComunSesionSemanal = class(TDataComunSesion)
  protected
    procedure LoadData; override;
  end;

var
  DataComunSesionDiario: TDataComunSesionDiario;
  DataComunSesionSemanal: TDataComunSesionSemanal;

  procedure GlobalInitialization;
  procedure GlobalFinalization;

implementation

uses dmBD, UtilDB, IBDatabase;

{$R *.dfm}

resourcestring
  NO_SESION = 'No se ha encontrado la sesión %d';
  NO_FECHA = 'No se ha encontrado la fecha %s';


{ TDataComunSesionSemanal }

procedure TDataComunSesionSemanal.LoadData;
var BDSemanal: TIBDatabase;
begin
  BDSemanal := BD.GetNewDatabase(nil, scdDatos, bddSemanal);
  try
    qSesionFecha.Database := BDSemanal;
    qSesionFecha.Transaction := BDSemanal.DefaultTransaction;
    inherited LoadData;
  finally
    BDSemanal.Free;
  end;
end;

{ TDataComunSesion }

constructor TDataComunSesion.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LoadData;
end;

function TDataComunSesion.Eof(const cursor: integer): Boolean;
begin
  result := cursor = length(SesionesFecha);
end;

procedure TDataComunSesion.First(var cursor: integer);
begin
  cursor := 0;
end;

function TDataComunSesion.GetFecha(const OIDSesion: integer): TDate;
var i, num: integer;
begin
  num := Length(SesionesFecha);
  i := 0;
  while i < num do begin
    if SesionesFecha[i].OIDSesion = OIDSesion then begin
      result := SesionesFecha[i].Fecha;
      exit;
    end;
    inc(i);
  end;
  raise EDataComunSesion.Create(Format(NO_SESION, [OIDSesion]));
end;

function TDataComunSesion.GetFechaCursor(const cursor: integer): TDate;
begin
  result := SesionesFecha[cursor].Fecha;
end;

function TDataComunSesion.GetOIDSesion(const fecha: TDate;
  const seekNumDias: Integer): integer;
var i, num: integer;
begin
  num := Length(SesionesFecha);
  i := 0;
  while i < num do begin
    if SesionesFecha[i].Fecha = fecha then begin
      i := i + seekNumDias;
      if i > num then
        i := num
      else
        if i < 0 then
          i := 0;
      result := SesionesFecha[i].OIDSesion;
      exit;
    end;
    inc(i);
  end;
  raise EDataComunSesion.Create(Format(NO_FECHA, [DateToStr(fecha)]));
end;

procedure TDataComunSesion.Next(var cursor: integer);
begin
  inc(cursor);
end;

function TDataComunSesion.GetOIDSesion(const fecha: TDate): integer;
var i, num: integer;
begin
  num := Length(SesionesFecha);
  i := 0;
  while i < num do begin
    if SesionesFecha[i].Fecha = fecha then begin
      result := SesionesFecha[i].OIDSesion;
      exit;
    end;
    inc(i);
  end;
  raise EDataComunSesion.Create(Format(NO_FECHA, [DateToStr(fecha)]));
end;

function TDataComunSesion.GetOIDSesionCursor(const cursor: integer): Integer;
begin
  result := SesionesFecha[cursor].OIDSesion;
end;

procedure TDataComunSesion.LoadData;
var i: Integer;
begin
  OpenDataSetRecordCount(qSesionFecha);
  SetLength(SesionesFecha, qSesionFecha.RecordCount);
  i := 0;
  while not qSesionFecha.Eof do begin
    SesionesFecha[i].OIDSesion := qSesionFechaOID_SESION.Value;
    SesionesFecha[i].Fecha := qSesionFechaFECHA.Value;
    inc(i);
    qSesionFecha.Next;
  end;
end;

function TDataComunSesion.GetOIDSesion(const OIDSesion,
  seekNumDias: Integer): integer;
var i, num: integer;
begin
  num := Length(SesionesFecha) - 1;
  i := 0;
  while i <= num do begin
    if SesionesFecha[i].OIDSesion = OIDSesion then begin
      i := i + seekNumDias;
      if i > num then
        i := num
      else
        if i < 0 then
          i := 0;
      result := SesionesFecha[i].OIDSesion;
      exit;
    end;
    inc(i);
  end;
  raise EDataComunSesion.Create(Format(NO_SESION, [OIDSesion]));
end;


procedure GlobalInitialization;
begin
  // Se crea primero el semanal porque así cuando se cree el diario configura
  // la BD a diario y el programa ya arranca en diario.
  DataComunSesionSemanal := TDataComunSesionSemanal.Create(nil);
  DataComunSesionDiario := TDataComunSesionDiario.Create(nil);
end;

procedure GlobalFinalization;
begin
  DataComunSesionDiario.Free;
  DataComunSesionSemanal.Free;
end;


end.
