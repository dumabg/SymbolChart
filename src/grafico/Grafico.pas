unit Grafico;

interface

uses GR32, Graphics, Classes, GR32_Image, DB, GR32_Layers,
  Messages, BusCommunication, Tipos, Controls, DatosGrafico, Contnrs;

type
  TMessageGrafico = class(TBusMessage);
  TMessageGraficoClass = class of TMessageGrafico;

  MessageGraficoAfterSetData = class(TMessageGrafico);
  MessageGraficoBeforeSetData = class(TMessageGrafico);

  TCustomLayerClass = class of TCustomLayer;

  TIncrustedLayer = class;

  TGrafico = class(TCustomImage32)
  private
    FColorBackGround: TColor32;
    FColorPositions: TColor32;
    FShowPositions: boolean;
    FShowDataHint: boolean;
    FShowY: boolean;
    FShowX: boolean;
    FAncho: Integer;
    FAlto: integer;
    FDatos: TDatosGrafico;
    lastRecalculateFrom, lastRecalculateTo: integer;
    FFixedYValues: PArrayCurrency;
    FShowDecimals: Boolean;
    Decimals: Integer;
    FManualDecimals: integer;
    FisManualDecimals: boolean;
    function GetColorBackGround: TColor;
    procedure SetColorBackGround(const Value: TColor);
    function GetColorPositions: TColor;
    procedure SetColorPositions(const Value: TColor);
    procedure SetShowPositions(const Value: boolean);
    procedure SetShowY(const Value: boolean);
    procedure SetShowX(const Value: boolean);
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure AddIncrustedLayer(const incrustedLayer: TIncrustedLayer; const before: boolean);
    procedure RemoveIncrustedLayer(const incrustedLayer: TIncrustedLayer);
    procedure SetFixedYValues(const Value: PArrayCurrency);
    procedure SetShowDecimals(const Value: Boolean);
    procedure SetManualDecimals(const Value: integer);
  protected
    FAnchoEjeY: Integer;
    FAltoEjeX: integer;    
    IncrustedLayersBefore, IncrustedLayersAfter: TObjectList;
    BusGrafico: TBus;
    procedure RecalculateMaxMin; virtual;
    procedure CalculateAnchoEjeY; overload; virtual;
    procedure CalculateAnchoEjeY(const Maximo, Minimo: currency); overload;
    procedure CalculateAltoEjeX; virtual;
    procedure NoFiller(Dst: PColor32; DstX, DstY, Length: Integer; AlphaValues: PColor32);
    procedure PaintGraphicPositions(const iFrom, iTo: integer); overload;
    procedure PaintGraphicPositions; overload; virtual;
    procedure PaintX(const iFrom, iTo: integer); overload; virtual;
    procedure PaintX; overload; virtual;
    procedure PaintY(const iFrom, iTo: integer); overload;
    procedure PaintY; overload; virtual;
    procedure PaintGrafico; virtual; abstract;
    procedure RecalculateTransformados(const fromPos, toPos: integer); virtual;
    function CreateDatosGrafico: TDatosGrafico; virtual;
    procedure SendEvent(const busMessageClass: TMessageGraficoClass);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RegisterEvent(const busMessageGraficoClass: TMessageGraficoClass;
      const event: TBusMessageEvent);
    procedure UnregisterEvent(const busMessageGraficoClass: TMessageGraficoClass;
      const event: TBusMessageEvent);
    procedure SetData(const PCambios: PArrayCurrency; const PFechas: PArrayDate); virtual;
    procedure DoKeyUp(var Key: Word;  Shift: TShiftState);
    procedure Resize; override;
    procedure Recalculate(const fromPos, toPos: integer); overload; virtual;
    procedure Recalculate; overload; virtual;
    procedure InvalidateGrafico;
    function GetLayerByType(const LayerClassType: TCustomLayerClass): TCustomLayer;
    property Datos: TDatosGrafico read FDatos;
    property ColorBackgroud: TColor read GetColorBackGround write SetColorBackGround default clBlack;
    property ColorPositions: TColor read GetColorPositions write SetColorPositions default $000080FF;
    property ShowPositions: boolean read FShowPositions write SetShowPositions default true;
    property FixedYValues: PArrayCurrency read FFixedYValues write SetFixedYValues;
    property ShowY: boolean read FShowY write SetShowY default true;
    property ShowX: boolean read FShowX write SetShowX default true;
    property Ancho: Integer read FAncho;
    property Alto: integer read FAlto;
    property AnchoEjeY: integer read FAnchoEjeY;
    property AltoEjeX: integer read FAltoEjeX;
    property ShowDecimals: Boolean read FShowDecimals write SetShowDecimals;
    property ManualDecimals: integer read FManualDecimals write SetManualDecimals;
    property IsManualDecimals: boolean read FisManualDecimals;
  end;


  // Las incrustedLayer simulan a una layer, pero se pintan cuando se hace el
  // Paint del bitmap principal, por lo que es como si se pintaran en el bitmap
  // principal
  TIncrustedLayer = class
  private
    FVisible: boolean;
    procedure SetVisible(const Value: boolean);
  protected
    Grafico: TGrafico;
    procedure DoKeyUp(var Key: Word;  Shift: TShiftState); virtual;
    procedure Recalculate(const fromPos, toPos: integer); overload; virtual; abstract;
    procedure RecalculateTransformados(const fromPos, toPos: integer); virtual; abstract;
    procedure Paint(Buffer: TBitmap32); virtual; abstract;
    procedure OnGraficoResize; virtual;
    procedure OnBeforeGraficoDataChange; virtual;
    procedure OnGraficoDataChanged; virtual;
  public
    constructor Create(const Grafico: TGrafico; const layerBefore: boolean); virtual;
    destructor Destroy; override;
    procedure Recalculate; overload;
    procedure Update; virtual;
    procedure SetVisibleWithoutUpdate(const value: boolean);
    property Visible: boolean read FVisible write SetVisible;
  end;

  TIncrustedDatosLayer = class(TIncrustedLayer)
  private
    function GetPDatos: PArrayCurrency;
    procedure SetPDatosLayer(const Value: PArrayCurrency);
  protected
    DatosLayer: TDatosGrafico;
    procedure Recalculate(const fromPos, toPos: integer); override;
    procedure RecalculateTransformados(const fromPos, toPos: integer); override;
    procedure OnGraficoResize; override;
  public
    constructor Create(const Grafico: TGrafico; const layerBefore: boolean); override;
    destructor Destroy; override;
    procedure Update; override;
    property PDatosLayer: PArrayCurrency read GetPDatos write SetPDatosLayer;
  end;

  /////////////////////////////

  TGraficoLayer = class(TPositionedLayer)
  protected
    procedure DoKeyUp(var Key: Word;  Shift: TShiftState); virtual;
    procedure RecalculateTransformados(const fromPos, toPos: integer); virtual; abstract;
  public
    constructor Create(Grafico: TGrafico); reintroduce; virtual;
  end;

  TGraficoDatosLayer = class(TGraficoLayer)
  protected
    Grafico: TGrafico;
    Datos: TDatosGrafico;
    procedure SendEvent(const busMessageGraficoClass: TMessageGraficoClass);
  public
    constructor Create(Grafico: TGrafico); override;
  end;


  TDatosLayer = class(TGraficoDatosLayer)
  private
    function GetPDatos: PArrayCurrency;
    procedure SetPDatosLayer(const Value: PArrayCurrency);
  protected
    DatosLayer: TDatosGrafico;
    procedure RecalculateTransformados(const fromPos, toPos: integer); override;
  public
    constructor Create(Grafico: TGrafico); override;
    destructor Destroy; override;
    property PDatosLayer: PArrayCurrency read GetPDatos write SetPDatosLayer;
  end;

