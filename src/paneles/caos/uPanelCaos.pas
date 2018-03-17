unit uPanelCaos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, uPanelNotificaciones, ExtCtrls, Buttons, mini, miniDB, StdCtrls,
  DBCtrls, TB2Dock, SpTBXItem, GIFImg, Menus, GraficoLineasLayer, TB2Item,
  TB2Toolbar, ActnList, ImgList;

type
  TfrPanelCaos = class(TfrPanelNotificaciones)
    dsCotizacionEstado: TDataSource;
    dsCotizacion: TDataSource;
    Bevel2: TBevel;
    Bevel8: TBevel;
    Cierre: TDBText;
    CambioBaja: TDBText;
    CambioDobleBaja: TDBText;
    CambioDobleSube: TDBText;
    CambioSube: TDBText;
    Dinero: TDBText;
    DineroBaja: TDBText;
    DineroBajaDoble: TDBText;
    DineroDobleSube: TDBText;
    DineroSube: TDBText;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image19: TImage;
    Image20: TImage;
    ImagenSubeDoble2: TImage;
    Image5: TImage;
    ImagenBaja: TImage;
    ImagenBajaDoble: TImage;
    ImagenBajaDoble2: TImage;
    ImagenSube: TImage;
    ImagenSubeDoble: TImage;
    Panel1: TPanel;
    Mapa: TDBMiniMap;
    Papel: TDBText;
    PapelBaja: TDBText;
    PapelBajaDoble: TDBText;
    PapelDobleSube: TDBText;
    PapelSube: TDBText;
    PorcentajeBaja: TDBText;
    PorcentajeDobleBaja: TDBText;
    PorcentajeDobleSube: TDBText;
    PorcentajeSube: TDBText;
    PresionLat: TDBText;
    PresionLatAlzaDoble: TDBText;
    PresionLatAlzaSimple: TDBText;
    PresionLatBajaDoble: TDBText;
    PresionLatBajaSimple: TDBText;
    PresionVert: TDBText;
    PresionVertAltaSimple: TDBText;
    PresionVertAlzaDoble: TDBText;
    PresionVertBajaDoble: TDBText;
    PresionVertBajaSimple: TDBText;
    Shape1: TShape;
    Shape2: TShape;
    Shape9: TShape;
    Zona: TDBText;
    ZonaBaja: TDBText;
    ZonaBajaDoble: TDBText;
    ZonaDobleSube: TDBText;
    ZonaSube: TDBText;
    TBXToolWindow: TSpTBXToolWindow;
    ActionList: TActionList;
    ImageList: TImageList;
    VerLetras: TAction;
    SpTBXToolbar1: TSpTBXToolbar;
    ItemVerLetras: TSpTBXItem;
    ItemMapaValores: TSpTBXItem;
    procedure ImagenSubeDobleClick(Sender: TObject);
    procedure ImagenSubeClick(Sender: TObject);
    procedure ImagenBajaClick(Sender: TObject);
    procedure ImagenBajaDobleClick(Sender: TObject);
    procedure VerLetrasExecute(Sender: TObject);
  private
    FEstadoSube: TEstado;
    FEstadoSubeDoble: TEstado;
    FEstadoBaja: TEstado;
    FEstadoBajaDoble: TEstado;
    LineaBajaSimple, LineaBajaDoble, LineaSubeSimple, LineaSubeDoble: THorizontalLine;
    procedure EstadoDineroPapel;
    procedure ClearEstadoSube;
    procedure ClearEstadoBajaDoble;
    procedure ClearEstadoSubeDoble;
    procedure ClearEstadoBaja;
    procedure LoadConfigVisual;
    procedure SaveConfigVisual;
  protected
    procedure OnCotizacionCambiada; override;
    procedure OnValorCambiado; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetNombre: string; override;
  end;

implementation

{$R *.dfm}

uses dmData, uPanel, fmCalendario, UtilDock, SCMain, GraficoPositionLayer,
  uAcciones, uAccionesValor, BusCommunication, uAccionesVer, ConfigVisual,
  GraficoLineas, GR32;

resourcestring
  NOMBRE = 'Teoría del caos';

type
  TLineaCambios = class(THorizontalLine)
  protected
    function CanBorrar: boolean; override;
  public
    constructor Create(const GraficoLineasLayer: TGraficoLinesLayer;
      const y: currency; const Color: TColor); reintroduce;
    function isPointInLine(p: TPoint): boolean; override;
  end;

{ TfrSituacion }

