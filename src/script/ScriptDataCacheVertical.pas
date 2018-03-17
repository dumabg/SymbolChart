unit ScriptDataCacheVertical;

interface

uses
  SysUtils, Classes, IBSQL, Controls, Contnrs, Windows, dmThreadDataModule, ScriptDataCache;

type
  TArrayCurrency = array of currency;
  PArrayCurrency = ^TArrayCurrency;

  TArrayInteger = array of integer;
  PArrayInteger = ^TArrayInteger;

  TArraySingle = array of Single;
  PArraySingle = ^TArraySingle;

  TArrayString = array of string;
  PArrayString = ^TArrayString;

  TDataCached = record
    OIDSesion: integer;
    IDCotizacion: TArrayInteger;
    MensajeFlags: TArrayInteger;
    AmbienteIntradia: TArrayString;
    BandaAlta: TArrayCurrency;
    BandaBaja: TArrayCurrency;
    Cierre: TArrayCurrency;
    Apertura: TArrayCurrency;
    Volumen: TArrayInteger;
    CambioAlzaDoble: TArrayCurrency;
    CambioAlzaSimple: TArrayCurrency;
    CambioBajaDoble: TArrayCurrency;
    CambioBajaSimple: TArrayCurrency;
    Correlacion: TArrayInteger;
    DiasSeguidosNum: TArrayInteger;
    DiasSeguidosPerCent: TArraySingle;
    DimensionFractal: TArrayCurrency;
    Dinero: TArrayCurrency;
    DineroAlzaDoble: TArrayCurrency;
    DineroAlzaSimple: TArrayCurrency;
    DineroBajaDoble: TArrayCurrency;
    DineroBajaSimple: TArrayCurrency;
    Dobson10: TArrayInteger;
    Dobson100: TArrayInteger;
    Dobson130: TArrayInteger;
    Dobson40: TArrayInteger;
    Dobson70: TArrayInteger;
    DobsonAlto10: TArrayInteger;
    DobsonAlto100: TArrayInteger;
    DobsonAlto130: TArrayInteger;
    DobsonAlto40: TArrayInteger;
    DobsonAlto70: TArrayInteger;
    DobsonBajo10: TArrayInteger;
    DobsonBajo100: TArrayInteger;
    DobsonBajo130: TArrayInteger;
    DobsonBajo40: TArrayInteger;
    DobsonBajo70: TArrayInteger;
    Maximo: TArrayCurrency;
    MaximoPrevisto: TArrayCurrency;
    MaximoPrevistoAprox: TArraySingle;
    MaximoSePrevino: TArrayCurrency;
    Media200: TArrayCurrency;
    Minimo: TArrayCurrency;
    MinimoPrevisto: TArrayCurrency;
    MinimoPrevistoAprox: TArraySingle;
    MinimoSePrevino: TArrayCurrency;
    NivelActual: TArrayString;
    NivelBaja: TArrayString;
    NivelSube: TArrayString;
    Papel: TArrayCurrency;
    PapelAlzaDoble: TArrayCurrency;
    PapelAlzaSimple: TArrayCurrency;
    PapelBajaDoble: TArrayCurrency;
    PapelBajaSimple: TArrayCurrency;
    PercentAlzaSimple: TArrayCurrency;
    PercentBajaSimple: TArrayCurrency;
    PivotPoint: TArrayCurrency;
    PivotPointR1: TArrayCurrency;
    PivotPointR2: TArrayCurrency;
    PivotPointR3: TArrayCurrency;
    PivotPointS1: TArrayCurrency;
    PivotPointS2: TArrayCurrency;
    PivotPointS3: TArrayCurrency;
    PotencialFractal: TArrayInteger;
    RentabilidadAbierta: TArraySingle;
    Rsi14: TArrayInteger;
    Rsi140: TArrayInteger;
    Stop: TArrayCurrency;
    Posicionado: TArrayCurrency;
    Variabilidad: TArraySingle;
    Variacion: TArraySingle;
    Volatilidad: TArraySingle;
    Zona: TArrayString;
    ZonaAlzaDoble: TArrayString;
    ZonaAlzaSimple: TArrayString;
    ZonaBajaDoble: TArrayString;
    ZonaBajaSimple: TArrayString;
    Riesgo: TArraySingle;
    PresionVertical: TArraySingle;
    PresionVerticalAlzaSimple: TArraySingle;
    PresionVerticalAlzaDoble: TArraySingle;
    PresionVerticalBajaSimple: TArraySingle;
    PresionVerticalBajaDoble: TArraySingle;
    PresionLateral: TArraySingle;
    PresionLateralAlzaSimple: TArraySingle;
    PresionLateralAlzaDoble: TArraySingle;
    PresionLateralBajaSimple: TArraySingle;
    PresionLateralBajaDoble: TArraySingle;
  end;

  PDataCached = ^TDataCached;

  TScriptDataCacheVertical = class(TScriptDataCache)
  private
    PDataActual: PDataCached;
  protected
    procedure SetOIDSesion(const Value: integer); override;
  public
    function GetIDCotizacion: integer; override;
    function GetCierre: currency; override;
    function GetApertura: currency; override;
    function GetVolumen: integer; override;
    function GetDiasSeguidosNum: integer; override;
    function GetDiasSeguidosPerCent: single; override;
    function GetMaximo: currency; override;
    function GetMinimo: currency; override;
    function GetVariacion: single; override;

    function GetMensajeFlags: integer; override;
    function GetAmbienteIntradia: string; override;
    function GetBandaAlta: currency; override;
    function GetBandaBaja: currency; override;
    function GetCorrelacion: integer; override;
    function GetDimensionFractal: currency; override;
    function GetDinero: currency; override;
    function GetDineroAlzaDoble: currency; override;
    function GetDineroAlzaSimple: currency; override;
    function GetDineroBajaDoble: currency; override;
    function GetDineroBajaSimple: currency; override;
    function GetDobson10: integer; override;
    function GetDobson100: integer; override;
    function GetDobson130: integer; override;
    function GetDobson40: integer; override;
    function GetDobson70: integer; override;
    function GetDobsonAlto10: integer; override;
    function GetDobsonAlto100: integer; override;
    function GetDobsonAlto130: integer; override;
    function GetDobsonAlto40: integer; override;
    function GetDobsonAlto70: integer; override;
    function GetDobsonBajo10: integer; override;
    function GetDobsonBajo100: integer; override;
    function GetDobsonBajo130: integer; override;
    function GetDobsonBajo40: integer; override;
    function GetDobsonBajo70: integer; override;
    function GetMaximoPrevisto: currency; override;
    function GetMaximoPrevistoAprox: single; override;
    function GetMaximoSePrevino: currency; override;
    function GetMedia200: currency; override;
    function GetMinimoPrevisto: currency; override;
    function GetMinimoPrevistoAprox: single; override;
    function GetMinimoSePrevino: currency; override;
    function GetNivelActual: string; override;
    function GetNivelBaja: string; override;
    function GetNivelSube: string; override;
    function GetPapel: currency; override;
    function GetPapelAlzaDoble: currency; override;
    function GetPapelAlzaSimple: currency; override;
    function GetPapelBajaDoble: currency; override;
    function GetPapelBajaSimple: currency; override;
    function GetPercentAlzaSimple: currency; override;
    function GetPercentBajaSimple: currency; override;
    function GetPivotPoint: currency; override;
    function GetPivotPointR1: currency; override;
    function GetPivotPointR2: currency; override;
    function GetPivotPointR3: currency; override;
    function GetPivotPointS1: currency; override;
    function GetPivotPointS2: currency; override;
    function GetPivotPointS3: currency; override;
    function GetPotencialFractal: integer; override;
    function GetRentabilidadAbierta: single; override;
    function GetRsi14: integer; override;
    function GetRsi140: integer; override;
    function GetStop: currency; override;
    function GetPosicionado: currency; override;
    function GetVariabilidad: single; override;
    function GetVolatilidad: single; override;
    function GetZona: string; override;
    function GetZonaAlzaDoble: string; override;
    function GetZonaAlzaSimple: string; override;
    function GetZonaBajaDoble: string; override;
    function GetZonaBajaSimple: string; override;
    function GetRiesgo: Single; override;
    function GetPresionVertical: Single; override;
    function GetPresionVerticalAlzaSimple: Single; override;
    function GetPresionVerticalAlzaDoble: Single; override;
    function GetPresionVerticalBajaSimple: Single; override;
    function GetPresionVerticalBajaDoble: Single; override;
    function GetPresionLateral: Single; override;
    function GetPresionLateralAlzaSimple: Single; override;
    function GetPresionLateralAlzaDoble: Single; override;
    function GetPresionLateralBajaSimple: Single; override;
    function GetPresionLateralBajaDoble: Single; override;
    function GetCambioAlzaSimple: currency; override;
    function GetCambioAlzaDoble: currency; override;
    function GetCambioBajaSimple: currency; override;
    function GetCambioBajaDoble: currency; override;
  end;

  TScriptDataCacheVerticalFactory = class(TScriptDataCacheFactory)
  private
    criticalSection: TRTLCriticalSection;
    DataCached: TList;
    qData: TIBSQL;
    cacheSize: integer;
    function MaxOIDValor: integer;
    procedure InitializeDataCache(PData: PDataCached);
    procedure FreeDataCached(const PData: PDataCached); overload;
    procedure FreeDataCached; overload;
    procedure LoadCotizacionMensaje(const OIDSesion: integer);
    procedure LoadCotizacionEstado(const OIDSesion: integer; const campo: string);
    procedure LoadCotizacion(const OIDSesion: integer; const campo: string);
    procedure LoadDataCotizacionMensaje(const OIDSesion: integer; const arrayInteger: PArrayInteger); overload;
    procedure LoadDataCotizacionEstado(const OIDSesion: integer; const campo: string; const arrayInteger: PArrayInteger); overload;
    procedure LoadDataCotizacionEstado(const OIDSesion: integer; const campo: string; const arrayCurrency: PArrayCurrency); overload;
    procedure LoadDataCotizacionEstado(const OIDSesion: integer; const campo: string; const arraySingle: PArraySingle); overload;
    procedure LoadDataCotizacionEstado(const OIDSesion: integer; const campo: string; const arrayString: PArrayString); overload;
    procedure LoadDataCotizacion(const OIDSesion: integer; const campo: string; const arrayCurrency: PArrayCurrency); overload;
    procedure LoadDataCotizacion(const OIDSesion: integer; const campo: string; const arraySingle: PArraySingle); overload;
    procedure LoadDataCotizacion(const OIDSesion: integer; const campo: string; const arrayInteger: PArrayInteger); overload;
    procedure SetOIDSesion(const Cursor: TScriptDataCacheVertical; const Value: integer);
