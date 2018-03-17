unit dmData;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery,
  IBDatabase, dmBD, IBUpdateSQL, controls, StockGraphicPainterLines, flags,
  ExtCtrls, kbmMemTable, BusCommunication, Valores, dmDataModuleBase;


const
  DIA_SIN_COTIZAR : integer = 0;

type
  MessageValorCambiado = class(TBusMessage);
  MessageCotizacionCambiada = class(TBusMessage);
  MessageTipoCotizacionCambiada = class(TBusMessage);

  TNotificacionEvent = procedure of object;

  TPosicionamientoValor = (pvIndefinido, pvLargo, pvCorto);

  TTipoCotizacion = (tcDiaria, tcSemanal);

  ETipoCotizacionDesconocido = class(Exception);

  TData = class(TDataModuleBase)
    dsValores: TDataSource;
    CotizacionEstado: TIBQuery;
    dsCotizacion: TDataSource;
    Cotizacion: TIBQuery;
    CotizacionFECHA: TDateField;
    CotizacionOID_COTIZACION: TIntegerField;
    CotizacionOR_VALOR: TSmallintField;
    CotizacionOR_SESION: TSmallintField;
    CotizacionDIAS_SEGUIDOS_NUM: TSmallintField;
    CotizacionDIAS_SEGUIDOS_PERCENT: TIBBCDField;
    CotizacionVARIACION: TIBBCDField;
    CotizacionMAXIMO: TIBBCDField;
    CotizacionMINIMO: TIBBCDField;
    CotizacionEstadoOR_COTIZACION: TIntegerField;
    CotizacionEstadoVOLATILIDAD: TIBBCDField;
    CotizacionEstadoVARIABILIDAD: TIBBCDField;
    CotizacionEstadoBANDA_ALTA: TIBBCDField;
    CotizacionEstadoBANDA_BAJA: TIBBCDField;
    CotizacionEstadoDINERO: TIBBCDField;
    CotizacionEstadoDINERO_ALZA_DOBLE: TIBBCDField;
    CotizacionEstadoDINERO_BAJA_DOBLE: TIBBCDField;
    CotizacionEstadoDINERO_BAJA_SIMPLE: TIBBCDField;
    CotizacionEstadoDINERO_ALZA_SIMPLE: TIBBCDField;
    CotizacionEstadoPAPEL: TIBBCDField;
    CotizacionEstadoPAPEL_ALZA_DOBLE: TIBBCDField;
    CotizacionEstadoPAPEL_ALZA_SIMPLE: TIBBCDField;
    CotizacionEstadoPAPEL_BAJA_DOBLE: TIBBCDField;
    CotizacionEstadoPAPEL_BAJA_SIMPLE: TIBBCDField;
    CotizacionEstadoDIMENSION_FRACTAL: TIBBCDField;
    CotizacionEstadoPOTENCIAL_FRACTAL: TSmallintField;
    CotizacionEstadoRSI_140: TSmallintField;
    CotizacionEstadoRSI_14: TSmallintField;
    CotizacionEstadoDOBSON_ALTO_130: TSmallintField;
    CotizacionEstadoDOBSON_ALTO_100: TSmallintField;
    CotizacionEstadoDOBSON_ALTO_70: TSmallintField;
    CotizacionEstadoDOBSON_ALTO_40: TSmallintField;
    CotizacionEstadoDOBSON_ALTO_10: TSmallintField;
    CotizacionEstadoDOBSON_130: TSmallintField;
    CotizacionEstadoDOBSON_100: TSmallintField;
    CotizacionEstadoDOBSON_70: TSmallintField;
    CotizacionEstadoDOBSON_40: TSmallintField;
    CotizacionEstadoDOBSON_10: TSmallintField;
    CotizacionEstadoDOBSON_BAJO_130: TSmallintField;
    CotizacionEstadoDOBSON_BAJO_100: TSmallintField;
    CotizacionEstadoDOBSON_BAJO_70: TSmallintField;
    CotizacionEstadoDOBSON_BAJO_40: TSmallintField;
    CotizacionEstadoDOBSON_BAJO_10: TSmallintField;
    CotizacionEstadoMAXIMO_SE_PREVINO: TIBBCDField;
    CotizacionEstadoMINIMO_SE_PREVINO: TIBBCDField;
    CotizacionEstadoMAXIMO_PREVISTO: TIBBCDField;
    CotizacionEstadoMINIMO_PREVISTO: TIBBCDField;
    CotizacionEstadoPIVOT_POINT: TIBBCDField;
    CotizacionEstadoPIVOT_POINT_R1: TIBBCDField;
    CotizacionEstadoPIVOT_POINT_R2: TIBBCDField;
    CotizacionEstadoPIVOT_POINT_R3: TIBBCDField;
    CotizacionEstadoPIVOT_POINT_S1: TIBBCDField;
    CotizacionEstadoPIVOT_POINT_S2: TIBBCDField;
    CotizacionEstadoPIVOT_POINT_S3: TIBBCDField;
    CotizacionEstadoSTOP: TIBBCDField;
    CotizacionEstadoMEDIA_200: TIBBCDField;
    CotizacionEstadoCAMBIO_ALZA_SIMPLE: TIBBCDField;
    CotizacionEstadoCAMBIO_ALZA_DOBLE: TIBBCDField;
    CotizacionEstadoCAMBIO_BAJA_SIMPLE: TIBBCDField;
    CotizacionEstadoCAMBIO_BAJA_DOBLE: TIBBCDField;
    CotizacionEstadoPERCENT_ALZA_SIMPLE: TIBBCDField;
    CotizacionEstadoPERCENT_BAJA_SIMPLE: TIBBCDField;
    CotizacionEstadoPERCENT_BAJA_DOBLE: TCurrencyField;
    CotizacionEstadoPERCENT_ALZA_DOBLE: TCurrencyField;
    CotizacionEstadoZONA_BAJA_SIMPLE_DESC: TStringField;
    CotizacionEstadoZONA_BAJA_DOBLE_DESC: TStringField;
    CotizacionEstadoZONA_ALZA_SIMPLE_DESC: TStringField;
    CotizacionEstadoZONA_ALZA_DOBLE_DESC: TStringField;
    CotizacionEstadoZONA_DESC: TStringField;
    CotizacionEstadoMAXIMO_PREVISTO_APROX: TIBBCDField;
    CotizacionEstadoMINIMO_PREVISTO_APROX: TIBBCDField;
    CotizacionEstadoZONA_ALZA_DOBLE: TIBStringField;
    CotizacionEstadoZONA_ALZA_SIMPLE: TIBStringField;
    CotizacionEstadoZONA_BAJA_DOBLE: TIBStringField;
    CotizacionEstadoZONA_BAJA_SIMPLE: TIBStringField;
    CotizacionEstadoZONA: TIBStringField;
    CotizacionEstadoNIVEL_SUBE: TIBStringField;
    CotizacionEstadoNIVEL_ACTUAL: TIBStringField;
    CotizacionEstadoNIVEL_BAJA: TIBStringField;
    CotizacionEstadoAMBIENTE_INTRADIA: TIBStringField;
    CotizacionEstadoRENTABILIDAD_ABIERTA: TIBBCDField;
    CotizacionEstadoOR_RENTABILIDAD: TIntegerField;
    CotizacionEstadoCORRELACION: TSmallintField;
    CotizacionEstadoPOSICIONADO: TIBBCDField;
    CotizacionEstadoRIESGO: TIBBCDField;
    CotizacionEstadoPRESION_VERTICAL: TIBBCDField;
    CotizacionEstadoPRESION_VERTICAL_ALZA_SIMPLE: TIBBCDField;
    CotizacionEstadoPRESION_VERTICAL_ALZA_DOBLE: TIBBCDField;
    CotizacionEstadoPRESION_VERTICAL_BAJA_SIMPLE: TIBBCDField;
    CotizacionEstadoPRESION_VERTICAL_BAJA_DOBLE: TIBBCDField;
    CotizacionEstadoPRESION_LATERAL: TIBBCDField;
    CotizacionEstadoPRESION_LATERAL_ALZA_SIMPLE: TIBBCDField;
    CotizacionEstadoPRESION_LATERAL_ALZA_DOBLE: TIBBCDField;
    CotizacionEstadoPRESION_LATERAL_BAJA_SIMPLE: TIBBCDField;
    CotizacionEstadoPRESION_LATERAL_BAJA_DOBLE: TIBBCDField;
    CotizacionEstadoRELACION_VOL_VAR: TCurrencyField;
    Valores: TkbmMemTable;
    ValoresOID_VALOR: TSmallintField;
    ValoresOID_MERCADO: TSmallintField;
    ValoresNOMBRE: TIBStringField;
    ValoresSIMBOLO: TIBStringField;
    ValoresDECIMALES: TSmallintField;
    ValoresMERCADO: TIBStringField;
    CotizacionAPERTURA: TIBBCDField;
    CotizacionCIERRE: TIBBCDField;
    CotizacionVOLUMEN: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure CotizacionEstadoCalcFields(DataSet: TDataSet);
    procedure CotizacionEstadoNIVELGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
    procedure ValoresAfterScroll(DataSet: TDataSet);
    procedure ValoresBeforeScroll(DataSet: TDataSet);
    procedure CotizacionAfterScroll(DataSet: TDataSet);
    procedure ValoresOID_VALORGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    FValoresActivator: TValores;
    FUltimaFecha: TDate;
    FTipoCotizacion: TTipoCotizacion;
    Flags: TFlags;
    FechaTipoCotDiario, FechaTipoCotSemanal: TDate;
    CambiandoValor: boolean;
    PackPos: array[1..1334] of string;
