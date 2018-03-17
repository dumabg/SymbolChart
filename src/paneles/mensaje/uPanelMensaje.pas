unit uPanelMensaje;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uPanelNotificaciones, Menus, ActnList, dmLector,
  ExtCtrls, JvExExtCtrls, JvExtComponent, JvPanel,
  Htmlview, imagesMensajesPanel, dmPanelMensaje, ImgList,
  TB2Item, SpTBXItem, TB2Toolbar, TB2Dock, mensajesPanel;

const
  WM_CHANGE_SIZE_TOOLWINDOW_MENSAJE = WM_USER + 1;

type
  TProximaVoz = (pvNo, pvSiguiente, pvAnterior);

  TfrPanelMensaje = class(TfrPanelNotificaciones)
    ActionListVoz: TActionList;
    VozReproducir: TAction;
    VozPausa: TAction;
    VozParar: TAction;
    VozSiguiente: TAction;
    VozAnterior: TAction;
    Mensajes: TImagesMensajesPanel;
    JvPanel1: TJvPanel;
    iLeerMensaje: TImage;
    pVoz: TPanel;
    ToolbarVoz: TSpTBXToolbar;
    TBXItem53: TSpTBXItem;
    TBXItem138: TSpTBXItem;
    TBXItem139: TSpTBXItem;
    TBXItem140: TSpTBXItem;
    TBXItem141: TSpTBXItem;
    ActionList: TActionList;
    ImageList: TImageList;
    MensajesConfigurar: TAction;
    MensajeMismaLinea: TAction;
    MensajesSeparacion: TAction;
    MensajeAgrandar: TAction;
    AyudaMensajes: TAction;
    ActualizarArrastrar: TAction;
    ToolWindowMensaje: TSpTBXToolWindow;
    PopupMensajes: TSpTBXPopupMenu;
    TBXItem82: TSpTBXItem;
    TBXSeparatorItem23: TSpTBXSeparatorItem;
    TBXItem83: TSpTBXItem;
    TBXItem84: TSpTBXItem;
    TBXItem85: TSpTBXItem;
    TBXSeparatorItem25: TSpTBXSeparatorItem;
    TBXItemMensajeConfigurar: TSpTBXItem;
    TBXSeparatorItem26: TSpTBXSeparatorItem;
    TBXItem88: TSpTBXItem;
    procedure VozReproducirExecute(Sender: TObject);
    procedure VozPausaExecute(Sender: TObject);
    procedure VozPararExecute(Sender: TObject);
    procedure VozSiguienteExecute(Sender: TObject);
    procedure VozAnteriorExecute(Sender: TObject);
    procedure MensajesConfigurarExecute(Sender: TObject);
    procedure MensajeMismaLineaExecute(Sender: TObject);
    procedure MensajeMismaLineaUpdate(Sender: TObject);
    procedure MensajesSeparacionExecute(Sender: TObject);
    procedure MensajesSeparacionUpdate(Sender: TObject);
    procedure MensajeAgrandarExecute(Sender: TObject);
    procedure MensajesMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MensajesMouseDouble(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AyudaMensajesExecute(Sender: TObject);
    procedure ActualizarArrastrarExecute(Sender: TObject);
    procedure ActualizarArrastrarUpdate(Sender: TObject);
    function MensajesGetBetaIndex(const OIDBeta: string): string;
    procedure MensajesHotSpotClick(Sender: TObject; const SRC: string;
      var Handled: Boolean);
    procedure iLeerMensajeClick(Sender: TObject);
    procedure ToolWindowMensajeCloseQuery(Sender: TObject;
      var CanClose: Boolean);
    procedure ToolWindowMensajeDockChanging(Sender: TObject; Floating: Boolean;
      DockingTo: TTBDock);
  private
    lastToolWindowMensajeHeight: integer;
    lastToolWindowMensajeWidth: integer;
    ProximaVoz: TProximaVoz;
    Lector: TLector;
    iVoz: integer;
    DataMensaje: TPanelMensaje;
    ToolWindowMensajeDoubleClick: boolean;
    ActivarActualizarArrastrar: boolean;
    procedure OnChangeSizeToolWindowMensaje(var message: TMessage); message WM_CHANGE_SIZE_TOOLWINDOW_MENSAJE;
    procedure OnHablaFinalizada;
    procedure OnMensajeCambiado;
    procedure ActivarControlesVoz(const reproducir: boolean);
    procedure AgrandarRapidamente;
    procedure OnConfiguracionMensajeCambiado;
  protected
    procedure OnCotizacionCambiada; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetNombre: string; override;
  end;

implementation

uses dmLectorImages, dmData, fmConfiguracion, Web,
  dmConfiguracion, ServerURLs, uPanel, UtilDock, dmDataComun, BusCommunication,
  frModuloMensajes;

{$R *.dfm}

resourcestring
  MENSAJE_AGRANDAR = 'Agrandar rápidamente                                (Doble clic)';
  MENSAJE_REDUCIR = 'Reducir rápidamente                                (Doble clic)';
  AVISO_LEGAL = 'Aviso legal';
  NOMBRE = 'Mensajes';

{ TfrPanelCotizacionCambiada1 }

procedure TfrPanelMensaje.ActivarControlesVoz(const reproducir: boolean);
begin
  VozReproducir.Enabled := not reproducir;
  VozPausa.Enabled := reproducir;
  VozParar.Enabled := reproducir;
  VozSiguiente.Enabled := reproducir;
  VozAnterior.Enabled := reproducir;
end;

procedure TfrPanelMensaje.ActualizarArrastrarExecute(Sender: TObject);
begin
  ActivarActualizarArrastrar := not ActivarActualizarArrastrar;
end;

procedure TfrPanelMensaje.ActualizarArrastrarUpdate(Sender: TObject);
begin
  ActualizarArrastrar.Checked := ActivarActualizarArrastrar;
end;

procedure TfrPanelMensaje.AgrandarRapidamente;
begin
  if ToolWindowMensaje.Floating then begin
    MensajeAgrandar.Caption := MENSAJE_AGRANDAR;
    ToolWindowMensaje.CurrentDock := ToolWindowMensaje.LastDock;
  end
  else begin
    ToolWindowMensaje.Floating := true;
    MensajeAgrandar.Caption := MENSAJE_REDUCIR;
  end;
end;

procedure TfrPanelMensaje.AyudaMensajesExecute(Sender: TObject);
begin
  AbrirURL(Configuracion.Sistema.URLServidor + URL_SIGNIFICACION_MENSAJES);
end;

constructor TfrPanelMensaje.Create(AOwner: TComponent);
var defaultDock: TDefaultDock;
begin
  if LectorImages = nil then
    LectorImages := TLectorImages.Create(Application);
  defaultDock.Position := dpArriba;
  defaultDock.Pos := 600;
  defaultDock.Row := 0;
  inherited CreatePanelNotificaciones(AOwner, defaultDock, [pnCotizacionCambiada]);
  DataMensaje := TPanelMensaje.Create(Self);
  DataMensaje.OnMensajeCambiado := OnMensajeCambiado;
  OnMensajeCambiado;
  OnConfiguracionMensajeCambiado;
  Bus.RegisterEvent(MessageConfiguracionMensaje, OnConfiguracionMensajeCambiado);
end;

destructor TfrPanelMensaje.Destroy;
begin
  Bus.UnregisterEvent(MessageConfiguracionMensaje, OnConfiguracionMensajeCambiado);
  inherited;
end;

class function TfrPanelMensaje.GetNombre: string;
begin
  result := NOMBRE;
end;

procedure TfrPanelMensaje.iLeerMensajeClick(Sender: TObject);
begin
  pVoz.Visible := not pVoz.Visible;
end;

procedure TfrPanelMensaje.MensajeAgrandarExecute(Sender: TObject);
begin
  AgrandarRapidamente;
end;

procedure TfrPanelMensaje.MensajeMismaLineaExecute(Sender: TObject);
begin
  Mensajes.TitleSeparation := not Mensajes.TitleSeparation;
end;

procedure TfrPanelMensaje.MensajeMismaLineaUpdate(Sender: TObject);
begin
  MensajeMismaLinea.Checked := not Mensajes.TitleSeparation;
end;

procedure TfrPanelMensaje.MensajesConfigurarExecute(Sender: TObject);
begin
  AbrirConfiguracion(TfModuloMensajes);
end;

function TfrPanelMensaje.MensajesGetBetaIndex(const OIDBeta: string): string;
var PValor: PDataComunValor;
begin
  inherited;
  PValor := DataComun.FindValor(StrToInt(OIDBeta));
  result := PValor^.Simbolo + ' - ' + PValor^.Nombre;
end;

procedure TfrPanelMensaje.MensajesHotSpotClick(Sender: TObject; const SRC: string;
  var Handled: Boolean);
var pagina: string;
begin
  inherited;
  pagina := Configuracion.Sistema.URLServidor + URL_BASE_AYUDA_MENSAJES + '/m' + src + '.html';
  AbrirURL(pagina);
  Handled := true;
end;

procedure TfrPanelMensaje.MensajesMouseDouble(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ToolWindowMensajeDoubleClick := true;
end;

procedure TfrPanelMensaje.MensajesMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ToolWindowMensajeDoubleClick then begin
    AgrandarRapidamente;
    ToolWindowMensajeDoubleClick := false;
  end;
end;

procedure TfrPanelMensaje.MensajesSeparacionExecute(Sender: TObject);
begin
  Mensajes.ParagrahSeparation := not Mensajes.ParagrahSeparation;
end;

procedure TfrPanelMensaje.MensajesSeparacionUpdate(Sender: TObject);
begin
  MensajesSeparacion.Checked := Mensajes.ParagrahSeparation;
end;

procedure TfrPanelMensaje.OnChangeSizeToolWindowMensaje(var message: TMessage);
begin
  ToolWindowMensaje.Height := message.LParam;
  ToolWindowMensaje.Width := message.WParam;
end;

procedure TfrPanelMensaje.OnConfiguracionMensajeCambiado;
var i, num: integer;
begin
  Mensajes.BeginUpdate;
  try
    Mensajes.TitleSeparation := not Configuracion.Mensajes.TituloMensajeMismaLinea;
    Mensajes.ParagrahSeparation := Configuracion.Mensajes.SeparacionEntreMensajes;
    Mensajes.TamanoFuente := Configuracion.Mensajes.TamanoFuente;
    num := length(Mensajes.Mensajes) - 1;
    for i := 0 to num do
      Mensajes.Mensajes[i].visible := Configuracion.Mensajes.Visible[Mensajes.Mensajes[i].TipoOID];
  finally
    Mensajes.EndUpdate;
  end;
  MensajeMismaLinea.Checked := Mensajes.TitleSeparation;
  MensajesSeparacion.Checked := Mensajes.ParagrahSeparation;
  ActualizarArrastrar.Checked := Configuracion.Mensajes.ActualizarArrastrar;
end;

procedure TfrPanelMensaje.OnCotizacionCambiada;
begin
  // Se ejecuta siempre la accion de parar, aunque esté disabled
  if Lector <> nil then
    VozPararExecute(nil);
  DataMensaje.OnCotizacionCambiada;
end;

procedure TfrPanelMensaje.OnHablaFinalizada;
begin
  FreeAndNil(Lector);
  case ProximaVoz of
    pvNo : begin
      ActivarControlesVoz(false);
      iVoz := 0;
    end;
    pvSiguiente: begin
      inc(iVoz);
      VozReproducirExecute(nil);
    end;
    pvAnterior: begin
      if iVoz > 0 then
        dec(iVoz);
      VozReproducirExecute(nil);
    end;
  end;
end;

procedure TfrPanelMensaje.OnMensajeCambiado;
begin
  Mensajes.BeginUpdate;
  try
    Mensajes.OIDBetas := DataMensaje.OIDBetas;
    Mensajes.OIDPrincipal := DataMensaje.OIDPrincipal;
    Mensajes.NombreValor := Data.ValoresNOMBRE.Value;
    Mensajes.Mensajes := DataMensaje.Mensajes;
  finally
    Mensajes.EndUpdate;
  end;
end;

procedure TfrPanelMensaje.ToolWindowMensajeCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  if (ToolWindowMensaje.Floating) and (Configuracion.Mensajes.Incrustar) then begin
    CanClose := false;
    ToolWindowMensaje.CurrentDock := ToolWindowMensaje.LastDock;
  end
  else
    CanClose := true;
end;

procedure TfrPanelMensaje.ToolWindowMensajeDockChanging(Sender: TObject;
  Floating: Boolean; DockingTo: TTBDock);
begin
  inherited;
  if DockingTo = nil then begin
    PostMessage(Handle, WM_CHANGE_SIZE_TOOLWINDOW_MENSAJE,
      lastToolWindowMensajeWidth, lastToolWindowMensajeHeight);
  end
  else begin
    lastToolWindowMensajeHeight := ToolWindowMensaje.Height;
    lastToolWindowMensajeWidth := ToolWindowMensaje.Width;
    case DockingTo.Position of
      dpBottom, dpTop : begin
        ToolWindowMensaje.Height := 153;
      end;
    end;
  end;
end;

procedure TfrPanelMensaje.VozAnteriorExecute(Sender: TObject);
begin
  ProximaVoz := pvAnterior;
  Lector.ParaDeHablar;
end;

procedure TfrPanelMensaje.VozPararExecute(Sender: TObject);
begin
  ProximaVoz := pvNo;
  if Lector <> nil then
    Lector.ParaDeHablar;
  ActivarControlesVoz(false);
  iVoz := 0;
end;

procedure TfrPanelMensaje.VozPausaExecute(Sender: TObject);
begin
  VozParar.Enabled := not VozParar.Enabled;
  VozSiguiente.Enabled := not VozSiguiente.Enabled;
  VozAnterior.Enabled := not VozAnterior.Enabled;
  Lector.Pausa;
end;

procedure TfrPanelMensaje.VozReproducirExecute(Sender: TObject);
var num: integer;
begin
  inherited;
  FreeAndNil(Lector);
  Lector := TLector.Create(Self);
  try
    // No se puede poner el InitializeVoices en el constructor del TLectorFP
    // porque si tira una excepción esta no se porque no se coge en el except
    Lector.InitializeVoices;
    Lector.OnHablaFinalizada := OnHablaFinalizada;
    ActivarControlesVoz(true);
    num := length(Mensajes.Mensajes);
    while (iVoz < num) and ((Mensajes.Mensajes[iVoz].IsNull) or (not Mensajes.Mensajes[iVoz].visible)) do
      inc(iVoz);
    if iVoz < num then begin
      Lector.Habla(Mensajes.Mensajes[iVoz].Titulo, Mensajes.GetMensaje(iVoz));
      ProximaVoz := pvSiguiente;
    end
    else begin
      if iVoz = num then begin
        Lector.Habla(AVISO_LEGAL, Mensajes.AvisoLegal);
      end
      else begin
        ActivarControlesVoz(false);
        iVoz := 0;
      end;
    end;
  except
    Lector.MostrarErrorVoz;
    FreeAndNil(Lector);
  end;
end;

procedure TfrPanelMensaje.VozSiguienteExecute(Sender: TObject);
begin
  ProximaVoz := pvSiguiente;
  Lector.ParaDeHablar;
end;

initialization
  RegisterPanelClass(TfrPanelMensaje);

end.
