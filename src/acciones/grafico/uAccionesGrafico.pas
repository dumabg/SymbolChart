unit uAccionesGrafico;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uAcciones, ActnList, ImgList,
  ActnMan, Menus, SpTBXItem, TB2Dock, TB2Toolbar,
  GraficoBolsa, SpTBXEditors, StdCtrls, TB2Item, UtilFrames;

const
  WM_ZOOM_N_RETURN = WM_USER + 1;

type
  TAccionesGrafico = class(TAcciones)
    HelpPoint: TAction;
    VerNormal: TAction;
    VerVelas: TAction;
    AutoPosicionarCursor: TAction;
    BorrarSeleccionada: TAction;
    BorrarTodas: TAction;
    GraficoMenuItem: TSpTBXSubmenuItem;
    TBXItem1: TSpTBXItem;
    TBXItem3: TSpTBXItem;
    TBXItem5: TSpTBXItem;
    TBXItem6: TSpTBXItem;
    VerEscenario: TAction;
    TBXItem7: TSpTBXItem;
    TBXSeparatorItem2: TSpTBXSeparatorItem;
    TBXItem8: TSpTBXItem;
    ActivarZoom: TAction;
    PopupGrafico: TSpTBXPopupMenu;
    DataHint: TAction;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    SpTBXItem1: TSpTBXItem;
    ZoomNext: TAction;
    ZoomBack: TAction;
    SpTBXItem7: TSpTBXItem;
    SpTBXItem2: TSpTBXItem;
    SpTBXItem3: TSpTBXItem;
    ClearZoom: TAction;
    SpTBXItem4: TSpTBXItem;
    Zoom640: TAction;
    SpTBXItem8: TSpTBXItem;
    ZoomItem: TSpTBXSubmenuItem;
    SpTBXSeparatorItem2: TSpTBXSeparatorItem;
    SpTBXSeparatorItem3: TSpTBXSeparatorItem;
    ZoomN: TAction;
    ZoomNItem: TSpTBXSpinEditItem;
    SpTBXItem9: TSpTBXItem;
    SpTBXSubmenuItem1: TSpTBXSubmenuItem;
    LineaHor: TAction;
    LineaVer: TAction;
    SpTBXSeparatorItem4: TSpTBXSeparatorItem;
    DibujarLineas: TAction;
    SpTBXItem11: TSpTBXItem;
    SpTBXItem12: TSpTBXItem;
    SpTBXSeparatorItem5: TSpTBXSeparatorItem;
    SpTBXItem5: TSpTBXItem;
    SpTBXSeparatorItem6: TSpTBXSeparatorItem;
    VerRecorrido: TAction;
    SpTBXItem6: TSpTBXItem;
    VerRSI: TAction;
    SpTBXItem10: TSpTBXItem;
    SpTBXSeparatorItem7: TSpTBXSeparatorItem;
    SpTBXSubmenuItem2: TSpTBXSubmenuItem;
    ColorFondo: TSpTBXColorPalette;
    ColorLinea: TSpTBXColorPalette;
    ColorCierres: TSpTBXColorPalette;
    SpTBXSubmenuItem3: TSpTBXSubmenuItem;
    SpTBXSubmenuItem4: TSpTBXSubmenuItem;
    SpTBXSubmenuItem5: TSpTBXSubmenuItem;
    ZoomTotal: TAction;
    SpTBXItem14: TSpTBXItem;
    SpTBXSubmenuItem6: TSpTBXSubmenuItem;
    ColorPosicion: TSpTBXColorPalette;
    VerOsciladores: TAction;
    SpTBXItem13: TSpTBXItem;
    SpTBXSubmenuItem7: TSpTBXSubmenuItem;
    SpTBXSubmenuItem8: TSpTBXSubmenuItem;
    SpTBXSubmenuItem9: TSpTBXSubmenuItem;
    ColorLineaDibujada: TSpTBXColorPalette;
    ColorLineaDibujadaSelec: TSpTBXColorPalette;
    VerRanquing: TAction;
    VerEstrategia: TAction;
    procedure HelpPointExecute(Sender: TObject);
    procedure HelpPointUpdate(Sender: TObject);
    procedure VerNormalExecute(Sender: TObject);
    procedure VerVelasExecute(Sender: TObject);
    procedure AutoPosicionarCursorExecute(Sender: TObject);
    procedure BorrarSeleccionadaExecute(Sender: TObject);
    procedure BorrarSeleccionadaUpdate(Sender: TObject);
    procedure BorrarTodasExecute(Sender: TObject);
    procedure BorrarTodasUpdate(Sender: TObject);
    procedure VerEscenarioExecute(Sender: TObject);
    procedure ActivarZoomExecute(Sender: TObject);
    procedure DataHintExecute(Sender: TObject);
    procedure ZoomNextExecute(Sender: TObject);
    procedure ZoomBackExecute(Sender: TObject);
    procedure ZoomBackUpdate(Sender: TObject);
    procedure ZoomNextUpdate(Sender: TObject);
    procedure ClearZoomExecute(Sender: TObject);
    procedure ClearZoomUpdate(Sender: TObject);
    procedure Zoom640Execute(Sender: TObject);
    procedure ZoomNItemBeginEdit(Sender: TObject; Viewer: TSpTBXEditItemViewer;
      EditControl: TCustomEdit);
    procedure ZoomNExecute(Sender: TObject);
    procedure ZoomItemPopup(Sender: TTBCustomItem; FromLink: Boolean);
    procedure ZoomItemClosePopup(Sender: TObject);
    procedure GraficoMenuItemInitPopup(Sender: TObject; PopupView: TTBView);
    procedure PopupGraficoInitPopup(Sender: TObject; PopupView: TTBView);
    procedure LineaLibreExecute(Sender: TObject);
    procedure DibujarLineasExecute(Sender: TObject);
    procedure LineaHorExecute(Sender: TObject);
    procedure LineaVerExecute(Sender: TObject);
    procedure ColorFondoChange(Sender: TObject);
    procedure ColorLineaChange(Sender: TObject);
    procedure ZoomTotalExecute(Sender: TObject);
    procedure ColorCierresChange(Sender: TObject);
    procedure ColorPosicionChange(Sender: TObject);
    procedure VerOsciladoresExecute(Sender: TObject);
    procedure ColorLineaDibujadaChange(Sender: TObject);
    procedure ColorLineaDibujadaSelecChange(Sender: TObject);
    procedure VerOsciladoresUpdate(Sender: TObject);
  private
    Grafico: TGraficoBolsa;
    ActionFrameRecorrido: TActionFrame;
    ActionFrameRSI: TActionFrame;
    ActionFrameRanquing: TActionFrame;
    ActionFrameEstrategia: TActionFrame;
    procedure OnVerOsciladoresCheckedChanged;
    procedure SaveConfigVisual;
    procedure LoadConfigVisual;
    procedure OnValorCambiado;
    procedure OnTipoGraficoChange;
    procedure OnMessageSCShowed;
    procedure AfterZoom;
    procedure OnKeyDownZoomNEditControl(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OnKeyPressZoomNEDitControl(Sender: TObject; var Key: Char);
    procedure OnWMZoomNReturn(var message: TMessage); message WM_ZOOM_N_RETURN;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetBarras: TBarras; override;
    procedure DoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState); override;
  end;