//    function GetFilteredValues: boolean;
    procedure SetTipoCotizacion(const Value: TTipoCotizacion);
    function GetSesion: TDate;
    function GetOIDSesion: integer;
    function GetValorSinCotizar: boolean;
    function GetOIDValor: integer;
    function GetPosicionamientoValor: TPosicionamientoValor;
    function GetPosicionado: currency;
    procedure OnDatosActualizados;
    procedure RefreshValores;
    function GetTipoCotizacionAsString: string;
    procedure SetTipoCotizacionAsString(const Value: string);
    procedure AjustarDisplayFormat;
    function GetBDDatos: TBDDatos;
  public
    procedure IrACotizacionConFecha(fecha: TDate);
    procedure IrACotizacionUltimaFecha;
    function IrAValor(const OIDValor: integer): boolean;
    procedure ValorSiguiente;
    procedure ValorAnterior;
    function hayValorAnterior: boolean;
    function hayValorPosterior: boolean;
    function CrearIndicador(const field: TField): TDataSet;
    function TieneEstado: boolean;
    function HayValores: boolean;
{    property GrupoActivo: integer read FGrupoActivo;
    property MercadoActivo: integer read FMercadoActivo;
    property IndicesActivo: integer read FIndicesActivo;}
  //  property FilteredValues: boolean read GetFilteredValues;
