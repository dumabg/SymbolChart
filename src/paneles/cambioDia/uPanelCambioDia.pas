unit uPanelCambioDia;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uPanel, StdCtrls, DBCtrls, uPanelNotificaciones, ExtCtrls, TB2Dock,
  SpTBXItem, Buttons;

type
  TTipoDia = class(TGraphicControl)
  private
    x: integer;
    FApertura: Currency;
    FMaximo: Currency;
    FCierre: Currency;
    FMinimo: Currency;
    function GetY(const valor: currency): integer;
    property Maximo: Currency read FMaximo write FMaximo;
    property Minimo: Currency read FMinimo write FMinimo;
    property Apertura: Currency read FApertura write FApertura;
    property Cierre: Currency read FCierre write FCierre;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TfrPanelCambioDia = class(TfrPanelNotificaciones)
    MaximoActual: TDBText;
    MinimoActual: TDBText;
    PerCentDias: TDBText;
    ImageSubir: TImage;
    NumDias: TDBText;
    ImageBajar: TImage;
    Variacion: TDBText;
    pTipoDia: TPanel;
    ToolWindow: TSpTBXToolWindow;
    Cierre: TDBText;
    Apertura: TDBText;
    Cierre2: TDBText;
    pCambios: TPanel;
    pFecha: TPanel;
    FechaEstado: TDBText;
    sbSeleccionarFecha: TSpeedButton;
    procedure sbSeleccionarFechaClick(Sender: TObject);
    procedure FechaEstadoClick(Sender: TObject);
  private
    TipoDia: TTipoDia;
  protected
    procedure OnCotizacionCambiada; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetNombre: string; override;
  end;


implementation

uses dmData, UtilDock, fmCalendario, GraficoPositionLayer, SCMain;

const
  DATO_NULL : integer = Low(integer);

resourcestring
  NOMBRE_PANEL = 'Cambios del día';

{$R *.dfm}

{ TfrPanel1 }

constructor TfrPanelCambioDia.Create(AOwner: TComponent);
var defaultDock: TDefaultDock;
begin
  defaultDock.Position := dpArriba;
  defaultDock.Pos := 0;
  defaultDock.Row := 0;
  inherited CreatePanelNotificaciones(AOwner, defaultDock, [pnCotizacionCambiada]);
  TipoDia := TTipoDia.Create(Self);
  TipoDia.Parent := pTipoDia;
  TipoDia.Align := alClient;
  OnCotizacionCambiada;
end;

destructor TfrPanelCambioDia.Destroy;
begin
  TipoDia.Free;
  inherited;
end;


procedure TfrPanelCambioDia.FechaEstadoClick(Sender: TObject);
begin
  inherited;
  sbSeleccionarFechaClick(Self);
end;

class function TfrPanelCambioDia.GetNombre: string;
begin
  result := NOMBRE_PANEL;
end;

procedure TfrPanelCambioDia.OnCotizacionCambiada;
begin
  inherited;
  if Data.CotizacionMAXIMO.IsNull then
    TipoDia.Maximo := DATO_NULL
  else
    TipoDia.Maximo := Data.CotizacionMAXIMO.Value;
  if Data.CotizacionMINIMO.IsNull then
    TipoDia.Minimo := DATO_NULL
  else
    TipoDia.Minimo := Data.CotizacionMINIMO.Value;
  if Data.CotizacionCIERRE.IsNull then
    TipoDia.Cierre := DATO_NULL
  else
    TipoDia.Cierre := Data.CotizacionCIERRE.Value;
  if Data.CotizacionAPERTURA.IsNull then
    TipoDia.Apertura := DATO_NULL
  else
    TipoDia.Apertura := Data.CotizacionAPERTURA.Value;
  TipoDia.Invalidate;

  if Data.CotizacionCIERRE.Value = 0 then begin
    pCambios.Visible := false;
  end
  else begin
    pCambios.Visible := true;
    if Data.CotizacionDIAS_SEGUIDOS_PERCENT.Value >= 0 then begin
      ImageSubir.Visible := true;
      ImageBajar.Visible := false;
      NumDias.Font.Color := clGreen;
      PerCentDias.Font.Color := clGreen;
    end
    else begin
      ImageSubir.Visible := false;
      ImageBajar.Visible := true;
      NumDias.Font.Color := clRed;
      PerCentDias.Font.Color := clRed;
    end;

    if Data.CotizacionVARIACION.Value > 0 then
      Variacion.Font.Color := clGreen
    else
      if Data.CotizacionVARIACION.Value = 0 then begin
        if Data.CotizacionDIAS_SEGUIDOS_PERCENT.Value >= 0 then
          Variacion.Font.Color := clGreen
        else
          Variacion.Font.Color := clRed;
      end
      else
        Variacion.Font.Color := clRed;
  end;
