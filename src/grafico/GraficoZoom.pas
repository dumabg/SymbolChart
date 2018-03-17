unit GraficoZoom;

interface

uses
  Grafico, GR32, Graphics, Classes, Controls, Tipos, ExtCtrls, GR32_Layers, Messages;

const
  ZOOM_ALL = -9999;

type
  MessageGraficoAfterZoom = class(TMessageGrafico);
  MessageGraficoBeforeZoom = class(TMessageGrafico);
  MessageGraficoAfterScroll = class(TMessageGrafico);
  MessageGraficoBeforeScroll = class(TMessageGrafico);

  TScrollButton = (sbIzquierdo, sbDerecho, sbNinguno);

  TZoom = record
     ZoomFrom, ZoomTo: integer;
  end;

  TZoomGrafico = class(TGrafico)
  private
    FColorZoom: TColor32;
    ZoomX: integer;
    FZoomActive: boolean;
    TimerScroll: TTimer;
    ScrollButtons: array[1..4] of TBitmapLayer;
    FShowScrollButtons: Boolean;
    FCursorAnterior: TCursor;
    function GetColorZoom: TColor;
    procedure SetColorZoom(const Value: TColor);
    function GetZoomInterval: TZoom;
    procedure SetZoomActive(const Value: boolean);
    procedure OnTimerScroll(Sender: TObject);
    procedure CreateScrollButtons;
    procedure ReposicionarScrollButtons;
    procedure DestroyScrollButtons;
    procedure VisibleScrollButtons(const left, visible: boolean);
    procedure InitializeZoom(const dataCount: integer);
    function GetIsZommed: boolean;
    function IsInScrollButton(const X, Y: integer): TScrollButton;
    procedure SetShowScrollButtons(const Value: Boolean);
  protected
    ZoomHistoryData: array of TZoom;
    ZoomHistoryPos: integer;
//    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    procedure RecalculateMaxMin; override;
    procedure RecalculateTransformados(const fromPos, toPos: integer); overload; override;
    procedure PaintGraphicPositions; overload; override;
    procedure PaintX; overload; override;
    procedure PaintY; overload; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure BeforeScroll; virtual;
    procedure AfterScroll; virtual;
    procedure AfterZoom; virtual;
    procedure BeforeZoom; virtual;
    procedure PaintGrafico; override;
    procedure PaintZoomGrafico(const iFrom, iTo: integer); virtual; abstract;
    procedure CalculateAnchoEjeY; override;
    procedure AssignZoomData(zoomGrafico: TZoomGrafico); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Recalculate; override;
    procedure SetData(const PCambios: PArrayCurrency; const PFechas: PArrayDate); override;
    procedure AssignZoom(zoomGrafico: TZoomGrafico);
    procedure Scroll(const value: integer);
    procedure Zoom(iFrom, iTo: integer);
    procedure ZoomScreen(xFrom, xTo: integer);
    procedure ZoomSesiones(const numSesiones: integer);
    procedure ZoomAll;
    procedure ZoomBack;
    procedure ZoomNext;
    procedure ClearZoom;
    function CanZoomBack: boolean;
    function CanZoomNext: boolean;
    property IsZommed: boolean read GetIsZommed;
    property ZoomInterval: TZoom read GetZoomInterval;
    property ZoomActive: boolean read FZoomActive write SetZoomActive default true;
    property ColorZoom: TColor read GetColorZoom write SetColorZoom;
    property ShowScrollButtons: Boolean read FShowScrollButtons write SetShowScrollButtons;
  end;


  TIncrustedDatosZoomLayer = class(TIncrustedDatosLayer)
  protected
    procedure RecalculateZoom;
    procedure BeforeScroll; virtual;
    procedure AfterScroll; virtual;
    procedure BeforeZoom; virtual;
    procedure AfterZoom; virtual;
    procedure OnGraficoResize; override;
  end;

implementation

uses
  Windows, Forms, SysUtils, BusCommunication;

