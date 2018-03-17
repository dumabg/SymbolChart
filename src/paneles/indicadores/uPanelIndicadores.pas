unit uPanelIndicadores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, ExtCtrls, DBCtrls, uPanelNotificaciones, TB2Dock,
  SpTBXItem, dmPanelIndicadores, JvExControls, JvLabel;

type
  TfrPanelIndicadores = class(TfrPanelNotificaciones)
    dsCotizacionEstado: TDataSource;
    PanelDobsonFractal: TPanel;
    Shape4: TShape;
    Shape3: TShape;
    OvcRotatedLabel1: TJvLabel;
    DobsonAlzaDoble130: TDBText;
    DobsonAlzaDoble100: TDBText;
    DobsonAlzaDoble70: TDBText;
    DobsonAlzaDoble40: TDBText;
    DobsonAlzaDoble10: TDBText;
    Dobson130: TDBText;
    DobsonBajaDoble100: TDBText;
    Dobson100: TDBText;
    Dobson70: TDBText;
    DobsonBajaDoble10: TDBText;
    DobsonBajaDoble130: TDBText;
    Dobson40: TDBText;
    Dobson10: TDBText;
    DobsonBajaDoble70: TDBText;
    DobsonBajaDoble40: TDBText;
    Image9: TImage;
    Bevel10: TBevel;
    OvcRotatedLabel4: TJvLabel;
    Bevel11: TBevel;
    Nivel: TDBText;
    NivelBajada: TDBText;
    NivelSubida: TDBText;
    Image2: TImage;
    Image4: TImage;
    Image1: TImage;
    BollinguerBaja: TDBText;
    BollinguerAlta: TDBText;
    Label3: TLabel;
    Label4: TLabel;
    PanelIncrementos: TPanel;
    Shape7: TShape;
    Shape6: TShape;
    Shape5: TShape;
    Bevel6: TBevel;
    OvcRotatedLabel3: TJvLabel;
    Label33: TLabel;
    Label32: TLabel;
    Volatilidad: TDBText;
    Variabilidad: TDBText;
    RSILargo: TDBText;
    RSICorto: TDBText;
    Label19: TLabel;
    Bevel1: TBevel;
    Media200: TDBText;
    Label6: TLabel;
    Label20: TLabel;
    lRSI: TJvLabel;
    PotencialFractalSube: TImage;
    PotencialFractalBaja: TImage;
    Label21: TLabel;
    DimFractal: TDBText;
    Label23: TLabel;
    PotFractal: TDBText;
    OvcRotatedLabel5: TJvLabel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Label38: TLabel;
    Maximo: TLabel;
    Label39: TLabel;
    Minimo: TLabel;
    Label49: TLabel;
    RelVolVar: TDBText;
    TBXToolWindow: TSpTBXToolWindow;
  private
    PanelIndicadores: TPanelIndicadores;
    procedure PintarNiveles;
  protected
    procedure OnCotizacionCambiada; override;
    procedure OnValorCambiado; override;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetNombre: string; override;
  end;

implementation

uses uPanel, UtilDock, UtilString;

{$R *.dfm}

const
  ColoresNiveles: array [0..10] of TColor =
  (clRed, clRed, clRed, clRed, clRed, clBlue,
   clGreen, clGreen, clGreen, clGreen, clGreen);

{ TfrIndicadores }

constructor TfrPanelIndicadores.Create(AOwner: TComponent);
var defaultDock: TDefaultDock;
begin
  defaultDock.Position := dpAbajo;
  defaultDock.Pos := 675;
  defaultDock.Row := 1;
  inherited CreatePanelNotificaciones(AOwner, defaultDock, [pnCotizacionCambiada, pnValorCambiado]);
  PanelIndicadores := TPanelIndicadores.Create(Self);
  OnValorCambiado;
  OnCotizacionCambiada;
end;

class function TfrPanelIndicadores.GetNombre: string;
begin
  result := 'Indicadores';
end;

procedure TfrPanelIndicadores.OnCotizacionCambiada;
var subePotFractal: boolean;
begin
  if (PanelIndicadores.ExisteCambio) and (PanelIndicadores.ExistePotencialFractal) then begin
    subePotFractal := PanelIndicadores.SubePotencialFractal;
    PotencialFractalSube.Visible := subePotFractal;
    PotencialFractalBaja.Visible := not subePotFractal;
    PintarNiveles;
  end
  else begin
    PotencialFractalSube.Visible := false;
    PotencialFractalBaja.Visible := false;
  end;
end;

procedure TfrPanelIndicadores.OnValorCambiado;
var max, min: currency;
begin
  if PanelIndicadores.CalcularMaxMin(max, min) then begin
    Maximo.Caption := FormatCurr(max);
    Minimo.Caption := FormatCurr(min);
  end
  else begin
    Maximo.Caption := '';
    Minimo.Caption := '';
  end;
end;

procedure TfrPanelIndicadores.PintarNiveles;
begin
  if PanelIndicadores.ExisteCambio then begin
    if PanelIndicadores.ExisteDobsonAlto then
      NivelSubida.Color := ColoresNiveles[PanelIndicadores.NivelSube]
    else
      NivelSubida.Color := $00F0F0F0;

    if PanelIndicadores.ExisteDobson then
      Nivel.Color := ColoresNiveles[PanelIndicadores.NivelActual]
    else
      Nivel.Color := $00F0F0F0;

    if PanelIndicadores.ExisteDobsonBajo then
      NivelBajada.Color := ColoresNiveles[PanelIndicadores.NivelBaja]
    else
      NivelBajada.Color := $00F0F0F0;
  end
  else
  begin
    Nivel.Color := $00F0F0F0;
    NivelSubida.Color := $00F0F0F0;
    NivelBajada.Color := $00F0F0F0;
  end;
end;

initialization
  RegisterPanelClass(TfrPanelIndicadores);

end.
