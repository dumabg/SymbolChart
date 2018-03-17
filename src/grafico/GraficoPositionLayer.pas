unit GraficoPositionLayer;

interface

uses GR32_Layers, Contnrs, Graphics, Windows, GR32, Grafico, Controls,
  Classes, Syncobjs;

const
  POSICION_INDEFINIDA: integer = low(integer);

type
  MessageGraficoPositionChange = class(TMessageGrafico);

  TGraficoPositionLayer = class;

  TGraficoPositionLayer = class(TGraficoDatosLayer)
  private
    FPosition: integer;
    FHelpPointSize: integer;
    FHelpPointActive: boolean;
    HelpPointActualSize: integer;
    FColorPosition: TColor32;
    FColorPositionText: TColor;
    pintarCuadro: boolean;
    FActive: boolean;
    OldActive: Boolean;
    FEnabled: boolean;
    CanPaintActualPosition: boolean;
    PositionBeforeZoom: integer;
    isOnTick: boolean;
    procedure SetColorPosition(const Value: TColor);
    function GetPointRect(const x,y: integer; const HelpPointActual: boolean): TRect;
    procedure SetHelpPointActive(const Value: boolean);
    procedure SetPosition(const Value: integer);
    function GetPositionFecha: TDate;
    procedure SetPositionFecha(const Value: TDate);
    procedure OnBeforeZoomScroll;
    procedure OnAfterZoomScroll;
    procedure OnBeforeSetData;
    procedure OnAfterSetData;
    function GetColorPosition: TColor;
    procedure SetActive(const Value: boolean);
    property HelpPointActive: boolean read FHelpPointActive write SetHelpPointActive;
  protected
    function isInZoomZone: boolean;
    procedure UpdateAll;
    procedure PositionChange; virtual;
    procedure InvalidatePosition(x, y: integer; const pintarCuadro: boolean);
    procedure MoveXToScreenX(const X: integer);
    procedure Paint(Buffer: TBitmap32); override;
    procedure OnMessageTick;
    procedure OnMessageTick2;
    procedure OnTick;
    procedure DoKeyUp(var Key: Word;  Shift: TShiftState); override;
    procedure RecalculateTransformados(const fromPos, toPos: integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function DoHitTest(X, Y: Integer): Boolean; override;
    function GetPosicion(const Fecha: TDate): integer;
  public
    constructor Create(Grafico: TGrafico); override;
    destructor Destroy; override;
    procedure HelpPoint;
    procedure Siguiente;
    procedure Anterior;
    procedure Primero(const considerarZoom: boolean);
    procedure Ultimo(const considerarZoom: boolean);
    property Position: integer read FPosition write SetPosition;
    property PositionFecha: TDate read GetPositionFecha write SetPositionFecha;
    property HelpPointSize: integer read FHelpPointSize write FHelpPointSize default 32;
    property ColorPosition: TColor read GetColorPosition write SetColorPosition;
    property Active: boolean read FActive write SetActive;
    property Enabled: boolean read FEnabled write FEnabled;
  end;

  TDefaultGraficoPositionLayer = class(TGraficoPositionLayer)
  protected
    procedure PositionChange; override;
  end;


implementation

uses Types, SysUtils, Tipos, GraficoZoom, uTickService, uServices,
  BusCommunication, dmData, DatosGrafico;

resourcestring
  SESION_SIN_COTIZAR = 'Sesión sin cotizar';

const
  HELP_POINT_SIZE: integer = 32;
  POSICION_PRIMERO_CON_CAMBIOS = -1;

{ TGraficoPositionLayer }

procedure TGraficoPositionLayer.Anterior;
begin
  if FPosition > 0 then
    Position := Position - 1;
end;

procedure TGraficoPositionLayer.OnBeforeZoomScroll;
begin
  PositionBeforeZoom := FPosition;
end;

constructor TGraficoPositionLayer.Create(Grafico: TGrafico);
begin
  inherited Create(Grafico);
  FColorPosition := clWhite32;
  FColorPositionText := clWhite;
  FHelpPointActive := false;
  FHelpPointSize := HELP_POINT_SIZE;
  Location := FloatRect(0, 0, Grafico.Width, Grafico.Height);
  FPosition := POSICION_INDEFINIDA;
  FActive := false;
  FEnabled := true;
  CanPaintActualPosition := false;
  Grafico.RegisterEvent(MessageGraficoBeforeSetData, OnBeforeSetData);
  Grafico.RegisterEvent(MessageGraficoAfterSetData, OnAfterSetData);
  Grafico.RegisterEvent(MessageGraficoAfterZoom, OnAfterZoomScroll);
  Grafico.RegisterEvent(MessageGraficoBeforeZoom, OnBeforeZoomScroll);
  Grafico.RegisterEvent(MessageGraficoAfterScroll, OnAfterZoomScroll);
  Grafico.RegisterEvent(MessageGraficoBeforeScroll, OnBeforeZoomScroll);
  Bus.RegisterEvent(MessageTick, OnMessageTick);
  Bus.RegisterEvent(MessageTick2, OnMessageTick2);
end;

destructor TGraficoPositionLayer.Destroy;
begin
  Bus.UnregisterEvent(MessageTick, OnMessageTick);
  Bus.UnregisterEvent(MessageTick2, OnMessageTick2);
  Grafico.UnregisterEvent(MessageGraficoBeforeSetData, OnBeforeSetData);
  Grafico.UnregisterEvent(MessageGraficoAfterSetData, OnAfterSetData);
  Grafico.UnregisterEvent(MessageGraficoAfterZoom, OnAfterZoomScroll);
  Grafico.UnregisterEvent(MessageGraficoBeforeZoom, OnBeforeZoomScroll);
  Grafico.UnregisterEvent(MessageGraficoAfterScroll, OnAfterZoomScroll);
  Grafico.UnregisterEvent(MessageGraficoBeforeScroll, OnBeforeZoomScroll);
  inherited Destroy;
end;

function TGraficoPositionLayer.DoHitTest(X, Y: Integer): Boolean;
begin
  result := FEnabled and FActive;
end;

procedure TGraficoPositionLayer.DoKeyUp(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_LEFT, VK_DOWN : begin
            Anterior;
             Key := 0;
            end;
    VK_RIGHT, VK_UP : begin
            Siguiente;
              Key := 0;
            end;
    VK_END: begin
            Ultimo(true);
            Key := 0;
            end;
    VK_HOME: begin
            Primero(true);
            Key := 0;
            end;
  end;
end;

function TGraficoPositionLayer.GetColorPosition: TColor;
begin
  result := FColorPositionText;
end;

function TGraficoPositionLayer.GetPointRect(const x, y: integer;
  const HelpPointActual: boolean): TRect;
begin
  if HelpPointActive then begin
    if HelpPointActual then
      result := Rect(x-HelpPointActualSize-2, y-HelpPointActualSize-2,
                     x+HelpPointActualSize+2, y+HelpPointActualSize+2)
    else
      result := Rect(x-FHelpPointSize-2, y-FHelpPointSize-2,
                     x+FHelpPointSize+2, y+FHelpPointSize+2);
  end
  else
    result := Rect(x-2, y-2, x+2, y+2);
end;

function TGraficoPositionLayer.GetPosicion(const Fecha: TDate): integer;
var i, num: integer;
begin
  num := Datos.DataCount - 1;
  for i := num downto 0 do begin
    if not Datos.IsSinCambio[i] then
      if Datos.Fechas[i] <= Fecha then begin
        result := i;
        exit;
      end;
  end;
  result := -1;
end;

function TGraficoPositionLayer.GetPositionFecha: TDate;
begin
  if FPosition <> POSICION_INDEFINIDA then
    result := Datos.Fechas[FPosition]
  else
    result := 0;
end;

procedure TGraficoPositionLayer.HelpPoint;
var zoom: TZoom;
begin
  if not HelpPointActive then begin
    zoom := TZoomGrafico(Grafico).ZoomInterval;
    if FPosition > zoom.ZoomTo then begin
      TZoomGrafico(Grafico).Scroll(FPosition - zoom.ZoomTo);
    end
    else begin
      if FPosition < zoom.ZoomFrom then
        TZoomGrafico(Grafico).Scroll(FPosition - zoom.ZoomFrom);
    end;
    HelpPointActive := true;
    HelpPointActualSize := FHelpPointSize;
  end;
end;

procedure TGraficoPositionLayer.InvalidatePosition(x, y: integer; const pintarCuadro: boolean);
var r: TRect;
  anchoTexto: integer;
begin
  if not FActive then
    Exit;

  if Datos.IsDataNull[FPosition] then begin
    // Al arrancar se hace un HelpPointActive.
    // Si la posición donde se está no hay cotización, se queda el
    // HelpPointActive activo porque nunca se pasa por el else de abajo y no
    // se llama a getPointRect, que es la función que desactiva el HelpPoint
    // cuando ha hecho todo el efecto.
    // Como consecuencia se ve el "sin cotización" parpadeando muy rápido,
    // a 100, que es la velocidad del HelpPoint
    HelpPointActive := false;
    r.Right := x;
    r.Top := 0;
    Grafico.Bitmap.Font.Size := 10;

    anchoTexto := Grafico.Bitmap.TextWidth(SESION_SIN_COTIZAR);
    r.Left := x - 4 - anchoTexto;
    if r.Left <= 1 then begin
      r.Left := x + 4;
      r.Right := x + 4 + anchoTexto;
    end;
    r.Bottom := Grafico.Height;
    Update(r);
  end
  else begin
    if CanPaintActualPosition then begin
      UpdateAll;
    end
    else begin
      r := getPointRect(x + 1, y, false);
      Update(r);
    end;
  end;
end;

function TGraficoPositionLayer.isInZoomZone: boolean;
var zoom: TZoom;
begin
  if Grafico is TZoomGrafico then begin
    zoom := TZoomGrafico(Grafico).ZoomInterval;
    result := (not TZoomGrafico(Grafico).IsZommed) or
      ((zoom.ZoomFrom <= FPosition) and (zoom.ZoomTo >= FPosition));
  end
  else
    result := true;
end;

procedure TGraficoPositionLayer.MoveXToScreenX(const X: integer);
var i, iFrom, iTo, beginPos: integer;
  zoom: TZoom;
begin
  if Grafico is TZoomGrafico then begin
    if TZoomGrafico(Grafico).IsZommed then begin
      zoom := TZoomGrafico(Grafico).ZoomInterval;
      if X >= Grafico.Width then begin
        Position := zoom.ZoomTo + 1;
        exit;
      end
      else begin
        if X <= 0 then begin
          Position := zoom.ZoomFrom - 1;
          exit;
        end
        else begin
          iTo := zoom.ZoomTo;
          iFrom := 0;
        end;
      end;
    end
    else begin
      iTo := Datos.DataCount - 1;
      iFrom := 0;
    end;
  end
  else begin
    iTo := Datos.DataCount - 1;
    iFrom := 0;
  end;
  i := iTo;

  if X >= Grafico.Width then
    Ultimo(true)
  else begin
    if X <= 0 then
      Primero(true)
    else begin
      while i >= iFrom do begin
        if Datos.XTransformados[i] <= X then begin
          if Datos.IsSinCambio[i] then begin
            beginPos := i;
            // Vamos hacia la izquierda hasta encontrar un cambio
            dec(i);
            while i >= iFrom do begin
              if not Datos.IsSinCambio[i] then begin
                Position := i;
                exit;
              end;
              dec(i);
            end;
            // Hacia la izquierda no hemos encontrado nada, vamos hacia la derecha
            i := beginPos + 1;
            while i <= iTo do begin
              if not Datos.IsSinCambio[i] then begin
                Position := i;
                exit;
              end;
              inc(i);
            end;
          end
          else
            Position := i;
          exit;
        end;
        dec(i);
      end;
    end;
  end;
end;

procedure TGraficoPositionLayer.MouseDown(
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    if Grafico is TZoomGrafico then begin
      if not TZoomGrafico(Grafico).ZoomActive then begin
        CanPaintActualPosition := true;
        MoveXToScreenX(X);
      end;
    end
    else begin
      CanPaintActualPosition := true;
      MoveXToScreenX(X);
    end;
  end;
end;

procedure TGraficoPositionLayer.MouseMove(Shift: TShiftState;
  X, Y: Integer);
begin
  if Shift = [ssLeft] then begin
    if Grafico is TZoomGrafico then begin
      if not TZoomGrafico(Grafico).ZoomActive then begin
        CanPaintActualPosition := true;
        MoveXToScreenX(X);
      end;
    end
    else begin
      CanPaintActualPosition := true;
      MoveXToScreenX(X);
    end;
  end;
end;

procedure TGraficoPositionLayer.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    if Grafico is TZoomGrafico then begin
      if not TZoomGrafico(Grafico).ZoomActive then begin
        CanPaintActualPosition := false;
        MoveXToScreenX(X);
      end;
    end
    else begin
      CanPaintActualPosition := false;
      MoveXToScreenX(X);
    end;
    pintarCuadro := true;
    UpdateAll;
  end;
end;

procedure TGraficoPositionLayer.OnBeforeSetData;
begin
  OldActive := FActive;
  FPosition := POSICION_INDEFINIDA;
  FActive := False;
end;

procedure TGraficoPositionLayer.OnMessageTick;
begin
  pintarCuadro := true;
  OnTick;
end;

procedure TGraficoPositionLayer.OnMessageTick2;
begin
  pintarCuadro := false;
  OnTick;
end;

procedure TGraficoPositionLayer.OnTick;
var x, y: integer;
begin
  isOnTick := true;
  try
    if (FActive) and (FPosition <> POSICION_INDEFINIDA) and (FPosition < Datos.DataCount) and
      (isInZoomZone) then begin
      if HelpPointActive then begin
        HelpPointActive := HelpPointActualSize > 0;
        HelpPointActualSize := HelpPointActualSize - 4;
      end;
      x := Datos.XTransformados[FPosition];
      y := Datos.YTransformados[FPosition];
      if y <> SIN_CAMBIO_TRANSFORMADO then
        InvalidatePosition(x, y, pintarCuadro);
    end;
  finally
    isOnTick := false;
  end;
end;

procedure TGraficoPositionLayer.OnAfterSetData;
begin
  FActive := OldActive;
end;

procedure TGraficoPositionLayer.OnAfterZoomScroll;
begin
  // MUY IMPORTANTE: Debe asignarse a FPosition, no a Position, ya que asignar
  // a Position significa que si la posición no está visible se ará scroll y lo
  // único que necesitamos es retablecer la posición porque al hacer Zoom se hace
  // un Recalculate y la posición pasa a indefinida.
  FPosition := PositionBeforeZoom;
end;

procedure TGraficoPositionLayer.Paint(Buffer: TBitmap32);
var x, y, anchoTexto: integer;
  r: TRect;

  procedure ShowPositionEjeY;
  var x, decimals: integer;
  begin
    x := Grafico.Width - Grafico.AnchoEjeY;
    Buffer.FillRectS(x, y - 6, Grafico.Width - 1, y + 6, clPurple32);
    if Grafico.ShowDecimals then begin
      if Grafico.IsManualDecimals then
        decimals := Grafico.ManualDecimals
      else
        decimals := CurrencyDecimals;
    end
    else
      decimals := 0;
    Buffer.Textout(x + 3, y - 7, CurrToStrF(Datos.Cambio[FPosition], ffCurrency, decimals));
  end;

  procedure ShowPositionEjeX;
  var x, y, anchoText: integer;
    text: string;
  begin
    y := Grafico.Height - 13;
    text := DateToStr(Datos.Fechas[FPosition]);
    anchoText := Buffer.TextWidth(text);
    x := Datos.XTransformados[FPosition] - (anchoText div 2);
    if x < 2 then
      x := 2;
    Buffer.FillRectS(x - 4, y + 2, x + anchoText + 4, y + 13, clPurple32);
    Buffer.Textout(x, y, text);
  end;

  procedure ShowPositionEjes(showY: boolean);
  begin
    Buffer.Font.Size := 8;
    if (Grafico.ShowY) and (showY) then
      ShowPositionEjeY;
    if Grafico.ShowX then
      ShowPositionEjeX;
  end;

begin
  if (FActive) and (FPosition <> POSICION_INDEFINIDA) and (isInZoomZone) then begin
    Buffer.Font.Color := clWhite;
    if Datos.IsCambio[FPosition] then begin
      x := Datos.XTransformados[FPosition];
      y := Datos.YTransformados[FPosition];
      if CanPaintActualPosition then begin
        Buffer.SetStipple([FColorPosition, FColorPosition, FColorPosition, 0, 0, 0]);
        Buffer.HorzLineTSP(0, y, Grafico.Width);
        Buffer.VertLineTSP(x, 0, Grafico.Height);
      end;
      ShowPositionEjes(true);
      if pintarCuadro then begin
        // El punto indicando la posición
        r := getPointRect(x + 1, y, true);
        Buffer.FillRectS(r.Left, r.Top, r.Right, r.Bottom, FColorPosition);
      end;
    end
    else begin
      if Datos.IsDataNull[FPosition] then begin
        x := Datos.XTransformados[FPosition];
        y := Datos.YTransformados[FPosition];
        ShowPositionEjes(False);
        Buffer.Font.Color := FColorPositionText;
        Buffer.Font.Size := 10;
        Buffer.VertLineS(x, 0, Grafico.Alto, FColorPosition);
        anchoTexto := Grafico.Bitmap.TextWidth(SESION_SIN_COTIZAR);
        if x - anchoTexto <= 1 then
          x := x + 4
        else
          x := x - 4 - anchoTexto;
        Buffer.Textout(x, 10, SESION_SIN_COTIZAR);
      end;
    end;
  end;
end;

procedure TGraficoPositionLayer.PositionChange;
begin
  UpdateAll;
  SendEvent(MessageGraficoPositionChange);
end;

procedure TGraficoPositionLayer.Primero(const considerarZoom: boolean);
var from: integer;
begin
  if Datos.DataCount > 0 then begin
    if considerarZoom then begin
      from := TZoomGrafico(Grafico).ZoomInterval.ZoomFrom;
      if Position = from then
        Position := POSICION_PRIMERO_CON_CAMBIOS
      else
        Position := from;
    end
    else
      Position := POSICION_PRIMERO_CON_CAMBIOS;
  end
  else
    Position := POSICION_INDEFINIDA;
end;

procedure TGraficoPositionLayer.RecalculateTransformados(const fromPos,
  toPos: integer);
begin
end;

procedure TGraficoPositionLayer.SetActive(const Value: boolean);
begin
  FActive := Value;
  //Si esta en el tick, debemos esperar a que acabe, sino podría pasar que
  //se modifiquen los datos en medio de un tick, por lo que daría access violation
  while isOnTick do;
end;

procedure TGraficoPositionLayer.SetColorPosition(const Value: TColor);
begin
  FColorPositionText := Value;
  FColorPosition := Color32(Value);
end;

procedure TGraficoPositionLayer.SetHelpPointActive(const Value: boolean);
var TickService: TTickService;
begin
  if FHelpPointActive <> Value then begin
    FHelpPointActive := Value;
    TickService := TTickService(Services.GetService(TTickService));
    if FHelpPointActive then
      TickService.Interval := 100
    else
      TickService.Interval := DEFAULT_FLASH_INTERVAL;
  end;
end;

procedure TGraficoPositionLayer.SetPosition(const Value: integer);
var zoom: TZoom;
  i, num: integer;
begin
  if FPosition <> Value then begin
    if (FPosition <> POSICION_INDEFINIDA) and (FActive) and (FPosition < Datos.DataCount) then
       //Invalidate previous position
      InvalidatePosition(Datos.XTransformados[FPosition], Datos.YTransformados[FPosition], false);
    // New position
    if Value < 0 then begin
      i := 0;
      while Datos.IsSinCambio[i] do
        inc(i);
      FPosition := i;
    end
    else begin
      num := Datos.DataCount - 1;
      if Value > num then begin
        i := num;
        while Datos.IsSinCambio[i] do
          dec(i);
        FPosition := i;
      end
      else begin
        i := Value;
        while (i < num) and (Datos.IsSinCambio[i]) do
          inc(i);
        if Datos.IsSinCambio[i] then begin
          while (i > 0) and (Datos.IsSinCambio[i]) do
            dec(i);
        end;
        if Datos.IsSinCambio[i] then
          FPosition := POSICION_INDEFINIDA
        else
          FPosition := i;
      end;
    end;
    if Grafico is TZoomGrafico then begin
      zoom := TZoomGrafico(Grafico).ZoomInterval;
      if not TZoomGrafico(Grafico).IsZommed then
        InvalidatePosition(Datos.XTransformados[FPosition], Datos.YTransformados[FPosition], true)
      else begin
        if zoom.ZoomTo < FPosition then
          TZoomGrafico(Grafico).Scroll(FPosition - zoom.ZoomTo)
        else
          if zoom.ZoomFrom > FPosition then
            TZoomGrafico(Grafico).Scroll(FPosition - zoom.ZoomFrom)
          else
            InvalidatePosition(Datos.XTransformados[FPosition], Datos.YTransformados[FPosition], true);
      end;
    end
    else
      InvalidatePosition(Datos.XTransformados[FPosition], Datos.YTransformados[FPosition], true);
    PositionChange;
  end;
end;

procedure TGraficoPositionLayer.SetPositionFecha(const Value: TDate);
var i: integer;
begin
  i := GetPosicion(Value);
  if i <> -1 then
    Position := i;
end;

procedure TGraficoPositionLayer.Siguiente;
begin
  if FPosition < Datos.DataCount - 1 then
    Position := Position + 1;
end;

procedure TGraficoPositionLayer.Ultimo(const considerarZoom: boolean);
var from: integer;
begin
  if Datos.DataCount > 0 then begin
    if considerarZoom then begin
      from := TZoomGrafico(Grafico).ZoomInterval.ZoomTo;
      if Position = from then
        Position := Datos.DataCount - 1
      else
        Position := from;
    end
    else
      Position := Datos.DataCount - 1;
  end
  else
    Position := POSICION_INDEFINIDA;
end;

procedure TGraficoPositionLayer.UpdateAll;
begin
  Update(Rect(0, 0, Grafico.Width, Grafico.Height));
end;

{ TDefaultGraficoPositionLayer }

procedure TDefaultGraficoPositionLayer.PositionChange;
begin
  if (Position <> POSICION_INDEFINIDA) and (Position < Datos.DataCount) then
    Data.IrACotizacionConFecha(Datos.Fechas[Position]);
  inherited PositionChange;
end;

end.
