unit fmEstudioNuevo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, DB, StdCtrls, JvExStdCtrls, JvCombobox, JvDBSearchComboBox,
  Buttons, dmEstudioNuevo, ActnList, XPStyleActnCtrls, ActnMan, 
  ExtCtrls, JvWizard, JvWizardRouteMapNodes, JvExControls,
  frSeleccionFechas, Mask, JvExMask, JvSpin, AppEvnts, JvGIF;

const
  // CUIDADO + 2, ya que en el fBase existe el + 1
  WM_FINISH = WM_USER + 2;

type
  TfEstudioNuevo = class(TfBase)
    Label1: TLabel;
    eNombre: TEdit;
    mDescripcion: TMemo;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label3: TLabel;
    scbTipo: TJvDBSearchComboBox;
    dsEstrategias: TDataSource;
    JvWizardEstudio: TJvWizard;
    JvWizardRouteMapNodes1: TJvWizardRouteMapNodes;
    PageNombre: TJvWizardInteriorPage;
    PagePeriodo: TJvWizardInteriorPage;
    ActionManager: TActionManager;
    SelecTodo: TAction;
    SelecNinguno: TAction;
    SelecInvert: TAction;
    ePaquetes: TJvSpinEdit;
    Label5: TLabel;
    Label6: TLabel;
    scbBroker: TJvDBSearchComboBox;
    dsBroker: TDataSource;
    lMoneda: TLabel;
    cbUSA100: TCheckBox;
    Label10: TLabel;
    Label11: TLabel;
    Image2: TImage;
    fSeleccionFechas: TfSeleccionFechas;
    cbMonedas: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure PagePeriodoFinishButtonClick(Sender: TObject;
      var Stop: Boolean);
    procedure SiguienteExecute(Sender: TObject);
    procedure eNombreKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure cbMonedasChange(Sender: TObject);
  private
    EstudioNuevo: TEstudioNuevo;
    function GetNombre: string;
    function GetDescripcion: string;
    function GetOIDEstrategia: integer;
    function GetDesde: TDate;
    function GetHasta: TDate;
    procedure DoFinish(var message:TMessage); message WM_FINISH;
    function GetCapital: integer;
    function GetPaquetes: integer;
    function GetNombreEstrategia: string;
    function GetDescripcionEstrategia: string;
    function GetOIDBroker: integer;
    function GetUSA100: boolean;
    function GetOIDMoneda: integer;
    procedure ActualizarMoneda;
  public
    property Nombre: string read GetNombre;
    property Descripcion: string read GetDescripcion;
    property NombreEstrategia: string read GetNombreEstrategia;
    property DescripcionEstrategia: string read GetDescripcionEstrategia;
    property OIDEstrategia: integer read GetOIDEstrategia;
    property Desde: TDate read GetDesde;
    property Hasta: TDate read GetHasta;
    property Paquetes: integer read GetPaquetes;
    property Capital: integer read GetCapital;
    property OIDBroker: integer read GetOIDBroker;
    property USA100: boolean read GetUSA100;
    property OIDMoneda: integer read GetOIDMoneda;
  end;

implementation

uses dmConfiguracion, dmDataComun;

{$R *.dfm}

resourcestring
  SIN_ESTRATEGIAS = 'Para poder crear un estudio es necesario tener definido como mínimo 1 estrategia.' +
    sLineBreak + 'Para ello seleccione en el menú Herramientas la opción Estrategias.';
  SIN_BROKERS = 'Para poder crear un estudio es necesario tener definido como mínimo 1 broker.' +
    sLineBreak + 'Para ello seleccione en el menú Herramientas la opción Brokers.';


procedure TfEstudioNuevo.ActualizarMoneda;
begin
  lMoneda.Caption := cbMonedas.Text;
end;

procedure TfEstudioNuevo.cbMonedasChange(Sender: TObject);
begin
  inherited;
  ActualizarMoneda;
end;