implementation

uses UtilDock, uAccionesValor, SCMain, BusCommunication, dmData,
  Grafico, GraficoZoom, dmConfiguracion, Tipos, GraficoLineasLayer,
  fmPanelRecorrido, fmPanelRSI, GraficoLineas, uAccionesVer, ConfigVisual,
  fmPanelRanquing, fmPanelEstrategia;

{$R *.dfm}

procedure TAccionesGrafico.ActivarZoomExecute(Sender: TObject);
begin
  inherited;
  ActivarZoom.Checked := not ActivarZoom.Checked;
  fSCMain.Grafico.ZoomActive := ActivarZoom.Checked;
end;

procedure TAccionesGrafico.BorrarSeleccionadaExecute(Sender: TObject);
begin
  Grafico.BorrarLineaSeleccionada;
end;

procedure TAccionesGrafico.BorrarSeleccionadaUpdate(Sender: TObject);
begin
  BorrarSeleccionada.Enabled := Grafico.HayLineaSeleccionada;
end;

procedure TAccionesGrafico.BorrarTodasExecute(Sender: TObject);
begin
  inherited;
  Grafico.BorrarLineas;
end;

procedure TAccionesGrafico.BorrarTodasUpdate(Sender: TObject);
begin
  inherited;
  BorrarTodas.Enabled := Grafico.HayLineas;