//    property TipoAgrupacionValores: TTipoAgrupacionValores read GetTipoAgrupacionValores;
    property OIDValor: integer read GetOIDValor;
    property TipoCotizacion: TTipoCotizacion read FTipoCotizacion write SetTipoCotizacion;
    property TipoCotizacionAsString: string read GetTipoCotizacionAsString write SetTipoCotizacionAsString;
//    property QueryValores: TQueryValores read FQueryValores;
    property Sesion: TDate read GetSesion;
    property OIDSesion: integer read GetOIDSesion;
    property ValorSinCotizar: boolean read GetValorSinCotizar;
    property PosicionamientoValor: TPosicionamientoValor read GetPosicionamientoValor;
    property Posicionado: currency read GetPosicionado;
    property ValoresActivator: TValores read FValoresActivator;
    property BDDatos: TBDDatos read GetBDDatos;
  end;

var
  Data: TData;

implementation

uses UtilDB, Dialogs, Variants, dmConfiguracion, dmDataComun, dmActualizarDatos;


{$R *.dfm}

procedure TData.DataModuleCreate(Sender: TObject);
var packPosFile: TStringList;
  i, oidValor, j: integer;
  aux: string;
begin
  FValoresActivator := TValores.Create(Valores);
  FValoresActivator.LoadConfiguracion;
  flags := TFlags.Create;
  CambiandoValor := false;
  FTipoCotizacion := tcDiaria;
  OpenDataSet(Cotizacion);
  OpenDataSet(CotizacionEstado);
  Locate(Valores, 'OID_VALOR', Configuracion.ReadInteger('Grupo', 'Valor', -1), []);
  Bus.RegisterEvent(MessageDatosActualizados, OnDatosActualizados);

  packPosFile := TStringList.Create;
  if FileExists('pack.txt') then begin
    packPosFile.LoadFromFile('pack.txt');
    for i := 0 to packPosFile.Count - 1 do begin
      aux := packPosFile[i];
      j := Pos(';', aux);
      oidValor := StrToInt(Copy(aux, 1, j - 1));
      PackPos[oidValor] := StringReplace(Copy(aux, j + 1, length(aux)), ';', '-', []);
    end;
  end;
