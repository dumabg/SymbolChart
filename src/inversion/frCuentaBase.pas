unit frCuentaBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, 
  ExtCtrls, TeEngine, Series, TeeProcs, Chart, Grids, DBGrids, JvExDBGrids,
  JvDBGrid, JvDBUltimGrid, ComCtrls, dmCuentaBase, JvExExtCtrls,
  JvNetscapeSplitter, ActnList, TB2Dock, TB2Toolbar, DBCtrls, 
  SpTBXItem, TB2Item;

type
  TfCuentaBase = class(TFrame)
    pcPosiciones: TPageControl;
    tsPosicionesAbiertas: TTabSheet;
    iCorto: TImage;
    iLargo: TImage;
    GridPosAbiertas: TJvDBUltimGrid;
    tsPosicionesCerradas: TTabSheet;
    GridPosCerradas: TJvDBUltimGrid;
    ChartCurvaCapital: TChart;
    Series1: TAreaSeries;
    GridCurvaCapital: TJvDBUltimGrid;
    tsMovimientos: TTabSheet;
    GridMovimientos: TJvDBUltimGrid;
    dsCurvaCapital: TDataSource;
    dsPosicionesCerradas: TDataSource;
    dsCuentaMovimientos: TDataSource;
    dsPosicionesAbiertas: TDataSource;
    Splitter: TJvNetscapeSplitter;
    pCurvaCapital: TPanel;
    TBXToolbar4: TSpTBXToolbar;
    ActionListCuentaBase: TActionList;
    VerCurva: TAction;
    TBXItem11: TSpTBXItem;
    TBXItem12: TSpTBXItem;
    VerPosiciones: TAction;
    VerMixta: TAction;
    TBXItem13: TSpTBXItem;
    TBXSeparatorItem6: TSpTBXSeparatorItem;
    TBXSeparatorItem8: TSpTBXSeparatorItem;
    MovimientosToolBar: TSpTBXToolbar;
    CerrarMonedas: TAction;
    TBXItem14: TSpTBXItem;
    CambiarCambioMoneda: TAction;
    TBXItem15: TSpTBXItem;
    TBXSeparatorItem9: TSpTBXSeparatorItem;
    BorrarMovimiento: TAction;
    TBXSeparatorItem10: TSpTBXSeparatorItem;
    TBXItem16: TSpTBXItem;
    BorrarCambioMoneda: TAction;
    TBXItem17: TSpTBXItem;
    TBXSeparatorItem15: TSpTBXSeparatorItem;
    TBXSeparatorItem16: TSpTBXSeparatorItem;
    TBXLabelItem1: TSpTBXLabelItem;
    liCapital: TSpTBXLabelItem;
    procedure ChartCurvaCapitalMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridCurvaCapitalCellClick(Column: TColumn);
    procedure GridCellClick(Column: TColumn);
    procedure GridPosAbiertasGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure GridPosCerradasGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure GridPosicionDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure GridMovimientosGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure GridCurvaCapitalGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure VerPosicionesExecute(Sender: TObject);
    procedure VerCurvaExecute(Sender: TObject);
    procedure VerMixtaExecute(Sender: TObject);
    procedure CerrarMonedasExecute(Sender: TObject);
    procedure CambiarCambioMonedaExecute(Sender: TObject);
    procedure CambiarCambioMonedaUpdate(Sender: TObject);
    procedure BorrarMovimientoExecute(Sender: TObject);
    procedure GridTitleHint(Sender: TObject; Field: TField;
      var AHint: string; var ATimeOut: Integer);
    procedure GridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BorrarCambioMonedaExecute(Sender: TObject);
    procedure BorrarCambioMonedaUpdate(Sender: TObject);
    procedure BorrarMovimientoUpdate(Sender: TObject);
    procedure CerrarMonedasUpdate(Sender: TObject);
  private
    FCuenta: TCuentaBase;
    CurvaCapitalUltimoColor: TColor;
    CurvaCapitalUltimaPos: integer;
    FMostrarFechaHora: boolean;
    procedure InicializarCurvaCapital;
    procedure OnInicializarCurvaCapital;
    procedure OnCapitalRecalculado;
    procedure SetMostrarFechaHora(const Value: boolean);
  protected
    procedure Rojo(var Background: TColor; AFont: TFont; Highlight: Boolean);
    procedure Verde(var Background: TColor; AFont: TFont; Highlight: Boolean);
    procedure OnAnadirCurvaCapital(Sender: TObject);
    procedure OnAfterScrollCurvaCapital(Sender: TObject);
    procedure SetCuenta(const Value: TCuentaBase); virtual;
    procedure DefaultCellColors(const g: TJvDBUltimGrid; const Field: TField;
          AFont: TFont; var Background: TColor);
    procedure RepintarTotales;
    procedure CambiarFechaHoraGrid(const g: TJvDBUltimGrid);
  public
    procedure Activar(const enable: boolean);
    constructor Create(AOwner: TComponent); override;
    procedure BeforeDestruction; override;
    property Cuenta: TCuentaBase read FCuenta write SetCuenta;
    property MostrarFechaHora: boolean read FMostrarFechaHora write SetMostrarFechaHora;
  end;