const
  fpcGraficoZoom = 1;
  SCROLL_BUTTON_IZQ = 0;
  SCROLL_BUTTON_DER = 1;
  MIN_ZOOM = 20;


{ TZoomGrafico }

procedure TZoomGrafico.AssignZoom(zoomGrafico: TZoomGrafico);
begin
  BeforeZoom;
  AssignZoomData(zoomGrafico);
  Recalculate;
  AfterZoom;
  InvalidateGrafico;
end;

procedure TZoomGrafico.AssignZoomData(zoomGrafico: TZoomGrafico);
var i, num: integer;
  zoom: TZoom;
begin
  ZoomHistoryData := Copy(zoomGrafico.ZoomHistoryData, 0, length(zoomGrafico.ZoomHistoryData));
  ZoomHistoryPos := zoomGrafico.ZoomHistoryPos;
  num := Datos.DataCount - 1;
  for i := Low(ZoomHistoryData) to High(ZoomHistoryData) do begin
    zoom := ZoomHistoryData[i];
    if zoom.ZoomTo > num then begin
      ZoomHistoryData[i].ZoomTo := num;
      ZoomHistoryData[i].ZoomFrom := zoom.ZoomTo - num;
      if ZoomHistoryData[i].ZoomFrom < 0 then
        ZoomHistoryData[i].ZoomFrom := 0;
    end;
    if zoom.ZoomFrom > num then
      ZoomHistoryData[i].ZoomFrom := 0;
  end;
end;

procedure TZoomGrafico.BeforeScroll;
var i, num: integer;
  layer: TIncrustedLayer;
begin
  num := IncrustedLayersBefore.Count - 1;
  for i := 0 to num do begin
    layer := TIncrustedLayer(IncrustedLayersBefore[i]);
    if layer is TIncrustedDatosZoomLayer then
      TIncrustedDatosZoomLayer(layer).BeforeScroll;
  end;
  num := IncrustedLayersAfter.Count - 1;
  for i := 0 to num do begin
    layer := TIncrustedLayer(IncrustedLayersAfter[i]);
    if layer is TIncrustedDatosZoomLayer then
      TIncrustedDatosZoomLayer(layer).BeforeScroll;
  end;
  BusGrafico.SendEvent(MessageGraficoBeforeScroll);
end;

procedure TZoomGrafico.BeforeZoom;
var i, num: integer;
  layer: TIncrustedLayer;
begin
  num := IncrustedLayersBefore.Count - 1;
  for i := 0 to num do begin
    layer := TIncrustedLayer(IncrustedLayersBefore[i]);
    if layer is TIncrustedDatosZoomLayer then
      TIncrustedDatosZoomLayer(layer).BeforeZoom;
  end;
  num := IncrustedLayersAfter.Count - 1;
  for i := 0 to num do begin
    layer := TIncrustedLayer(IncrustedLayersAfter[i]);
    if layer is TIncrustedDatosZoomLayer then
      TIncrustedDatosZoomLayer(layer).BeforeZoom;
  end;
  BusGrafico.SendEvent(MessageGraficoBeforeZoom);
end;

procedure TZoomGrafico.CalculateAnchoEjeY;
var Zoom: TZoom;
begin
  Zoom := ZoomInterval;
  if Zoom.ZoomFrom = ZOOM_ALL then
    inherited
  else begin
    Datos.RecalculateMaxMin(Zoom.ZoomFrom, Zoom.ZoomTo);
    CalculateAnchoEjeY(Datos.Maximo, Datos.Minimo);
  end;
end;

function TZoomGrafico.CanZoomBack: boolean;
begin
  result := ZoomHistoryPos > Low(ZoomHistoryData) + 1;
end;

function TZoomGrafico.CanZoomNext: boolean;
begin
  result := ZoomHistoryPos <= High(ZoomHistoryData); // zero based
end;

procedure TZoomGrafico.ClearZoom;
begin
  BeforeZoom;
  InitializeZoom(Datos.DataCount);
  Recalculate;
  AfterZoom;
  InvalidateGrafico;  
end;