end;


function TData.GetValorSinCotizar: boolean;
begin
  result := CotizacionCIERRE.IsNull;
end;

procedure TData.ValorAnterior;
begin
  Valores.Prior;
end;

procedure TData.ValoresAfterScroll(DataSet: TDataSet);
begin
  CurrencyDecimals := ValoresDECIMALES.Value;
  AjustarDisplayFormat;
  Bus.SendEvent(MessageValorCambiado);
  // Al ser Cotizacion un detalle de Valores, se genera antes el AfterScroll,
  // por lo que primero se recibiría un mensaje de CotizacionCambiada y después
  // de ValorCambiado, y se presupone que es al revés. Para solventarlo, en el
  // BeforeScroll de Valores se pone a true una variable y al producirse el
  // AfterScroll en Cotizacion no realiza un mensaje de notificación cambiada.
  // Por eso, se debe realizar aquí.
  Bus.SendEvent(MessageCotizacionCambiada);
  CambiandoValor := false;
end;

procedure TData.ValoresBeforeScroll(DataSet: TDataSet);
begin
  FUltimaFecha := CotizacionFECHA.Value;
  CambiandoValor := true;
end;


procedure TData.ValoresOID_VALORGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  inherited;
  if ValoresOID_VALOR.IsNull then
    Text := ''
  else
    Text := PackPos[ValoresOID_VALOR.Value];
end;

procedure TData.ValorSiguiente;
begin
  Valores.Next;
end;

procedure TData.RefreshValores;
var OIDValor: integer;
  inspect: TInspectDataSets;
  UltimaFecha: TDate;
begin
  inspect := StartInspectDataSets([Cotizacion, CotizacionEstado, Valores]);
  try
    OIDValor := ValoresOID_VALOR.Value;
    CotizacionEstado.Close;
    UltimaFecha := CotizacionFECHA.Value;
    Cotizacion.Close;
    Valores.Close;
    DataComun.ReloadValores;
    Valores.Open;
    FValoresActivator.Reload;
    Valores.Locate('OID_VALOR', OIDValor, []);
    OpenDataSet(Cotizacion);
    FUltimaFecha := UltimaFecha;
    IrACotizacionUltimaFecha;
    OpenDataSet(CotizacionEstado);
  finally
    EndInspectDataSets(inspect);
  end;
end;


procedure TData.AjustarDisplayFormat;
var i: integer;
  displayFormat: string;
begin
  displayFormat := '#0.';
  for i := CurrencyDecimals downto 1 do begin
    displayFormat := displayFormat + '0';
  end;
  CotizacionCIERRE.DisplayFormat := displayFormat;
  CotizacionMAXIMO.DisplayFormat := displayFormat;
  CotizacionMINIMO.DisplayFormat := displayFormat;
  CotizacionAPERTURA.DisplayFormat := displayFormat;
  CotizacionEstadoBANDA_ALTA.DisplayFormat := displayFormat;
  CotizacionEstadoBANDA_BAJA.DisplayFormat := displayFormat;
  CotizacionEstadoMAXIMO_SE_PREVINO.DisplayFormat := displayFormat;
  CotizacionEstadoMAXIMO_PREVISTO.DisplayFormat := displayFormat;
  CotizacionEstadoMINIMO_PREVISTO.DisplayFormat := displayFormat;
  CotizacionEstadoMINIMO_PREVISTO.DisplayFormat := displayFormat;
  CotizacionEstadoPIVOT_POINT.DisplayFormat := displayFormat;
  CotizacionEstadoPIVOT_POINT_R1.DisplayFormat := displayFormat;
  CotizacionEstadoPIVOT_POINT_R2.DisplayFormat := displayFormat;
  CotizacionEstadoPIVOT_POINT_R3.DisplayFormat := displayFormat;
  CotizacionEstadoPIVOT_POINT_S1.DisplayFormat := displayFormat;
  CotizacionEstadoPIVOT_POINT_S2.DisplayFormat := displayFormat;
  CotizacionEstadoPIVOT_POINT_S3.DisplayFormat := displayFormat;
  CotizacionEstadoSTOP.DisplayFormat := displayFormat;
  CotizacionEstadoMEDIA_200.DisplayFormat := displayFormat;
  CotizacionEstadoCAMBIO_ALZA_SIMPLE.DisplayFormat := displayFormat;
  CotizacionEstadoCAMBIO_ALZA_DOBLE.DisplayFormat := displayFormat;
  CotizacionEstadoCAMBIO_BAJA_SIMPLE.DisplayFormat := displayFormat;
  CotizacionEstadoCAMBIO_BAJA_DOBLE.DisplayFormat := displayFormat;
  CotizacionEstadoMAXIMO_PREVISTO_APROX.DisplayFormat := displayFormat;
  CotizacionEstadoMINIMO_PREVISTO_APROX.DisplayFormat := displayFormat;
