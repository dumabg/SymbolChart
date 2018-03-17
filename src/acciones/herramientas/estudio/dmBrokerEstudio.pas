unit dmBrokerEstudio;

interface

uses
  SysUtils, Classes, dmBroker, DB, Controls,
  IBCustomDataSet, IBQuery, IBUpdateSQL, IBSQL, dmBrokerCartera, kbmMemTable;

type
  TBrokerEstudio = class(TBrokerCartera)
    PosicionesAbiertas: TkbmMemTable;
    PosicionesAbiertasBROKER_ID: TIntegerField;
    PosicionesAbiertasOID_VALOR: TIntegerField;
    PosicionesAbiertasES_LARGO: TBooleanField;
    PosicionesAbiertasCAMBIO: TCurrencyField;
    PosicionesAbiertasSTOP: TCurrencyField;
    PosicionesAbiertasNUM_ACCIONES: TIntegerField;
    PosicionesPendientes: TkbmMemTable;
    PosicionesPendientesBROKER_ID: TIntegerField;
    PosicionesPendientesOID_VALOR: TIntegerField;
    PosicionesPendientesES_LARGO: TBooleanField;
    PosicionesPendientesCAMBIO: TCurrencyField;
    PosicionesPendientesSTOP: TCurrencyField;
    PosicionesPendientesNUM_ACCIONES: TIntegerField;
    qCotizacionMAXIMO: TIBBCDField;
    qCotizacionMINIMO: TIBBCDField;
    procedure DataModuleCreate(Sender: TObject);
  private
    OIDPosiciones: integer;
    FFecha: TDate;
    procedure SetFecha(const Value: TDate);
    function BuscarCotizacion(const OIDValor: integer; const cierre: boolean): boolean;
  protected
    procedure InternalAbrirPosicion(const Orden: TOrden;
      var FechaHora: TDateTime; var BrokerID: integer; var mensaje: string); override;
    function GetIDValorBroker(const OIDValor: integer): string;
    procedure EntrarPosicionesPendientes;
  public
    procedure AntesCerrarSesion;
    procedure CerrarSesion;
    procedure CambiarStop(const OIDValor, OrdenID: integer;
      const largo: boolean; const NumAcciones: cardinal; const stop: currency); override;
    function GetCierre(const OIDValor: integer): currency; override;
    property Fecha: TDate read FFecha write SetFecha;
  end;


implementation

uses dmBD, dmCuentaMovimientosBase;

{$R *.dfm}

const
  A_MERCADO: integer = -1;


{ TDataModule2 }

procedure TBrokerEstudio.AntesCerrarSesion;
var largo: boolean;
  stop, comision, maximo, minimo: currency;
  BrokerOID, OIDValor: integer;
begin
  EntrarPosicionesPendientes;
  // Miramos las posiciones abiertas si ha saltado algun stop
  PosicionesAbiertas.First;
  while not PosicionesAbiertas.Eof do begin
    stop := PosicionesAbiertasSTOP.Value;
    if stop <> 0 then begin
      OIDValor := PosicionesAbiertasOID_VALOR.Value;
      largo := PosicionesAbiertasES_LARGO.Value;
      if BuscarCotizacion(OIDValor, true) then begin
        minimo := qCotizacionMINIMO.Value;
        maximo := qCotizacionMAXIMO.Value;
        if (maximo > 0) and (minimo > 0) and (
          ((largo) and (minimo < stop)) or ((not largo) and (maximo > stop))) then begin
          comision := GetComision(OIDValor, PosicionesAbiertasNUM_ACCIONES.Value,
            stop, largo, false);
          BrokerOID := PosicionesAbiertasBROKER_ID.Value;
          inc(OIDPosiciones);
          // Si estamos en posiciones largas y el stop está por encima del máximo,
          // significa que el programa está corto y nosotros aún en largo, por lo
          // que al poner un stop para cortos a mercado, salta rápidamente la venta.
          // Obviamente, el valor del stop no será al que hemos vendido, ya que
          // en esa sesión no se ha estado nunca a ese valor, por lo que ponemos
          // el escenario más desfavorable, que se haya vendido al mínimo.
          if largo then begin
            if maximo < stop then
              stop := minimo;
          end
          else begin // caso de corto
            if minimo > stop then
              stop := maximo;
          end;
          PosicionCerrada(Fecha, BrokerOID, stop, comision, SIN_MONEDA_VALOR);
          PosicionesAbiertas.Delete;
        end
        else
          PosicionesAbiertas.Next;
      end
      else
        PosicionesAbiertas.Next;
    end
    else
      PosicionesAbiertas.Next;
  end;
end;

function TBrokerEstudio.BuscarCotizacion(const OIDValor: integer; const cierre: boolean): boolean;
begin
  qCotizacion.Close;
  qCotizacion.ParamByName('OID_VALOR').AsInteger := OIDValor;
  qCotizacion.ParamByName('FECHA').AsDate := FFecha;
  qCotizacion.Open;
  if not cierre then
    qCotizacion.Last;
  result := not qCotizacion.IsEmpty;
end;

procedure TBrokerEstudio.CambiarStop(const OIDValor, OrdenID: integer;
  const largo: boolean; const NumAcciones: cardinal; const stop: currency);
begin
  if PosicionesAbiertas.Locate('BROKER_ID', OrdenID, []) then begin
    PosicionesAbiertas.Edit;
    PosicionesAbiertasSTOP.Value := stop;
    PosicionesAbiertas.Post;
  end
  else
    raise Exception.Create('No se ha podido encontrar la orden ' + IntToStr(OrdenID));
end;

procedure TBrokerEstudio.CerrarSesion;
var largo: boolean;
  cambio, stop, comision: currency;
  BrokerOID, OIDValor: integer;
  cerrada: boolean;