procedure TfrPanelCaos.ClearEstadoBaja;
begin
  if FEstadoBaja <> nil then begin
    Mapa.DeleteEstado(FEstadoBaja);
    FEstadoBaja := nil;
  end;
  if LineaBajaSimple <> nil then begin
    fSCMain.Grafico.GetGraficoLinesLayer.BorrarLinea(LineaBajaSimple);
    LineaBajaSimple := nil;
  end;
end;

procedure TfrPanelCaos.ClearEstadoBajaDoble;
begin
  if FEstadoBajaDoble <> nil then begin
    Mapa.DeleteEstado(FEstadoBajaDoble);
    FEstadoBajaDoble := nil;
  end;
  if LineaBajaDoble <> nil then begin
    fSCMain.Grafico.GetGraficoLinesLayer.BorrarLinea(LineaBajaDoble);
    LineaBajaDoble := nil;
  end;
end;

procedure TfrPanelCaos.ClearEstadoSube;
begin
  if FEstadoSube <> nil then begin
    Mapa.DeleteEstado(FEstadoSube);
    FEstadoSube := nil;
  end;
  if LineaSubeSimple <> nil then begin
    fSCMain.Grafico.GetGraficoLinesLayer.BorrarLinea(LineaSubeSimple);
    LineaSubeSimple := nil;
  end;
end;

procedure TfrPanelCaos.ClearEstadoSubeDoble;
begin
  if FEstadoSubeDoble <> nil then begin
    Mapa.DeleteEstado(FEstadoSubeDoble);
    FEstadoSubeDoble := nil;
  end;
  if LineaSubeDoble <> nil then begin
    fSCMain.Grafico.GetGraficoLinesLayer.BorrarLinea(LineaSubeDoble);
    LineaSubeDoble := nil;
  end;
end;

constructor TfrPanelCaos.Create(AOwner: TComponent);
var defaultDock: TDefaultDock;
  accionesValor: TAccionesValor;
begin
  defaultDock.Position := dpAbajo;
  defaultDock.Pos := 215;
  defaultDock.Row := 1;
  inherited CreatePanelNotificaciones(AOwner, defaultDock, [pnValorCambiado, pnCotizacionCambiada]);
  FEstadoSube := nil;
  FEstadoSubeDoble := nil;
  FEstadoBaja := nil;
  FEstadoBajaDoble := nil;
  OnValorCambiado;
  OnCotizacionCambiada;
  accionesValor := TAccionesValor(GetAcciones(TAccionesValor));
  ItemMapaValores.Action := accionesValor.MapaValores;
  ItemMapaValores.Images := accionesValor.ImageList;
  ItemMapaValores.ImageIndex := accionesValor.MapaValores.ImageIndex;
  Bus.RegisterEvent(MessageVistaGuardando, SaveConfigVisual);
  Bus.RegisterEvent(MessageVistaCargando, LoadConfigVisual);
  LoadConfigVisual;
end;

destructor TfrPanelCaos.Destroy;
begin
  SaveConfigVisual;
  Bus.UnregisterEvent(MessageVistaGuardando, SaveConfigVisual);
  Bus.UnregisterEvent(MessageVistaCargando, LoadConfigVisual);
  inherited;
end;

procedure TfrPanelCaos.EstadoDineroPapel;
  procedure Color(const control: TDBText);
  var imaginario: boolean;
     valor: currency;
     field: TField;
  begin
    field := control.Field;
    if field <> nil then begin
      valor := field.AsCurrency;
      imaginario := (valor >= 45) and (valor <= 135);
      if imaginario then
        control.Font.Color := clRed
      else
        control.Font.Color := clBlack;
    end
    else
      control.Font.Color := clSilver;
  end;
begin
  Color(DineroBaja);
  Color(DineroBajaDoble);
  Color(Dinero);
  Color(DineroSube);
  Color(DineroDobleSube);
  Color(Papel);
  Color(PapelDobleSube);
  Color(PapelSube);
  Color(PapelBajaDoble);
  Color(PapelBaja);
end;

class function TfrPanelCaos.GetNombre: string;
begin
  result := NOMBRE;
end;

procedure TfrPanelCaos.ImagenBajaClick(Sender: TObject);
var lineasLayer: TGraficoLinesLayer;
begin
  if FEstadoBaja = nil then begin
    if Data.CotizacionCIERRE.Value > 0 then begin
      FEstadoBaja := Mapa.AddEstado('Baja', '', DineroBaja.Field.AsCurrency,
        PapelBaja.Field.AsCurrency, ZonaBaja.Field.AsString, $00000099);
      lineasLayer := fSCMain.Grafico.GetGraficoLinesLayer;
      LineaBajaSimple := TLineaCambios.Create(lineasLayer,
        Data.CotizacionEstadoCAMBIO_BAJA_SIMPLE.Value, $00000099);
      lineasLayer.AddLine(LineaBajaSimple);
    end;
  end
  else
    ClearEstadoBaja;
