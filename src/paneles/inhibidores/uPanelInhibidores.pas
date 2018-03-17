unit uPanelInhibidores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uPanelNotificaciones, ExtCtrls, dmPanelInhibidores, DB, JvExExtCtrls,
  JvShape, StdCtrls, TB2Dock, SpTBXItem, AppEvnts;

type
  TfrPanelInhibidores = class(TfrPanelNotificaciones)
    lInhibidorLargo: TLabel;
    InhibidorLargo: TJvShape;
    lInhibidorCorto: TLabel;
    InhibidorCorto: TJvShape;
    TBXToolWindow: TSpTBXToolWindow;
    ApplicationEvents: TApplicationEvents;
    iHistoricoLargo: TImage;
    iHistoricoCorto: TImage;
    procedure ApplicationEventsShowHint(var HintStr: string;
      var CanShow: Boolean; var HintInfo: THintInfo);
  private
    DataInhibidores: TPanelInhibidores;
    bHistoricoLargo, bHistoricoCorto: TBitmap;
    procedure qInhibidorAfterOpen(DataSet: TDataSet);
    procedure PaintInhibidoresHistorico;
  protected
    procedure OnCotizacionCambiada; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetNombre: string; override;
  end;

implementation

{$R *.dfm}

uses UtilDB, dmData, uPanel, UtilDock;

resourcestring
  NOMBRE = 'Aproximaciones';

{ TfrInhibidores }

procedure TfrPanelInhibidores.ApplicationEventsShowHint(var HintStr: string;
  var CanShow: Boolean; var HintInfo: THintInfo);
var control: TControl;
  inhibidor, estado: string;
begin
  inherited;
  control := HintInfo.HintControl;
  if control = InhibidorLargo then begin
    inhibidor := DataInhibidores.qInhibidorINHIBIDOR.Value;
    if not ((inhibidor = 'A') or (inhibidor = 'L')) then
      estado := 'Desactivado'
    else
      estado := 'Activado';
    HintStr := HintStr + '. ' + estado + '.';
  end
  else begin
    if control = InhibidorCorto then begin
      if not ((inhibidor = 'A') or (inhibidor = 'C')) then
        estado := 'Activado'
      else
        estado := 'Desactivado';
      HintStr := HintStr + '. ' + estado + '.';
    end;
  end;
end;

constructor TfrPanelInhibidores.Create(AOwner: TComponent);
var defaultDock: TDefaultDock;
begin
  defaultDock.Position := dpAbajo;
  defaultDock.Pos := 0;
  defaultDock.Row := 0;
  inherited CreatePanelNotificaciones(AOwner, defaultDock, [pnCotizacionCambiada]);
  DataInhibidores := TPanelInhibidores.Create(Self);
  DataInhibidores.qInhibidor.AfterOpen := qInhibidorAfterOpen;

  bHistoricoLargo := TBitmap.Create;
  bHistoricoLargo.Width := iHistoricoLargo.Width;
  bHistoricoLargo.Height := iHistoricoLargo.Height;
  iHistoricoLargo.Picture.Graphic := bHistoricoLargo;

  bHistoricoCorto := TBitmap.Create;
  bHistoricoCorto.Width := iHistoricoCorto.Width;
  bHistoricoCorto.Height := iHistoricoCorto.Height;
  iHistoricoCorto.Picture.Graphic := bHistoricoCorto;

  OnCotizacionCambiada;
end;

destructor TfrPanelInhibidores.Destroy;
begin
  bHistoricoLargo.Free;
  bHistoricoCorto.Free;
  inherited;
end;

class function TfrPanelInhibidores.GetNombre: string;
begin
  result := NOMBRE;
end;

procedure TfrPanelInhibidores.OnCotizacionCambiada;
var inhibidor: string;
  rentPositiva: boolean;