implementation

uses SysUtils, UtilColors, Windows, Forms, GR32_Blend;

const
  DEFAULT_ALTO_EJE_X: integer = 13;

{ TGrafico }

procedure TGrafico.AddIncrustedLayer(const incrustedLayer: TIncrustedLayer;
  const before: boolean);
begin
  if before then
    IncrustedLayersBefore.Add(incrustedLayer)
  else
    IncrustedLayersAfter.Add(incrustedLayer);
end;

procedure TGrafico.CalculateAltoEjeX;
begin
  if FShowX then
    FAltoEjeX := DEFAULT_ALTO_EJE_X
  else
    FAltoEjeX := 0;
end;

procedure TGrafico.CalculateAnchoEjeY;
begin
  CalculateAnchoEjeY(Datos.Maximo, Datos.Minimo);
end;

procedure TGrafico.CalculateAnchoEjeY(const Maximo, Minimo: currency);
var anchoMax, anchoMin: integer;
  textMax, textMin: string;
begin
  textMax := CurrToStrF(Maximo, ffCurrency, Decimals);
  textMin := CurrToStrF(Minimo, ffCurrency, Decimals);
  Bitmap.Font.Size := 8;
  anchoMax := Bitmap.TextWidth(textMax);
  anchoMin := Bitmap.TextWidth(textMin);
  if anchoMax > anchoMin then
    FAnchoEjeY := anchoMax
  else
    FAnchoEjeY := anchoMin;
  FAnchoEjeY := FAnchoEjeY + 5;
