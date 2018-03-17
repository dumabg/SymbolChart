unit uPanelRentabilidadMercado;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uPanelNotificaciones, frRentabilidadMercado, TB2Dock, SpTBXItem;

type
  TfrPanelRentabilidadMercado = class(TfrPanelNotificaciones)
    ToolWindowRentabilidadMercado: TSpTBXToolWindow;
    frPanelRentabilidadMercado: TfRentabilidadMercado;
  protected
    procedure OnCotizacionCambiada; override;
    procedure OnTipoCotizacionCambiada; override;
  public
    constructor Create(Owner: TComponent); override;
    class function GetNombre: string; override;
  end;

implementation

{$R *.dfm}

uses uPanel, dmData, UtilDock;

resourcestring
  NOMBRE = 'Rentabilidad mercado';

constructor TfrPanelRentabilidadMercado.Create(Owner: TComponent);
var defaultDock: TDefaultDock;
begin
  defaultDock.Position := dpAbajo;
  defaultDock.Pos := 83;
  defaultDock.Row := 0;
  inherited CreatePanelNotificaciones(Owner, defaultDock, [pnCotizacionCambiada, pnTipoCotizacionCambiada]);
  OnCotizacionCambiada;
end;

class function TfrPanelRentabilidadMercado.GetNombre: string;
begin
  result := NOMBRE;
end;

procedure TfrPanelRentabilidadMercado.OnCotizacionCambiada;
begin
  frPanelRentabilidadMercado.Load(Data.CotizacionOR_SESION.Value, Data.ValoresOID_MERCADO.Value);
end;


procedure TfrPanelRentabilidadMercado.OnTipoCotizacionCambiada;
begin
  frPanelRentabilidadMercado.Reset;
  OnCotizacionCambiada;
end;

initialization
  RegisterPanelClass(TfrPanelRentabilidadMercado);

end.
