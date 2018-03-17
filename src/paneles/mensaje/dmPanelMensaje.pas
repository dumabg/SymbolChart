unit dmPanelMensaje;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, Tipos, mensajesPanel, flags,
  dmThreadDataModule, dmDataModuleBase;

type
  TMensajeField = record
    iFieldOR: integer;
    iFieldParams: integer;
    FieldOR: TIntegerField;
//    FieldParams: TMemoField;
    FieldParams: TStringField;
  end;

  TMensajeFields = array of TMensajeField;

  TPanelMensaje = class(TThreadDataModule)
    CotizacionMensajes: TIBQuery;
    TipoMensajes: TIBQuery;
    TipoMensajesOID_TIPO_MENSAJE: TSmallintField;
    TipoMensajesDESCRIPCION: TIBStringField;
    TipoMensajesPOSICION: TSmallintField;
    TipoMensajesCAMPO: TIBStringField;
    qMensaje: TIBQuery;
    qMensajeES: TMemoField;
    procedure CotizacionMensajesBeforeOpen(DataSet: TDataSet);
  private
    FOnMensajeCambiado: TNotificacion;
    FMensajes: TMensajes;
    FMensajeFields: TMensajeFields;
    FOIDBetas: integer;
    FOIDPrincipal: integer;
    procedure MapFields;
    procedure InicializarCotizacionMensajes;
    function GetMensajes: TMensajes;
    procedure SetOnMensajeCambiado(const Value: TNotificacion);
    function GetFlagsMensajes: TFlags;
    procedure OnStructureMessageChanged;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure OnCotizacionCambiada;
    property FlagsMensajes: TFlags read GetFlagsMensajes;
    property Mensajes: TMensajes read GetMensajes;
    property OnMensajeCambiado: TNotificacion read FOnMensajeCambiado write SetOnMensajeCambiado;
    property OIDBetas: integer read FOIDBetas;
    property OIDPrincipal: integer read FOIDPrincipal;
  end;


implementation

uses dmData, UtilDB, dmConfiguracion, dmBD, dmConfigMensajes, BusCommunication,
  dmActualizarDatos, IBDatabase;

{$R *.dfm}

procedure TPanelMensaje.CotizacionMensajesBeforeOpen(DataSet: TDataSet);
begin
  CotizacionMensajes.Params[0].AsInteger := Data.CotizacionOID_COTIZACION.Value;
end;

constructor TPanelMensaje.Create(AOwner: TComponent);
begin
  inherited;
  InicializarCotizacionMensajes;
  MapFields;
  Bus.RegisterEvent(MessageStructureMessageChanged, OnStructureMessageChanged);
  Bus.RegisterEvent(MessageTipoCotizacionCambiada, OnStructureMessageChanged);
end;

destructor TPanelMensaje.Destroy;
begin
  Bus.UnregisterEvent(MessageStructureMessageChanged, OnStructureMessageChanged);
  Bus.UnregisterEvent(MessageTipoCotizacionCambiada, OnStructureMessageChanged);
  inherited;
end;

function TPanelMensaje.GetFlagsMensajes: TFlags;
begin
  result := TFlags.Create;
  result.Flags := CotizacionMensajes.FieldByName('FLAGS').AsInteger;
end;

function TPanelMensaje.GetMensajes: TMensajes;
var i: integer;
  cad: string;
  field: TField;
begin
//
//  if Data.TipoCotizacion = tcDiaria then begin
//    for i := Low(FMensajes) to High(FMensajes) do begin
//      FMensajes[i].IsNull := true;
//      FMensajes[i].Mensaje := '';
//    end;
//    FMensajes[Low(FMensajes)].IsNull := false;
//    FMensajes[Low(FMensajes)].Mensaje := '<b>MENSAJES E INDICADORES NO DISPONIBLES EN DATOS DIARIOS.</b>';
//  end
//  else begin
//
    for i := Low(FMensajes) to High(FMensajes) do begin
      field := FMensajeFields[i].FieldOR;
      FMensajes[i].IsNull := field.IsNull;
      if FMensajes[i].IsNull then begin
        FMensajes[i].mensaje := '';
      end
      else begin
        qMensaje.Close;
        qMensaje.Params[0].AsInteger := field.Value;
        OpenDataSet(qMensaje);
        cad := '';
        while not qMensaje.Eof do begin
          cad := cad + qMensajeES.Value + '. ';
          qMensaje.Next;
        end;
        FMensajes[i].mensaje := cad;
        FMensajes[i].Params := FMensajeFields[i].FieldParams.Value;
      end;
    end;
//  end;
  result := FMensajes;
end;

procedure TPanelMensaje.InicializarCotizacionMensajes;
var nombre, titulo: string;
  num, i: integer;
  database: TIBDatabase;
  transaction: TIBTransaction;