procedure TfEstudioNuevo.DoFinish(var message: TMessage);
begin
  ModalResult := mrOk;
  Configuracion.WriteDateTime('Nuevo estudio', 'desde', fSeleccionFechas.Desde);
  Configuracion.WriteDateTime('Nuevo estudio', 'hasta', fSeleccionFechas.Hasta);
end;

procedure TfEstudioNuevo.eNombreKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Trim(eNombre.Text) = '' then
    PageNombre.EnabledButtons := [bkCancel]
  else
    PageNombre.EnabledButtons := [bkNext, bkCancel];
end;

procedure TfEstudioNuevo.FormCreate(Sender: TObject);
var monedas: PDataComunMonedas;
  i: integer;
begin
  inherited;
  EstudioNuevo := TEstudioNuevo.Create(Self);
  ActualizarMoneda;
  monedas := DataComun.Monedas;
  for i := Low(monedas^) to High(monedas^) do begin
    cbMonedas.AddItem(monedas^[i].Nombre, TObject(monedas^[i].OIDMoneda));
  end;
  i := cbMonedas.Items.IndexOf('EUR');
  cbMonedas.ItemIndex := i;
  ActualizarMoneda;
end;

procedure TfEstudioNuevo.FormShow(Sender: TObject);
var error: string;
  desde, hasta: TDate;
begin
  inherited;
  error := '';
  if EstudioNuevo.qEstrategias.IsEmpty then
    error := SIN_ESTRATEGIAS;
  if EstudioNuevo.qBroker.IsEmpty then begin
    if error <> '' then
      error := error + sLineBreak + sLineBreak;
    error := error + SIN_BROKERS;
  end;
  if error = '' then begin // sin error
    desde := Configuracion.ReadDateTime('Nuevo estudio', 'desde', 0);
    if desde <> 0 then
      fSeleccionFechas.Desde := desde;
    hasta := Configuracion.ReadDateTime('Nuevo estudio', 'hasta', 0);
    if hasta <> 0 then
      fSeleccionFechas.Hasta := hasta;
  end
  else begin
    ShowMessage(error);
    ModalResult := mrCancel;
    PostMessage(Handle, WM_CLOSE, 0, 0);
  end;
end;

function TfEstudioNuevo.GetCapital: integer;
begin
  result := 10000;
end;

function TfEstudioNuevo.GetDescripcion: string;
begin
  result := mDescripcion.Text;
end;

function TfEstudioNuevo.GetDescripcionEstrategia: string;
begin
  result := EstudioNuevo.qEstrategiasDESCRIPCION.Value;
end;

function TfEstudioNuevo.GetDesde: TDate;
begin
  result := fSeleccionFechas.Desde;
end;

function TfEstudioNuevo.GetHasta: TDate;
begin
  result := fSeleccionFechas.Hasta;
end;

function TfEstudioNuevo.GetNombre: string;
begin
  result := eNombre.Text;
end;

function TfEstudioNuevo.GetNombreEstrategia: string;
begin
  result := scbTipo.Text;
end;

function TfEstudioNuevo.GetOIDBroker: integer;
begin
  result := EstudioNuevo.qBrokerOID_BROKER.Value;
end;

function TfEstudioNuevo.GetOIDEstrategia: integer;
begin
  result := EstudioNuevo.qEstrategiasOID_ESTRATEGIA.Value;
end;

function TfEstudioNuevo.GetOIDMoneda: integer;
begin
  result := Integer(cbMonedas.Items.Objects[cbMonedas.ItemIndex]);
end;

function TfEstudioNuevo.GetPaquetes: integer;
begin
  result := ePaquetes.AsInteger;
end;

function TfEstudioNuevo.GetUSA100: boolean;
begin
  result := cbUSA100.Checked;
end;

procedure TfEstudioNuevo.PagePeriodoFinishButtonClick(Sender: TObject;
  var Stop: Boolean);
begin
  inherited;
  PostMessage(Handle, WM_FINISH, 0, 0);
end;

procedure TfEstudioNuevo.SiguienteExecute(Sender: TObject);
begin
  inherited;
//
end;

end.
