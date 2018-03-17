unit dmEstrategiaBase;

interface

uses
  SysUtils, Classes, DB,
    Controls, dmDataComun, kbmMemTable, dmThreadDataModule;

type
  TOnCanceledEvent = procedure (var raiseAbort: boolean) of object;

  TEstrategiaBase = class(TThreadDataModule)
    Posiciones: TkbmMemTable;
    PosicionesPUNTOS: TIntegerField;
    PosicionesOID_VALOR: TIntegerField;
    PosicionesNOMBRE: TStringField;
    PosicionesSIMBOLO: TStringField;
    PosicionesOID_MERCADO: TIntegerField;
    PosicionesMERCADO: TStringField;
    PosicionesPOSICION: TStringField;
    PosicionesSTOP: TCurrencyField;
    PosicionesLIMITE: TCurrencyField;
    Posicionados: TkbmMemTable;
    PosicionadosOID_VALOR: TIntegerField;
    PosicionadosSTOP: TCurrencyField;
    procedure DataModuleCreate(Sender: TObject);
  private
    FValores: TDataset;
    FieldOID_VALOR, FieldOID_MERCADO: TIntegerField;
    canceled: boolean;
    FOnCanceled: TOnCanceledEvent;
    procedure SetValores(const Value: TDataset);
    function GetOIDValor: integer; inline;
  protected
    function CambioEntrada: currency; virtual; abstract;
    procedure ModificarStop(stop: currency);
    procedure CerrarPosicion; virtual; abstract;
    procedure AbrirPosicion(const puntos: integer; const limitada, largo: boolean;
      const stop: currency; const limite: currency = -1);
    procedure AntesAbrirSesionValor(const OIDValor: integer); virtual; abstract;
    procedure AntesCerrarSesionValor(const OIDValor: integer); virtual; abstract;
    procedure AntesAbrirSesionPosicionadoValor(const OIDValor: integer); virtual; abstract;
    procedure AntesCerrarSesionPosicionadoValor(const OIDValor: integer); virtual; abstract;
    procedure Initialize;
    property OIDValor: integer read GetOIDValor;
  public
    constructor Create(const AOwner: TComponent; const Valores: TDataset); reintroduce; virtual;
    procedure AntesAbrirSesion; virtual;
    procedure AntesCerrarSesion; virtual;
    procedure AntesAbrirSesionPosicionados; virtual;
    procedure AntesCerrarSesionPosicionados; virtual;
    procedure Cancel;
    procedure AnadirPosicionado(const OIDValor: integer);
    procedure InicializarPosicionado;
    property Valores: TDataset read FValores write SetValores;
    property OnCanceled: TOnCanceledEvent read FOnCanceled write FOnCanceled;
  end;


implementation

uses UtilException, Forms, UtilDB;

{$R *.dfm}

{ TEstrategia }

procedure TEstrategiaBase.AbrirPosicion(const puntos: integer; const limitada: boolean;
  const largo: boolean; const stop: currency; const limite: currency);
var valor: PDataComunValor;
begin
  Posiciones.Append;
  PosicionesOID_VALOR.Value := OIDValor;
  valor := DataComun.FindValor(OIDValor);
  PosicionesNOMBRE.Value := valor^.Nombre;
  PosicionesSIMBOLO.Value := valor^.Simbolo;
  PosicionesOID_MERCADO.Value := valor^.Mercado^.OIDMercado;
  PosicionesMERCADO.Value := valor^.Mercado^.Nombre;
  if largo then
    PosicionesPOSICION.Value := 'L'
  else
    PosicionesPOSICION.Value := 'C';
  PosicionesSTOP.Value := stop;
  if limite = -1 then
    PosicionesLIMITE.Clear
  else
    PosicionesLIMITE.Value := limite;
  PosicionesPUNTOS.Value := puntos;
  Posiciones.Post;
end;

procedure TEstrategiaBase.AnadirPosicionado(const OIDValor: integer);
begin
  Posicionados.Append;
  PosicionadosOID_VALOR.Value := OIDValor;
  Posicionados.Post;
end;

procedure TEstrategiaBase.AntesAbrirSesion;
var raiseAbort: boolean;
  inspect: TInspectDataSet;
  OIDValor: integer;
  valor: PDataComunValor;
begin
  Initialize;
  inspect := StartInspectDataSet(FValores);
  try
    FValores.First;
    while not FValores.Eof do begin
      Application.ProcessMessages;
      if canceled then begin
        raiseAbort := true;
        if Assigned(FOnCanceled) then
          FOnCanceled(raiseAbort);
        if raiseAbort then
          raise EAbort.Create('Estrategia cancelada');
      end;
      OIDValor := FieldOID_VALOR.Value;
      try
        // Solo se permiten procesar valores de mercados
        if {(FieldOID_MERCADO.Value <= Mercado_Const.OID_ReinoUnido) and}
          (not Posicionados.Locate('OID_VALOR', OIDValor, [])) then
          AntesAbrirSesionValor(FieldOID_VALOR.Value);
      except
        on e: Exception do begin
          e.ClearInfo;
          e.AddInfo('OIDValor', IntToStr(OIDValor));
          valor := DataComun.FindValor(OIDValor);
          e.AddInfo('Nombre', valor^.Nombre);
          e.AddInfo('Simbolo', valor^.Simbolo);
          e.AddInfo('Mercado', valor^.Mercado^.Nombre);
          raise;
        end;
      end;
      FValores.Next;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;