implementation


{$R *.dfm}

uses UtilDB, UtilColors, dmDataComun, UtilForms,
  dmConfiguracion, dmData;

resourcestring
  SIN_CAMBIOS = 'Todos los movimientos que no son %s ya tienen cambio de moneda';
  CAPTION_BORRAR_MOV = 'Borrar movimiento';
  MSG_BORRAR_MOV = '¿Desea realmente borrar el movimiento seleccionado?';

const NO_ASIGNADA = -1;

procedure TfCuentaBase.Activar(const enable: boolean);
begin
  dsPosicionesAbiertas.Enabled := enable;
  dsPosicionesCerradas.Enabled := enable;
  dsCurvaCapital.Enabled := enable;
  dsCuentaMovimientos.Enabled := enable;
  GridPosAbiertas.Enabled := enable;
  GridPosCerradas.Enabled := enable;
  GridCurvaCapital.Enabled := enable;
  ChartCurvaCapital.Enabled := enable;
  GridMovimientos.Enabled := enable;
end;


procedure TfCuentaBase.BorrarCambioMonedaExecute(Sender: TObject);
begin
  Cuenta.BorrarCambioMoneda;
end;

procedure TfCuentaBase.BorrarCambioMonedaUpdate(Sender: TObject);
begin
  BorrarCambioMoneda.Enabled := (Cuenta.HayCambioMoneda) and (Cuenta.EsCompraVenta);
end;

procedure TfCuentaBase.BorrarMovimientoExecute(Sender: TObject);
begin
  if not Cuenta.CuentaMovimientos.IsEmpty then begin
    if ShowMensaje(CAPTION_BORRAR_MOV, MSG_BORRAR_MOV, mtConfirmation, [mbYes, mbNo]) = mrYes then
      Cuenta.BorrarMovimiento;
  end;
end;

procedure TfCuentaBase.BorrarMovimientoUpdate(Sender: TObject);
begin
  BorrarMovimiento.Enabled := not Cuenta.CuentaMovimientos.IsEmpty;
end;

procedure TfCuentaBase.CambiarCambioMonedaExecute(Sender: TObject);
begin
  Cuenta.CambiarCambioMoneda;
end;

procedure TfCuentaBase.CambiarCambioMonedaUpdate(Sender: TObject);
begin
  CambiarCambioMoneda.Enabled := Cuenta.EsCompraVenta;
end;

procedure TfCuentaBase.CambiarFechaHoraGrid(const g: TJvDBUltimGrid);
var i, num: integer;
  col: TColumn;
  field: TField;
