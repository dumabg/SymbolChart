unit uPanelRentabilidadValor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uPanelNotificaciones, DB, DBCtrls, StdCtrls, ExtCtrls,
  dmPanelRentabilidadValor, TB2Dock, SpTBXItem, AppEvnts, GIFImg;

type
  TfrPanelRentabilidadValor = class(TfrPanelNotificaciones)
    dsCotizacionRentabilidad: TDataSource;
    ToolWindowRentabilidadValor: TSpTBXToolWindow;
    Label29: TLabel;
    Label40: TLabel;
    Label48: TLabel;
    Label50: TLabel;
    Bevel5: TBevel;
    Label53: TLabel;
    Label54: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label59: TLabel;
    Image6: TImage;
    Image7: TImage;
    RentabilidadAbierta: TDBText;
    RentabilidadAbiertaNivel: TDBText;
    RentabilidadAbiertaFecha: TDBText;
    RentabilidadCerradoFechaIni: TDBText;
    RentabilidadCerradoNivelIni: TDBText;
    RentabilidadCerradoFechaFin: TDBText;
    RentabilidadCerradoNivelFin: TDBText;
    RentabilidadCerrado: TDBText;
    Label30: TLabel;
    Label27: TLabel;
    Label45: TLabel;
    TipoPosCerrado: TDBText;
    TipoPosAbierto: TDBText;
    Image8: TImage;
    Image17: TImage;
    Image18: TImage;
    ApplicationEvents: TApplicationEvents;
    pFondo: TPanel;
    procedure IrAFecha(Sender: TObject);
    procedure ApplicationEventsShowHint(var HintStr: string;
      var CanShow: Boolean; var HintInfo: THintInfo);
  private
    RentabilidadValor: TRentabilidadValor;
  protected
    procedure OnCotizacionCambiada; override;
    procedure IndicadoresRentabilidad;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetNombre: string; override;
  end;

implementation

{$R *.dfm}

uses dmData, uPanel, UtilDock, BusCommunication;

resourcestring
  NOMBRE = 'Rentabilidad valor';
  HINT_ULTIMO_POS_TEORICO_ABIERTO = 'Resultado del último posicionamiento teórico abierto';
  HINT_ULTIMO_POS_TEORICO_CERRADO = 'Resultado del último posicionamiento teórico cerrado';

{ TfrRentabilidadValor }

procedure TfrPanelRentabilidadValor.ApplicationEventsShowHint(
  var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
var c: TControl;
begin
  inherited;
  c := HintInfo.HintControl;
  if c = RentabilidadAbierta then begin
    HintStr := HINT_ULTIMO_POS_TEORICO_ABIERTO + sLineBreak + RentabilidadValor.GetTAEAbierta;
  end
  else begin
    if c = RentabilidadCerrado then begin
      HintStr := HINT_ULTIMO_POS_TEORICO_CERRADO +  sLineBreak + RentabilidadValor.GetTAECerrada;
    end;
  end;
end;

constructor TfrPanelRentabilidadValor.Create(AOwner: TComponent);
var defaultDock: TDefaultDock;
begin
  defaultDock.Position := dpAbajo;
  defaultDock.Pos := 423;
  defaultDock.Row := 0;
  inherited CreatePanelNotificaciones(AOwner, defaultDock, [pnCotizacionCambiada]);
  RentabilidadValor := TRentabilidadValor.Create(Self);
  IndicadoresRentabilidad;
end;

class function TfrPanelRentabilidadValor.GetNombre: string;
begin
  result := NOMBRE;
end;

procedure TfrPanelRentabilidadValor.IndicadoresRentabilidad;
begin
  if RentabilidadValor.CotizacionRentabilidadRENTABILIDAD_CERRADA.IsNull then
    RentabilidadCerrado.Font.Color := clBlack
  else begin
    if RentabilidadValor.CotizacionRentabilidadRENTABILIDAD_CERRADA.Value >= 0 then
      RentabilidadCerrado.Font.Color := clGreen
    else
      RentabilidadCerrado.Font.Color := clRed;
  end;
  if RentabilidadValor.HayRentabilidadAbierta then begin
    if RentabilidadValor.RentabilidadAbierta >= 0 then
      RentabilidadAbierta.Font.Color := clGreen
    else
      RentabilidadAbierta.Font.Color := clRed;
  end
  else begin
    RentabilidadAbierta.Font.Color := clBlack
  end;
end;

procedure TfrPanelRentabilidadValor.IrAFecha(Sender: TObject);
begin
  Data.IrACotizacionConFecha(TDBText(Sender).Field.AsDateTime);
end;

procedure TfrPanelRentabilidadValor.OnCotizacionCambiada;
begin
  IndicadoresRentabilidad;
end;


initialization
  RegisterPanelClass(TfrPanelRentabilidadValor);

end.