procedure TEstrategiaBase.AntesAbrirSesionPosicionados;
var raiseAbort: boolean;
  inspect: TInspectDataSet;
  valor: PDataComunValor;
begin
  Initialize;
  inspect := StartInspectDataSet(FValores);
  try
    Posicionados.First;
    while not Posicionados.Eof do begin
      Application.ProcessMessages;
      if canceled then begin
        raiseAbort := true;
        if Assigned(FOnCanceled) then
          FOnCanceled(raiseAbort);
        if raiseAbort then
          raise EAbort.Create('Estrategia cancelada');
      end;
      try
        if FValores.Locate('OID_VALOR', PosicionadosOID_VALOR.Value, []) then
          AntesAbrirSesionPosicionadoValor(FieldOID_VALOR.Value);
      except
        on e: Exception do begin
          e.ClearInfo;
          e.AddInfo('OIDValor', IntToStr(PosicionadosOID_VALOR.Value));
          valor := DataComun.FindValor(PosicionadosOID_VALOR.Value);
          e.AddInfo('Nombre', valor^.Nombre);
          e.AddInfo('Simbolo', valor^.Simbolo);
          e.AddInfo('Mercado', valor^.Mercado^.Nombre);
          raise;
        end;
      end;
      Posicionados.Next;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;

procedure TEstrategiaBase.AntesCerrarSesion;
var raiseAbort: boolean;
  inspect: TInspectDataSet;
  OIDValor: integer;
  valor: PDataComunValor;
begin
  Initialize;
  inspect := StartInspectDataSet(FValores);
  try
    FValores.First;
    while not FValores.Eof do begin
      Application.ProcessMessages;
      if canceled then begin
        raiseAbort := true;
        if Assigned(FOnCanceled) then
          FOnCanceled(raiseAbort);
        if raiseAbort then
          raise EAbort.Create('Estrategia cancelada');
      end;
      OIDValor := FieldOID_VALOR.Value;
      try
        // Solo se permiten procesar valores de mercados
        if {(FieldOID_MERCADO.Value <= Mercado_Const.OID_ReinoUnido) and}
          (not Posicionados.Locate('OID_VALOR', OIDValor, [])) then
          AntesCerrarSesionValor(OIDValor);
      except
        on e: Exception do begin
          e.ClearInfo;
          e.AddInfo('OIDValor', IntToStr(OIDValor));
          valor := DataComun.FindValor(OIDValor);
          e.AddInfo('Nombre', valor^.Nombre);
          e.AddInfo('Simbolo', valor^.Simbolo);
          e.AddInfo('Mercado', valor^.Mercado^.Nombre);
          raise;
        end;
      end;
      FValores.Next;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;

procedure TEstrategiaBase.AntesCerrarSesionPosicionados;
var raiseAbort: boolean;
  inspect: TInspectDataSet;
  valor: PDataComunValor;
begin
  Initialize;
  inspect := StartInspectDataSet(FValores);
  try
    Posicionados.First;
    while not Posicionados.Eof do begin
      Application.ProcessMessages;
      if canceled then begin
        raiseAbort := true;
        if Assigned(FOnCanceled) then
          FOnCanceled(raiseAbort);
        if raiseAbort then
          raise EAbort.Create('Estrategia cancelada');
      end;
      try
        if FValores.Locate('OID_VALOR', PosicionadosOID_VALOR.Value, []) then
          AntesCerrarSesionPosicionadoValor(FieldOID_VALOR.Value);
      except
        on e: Exception do begin
          e.ClearInfo;
          e.AddInfo('OIDValor', IntToStr(PosicionadosOID_VALOR.Value));
          valor := DataComun.FindValor(OIDValor);
          e.AddInfo('Nombre', valor^.Nombre);
          e.AddInfo('Simbolo', valor^.Simbolo);
          e.AddInfo('Mercado', valor^.Mercado^.Nombre);
          raise;
        end;
      end;
      Posicionados.Next;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;

procedure TEstrategiaBase.Cancel;
begin
  canceled := true;
end;

constructor TEstrategiaBase.Create(const AOwner: TComponent; const Valores: TDataset);
begin
  inherited Create(AOwner);
  Self.Valores := Valores;
end;


procedure TEstrategiaBase.DataModuleCreate(Sender: TObject);
begin
  Posicionados.Open;
end;

function TEstrategiaBase.GetOIDValor: integer;
begin
  result := FieldOID_VALOR.Value;
end;

procedure TEstrategiaBase.InicializarPosicionado;
begin
  Initialize;
  if Posicionados.Active then  
    Posicionados.EmptyTable
  else
    Posicionados.Open;
end;

procedure TEstrategiaBase.Initialize;
begin
  canceled := false;
  if Posiciones.Active then
    Posiciones.EmptyTable
  else
    Posiciones.Open;
end;

procedure TEstrategiaBase.ModificarStop(stop: currency);
begin
  if Posicionados.Locate('OID_VALOR', OIDValor, []) then begin
    Posicionados.Edit;
    PosicionadosSTOP.Value := stop;
    Posicionados.Post;
  end;
end;

procedure TEstrategiaBase.SetValores(const Value: TDataset);
begin
  FValores := Value;
  FieldOID_VALOR := FValores.FieldByName('OID_VALOR') as TIntegerField;
  FieldOID_MERCADO := FValores.FieldByName('OID_MERCADO') as TIntegerField;
end;

end.