begin
  num := g.Columns.Count - 1;
  for i := 0 to num do begin
    col := g.Columns[i];
    field := col.Field;
    if field is TDateTimeField then begin
      if FMostrarFechaHora then begin
        TDateTimeField(field).DisplayFormat := 'dd/mm/yy hh:mm:ss';
        if Pos('Fecha/Hora', col.Title.Caption) = 0 then begin
          col.Title.Caption := StringReplace(col.Title.Caption, 'Fecha', 'Fecha/Hora', []);
        end;
        if Pos('Fecha/Hora', field.DisplayLabel) = 0 then begin
          field.DisplayLabel := StringReplace(field.DisplayLabel, 'Fecha', 'Fecha/Hora', []);
        end;
      end
      else begin
        TDateTimeField(field).DisplayFormat := 'dd/mm/yy';
        if Pos('Fecha/Hora', col.Title.Caption) > 0 then begin
          col.Title.Caption := StringReplace(col.Title.Caption, 'Fecha/Hora', 'Fecha', []);
        end;
        if Pos('Fecha/Hora', field.DisplayLabel) > 0 then begin
          field.DisplayLabel := StringReplace(field.DisplayLabel, 'Fecha/Hora', 'Fecha', []);
        end;
      end;
    end;
  end;
end;

procedure TfCuentaBase.CerrarMonedasExecute(Sender: TObject);
begin
  case Cuenta.CerrarMonedas of
    cmrSinCambios : ShowMessage(Format(SIN_CAMBIOS,
      [DataComun.FindMoneda(Cuenta.OIDMoneda)^.Nombre]));
  end;
end;

procedure TfCuentaBase.CerrarMonedasUpdate(Sender: TObject);
begin
  CerrarMonedas.Enabled := not Cuenta.CuentaMovimientos.IsEmpty;
end;

procedure TfCuentaBase.ChartCurvaCapitalMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var serie: TChartSeries;
  i: integer;
begin
  serie := ChartCurvaCapital.Series[0];
  i := serie.Clicked(X, Y);
  if i <> -1 then begin
    Cuenta.CurvaCapital.First;
    Cuenta.CurvaCapital.MoveBy(Cuenta.CurvaCapital.RecordCount - i - 1);
    GridCurvaCapital.Options := GridCurvaCapital.Options + [dgAlwaysShowSelection];
    OnAfterScrollCurvaCapital(nil);
  end;
end;

constructor TfCuentaBase.Create(AOwner: TComponent);
begin
  inherited;
  CurvaCapitalUltimaPos := NO_ASIGNADA;
  Activar(false);
  Configuracion.Grids.LoadColumns(GridMovimientos);
  Configuracion.Grids.LoadColumns(GridCurvaCapital);
  Configuracion.Grids.LoadColumns(GridPosCerradas);
  Configuracion.Grids.LoadColumns(GridPosAbiertas);
{  TUtilGridPopup.Create(GridMovimientos);
  TUtilGridPopup.Create(GridCurvaCapital);
  TUtilGridPopup.Create(GridPosAbiertas);
  TUtilGridPopup.Create(GridPosCerradas);}
end;

procedure TfCuentaBase.DefaultCellColors(const g: TJvDBUltimGrid;
  const Field: TField; AFont: TFont; var Background: TColor);
var i: integer;
begin
  i := 0;
  while (i < g.Columns.Count) and (g.Columns[i].Field <> Field) do
    inc(i);
  Background := g.Columns[i].Color;
  AFont.Color := clBlack;
end;

procedure TfCuentaBase.BeforeDestruction;
begin
  if tsMovimientos.Visible then  
    Configuracion.Grids.SaveColumns(GridMovimientos);
  if tsPosicionesCerradas.Visible then begin
    Configuracion.Grids.SaveColumns(GridCurvaCapital);
    Configuracion.Grids.SaveColumns(GridPosCerradas);
  end;
  if tsPosicionesAbiertas.Visible then
    Configuracion.Grids.SaveColumns(GridPosAbiertas);
  inherited;
