unit uAccionesHerramientas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uAcciones, ActnList, ImgList, TB2Item, SpTBXItem, TB2Dock, TB2Toolbar,
  dmAccionesCartera;

type
  TAccionesHerramientas = class(TAcciones)
    TBXSubmenuItem1: TSpTBXSubmenuItem;
    StopManual: TAction;
    Actualizar: TAction;
    EstadoCuenta: TAction;
    Configurar: TAction;
    Exportar: TAction;
    RentabilidadMercados: TAction;
    AnalisisRapido: TAction;
    Cartera: TAction;
    AnadirCartera: TAction;
    Estudios: TAction;
    Estrategias: TAction;
    Brokers: TAction;
    Bloquear: TAction;
    Correo: TAction;
    TBXItem1: TSpTBXItem;
    TBXItem2: TSpTBXItem;
    TBXSubmenuItem2: TSpTBXSubmenuItem;
    TBXItem52: TSpTBXItem;
    TBXItem35: TSpTBXItem;
    TBXSeparatorItem31: TSpTBXSeparatorItem;
    TBXSubmenuItem6: TSpTBXSubmenuItem;
    TBXItem135: TSpTBXItem;
    TBXItem110: TSpTBXItem;
    TBXItem130: TSpTBXItem;
    TBXItem131: TSpTBXItem;
    TBXItem133: TSpTBXItem;
    TBXSeparatorItem32: TSpTBXSeparatorItem;
    TBXItem129: TSpTBXItem;
    ExportarDatosItemMenu: TSpTBXItem;
    TBXItem95: TSpTBXItem;
    TBXItem54: TSpTBXItem;
    TBXItem137: TSpTBXItem;
    TBXSeparatorItem6: TSpTBXSeparatorItem;
    ConfiguracionItemMenu: TSpTBXItem;
    TBXSeparatorItem35: TSpTBXSeparatorItem;
    TBXItem136: TSpTBXItem;
    Tareas: TAction;
    SpTBXItem1: TSpTBXItem;
    SpTBXItem2: TSpTBXItem;
    SpTBXItem3: TSpTBXItem;
    Ranquing: TAction;
    Estadistica: TAction;
    procedure StopManualExecute(Sender: TObject);
    procedure ActualizarExecute(Sender: TObject);
    procedure EstadoCuentaExecute(Sender: TObject);
    procedure ConfigurarExecute(Sender: TObject);
    procedure ExportarExecute(Sender: TObject);
    procedure CorreoExecute(Sender: TObject);
    procedure AnalisisRapidoExecute(Sender: TObject);
    procedure BloquearExecute(Sender: TObject);
    procedure BloquearUpdate(Sender: TObject);
    procedure BrokersExecute(Sender: TObject);
    procedure EstrategiasExecute(Sender: TObject);
    procedure TareasExecute(Sender: TObject);
    procedure RentabilidadMercadosExecute(Sender: TObject);
    procedure EstudiosExecute(Sender: TObject);
    procedure CarteraExecute(Sender: TObject);
    procedure AnadirCarteraExecute(Sender: TObject);
    procedure AnadirCarteraUpdate(Sender: TObject);
    procedure RanquingExecute(Sender: TObject);
    procedure EstadisticaExecute(Sender: TObject);
  private
    AccionesCartera: TAccionesCartera;
  public
    constructor Create(AOwner: TComponent); override;
    function GetBarras: TBarras; override;
  end;


implementation

uses uAccionesEscenarios, fmStopsManuales, UtilForms, UtilDock,
  dmConfiguracion, fmConfiguracion, fmExportar, SCMain, fmCorreo,
  fmAnalisisRapido, fmBloquear, fmBrokers, fmEstrategias,
  fmTareas, fmRentabilidadMercados, fmEstudios, fmActualizarDatosWizard, fmLogin,
  fmEstadoCuenta, fmCartera, fmAnadirValorCartera, fmRanquing, fmEstadistica;

{$R *.dfm}

const
  TFORMCARTERA_INTERNAL_NAME = '__cartera';

procedure TAccionesHerramientas.ActualizarExecute(Sender: TObject);
begin
  ShowFormModal(TfActualizarDatosWizard);
end;

procedure TAccionesHerramientas.AnadirCarteraExecute(Sender: TObject);
begin
  inherited;
  ShowFormModal(TfAnadirValorCartera);
end;

procedure TAccionesHerramientas.AnadirCarteraUpdate(Sender: TObject);
begin
  inherited;
  AnadirCartera.Enabled := AccionesCartera.HayCarteras;