end;

procedure TfrPanelCambioDia.sbSeleccionarFechaClick(Sender: TObject);
var fCalendario: TfCalendario;
  x, y: integer;
  p: TPoint;
  positionLayer: TGraficoPositionLayer;
begin
  inherited;
  fCalendario := TfCalendario.Create(nil, Data.ValoresOID_VALOR.Value);
  try
    x := sbSeleccionarFecha.Width;
    y := sbSeleccionarFecha.Height;
    p := sbSeleccionarFecha.ClientToScreen(Point(x, y));
    x := p.x  - fCalendario.Width + 4;
    if x < 0 then
      x := 0;
    fCalendario.Left := x;
    if p.y + fCalendario.Height > Screen.Height then
      fCalendario.Top := p.Y - fCalendario.Height - sbSeleccionarFecha.Height - 1
    else
      fCalendario.Top := p.y + 1;
    if fCalendario.ShowModal = mrOk then begin
      positionLayer := fSCMain.Grafico.GetGraficoPositionLayer;
      if positionLayer <> nil then
        positionLayer.HelpPoint;
    end;
  finally
    fCalendario.Free;
  end;
end;

{ TTipoDia }

constructor TTipoDia.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque];
  FMaximo := DATO_NULL;
  FMinimo := DATO_NULL;
  FCierre := DATO_NULL;
  FApertura := DATO_NULL;
end;

function TTipoDia.GetY(const valor: currency): integer;
begin
  result := Height - Trunc(((valor - FMinimo) * Height) / (FMaximo - FMinimo));
  if result = Height then
    result := result - 2;
  if result = 0 then
    inc(result);
end;

procedure TTipoDia.Paint;
var y: integer;
begin
  // -2 --> 4 pixels de anchura de la barra principal / 2
  x := Trunc(Width / 2) - 2;

  if Data.CotizacionVARIACION.Value >= 0 then
    Canvas.Pen.Color := clGreen
  else
    Canvas.Pen.Color := clRed;
  Canvas.Brush.Color := $00FFF9F9;
  Canvas.FillRect(Rect(0,0,Width,Height));
  if (FMaximo <> DATO_NULL) and (FMinimo <> DATO_NULL) and
    (FCierre <> DATO_NULL) then begin
    if (FApertura <> DATO_NULL) and (FMaximo <> FMinimo) then begin
      y := GetY(FApertura);
      Canvas.PenPos := Point(x, y);
      Canvas.Pen.Width := 3;
      Canvas.LineTo(x - 6, y);
    end;
    Canvas.Pen.Width := 4;
    Canvas.PenPos := Point(x, 0);
    Canvas.LineTo(x, Height);

    if FMaximo <> FMinimo then begin
      y := GetY(FCierre);
      Canvas.PenPos := Point(x, y);
      Canvas.Pen.Width := 3;
      Canvas.LineTo(x + 6, y);
    end;
  end;
end;

initialization
  RegisterPanelClass(TfrPanelCambioDia);

end.