end;

procedure TAccionesGrafico.ClearZoomExecute(Sender: TObject);
begin
  inherited;
  Grafico.ClearZoom;
end;

procedure TAccionesGrafico.ClearZoomUpdate(Sender: TObject);
begin
  inherited;
  ClearZoom.Enabled := ZoomNext.Enabled or ZoomBack.Enabled;
end;

procedure TAccionesGrafico.ColorCierresChange(Sender: TObject);
begin
  inherited;
  Grafico.ColorPositions := ColorCierres.Color;
end;

procedure TAccionesGrafico.ColorFondoChange(Sender: TObject);
begin
  inherited;
  Grafico.ColorBackgroud := ColorFondo.Color;
end;

procedure TAccionesGrafico.ColorLineaChange(Sender: TObject);
begin
  inherited;
  Grafico.ColorLines := ColorLinea.Color;
end;

procedure TAccionesGrafico.ColorLineaDibujadaChange(Sender: TObject);
begin
  inherited;
  Grafico.ColorDibujarLinea := ColorLineaDibujada.Color;
end;

procedure TAccionesGrafico.ColorLineaDibujadaSelecChange(Sender: TObject);
begin
  inherited;
  Grafico.ColorDibujarLineaSelec := ColorLineaDibujadaSelec.Color;
end;

procedure TAccionesGrafico.ColorPosicionChange(Sender: TObject);
begin
  inherited;
  Grafico.ColorPosition := ColorPosicion.Color;
end;

constructor TAccionesGrafico.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Grafico := fSCMain.Grafico;
  Grafico.PopupMenu := PopupGrafico;
  Bus.RegisterEvent(MessageTipoGraficoChange, OnTipoGraficoChange);
  Bus.RegisterEvent(MessageValorCambiado, OnValorCambiado);
  Grafico.RegisterEvent(MessageGraficoAfterZoom, AfterZoom);
  ActionFrameRecorrido := TActionFrame.Create(Self, VerRecorrido, TfrPanelRecorrido, nil);
  ActionFrameRSI := TActionFrame.Create(Self, VerRSI, TfPanelRSI, nil);
//  ActionFrameRanquing := TActionFrame.Create(Self, VerRanquing, TfrPanelRanquing, nil);
//  ActionFrameEstrategia := TActionFrame.Create(Self, VerEstrategia, TfrPanelEstrategia, nil);
  Bus.RegisterEvent(MessageVistaGuardando, SaveConfigVisual);
  Bus.RegisterEvent(MessageVistaCargando, LoadConfigVisual);
  Bus.RegisterEvent(MessageSCBeforeClose, SaveConfigVisual);
  Bus.RegisterEvent(MessageSCShowed, OnMessageSCShowed);
end;

procedure TAccionesGrafico.DataHintExecute(Sender: TObject);
begin
  inherited;
  DataHint.Checked := not DataHint.Checked;
  Grafico.ShowDataHint := DataHint.Checked;
end;

destructor TAccionesGrafico.Destroy;
begin
  Bus.UnregisterEvent(MessageVistaGuardando, SaveConfigVisual);
  Bus.UnregisterEvent(MessageVistaCargando, LoadConfigVisual);
  Bus.UnregisterEvent(MessageSCBeforeClose, SaveConfigVisual);
  Bus.UnregisterEvent(MessageTipoGraficoChange, OnTipoGraficoChange);
  Bus.UnregisterEvent(MessageValorCambiado, OnValorCambiado);
  Grafico.UnregisterEvent(MessageGraficoAfterZoom, AfterZoom);
  inherited;