constructor TZoomGrafico.Create(AOwner: TComponent);
var layerMouse: TBitmapLayer;
begin
  inherited Create(AOwner);
  FCursorAnterior := crDefault;
  layerMouse := TBitmapLayer.Create(Layers);
  layerMouse.Visible := false;
  layerMouse.Location := FloatRect(-1, 0, -1, Height);
  ZoomActive := true;
  ColorZoom := clGreen;
end;

procedure TZoomGrafico.CreateScrollButtons;
  procedure CreateButton(const i, tipo: integer; ResourceName: string);
  var L: TBitmapLayer;
  begin
    L := TBitmapLayer.Create(Layers);
    L.Bitmap.SetSize(8, 16);
    L.Bitmap.DrawMode := dmBlend;
    L.Bitmap.MasterAlpha := 100;
    L.Bitmap.LoadFromResourceName(HInstance, ResourceName);
    L.Visible := false;
    L.Tag := tipo;
    ScrollButtons[i] := L;
  end;
begin
  TimerScroll := TTimer.Create(nil);
  TimerScroll.Enabled := false;
  TimerScroll.Interval := 5;
  TimerScroll.OnTimer := OnTimerScroll;
  CreateButton(1, SCROLL_BUTTON_IZQ, 'SCROLL_IZQ');
  CreateButton(2, SCROLL_BUTTON_IZQ, 'SCROLL_IZQ');
  CreateButton(3, SCROLL_BUTTON_DER, 'SCROLL_DER');
  CreateButton(4, SCROLL_BUTTON_DER, 'SCROLL_DER');
end;

destructor TZoomGrafico.Destroy;
begin
  if FShowScrollButtons then
    DestroyScrollButtons;
  inherited;
end;

procedure TZoomGrafico.DestroyScrollButtons;
var i, j: integer;
begin
  FreeAndNil(TimerScroll);
  for i := 1 to 4 do begin
    // El index devuelve -1 cuando se cierra la aplicación
    j := ScrollButtons[i].Index;
    if j <> -1 then
      Layers.Delete(j);
  end;
end;

{function TZoomGrafico.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  Zoom(ZoomHistoryData[ZoomHistoryPos - 1].ZoomFrom + WheelDelta,
    ZoomHistoryData[ZoomHistoryPos - 1].ZoomTo + WheelDelta);
  result := true;
end;}

function TZoomGrafico.GetColorZoom: TColor;
begin
  result := WinColor(FColorZoom);
end;

function TZoomGrafico.GetIsZommed: boolean;
begin
  result := ZoomHistoryData[ZoomHistoryPos - 1].ZoomFrom <> ZOOM_ALL;
end;

function TZoomGrafico.GetZoomInterval: TZoom;
begin
  result.ZoomFrom := ZoomHistoryData[ZoomHistoryPos - 1].ZoomFrom;
  if result.ZoomFrom = ZOOM_ALL then begin
    result.ZoomFrom := 0;
    result.ZoomTo := Datos.DataCount - 1;
  end
  else
    result.ZoomTo := ZoomHistoryData[ZoomHistoryPos - 1].ZoomTo;
end;

procedure TZoomGrafico.InitializeZoom(const dataCount: integer);
var from: integer;
begin
  ZoomHistoryPos := 1;
  SetLength(ZoomHistoryData, 1);
  from := dataCount - 640;
  if from < 0 then
    from := 0;
  ZoomHistoryData[0].ZoomFrom := from;
  ZoomHistoryData[0].ZoomTo := dataCount - 1;
end;

function TZoomGrafico.IsInScrollButton(const X, Y: integer): TScrollButton;
var i: integer;
  loc: TFloatRect;
  scrollButton: TBitmapLayer;
begin
  if FShowScrollButtons then begin
    for i := Low(ScrollButtons) to High(ScrollButtons) do begin
      scrollButton := ScrollButtons[i];
      if scrollButton.Visible then begin
        loc := scrollButton.Location;
        if (loc.Left - 4 <= X) and (loc.Right + 4 >= X) and
          (loc.Top - 4 <= Y) and (loc.Bottom + 4 >= Y) then begin
          if scrollButton.Tag = SCROLL_BUTTON_IZQ then
            result := sbIzquierdo
          else
            result := sbDerecho;
          exit;
        end;
      end;
    end;
  end;
  result := sbNinguno;