begin
  //La longitud de las columnas de la tabla cotizacion_mensaje pueden variar.
  //Cuando se actualizan los datos puede que haya uno que su longitud
  //sea mayor que la longitud de la columna, por lo que la actualización varía
  //la longitud de la bd y vuelve a importar. Cuando varía la longitud, tira el
  //evento MessageStructureMessageChanged. Como la estructura ha variado, se debe
  //reabrir la base de datos para que CotizacionMensajes reciba las longitudes
  //correctas de las columnas. Por esto CotizacionMensajes tiene su propia conexión
  //a la base de datos, para poder reabrirla en caso necesario. Por otra parte
  //cuando se actualizan los datos, CotizacionMensajes no los ve, ya que tiene
  //otra conexión con otra transacción abierta, por lo que no ve los cambios de
  //la base de datos. Para que vea los cambios, debe hacer un Commit de su transacción.
  database := BD.GetNewDatabase(Self, scdDatos, Data.BDDatos);
  transaction := TIBTransaction.Create(Self);
  database.DefaultTransaction := transaction;
  CotizacionMensajes.Database := database;
  OpenDataSet(CotizacionMensajes);
  OpenDataSet(TipoMensajes);
  TipoMensajes.Last;
  num := TipoMensajes.RecordCount;
  SetLength(FMensajes, num);
  SetLength(FMensajeFields, num);

  //El primer mensaje es el principal
  FMensajes[0].Titulo := '';
  FMensajes[0].visible := true;
  FMensajes[0].TipoOID := TipoMensajesOID_TIPO_MENSAJE.Value;
  FMensajeFields[0].iFieldOR :=
      CotizacionMensajes.FieldByName('OR_PRINCIPAL').FieldNo - 1;
  FMensajeFields[0].iFieldParams :=
      CotizacionMensajes.FieldByName('PARAMS_PRINCIPAL').FieldNo - 1;

  i := 1;
  TipoMensajes.Prior;
  while not TipoMensajes.Bof do begin
    nombre := TipoMensajesCAMPO.Value;
    FMensajeFields[i].iFieldOR :=
      CotizacionMensajes.FieldByName('OR_' + nombre).FieldNo - 1;
    FMensajeFields[i].iFieldParams :=
      CotizacionMensajes.FieldByName('PARAMS_' + nombre).FieldNo - 1;
    titulo := TipoMensajesDESCRIPCION.Value;

    FMensajes[i].Titulo := titulo;
    //En Configuracion.Mensajes se crean los mensajes igual que en TipoMensajes
    //pero sin el principal, por lo que será i - 1
    FMensajes[i].visible := Configuracion.Mensajes.Visible[i - 1];
    FMensajes[i].TipoOID := TipoMensajesOID_TIPO_MENSAJE.Value;

    TipoMensajes.Prior;
    inc(i);
  end;

  if TipoMensajes.Locate('CAMPO', 'BETAS', []) then
    FOIDBetas := TipoMensajesOID_TIPO_MENSAJE.Value
  else
    raise Exception.Create('No se ha encontrado el campo de las Betas');

  if TipoMensajes.Locate('CAMPO', 'PRINCIPAL', []) then
    FOIDPrincipal := TipoMensajesOID_TIPO_MENSAJE.Value
  else
    raise Exception.Create('No se ha encontrado el campo principal');
end;

procedure TPanelMensaje.MapFields;
var i: integer;
begin
  for i := Low(FMensajeFields) to High(FMensajeFields) do begin
    FMensajeFields[i].FieldOR := CotizacionMensajes.Fields[FMensajeFields[i].iFieldOR] as TIntegerField;
    FMensajeFields[i].FieldParams := CotizacionMensajes.Fields[FMensajeFields[i].iFieldParams] as TStringField;
  end;
end;

procedure TPanelMensaje.OnCotizacionCambiada;
begin
  //La longitud de las columnas de la tabla cotizacion_mensaje pueden variar.
  //Cuando se actualizan los datos puede que haya uno que su longitud
  //sea mayor que la longitud de la columna, por lo que la actualización varía
  //la longitud de la bd y vuelve a importar. Cuando varía la longitud, tira el
  //evento MessageStructureMessageChanged. Como la estructura ha variado, se debe
  //reabrir la base de datos para que CotizacionMensajes reciba las longitudes
  //correctas de las columnas. Por esto CotizacionMensajes tiene su propia conexión
  //a la base de datos, para poder reabrirla en caso necesario. Por otra parte
  //cuando se actualizan los datos, CotizacionMensajes no los ve, ya que tiene
  //otra conexión con otra transacción abierta, por lo que no ve los cambios de
  //la base de datos. Para que vea los cambios, debe hacer un Commit de su transacción.
  CotizacionMensajes.Transaction.Commit;
  OpenDataSet(CotizacionMensajes);
  MapFields;
  if Assigned(FOnMensajeCambiado) then
    FOnMensajeCambiado;
end;

procedure TPanelMensaje.OnStructureMessageChanged;
begin
  //La longitud de las columnas de la tabla cotizacion_mensaje pueden variar.
  //Cuando se actualizan los datos puede que haya uno que su longitud
  //sea mayor que la longitud de la columna, por lo que la actualización varía
  //la longitud de la bd y vuelve a importar. Cuando varía la longitud, tira el
  //evento MessageStructureMessageChanged. Como la estructura ha variado, se debe
  //reabrir la base de datos para que CotizacionMensajes reciba las longitudes
  //correctas de las columnas. Por esto CotizacionMensajes tiene su propia conexión
  //a la base de datos, para poder reabrirla en caso necesario. Por otra parte
  //cuando se actualizan los datos, CotizacionMensajes no los ve, ya que tiene
  //otra conexión con otra transacción abierta, por lo que no ve las actualizaciones de
  //la base de datos. Para que vea los cambios, debe hacer un Commit de su transacción.
  CotizacionMensajes.Close;
  CotizacionMensajes.UnPrepare;
  CotizacionMensajes.Database.DefaultTransaction.Free;
  CotizacionMensajes.Database.Free;
  InicializarCotizacionMensajes;
end;

procedure TPanelMensaje.SetOnMensajeCambiado(const Value: TNotificacion);
begin
  FOnMensajeCambiado := Value;
end;

end.
