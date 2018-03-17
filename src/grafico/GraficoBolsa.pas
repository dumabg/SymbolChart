unit GraficoBolsa;

interface

uses Classes, Grafico, Graphics, ExtCtrls, DB, GraficoPositionLayer, Messages,
  Controls, GraficoDataHintLayer, GraficoZoom, GraficoLineas,
  GraficoLineasLayer, BusCommunication, dmGraficoBolsa;

type
  MessageTipoGraficoChange = class(TBusMessage);
  MessageColorChanged = class(TBusMessage);

  TTipoGraficoBolsa = (tgbIndefinido, tgbLineas, tgbVelas, tgbEscenario);

  TOnTipoGraficoChange = procedure (const tipo: TTipoGraficoBolsa) of object;

  TGraficoBolsa = class(TWinControl)
  private
    BusGraficoBolsa: TBus;
    DataGraficoBolsa: TDataGraficoBolsa;
    ultimaFecha: TDate;
    FCierres, FCambiosMaximo, FCambiosMinimo: array of currency;
    FFechas: array of TDate;
    FTipo: TTipoGraficoBolsa;
    FUltimoOIDValor: integer;
    Position: TGraficoPositionLayer;
    DataHint: TGraficoDataHintLayer;
    DrawLines: TGraficoLinesLayer;
    Graficos: array[TTipoGraficoBolsa] of TZoomGrafico;
    LoadedData: array[TTipoGraficoBolsa] of boolean;
    FColorBackgroud: TColor;
    FColorLines: TColor;
    FColorPositions: TColor;
    FColorPosition: TColor;
    FColorDibujarLinea: TColor;
    FColorDibujarLineaSelec: TColor;
    FFieldCierre: TNumericField;
    FFieldMaximo: TNumericField;
    FFieldMinimo: TNumericField;
    FFieldFecha: TDateField;
    FShowDataHint: boolean;
    FAutoPosicionarCursor: boolean;
    FDrawLinesActive: boolean;
    procedure SetTipo(Value: TTipoGraficoBolsa);
    procedure ConfigureGrafico(const Grafico: TZoomGrafico);
    procedure SetColorBackground(const Value: TColor);
    function GetShowPositions: boolean;
    procedure SetShowPositions(const Value: boolean);
    procedure SetShowDataHint(const Value: boolean);
    procedure WMEraseBkGnd(var msg: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure OnCotizacionCambiada;
    function GetZoomActive: boolean; inline;
    procedure SetZoomActive(const Value: boolean);
    procedure SetDrawLinesActive(const Value: boolean);
    function GetLineType: TLineType;
    procedure SetLineType(const Value: TLineType);
    procedure CreateLinesLayer;
    procedure OnMessageGraficoAfterSetData;
    procedure OnMessageGraficoAfterZoom;
    procedure OnMessageGraficoBeforeZoom;
    procedure OnMessageGraficoAfterScroll;
    procedure OnMessageGraficoBeforeScroll;
    procedure SetColorPositions(const Value: TColor);
    procedure CargarLineas;
    procedure GuardarLineas(const OIDValor: integer);
    procedure SetColorLines(const Value: TColor);
    procedure SetColorPosition(const Value: TColor);
    procedure SetColorDibujarLinea(const Value: TColor);
    procedure SetColorDibujarLineaSelec(const Value: TColor);
    procedure InitLoadedData;
  protected
    procedure LoadMaxMin;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RegisterEvent(const busMessageClass: TBusMessageClass;
      const event: TBusMessageEvent);
    procedure UnregisterEvent(const busMessageClass: TBusMessageClass;
      const event: TBusMessageEvent);
    procedure Resize; override;
    procedure LoadData;
    procedure CancelHint;
    procedure HelpPoint;
    function GetGrafico: TZoomGrafico; overload;
    function GetGrafico(Tipo: TTipoGraficoBolsa): TZoomGrafico; overload;
    function GetGraficoPositionLayer: TGraficoPositionLayer;
    function GetGraficoLinesLayer: TGraficoLinesLayer;
    procedure ClearZoom;
    procedure BorrarLineas;
    procedure BorrarLineaSeleccionada;
    function HayLineas: boolean;
    function HayLineaSeleccionada: boolean;
    property FieldCierre: TNumericField read FFieldCierre write FFieldCierre;
    property FieldMaximo: TNumericField read FFieldMaximo write FFieldMaximo;
    property FieldMinimo: TNumericField read FFieldMinimo write FFieldMinimo;
    property FieldFecha: TDateField read FFieldFecha write FFieldFecha;
    property AutoPosicionarCursor: boolean read FAutoPosicionarCursor write FAutoPosicionarCursor;
    property Tipo: TTipoGraficoBolsa read FTipo write SetTipo;
    property ShowPositions: boolean read GetShowPositions write SetShowPositions default true;
    property ShowDataHint: boolean read FShowDataHint write SetShowDataHint default false;
    property DrawLinesActive: boolean read FDrawLinesActive write SetDrawLinesActive;
    property LineType: TLineType read GetLineType write SetLineType;
    property ZoomActive: boolean read GetZoomActive write SetZoomActive;
    property ColorBackgroud: TColor read FColorBackgroud write SetColorBackground;
    property ColorPositions: TColor read FColorPositions write SetColorPositions;
    property ColorLines: TColor read FColorLines write SetColorLines;
    property ColorPosition: TColor read FColorPosition write SetColorPosition;
    property ColorDibujarLinea: TColor read FColorDibujarLinea write SetColorDibujarLinea;
    property ColorDibujarLineaSelec: TColor read FColorDibujarLineaSelec write SetColorDibujarLineaSelec;
    property PopupMenu;
 end;

implementation

{ TGraficoBolsa }

uses SysUtils, GR32_Layers, dmData, GraficoEscenario,
  UtilDB, GraficoVelas, Windows, Tipos, DatosGrafico, Contnrs,
  GraficoEscenarioPositionLayer, ConfigVisual;

const
  DATA_NULL : currency = 0;
  CAMBIOS_MINIMOS : integer = 640;
  SIN_OID_VALOR : integer = Low(Integer);

constructor TGraficoBolsa.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FUltimoOIDValor := SIN_OID_VALOR;
  DataGraficoBolsa := TDataGraficoBolsa.Create(Self);
  BusGraficoBolsa := TBus.Create;
  FAutoPosicionarCursor := false;
  InitLoadedData;
  FillChar(Graficos, length(Graficos) * sizeof(TZoomGrafico), 0);
  FTipo := tgbIndefinido;
  Bus.RegisterEvent(MessageCotizacionCambiada, OnCotizacionCambiada);
end;

procedure TGraficoBolsa.CreateLinesLayer;
begin
  DrawLines := TGraficoLinesLayer.Create(GetGrafico);
  DrawLines.ColorLines := FColorDibujarLinea;
  DrawLines.ColorSelectedLine := FColorDibujarLineaSelec;
end;

destructor TGraficoBolsa.Destroy;
begin
  if FUltimoOIDValor <> SIN_OID_VALOR then
    GuardarLineas(FUltimoOIDValor);
  BusGraficoBolsa.Free;
  Bus.UnRegisterEvent(MessageCotizacionCambiada, OnCotizacionCambiada);
  inherited Destroy;
end;

function TGraficoBolsa.GetGrafico: TZoomGrafico;
begin
  if Tipo = tgbIndefinido then
    result := nil
  else begin
    result := Graficos[Tipo];
    if result = nil then begin
      case Tipo of
        tgbLineas: Graficos[tgbLineas] := TGraficoLineas.Create(Self);
        tgbVelas: Graficos[tgbVelas] := TGraficoVelas.Create(Self);
        tgbEscenario: Graficos[tgbEscenario] := TGraficoEscenario.Create(Self);
      end;
      ConfigureGrafico(Graficos[Tipo]);
      result := Graficos[Tipo];
    end;
  end;
end;

function TGraficoBolsa.GetGrafico(Tipo: TTipoGraficoBolsa): TZoomGrafico;
begin
  result := Graficos[Tipo];
end;

function TGraficoBolsa.GetGraficoLinesLayer: TGraficoLinesLayer;
begin
  if DrawLines = nil then
    CreateLinesLayer;
  result := DrawLines;
end;

function TGraficoBolsa.GetGraficoPositionLayer: TGraficoPositionLayer;
begin
  result := TGraficoPositionLayer(GetGrafico.GetLayerByType(TGraficoPositionLayer));
end;

function TGraficoBolsa.GetLineType: TLineType;
begin
  result := DrawLines.LineType;
end;

function TGraficoBolsa.GetShowPositions: boolean;
begin
  result := GetGrafico.ShowPositions;
end;

function TGraficoBolsa.GetZoomActive: boolean;
begin
  result := GetGrafico.ZoomActive;
end;

procedure TGraficoBolsa.GuardarLineas(const OIDValor: integer);
var lineas: TObjectList;
begin
  if DrawLines <> nil then begin
    lineas := DrawLines.Lineas;
    if lineas <> nil then
      DataGraficoBolsa.GuardarLineas(OIDValor, lineas);
  end;
end;

function TGraficoBolsa.HayLineas: boolean;
begin
  result := (DrawLines <> nil) and (DrawLines.HayLineas);
end;

function TGraficoBolsa.HayLineaSeleccionada: boolean;
begin
  result := (DrawLines <> nil) and (DrawLines.HayLineaSeleccionada);
end;

procedure TGraficoBolsa.HelpPoint;
var positionLayer : TGraficoPositionLayer;
begin
  positionLayer := TGraficoPositionLayer(GetGrafico.GetLayerByType(TGraficoPositionLayer));
  positionLayer.HelpPoint;
end;

procedure TGraficoBolsa.InitLoadedData;
begin
  FillChar(LoadedData, length(LoadedData) * sizeof(boolean), false);
end;

procedure TGraficoBolsa.KeyUp(var Key: Word; Shift: TShiftState);
begin
  GetGrafico.DoKeyUp(Key, Shift);
end;

procedure TGraficoBolsa.BorrarLineas;
begin
  if DrawLines <> nil then
    DrawLines.BorrarLineas(false);
end;

procedure TGraficoBolsa.BorrarLineaSeleccionada;
begin
  if DrawLines <> nil then
    DrawLines.BorrarLineaSeleccionada;
end;

procedure TGraficoBolsa.CancelHint;
var layer: TCustomLayer;
begin
  layer := GetGrafico.GetLayerByType(TGraficoDataHintLayer);
  if layer <> nil then
    TGraficoDataHintLayer(layer).CancelHint;
end;

procedure TGraficoBolsa.CargarLineas;
var lineasLayer: TGraficoLinesLayer;
begin
  if DrawLines <> nil then
    DrawLines.BorrarLineas(true);
  if DataGraficoBolsa.CargarLineas then begin
    lineasLayer := GetGraficoLinesLayer;
    DataGraficoBolsa.CargarLineasLayer(lineasLayer);
  end;
end;

procedure TGraficoBolsa.ClearZoom;
begin
  GetGrafico.ClearZoom;
end;

procedure TGraficoBolsa.ConfigureGrafico(const Grafico: TZoomGrafico);
begin
  with Grafico do begin
    Align := alClient;
    Datos.DataNull := DIA_SIN_COTIZAR;
    Datos.DataSinCambio := SIN_CAMBIO;
    Visible := false;
    Parent := Self;
    ColorBackgroud := FColorBackgroud;
    ColorPositions := FColorPositions;
    ColorLines := FColorLines;
    ShowPositions := true;
    Padding.Right := 3;
    Padding.Top := 3;
    Padding.Bottom := 3;
    Padding.Left := 3;
    ZoomActive := false;
    ShowScrollButtons := true;
    RegisterEvent(MessageGraficoAfterZoom, OnMessageGraficoAfterZoom);
    RegisterEvent(MessageGraficoBeforeZoom, OnMessageGraficoBeforeZoom);
    RegisterEvent(MessageGraficoAfterScroll, OnMessageGraficoAfterScroll);
    RegisterEvent(MessageGraficoBeforeScroll, OnMessageGraficoBeforeScroll);
    RegisterEvent(MessageGraficoAfterSetData, OnMessageGraficoAfterSetData);
  end;
end;

procedure TGraficoBolsa.LoadData;
var i, j, num: integer;
  DataSet: TDataSet;
  inspect: TInspectDataSet;
  positionActive: boolean;
  positionLayer: TGraficoPositionLayer;
  grafico: TZoomGrafico;
begin
  if FUltimoOIDValor <> SIN_OID_VALOR then
    GuardarLineas(FUltimoOIDValor);

  if DrawLines <> nil then
    DrawLines.BorrarLineas(true);

  positionLayer := GetGraficoPositionLayer;
  if positionLayer <> nil then begin
    positionActive := positionLayer.Active;
    positionLayer.Active := false;
  end
  else
    positionActive := false;

  DataSet := FieldCierre.DataSet;
  inspect := StartInspectDataSet(DataSet);
  try
    DataSet.Last;
    num := DataSet.RecordCount;
    j := 0;
    if num < CAMBIOS_MINIMOS then begin
      SetLength(FCierres, CAMBIOS_MINIMOS);
      SetLength(FFechas, CAMBIOS_MINIMOS);
      j := CAMBIOS_MINIMOS - num - 1; //zero based
      for i := 0 to j do begin
        FCierres[i] := SIN_CAMBIO;
        FFechas[i] := SIN_FECHA;
      end;
      num := CAMBIOS_MINIMOS;
      inc(j);
    end
    else begin
      SetLength(FCierres, num);
      SetLength(FFechas, num);
    end;
    dec(num);
    for i := j to num do begin
      FFechas[i] := FieldFecha.Value;
      if FieldCierre.IsNull then
        FCierres[i] := DATA_NULL
      else
        FCierres[i] := FieldCierre.AsCurrency;
      DataSet.Prior;
    end;
  finally
    EndInspectDataSet(inspect);
  end;

  grafico := GetGrafico;
  if Tipo = tgbVelas then begin
    LoadMaxMin;
    TGraficoVelas(grafico).SetData(@FCierres, @FCambiosMaximo, @FCambiosMinimo, @FFechas);
  end
  else begin
    grafico.SetData(@FCierres, @FFechas);
    if Tipo = tgbEscenario then
      //Al recargar datos en un escenario, interesa que la línea del escenario
      //aparezca al final, por lo que se debe recalcular el zoom. El recalculo
      //del zoom lo realiza en AssignZoom, por lo que nos autoasignamos para
      //que se haga el recálculo del zoom.
      grafico.AssignZoom(grafico);
  end;

  if FAutoPosicionarCursor then
    Data.IrACotizacionConFecha(ultimaFecha);

  if positionLayer <> nil then begin
    if positionLayer.Position > num then
      positionLayer.Position := num;
    positionLayer.Active := positionActive;
  end;

  CargarLineas;

  if FUltimoOIDValor <> Data.OIDValor then begin
    FUltimoOIDValor := Data.OIDValor;
    FillChar(LoadedData, length(LoadedData) * sizeof(boolean), false);
  end;
  InitLoadedData;
  LoadedData[Tipo] := true;
end;

procedure TGraficoBolsa.LoadMaxMin;
var i, j, num: integer;
  DataSet: TDataSet;
  inspect: TInspectDataSet;
begin
  DataSet := FieldMaximo.DataSet;
  inspect := StartInspectDataSet(DataSet);
  try
    DataSet.Last;
    num := DataSet.RecordCount;
    j := 0;
    if num < CAMBIOS_MINIMOS then begin
      SetLength(FCambiosMaximo, CAMBIOS_MINIMOS);
      SetLength(FCambiosMinimo, CAMBIOS_MINIMOS);
      j := CAMBIOS_MINIMOS - num - 1;
      for i := 0 to j do begin
        FCambiosMaximo[i] := SIN_CAMBIO;
        FCambiosMinimo[i] := SIN_CAMBIO;
      end;
      num := CAMBIOS_MINIMOS;
      inc(j);
    end
    else begin
      SetLength(FCambiosMaximo, num);
      SetLength(FCambiosMinimo, num);
    end;
    dec(num);
    for i := j to num do begin
      FCambiosMaximo[i] := FieldMaximo.AsCurrency;
      FCambiosMinimo[i] := FieldMinimo.AsCurrency;
      DataSet.Prior;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;

procedure TGraficoBolsa.OnCotizacionCambiada;
begin
  ultimaFecha := Data.Sesion;
  Position.PositionFecha := ultimaFecha;
end;

procedure TGraficoBolsa.OnMessageGraficoAfterScroll;
begin
  BusGraficoBolsa.SendEvent(MessageGraficoAfterScroll);
end;

procedure TGraficoBolsa.OnMessageGraficoAfterZoom;
begin
  BusGraficoBolsa.SendEvent(MessageGraficoAfterZoom);
end;

procedure TGraficoBolsa.OnMessageGraficoBeforeScroll;
begin
  BusGraficoBolsa.SendEvent(MessageGraficoBeforeScroll);
end;

procedure TGraficoBolsa.OnMessageGraficoBeforeZoom;
begin
  BusGraficoBolsa.SendEvent(MessageGraficoBeforeZoom);
end;

procedure TGraficoBolsa.OnMessageGraficoAfterSetData;
begin
  BusGraficoBolsa.SendEvent(MessageGraficoAfterSetData);
end;

procedure TGraficoBolsa.RegisterEvent(const busMessageClass: TBusMessageClass;
  const event: TBusMessageEvent);
begin
  BusGraficoBolsa.RegisterEvent(busMessageClass, event);
end;

procedure TGraficoBolsa.Resize;
var Grafico: TGrafico;
begin
  inherited Resize;
  Grafico := GetGrafico;
  if Grafico <> nil then
    Grafico.SetBounds(0, 0, Width, Height);
end;

procedure TGraficoBolsa.SetColorBackground(const Value: TColor);
var i: TTipoGraficoBolsa;
begin
  FColorBackgroud := Value;
  for i := Low(TTipoGraficoBolsa) to High(TTipoGraficoBolsa) do begin
    if Graficos[i] <> nil then
      Graficos[i].ColorBackgroud := Value;
  end;
  BusGraficoBolsa.SendEvent(MessageColorChanged);
end;

procedure TGraficoBolsa.SetColorDibujarLinea(const Value: TColor);
begin
  FColorDibujarLinea := Value;
  if DrawLines <> nil then
    DrawLines.ColorLines := FColorDibujarLinea;
end;

procedure TGraficoBolsa.SetColorDibujarLineaSelec(const Value: TColor);
begin
  FColorDibujarLineaSelec := Value;
  if DrawLines <> nil then
    DrawLines.ColorSelectedLine := FColorDibujarLineaSelec;
end;

procedure TGraficoBolsa.SetColorLines(const Value: TColor);
var i: TTipoGraficoBolsa;
begin
  FColorLines := Value;
  for i := Low(TTipoGraficoBolsa) to High(TTipoGraficoBolsa) do begin
    if (Graficos[i] <> nil) and (Graficos[i] is TGraficoLineas) then
      TGraficoLineas(Graficos[i]).ColorLine := Value;
  end;
  BusGraficoBolsa.SendEvent(MessageColorChanged);
end;

procedure TGraficoBolsa.SetColorPosition(const Value: TColor);
begin
  FColorPosition  := Value;
  if Position <> nil then
    Position.ColorPosition := Value;
  BusGraficoBolsa.SendEvent(MessageColorChanged);
end;

procedure TGraficoBolsa.SetColorPositions(const Value: TColor);
var i: TTipoGraficoBolsa;
begin
  FColorPositions := Value;
  for i := Low(TTipoGraficoBolsa) to High(TTipoGraficoBolsa) do begin
    if Graficos[i] <> nil then
      Graficos[i].ColorPositions := Value;
  end;
  BusGraficoBolsa.SendEvent(MessageColorChanged);
end;

procedure TGraficoBolsa.SetDrawLinesActive(const Value: boolean);
begin
  FDrawLinesActive := Value;
  if FDrawLinesActive then begin
    GetGraficoPositionLayer.Enabled := false;
    CancelHint;
    if DrawLines = nil then
      CreateLinesLayer;
    DrawLines.Active := true;
    DrawLines.BringToFront;
  end
  else begin
    if DrawLines <> nil then begin
      DrawLines.Active := false;
    end;
    GetGraficoPositionLayer.Enabled := true;
  end;
end;

procedure TGraficoBolsa.SetLineType(const Value: TLineType);
begin
  DrawLines.LineType := Value;
  if Value = ltHorizontal then
    DrawLines.AddHorizontalLine(Data.CotizacionCIERRE.Value)
  else
    if Value = ltVertical then
      DrawLines.AddVerticalLine(Data.CotizacionFECHA.Value);
end;

procedure TGraficoBolsa.SetShowDataHint(const Value: boolean);
begin
  if FShowDataHint <> Value then begin
    FShowDataHint := Value;
    if FShowDataHint then
      DataHint := TGraficoDataHintLayer.Create(GetGrafico, Position)
    else
      FreeAndNil(DataHint);
  end;
end;

procedure TGraficoBolsa.SetShowPositions(const Value: boolean);
var i: TTipoGraficoBolsa;
begin
  for i := Low(TTipoGraficoBolsa) to High(TTipoGraficoBolsa) do
    Graficos[i].ShowPositions := Value;
end;

procedure TGraficoBolsa.SetTipo(Value: TTipoGraficoBolsa);
var positionAnterior: TDate;
  tipoAnterior: TTipoGraficoBolsa;
  graficoAnterior: TZoomGrafico;
  grafico: TZoomGrafico;
  drawLineasActive: boolean;
begin
  if Value = tgbIndefinido then
    Value := tgbLineas;

  if FTipo = Value then
    exit;
  // Gráfico actualmente visible
  if Position <> nil then begin
    positionAnterior := Position.PositionFecha;
    Position.Active := false;
    FreeAndNil(Position);
  end
  else
    positionAnterior := 0;
  FreeAndNil(DataHint);
  tipoAnterior := FTipo;
  graficoAnterior := GetGrafico;
  // Nuevo tipo de gráfico
  FTipo := Value;
  grafico := GetGrafico;


{  if not LoadedData[FTipo] then begin
    LoadData;
    positionAnterior := Data.Sesion;
  end;
 }
  if not LoadedData[FTipo] then begin
    if LoadedData[tipoAnterior] then begin
      if Tipo = tgbVelas then begin
        LoadMaxMin;
        TGraficoVelas(grafico).SetData(@FCierres, @FCambiosMaximo,
          @FCambiosMinimo, @FFechas);
      end
      else
        grafico.SetData(@FCierres, @FFechas);
      LoadedData[tipo] := true;
    end
    else
      LoadData;
    positionAnterior := Data.Sesion;
  end;

  if positionAnterior = 0 then
    positionAnterior := Data.Sesion;
  if Tipo = tgbEscenario then
    Position := TEscenarioGraficoPositionLayer.Create(grafico)
  else
    Position := TDefaultGraficoPositionLayer.Create(grafico);
  Position.ColorPosition := FColorPosition;
  if graficoAnterior <> nil then
    graficoAnterior.Visible := false;
//  grafico.SetBounds(0, 0, Width, Height);
  grafico.Visible := true;
  if FShowDataHint then
    DataHint := TGraficoDataHintLayer.Create(grafico, Position);
  if DrawLines <> nil then begin
    GuardarLineas(FUltimoOIDValor);
    DrawLines.BorrarLineas(true);
    drawLineasActive := DrawLines.Active;
    DrawLines.Free;
    CreateLinesLayer;
    CargarLineas;
    DrawLines.Active := drawLineasActive;
  end;
  Position.PositionFecha := positionAnterior;
  Position.Active := true;
  Bus.SendEvent(MessageTipoGraficoChange);
  if graficoAnterior <> nil then
    grafico.AssignZoom(graficoAnterior);
end;

procedure TGraficoBolsa.SetZoomActive(const Value: boolean);
var grafico: TZoomGrafico;
begin
  grafico := GetGrafico;
  grafico.ZoomActive := Value;
  // Después de hacer el zoom, la capa de líneas puede no estar encima de todo.
  // Se envía arriba de todo para que si se selecciona dibujar líneas, funcione
  // el ratón
  if not Value then begin
    if DrawLinesActive then
      DrawLines.BringToFront;
  end;
end;

procedure TGraficoBolsa.UnregisterEvent(const busMessageClass: TBusMessageClass;
  const event: TBusMessageEvent);
begin
   BusGraficoBolsa.UnregisterEvent(busMessageClass, event);
end;

procedure TGraficoBolsa.WMEraseBkGnd(var msg: TWMEraseBkGnd);
begin
  msg.result := 1;
end;

procedure TGraficoBolsa.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTALLKEYS or DLGC_WANTARROWS;
end;


end.
