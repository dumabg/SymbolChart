unit uPanelSwing;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uPanelNotificaciones, DBCtrls, StdCtrls, ExtCtrls, DB,
  dmPanelSwing, DBTextExt, TB2Dock, SpTBXItem, mensajesPanel;

type
  TfrPanelSwing = class(TfrPanelNotificaciones)
    dsCotizacionEstado: TDataSource;
    ToolBarSwingTrading: TSpTBXToolWindow;
    FlowPanelSwing: TFlowPanel;
    iAvance: TImage;
    sepAvance: TBevel;
    stEstado: TLabel;
    Bevel7: TBevel;
    Label7: TLabel;
    Stop: TDBText;
    sepPosicionado: TBevel;
    lPosicionado: TLabel;
    lPosicionadoSigno: TLabel;
    Posicionado: TDBText;
    sepRiesgo: TBevel;
    lRiesgo: TLabel;
    Riesgo: TDBText;
    pNuevoSwing: TPanel;
    lNuevoMensaje: TLabel;
  private
    DataSwing: TPanelSwing;
    NuevoMensajePanel: TMensajesPanel;
    procedure SwingTrading;
    procedure NuevoSwingTrading;
  protected
    procedure OnCotizacionCambiada; override;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetNombre: string; override;
  end;


implementation

{$R *.dfm}

uses dmData, flags, uPanel, UtilDock;


var cont : integer = 0;

resourcestring
  NOMBRE = 'Swing trading';

{ TfrSwing }

constructor TfrPanelSwing.Create(AOwner: TComponent);
var defaultDock: TDefaultDock;
begin
  defaultDock.Position := dpArribaCentro;
  defaultDock.Pos := 0;
  defaultDock.Row := 0;
  inherited CreatePanelNotificaciones(AOwner, defaultDock, [pnCotizacionCambiada]);
  DataSwing := TPanelSwing.Create(Self);
  NuevoMensajePanel := TMensajesPanel.Create(Self);
  NuevoMensajePanel.Visible := false;
  NuevoMensajePanel.Parent := Self;
//  NuevoMensajePanel.Align := alClient;
  OnCotizacionCambiada;
end;

class function TfrPanelSwing.GetNombre: string;
begin
  result := NOMBRE;
end;

procedure TfrPanelSwing.NuevoSwingTrading;
var msg: string;
begin
  NuevoMensajePanel.BeginUpdate;
  try
    NuevoMensajePanel.OIDBetas := 1;
    NuevoMensajePanel.OIDPrincipal := 0;
    NuevoMensajePanel.Mensajes := DataSwing.NuevoMensaje;
  finally
    NuevoMensajePanel.EndUpdate;
  end;
  msg := NuevoMensajePanel.GetMensaje(0);

  case (cont mod 4) of
    0 : msg := 'LARGOS.' + msg;
    1 : msg := 'CORTOS.' + msg;
    2 : msg := 'ESPERAR.' + msg;
    3 : msg := 'SIN MENSAJE.' + msg;
  end;
  inc(cont);

  lNuevoMensaje.Caption := msg;
  if msg[1] = 'L' then
    lNuevoMensaje.Font.Color := clGreen
  else
    if msg[1] = 'C' then
      lNuevoMensaje.Font.Color := clRed
    else
      if msg[1] = 'E' then
        lNuevoMensaje.Font.Color := clNavy
      else
        lNuevoMensaje.Font.Color := clBlack;
  ToolBarSwingTrading.Width := lNuevoMensaje.Canvas.TextWidth(msg) + 15;
end;

procedure TfrPanelSwing.OnCotizacionCambiada;
begin
//  if Data.TipoCotizacion = tcDiaria then begin
//    FlowPanelSwing.Visible := false;
//    pNuevoSwing.Visible := true;
//    NuevoSwingTrading;
//  end
//  else begin
    pNuevoSwing.Visible := false;
    FlowPanelSwing.Visible := true;
    SwingTrading;
//  end;
end;

procedure TfrPanelSwing.SwingTrading;
var flags: TFlags;
  procedure PosicionadoRiesgo(const visible, isVirtual: boolean);
  begin
    lPosicionadoSigno.Visible := Visible;
    lPosicionado.Visible := visible;
    sepPosicionado.Visible := visible;
    Posicionado.Visible := visible;
    if isVirtual then begin
      lRiesgo.Visible := false;
      sepRiesgo.Visible := false;
      Riesgo.Visible := false;
    end
    else begin
      lRiesgo.Visible := visible;
      sepRiesgo.Visible := visible;
      Riesgo.Visible := visible;
    end;
  end;
begin
  iAvance.Visible := DataSwing.HayMensajeAvance;
  sepAvance.Visible := iAvance.Visible;
  if iAvance.Visible then
    stEstado.Margins.Left := 3
  else
    stEstado.Margins.Left := 10;
  flags := DataSwing.FlagsMensajes;
  try
    if flags.Es(cMantener) then begin
      stEstado.Caption := 'MANTENER';
      stEstado.Font.Color := clGreen;
      PosicionadoRiesgo(false, false);
    end
    else
      if flags.Es(cAdvertencia) then begin
        stEstado.Caption := 'ADVERTENCIA';
        stEstado.Font.Color := clRed;
        PosicionadoRiesgo(false, false);
      end
      else
        if flags.Es(cInicioCiclo) then begin
          stEstado.Caption := 'INICIO DE CICLO';
          stEstado.Font.Color := clGreen;
          lPosicionadoSigno.Caption := '<';
          PosicionadoRiesgo(true, false);
        end
        else
          if flags.Es(cPrimeraAdvertencia) then begin
            stEstado.Caption := 'PRIMERA ADVERTENCIA';
            stEstado.Font.Color := clRed;
            lPosicionadoSigno.Caption := '>';
            PosicionadoRiesgo(true, false);
          end
          else
            if flags.Es(cInicioCicloVirtual) then begin
              stEstado.Caption := 'INICIO DE CICLO VIRTUAL';
              stEstado.Font.Color := clGreen;
              lPosicionadoSigno.Caption := '<';
              PosicionadoRiesgo(true, true);
            end
            else
              if flags.Es(cPrimeraAdvertenciaVirtual) then begin
                stEstado.Caption := 'PRIMERA ADVERTENCIA VIRTUAL';
                stEstado.Font.Color := clRed;
                lPosicionadoSigno.Caption := '>';
                PosicionadoRiesgo(true, true);
              end
              else begin
                PosicionadoRiesgo(false, false);
                case Data.PosicionamientoValor of
                  pvLargo: begin
                    stEstado.Caption := 'MANTENER';
                    stEstado.Font.Color := clGreen;
                  end;
                  pvCorto: begin
                    stEstado.Caption := 'ADVERTENCIA';
                    stEstado.Font.Color := clRed;
                  end;
                  else stEstado.Caption := '';
                end;
              end;
  finally
    flags.Free;
  end;
end;

initialization
  RegisterPanelClass(TfrPanelSwing);

end.