end;


procedure TAccionesGrafico.DibujarLineasExecute(Sender: TObject);
var checked: Boolean;
begin
  inherited;
  checked := not DibujarLineas.Checked;
  DibujarLineas.Checked := checked;
  DataHint.Enabled := not checked;
  Grafico.DrawLinesActive := checked;
  LineaHor.Enabled := checked;
  LineaVer.Enabled := checked;
end;

procedure TAccionesGrafico.DoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ActivarZoom.Checked then
    if Key = VK_ESCAPE then begin
      ActivarZoomExecute(nil);
      Key := 0;
    end;
end;

function TAccionesGrafico.GetBarras: TBarras;
begin
  result := inherited GetBarras;
  result[0].Dock.Position := dpIzquierdaCentro;
end;

procedure TAccionesGrafico.HelpPointExecute(Sender: TObject);
begin
  inherited;
  fSCMain.Grafico.HelpPoint;
end;

procedure TAccionesGrafico.HelpPointUpdate(Sender: TObject);
begin
//  HelpPoint.Enabled := not PainterLines.Active;
end;

procedure TAccionesGrafico.LineaHorExecute(Sender: TObject);
begin
  inherited;
  Grafico.LineType := ltHorizontal;
  Grafico.LineType := ltNormal;  
end;

procedure TAccionesGrafico.LineaLibreExecute(Sender: TObject);
begin
  inherited;
  Grafico.LineType := ltNormal;
end;

procedure TAccionesGrafico.LineaVerExecute(Sender: TObject);
begin
  inherited;
  Grafico.LineType := ltVertical;
  Grafico.LineType := ltNormal;
end;

procedure TAccionesGrafico.LoadConfigVisual;
begin
  ActionFrameRSI.Checked := ConfiguracionVisual.ReadBoolean(ClassName, 'VerRSI', false);
  ActionFrameRecorrido.Checked := ConfiguracionVisual.ReadBoolean(ClassName, 'VerRecorrido', false);
  VerOsciladores.Checked := ConfiguracionVisual.ReadBoolean(ClassName, 'VerOsciladores', true);
  OnVerOsciladoresCheckedChanged;
end;

