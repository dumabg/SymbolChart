unit uAccionesEscenarios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uAcciones, ActnList, ImgList, EscenarioController, TB2Item,
  SpTBXItem, TB2Dock, TB2Toolbar, GraficoEscenario;

type
  TAccionesEscenarios = class(TAcciones)
    NuevoEscenario: TAction;
    VerMedia: TAction;
    VerEscenarioSimple: TAction;
    CrearMedia: TAction;
    EscenarioPrior: TAction;
    EscenarioNext: TAction;
    CancelarNuevoEscenario: TAction;
    CancelarCrearMedia: TAction;
    MenuEscenarios: TSpTBXSubmenuItem;
    BorrarEscenario: TAction;
    VerNube: TAction;
    MenuNuevoEscenario: TSpTBXItem;
    MenuNuevaMedia: TSpTBXItem;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    SpTBXItem4: TSpTBXItem;
    SpTBXItem5: TSpTBXItem;
    SpTBXItem1: TSpTBXItem;
    SpTBXItem2: TSpTBXItem;
    PlusvaliaRiesgo: TAction;
    procedure NuevoEscenarioExecute(Sender: TObject);
    procedure CancelarNuevoEscenarioExecute(Sender: TObject);
    procedure CancelarCrearMediaExecute(Sender: TObject);
    procedure CrearMediaExecute(Sender: TObject);
    procedure VerMediaExecute(Sender: TObject);
    procedure VerEscenarioSimpleExecute(Sender: TObject);
    procedure BorrarEscenarioExecute(Sender: TObject);
    procedure BorrarEscenarioUpdate(Sender: TObject);
    procedure VerNubeExecute(Sender: TObject);
    procedure PlusvaliaRiesgoExecute(Sender: TObject);
  private
    EscenarioController: TEscenarioController;
    procedure OnValorCambiado;
    procedure Borrar;
    procedure OnTerminateCreacion(Sender: TObject);
    procedure EnableMenus(const creando: boolean); overload;
    procedure EnableMenus(const creando, media: boolean); overload;
    procedure CrearNuevoEscenario(const media: boolean);
    function GetGraficoEscenario: TGraficoEscenario;
    property GraficoEscenario: TGraficoEscenario read GetGraficoEscenario;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetBarras: TBarras; override;
  end;

implementation

uses uAccionesGrafico, UtilDock, SCMain, GraficoBolsa, uAccionesVer,
  uPanelEscenario, GraficoZoom, BusCommunication, dmData,
  GraficoPositionLayer, ConfigVisual, fmPlusvaliaRiesgo;

{$R *.dfm}

resourcestring
  ESCENARIO_NO_VALIDO = 'No se ha podido encontrar un escenario válido para este gráfico';

{ TAccionesEscenarios }

procedure TAccionesEscenarios.Borrar;
var accionesVer: TAccionesVer;
  pEscenario: TfrEscenario;
  ge: TGraficoEscenario;
begin
  ge := GraficoEscenario;
  if ge <> nil then
    GraficoEscenario.Borrar;
  if EscenarioController <> nil then
    EscenarioController.Borrar;
  VerMedia.Enabled := false;
  VerEscenarioSimple.Enabled := false;
  VerNube.Enabled := false;
  BorrarEscenario.Enabled := false;

  accionesVer := GetAcciones(TAccionesVer) as TAccionesVer;
  pEscenario := accionesVer.GetPanel(TfrEscenario) as TfrEscenario;
  if pEscenario <> nil then
    pEscenario.Borrar;
end;

procedure TAccionesEscenarios.BorrarEscenarioExecute(Sender: TObject);
begin
  inherited;
  Borrar;
end;

procedure TAccionesEscenarios.BorrarEscenarioUpdate(Sender: TObject);
begin
  inherited;
  //INCREIBLE!! Si no se pone este update, BorrarEscenario siempre aparece Enabled
  // aunque por código lo desconectes
  BorrarEscenario.Enabled := VerEscenarioSimple.Enabled;
end;

procedure TAccionesEscenarios.CancelarCrearMediaExecute(Sender: TObject);
begin
  inherited;
  if EscenarioController <> nil then
    EscenarioController.Cancelar;
end;

procedure TAccionesEscenarios.CancelarNuevoEscenarioExecute(Sender: TObject);
begin
  inherited;
  if EscenarioController <> nil then
    EscenarioController.Cancelar;
end;

procedure TAccionesEscenarios.CrearMediaExecute(Sender: TObject);
begin
  inherited;
  CrearNuevoEscenario(true);
end;

procedure TAccionesEscenarios.CrearNuevoEscenario(const media: boolean);
begin
  inherited;
  EnableMenus(true, media);
  fSCMain.Grafico.Tipo := tgbEscenario;
  if EscenarioController = nil then
    EscenarioController := TEscenarioController.Create(GraficoEscenario);
  EscenarioController.OnTerminate := OnTerminateCreacion;
  EscenarioController.Crear(media);
end;