end;

procedure TData.CotizacionAfterScroll(DataSet: TDataSet);
begin
  if not CambiandoValor then
    Bus.SendEvent(MessageCotizacionCambiada);
end;

procedure TData.CotizacionEstadoCalcFields(DataSet: TDataSet);
var variabilidad: currency;
begin
  CotizacionEstadoPERCENT_ALZA_DOBLE.Value := 2 * CotizacionEstadoPERCENT_ALZA_SIMPLE.Value;
  CotizacionEstadoPERCENT_BAJA_DOBLE.Value := 2 * CotizacionEstadoPERCENT_BAJA_SIMPLE.Value;
  variabilidad := CotizacionEstadoVARIABILIDAD.Value;
  if variabilidad = 0 then
    CotizacionEstadoRELACION_VOL_VAR.Clear
  else
    CotizacionEstadoRELACION_VOL_VAR.Value := CotizacionEstadoVOLATILIDAD.Value / variabilidad;

  CotizacionEstadoZONA_DESC.Value := DataComun.FindZona(CotizacionEstadoZONA.AsInteger);
  CotizacionEstadoZONA_BAJA_SIMPLE_DESC.Value := DataComun.FindZona(CotizacionEstadoZONA_BAJA_SIMPLE.AsInteger);
  CotizacionEstadoZONA_BAJA_DOBLE_DESC.Value := DataComun.FindZona(CotizacionEstadoZONA_BAJA_DOBLE.AsInteger);
  CotizacionEstadoZONA_ALZA_SIMPLE_DESC.Value := DataComun.FindZona(CotizacionEstadoZONA_ALZA_SIMPLE.AsInteger);
  CotizacionEstadoZONA_ALZA_DOBLE_DESC.Value := DataComun.FindZona(CotizacionEstadoZONA_ALZA_DOBLE.AsInteger);
end;

procedure TData.CotizacionEstadoNIVELGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := Sender.AsString;
  if Text = 'A' then
    Text := '10';
end;

function TData.CrearIndicador(const field: TField): TDataSet;
var sql: string;
  query: TIBQuery;
begin
  sql := 'SELECT CE.' + Field.FieldName + ' FROM COTIZACION C ' +
   'LEFT OUTER JOIN COTIZACION_ESTADO CE ON (C.OID_COTIZACION = CE.OR_COTIZACION) ' +
   'LEFT OUTER JOIN SESION S ON (C.OR_SESION = S.OID_SESION) WHERE ' +
   '(C.OR_SESION = S.OID_SESION) AND (C.OR_VALOR = :OID_VALOR) AND ' +
   '(C.TIPO = :TIPO) ORDER BY s.fecha DESC';
  query := TIBQuery.Create(Self);
  query.Database := Cotizacion.Database;
  query.Transaction := Cotizacion.Transaction;
  query.SQL.Text := sql;
  query.ParamByName('OID_VALOR').AsInteger := ValoresOID_VALOR.Value;
  if FTipoCotizacion = tcDiaria then
    query.ParamByName('TIPO').AsString := 'D'
  else
    query.ParamByName('TIPO').AsString := 'S';
  OpenDataSet(query);
  result := query;
end;

procedure TData.SetTipoCotizacion(const Value: TTipoCotizacion);
var fecha: TDate;
  eventsCot, eventsCotEstado: TDataSetEvents;