end;

procedure TfrPanelCaos.ImagenBajaDobleClick(Sender: TObject);
var lineasLayer: TGraficoLinesLayer;
begin
  if FEstadoBajaDoble = nil then begin
    if Data.CotizacionCIERRE.Value > 0 then begin
      FEstadoBajaDoble := Mapa.AddEstado('Baja doble', '',
        DineroBajaDoble.Field.AsCurrency, PapelBajaDoble.Field.AsCurrency,
        ZonaBajaDoble.Field.AsString, clRed);
      lineasLayer := fSCMain.Grafico.GetGraficoLinesLayer;
      LineaBajaDoble := TLineaCambios.Create(lineasLayer,
        Data.CotizacionEstadoCAMBIO_BAJA_DOBLE.Value, clRed);
      lineasLayer.AddLine(LineaBajaDoble);
    end;
  end
  else
    ClearEstadoBajaDoble;
end;

procedure TfrPanelCaos.ImagenSubeClick(Sender: TObject);
var lineasLayer: TGraficoLinesLayer;
begin
  if FEstadoSube = nil then begin
    if Data.CotizacionCIERRE.Value > 0 then begin
      FEstadoSube := Mapa.AddEstado('Sube', '', DineroSube.Field.AsCurrency,
        PapelSube.Field.AsCurrency, ZonaSube.Field.AsString, clGreen);
      lineasLayer := fSCMain.Grafico.GetGraficoLinesLayer;
      LineaSubeSimple := TLineaCambios.Create(lineasLayer,
        Data.CotizacionEstadoCAMBIO_ALZA_SIMPLE.Value, clGreen);
      lineasLayer.AddLine(LineaSubeSimple);
    end;
  end
  else
    ClearEstadoSube;
end;

procedure TfrPanelCaos.ImagenSubeDobleClick(Sender: TObject);
var lineasLayer: TGraficoLinesLayer;
begin
  if FEstadoSubeDoble = nil then begin
    if Data.CotizacionCIERRE.Value > 0 then begin
      FEstadoSubeDoble := Mapa.AddEstado('Sube doble', '',
        DineroDobleSube.Field.AsCurrency, PapelDobleSube.Field.AsCurrency,
        ZonaDobleSube.Field.AsString, clLime);
      lineasLayer := fSCMain.Grafico.GetGraficoLinesLayer;
      LineaSubeDoble := TLineaCambios.Create(lineasLayer,
        Data.CotizacionEstadoCAMBIO_ALZA_DOBLE.Value, clLime);
      lineasLayer.AddLine(LineaSubeDoble);
    end;
  end
  else
    ClearEstadoSubeDoble;
end;

procedure TfrPanelCaos.LoadConfigVisual;
begin
  Mapa.ShowLetras := ConfiguracionVisual.ReadBoolean(ClassName, 'Mapa.ShowLetras', false);
end;

procedure TfrPanelCaos.OnCotizacionCambiada;
begin
  ClearEstadoSube;
  ClearEstadoBajaDoble;
  ClearEstadoSubeDoble;
  ClearEstadoBaja;
  EstadoDineroPapel;
end;

procedure TfrPanelCaos.OnValorCambiado;
begin
  ClearEstadoSube;
  ClearEstadoBajaDoble;
  ClearEstadoSubeDoble;
  ClearEstadoBaja;
end;

procedure TfrPanelCaos.SaveConfigVisual;
begin
  ConfiguracionVisual.WriteBoolean(ClassName, 'Mapa.ShowLetras', Mapa.ShowLetras);
end;

procedure TfrPanelCaos.VerLetrasExecute(Sender: TObject);
begin
  inherited;
  VerLetras.Checked := not VerLetras.Checked;
  Mapa.ShowLetras := VerLetras.Checked;
end;

{ TLineaCambios }

function TLineaCambios.CanBorrar: boolean;
begin
  result := false;
end;

constructor TLineaCambios.Create(const GraficoLineasLayer: TGraficoLinesLayer;
  const y: currency; const Color: TColor);
var c32: TColor32;
  pattern: TArrayOfColor32;
begin
  inherited Create(GraficoLineasLayer, y);
  c32 := Color32(Color);
  SetLength(pattern, 4);
  pattern[0] := c32;
  pattern[1] := c32;
  pattern[2] := 0;
  pattern[3] := 0;
  Stipple := pattern;
end;

function TLineaCambios.isPointInLine(p: TPoint): boolean;
begin
  result := false;
end;

initialization
  RegisterPanelClass(TfrPanelCaos);

end.