end;

constructor TGrafico.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BusGrafico := TBus.Create;
  IncrustedLayersBefore := TObjectList.Create(false);
  IncrustedLayersAfter := TObjectList.Create(false);
  FShowDecimals := true;
  FDatos := CreateDatosGrafico;
  FShowDataHint := false;
  FShowY := true;
  FShowX := true;
  RepaintMode := rmOptimizer;
  FColorBackGround := clBlack32;
  ColorPositions := $000080FF;
  FShowDataHint := false;
  CalculateAltoEjeX;
end;

function TGrafico.CreateDatosGrafico: TDatosGrafico;
begin
  result := TDatosGrafico.Create;
end;

procedure TGrafico.PaintGraphicPositions;
begin
  PaintGraphicPositions(0, Datos.DataCount - 1);
end;

procedure TGrafico.PaintX(const iFrom, iTo: integer);
var i, x, y, proximo, anchoText: integer;
  text: string;
  fecha: TDate;
begin
  i := iTo;
  y := Height - 13;
  Bitmap.Font.Size := 8;
  Bitmap.SetStipple([Color32(60, 60, 60), 0, 0, 0, 0]);
  while i >= iFrom do begin
    fecha := Datos.Fechas[i];
    if fecha <> SIN_FECHA then begin
      text := DateToStr(fecha);
      anchoText := Bitmap.TextWidth(text);
      x := Datos.XTransformados[i];
      Bitmap.VertLineTSP(x, 0, y);
      Bitmap.Textout(x - (anchoText div 2), y, text);
      proximo := x - anchoText - 5;
      while (i >= iFrom) and (Datos.Xtransformados[i] > proximo) do
        dec(i);
    end
    else
      dec(i);
  end;
end;

procedure TGrafico.PaintX;
begin
  PaintX(0, Datos.DataCount - 1);
end;