begin
  EntrarPosicionesPendientes;
  // Miramos las posiciones abiertas si ha saltado el stop, pero solo con el cambio
  // ya que AntesCerrarSesion ya examina los posibles barridos con máximo y mínimos.
  PosicionesAbiertas.First;
  while not PosicionesAbiertas.Eof do begin
    cerrada := PosicionesAbiertasSTOP.IsNull;
    stop := PosicionesAbiertasSTOP.Value;
    if (stop <> 0) or (cerrada) then begin
      OIDValor := PosicionesAbiertasOID_VALOR.Value;
      largo := PosicionesAbiertasES_LARGO.Value;
      if (BuscarCotizacion(OIDValor, true)) then begin
        cambio := qCotizacionCIERRE.Value;
        if (cerrada) or ((largo) and (cambio < stop)) or ((not largo) and (cambio > stop)) then begin
          comision := GetComision(OIDValor, PosicionesAbiertasNUM_ACCIONES.Value,
            cambio, largo, false);
          BrokerOID := PosicionesAbiertasBROKER_ID.Value;
          inc(OIDPosiciones);
          PosicionCerrada(Fecha, BrokerOID, cambio, comision, SIN_MONEDA_VALOR);
          PosicionesAbiertas.Delete;
          end
        else
          PosicionesAbiertas.Next;
      end
      else
        PosicionesAbiertas.Next;
    end
    else
      PosicionesAbiertas.Next;
  end;
end;

procedure TBrokerEstudio.DataModuleCreate(Sender: TObject);
begin
  inherited;
  OIDPosiciones := 0;
  PosicionesAbiertas.Open;
  PosicionesPendientes.Open;
end;

procedure TBrokerEstudio.EntrarPosicionesPendientes;
var largo: boolean;
  cambio, comision, maximo, minimo: currency;
  BrokerOID, OIDValor: integer;
  numAcciones: cardinal;
begin
  PosicionesPendientes.First;
  while not PosicionesPendientes.Eof do begin
    cambio := PosicionesPendientesCAMBIO.Value;
    OIDValor := PosicionesPendientesOID_VALOR.Value;
    if (BuscarCotizacion(OIDValor, true)) then begin
      maximo := qCotizacionMAXIMO.Value;
      if maximo = 0 then
        maximo := cambio;
      minimo := qCotizacionMINIMO.Value;
      if minimo = 0 then
        minimo := cambio;
      if (maximo >= cambio) and (minimo <= cambio) then begin
        numAcciones := PosicionesPendientesNUM_ACCIONES.Value;
        largo := PosicionesPendientesES_LARGO.Value;
        BrokerOID := PosicionesPendientesBROKER_ID.Value;
        comision := GetComision(OIDValor, numAcciones, cambio, largo, true);
        PosicionesAbiertas.Append;
        PosicionesAbiertasBROKER_ID.Value := BrokerOID;
        PosicionesAbiertasOID_VALOR.Value := OIDValor;
        PosicionesAbiertasES_LARGO.Value := largo;
        if PosicionesPendientesSTOP.IsNull then
          PosicionesAbiertasSTOP.Clear
        else
          PosicionesAbiertasSTOP.Value := PosicionesPendientesSTOP.Value;
        PosicionesAbiertasCAMBIO.Value := cambio;
        PosicionesAbiertasNUM_ACCIONES.Value := numAcciones;
        PosicionesAbiertas.Post;
        PosicionAbierta(Fecha, BrokerOID, cambio, comision, SIN_MONEDA_VALOR);
      end;
    end;
    PosicionesPendientes.Next;
  end;
  PosicionesPendientes.Close;
  PosicionesPendientes.Open;
end;

function TBrokerEstudio.GetCierre(const OIDValor: integer): currency;
begin
  BuscarCotizacion(OIDValor, false);
  result := qCotizacionCIERRE.Value;
end;

function TBrokerEstudio.GetIDValorBroker(const OIDValor: integer): string;
begin
  result := IntToStr(OIDValor);
end;

procedure TBrokerEstudio.InternalAbrirPosicion(const Orden: TOrden;
  var FechaHora: TDateTime; var BrokerID: integer; var mensaje: string);
var OIDValor: integer;
  maximo, minimo: currency;
begin
  inherited InternalAbrirPosicion(Orden, FechaHora, BrokerID, mensaje);
  FechaHora := Fecha;

  OIDValor := Orden.OIDValor;
  inc(OIDPosiciones);
  PosicionesPendientes.Append;
  PosicionesPendientesBROKER_ID.Value := BrokerID;
  PosicionesPendientesOID_VALOR.Value := OIDValor;
  PosicionesPendientesES_LARGO.Value := Orden.Largo;
  if Orden is TOrdenMercado then begin
    BuscarCotizacion(OIDValor, true);
    maximo := qCotizacionMAXIMO.Value;
    minimo := qCotizacionMINIMO.Value;
    if (maximo = 0) or (minimo = 0) then
      PosicionesPendientesCAMBIO.Value := qCotizacionCIERRE.Value
    else
      PosicionesPendientesCAMBIO.Value := (maximo + minimo) / 2;
  end
  else begin
    if Orden is TOrdenLimitada then
      PosicionesPendientesCAMBIO.Value := TOrdenLimitada(Orden).Cambio;
  end;

  if Orden.HasStop then
    PosicionesPendientesSTOP.Value := Orden.Stop;
  PosicionesPendientesNUM_ACCIONES.Value := Orden.NumAcciones;
  PosicionesPendientes.Post;
end;

procedure TBrokerEstudio.SetFecha(const Value: TDate);
begin
  FFecha := Value;
  qCotizacion.Close;
end;

initialization
  RegisterClass(TBrokerEstudio);

end.