end;

procedure TfCuentaBase.GridCurvaCapitalCellClick(Column: TColumn);
begin
  OnAfterScrollCurvaCapital(Self);
end;

procedure TfCuentaBase.GridCurvaCapitalGetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; Highlight: Boolean);
var g: TJvDBUltimGrid;
begin
  inherited;
  g := Sender as TJvDBUltimGrid;
  if (not Field.IsNull) and (not (Field.FieldName = 'FECHA_HORA')) then begin
    if Field.Value >= 0 then
      Verde(Background, AFont, Highlight)
    else
      Rojo(Background, AFont, Highlight);
  end
  else
    DefaultCellColors(g, Field, AFont, Background);
  if g.Row = g.CurrentDrawRow then begin
    AFont.Style := [fsBold];
    Background :=  IncreaseColor(Background);
  end;
end;

procedure TfCuentaBase.GridMovimientosGetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; Highlight: Boolean);
var g: TJvDBUltimGrid;
begin
  inherited;
  g := Sender as TJvDBUltimGrid;  
  if (not Field.IsNull) and (
    (Field.FieldName = 'GANANCIA') or (Field.FieldName = 'GANANCIA_MONEDA_BASE')) then begin
    if Field.Value >= 0 then
      Verde(Background, AFont, Highlight)
    else
      Rojo(Background, AFont, Highlight);
  end
  else
    DefaultCellColors(g, Field, AFont, Background);
  if g.Row = g.CurrentDrawRow then begin
    AFont.Style := [fsBold];
    Background :=  IncreaseColor(Background);
  end;
end;

procedure TfCuentaBase.GridCellClick(Column: TColumn);
begin
  Cuenta.Select(Column.Field, true);
end;

procedure TfCuentaBase.GridPosAbiertasGetCellParams(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; Highlight: Boolean);
var fieldName: string;
  g: TJvDBUltimGrid;
begin
  inherited;
  g := Sender as TJvDBUltimGrid;
  if (Cuenta <> nil) and (Field <> nil) and (not Field.IsNull) then begin
    fieldName := Field.FieldName;
    if fieldName = 'STOP_DIARIO' then begin
      if Cuenta.StopRoto(tcDiaria) then
        Rojo(Background, AFont, Highlight)
      else
        Verde(Background, AFont, Highlight);
    end
    else begin
      if fieldName = 'STOP_SEMANAL' then begin
        if Cuenta.StopRoto(tcSemanal) then
          Rojo(Background, AFont, Highlight)
       else
          Verde(Background, AFont, Highlight);
      end
      else begin
        if (fieldName = 'GANANCIA_TOTAL_DIARIO') or (fieldName = 'GANANCIA_PER_CENT_DIARIO') or
          (fieldName = 'GANANCIA_TOTAL_SEMANAL') or (fieldName = 'GANANCIA_PER_CENT_SEMANAL') then begin
          if Field.Value >= 0 then
            Verde(Background, AFont, Highlight)
          else
            Rojo(Background, AFont, Highlight);
        end
        else
          DefaultCellColors(g, Field, Afont, Background);
      end;
    end;
  end
  else
    DefaultCellColors(g, Field, Afont, Background);
  if g.Row = g.CurrentDrawRow then begin
    AFont.Style := [fsBold];
    Background :=  IncreaseColor(Background);
  end;
end;

procedure TfCuentaBase.GridMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var g: TJvDBUltimGrid;
  row, col: integer;
begin
  g := Sender as TJvDBUltimGrid;
  g.MouseToCell(X, Y, col, row);
  if (col > -1) and (Cuenta.Select(g.Columns[col].Field, false)) then
    g.Cursor := crHandPoint
  else
    g.Cursor := crDefault;
end;