end;

procedure TAccionesHerramientas.AnalisisRapidoExecute(Sender: TObject);
begin
  inherited;
  ShowForm(TfAnalisisRapido, Self);
end;

procedure TAccionesHerramientas.BloquearExecute(Sender: TObject);
var cerrar: boolean;
  fBloquear: TfBloquear;
begin
  inherited;
  fSCMain.Visible := false;
  cerrar := false;
  try
    fBloquear := TfBloquear.Create(nil);
    try
      fBloquear.ShowModal;
      cerrar := fBloquear.CerrarAplicacion;
    finally
      fBloquear.Free;
    end;
  finally
    if cerrar then
      fSCMain.Close
    else begin
      fSCMain.Visible := true;
      fSCMain.BringToFront;
    end;
  end;
end;

procedure TAccionesHerramientas.BloquearUpdate(Sender: TObject);
begin
  Bloquear.Enabled := Configuracion.Identificacion.Bloquear;
end;

procedure TAccionesHerramientas.BrokersExecute(Sender: TObject);
begin
  inherited;
  ShowFormModal(TfBrokers);
end;

procedure TAccionesHerramientas.CarteraExecute(Sender: TObject);
var f: TfCartera;
begin
  inherited;
  f := TfCartera(ShowForm(TfCartera, Self, TFORMCARTERA_INTERNAL_NAME));
  f.AccionesCartera := AccionesCartera;
end;

procedure TAccionesHerramientas.ConfigurarExecute(Sender: TObject);
begin
  ShowFormModal(TfConfiguracion);
end;

procedure TAccionesHerramientas.CorreoExecute(Sender: TObject);
begin
  inherited;
  ShowFormModal(TfCorreo);
end;

constructor TAccionesHerramientas.Create(AOwner: TComponent);
begin
  inherited;
  AccionesCartera := TAccionesCartera.Create(Self);
end;

procedure TAccionesHerramientas.EstadisticaExecute(Sender: TObject);
begin
  inherited;
   ShowFormModal(TfEstadistica);
end;

procedure TAccionesHerramientas.EstadoCuentaExecute(Sender: TObject);
var login: TfLogin;
  fEstadoCuenta: TfEstadoCuenta;
begin
  login := TfLogin.Create(nil);
  try
    login.CloseOnLogged := True;
    login.ShowModal;
    login.Close;
    if login.IsLogged then begin
      fEstadoCuenta := TfEstadoCuenta.Create(nil, Configuracion.Sistema.URLServidor,
        login.LoginState, login.fLoginServer.Usuario);
      try
        fEstadoCuenta.Conectar;
        fEstadoCuenta.ShowModal;
      finally
        fEstadoCuenta.Free;
      end;
    end;
  finally
    login.Free;
  end;
end;

procedure TAccionesHerramientas.EstrategiasExecute(Sender: TObject);
var cartera: TfCartera;
begin
  inherited;
  ShowFormModal(TfEstrategias);
  cartera := FindComponent(TFORMCARTERA_INTERNAL_NAME) as TfCartera;
  if cartera <> nil then
    cartera.RefrescarEstrategias;
end;

procedure TAccionesHerramientas.EstudiosExecute(Sender: TObject);
begin
  inherited;
//  ShowForm(TfEstudios, fSCMain);
  ShowFormModal(TfEstudios);
end;

procedure TAccionesHerramientas.ExportarExecute(Sender: TObject);
begin
  inherited;
  ShowForm(TfExportar, fSCMain);
end;

function TAccionesHerramientas.GetBarras: TBarras;
begin
  result := inherited GetBarras;
  result[0].Dock.Position := dpArribaBotones;
end;

procedure TAccionesHerramientas.RanquingExecute(Sender: TObject);
begin
  inherited;
  ShowFormModal(TfRanquing);
end;

procedure TAccionesHerramientas.RentabilidadMercadosExecute(Sender: TObject);
begin
  inherited;
  ShowFormModal(TfRentabilidadMercados);
end;

procedure TAccionesHerramientas.StopManualExecute(Sender: TObject);
begin
  ShowFormModal(TfStopsManuales);
end;

procedure TAccionesHerramientas.TareasExecute(Sender: TObject);
begin
  inherited;
  ShowForm(TfTareas, Self);
end;

initialization
  RegisterAccionesAfter(TAccionesHerramientas, TAccionesEscenarios);

end.