//    procedure OnTipoCotizacionCambiada;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure InitializeCache; override;
  end;

implementation

uses dmBD, dmDataComun, UtilThread, UtilDB, BusCommunication, dmData;

const
  MAX_NUM_ENTRADAS_CACHE = 3;
  SIN_DATO : integer = Low(integer);
  SIN_DATO_S: string = '';

{ TScriptDataCacheEngine }

constructor TScriptDataCacheVerticalFactory.Create;
begin
  inherited;
  InitializeCriticalSection(criticalSection);
  qData := TIBSQL.Create(nil);
  qData.Database := BD.IBDatabaseDatos;
  DataCached := TList.Create;
  ScriptDataCacheClass := TScriptDataCacheVertical;
  cacheSize := MaxOIDValor;
end;

destructor TScriptDataCacheVerticalFactory.Destroy;
begin
  qData.Free;
  FreeDataCached;
  DataCached.Free;
  DeleteCriticalSection(criticalSection);
  inherited;
end;

procedure TScriptDataCacheVerticalFactory.FreeDataCached;
var i, num: integer;
begin
  num := DataCached.Count - 1;
  for i := 0 to num do
    FreeDataCached(PDataCached(DataCached.Items[i]));
  DataCached.Clear;
end;

procedure TScriptDataCacheVerticalFactory.FreeDataCached(const PData: PDataCached);
begin
  // Se ha de realizar un Initialize para poner a nil todos los arrays y así
  // liberar la memoria
  InitializeDataCache(PData);
  FreeMem(PData);