end;

procedure TZoomGrafico.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var scrollButton: TScrollButton;
begin
  if FZoomActive then begin
    ZoomX := X;
    TBitmapLayer(layers[0]).Location := FloatRect(X, 0, X, Height);
  end;
  Layers[0].Visible := FZoomActive;
  scrollButton := IsInScrollButton(X, Y);
  if TimerScroll <> nil then
    TimerScroll.Enabled := scrollButton <> sbNinguno;
  case scrollButton of
    sbIzquierdo : Scroll(-1);
    sbDerecho : Scroll(1);
    sbNinguno : inherited MouseDown(Button, Shift, X, Y);
  end;
end;

procedure TZoomGrafico.MouseMove(Shift: TShiftState; X, Y: Integer);
var scrollButton: TScrollButton;
begin
  if not (Shift = [ssLeft]) then
    scrollButton :=  sbNinguno
  else
    scrollButton := IsInScrollButton(X, Y);
  if TimerScroll <> nil then
    TimerScroll.Enabled := scrollButton <> sbNinguno;
  if scrollButton = sbNinguno then begin
    if Layers[0].Visible then begin
      if ZoomX > X then
        TBitmapLayer(layers[0]).Location := FloatRect(X, 0, ZoomX, Height)
      else
        TBitmapLayer(layers[0]).Location := FloatRect(ZoomX, 0, X, Height);
    end;
    inherited MouseMove(Shift, X, Y);
  end;
end;

procedure TZoomGrafico.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var scrollButton: TScrollButton;
begin
  Layers[0].Visible := false;
  if FZoomActive then
    ZoomScreen(ZoomX, X)
  else begin
    scrollButton := IsInScrollButton(X, Y);
    if TimerScroll <> nil then
      TimerScroll.Enabled := scrollButton <> sbNinguno;
    if scrollButton = sbNinguno then
      inherited MouseUp(Button, Shift, X, Y);
  end;
end;

procedure TZoomGrafico.OnTimerScroll(Sender: TObject);
var p: TPoint;
begin
  if TimerScroll <> nil then begin
    if GetAsyncKeyState(VK_LBUTTON) <> 0 then begin
      p := ScreenToClient(Mouse.CursorPos);
      case IsInScrollButton(p.X, p.Y) of
        sbIzquierdo : Scroll(-1);
        sbDerecho : Scroll(1);
        sbNinguno : TimerScroll.Enabled := false;
      end;
    end
    else
      TimerScroll.Enabled := false;
  end;
end;

procedure TZoomGrafico.PaintGrafico;
var Zoom: TZoom;
begin
  Zoom := ZoomInterval;
  PaintZoomGrafico(Zoom.ZoomFrom, Zoom.ZoomTo);
end;

procedure TZoomGrafico.PaintGraphicPositions;
var Zoom: TZoom;
begin
  Zoom := ZoomInterval;
  PaintGraphicPositions(Zoom.ZoomFrom, Zoom.ZoomTo);
end;

procedure TZoomGrafico.PaintX;
var Zoom: TZoom;
begin
  Zoom := ZoomInterval;
  PaintX(Zoom.ZoomFrom, Zoom.ZoomTo);
end;

procedure TZoomGrafico.PaintY;
var Zoom: TZoom;
begin
  Zoom := ZoomInterval;
  PaintY(Zoom.ZoomFrom, Zoom.ZoomTo);
end;

procedure TZoomGrafico.Recalculate;
var Zoom: TZoom;
begin
  Zoom := ZoomInterval;
  if Zoom.ZoomFrom = ZOOM_ALL then
    inherited
  else begin
    Recalculate(Zoom.ZoomFrom, Zoom.ZoomTo);
  end;
  ReposicionarScrollButtons;
end;