procedure TfCuentaBase.GridPosCerradasGetCellParams(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; Highlight: Boolean);
var g: TJvDBUltimGrid;
begin
  inherited;
  g := Sender as TJvDBUltimGrid;
  AFont.Color := clBlack;
  if (not Field.IsNull) and (Field.FieldName = 'GANANCIA') then begin
    if Field.Value >= 0 then
      Verde(Background, AFont, Highlight)
    else
      Rojo(Background, AFont, Highlight);
  end
  else
    DefaultCellColors(g, Field, AFont, Background);
  if g.Row = g.CurrentDrawRow then begin
    AFont.Style := [fsBold];  
    Background :=  IncreaseColor(Background);
  end;
end;

procedure TfCuentaBase.GridPosicionDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var Canvas: TCanvas;
begin
  if (Column.FieldName = 'POSICION') and (not Column.Field.IsNull) then begin
    Canvas := (Sender as TDBGrid).Canvas;
    Canvas.FillRect(Rect);
    if Column.Field.AsString = 'L' then
      Canvas.Draw(Rect.Left + 2, Rect.Top + 4, iLargo.Picture.Graphic)
    else
      Canvas.Draw(Rect.Left + 3, Rect.Top + 4, iCorto.Picture.Graphic);
  end
  else
    inherited;
end;

procedure TfCuentaBase.GridTitleHint(Sender: TObject; Field: TField;
  var AHint: string; var ATimeOut: Integer);
begin
  AHint := Field.DisplayLabel;
end;

procedure TfCuentaBase.InicializarCurvaCapital;
var serie: TChartSeries;
  color: TColor;
  inspect: TInspectDataSet;