end;

procedure TScriptDataCacheVerticalFactory.InitializeCache;
begin
  FreeDataCached;
end;

procedure TScriptDataCacheVerticalFactory.InitializeDataCache(PData: PDataCached);
begin
  with PData^ do begin
    IDCotizacion:= nil;
    MensajeFlags:= nil;
    AmbienteIntradia:= nil;
    BandaAlta:= nil;
    BandaBaja:= nil;
    Cierre := nil;
    Apertura := nil;
    Volumen := nil;
    CambioAlzaDoble:= nil;
    CambioAlzaSimple:= nil;
    CambioBajaDoble:= nil;
    CambioBajaSimple:= nil;
    Correlacion:= nil;
    DiasSeguidosNum:= nil;
    DiasSeguidosPerCent:= nil;
    DimensionFractal:= nil;
    Dinero:= nil;
    DineroAlzaDoble:= nil;
    DineroAlzaSimple:= nil;
    DineroBajaDoble:= nil;
    DineroBajaSimple:= nil;
    Dobson10:= nil;
    Dobson100:= nil;
    Dobson130:= nil;
    Dobson40:= nil;
    Dobson70:= nil;
    DobsonAlto10:= nil;
    DobsonAlto100:= nil;
    DobsonAlto130:= nil;
    DobsonAlto40:= nil;
    DobsonAlto70:= nil;
    DobsonBajo10:= nil;
    DobsonBajo100:= nil;
    DobsonBajo130:= nil;
    DobsonBajo40:= nil;
    DobsonBajo70:= nil;
    Maximo:= nil;
    MaximoPrevisto:= nil;
    MaximoPrevistoAprox:= nil;
    MaximoSePrevino:= nil;
    Media200:= nil;
    Minimo:= nil;
    MinimoPrevisto:= nil;
    MinimoPrevistoAprox:= nil;
    MinimoSePrevino:= nil;
    NivelActual:= nil;
    NivelBaja:= nil;
    NivelSube:= nil;
    Papel:= nil;
    PapelAlzaDoble:= nil;
    PapelAlzaSimple:= nil;
    PapelBajaDoble:= nil;
    PapelBajaSimple:= nil;
    PercentAlzaSimple:= nil;
    PercentBajaSimple:= nil;
    PivotPoint:= nil;
    PivotPointR1:= nil;
    PivotPointR2:= nil;
    PivotPointR3:= nil;
    PivotPointS1:= nil;
    PivotPointS2:= nil;
    PivotPointS3:= nil;
    PotencialFractal:= nil;
    RentabilidadAbierta:= nil;
    Rsi14:= nil;
    Rsi140:= nil;
    Stop:= nil;
    Posicionado:= nil;
    Variabilidad:= nil;
    Variacion:= nil;
    Volatilidad:= nil;
    Zona:= nil;
    ZonaAlzaDoble:= nil;
    ZonaAlzaSimple:= nil;
    ZonaBajaDoble:= nil;
    ZonaBajaSimple:= nil;
    Riesgo:= nil;
    PresionVertical:= nil;
    PresionVerticalAlzaSimple:= nil;
    PresionVerticalAlzaDoble:= nil;
    PresionVerticalBajaSimple:= nil;
    PresionVerticalBajaDoble:= nil;
    PresionLateral:= nil;
    PresionLateralAlzaSimple:= nil;
    PresionLateralAlzaDoble:= nil;
    PresionLateralBajaSimple:= nil;
    PresionLateralBajaDoble:= nil;
  end;
end;

procedure TScriptDataCacheVerticalFactory.LoadDataCotizacionEstado(const OIDSesion: integer;
  const campo: string; const arrayInteger: PArrayInteger);
var i: integer;
begin
  EnterCriticalSection(criticalSection);
  try
    //+1 porque no existe el OIDValor 0
    SetLength(arrayInteger^, cacheSize + 1);
    for i := 0 to cacheSize do
      arrayInteger^[i] := SIN_DATO;
    LoadCotizacionEstado(OIDSesion, campo);
    while not qData.Eof do begin
      arrayInteger^[qData.Fields[0].AsInteger] := qData.Fields[1].AsInteger;
      qData.Next;
    end;
    qData.Close;
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