procedure TGrafico.PaintY(const iFrom, iTo: integer);

    procedure PaintYNoFixed;
    var x, i, y, num: integer;
      nivel, den, increment: currency;
      text: string;
      anchoText: integer;
    begin
      den := Alto / 40;
      increment := (Datos.Maximo - Datos.Minimo) / den;
      Bitmap.Font.Color := RGBToColor(130, 130, 130);
      Bitmap.Font.Size := 8;
      Bitmap.SetStipple([Color32(60, 60, 60), 0, 0, 0, 0]);
      num := Round(den);
      x := Width - AnchoEjeY;
      // Primer valor un poco más abajo porque sino no se acaba de ver bien, ya que
      // un trozo sale por arriba del gráfico
      Bitmap.HorzLineTSP(0, 0, x);
      if Datos.Maximo <> SIN_CAMBIO then begin
        text := CurrToStrF(Datos.Maximo, ffCurrency, Decimals);
        anchoText := Bitmap.TextWidth(text);
        Bitmap.Textout(Width - anchoText, 0, text);
      end;

      // desde 1 a num - 1, ya que el primer y el último elemento se tratan aparte
      dec(num);
      for i := 1 to num do begin
        y := i * 40;
        Bitmap.HorzLineTSP(0, y + Padding.Top, x);

        // 0       FMax     y=0 -- FMax
        //
        // y       nivel
        //
        // Height  FMin
        nivel := Datos.Maximo - (increment * i);
        if nivel <> SIN_CAMBIO then begin
          text := CurrToStrF(nivel, ffCurrency, Decimals);
          anchoText := Bitmap.TextWidth(text);
          Bitmap.Textout(Width - anchoText, y - 3, text);
        end;
      end;

      inc(num);
      // Último valor un poco más arriba porque sino se pisa con las fechas
      y := num * 40;
      Bitmap.HorzLineTSP(0, y + Padding.Top, x);
      nivel := Datos.Maximo - (increment * num);
      if nivel <> SIN_CAMBIO then begin
        text := CurrToStrF(nivel, ffCurrency, Decimals);
        anchoText := Bitmap.TextWidth(text);
        Bitmap.Textout(Width - anchoText, y - 8, text);
      end;
    end;

    procedure PaintFixed;
    var x, i, num, y, altoMasPaddingTop, anchoText: integer;
      den, nivel, min, max: currency;
      altoDivDen: Double;
    begin
      Bitmap.Font.Color := RGBToColor(130, 130, 130);
      Bitmap.Font.Size := 8;
      Bitmap.SetStipple([Color32(60, 60, 60), 0, 0, 0, 0]);
      x := Width - AnchoEjeY;
      // Ver DatosGrafico.RecalculteTransformados(x,x)
      min := FDatos.Minimo;
      max := FDatos.Maximo;
      den := max - min;
      altoDivDen := Alto / den;
      altoMasPaddingTop := Alto + Top + 4;
      //
      num := Length(FFixedYValues^) - 1;
      for i := 0 to num do begin
        nivel := FFixedYValues^[i];
        // Ver DatosGrafico.RecalculteTransformados(x,x)
        y := altoMasPaddingTop - Round((nivel - min) * altoDivDen) - 1;
        //
        Bitmap.HorzLineTSP(0, y, x);
        text := CurrToStrF(nivel, ffCurrency, Decimals);
        anchoText := Bitmap.TextWidth(text);
        Bitmap.Textout(Width - anchoText, y - 3, text);
      end;
    end;
begin
  if FFixedYValues = nil then
    PaintYNoFixed
  else
    PaintFixed;
end;

procedure TGrafico.PaintY;
begin
  PaintY(0, Datos.DataCount - 1);
end;

procedure TGrafico.PaintGraphicPositions(const iFrom, iTo: integer);
var i, x, y: integer;
begin
  for i := iFrom to iTo do begin
    if (Datos.IsDataNull[i]) or (Datos.IsSinCambio[i]) then begin
      // No transformamos a and para que vaya más rápido
    end
    else begin
      x := Datos.XTransformados[i];
      y := Datos.YTransformados[i];
      Bitmap.FillRectS(x, y, x + 1, y + 1, FColorPositions);
    end;
  end;
end;

function TGrafico.GetColorBackGround: TColor;
begin
  result := WinColor(FColorBackGround);
end;

function TGrafico.GetColorPositions: TColor;
begin
  result := WinColor(FColorPositions);
end;

destructor TGrafico.Destroy;
begin
  while IncrustedLayersBefore.Count > 0 do
    IncrustedLayersBefore[0].Free;
  IncrustedLayersBefore.Free;
  while IncrustedLayersAfter.Count > 0 do
    IncrustedLayersAfter[0].Free;
  IncrustedLayersAfter.Free;
  FDatos.Free;
  inherited;
  //MUY IMPORTANTE. Se debe hacer el free del BusGrafico después del inherited
  //ya que al ser un TCustomImage32, en su destructor se destruyen los layers
  //y hay layers que tienen registrados eventos en el BusGrafico, por lo que
  //en sus destructores habrá llamadas al BusGrafico.UnregisterEvent.
  BusGrafico.Free;  
end;

procedure TGrafico.DoKeyUp(var Key: Word; Shift: TShiftState);
var i: integer;
begin
  for i := 0 to Layers.Count - 1 do begin
    if Layers[i] is TGraficoLayer then begin
      TGraficoLayer(Layers[i]).DoKeyUp(Key, Shift);
      if Key = 0 then
        exit;
    end;
  end;
end;

function TGrafico.GetLayerByType(
  const LayerClassType: TCustomLayerClass): TCustomLayer;
var i: integer;
begin
  for i := 0 to Layers.Count - 1 do begin
    if Layers[i] is LayerClassType then begin
      result := Layers[i];
      exit;
    end;
  end;
  result := nil;
