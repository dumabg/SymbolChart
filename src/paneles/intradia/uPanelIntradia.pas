unit uPanelIntradia;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uPanelNotificaciones, DB, StdCtrls, DBCtrls, dbmemoReadOnly,
  ExtCtrls, SpTBXItem, TB2Dock, dmPanelIntradia, SpTBXControls;

type
  TfrPanelIntradia = class(TfrPanelNotificaciones)
    dsCotizacion: TDataSource;
    dsCotizacionEstado: TDataSource;
    pPivotPoints: TPanel;
    Label26: TLabel;
    Label34: TLabel;
    Panel6: TPanel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    PivotR3: TDBText;
    PivotR2: TDBText;
    PivotR1: TDBText;
    Panel7: TPanel;
    Label37: TLabel;
    Label41: TLabel;
    Label46: TLabel;
    PivotS1: TDBText;
    PivotS2: TDBText;
    PivotS3: TDBText;
    Panel8: TPanel;
    Label35: TLabel;
    Pivot: TDBText;
    pIntradia: TPanel;
    Shape11: TShape;
    Shape8: TShape;
    Shape10: TShape;
    MaximoPrevistoAprox: TDBText;
    Label24: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    Label94: TLabel;
    MaximoFuturo: TDBText;
    MaximoHistorico: TDBText;
    MaximoPrevisto: TDBText;
    MinimoFuturo: TDBText;
    MinimoHistorico: TDBText;
    MinimoPrevisto: TDBText;
    MinimoPrevistoAprox: TDBText;
    Label31: TLabel;
    FechaEstado2: TDBText;
    Label2: TLabel;
    Label28: TLabel;
    TBXToolWindow: TSpTBXToolWindow;
    lAmbienteIntradia: TLabel;
  private
    PanelIntradia: TPanelIntradia;
  protected
    procedure OnCotizacionCambiada; override;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetNombre: string; override;
  end;


implementation

uses dmData, uPanel, UtilDock;

resourcestring
  NOMBRE = 'Intradía';

{$R *.dfm}

{ TfrPanelCotizacionCambiada1 }

constructor TfrPanelIntradia.Create(AOwner: TComponent);
var defaultDock: TDefaultDock;
begin
  defaultDock.Position := dpArriba;
  defaultDock.Pos := 236;
  defaultDock.Row := 0;
  inherited CreatePanelNotificaciones(AOwner, defaultDock, [pnCotizacionCambiada]);
  PanelIntradia := TPanelIntradia.Create(Self);
  OnCotizacionCambiada;
end;

class function TfrPanelIntradia.GetNombre: string;
begin
  result := NOMBRE;
end;

procedure TfrPanelIntradia.OnCotizacionCambiada;
var maximo, minimo, maximoPrevio, minimoPrevio: currency;
begin
  maximo := Data.CotizacionMAXIMO.Value;
  minimo := Data.CotizacionMINIMO.Value;
  maximoPrevio := Data.CotizacionEstadoMAXIMO_SE_PREVINO.Value;
  minimoPrevio := Data.CotizacionEstadoMINIMO_SE_PREVINO.Value;
  if maximoPrevio > maximo then
    MaximoPrevisto.Font.Color := clBlue
  else
    if maximoPrevio < maximo then
      MaximoPrevisto.Font.Color := clPurple
    else
      MaximoPrevisto.Font.Color := clBlack;
  if minimoPrevio > minimo then
    MinimoPrevisto.Font.Color := clBlue
  else
    if minimoPrevio < minimo then
      MinimoPrevisto.Font.Color := clPurple
    else
      MinimoPrevisto.Font.Color := clBlack;

  if Data.CotizacionEstadoMAXIMO_PREVISTO_APROX.Value > 99.8 then
    MaximoPrevistoAprox.Font.Color := clGreen
  else
    MaximoPrevistoAprox.Font.Color := clRed;
  if Data.CotizacionEstadoMINIMO_PREVISTO_APROX.Value > 99.8 then
    MinimoPrevistoAprox.Font.Color := clGreen
  else
    MinimoPrevistoAprox.Font.Color := clRed;

  lAmbienteIntradia.Caption := PanelIntradia.GetMsg(Data.CotizacionEstadoAMBIENTE_INTRADIA.Value);
end;

initialization
  RegisterPanelClass(TfrPanelIntradia);

end.