procedure TScriptDataCacheVerticalFactory.LoadDataCotizacionEstado(const OIDSesion: integer;
  const campo: string; const arrayCurrency: PArrayCurrency);
var i: integer;
begin
  EnterCriticalSection(criticalSection);
  try
    SetLength(arrayCurrency^, cacheSize + 1);
    for i := 0 to cacheSize do
      arrayCurrency^[i] := SIN_DATO;
    LoadCotizacionEstado(OIDSesion, campo);
    while not qData.Eof do begin
      arrayCurrency^[qData.Fields[0].AsInteger] := qData.Fields[1].AsCurrency;
      qData.Next;
    end;
    qData.Close;
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

procedure TScriptDataCacheVerticalFactory.LoadCotizacion(const OIDSesion: integer; const campo: string);
begin
  qData.Close;
  qData.SQL.Text := 'SELECT OR_VALOR,' + campo + ' FROM COTIZACION ' +
      'WHERE OR_SESION=:S and not ' + campo + ' is null';
  qData.Params[0].AsInteger := OIDSesion;
  ExecQuery(qData, false);
end;

procedure TScriptDataCacheVerticalFactory.LoadCotizacionEstado(const OIDSesion: integer; const campo: string);
begin
  qData.Close;
  qData.SQL.Text := 'SELECT C.OR_VALOR,CE.' + campo + ' FROM COTIZACION C ' +
      'LEFT OUTER JOIN COTIZACION_ESTADO CE ON (C.OID_COTIZACION=CE.OR_COTIZACION) ' +
      'WHERE C.OR_SESION=:S and not CE.' + campo + ' is null';
  qData.Params[0].AsInteger := OIDSesion;
  ExecQuery(qData, false);
end;

procedure TScriptDataCacheVerticalFactory.LoadCotizacionMensaje(
  const OIDSesion: integer);
begin
  qData.Close;
  qData.SQL.Text := 'SELECT C.OR_VALOR,CM.FLAGS FROM COTIZACION C ' +
      'LEFT OUTER JOIN COTIZACION_MENSAJE CM ON (C.OID_COTIZACION=CM.OR_COTIZACION) ' +
      'WHERE C.OR_SESION=:S and not CM.FLAGS is null';
  qData.Params[0].AsInteger := OIDSesion;
  ExecQuery(qData, false);
end;

procedure TScriptDataCacheVerticalFactory.LoadDataCotizacion(const OIDSesion: integer; const campo: string;
  const arrayCurrency: PArrayCurrency);
var i: integer;
begin
  EnterCriticalSection(criticalSection);
  try
    SetLength(arrayCurrency^, cacheSize + 1);
    for i := 0 to cacheSize do
      arrayCurrency^[i] := SIN_DATO;
    LoadCotizacion(OIDSesion, campo);
    while not qData.Eof do begin
      arrayCurrency^[qData.Fields[0].AsInteger] := qData.Fields[1].AsCurrency;
      qData.Next;
    end;
    qData.Close;
  finally
    LeaveCriticalSection(criticalSection);
  end;

end;

procedure TScriptDataCacheVerticalFactory.LoadDataCotizacion(const OIDSesion: integer;
  const campo: string; const arraySingle: PArraySingle);
var i: integer;
begin
  EnterCriticalSection(criticalSection);
  try
    SetLength(arraySingle^, cacheSize + 1);
    for i := 0 to cacheSize do
      arraySingle^[i] := SIN_DATO;
    LoadCotizacion(OIDSesion, campo);
    while not qData.Eof do begin
      arraySingle^[qData.Fields[0].AsInteger] := qData.Fields[1].AsCurrency;
      qData.Next;
    end;
    qData.Close;
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

procedure TScriptDataCacheVerticalFactory.LoadDataCotizacion(const OIDSesion: integer;
  const campo: string; const arrayInteger: PArrayInteger);
var i: integer;
begin
  EnterCriticalSection(criticalSection);
  try
    //Presuponemos que los valores no son negativos y empiezan con el 1, por lo
    //que será 0 based
    SetLength(arrayInteger^, cacheSize + 1);
    for i := 0 to cacheSize do
      arrayInteger^[i] := SIN_DATO;
    LoadCotizacion(OIDSesion, campo);
    while not qData.Eof do begin
      arrayInteger^[qData.Fields[0].AsInteger] := qData.Fields[1].AsInteger;
      qData.Next;
    end;
    qData.Close;
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

procedure TScriptDataCacheVerticalFactory.LoadDataCotizacionEstado(const OIDSesion: integer;
  const campo: string; const arraySingle: PArraySingle);
var i: Integer;
begin
  EnterCriticalSection(criticalSection);
  try
    SetLength(arraySingle^, cacheSize + 1);
    for i := 0 to cacheSize do
      arraySingle^[i] := SIN_DATO;
    LoadCotizacionEstado(OIDSesion, campo);
    while not qData.Eof do begin
      arraySingle^[qData.Fields[0].AsInteger] := qData.Fields[1].AsCurrency;
      qData.Next;
    end;
    qData.Close;
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

procedure TScriptDataCacheVerticalFactory.LoadDataCotizacionEstado(const OIDSesion: integer;
  const campo: string; const arrayString: PArrayString);
var i, cacheSize: integer;
begin
  EnterCriticalSection(criticalSection);
  try
    SetLength(arrayString^, cacheSize + 1);
    for i := 0 to cacheSize do
      arrayString^[i] := SIN_DATO_S;
    LoadCotizacionEstado(OIDSesion, campo);
    while not qData.Eof do begin
      arrayString^[qData.Fields[0].AsInteger] := qData.Fields[1].AsString;
      qData.Next;
    end;
    qData.Close;
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

