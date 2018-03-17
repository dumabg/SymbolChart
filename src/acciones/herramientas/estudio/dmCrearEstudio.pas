unit dmCrearEstudio;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, dmTareas, dmInversorEstudio,
  Controls, IBUpdateSQL, dmBrokerEstudio, kbmMemTable;

type
  TCrearEstudio = class(TDataModule)
    qSesiones: TIBQuery;
    qSesionesFECHA: TDateField;
    qMensajes: TIBQuery;
    qMensajesOR_ESTUDIO: TIntegerField;
    qMensajesMENSAJE: TMemoField;
    qMensajesPOSICION: TIntegerField;
    uMensajes: TIBUpdateSQL;
    Valores: TkbmMemTable;
    ValoresOID_VALOR: TSmallintField;
    ValoresOID_MERCADO: TSmallintField;
    ValoresNOMBRE: TIBStringField;
    ValoresSIMBOLO: TIBStringField;
    ValoresDECIMALES: TSmallintField;
    ValoresMERCADO: TIBStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    canceled: boolean;
    PosicionMensaje: integer;
    OIDEstudioNuevo: integer;
    Broker: TBrokerEstudio;
    procedure OnLog(const msg: string);
    procedure Execute(const Inversor: TInversorEstudio; const nombre: string;
      const Desde, Hasta: TDate; const OIDEstrategia, OIDMoneda, OIDBroker: integer);
    procedure Cancelar;
  public
    { Public declarations }
  end;

  TCrearEstudioTarea = class(TTarea)
  public
    procedure Execute; override;
  end;


implementation

{$R *.dfm}

uses dmBD, UtilDB, UtilDBSC, dmCuentaEstudio;

{ TCrearEstudio }

procedure TCrearEstudio.Cancelar;
begin
  canceled := true;
end;

procedure TCrearEstudio.DataModuleCreate(Sender: TObject);
var OIDGenerator: TOIDGenerator;
begin
  OIDGenerator := TOIDGenerator.Create(scdUsuario, 'ESTUDIO_MENSAJE', 'OR_ESTUDIO');
  try
    PosicionMensaje := OIDGenerator.NextOID;
  finally
    OIDGenerator.Free;
  end;
end;

procedure TCrearEstudio.Execute(const Inversor: TInversorEstudio; const nombre: string;
      const Desde, Hasta: TDate; const OIDEstrategia, OIDMoneda, OIDBroker: integer);
var CuentaEstudio: TCuentaEstudio;
  fecha: TDate;
begin
  canceled := false;
  qSesiones.Close;
  qSesiones.ParamByName('DESDE').AsDate := desde;
  qSesiones.ParamByName('HASTA').AsDate := hasta;
  OpenDataSet(qSesiones);
  qSesiones.Last;
  qSesiones.First;
//  FOnStartingCalculandoSesion(qSesiones.RecordCount + 1);
//  try
//    Inversor := TInversorEstudio.Create(Self, paquetes);
    try
      Inversor.OnLog := OnLog;
      Inversor.CrearEstudio(nombre, OIDMoneda);
      CuentaEstudio := Inversor.CuentaEstudio;
      CuentaEstudio.BeginEstudio;
      Broker := TBrokerEstudio.Create(nil, OIDBroker, CuentaEstudio);
      try
        Inversor.Broker := Broker;
        Inversor.Valores := Valores;
//          Inversor.TipoCotizacion := tcDiaria;
        Inversor.OIDEstrategia := OIDEstrategia;
        if (not canceled) and (not qSesiones.Eof) then begin
          fecha := qSesionesFECHA.Value;
          Inversor.FechaActual := fecha;
          repeat
  //          OnCalculandoSesion(fecha);
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
          if canceled then
            qMensajes.CancelUpdates
          else begin
//            CrearEstudio;
            Inversor.FechaFinal := fecha;
            CuentaEstudio.EndEstudio;
          end;
        end;
      finally
        Broker.Free;
      end;
    finally
//      FreeAndNil(Inversor);
    end;
    if canceled then
      BD.IBTransactionUsuario.RollbackRetaining
    else
      BD.IBTransactionUsuario.CommitRetaining;
{  except
    BD.IBTransactionUsuario.RollbackRetaining;
    if not canceled then
      raise;
  end;}
end;

procedure TCrearEstudio.OnLog(const msg: string);
begin
  qMensajes.Append;
  qMensajesOR_ESTUDIO.Value := OIDEstudioNuevo;
  qMensajesPOSICION.Value := PosicionMensaje;
  qMensajesMENSAJE.Value := msg;
  qMensajes.Post;
  inc(PosicionMensaje);
end;

{ TCrearEstudioTarea }

procedure TCrearEstudioTarea.Execute;
var CrearEstudio: TCrearEstudio;
begin
  CrearEstudio := TCrearEstudio.Create(nil);
  try

  finally
    CrearEstudio.Free;
  end;
end;

end.