constructor TAccionesEscenarios.Create(AOwner: TComponent);
begin
  inherited;
  Bus.RegisterEvent(MessageValorCambiado, OnValorCambiado);
  VerNube.Checked := ConfiguracionVisual.ReadBoolean(ClassName, 'VerNube', true);
end;

destructor TAccionesEscenarios.Destroy;
begin
  Bus.UnregisterEvent(MessageValorCambiado, OnValorCambiado);
  if EscenarioController <> nil then
    EscenarioController.Free;
  ConfiguracionVisual.WriteBoolean(ClassName, 'VerNube', VerNube.Checked);
  inherited;
end;

procedure TAccionesEscenarios.EnableMenus(const creando: boolean);
var i, num: integer;
begin
  num := ActionList.ActionCount - 1;
  for i := 0 to num do
    TAction(ActionList.Actions[i]).Enabled := not creando;
end;

procedure TAccionesEscenarios.EnableMenus(const creando, media: boolean);
begin
  EnableMenus(creando);
  if media then begin
    CancelarCrearMedia.Enabled := true;
    CancelarCrearMedia.Visible := true;
    MenuNuevaMedia.Visible := false;
  end
  else begin
    CancelarNuevoEscenario.Enabled := true;
    CancelarNuevoEscenario.Visible := true;
    MenuNuevoEscenario.Visible := False;
  end;
end;

function TAccionesEscenarios.GetBarras: TBarras;
begin
  result := inherited GetBarras;
  result[0].Dock.Position := dpDerechaCentro;
end;

function TAccionesEscenarios.GetGraficoEscenario: TGraficoEscenario;
begin
  result := fSCMain.Grafico.GetGrafico(tgbEscenario) as TGraficoEscenario;
end;

procedure TAccionesEscenarios.NuevoEscenarioExecute(Sender: TObject);
begin
  CrearNuevoEscenario(false);
end;

procedure TAccionesEscenarios.OnTerminateCreacion(Sender: TObject);
var panelEscenario: TfrEscenario;
  accionesVer: TAccionesVer;
  graficoEscenario: TGraficoEscenario;
  positionLayer: TGraficoPositionLayer;
  datosEscenario: TDatosGraficoEscenario;
begin
  EnableMenus(false);

  CancelarCrearMedia.Visible := false;
  MenuNuevaMedia.Visible := true;
  CancelarNuevoEscenario.Visible := false;
  MenuNuevoEscenario.Visible := true;

  if (EscenarioController.Canceled) or (EscenarioController.NoEncontrado) then begin
    GetGraficoEscenario.Borrar;
    accionesVer := GetAcciones(TAccionesVer) as TAccionesVer;
    panelEscenario := TfrEscenario(accionesVer.GetPanel(TfrEscenario));
    if panelEscenario <> nil then
      panelEscenario.Borrar;
    if (not EscenarioController.Canceled) and (EscenarioController.NoEncontrado) then
      ShowMessage(ESCENARIO_NO_VALIDO);
  end
  else begin
    accionesVer := GetAcciones(TAccionesVer) as TAccionesVer;
    accionesVer.MostrarPanel(TfrEscenario);
    panelEscenario := TfrEscenario(accionesVer.GetPanel(TfrEscenario));
    graficoEscenario := GetGraficoEscenario;
    graficoEscenario.ShowMedia := VerMedia.Checked;
    graficoEscenario.VerNube := VerNube.Checked;
    panelEscenario.GraficoEscenario := graficoEscenario;

    positionLayer := fSCMain.Grafico.GetGraficoPositionLayer;
    datosEscenario := TDatosGraficoEscenario(graficoEscenario.Datos);
    positionLayer.Position := datosEscenario.DataCount - 1;
    positionLayer.Position := datosEscenario.UltimoIData + 1;
  end;
end;

procedure TAccionesEscenarios.OnValorCambiado;
begin
  Borrar;
end;

procedure TAccionesEscenarios.PlusvaliaRiesgoExecute(Sender: TObject);
var pr: TfPlusvaliaRiesgo;
  nombre: string;
  aux: TComponent;
begin
  inherited;
  nombre := TfPlusvaliaRiesgo.ClassName;
  aux := FindComponent(nombre);
  if aux = nil then begin
    pr := TfPlusvaliaRiesgo.Create(Self);
    pr.Name := nombre;
  end
  else
    pr := TfPlusvaliaRiesgo(aux);
  pr.Show;
end;

procedure TAccionesEscenarios.VerEscenarioSimpleExecute(Sender: TObject);
begin
  inherited;
  GraficoEscenario.ShowMedia := false;
end;

procedure TAccionesEscenarios.VerMediaExecute(Sender: TObject);
begin
  inherited;
  GraficoEscenario.ShowMedia := true;
end;

procedure TAccionesEscenarios.VerNubeExecute(Sender: TObject);
begin
  inherited;
  VerNube.Checked := not VerNube.Checked;
  GraficoEscenario.VerNube := VerNube.Checked;
end;

initialization
  RegisterAccionesAfter(TAccionesEscenarios, TAccionesGrafico);

end.