end;

procedure TGrafico.Recalculate;
begin
  Recalculate(0, Datos.DataCount - 1);
end;

procedure TGrafico.RecalculateMaxMin;
begin
  Datos.RecalculateMaxMin(0, Datos.DataCount - 1);
end;

procedure TGrafico.Recalculate(const fromPos, toPos: integer);
var i, num: integer;
begin
  lastRecalculateFrom := fromPos;
  lastRecalculateTo := toPos;
  Datos.Recalculate(fromPos, toPos);
  num := Layers.Count - 1;
  for i := 0 to num do begin
    if Layers[i] is TGraficoLayer then
      TGraficoLayer(Layers[i]).RecalculateTransformados(fromPos, toPos);
  end;
  num := IncrustedLayersBefore.Count - 1;
  for i := 0 to num do begin
    TIncrustedLayer(IncrustedLayersBefore[i]).Recalculate(fromPos, toPos);
  end;
  num := IncrustedLayersAfter.Count - 1;
  for i := 0 to num do begin
    TIncrustedLayer(IncrustedLayersAfter[i]).Recalculate(fromPos, toPos);
  end;
end;

procedure TGrafico.RecalculateTransformados(const fromPos, toPos: integer);
var i: integer;
begin
  lastRecalculateFrom := fromPos;
  lastRecalculateTo := toPos;
  Datos.RecalculateTransformados(fromPos, toPos);
  for i := 0 to Layers.Count - 1 do begin
    if Layers[i] is TGraficoLayer then
      TGraficoLayer(Layers[i]).RecalculateTransformados(fromPos, toPos);
  end;
end;

procedure TGrafico.RegisterEvent(const busMessageGraficoClass: TMessageGraficoClass;
  const event: TBusMessageEvent);
begin
  BusGrafico.RegisterEvent(busMessageGraficoClass, event);
end;

procedure TGrafico.RemoveIncrustedLayer(const incrustedLayer: TIncrustedLayer);
var i: integer;
begin
  i := incrustedLayersAfter.Remove(incrustedLayer);
  if i = -1 then //doesn't remove
    incrustedLayersBefore.Remove(incrustedLayer);
end;

procedure TGrafico.Resize;
var i, num: integer;
begin
  inherited;
  FAncho := Width - Padding.Left - Padding.Right - AnchoEjeY;
  FAlto := Height - Padding.Top - Padding.Bottom - AltoEjeX;
  SetupBitmap;
  Datos.Ancho := FAncho;
  Datos.Alto := FAlto;
  if Datos.DataCount > 0 then
    RecalculateTransformados(0, Datos.DataCount - 1);

  num := IncrustedLayersBefore.Count - 1;
  for i := 0 to num do begin
    TIncrustedLayer(IncrustedLayersBefore[i]).OnGraficoResize;
  end;
  num := IncrustedLayersAfter.Count - 1;
  for i := 0 to num do begin
    TIncrustedLayer(IncrustedLayersAfter[i]).OnGraficoResize;
  end;

  InvalidateGrafico;
end;

procedure TGrafico.InvalidateGrafico;
var i, num: integer;
  il: TIncrustedLayer;
begin
  if Datos.PCambios <> nil then begin
    Bitmap.BeginUpdate;
    Bitmap.ClipRect := Rect(0, 0, Width, Height);
    Bitmap.Clear(FColorBackGround);
    if FShowY then
      PaintY;
    if FShowX then
      PaintX;
    Bitmap.ClipRect := Rect(0, 0, Width - AnchoEjeY, Height - AltoEjeX);
    num := IncrustedLayersBefore.Count - 1;
    for i := 0 to num do begin
      il := TIncrustedLayer(IncrustedLayersBefore[i]);
      if il.Visible then
        il.Paint(Bitmap);
    end;
    PaintGrafico;
    num := IncrustedLayersAfter.Count - 1;
    for i := 0 to num do begin
      il := TIncrustedLayer(IncrustedLayersAfter[i]);
      if il.Visible then
        il.Paint(Bitmap);
    end;
    if FShowPositions then
      PaintGraphicPositions;
    Bitmap.EndUpdate;
    Bitmap.Changed;
  end;
end;