procedure TZoomGrafico.RecalculateMaxMin;
var Zoom: TZoom;
begin
  Zoom := ZoomInterval;
  if Zoom.ZoomFrom = ZOOM_ALL then
    inherited
  else
    Datos.RecalculateMaxMin(Zoom.ZoomFrom, Zoom.ZoomTo);
end;

procedure TZoomGrafico.RecalculateTransformados(const fromPos, toPos: integer);
var Zoom: TZoom;
begin
  Zoom := ZoomInterval;
  if Zoom.ZoomFrom = ZOOM_ALL then
    inherited RecalculateTransformados(0, Datos.DataCount - 1)
  else
    inherited RecalculateTransformados(Zoom.ZoomFrom, Zoom.ZoomTo);
  ReposicionarScrollButtons;
end;

procedure TZoomGrafico.ReposicionarScrollButtons;
var ancho, alto: integer;
  zoom: TZoom;
  i: integer;
begin
  if FShowScrollButtons then begin
    zoom := ZoomInterval;
    VisibleScrollButtons(true, zoom.ZoomFrom > 0);
    VisibleScrollButtons(false, zoom.ZoomTo < Datos.DataCount - 1);
    ancho := Width;
    alto := Height;
    ScrollButtons[1].Location := FloatRect(3, 3, 17, 19);
    ScrollButtons[2].Location := FloatRect(3, alto - 19, 17, alto - 3);
    ScrollButtons[3].Location := FloatRect(ancho - 17, 3, ancho - 3, 23);
    ScrollButtons[4].Location := FloatRect(ancho - 17, alto - 19, ancho - 3, alto - 3);
    for i := Low(ScrollButtons) to High(ScrollButtons) do
      ScrollButtons[i].BringToFront;
  end;
end;

procedure TZoomGrafico.Scroll(const value: integer);
var max, ZoomFrom, ZoomTo: integer;
  zoom: TZoom;
begin
  zoom := ZoomHistoryData[ZoomHistoryPos - 1];
  if zoom.ZoomFrom <> ZOOM_ALL then begin
    BeforeScroll;
    ZoomFrom := zoom.ZoomFrom + Value;
    ZoomTo := zoom.ZoomTo + Value;
    if ZoomFrom < 0 then begin
      ZoomTo := ZoomTo - ZoomFrom; // - - Se suma la cantidad de desviación
      ZoomFrom := 0;
    end;
    max := Datos.DataCount - 1;
    if ZoomTo > max then begin
      ZoomFrom := ZoomFrom - (ZoomTo - max);
      ZoomTo := max;
    end;
    ZoomHistoryData[ZoomHistoryPos - 1].ZoomFrom := ZoomFrom;
    ZoomHistoryData[ZoomHistoryPos - 1].ZoomTo := ZoomTo;
    Recalculate;
    AfterScroll;
    InvalidateGrafico;
  end;
end;

procedure TZoomGrafico.SetColorZoom(const Value: TColor);
var b: TBitmap32;
 layerMouse: TBitmapLayer;
begin
  FColorZoom := Color32(Value);
  b := TBitmap32.Create;
  try
    b.SetSize(1, 1);
    b.FillRect(0, 0, 1, 1, FColorZoom);
    layerMouse := TBitmapLayer(layers[0]);
    layerMouse.LayerOptions := LOB_NO_CAPTURE;
    layerMouse.Bitmap.Assign(b);
    layerMouse.Bitmap.DrawMode := dmBlend;
    layerMouse.Bitmap.MasterAlpha := 50;
  finally
    b.Free;
  end;
end;

procedure TZoomGrafico.SetData(const PCambios: PArrayCurrency;
  const PFechas: PArrayDate);
var i, max, decrement: integer;
   PZoom: ^TZoom;