begin
  if Value <> FTipoCotizacion then begin
    CambiandoValor := true;
    try
      fecha := CotizacionFECHA.Value;
      // Estabamos en diario
      if FTipoCotizacion = tcDiaria then
        FechaTipoCotDiario := fecha;
      FTipoCotizacion := Value;
      eventsCot := DisableEventsDataSet(Cotizacion);
      try
        eventsCotEstado := DisableEventsDataSet(CotizacionEstado);
        try
          CotizacionEstado.Close;
          Cotizacion.Close;
          if Value = tcDiaria then
            BD.BDDatos := bddDiaria
          else
            BD.BDDatos := bddSemanal;
          OpenDataSet(Cotizacion);
          if (FTipoCotizacion = tcDiaria) and (FechaTipoCotSemanal = fecha) then
            IrACotizacionConFecha(FechaTipoCotDiario)
          else begin
            IrACotizacionConFecha(fecha);
            // Si ahora estamos en semanal
            if FTipoCotizacion = tcSemanal then
              FechaTipoCotSemanal := CotizacionFECHA.Value;
          end;
          OpenDataSet(CotizacionEstado);
        finally
          EnableEventsDataSet(CotizacionEstado, eventsCotEstado);
        end;
      finally
        EnableEventsDataSet(Cotizacion, eventsCot);
      end;
    finally
      CambiandoValor := false;
    end;
    Bus.SendEvent(MessageTipoCotizacionCambiada);
    //El cambiar de diario a semanal son 2 valores distintos
    Bus.SendEvent(MessageValorCambiado);
    Bus.SendEvent(MessageCotizacionCambiada);
  end;
end;

procedure TData.SetTipoCotizacionAsString(const Value: string);
begin
  if Value = 'D' then
    TipoCotizacion := tcDiaria
  else
    if Value ='S' then
      TipoCotizacion := tcSemanal
    else
      raise ETipoCotizacionDesconocido.Create('TipoCotizacion incorrecto: ' + Value);
end;

function TData.TieneEstado: boolean;
begin
  result := not CotizacionEstado.IsEmpty;
end;


function TData.hayValorAnterior: boolean;
begin
  result := Valores.RecNo > 1;
end;

function TData.HayValores: boolean;
begin
  result := Valores.RecordCount > 0;
end;

function TData.hayValorPosterior: boolean;
begin
  result := not Valores.EOF;
end;

function TData.IrAValor(const OIDValor: integer): boolean;
begin
  result := Locate(Valores, 'OID_VALOR', OIDValor, []);
end;

procedure TData.OnDatosActualizados;
begin
  RefreshValores;
  // RefreshValores reabre los datasets pero no lanzan los eventos, para ser
  // más rápido. Una vez todo recargado, se deben lanzar los eventos como si
  // se hubiese pasado de valor.
  ValoresAfterScroll(nil);
end;

procedure TData.DataModuleDestroy(Sender: TObject);
begin
  flags.Free;
  Bus.UnregisterEvent(MessageDatosActualizados, OnDatosActualizados);
  FValoresActivator.SaveConfiguracion;
  Configuracion.WriteInteger('Grupo', 'Valor', ValoresOID_VALOR.AsInteger);
  FValoresActivator.Free;
end;


procedure TData.IrACotizacionConFecha(fecha: TDate);
var events: TDataSetEvents;
begin
  if (fecha = 0) or (CotizacionFECHA.Value = fecha) then
    exit;
  //Se debe utilizar TDataSetEvents envez de InspectDataSet porque el inspectDataSet
  //guarda la última posición y se reposiciona.
  events := DisableEventsDataSet(Cotizacion);
  try
    CotizacionEstado.Close;
    Cotizacion.First;
    while (not Cotizacion.Eof) and (CotizacionFECHA.Value > fecha) do
      Cotizacion.Next;
    OpenDataSet(CotizacionEstado);
  finally
    EnableEventsDataSet(Cotizacion, events, true);
  end;
end;

procedure TData.IrACotizacionUltimaFecha;
begin
  IrACotizacionConFecha(FUltimaFecha);
end;

function TData.GetBDDatos: TBDDatos;
begin
  result := BD.BDDatos;
end;

function TData.GetOIDSesion: integer;
begin
  result := CotizacionOR_SESION.Value;
end;

function TData.GetOIDValor: integer;
begin
  result := ValoresOID_VALOR.Value;
end;

function TData.GetPosicionado: currency;
begin
  result := CotizacionEstadoPOSICIONADO.Value;
end;

function TData.GetPosicionamientoValor: TPosicionamientoValor;
begin
  if CotizacionEstadoSTOP.IsNull then
    result := pvIndefinido
  else
    if CotizacionEstadoSTOP.Value > CotizacionCIERRE.Value then
      result := pvCorto
    else
      result := pvLargo;
end;

function TData.GetSesion: TDate;
begin
  result := CotizacionFECHA.Value;
end;

function TData.GetTipoCotizacionAsString: string;
begin
  if TipoCotizacion = tcDiaria then
    result := 'D'
  else
    result := 'S';
end;

end.