procedure TScriptDataCacheVerticalFactory.LoadDataCotizacionMensaje(
  const OIDSesion: integer; const arrayInteger: PArrayInteger);
var i: integer;
begin
  EnterCriticalSection(criticalSection);
  try
    SetLength(arrayInteger^, cacheSize + 1);
    for i := 0 to cacheSize do
      arrayInteger^[i] := SIN_DATO;
    LoadCotizacionMensaje(OIDSesion);
    while not qData.Eof do begin
      arrayInteger^[qData.Fields[0].AsInteger] := qData.Fields[1].AsInteger;
      qData.Next;
    end;
    qData.Close;
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

function TScriptDataCacheVerticalFactory.MaxOIDValor: integer;
var i, OIDValor: integer;
  DataComunValores: PDataComunValores;
begin
  DataComunValores := DataComun.Valores;
  result := 0;
  for i := Low(DataComunValores^) to High(DataComunValores^) do begin
    OIDValor := DataComunValores^[i].OIDValor;
    if OIDValor > result then
      result := OIDValor;
  end;
end;

{
procedure TScriptDataCacheVerticalFactory.OnTipoCotizacionCambiada;
begin
  EnterCriticalSection(criticalSection);
  try
    FreeDataCached;
    BD.BDDatos := Data.BDDatos;
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;
}
procedure TScriptDataCacheVerticalFactory.SetOIDSesion(const Cursor: TScriptDataCacheVertical;
  const Value: integer);
var i, num: Integer;
  PData: PDataCached;
begin
  EnterCriticalSection(criticalSection);
  try
    num := DataCached.Count - 1;
    for i := 0 to num do begin
      PData := PDataCached(DataCached.Items[i]);
      if PData^.OIDSesion = Value then begin
        Cursor.PDataActual := PData;
        // Pasamos los datos al final de la lista, para mantener el orden
        // de los más recientemente usados
        DataCached.Add(PData);
        DataCached.Delete(i);
        exit;
      end;
    end;
    New(PData);
    InitializeDataCache(PData);
    PData^.OIDSesion := Value;
    DataCached.Add(PData);
    Cursor.PDataActual := PData;
    // Borramos el menos usado
    if DataCached.Count > MAX_NUM_ENTRADAS_CACHE then begin
      // Buscamos por todos los cursores aquellos que apunten al item que va a ser
      // quitado de la cache
      PData := PDataCached(DataCached.Items[0]);
      num := Cursores.Count - 1;
      for i := 0 to num do begin
        if TScriptDataCacheVertical(Cursores[i]).PDataActual = PData then
          TScriptDataCacheVertical(Cursores[i]).PDataActual := nil;
      end;
      FreeDataCached(DataCached.Items[0]);
      DataCached.Delete(0);
    end;
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

{ TScriptDataCacheVertical }