begin
  CurvaCapitalUltimaPos := NO_ASIGNADA;
  serie := ChartCurvaCapital.Series[0];
  serie.Clear;
  inspect := StartInspectDataSet(Cuenta.CurvaCapital);
  try
    serie.Add(0);
    Cuenta.CurvaCapital.Last;
    while not Cuenta.CurvaCapital.Bof do begin
      if Cuenta.CurvaCapitalTOTAL.Value >= 0 then
        color := clGreen
      else
        color := clRed;
      serie.Add(Cuenta.CurvaCapitalTOTAL.Value, ReplaceChar(Cuenta.CurvaCapitalFECHA_HORA.AsString, ' ', #13), color);
      Cuenta.CurvaCapital.Prior;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;

procedure TfCuentaBase.OnAfterScrollCurvaCapital(Sender: TObject);
var serie: TChartSeries;
  i: integer;
begin
  inherited;
  // La curva de capital está inicializada despues de mostrarse.
  if (not Cuenta.CurvaCapital.IsEmpty) and
    (Cuenta.CurvaCapital.State in [dsBrowse]) then begin
    serie := ChartCurvaCapital.Series[0];
    i := serie.Count - Cuenta.CurvaCapital.RecNo;
    if CurvaCapitalUltimaPos <> NO_ASIGNADA then
      serie.ValueColor[CurvaCapitalUltimaPos] := CurvaCapitalUltimoColor;
    CurvaCapitalUltimaPos := i;
    CurvaCapitalUltimoColor := serie.ValueColor[i];
    serie.ValueColor[i] := clNavy;
  end;
end;

procedure TfCuentaBase.OnAnadirCurvaCapital(Sender: TObject);
var serie: TChartSeries;
  color: TColor;
begin
  serie := ChartCurvaCapital.Series[0];
  if Cuenta.CurvaCapitalTOTAL.Value >= 0 then
    color := clGreen
  else
    color := clRed;
  serie.Add(Cuenta.CurvaCapitalTOTAL.Value, ReplaceChar(Cuenta.CurvaCapitalFECHA_HORA.AsString, ' ', #13), color);
end;

procedure TfCuentaBase.OnCapitalRecalculado;
begin
  RepintarTotales;
end;

procedure TfCuentaBase.OnInicializarCurvaCapital;
begin
  InicializarCurvaCapital;
end;

procedure TfCuentaBase.RepintarTotales;
begin
  liCapital.Caption := CurrToStr(FCuenta.Capital) +  ' ' + FCuenta.DescOIDMoneda;
end;

procedure TfCuentaBase.Rojo(var Background: TColor; AFont: TFont;
  Highlight: Boolean);
begin
  if Highlight then begin
    Background := clRed;
    AFont.Color := clWhite;
  end
  else begin
    Background := $00EAEAFF;
    AFont.Color := clBlack;
  end;
end;

procedure TfCuentaBase.SetCuenta(const Value: TCuentaBase);
var tab: TTabSheet;
  procedure TabVisible(const visible: boolean);
  begin
    tsPosicionesAbiertas.TabVisible := visible;
    tsPosicionesCerradas.TabVisible := visible;
    tsMovimientos.TabVisible := visible;
  end;

begin
  FCuenta := Value;
  if FCuenta = nil then begin
    TabVisible(false);
    dsPosicionesAbiertas.DataSet := nil;
    dsPosicionesCerradas.DataSet := nil;
    dsCurvaCapital.DataSet := nil;
    dsCuentaMovimientos.DataSet := nil;
  end
  else begin
    tab := pcPosiciones.ActivePage;
    FCuenta.OnInicializarCurvaCapital := OnInicializarCurvaCapital;
    dsPosicionesAbiertas.DataSet := FCuenta.PosicionesAbiertas;
    dsPosicionesCerradas.DataSet := FCuenta.PosicionesCerradas;
    dsCurvaCapital.DataSet := FCuenta.CurvaCapital;
    dsCuentaMovimientos.DataSet := FCuenta.CuentaMovimientos;
    FCuenta.OnAnadirCurvaCapital := OnAnadirCurvaCapital;
    FCuenta.OnAfterScrollCurvaCapital := OnAfterScrollCurvaCapital;
    FCuenta.OnCapitalRecalculado := OnCapitalRecalculado;
    InicializarCurvaCapital;
    FCuenta.InvalidateValoresActualPosicionesAbiertas;
    TabVisible(true);
    Activar(true);
    if tab.TabVisible then
      pcPosiciones.ActivePage := tab;
    RepintarTotales;
  end;
end;

procedure TfCuentaBase.SetMostrarFechaHora(const Value: boolean);
begin
  FMostrarFechaHora := Value;
  CambiarFechaHoraGrid(GridMovimientos);
  CambiarFechaHoraGrid(GridPosCerradas);
  CambiarFechaHoraGrid(GridCurvaCapital);
  CambiarFechaHoraGrid(GridPosAbiertas);
end;

procedure TfCuentaBase.VerCurvaExecute(Sender: TObject);
begin
  VerCurva.Enabled := false;
  VerPosiciones.Enabled := true;
  VerMixta.Enabled := true;
  pCurvaCapital.Visible := true;
  GridPosCerradas.Visible := false;
end;

procedure TfCuentaBase.Verde(var Background: TColor; AFont: TFont;
  Highlight: Boolean);
begin
  if Highlight then begin
    Background := clGreen;
    AFont.Color := clWhite;
  end
  else begin
    Background := $00ECFFEC;
    AFont.Color := clBlack;
  end;
end;

procedure TfCuentaBase.VerMixtaExecute(Sender: TObject);
begin
  VerMixta.Enabled := false;
  VerPosiciones.Enabled := true;
  VerCurva.Enabled := true;
  pCurvaCapital.Visible := true;
  GridPosCerradas.Align := alBottom;
  GridPosCerradas.Height := 90;
  GridPosCerradas.Visible := true;
end;

procedure TfCuentaBase.VerPosicionesExecute(Sender: TObject);
begin
  VerPosiciones.Enabled := false;
  VerCurva.Enabled := true;
  VerMixta.Enabled := true;
  pCurvaCapital.Visible := false;
  GridPosCerradas.Visible := true;
  GridPosCerradas.Align := alClient;
end;

end.
