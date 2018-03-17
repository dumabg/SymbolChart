unit dmEstudio;

interface

uses
  SysUtils, Classes, UtilThread, IBSQL, Controls, Tipos, DB, IBCustomDataSet,
  IBQuery, dmTareas, kbmMemTable, dmBD, dmThreadDataModule;

type
  TEstudioNotify = procedure (const OID: integer) of object;

  TEstudioParams = record
    Capital: integer;
    Descripcion: string;
    Desde: TDate;
    Hasta: TDate;
    OIDEstrategia: Integer;
    Paquetes: integer;
    Usa100: boolean;
    Grupo: string;
    Nombre: string;
    OIDMoneda: integer;
    OIDBroker: Integer;
    OnPerCent: TOnPerCentNotify;
    OnEstudioCreated: TEstudioNotify;
    OnEstudioCanceled: TEstudioNotify;
  end;

  PTEstudioParams = ^TEstudioParams;

  TEstudioThread = class;

  TDataEstudio = class(TThreadDataModule)
    iEstudio: TIBSQL;
    qSesiones: TIBQuery;
    qSesionesFECHA: TDateField;
    Valores: TkbmMemTable;
    ValoresOID_VALOR: TIntegerField;
    ValoresOID_MERCADO: TIntegerField;
    dCuenta: TIBSQL;
  private
    FOIDEstudio: Integer;
    canceled: boolean;
    procedure LoadSesiones(const desde, hasta: TDate);
    procedure LoadValores(const PValores: PArrayInteger);
    procedure CrearEstudio(const PParams: PTEstudioParams; const OIDCuenta: integer);
    procedure CalcularEstudio(const PParams: PTEstudioParams; const PValores: PArrayInteger);
    procedure OnLog(const msg: string);
  protected
    Tarea: TEstudioThread;
    procedure Crear(const OIDEstudio: integer; const PParams: PTEstudioParams; const PValores: PArrayInteger);
  end;

  TEstudioThread = class(TTarea)
  private
    DataEstudio: TDataEstudio;
    PEstudioParams: PTEstudioParams;
    POIDValores: PArrayInteger;
    TipoBD: TBDDatos;
    FOIDEstudio: integer;
  protected
    procedure InitializeResources; override;
    procedure FreeResources; override;
    procedure InternalExecute; override;
    procedure InternalCancel; override;
  public
    property MaxPosition;
    property OIDEstudio: integer read FOIDEstudio write FOIDEstudio;
  end;

  TEstudio = class
  private
    thread: TEstudioThread;
    params: TEstudioParams;
    OIDValores: TArrayInteger;
    FOnEstudioCanceled: TEstudioNotify;
    FOnEstudioCreated: TEstudioNotify;
    procedure InitializeOIDValores;
    procedure OnTerminate(Sender: TObject);
    property OnEstudioCreated: TEstudioNotify read FOnEstudioCreated write FOnEstudioCreated;
    property OnEstudioCanceled: TEstudioNotify read FOnEstudioCanceled write FOnEstudioCanceled;
  public
    procedure Run(const OIDEstudio: integer; PParams: PTEstudioParams);
    procedure Cancel;
  end;


implementation

uses UtilDB, dmData, UtilDBSC, dmInversorEstudio,
  dmCuentaEstudio, dmBrokerEstudio, dmDataComun;

{$R *.dfm}

resourcestring
  ESTUDIO_TITLE = 'Estudio';

{ TEstudio }

procedure TEstudio.Cancel;
begin
  if thread <> nil then  
    thread.Cancel;
end;

procedure TEstudio.InitializeOIDValores;
var inspect: TInspectDataSet;
  Valores: TDataSet;
  FieldOID_VALOR: TIntegerField;
  i: integer;
begin
  Valores := Data.Valores;
  FieldOID_VALOR := Data.ValoresOID_VALOR;
  SetLength(OIDValores, Valores.RecordCount);
  inspect := StartInspectDataSet(Valores);
  try
    i := 0;
    Valores.First;
    while not Valores.Eof do begin
      OIDValores[i] := FieldOID_VALOR.Value;
      Valores.Next;
      inc(i);
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;

procedure TEstudio.OnTerminate(Sender: TObject);
begin
  if thread.Canceled then
    OnEstudioCanceled(thread.OIDEstudio)
  else
    OnEstudioCreated(thread.OIDEstudio);
end;

procedure TEstudio.Run(const OIDEstudio: integer; PParams: PTEstudioParams);
var idTarea: integer;
begin
  params := PParams^;
  FOnEstudioCanceled := params.OnEstudioCanceled;
  FOnEstudioCreated := params.OnEstudioCreated;
  InitializeOIDValores;
  thread := TEstudioThread.Create;
  thread.FreeOnTerminate := true;
  thread.OnTerminate := OnTerminate;
  thread.OIDEstudio := OIDEstudio;
  if Data.TipoCotizacion = tcDiaria then
    thread.TipoBD := bddDiaria
  else
    thread.TipoBD := bddSemanal;
  thread.PEstudioParams := @params;
  thread.POIDValores := @OIDValores;
  idTarea := Tareas.EjecutarTarea(thread, ESTUDIO_TITLE, PParams^.Nombre);
  Tareas.GetTarea(idTarea).OnPerCent := PParams^.OnPerCent;
end;

{ TEstudioThread }