begin
  max := length(PCambios^);
  if Length(ZoomHistoryData) = 0 then
    InitializeZoom(max);
  dec(max);
  for i := Low(ZoomHistoryData) to High(ZoomHistoryData) do begin
    PZoom := @ZoomHistoryData[i];
    if (PZoom^.ZoomTo <> ZOOM_ALL) and (PZoom^.ZoomTo > max) then begin
      decrement := PZoom^.ZoomTo - max;
      PZoom^.ZoomTo := max;
      PZoom^.ZoomFrom := PZoom^.ZoomFrom - decrement;
      if PZoom^.ZoomFrom < 0 then
        PZoom^.ZoomFrom := 0;
    end;
  end;
  inherited;
end;

procedure TZoomGrafico.SetShowScrollButtons(const Value: Boolean);
begin
  if FShowScrollButtons <> Value then begin
    FShowScrollButtons := Value;
    if FShowScrollButtons then
      CreateScrollButtons
    else
      DestroyScrollButtons;
    Invalidate;
  end;
end;

procedure TZoomGrafico.SetZoomActive(const Value: boolean);
begin
  FZoomActive := Value;
  if FZoomActive then begin
    FCursorAnterior := Cursor;
    Cursor := fpcGraficoZoom;
  end
  else begin
    //Error en Delphi. Si se hace solo Cursor :=, no funciona, no cambia el cursor.
    Screen.Cursor := FCursorAnterior;
    Cursor := FCursorAnterior;
    Screen.Cursor := crDefault;
  end;
end;

procedure TZoomGrafico.VisibleScrollButtons(const left, visible: boolean);
begin
  if left then begin
    ScrollButtons[1].Visible := visible;
    ScrollButtons[2].Visible := visible;
  end
  else begin
    ScrollButtons[3].Visible := visible;
    ScrollButtons[4].Visible := visible;
  end;
end;

procedure TZoomGrafico.Zoom(iFrom, iTo: integer);
var aux: integer;
begin
  if (iFrom <> ZOOM_ALL) and (Abs(iTo - iFrom) < MIN_ZOOM) then
    exit;
  if iFrom > iTo then begin
    aux := iFrom;
    iFrom := iTo;
    iTo := aux;
  end;
  BeforeZoom;
  inc(ZoomHistoryPos);
  SetLength(ZoomHistoryData, ZoomHistoryPos);
  ZoomHistoryData[ZoomHistoryPos - 1].ZoomFrom := iFrom;
  ZoomHistoryData[ZoomHistoryPos - 1].ZoomTo := iTo;
  Recalculate;
  AfterZoom;
  InvalidateGrafico;
end;

procedure TZoomGrafico.ZoomAll;
begin
  Zoom(ZOOM_ALL, ZOOM_ALL);
end;

procedure TZoomGrafico.ZoomBack;
begin
  if CanZoomBack then begin
    BeforeZoom;
    dec(ZoomHistoryPos);
    Recalculate;
    AfterZoom;
    InvalidateGrafico;
  end;
end;

procedure TZoomGrafico.AfterScroll;
var i, num: integer;
  layer: TIncrustedLayer;
begin
  num := IncrustedLayersBefore.Count - 1;
  for i := 0 to num do begin
    layer := TIncrustedLayer(IncrustedLayersBefore[i]);
    if layer is TIncrustedDatosZoomLayer then
      TIncrustedDatosZoomLayer(layer).AfterScroll;
  end;
  num := IncrustedLayersAfter.Count - 1;
  for i := 0 to num do begin
    layer := TIncrustedLayer(IncrustedLayersAfter[i]);
    if layer is TIncrustedDatosZoomLayer then
      TIncrustedDatosZoomLayer(layer).AfterScroll;
  end;
  BusGrafico.SendEvent(MessageGraficoAfterScroll);
end;

procedure TZoomGrafico.AfterZoom;
var i, num: integer;
  layer: TIncrustedLayer;
begin
  num := IncrustedLayersBefore.Count - 1;
  for i := 0 to num do begin
    layer := TIncrustedLayer(IncrustedLayersBefore[i]);
    if layer is TIncrustedDatosZoomLayer then
      TIncrustedDatosZoomLayer(layer).AfterZoom;
  end;
  num := IncrustedLayersAfter.Count - 1;
  for i := 0 to num do begin
    layer := TIncrustedLayer(IncrustedLayersAfter[i]);
    if layer is TIncrustedDatosZoomLayer then
      TIncrustedDatosZoomLayer(layer).AfterZoom;
  end;
  BusGrafico.SendEvent(MessageGraficoAfterZoom);