procedure TGrafico.NoFiller(Dst: PColor32; DstX, DstY, Length: Integer;
  AlphaValues: PColor32);
begin

end;

procedure TGrafico.SendEvent(const busMessageClass: TMessageGraficoClass);
begin
  BusGrafico.SendEvent(busMessageClass);
end;

procedure TGrafico.SetColorBackGround(const Value: TColor);
begin
  FColorBackGround := Color32(Value);
  InvalidateGrafico;
end;

procedure TGrafico.SetColorPositions(const Value: TColor);
begin
  FColorPositions := Color32(Value);
  InvalidateGrafico;
end;

procedure TGrafico.SetData(const PCambios: PArrayCurrency;
  const PFechas: PArrayDate);
var i, num: integer;
begin
  num := IncrustedLayersBefore.Count - 1;
  for i := 0 to num do begin
    TIncrustedLayer(IncrustedLayersBefore[i]).OnBeforeGraficoDataChange;
  end;
  num := IncrustedLayersAfter.Count - 1;
  for i := 0 to num do begin
    TIncrustedLayer(IncrustedLayersAfter[i]).OnBeforeGraficoDataChange;
  end;

  BusGrafico.SendEvent(MessageGraficoBeforeSetData);
  Datos.SetData(PCambios, PFechas);
  RecalculateMaxMin;
  // Nos reasignamos ShowDecimals porque si han cambiado los decimales del
  // CurrenyDecimals, estén correctamente
  ShowDecimals := FShowDecimals;
  CalculateAnchoEjeY;

  num := IncrustedLayersBefore.Count - 1;
  for i := 0 to num do begin
    TIncrustedLayer(IncrustedLayersBefore[i]).OnGraficoDataChanged;
  end;
  num := IncrustedLayersAfter.Count - 1;
  for i := 0 to num do begin
    TIncrustedLayer(IncrustedLayersAfter[i]).OnGraficoDataChanged;
  end;

  BusGrafico.SendEvent(MessageGraficoAfterSetData);
  Resize;
end;

procedure TGrafico.SetFixedYValues(const Value: PArrayCurrency);
begin
  FFixedYValues := Value;
  InvalidateGrafico;
end;

procedure TGrafico.SetManualDecimals(const Value: integer);
begin
  FManualDecimals := Value;
  FisManualDecimals := true;
end;

procedure TGrafico.SetShowDecimals(const Value: Boolean);
begin
  FShowDecimals := Value;
  if Value then begin
    if isManualDecimals then
      Decimals := FManualDecimals
    else
      Decimals := CurrencyDecimals;
  end
  else
    Decimals := 0;
end;

procedure TGrafico.SetShowPositions(const Value: boolean);
begin
  FShowPositions := Value;
  InvalidateGrafico;
end;

procedure TGrafico.SetShowX(const Value: boolean);
begin
  FShowX := Value;
  CalculateAltoEjeX;
  InvalidateGrafico;
end;

procedure TGrafico.SetShowY(const Value: boolean);
begin
  FShowY := Value;
  InvalidateGrafico;
end;


procedure TGrafico.UnregisterEvent(const busMessageGraficoClass: TMessageGraficoClass;
  const event: TBusMessageEvent);
begin
  BusGrafico.UnregisterEvent(busMessageGraficoClass, event);
end;

procedure TGrafico.WMGetDlgCode(var Message: TWMGetDlgCode);
begin

end;

{ TGraficoLayer }

constructor TGraficoLayer.Create(Grafico: TGrafico);
begin
  inherited Create(Grafico.Layers);
end;

procedure TGraficoLayer.DoKeyUp(var Key: Word;
  Shift: TShiftState);
begin

end;

{ TGraficoDatosLayer }

constructor TGraficoDatosLayer.Create(Grafico: TGrafico);
begin
  inherited;
  Self.Grafico := Grafico;
  Datos := Grafico.Datos;
end;

procedure TGraficoDatosLayer.SendEvent(
  const busMessageGraficoClass: TMessageGraficoClass);
begin
  Grafico.SendEvent(busMessageGraficoClass);
end;

{ TDatosLayer }