begin
{  if (Data.ValorSinCotizar) or (not Data.TieneEstado) then begin
    InhibidorCorto.Brush.Color := clSilver;
    InhibidorLargo.Brush.Color := clSilver;
  end
  else begin
    inhibidor := DataInhibidores.qInhibidorINHIBIDOR.Value;
    rentPositiva := DataInhibidores.qInhibidorTOTAL_PERCENT.Value >= 0;
    if not ((inhibidor = 'A') or (inhibidor = 'L')) then begin
      InhibidorLargo.Brush.Color := clLime;
    end
    else begin
      if rentPositiva then
        InhibidorLargo.Brush.Color := clYellow
      else
        InhibidorLargo.Brush.Color := clRed;
    end;
    if not ((inhibidor = 'A') or (inhibidor = 'C')) then begin
      InhibidorCorto.Brush.Color := clLime;
    end
    else begin
      if rentPositiva then
        InhibidorCorto.Brush.Color := clYellow
      else
        InhibidorCorto.Brush.Color := clRed;
    end;
  end;}

  if (Data.ValorSinCotizar) or (not Data.TieneEstado) then begin
    InhibidorCorto.Brush.Color := clSilver;
    InhibidorLargo.Brush.Color := clSilver;
  end
  else begin
    inhibidor := DataInhibidores.qInhibidorINHIBIDOR.Value;
    rentPositiva := DataInhibidores.qInhibidorTOTAL_PERCENT.Value >= 0;
    if not ((inhibidor = 'A') or (inhibidor = 'L')) then begin
      InhibidorLargo.Brush.Color := clLime;
    end
    else begin
      if rentPositiva then
        InhibidorLargo.Brush.Color := $0000D2D2
      else
        InhibidorLargo.Brush.Color := clRed;
    end;
    if not ((inhibidor = 'A') or (inhibidor = 'C')) then begin
      InhibidorCorto.Brush.Color := clLime;
    end
    else begin
      if rentPositiva then
        InhibidorCorto.Brush.Color := $0000D2D2
      else
        InhibidorCorto.Brush.Color := clRed;
    end;
  end;

  PaintInhibidoresHistorico;
end;

procedure TfrPanelInhibidores.PaintInhibidoresHistorico;
var inspect: TInspectDataSet;
  field: TStringField;
  CanvasLargo, CanvasCorto: TCanvas;
  x, ancho, alto: integer;
  rentPositiva: boolean;

    procedure Clear(Canvas: TCanvas);
    begin
      Canvas.Pen.Style := psClear;
      Canvas.Brush.Color := clNone;
      Canvas.FillRect(Rect(0, 0, ancho, alto));
    end;
begin
  CanvasLargo := iHistoricoLargo.Picture.Bitmap.Canvas;
  CanvasCorto := iHistoricoCorto.Picture.Bitmap.Canvas;
  alto := iHistoricoLargo.Height;
  ancho := iHistoricoLargo.Width;
  Clear(CanvasLargo);
  Clear(CanvasCorto);
  ancho := ancho div 20;
  inspect := StartInspectDataSet(DataInhibidores.qInhibidor);
  try
    field := DataInhibidores.qInhibidorINHIBIDOR;
    DataInhibidores.qInhibidor.First;
    x := iHistoricoLargo.Width;
    while not DataInhibidores.qInhibidor.Eof do begin
      if field.IsNull then begin
        CanvasLargo.Brush.Color := clGreen;
        CanvasCorto.Brush.Color := clGreen;
      end
      else begin
        rentPositiva := DataInhibidores.qInhibidorTOTAL_PERCENT.Value >= 0;
        if field.Value = 'C' then begin
          CanvasLargo.Brush.Color := clGreen;
          if rentPositiva then
            CanvasCorto.Brush.Color := $0000D2D2
          else
            CanvasCorto.Brush.Color := clRed;
        end
        else begin
          if field.Value = 'L' then begin
            if rentPositiva then
              CanvasLargo.Brush.Color := $0000D2D2
            else
              CanvasLargo.Brush.Color := clRed;
            CanvasCorto.Brush.Color := clGreen;
          end
          else begin
            if rentPositiva then begin
              CanvasLargo.Brush.Color := $0000D2D2;
              CanvasCorto.Brush.Color := $0000D2D2;
            end
            else begin
              CanvasLargo.Brush.Color := clRed;
              CanvasCorto.Brush.Color := clRed;
            end;
          end;
        end;
      end;
      CanvasLargo.Rectangle(x - ancho, 0, x, alto);
      CanvasCorto.Rectangle(x - ancho, 0, x, alto);
      x := x - ancho;
      DataInhibidores.qInhibidor.Next;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;


procedure TfrPanelInhibidores.qInhibidorAfterOpen(DataSet: TDataSet);
begin
end;

initialization
  RegisterPanelClass(TfrPanelInhibidores);

end.