end;

procedure TZoomGrafico.ZoomNext;
begin
  if CanZoomNext then begin
    BeforeZoom;
    inc(ZoomHistoryPos);
    Recalculate;
    InvalidateGrafico;
    AfterZoom;
  end;
end;

procedure TZoomGrafico.ZoomScreen(xFrom, xTo: integer);
var iXFrom, iXTo, lon, aux, ZoomTo, ZoomFrom: integer;
  ZoomInterval: TZoom;
begin
  ZoomInterval := GetZoomInterval;
  ZoomFrom := ZoomInterval.ZoomFrom;
  ZoomTo := ZoomInterval.ZoomTo;
  if ZoomTo = ZoomFrom then
    exit;
  if xFrom > xTo then begin
    aux := xFrom;
    xFrom := xTo;
    xTo := aux;
  end;
  if xFrom < 0 then
    xFrom := 0;
  if xTo < 0 then
    xTo := 0;
  if xFrom > Ancho then
    xFrom := Ancho;
  if xTo > Ancho then
    xTo := Ancho;
  lon := ZoomTo - ZoomFrom;
  iXFrom := Round(xFrom * lon / Ancho);
  iXTo := Round(xTo * lon / Ancho);
  if iXFrom <> iXTo then
    Zoom(ZoomFrom + iXFrom, ZoomTo - lon + iXTo);
end;

procedure TZoomGrafico.ZoomSesiones(const numSesiones: integer);
var iFrom, num: integer;
begin
  num := Datos.DataCount - 1;
  iFrom := num - numSesiones;
  if iFrom <  0 then
    iFrom := 0;
  Zoom(iFrom, num);
end;

procedure LoadCursors;
var C: HCURSOR;
begin
    C := LoadCursor(HInstance, 'GRAFICO_ZOOM');
    if C <> 0 then
      Screen.Cursors[fpcGraficoZoom] := C;
end;

{ TIncrustedDatosZoomLayer }

procedure TIncrustedDatosZoomLayer.AfterScroll;
begin
  RecalculateZoom;
end;

procedure TIncrustedDatosZoomLayer.AfterZoom;
begin
  RecalculateZoom;
end;

procedure TIncrustedDatosZoomLayer.BeforeScroll;
begin

end;

procedure TIncrustedDatosZoomLayer.BeforeZoom;
begin

end;

procedure TIncrustedDatosZoomLayer.OnGraficoResize;
var Zoom: TZoom;
begin
  inherited;
  if Grafico is TZoomGrafico then begin
    Zoom := TZoomGrafico(Grafico).ZoomInterval;
    if Zoom.ZoomFrom = ZOOM_ALL then
      RecalculateTransformados(0, DatosLayer.DataCount - 1)
    else
      RecalculateTransformados(Zoom.ZoomFrom, Zoom.ZoomTo);
  end
  else
    RecalculateTransformados(0, DatosLayer.DataCount - 1);
end;

procedure TIncrustedDatosZoomLayer.RecalculateZoom;
var Zoom: TZoom;
begin
  inherited;
  // Se puede disparar el zoom pero el incrusted layer aún está calculando,
  // por lo que solo se debe hacer el zoom si ya hay datos, ya que significa
  // que ya se ha acabado de calcular
  if DatosLayer.DataCount > 0 then begin  
    if Grafico is TZoomGrafico then begin
      Zoom := TZoomGrafico(Grafico).ZoomInterval;
      if Zoom.ZoomFrom = ZOOM_ALL then
        Recalculate(0, DatosLayer.DataCount - 1)
      else
        Recalculate(Zoom.ZoomFrom, Zoom.ZoomTo);
    end
    else
      Recalculate(0, DatosLayer.DataCount - 1);
  end;          
end;

initialization
  LoadCursors;


end.