constructor TDatosLayer.Create(Grafico: TGrafico);
begin
  inherited Create(Grafico);
  DatosLayer := TDatosGrafico.Create;
  DatosLayer.MaximoManual := Grafico.Datos.Maximo;
  DatosLayer.MinimoManual := Grafico.Datos.Minimo;
  DatosLayer.Left := 0;
  DatosLayer.Top := 0;
end;

destructor TDatosLayer.Destroy;
begin
  DatosLayer.Free;
  inherited;
end;

function TDatosLayer.GetPDatos: PArrayCurrency;
begin
  result := DatosLayer.PCambios;
end;

procedure TDatosLayer.RecalculateTransformados(const fromPos, toPos: integer);
begin
  DatosLayer.Ancho := Grafico.Ancho;
  DatosLayer.Alto := Grafico.Alto;
  DatosLayer.RecalculateTransformados(fromPos, toPos);
end;

procedure TDatosLayer.SetPDatosLayer(const Value: PArrayCurrency);
begin
  DatosLayer.Ancho := Grafico.Ancho;
  DatosLayer.Alto := Grafico.Alto;
  DatosLayer.SetData(Value, nil);
  DatosLayer.Recalculate;
end;

{ TIncrustedLayer }

constructor TIncrustedLayer.Create(const Grafico: TGrafico; const layerBefore: boolean);
begin
  inherited Create;
  Self.Grafico := Grafico;
  Grafico.AddIncrustedLayer(Self, layerBefore);
  FVisible := false;
end;

destructor TIncrustedLayer.Destroy;
begin
  Grafico.RemoveIncrustedLayer(Self);
  inherited;
end;

procedure TIncrustedLayer.DoKeyUp(var Key: Word; Shift: TShiftState);
begin

end;

procedure TIncrustedLayer.OnBeforeGraficoDataChange;
begin

end;

procedure TIncrustedLayer.OnGraficoDataChanged;
begin

end;

procedure TIncrustedLayer.OnGraficoResize;
begin
end;

procedure TIncrustedLayer.Recalculate;
begin
  Recalculate(Grafico.lastRecalculateFrom, Grafico.lastRecalculateTo);
end;

procedure TIncrustedLayer.SetVisible(const Value: boolean);
begin
  FVisible := Value;
  Update;
end;

procedure TIncrustedLayer.SetVisibleWithoutUpdate(const value: boolean);
begin
  FVisible := value;
end;

procedure TIncrustedLayer.Update;
begin
  Grafico.InvalidateGrafico;
end;

{ TIncrustedDatosLayer }

constructor TIncrustedDatosLayer.Create(const Grafico: TGrafico; const layerBefore: boolean);
begin
  inherited Create(Grafico, layerBefore);
  DatosLayer := TDatosGrafico.Create;
  DatosLayer.Left := 0;
  DatosLayer.Top := 0;
  DatosLayer.Ancho := Grafico.Ancho;
  DatosLayer.Alto := Grafico.Alto;
  DatosLayer.MaximoManual := Grafico.Datos.MaximoManual;
  DatosLayer.MinimoManual := Grafico.Datos.MinimoManual;
  DatosLayer.DataNull := Grafico.Datos.DataNull;
  DatosLayer.DataSinCambio := Grafico.Datos.DataSinCambio;
end;

destructor TIncrustedDatosLayer.Destroy;
begin
  DatosLayer.Free;
  inherited;
end;

function TIncrustedDatosLayer.GetPDatos: PArrayCurrency;
begin
  result := DatosLayer.PCambios;
end;

procedure TIncrustedDatosLayer.OnGraficoResize;
begin
  DatosLayer.Ancho := Grafico.Ancho;
  DatosLayer.Alto := Grafico.Alto;
end;

procedure TIncrustedDatosLayer.Recalculate(const fromPos, toPos: integer);
begin
  DatosLayer.Recalculate(fromPos, toPos);
end;

procedure TIncrustedDatosLayer.RecalculateTransformados(const fromPos,
  toPos: integer);
begin
  DatosLayer.RecalculateTransformados(fromPos, toPos);
end;

procedure TIncrustedDatosLayer.SetPDatosLayer(const Value: PArrayCurrency);
begin
  DatosLayer.SetData(Value, nil);
end;

procedure TIncrustedDatosLayer.Update;
begin
  if PDatosLayer <> nil then
    inherited;
end;


end.