function TScriptDataCacheVertical.GetAmbienteIntradia: string;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.AmbienteIntradia = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'AMBIENTE_INTRADIA', PArrayString(@PDataActual^.AmbienteIntradia));
  result := PDataActual^.AmbienteIntradia[OIDValor];
  if result = '' then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetApertura: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Apertura = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacion(FOIDSesion, 'APERTURA', PArrayCurrency(@PDataActual^.Apertura));
  result := PDataActual^.Apertura[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetBandaAlta: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.BandaAlta = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'BANDA_ALTA', PArrayCurrency(@PDataActual^.BandaAlta));
  result := PDataActual^.BandaAlta[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetBandaBaja: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.BandaBaja = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'BANDA_BAJA', PArrayCurrency(@PDataActual^.BandaBaja));
  result := PDataActual^.BandaBaja[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetCambioAlzaDoble: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.CambioAlzaDoble = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'CAMBIO_ALZA_DOBLE', PArrayCurrency(@PDataActual^.CambioAlzaDoble));
  result := PDataActual^.CambioAlzaDoble[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetCambioAlzaSimple: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.CambioAlzaSimple = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'CAMBIO_ALZA_SIMPLE', PArrayCurrency(@PDataActual^.CambioAlzaSimple));
  result := PDataActual^.CambioAlzaSimple[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetCambioBajaDoble: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.CambioBajaDoble = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'CAMBIO_BAJA_DOBLE', PArrayCurrency(@PDataActual^.CambioBajaDoble));
  result := PDataActual^.CambioBajaDoble[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetCambioBajaSimple: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.CambioBajaSimple = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'CAMBIO_BAJA_SIMPLE', PArrayCurrency(@PDataActual^.CambioBajaSimple));
  result := PDataActual^.CambioBajaSimple[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetCierre: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Cierre = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacion(FOIDSesion, 'CIERRE', PArrayCurrency(@PDataActual^.Cierre));
  result := PDataActual^.Cierre[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetCorrelacion: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Correlacion = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'CORRELACION', PArrayInteger(@PDataActual^.Correlacion));
  result := PDataActual^.Correlacion[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetDiasSeguidosNum: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.DiasSeguidosNum = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacion(FOIDSesion, 'DIAS_SEGUIDOS_NUM', PArrayInteger(@PDataActual^.DiasSeguidosNum));
  result := PDataActual^.DiasSeguidosNum[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetDiasSeguidosPerCent: single;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.DiasSeguidosPerCent = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacion(FOIDSesion, 'DIAS_SEGUIDOS_PERCENT', PArraySingle(@PDataActual^.DiasSeguidosPerCent));
  result := PDataActual^.DiasSeguidosPerCent[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetDimensionFractal: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.DimensionFractal = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DIMENSION_FRACTAL', PArrayCurrency(@PDataActual^.DimensionFractal));
  result := PDataActual^.DimensionFractal[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetDinero: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Dinero = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DINERO', PArrayCurrency(@PDataActual^.Dinero));
  result := PDataActual^.Dinero[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetDineroAlzaDoble: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.DineroAlzaDoble = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DINERO_ALZA_DOBLE', PArrayCurrency(@PDataActual^.DineroAlzaDoble));
  result := PDataActual^.DineroAlzaDoble[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetDineroAlzaSimple: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.DineroAlzaSimple = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DINERO_ALZA_SIMPLE', PArrayCurrency(@PDataActual^.DineroAlzaSimple));
  result := PDataActual^.DineroAlzaSimple[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetDineroBajaDoble: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.DineroBajaDoble = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DINERO_BAJA_DOBLE', PArrayCurrency(@PDataActual^.DineroBajaDoble));
  result := PDataActual^.DineroBajaDoble[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetDineroBajaSimple: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.DineroBajaSimple = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DINERO_BAJA_SIMPLE', PArrayCurrency(@PDataActual^.DineroBajaSimple));
  result := PDataActual^.DineroBajaSimple[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetDobson10: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Dobson10 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DOBSON_10', PArrayInteger(@PDataActual^.Dobson10));
  result := PDataActual^.Dobson10[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetDobson100: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Dobson100 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DOBSON_100', PArrayInteger(@PDataActual^.Dobson100));
  result := PDataActual^.Dobson100[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetDobson130: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Dobson130 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DOBSON_130', PArrayInteger(@PDataActual^.Dobson130));
  result := PDataActual^.Dobson130[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetDobson40: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Dobson40 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DOBSON_40', PArrayInteger(@PDataActual^.Dobson40));
  result := PDataActual^.Dobson40[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetDobson70: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Dobson70 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DOBSON_70', PArrayInteger(@PDataActual^.Dobson70));
  result := PDataActual^.Dobson70[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetDobsonAlto10: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.DobsonAlto10 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DOBSON_ALTO_10', PArrayInteger(@PDataActual^.DobsonAlto10));
  result := PDataActual^.DobsonAlto10[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetDobsonAlto100: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.DobsonAlto100 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DOBSON_ALTO_100', PArrayInteger(@PDataActual^.DobsonAlto100));
  result := PDataActual^.DobsonAlto100[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetDobsonAlto130: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.DobsonAlto130 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DOBSON_ALTO_130', PArrayInteger(@PDataActual^.DobsonAlto130));
  result := PDataActual^.DobsonAlto130[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetDobsonAlto40: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.DobsonAlto40 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DOBSON_ALTO_40', PArrayInteger(@PDataActual^.DobsonAlto40));
  result := PDataActual^.DobsonAlto40[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetDobsonAlto70: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.DobsonAlto70 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DOBSON_ALTO_70', PArrayInteger(@PDataActual^.DobsonAlto70));
  result := PDataActual^.DobsonAlto70[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetDobsonBajo10: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.DobsonBajo10 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DOBSON_BAJO_10', PArrayInteger(@PDataActual^.DobsonBajo10));
  result := PDataActual^.DobsonBajo10[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetDobsonBajo100: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.DobsonBajo100 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DOBSON_BAJO_100', PArrayInteger(@PDataActual^.DobsonBajo100));
  result := PDataActual^.DobsonBajo100[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetDobsonBajo130: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.DobsonBajo130 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DOBSON_BAJO_130', PArrayInteger(@PDataActual^.DobsonBajo130));
  result := PDataActual^.DobsonBajo130[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetDobsonBajo40: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.DobsonBajo40 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DOBSON_BAJO_40', PArrayInteger(@PDataActual^.DobsonBajo40));
  result := PDataActual^.DobsonBajo40[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetDobsonBajo70: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.DobsonBajo70 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'DOBSON_BAJO_70', PArrayInteger(@PDataActual^.DobsonBajo70));
  result := PDataActual^.DobsonBajo70[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetNivelActual: string;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.NivelActual = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'NIVEL_ACTUAL', PArrayString(@PDataActual^.NivelActual));
  result := PDataActual^.NivelActual[OIDValor];
  if result = '' then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetNivelBaja: string;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.NivelBaja = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'NIVEL_BAJA', PArrayString(@PDataActual^.NivelBaja));
  result := PDataActual^.NivelBaja[OIDValor];
  if result = '' then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetNivelSube: string;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.NivelSube = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'NIVEL_SUBE', PArrayString(@PDataActual^.NivelSube));
  result := PDataActual^.NivelSube[OIDValor];
  if result = '' then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetMensajeFlags: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.MensajeFlags = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionMensaje(FOIDSesion, PArrayInteger(@PDataActual^.MensajeFlags));
  result := PDataActual^.MensajeFlags[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetIDCotizacion: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.IDCotizacion = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacion(FOIDSesion, 'OID_COTIZACION', PArrayInteger(@PDataActual^.IDCotizacion));
  result := PDataActual^.IDCotizacion[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetMaximo: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Maximo = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacion(FOIDSesion, 'MAXIMO', PArrayCurrency(@PDataActual^.Maximo));
  result := PDataActual^.Maximo[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetMaximoPrevisto: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.MaximoPrevisto = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'MAXIMO_PREVISTO', PArrayCurrency(@PDataActual^.MaximoPrevisto));
  result := PDataActual^.MaximoPrevisto[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetMaximoPrevistoAprox: single;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.MaximoPrevistoAprox = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'MAXIMO_PREVISTO_APROX', PArraySingle(@PDataActual^.MaximoPrevistoAprox));
  result := PDataActual^.MaximoPrevistoAprox[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetMaximoSePrevino: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.MaximoSePrevino = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'MAXIMO_SE_PREVINO', PArrayCurrency(@PDataActual^.MaximoSePrevino));
  result := PDataActual^.MaximoSePrevino[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetMedia200: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Media200 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'MEDIA_200', PArrayCurrency(@PDataActual^.Media200));
  result := PDataActual^.Media200[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetMinimo: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Minimo = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacion(FOIDSesion, 'MINIMO', PArrayCurrency(@PDataActual^.Minimo));
  result := PDataActual^.Minimo[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetMinimoPrevisto: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.MinimoPrevisto = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'MINIMO_PREVISTO', PArrayCurrency(@PDataActual^.MinimoPrevisto));
  result := PDataActual^.MinimoPrevisto[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetMinimoPrevistoAprox: single;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.MinimoPrevistoAprox = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'MINIMO_PREVISTO_APROX', PArraySingle(@PDataActual^.MinimoPrevistoAprox));
  result := PDataActual^.MinimoPrevistoAprox[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetMinimoSePrevino: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.MinimoSePrevino = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'MINIMO_SE_PREVINO', PArrayCurrency(@PDataActual^.MinimoSePrevino));
  result := PDataActual^.MinimoSePrevino[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetPapel: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Papel = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PAPEL', PArrayCurrency(@PDataActual^.Papel));
  result := PDataActual^.Papel[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetPapelAlzaDoble: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PapelAlzaDoble = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PAPEL_ALZA_DOBLE', PArrayCurrency(@PDataActual^.PapelAlzaDoble));
  result := PDataActual^.PapelAlzaDoble[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetPapelAlzaSimple: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PapelAlzaSimple = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PAPEL_ALZA_SIMPLE', PArrayCurrency(@PDataActual^.PapelAlzaSimple));
  result := PDataActual^.PapelAlzaSimple[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPapelBajaDoble: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PapelBajaDoble = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PAPEL_BAJA_DOBLE', PArrayCurrency(@PDataActual^.PapelBajaDoble));
  result := PDataActual^.PapelBajaDoble[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPapelBajaSimple: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PapelBajaSimple = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PAPEL_BAJA_SIMPLE', PArrayCurrency(@PDataActual^.PapelBajaSimple));
  result := PDataActual^.PapelBajaSimple[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPercentAlzaSimple: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PercentAlzaSimple = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PERCENT_ALZA_SIMPLE', PArrayCurrency(@PDataActual^.PercentAlzaSimple));
  result := PDataActual^.PercentAlzaSimple[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetPercentBajaSimple: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PercentBajaSimple = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PERCENT_BAJA_SIMPLE', PArrayCurrency(@PDataActual^.PercentBajaSimple));
  result := PDataActual^.PercentBajaSimple[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetPivotPoint: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PivotPoint = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PIVOT_POINT', PArrayCurrency(@PDataActual^.PivotPoint));
  result := PDataActual^.PivotPoint[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPivotPointR1: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PivotPointR1 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PIVOT_POINT_R1', PArrayCurrency(@PDataActual^.PivotPointR1));
  result := PDataActual^.PivotPointR1[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPivotPointR2: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PivotPointR2 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PIVOT_POINT_R2', PArrayCurrency(@PDataActual^.PivotPointR2));
  result := PDataActual^.PivotPointR2[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPivotPointR3: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PivotPointR3 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PIVOT_POINT_R3', PArrayCurrency(@PDataActual^.PivotPointR3));
  result := PDataActual^.PivotPointR3[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPivotPointS1: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PivotPointS1 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PIVOT_POINT_S1', PArrayCurrency(@PDataActual^.PivotPointS1));
  result := PDataActual^.PivotPointS1[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPivotPointS2: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PivotPointS2 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PIVOT_POINT_S2', PArrayCurrency(@PDataActual^.PivotPointS2));
  result := PDataActual^.PivotPointS2[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPivotPointS3: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PivotPointS3 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PIVOT_POINT_S3', PArrayCurrency(@PDataActual^.PivotPointS3));
  result := PDataActual^.PivotPointS3[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPosicionado: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Posicionado = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'POSICIONADO', PArrayCurrency(@PDataActual^.Posicionado));
  result := PDataActual^.Posicionado[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPotencialFractal: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PotencialFractal = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'POTENCIAL_FRACTAL', PArrayInteger(@PDataActual^.PotencialFractal));
  result := PDataActual^.PotencialFractal[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPresionLateral: Single;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PresionLateral = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PRESION_LATERAL', PArraySingle(@PDataActual^.PresionLateral));
  result := PDataActual^.PresionLateral[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPresionLateralAlzaDoble: Single;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PresionLateralAlzaDoble = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PRESION_LATERAL_ALZA_DOBLE', PArraySingle(@PDataActual^.PresionLateralAlzaDoble));
  result := PDataActual^.PresionLateralAlzaDoble[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPresionLateralAlzaSimple: Single;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PresionLateralAlzaSimple = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PRESION_LATERAL_ALZA_SIMPLE', PArraySingle(@PDataActual^.PresionLateralAlzaSimple));
  result := PDataActual^.PresionLateralAlzaSimple[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPresionLateralBajaDoble: Single;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PresionLateralBajaDoble = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PRESION_LATERAL_BAJA_DOBLE', PArraySingle(@PDataActual^.PresionLateralBajaDoble));
  result := PDataActual^.PresionLateralBajaDoble[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPresionLateralBajaSimple: Single;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PresionLateralBajaSimple = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PRESION_LATERAL_BAJA_SIMPLE', PArraySingle(@PDataActual^.PresionLateralBajaSimple));
  result := PDataActual^.PresionLateralBajaSimple[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPresionVertical: Single;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PresionVertical = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PRESION_VERTICAL', PArraySingle(@PDataActual^.PresionVertical));
  result := PDataActual^.PresionVertical[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPresionVerticalAlzaDoble: Single;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PresionVerticalAlzaDoble = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PRESION_VERTICAL_ALZA_DOBLE', PArraySingle(@PDataActual^.PresionVerticalAlzaDoble));
  result := PDataActual^.PresionVerticalAlzaDoble[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPresionVerticalAlzaSimple: Single;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PresionVerticalAlzaSimple = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PRESION_VERTICAL_ALZA_SIMPLE', PArraySingle(@PDataActual^.PresionVerticalAlzaSimple));
  result := PDataActual^.PresionVerticalAlzaSimple[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPresionVerticalBajaDoble: Single;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PresionVerticalBajaDoble = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PRESION_VERTICAL_BAJA_DOBLE', PArraySingle(@PDataActual^.PresionVerticalBajaDoble));
  result := PDataActual^.PresionVerticalBajaDoble[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetPresionVerticalBajaSimple: Single;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.PresionVerticalBajaSimple = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'PRESION_VERTICAL_BAJA_SIMPLE', PArraySingle(@PDataActual^.PresionVerticalBajaSimple));
  result := PDataActual^.PresionVerticalBajaSimple[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetRentabilidadAbierta: single;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.RentabilidadAbierta = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'RENTABILIDAD_ABIERTA', PArraySingle(@PDataActual^.RentabilidadAbierta));
  result := PDataActual^.RentabilidadAbierta[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetRiesgo: Single;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Riesgo = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'RIESGO', PArraySingle(@PDataActual^.Riesgo));
  result := PDataActual^.Riesgo[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetRsi14: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Rsi14 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'RSI_14', PArrayInteger(@PDataActual^.Rsi14));
  result := PDataActual^.Rsi14[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetRsi140: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Rsi140 = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'RSI_140', PArrayInteger(@PDataActual^.Rsi140));
  result := PDataActual^.Rsi140[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetStop: currency;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Stop = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'STOP', PArrayCurrency(@PDataActual^.Stop));
  result := PDataActual^.Stop[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetVariabilidad: single;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Variabilidad = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'VARIABILIDAD', PArraySingle(@PDataActual^.Variabilidad));
  result := PDataActual^.Variabilidad[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetVariacion: single;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Variacion = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacion(FOIDSesion, 'VARIACION', PArraySingle(@PDataActual^.Variacion));
  result := PDataActual^.Variacion[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetVolatilidad: single;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Volatilidad = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'VOLATILIDAD', PArraySingle(@PDataActual^.Volatilidad));
  result := PDataActual^.Volatilidad[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');  
end;

function TScriptDataCacheVertical.GetVolumen: integer;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Volumen = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacion(FOIDSesion, 'VOLUMEN', PArrayInteger(@PDataActual^.Volumen));
  result := PDataActual^.Volumen[OIDValor];
  if result = SIN_DATO then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetZona: string;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.Zona = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'ZONA', PArrayString(@PDataActual^.Zona));
  result := PDataActual^.Zona[OIDValor];
  if result = '' then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetZonaAlzaDoble: string;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.ZonaAlzaDoble = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'ZONA_ALZA_DOBLE', PArrayString(@PDataActual^.ZonaAlzaDoble));
  result := PDataActual^.ZonaAlzaDoble[OIDValor];
  if result = '' then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetZonaAlzaSimple: string;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.ZonaAlzaSimple = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'ZONA_ALZA_SIMPLE', PArrayString(@PDataActual^.ZonaAlzaSimple));
  result := PDataActual^.ZonaAlzaSimple[OIDValor];
  if result = '' then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetZonaBajaDoble: string;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.ZonaBajaDoble = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'ZONA_BAJA_DOBLE', PArrayString(@PDataActual^.ZonaBajaDoble));
  result := PDataActual^.ZonaBajaDoble[OIDValor];
  if result = '' then
    raise EDatoNoEncontrado.Create('');
end;

function TScriptDataCacheVertical.GetZonaBajaSimple: string;
begin
  if PDataActual = nil then
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  if PDataActual^.ZonaBajaSimple = nil then
    TScriptDataCacheVerticalFactory(Factory).LoadDataCotizacionEstado(FOIDSesion, 'ZONA_BAJA_SIMPLE', PArrayString(@PDataActual^.ZonaBajaSimple));
  result := PDataActual^.ZonaBajaSimple[OIDValor];
  if result = '' then
    raise EDatoNoEncontrado.Create('');
end;

procedure TScriptDataCacheVertical.SetOIDSesion(const Value: integer);
begin
  if FOIDSesion <> Value then begin
    FOIDSesion := Value;
    TScriptDataCacheVerticalFactory(Factory).SetOIDSesion(Self, FOIDSesion);
  end;
end;



end.