procedure TEstudioThread.FreeResources;
begin
  DataEstudio.Free;
  inherited;
end;

procedure TEstudioThread.InitializeResources;
begin
  inherited;
  BD.BDDatos := TipoBD;
  DataEstudio := TDataEstudio.Create(nil);
end;

procedure TEstudioThread.InternalCancel;
begin
  inherited;
  DataEstudio.canceled := true;
end;

procedure TEstudioThread.InternalExecute;
begin
  DataEstudio.Tarea := Self;
  DataEstudio.Crear(FOIDEstudio, PEstudioParams, POIDValores);
end;

{ TDataEstudio }

procedure TDataEstudio.CalcularEstudio(const PParams: PTEstudioParams;
  const PValores: PArrayInteger);
var Inversor: TInversorEstudio;
  CuentaEstudio: TCuentaEstudio;
  Broker: TBrokerEstudio;
  fecha: TDate;
  i: integer;
begin
  LoadSesiones(PParams^.Desde, PParams^.Hasta);
  LoadValores(PValores);
  Tarea.MaxPosition := qSesiones.RecordCount;
  Inversor := TInversorEstudio.Create(Self, PParams^.Paquetes);
  try
    Inversor.OnLog := OnLog;
    Inversor.CrearEstudio(PParams^.Nombre, PParams^.OIDMoneda);
    CuentaEstudio := Inversor.CuentaEstudio;
    CrearEstudio(PParams, CuentaEstudio.OIDCuenta);
    CuentaEstudio.BeginEstudio;
    Broker := TBrokerEstudio.Create(nil, PParams^.OIDBroker, CuentaEstudio);
    try
      Inversor.Broker := Broker;
      Inversor.Valores := Valores;
//          Inversor.AnadirCapital(Capital);
      Inversor.OIDEstrategia := PParams^.OIDEstrategia;
      i := 0;
      if (not canceled) and (not qSesiones.Eof) then begin
        fecha := qSesionesFECHA.Value;
        Inversor.FechaActual := fecha;
        repeat
          Tarea.DoPerCentPos(i);
          inc(i);
          Inversor.BuscarPosiciones(true, true);
          qSesiones.Next;
          if not qSesiones.Eof then begin
            fecha := qSesionesFECHA.Value;
            Inversor.FechaActual := fecha;
            Inversor.PosicionarTodos;
            Broker.AntesCerrarSesion;
            Inversor.BuscarPosiciones(false, true);
            Inversor.PosicionarTodos;
            Broker.CerrarSesion;
          end;
//            Inversor.CambiarStops(tcDiaria);
        until (canceled) or (qSesiones.Eof);
        Inversor.FechaFinal := fecha;
      end;
      CuentaEstudio.EndEstudio;
      if canceled then begin
        dCuenta.Params[0].AsInteger := CuentaEstudio.OIDCuenta;
        ExecQuery(dCuenta, true);
      end;
    finally
      Broker.Free;
    end;
  finally
    FreeAndNil(Inversor);
  end;
end;

procedure TDataEstudio.Crear(const OIDEstudio: integer; const PParams: PTEstudioParams; const PValores: PArrayInteger);
begin
  FOIDEstudio := OIDEstudio;
  CalcularEstudio(PParams, PValores);
end;

procedure TDataEstudio.CrearEstudio(const PParams: PTEstudioParams; const OIDCuenta: integer);
begin
  iEstudio.ParamByName('OID_ESTUDIO').AsInteger := FOIDEstudio;
  iEstudio.ParamByName('CAPITAL').AsInteger := PParams^.Capital;
  iEstudio.ParamByName('DESCRIPCION').AsString := PParams^.Descripcion;
  iEstudio.ParamByName('DESDE').AsDate := PParams^.Desde;
  iEstudio.ParamByName('HASTA').AsDate := PParams^.Hasta;
  iEstudio.ParamByName('OR_CUENTA').AsInteger := OIDCuenta;
  iEstudio.ParamByName('OR_ESTRATEGIA').AsInteger := PParams^.OIDEstrategia;
  iEstudio.ParamByName('PAQUETES').AsInteger := PParams^.Paquetes;
  if PParams^.Usa100 then
    iEstudio.ParamByName('USA100').AsString := 'S'
  else
    iEstudio.ParamByName('USA100').AsString := 'N';
  iEstudio.ParamByName('GRUPO').AsString := PParams^.Grupo;
  iEstudio.ParamByName('NOMBRE').AsString := PParams^.Nombre;
  ExecQuery(iEstudio, false);
end;

procedure TDataEstudio.LoadSesiones(const desde, hasta: TDate);
begin
  qSesiones.ParamByName('DESDE').AsDate := desde;
  qSesiones.ParamByName('HASTA').AsDate := hasta;
  OpenDataSet(qSesiones);
  qSesiones.Last;
  qSesiones.First;
end;

procedure TDataEstudio.LoadValores(const PValores: PArrayInteger);
var i, num, OIDValor: Integer;
begin
  Valores.Open;
  num := length(PValores^) - 1;
  for i := 0 to num do begin
    Valores.Append;
    OIDValor := PValores^[i];
    ValoresOID_VALOR.Value := OIDValor;
    ValoresOID_MERCADO.Value := DataComun.FindValor(OIDValor)^.Mercado^.OIDMercado;
    Valores.Post;
  end;
end;

procedure TDataEstudio.OnLog(const msg: string);
begin

end;

end.
