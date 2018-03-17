unit dmCuentaBase;

interface

uses
  SysUtils, Variants, Classes, Graphics, Controls,
  Dialogs, dmCuentaMovimientosBase, DB, IBQuery, tipos, dmData, kbmMemTable,
  IBCustomDataSet;

type
  TTipoPosicion = (tpLargo, tpCorto);

  EVentaException = class(Exception);

  TCerrarMonedasResult = (cmrCancelado, cmrSinCambios, cmrCambiado);

  TCuentaBase = class(TCuentaMovimientosBase)
    CurvaCapital: TkbmMemTable;
    CurvaCapitalNUM_MOVIMIENTO: TIntegerField;
    CurvaCapitalFECHA_HORA: TDateTimeField;
    CurvaCapitalGANANCIA: TBCDField;
    CurvaCapitalTOTAL: TCurrencyField;
    PosicionesAbiertas: TkbmMemTable;
    PosicionesCerradas: TkbmMemTable;
    PosicionesAbiertasNUM_MOVIMIENTO: TIntegerField;
    PosicionesAbiertasFECHA_HORA: TDateTimeField;
    PosicionesAbiertasOR_VALOR: TSmallintField;
    PosicionesAbiertasNUM_ACCIONES: TIntegerField;
    PosicionesAbiertasCAMBIO: TBCDField;
    PosicionesAbiertasPOSICION: TStringField;
    PosicionesCerradasNUM_MOVIMIENTO: TIntegerField;
    PosicionesCerradasFECHA_HORA: TDateTimeField;
    PosicionesCerradasOR_VALOR: TSmallintField;
    PosicionesCerradasNUM_ACCIONES: TIntegerField;
    PosicionesCerradasCAMBIO: TBCDField;
    PosicionesCerradasCOMISION: TBCDField;
    PosicionesCerradasPOSICION: TStringField;
    PosicionesCerradasOR_NUM_MOVIMIENTO: TIntegerField;
    PosicionesCerradasGANANCIA: TBCDField;
    PosicionesAbiertasCAMBIO_ACTUAL: TCurrencyField;
    PosicionesAbiertasSTOP_DIARIO: TCurrencyField;
    PosicionesAbiertasGANANCIA_PER_CENT_DIARIO: TCurrencyField;
    PosicionesAbiertasGANANCIA_TOTAL_DIARIO: TCurrencyField;
    PosicionesCerradasFECHA_HORA_COMPRA: TDateTimeField;
    PosicionesCerradasCAMBIO_COMPRA: TBCDField;
    PosicionesCerradasCOMISION_COMPRA: TBCDField;
    PosicionesAbiertasSIMBOLO: TStringField;
    PosicionesAbiertasNOMBRE: TStringField;
    PosicionesAbiertasMERCADO: TStringField;
    PosicionesAbiertasOID_MERCADO: TSmallintField;
    PosicionesCerradasSIMBOLO: TStringField;
    PosicionesCerradasNOMBRE: TStringField;
    PosicionesCerradasMERCADO: TStringField;
    PosicionesCerradasOID_MERCADO: TSmallintField;
    qCambioStopDiario: TIBQuery;
    PosicionesAbiertasBROKER_ID: TIntegerField;
    PosicionesAbiertasOID_MONEDA: TSmallintField;
    PosicionesAbiertasMONEDA: TStringField;
    PosicionesCerradasOID_MONEDA: TSmallintField;
    PosicionesCerradasMONEDA: TStringField;
    PosicionesCerradasMONEDA_VALOR: TBCDField;
    PosicionesAbiertasSTOP_SEMANAL: TCurrencyField;
    PosicionesAbiertasGANANCIA_PER_CENT_SEMANAL: TCurrencyField;
    PosicionesAbiertasGANANCIA_TOTAL_SEMANAL: TCurrencyField;
    PosicionesAbiertasCOMISION: TCurrencyField;
    qCambioStopSemanal: TIBQuery;
    qCambioStopDiarioSTOP: TIBBCDField;
    qCambioStopSemanalSTOP: TIBBCDField;
    CurvaCapitalOR_VALOR: TIntegerField;
    qCambioStopDiarioCIERRE: TIBBCDField;
    qCambioStopSemanalCIERRE: TIBBCDField;
    procedure CurvaCapitalAfterScroll(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure PosicionesCerradasAfterScroll(DataSet: TDataSet);
  private
    FOnAfterScrollCurvaCapital: TNotifyEvent;
    FOnAnadirCurvaCapital: TNotifyEvent;
    TotalGanancia: currency;
    FFechaActual: TDate;
    FOnInicializarCurvaCapital: TNotificacion;
    DoingAfterScroll: boolean;
    procedure SetFechaActual(const Value: TDate);
  protected
    inicializando: boolean;
    OIDNumMovimiento: integer;
    procedure AnadirCurvaCapital; virtual;
    procedure InicializarResto; virtual;
    procedure Inicializar; override;
    function GetNumMovimiento: integer; override;
    procedure InicializarPosicionesAbiertas; virtual;
    procedure InicializarPosicionesCerradas; virtual;
    procedure InicializarCurvaCapital; virtual;
    procedure BeforeCalculateValoresActual; virtual;
    function GetCambioActualPosicionAbierta: currency; virtual;
    function GetStopActualPosicionAbierta(const TipoCotizacion: TTipoCotizacion): currency; virtual;
    procedure AbrirPosicion;
    procedure CerrarPosicion(const OIDMovimientoCompra: integer);
    procedure ValoresActualPosicionAbierta;
    function GetCambioMoneda(const OIDMoneda: integer): currency; override;
    procedure RecalcularGanancia(const valorMoneda: currency);
  public
    function CerrarMonedas: TCerrarMonedasResult; virtual;
    function CambiarCambioMoneda: TCerrarMonedasResult; virtual;
    procedure BorrarCambioMoneda;
    procedure BorrarMovimiento; virtual;
    function EsCompraVenta: boolean;
    function HayCambioMoneda: boolean;
    procedure InvalidateValoresActualPosicionesAbiertas;
    procedure VentaAcciones(const BrokerID: integer; const fecha: TDateTime;
      const cambio, comision, MonedaValor: currency); reintroduce; overload;
    procedure VentaAcciones(const fecha: TDateTime; const cambio, comision, MonedaValor: currency); reintroduce; overload;
    procedure VentaAcciones(const BrokerID: integer; const fecha: TDateTime;
      const OIDMovimientoCompra: integer; const cambio, comision, MonedaValor: currency); overload; override;
    function CompraAcciones(const BrokerID: integer; const fecha: TDateTime;
      const OIDValor: integer; const NumAcciones: cardinal; Cambio, Comision: currency;
      const EsPosicionLarga: boolean; const MonedaValor: currency): integer; override;
    function Select(const Field: TField; const ir: boolean): boolean;
    function LocateBrokerID(const BrokerID: integer): boolean;
    function StopRoto(const TipoCotizacion: TTipoCotizacion): boolean;
    property OnAnadirCurvaCapital: TNotifyEvent read FOnAnadirCurvaCapital write FOnAnadirCurvaCapital;
    property OnAfterScrollCurvaCapital: TNotifyEvent read FOnAfterScrollCurvaCapital write FOnAfterScrollCurvaCapital;
    property FechaActual: TDate read FFechaActual write SetFechaActual;
    property OnInicializarCurvaCapital: TNotificacion read FOnInicializarCurvaCapital write FOnInicializarCurvaCapital;
  end;

const
  TipoPosicionString : array [TTipoPosicion] of char = ('L', 'C');

implementation

uses UtilDB, fmCambioMoneda, dmDataComun, dmCambioMoneda,
  UtilForms, fmCerrarMoneda, dmBD, IBDatabase;

{$R *.dfm}

resourcestring
  E_MSG_VENTA_EXCEPTION = 'Al vender no se ha encontrado el movimiento de compra en las ' +
      'posiciones abiertas';
  BORRAR_MOV_TITULO = 'Borrar movimiento';
  BORRAR_MOV_MSG = 'Esta intentando borrar un movimiento de compra que ' +
        'tiene asociado un movimiento de venta.' + #13 +
        'Si borra este movimiento también se borrará automáticamente el de venta.' + #13 + #13 +
        '¿Confirma el borrado?';

procedure TCuentaBase.AbrirPosicion;
begin
  PosicionesAbiertas.Append;
  PosicionesAbiertasNUM_MOVIMIENTO.Value := CuentaMovimientosNUM_MOVIMIENTO.Value;
  PosicionesAbiertasFECHA_HORA.Value := CuentaMovimientosFECHA_HORA.Value;
  PosicionesAbiertasOR_VALOR.Value := CuentaMovimientosOR_VALOR.Value;
  PosicionesAbiertasNUM_ACCIONES.Value := CuentaMovimientosNUM_ACCIONES.Value;
  PosicionesAbiertasCAMBIO.Value := CuentaMovimientosCAMBIO.Value;
  PosicionesAbiertasPOSICION.Value := CuentaMovimientosPOSICION.Value;
  PosicionesAbiertasNOMBRE.Value := CuentaMovimientosNOMBRE.Value;
  PosicionesAbiertasSIMBOLO.Value := CuentaMovimientosSIMBOLO.Value;
  PosicionesAbiertasOID_MERCADO.Value := CuentaMovimientosOID_MERCADO.Value;
  PosicionesAbiertasMERCADO.Value := CuentaMovimientosMERCADO.Value;
  PosicionesAbiertasOID_MONEDA.Value := CuentaMovimientosOID_MONEDA.Value;
  PosicionesAbiertasMONEDA.Value := CuentaMovimientosMONEDA.Value;
  PosicionesAbiertasCOMISION.Value := 2 * CuentaMovimientosCOMISION.Value;
  if not inicializando then
    BeforeCalculateValoresActual;
  PosicionesAbiertasSTOP_DIARIO.Value := GetStopActualPosicionAbierta(tcDiaria);
  PosicionesAbiertasSTOP_SEMANAL.Value := GetStopActualPosicionAbierta(tcSemanal);
  PosicionesAbiertasBROKER_ID.Value := CuentaMovimientosBROKER_ID.Value;
  if not inicializando then
    ValoresActualPosicionAbierta;
  PosicionesAbiertas.Post;
end;

procedure TCuentaBase.AnadirCurvaCapital;
var ganancia: currency;
begin
  CurvaCapital.First;
  CurvaCapital.Insert;
  CurvaCapitalNUM_MOVIMIENTO.Value := CuentaMovimientosNUM_MOVIMIENTO.Value;
  CurvaCapitalFECHA_HORA.Value := CuentaMovimientosFECHA_HORA.Value;
  CurvaCapitalOR_VALOR.Value := CuentaMovimientosOR_VALOR.Value;
  ganancia := CuentaMovimientosGANANCIA_MONEDA_BASE.Value;
{  ganancia := CuentaMovimientosGANANCIA.Value;
  if FOIDMoneda <> CuentaMovimientosOID_MONEDA.Value then
    if (not CuentaMovimientosMONEDA_VALOR.IsNull) and (CuentaMovimientosMONEDA_VALOR.Value <> 0) then
      ganancia := ganancia / CuentaMovimientosMONEDA_VALOR.Value;}
  CurvaCapitalGANANCIA.Value := ganancia;
  TotalGanancia := TotalGanancia + ganancia;
  CurvaCapitalTOTAL.Value := TotalGanancia;
  CurvaCapital.Post;
  if (not inicializando) and (Assigned(FOnAnadirCurvaCapital)) then
    FOnAnadirCurvaCapital(Self);
end;

procedure TCuentaBase.BeforeCalculateValoresActual;
begin
  qCambioStopDiario.Close;
  qCambioStopDiario.ParamByName('FECHA').AsDate := FFechaActual;
  qCambioStopDiario.ParamByName('OID_VALOR').AsInteger := PosicionesAbiertasOR_VALOR.Value;
  qCambioStopDiario.Open;
  qCambioStopSemanal.Close;
  qCambioStopSemanal.ParamByName('FECHA').AsDate := FFechaActual;
  qCambioStopSemanal.ParamByName('OID_VALOR').AsInteger := PosicionesAbiertasOR_VALOR.Value;
  qCambioStopSemanal.Open;
end;

procedure TCuentaBase.BorrarCambioMoneda;
begin
  RecalcularGanancia(0);
  InicializarResto;  
end;

procedure TCuentaBase.BorrarMovimiento;
var numMov: integer;
  inspect: TInspectDataSet;
  coste: currency;
begin
  if GetMovimientoInversion = miCompraAcciones then begin
    if CuentaMovimientosOR_NUM_MOVIMIENTO.IsNull then begin
      coste := GetCosteMoneda;
      CuentaMovimientos.Delete;
      FCapital := FCapital + coste;
    end
    else begin
      if ShowMensaje(BORRAR_MOV_TITULO, BORRAR_MOV_MSG, mtConfirmation, mbYesNo) = mrYes then begin
        // Movimiento de venta
        coste := GetCosteMoneda;
        numMov := CuentaMovimientosOR_NUM_MOVIMIENTO.Value;
        CuentaMovimientos.Delete;
        FCapital := FCapital - coste;
        inspect := StartInspectDataSet(CuentaMovimientos);
        try
          if CuentaMovimientos.Locate('NUM_MOVIMIENTO', numMov, []) then begin
            coste := GetCosteMoneda;
            CuentaMovimientos.Delete;
            FCapital := FCapital + coste;
          end;
        finally
          EndInspectDataSet(inspect);
        end;
      end;
    end;
  end
  else begin
    // Movimiento de compra
    numMov := CuentaMovimientosOR_NUM_MOVIMIENTO.Value;
    coste := GetCosteMoneda;
    CuentaMovimientos.Delete;
    FCapital := FCapital - coste;
    if CuentaMovimientos.Locate('NUM_MOVIMIENTO', numMov, []) then begin
      CuentaMovimientos.Edit;
      CuentaMovimientosOR_NUM_MOVIMIENTO.Clear;
      CuentaMovimientos.Post;
    end;
  end;
  InicializarResto;
end;

function TCuentaBase.CambiarCambioMoneda: TCerrarMonedasResult;
var fCambioMoneda: TfCambioMoneda2;
  movOIDMoneda: integer;
begin
  fCambioMoneda := TfCambioMoneda2.Create(nil);
    try
      movOIDMoneda := CuentaMovimientosOID_MONEDA.Value;
      fCambioMoneda.MonedaFrom := DataComun.FindMoneda(FOIDMoneda)^.Nombre;
      fCambioMoneda.MonedaTo := DataComun.FindMoneda(movOIDMoneda)^.Nombre;
      fCambioMoneda.MonedaValor := CuentaMovimientosMONEDA_VALOR.Value;
      if fCambioMoneda.ShowModal = mrOk then begin
        RecalcularGanancia(fCambioMoneda.MonedaValor);
        result := cmrCambiado;
        InicializarResto;
      end
      else
        result := cmrCancelado;
    finally
      fCambioMoneda.Free;
    end;
end;

function TCuentaBase.CerrarMonedas: TCerrarMonedasResult;
var inspect: TInspectDataSet;
  fCerrarMoneda: TfCerrarMoneda;
  cambiosHechos, cancelar, oldVersioning: boolean;
  oldVersioningMode: TkbmVersioningMode;

    procedure CerrarMovimientos;
    type
      TMonedas = record
        cambio: currency;
        compras: boolean;
        ventas: boolean;
      end;
    var movOIDMoneda: integer;
      cambios: array of TMonedas;
      i, iMoneda: integer;
      tipo: TMovimientoInversion;
    begin
      // Presuponemos que el OID_MONEDA están definido correlativamente,
      // empezando por el 1, por lo que el máximo OID_MONEDA será igual al RecordCount
      SetLength(cambios, DataComun.CountMonedas);
      for i := Low(cambios) to High(cambios) do
        cambios[i].cambio := 0;
      CuentaMovimientos.First;
      cancelar := false;
      cambiosHechos := false;
      while (not CuentaMovimientos.Eof) and (not cancelar) do begin
        movOIDMoneda := CuentaMovimientosOID_MONEDA.Value;
        iMoneda := movOIDMoneda - 1;
        tipo := GetMovimientoInversion;
        if (movOIDMoneda <> FOIDMoneda) and (CuentaMovimientosMONEDA_VALOR.IsNull) and
          ((tipo = miCompraAcciones) or (tipo = miVentaAcciones)) then begin
          if cambios[iMoneda].cambio = 0 then begin
            fCerrarMoneda.MonedaFrom := DataComun.FindMoneda(FOIDMoneda)^.Nombre;
            fCerrarMoneda.MonedaTo := DataComun.FindMoneda(movOIDMoneda)^.Nombre;
            if fCerrarMoneda.ShowModal = mrOk then begin
              cambios[iMoneda].cambio := fCerrarMoneda.MonedaValor;
              cambios[iMoneda].compras := fCerrarMoneda.Compras;
              cambios[iMoneda].ventas := fCerrarMoneda.Ventas;
            end
            else
              cancelar := true;
          end;
          if not cancelar then begin
            if ((tipo = miCompraAcciones) and (cambios[iMoneda].compras)) or
               ((tipo = miVentaAcciones) and (cambios[iMoneda].ventas)) then begin
              cambiosHechos := true;
              RecalcularGanancia(cambios[iMoneda].cambio);
            end;
          end;
        end;
        CuentaMovimientos.Next;
      end;
    end;
begin
  inspect := StartInspectDataSet(CuentaMovimientos);
  try
    fCerrarMoneda := TfCerrarMoneda.Create(nil);
    try
      oldVersioning := CuentaMovimientos.EnableVersioning;
      try
        oldVersioningMode := CuentaMovimientos.VersioningMode;
        try
          CuentaMovimientos.VersioningMode := mtvmAllSinceCheckPoint;
          CuentaMovimientos.EnableVersioning := true;
          CuentaMovimientos.StartTransaction;
          CerrarMovimientos;
          if cancelar then begin
            CuentaMovimientos.Rollback;
            result := cmrCancelado;
          end
          else begin
            CuentaMovimientos.Commit;
            if cambiosHechos then begin
              result := cmrCambiado;
              InicializarResto;
            end
            else
              result := cmrSinCambios;
          end;
        finally
          CuentaMovimientos.VersioningMode := oldVersioningMode;
        end;
      finally
        CuentaMovimientos.EnableVersioning := oldVersioning;
      end;
    finally
      fCerrarMoneda.Free;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;

procedure TCuentaBase.CerrarPosicion(const OIDMovimientoCompra: integer);
var inspect: TInspectDataSets;
begin
  if CuentaMovimientos.Locate('OR_NUM_MOVIMIENTO', OIDMovimientoCompra, []) then begin
    PosicionesCerradas.Append;
    PosicionesCerradasNUM_MOVIMIENTO.Value := CuentaMovimientosNUM_MOVIMIENTO.Value;
    PosicionesCerradasFECHA_HORA.Value := CuentaMovimientosFECHA_HORA.Value;
    PosicionesCerradasOR_VALOR.Value := CuentaMovimientosOR_VALOR.Value;
    PosicionesCerradasNUM_ACCIONES.Value := CuentaMovimientosNUM_ACCIONES.Value;
    PosicionesCerradasCAMBIO.Value := CuentaMovimientosCAMBIO.Value;
    PosicionesCerradasPOSICION.Value := CuentaMovimientosPOSICION.Value;
    PosicionesCerradasOR_NUM_MOVIMIENTO.Value := OIDMovimientoCompra;
    PosicionesCerradasGANANCIA.Value := CuentaMovimientosGANANCIA.Value;
    PosicionesCerradasCOMISION.Value := CuentaMovimientosCOMISION.Value;
    PosicionesCerradasNOMBRE.Value := CuentaMovimientosNOMBRE.Value;
    PosicionesCerradasSIMBOLO.Value := CuentaMovimientosSIMBOLO.Value;
    PosicionesCerradasOID_MERCADO.Value := CuentaMovimientosOID_MERCADO.Value;
    PosicionesCerradasMERCADO.Value := CuentaMovimientosMERCADO.Value;
    PosicionesCerradasOID_MONEDA.Value := CuentaMovimientosOID_MONEDA.Value;
    PosicionesCerradasMONEDA.Value := CuentaMovimientosMONEDA.Value;
    if not CuentaMovimientosMONEDA_VALOR.IsNull then
      PosicionesCerradasMONEDA_VALOR.Value := CuentaMovimientosMONEDA_VALOR.Value;
    inspect := StartInspectDataSets([CuentaMovimientos, PosicionesAbiertas]);
    try
      if CuentaMovimientos.Locate('NUM_MOVIMIENTO', OIDMovimientoCompra, []) then begin
        PosicionesCerradasFECHA_HORA_COMPRA.Value := CuentaMovimientosFECHA_HORA.Value;
        PosicionesCerradasCAMBIO_COMPRA.Value := CuentaMovimientosCAMBIO.Value;
        PosicionesCerradasCOMISION_COMPRA.Value := CuentaMovimientosCOMISION.Value;
      end
      else
        raise Exception.Create(Format(ERROR_INTERNO_VENTA + ' Compra.', [OIDMovimientoCompra]));
      if PosicionesAbiertas.Locate('NUM_MOVIMIENTO', OIDMovimientoCompra, []) then
        PosicionesAbiertas.Delete
      else
        raise Exception.Create(Format(ERROR_INTERNO_VENTA + ' PosAbiertas.', [OIDMovimientoCompra]));
    finally
      EndInspectDataSets(inspect);
    end;
    PosicionesCerradas.Post;
    if CuentaMovimientos.Locate('NUM_MOVIMIENTO', PosicionesCerradasNUM_MOVIMIENTO.Value, []) then
      AnadirCurvaCapital
    else
      raise Exception.Create(Format(ERROR_INTERNO_VENTA + ' Curva.', [PosicionesCerradasNUM_MOVIMIENTO.Value]));
  end
  else
    raise Exception.Create(Format(ERROR_INTERNO_VENTA + ' Curva.', [OIDMovimientoCompra]));
end;

function TCuentaBase.CompraAcciones(const BrokerID: integer; const fecha: TDateTime;
  const OIDValor: integer; const NumAcciones: cardinal; Cambio, Comision: currency;
  const EsPosicionLarga: boolean; const MonedaValor: currency): integer;
begin
  result := inherited CompraAcciones(BrokerID, fecha, OIDValor, NumAcciones,
    Cambio, Comision, EsPosicionLarga, MonedaValor);
  AbrirPosicion;
end;

procedure TCuentaBase.CurvaCapitalAfterScroll(DataSet: TDataSet);
begin
  inherited;
  if not inicializando then begin
    if not DoingAfterScroll then begin
      DoingAfterScroll := true;
      try
        PosicionesCerradas.Locate('NUM_MOVIMIENTO', CurvaCapitalNUM_MOVIMIENTO.Value, []);
      finally
        DoingAfterScroll := false;
      end;
      if Assigned(FOnAfterScrollCurvaCapital) then
        FOnAfterScrollCurvaCapital(Self);
    end;
  end;
end;

procedure TCuentaBase.DataModuleCreate(Sender: TObject);
var transactionDiario, transactionSemanal: TIBTransaction;
  BDDiario, BDSemanal: TIBDatabase;
begin
  inherited;
  OIDNumMovimiento := 0;
  FFechaActual := now;
  BDDiario := BD.GetNewDatabase(Self, scdDatos, bddDiaria);
  BDSemanal := BD.GetNewDatabase(Self, scdDatos, bddSemanal);
  transactionDiario := TIBTransaction.Create(Self);
  transactionSemanal := TIBTransaction.Create(Self);
  transactionDiario.AddDatabase(BDDiario);
  transactionSemanal.AddDatabase(BDSemanal);
  qCambioStopDiario.Database := BDDiario;
  qCambioStopDiario.Transaction := transactionDiario;
  qCambioStopSemanal.Database := BDSemanal;
  qCambioStopSemanal.Transaction := transactionSemanal;
end;

function TCuentaBase.EsCompraVenta: boolean;
var mov: TMovimientoInversion;
begin
  result := (not CuentaMovimientos.IsEmpty) and
    (CuentaMovimientosOID_MONEDA.Value <> FOIDMoneda);

  if result then begin
    mov := GetMovimientoInversion;
    result := (mov = miVentaAcciones) or (mov = miCompraAcciones);
  end;
end;

function TCuentaBase.GetCambioActualPosicionAbierta: currency;
begin
  result := qCambioStopDiarioCIERRE.Value;
end;

function TCuentaBase.GetCambioMoneda(const OIDMoneda: integer): currency;
var CambioMoneda: TCambioMoneda;
begin
  CambioMoneda := TCambioMoneda.Create(nil);
  try
    result := CambioMoneda.GetCambioBD(FOIDMoneda, OIDMoneda);
  finally
    CambioMoneda.Free;
  end;
end;

function TCuentaBase.GetNumMovimiento: integer;
begin
  inc(OIDNumMovimiento);
  result := OIDNumMovimiento;
end;

function TCuentaBase.GetStopActualPosicionAbierta(const TipoCotizacion: TTipoCotizacion): currency;
begin
  if TipoCotizacion = tcDiaria then
    result := qCambioStopDiarioSTOP.Value
  else
    result := qCambioStopSemanalSTOP.Value;
end;

function TCuentaBase.HayCambioMoneda: boolean;
begin
  result := not CuentaMovimientosMONEDA_VALOR.IsNull;
end;

procedure TCuentaBase.Inicializar;
begin
  inherited;
  inicializando := true;
  try
    InicializarResto;
    InvalidateValoresActualPosicionesAbiertas;
  finally
    inicializando := false;
  end;
end;

procedure TCuentaBase.InicializarCurvaCapital;
begin
  TotalGanancia := 0;
  CurvaCapital.Close;
  CurvaCapital.Open;
end;

procedure TCuentaBase.InicializarPosicionesAbiertas;
begin
  PosicionesAbiertas.Close;
  PosicionesAbiertas.Open;
end;

procedure TCuentaBase.InicializarPosicionesCerradas;
begin
  PosicionesCerradas.Close;
  PosicionesCerradas.Open;
end;

procedure TCuentaBase.InicializarResto;
var inspect: TInspectDataSets;
begin
  inspect := StartInspectDataSets([CuentaMovimientos, PosicionesAbiertas,
    PosicionesCerradas, CurvaCapital]);
  try
    InicializarCurvaCapital;
    InicializarPosicionesAbiertas;
    InicializarPosicionesCerradas;

    CuentaMovimientos.Last;
    while not CuentaMovimientos.Bof do begin
      case GetMovimientoInversion of
        miCompraAcciones: begin
          AbrirPosicion;
        end;
        miVentaAcciones: begin
          CerrarPosicion(CuentaMovimientosOR_NUM_MOVIMIENTO.Value);
        end;
      end;
      CuentaMovimientos.Prior;
    end;
  finally
    EndInspectDataSets(inspect);
  end;

  RecalcularCapital;
  if Assigned(FOnInicializarCurvaCapital) then
    FOnInicializarCurvaCapital;
end;

procedure TCuentaBase.InvalidateValoresActualPosicionesAbiertas;
var inspect: TInspectDataSet;
begin
  inspect := StartInspectDataSet(PosicionesAbiertas);
  try
    PosicionesAbiertas.First;
    while not PosicionesAbiertas.Eof do begin
      PosicionesAbiertas.Edit;
      BeforeCalculateValoresActual;
      ValoresActualPosicionAbierta;
      PosicionesAbiertas.Post;
      PosicionesAbiertas.Next;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;

function TCuentaBase.LocateBrokerID(const BrokerID: integer): boolean;
begin
  result := PosicionesAbiertas.Locate('BROKER_ID', BrokerID, []);
end;

procedure TCuentaBase.PosicionesCerradasAfterScroll(DataSet: TDataSet);
begin
  inherited;
  if not inicializando then begin
    if not DoingAfterScroll then begin
      DoingAfterScroll := true;
      try
        CurvaCapital.Locate('NUM_MOVIMIENTO', PosicionesCerradasNUM_MOVIMIENTO.Value, []);
      finally
        DoingAfterScroll := false;
      end;
      if Assigned(FOnAfterScrollCurvaCapital) then
        FOnAfterScrollCurvaCapital(Self);
    end;
  end;
end;

procedure TCuentaBase.RecalcularGanancia(const valorMoneda: currency);

  procedure Venta;
  var inspect: TInspectDataSet;
    costeAnterior, ganancia, gananciaAnterior: currency;
  begin
    inspect := StartInspectDataSet(CuentaMovimientos);
    try
      if CuentaMovimientos.Locate('NUM_MOVIMIENTO', CuentaMovimientosOR_NUM_MOVIMIENTO.Value, []) then begin
        costeAnterior := GetCosteMoneda;
      end
      else
        costeAnterior := 0;
    finally
      EndInspectDataSet(inspect);
    end;
    CuentaMovimientos.Edit;
    if valorMoneda = 0 then
      CuentaMovimientosMONEDA_VALOR.Clear
    else
      CuentaMovimientosMONEDA_VALOR.Value := valorMoneda;
    gananciaAnterior := CuentaMovimientosGANANCIA_MONEDA_BASE.Value;
    ganancia := GetCosteMoneda - costeAnterior;
    CuentaMovimientosGANANCIA_MONEDA_BASE.Value := ganancia;
    CuentaMovimientos.Post;
    FCapital := FCapital + (ganancia - gananciaAnterior);
  end;

  procedure Compra;
  var costeCompra, ganancia, gananciaAnterior: currency;
    inspect: TInspectDataSet;
  begin
    CuentaMovimientos.Edit;
    if valorMoneda = 0 then
      CuentaMovimientosMONEDA_VALOR.Clear
    else
      CuentaMovimientosMONEDA_VALOR.Value := valorMoneda;
    CuentaMovimientos.Post;
    // Tiene una venta asociada
    if not CuentaMovimientosOR_NUM_MOVIMIENTO.IsNull then begin
      costeCompra := GetCosteMoneda;
      inspect := StartInspectDataSet(CuentaMovimientos);
      try
        if CuentaMovimientos.Locate('NUM_MOVIMIENTO',
            CuentaMovimientosOR_NUM_MOVIMIENTO.Value, []) then begin
          gananciaAnterior := CuentaMovimientosGANANCIA_MONEDA_BASE.Value;
          ganancia := GetCosteMoneda - costeCompra;
          CuentaMovimientos.Edit;
          CuentaMovimientosGANANCIA_MONEDA_BASE.Value := ganancia;
          CuentaMovimientos.Post;
          FCapital := FCapital + (ganancia - gananciaAnterior);
        end;
      finally
        EndInspectDataSet(inspect);
      end;
    end;
  end;

begin
  if GetMovimientoInversion = miVentaAcciones then
    Venta
  else
    Compra;
end;


function TCuentaBase.Select(const Field: TField; const ir: boolean): boolean;
var FieldORValor: TIntegerField;
  fecha: TDate;
begin
  result := false;
  if not Field.IsNull then begin
    if Field is TDateTimeField then begin
      FieldORValor := Field.DataSet.FindField('OR_VALOR') as TIntegerField;
      if FieldORValor = nil then
        FieldORValor := Field.DataSet.FindField('OID_VALOR') as TIntegerField;
      if (FieldORValor <> nil) and (not FieldORValor.IsNull) then begin
        result := true;
        if ir then begin
          Data.IrAValor(FieldORValor.Value);
          fecha := Trunc(Field.AsDateTime);
          Data.IrACotizacionConFecha(fecha);
        end;
      end;
    end
    else begin
      if Field = CuentaMovimientosOR_NUM_MOVIMIENTO then begin
        result := true;
        if ir then
          CuentaMovimientos.Locate('NUM_MOVIMIENTO', CuentaMovimientosOR_NUM_MOVIMIENTO.Value, [])
      end
      else
        if (Field.FieldName = 'NOMBRE') or (Field.FieldName = 'SIMBOLO') then begin
          FieldORValor := Field.DataSet.FindField('OR_VALOR') as TIntegerField;
          if FieldORValor = nil then
            FieldORValor := Field.DataSet.FindField('OID_VALOR') as TIntegerField;
          if (FieldORValor <> nil) and (not FieldORValor.IsNull) then begin
            result := true;
            if ir then
              Data.IrAValor(FieldORValor.Value);
          end;
        end;
    end;
  end;
end;

procedure TCuentaBase.SetFechaActual(const Value: TDate);
begin
  FFechaActual := Value;
  InvalidateValoresActualPosicionesAbiertas;
end;

function TCuentaBase.StopRoto(const TipoCotizacion: TTipoCotizacion): boolean;
var largo: boolean;
begin
  largo := PosicionesAbiertasPOSICION.Value = TipoPosicionString[tpLargo];
  if TipoCotizacion = tcDiaria then begin
    if largo then
      result := PosicionesAbiertasSTOP_DIARIO.Value > PosicionesAbiertasCAMBIO_ACTUAL.Value
    else
      result := PosicionesAbiertasSTOP_DIARIO.Value < PosicionesAbiertasCAMBIO_ACTUAL.Value;
  end
  else begin
    if largo then
      result := PosicionesAbiertasSTOP_SEMANAL.Value > PosicionesAbiertasCAMBIO_ACTUAL.Value
    else
      result := PosicionesAbiertasSTOP_SEMANAL.Value < PosicionesAbiertasCAMBIO_ACTUAL.Value;
  end;
end;

procedure TCuentaBase.VentaAcciones(const BrokerID: integer;
  const fecha: TDateTime; const cambio, comision, MonedaValor: currency);
begin
  if PosicionesAbiertas.Locate('BROKER_ID', BrokerID, []) then
    VentaAcciones(BrokerID, fecha, PosicionesAbiertasNUM_MOVIMIENTO.Value, cambio,
      comision, MonedaValor)
  else
    raise EVentaException.Create(E_MSG_VENTA_EXCEPTION);
end;

procedure TCuentaBase.VentaAcciones(const fecha: TDateTime; const cambio,
  comision, MonedaValor: currency);
begin
  VentaAcciones(fecha, PosicionesAbiertasNUM_MOVIMIENTO.Value, cambio, comision, MonedaValor);
end;

procedure TCuentaBase.ValoresActualPosicionAbierta;
var largo: boolean;
  stopDiario, stopSemanal, comision, cambio, cambioActualDiario: currency;
  numAcciones: cardinal;

    function GetGanancia(const stop: currency): currency;
    begin
      if largo then
        result := ((stop - cambio) * numAcciones) - PosicionesAbiertasCOMISION.Value
      else
        result := ((cambio - stop) * numAcciones) - PosicionesAbiertasCOMISION.Value;
    end;

    function GetPerCent(const stop: currency): currency;
    begin
      if largo then
        result :=
        ((((stop * numAcciones) - comision) / ((cambio * numAcciones) + comision)) - 1) * 100
      else
        result :=
            (1 - (((stop * numAcciones) + comision) / ((cambio * numAcciones) - comision))) * 100;
    {           ((((cambio * numAcciones) - comision) - ((cambioActual * numAcciones) + comision)) /
            ((cambio * numAcciones) - comision)) * 100;}
    end;

    procedure Assign(const field: TCurrencyField; const valor: currency);
    begin
      if valor = 0 then
        field.Clear
      else
        field.Value := valor;
    end;

begin
  cambioActualDiario := GetCambioActualPosicionAbierta;
  PosicionesAbiertasCAMBIO_ACTUAL.Value := cambioActualDiario;
  stopDiario := GetStopActualPosicionAbierta(tcDiaria);
  Assign(PosicionesAbiertasSTOP_DIARIO, stopDiario);
  stopSemanal := GetStopActualPosicionAbierta(tcSemanal);
  Assign(PosicionesAbiertasSTOP_SEMANAL, stopSemanal);
  numAcciones := PosicionesAbiertasNUM_ACCIONES.Value;

  comision := PosicionesAbiertasCOMISION.Value;
  cambio := PosicionesAbiertasCAMBIO.Value;
  largo := PosicionesAbiertasPOSICION.Value = TipoPosicionString[tpLargo];
  if stopDiario = 0 then begin
    PosicionesAbiertasGANANCIA_TOTAL_DIARIO.Clear;
    PosicionesAbiertasGANANCIA_PER_CENT_DIARIO.Clear;
  end
  else begin
    Assign(PosicionesAbiertasGANANCIA_TOTAL_DIARIO, GetGanancia(stopDiario));
    Assign(PosicionesAbiertasGANANCIA_PER_CENT_DIARIO, GetPerCent(stopDiario));
  end;
  if stopSemanal = 0 then begin
    PosicionesAbiertasGANANCIA_TOTAL_SEMANAL.Clear;
    PosicionesAbiertasGANANCIA_PER_CENT_SEMANAL.Clear;
  end
  else begin
    Assign(PosicionesAbiertasGANANCIA_TOTAL_SEMANAL, GetGanancia(stopSemanal));
    Assign(PosicionesAbiertasGANANCIA_PER_CENT_SEMANAL, GetPerCent(stopSemanal));
  end;
  PosicionesAbiertasCAMBIO_ACTUAL.Value := cambioActualDiario;
end;

procedure TCuentaBase.VentaAcciones(const BrokerID: integer; const fecha: TDateTime;
  const OIDMovimientoCompra: integer; const cambio, comision, MonedaValor: currency);
begin
  //Siempre se ejecuta, ya que hace un override del método base principal
  if PosicionesAbiertas.Locate('NUM_MOVIMIENTO', OIDMovimientoCompra, []) then begin
    inherited;
    CerrarPosicion(OIDMovimientoCompra);
    PosicionesCerradas.Locate('NUM_MOVIMIENTO', CuentaMovimientosNUM_MOVIMIENTO.Value, []);
  end
  else
    raise EVentaException.Create(E_MSG_VENTA_EXCEPTION);
end;

end.