procedure TAccionesGrafico.OnKeyDownZoomNEditControl(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    PostMessage(Handle, WM_ZOOM_N_RETURN, 0, 0);
end;

procedure TAccionesGrafico.OnKeyPressZoomNEDitControl(Sender: TObject;
  var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TAccionesGrafico.OnMessageSCShowed;
begin
  LoadConfigVisual;
  Bus.UnregisterEvent(MessageSCShowed, OnMessageSCShowed);
end;

procedure TAccionesGrafico.OnTipoGraficoChange;
begin
  case Grafico.Tipo of
    tgbLineas: VerNormal.Checked := true;
    tgbVelas: VerVelas.Checked := true;
    tgbEscenario: VerEscenario.Checked := true;
  end;
end;

procedure TAccionesGrafico.OnValorCambiado;
begin
{  if AutoPosicionarCursor.Checked then
    Data.IrACotizacionUltimaFecha;}
end;

procedure TAccionesGrafico.OnVerOsciladoresCheckedChanged;
begin
  fSCMain.PanelOsicladoresVisible := VerOsciladores.Checked;
end;

procedure TAccionesGrafico.OnWMZoomNReturn(var message: TMessage);
begin
  ZoomNExecute(nil);
end;

procedure TAccionesGrafico.PopupGraficoInitPopup(Sender: TObject;
  PopupView: TTBView);
begin
  inherited;
  PopupGrafico.LinkSubitems := Toolbar.Items;
end;

procedure TAccionesGrafico.SaveConfigVisual;
begin
  ConfiguracionVisual.WriteBoolean(ClassName, 'VerRSI', ActionFrameRSI.Checked);
  ConfiguracionVisual.WriteBoolean(ClassName, 'VerRecorrido', ActionFrameRecorrido.Checked);
  ConfiguracionVisual.WriteBoolean(ClassName, 'VerOsciladores', VerOsciladores.Checked);
end;

procedure TAccionesGrafico.GraficoMenuItemInitPopup(Sender: TObject;
  PopupView: TTBView);
begin
  inherited;
  GraficoMenuItem.LinkSubitems := Toolbar.Items;
end;

procedure TAccionesGrafico.AfterZoom;
begin
  ActivarZoom.Checked := false;
  fSCMain.Grafico.ZoomActive := false;
end;

procedure TAccionesGrafico.AutoPosicionarCursorExecute(Sender: TObject);
begin
  inherited;
  fSCMain.Grafico.AutoPosicionarCursor := AutoPosicionarCursor.Checked;
end;

procedure TAccionesGrafico.VerEscenarioExecute(Sender: TObject);
begin
  fSCMain.Grafico.Tipo := tgbEscenario;
end;

procedure TAccionesGrafico.VerNormalExecute(Sender: TObject);
begin
  fSCMain.Grafico.Tipo := tgbLineas;
end;

procedure TAccionesGrafico.VerOsciladoresExecute(Sender: TObject);
begin
  inherited;
  VerOsciladores.Checked := not VerOsciladores.Checked;
  OnVerOsciladoresCheckedChanged;
end;

procedure TAccionesGrafico.VerOsciladoresUpdate(Sender: TObject);
begin
  inherited;
  VerOsciladores.Enabled := fSCMain.Grafico.Tipo = tgbLineas;
end;

procedure TAccionesGrafico.VerVelasExecute(Sender: TObject);
begin
  fSCMain.Grafico.Tipo := tgbVelas;
end;

procedure TAccionesGrafico.ZoomNExecute(Sender: TObject);
begin
  inherited;
  Grafico.GetGrafico.ZoomSesiones(ZoomNItem.SpinOptions.ValueAsInteger);
end;

procedure TAccionesGrafico.ZoomNextExecute(Sender: TObject);
begin
  inherited;
  Grafico.GetGrafico.ZoomNext;
end;

procedure TAccionesGrafico.ZoomNextUpdate(Sender: TObject);
begin
  inherited;
  ZoomNext.Enabled := Grafico.GetGrafico.CanZoomNext;
end;

procedure TAccionesGrafico.ZoomNItemBeginEdit(Sender: TObject;
  Viewer: TSpTBXEditItemViewer; EditControl: TCustomEdit);
begin
  inherited;
  with TSpTBXUnicodeEdit(EditControl) do begin
    OnKeyPress := OnKeyPressZoomNEDitControl;
    OnKeyDown := OnKeyDownZoomNEditControl;
  end;
end;

procedure TAccionesGrafico.ZoomTotalExecute(Sender: TObject);
begin
  inherited;
  Grafico.GetGrafico.ZoomAll;
end;

procedure TAccionesGrafico.Zoom640Execute(Sender: TObject);
begin
  inherited;
  Grafico.GetGrafico.ZoomSesiones(640);
end;

procedure TAccionesGrafico.ZoomBackExecute(Sender: TObject);
begin
  inherited;
  Grafico.GetGrafico.ZoomBack;
end;

procedure TAccionesGrafico.ZoomBackUpdate(Sender: TObject);
begin
  inherited;
  ZoomBack.Enabled := Grafico.GetGrafico.CanZoomBack;
end;

procedure TAccionesGrafico.ZoomItemClosePopup(Sender: TObject);
begin
  inherited;
  Configuracion.WriteInteger(ClassName, 'ZoomNItem', ZoomNItem.SpinOptions.ValueAsInteger);
end;

procedure TAccionesGrafico.ZoomItemPopup(Sender: TTBCustomItem;
  FromLink: Boolean);
begin
  inherited;
  ZoomNItem.SpinOptions.MaxValue := Grafico.GetGrafico.Datos.DataCount;
  ZoomNItem.SpinOptions.MinValue := 20;
  ZoomNItem.SpinOptions.Value := Configuracion.ReadInteger(ClassName, 'ZoomNItem', 450);
end;

initialization
  RegisterAccionesAfter(TAccionesGrafico, TAccionesValor);

end.
