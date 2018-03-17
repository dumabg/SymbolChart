unit uPanelNotificaciones;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uPanel, BusCommunication, UtilDock, JvComponentBase, JvFormPlacement;

type
  TPanelNotificacion = (pnValorCambiado, pnCotizacionCambiada, pnTipoCotizacionCambiada);

  TPanelNotificaciones = set of TPanelNotificacion;

  TfrPanelNotificaciones = class(TfrPanel)
  private
    notificaciones: TPanelNotificaciones;
  protected
    procedure OnCotizacionCambiada; virtual;
    procedure OnValorCambiado; virtual;
    procedure OnTipoCotizacionCambiada; virtual;
  public
    constructor CreatePanelNotificaciones(AOwner: TComponent;
      const DefaultDock: TDefaultDock; const notificaciones: TPanelNotificaciones);
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses dmData;

{ TfrCotizacionCambiada }

constructor TfrPanelNotificaciones.CreatePanelNotificaciones(AOwner: TComponent;
  const DefaultDock: TDefaultDock; const notificaciones: TPanelNotificaciones);
begin
  inherited CreatePanel(AOwner, DefaultDock);
  Self.notificaciones := notificaciones;
  if pnValorCambiado in notificaciones then
    Bus.RegisterEvent(MessageValorCambiado, OnValorCambiado);
  if pnCotizacionCambiada in notificaciones then
    Bus.RegisterEvent(MessageCotizacionCambiada, OnCotizacionCambiada);
  if pnTipoCotizacionCambiada in notificaciones then
    Bus.RegisterEvent(MessageTipoCotizacionCambiada, OnTipoCotizacionCambiada);
end;

destructor TfrPanelNotificaciones.Destroy;
begin
  if pnValorCambiado in notificaciones then
    Bus.UnregisterEvent(MessageValorCambiado, OnValorCambiado);
  if pnCotizacionCambiada in notificaciones then
    Bus.UnregisterEvent(MessageCotizacionCambiada, OnCotizacionCambiada);
  if pnTipoCotizacionCambiada in notificaciones then
    Bus.UnregisterEvent(MessageTipoCotizacionCambiada, OnTipoCotizacionCambiada);
  inherited Destroy;
end;

procedure TfrPanelNotificaciones.OnCotizacionCambiada;
begin

end;

procedure TfrPanelNotificaciones.OnTipoCotizacionCambiada;
begin

end;

procedure TfrPanelNotificaciones.OnValorCambiado;
begin

end;

end.
