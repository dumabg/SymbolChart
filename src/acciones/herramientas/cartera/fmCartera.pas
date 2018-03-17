unit fmCartera;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmInversorCartera, Grids, DBGrids, JvExDBGrids, JvDBGrid,
  JvDBUltimGrid, DB, ExtCtrls, ActnList, XPStyleActnCtrls, ActnMan,
  ImgList, Buttons, JvComponentBase, JvPluginManager,
  DBCtrls, frCuentaBase,
  fmCuentaCartera,
  fmBaseMasterDetalle, DBActns, JvExExtCtrls, JvNetscapeSplitter, dmCartera,
  AppEvnts, TB2Item, SpTBXItem, TB2Dock, TB2Toolbar, dmAccionesCartera;

type
  TfCartera = class(TfBaseMasterDetalle)
    ToolbarCartera: TSpTBXToolbar;
    TBXItem3: TSpTBXItem;
    TBXItem4: TSpTBXItem;
    TBXSeparatorItem1: TSpTBXSeparatorItem;
    TBXItem5: TSpTBXItem;
    CuentaCartera: TfCuentaCartera;
    ActionManager: TActionManager;
    CerrarPosicion: TAction;
    AnadirCapital: TAction;
    RetirarCapital: TAction;
    AbrirPosicion: TAction;
    ImageList: TImageList;
    FechaHora: TAction;
    TBXSeparatorItem2: TSpTBXSeparatorItem;
    TBXItem6: TSpTBXItem;
    procedure FormCreate(Sender: TObject);
    procedure BorrarExecute(Sender: TObject);
    procedure BorrarUpdate(Sender: TObject);
    procedure RetirarCapitalExecute(Sender: TObject);
    procedure JvDBUltimGrid1ShowTitleHint(Sender: TObject; Field: TField;
  var AHint: string; var ATimeOut: Integer);
    procedure AnadirCapitalExecute(Sender: TObject);
    procedure AbrirPosicionExecute(Sender: TObject);
    procedure AnadirExecute(Sender: TObject);
    procedure CuentaCarteraConfirmarExecute(Sender: TObject);
    procedure CuentaCarteraCerrarPosicionExecute(Sender: TObject);
    procedure dsMasterDataChange(Sender: TObject; Field: TField);
    procedure CuentaCarteraBuscarPosicionesExecute(Sender: TObject);
    procedure CuentaCarteraPosicionarExecute(Sender: TObject);
    procedure FechaHoraExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FInversor: TInversorCartera;
    FAccionesCartera: TAccionesCartera;
    function GetCartera: TCartera;
    procedure OnDatosActualizados;
  public
    // Cuando se quite el main, mover este método a protected o borrarlo
    procedure InvalidateValoresActualPosicionesAbiertas;
    procedure RefrescarEstrategias;
    function EstaCalculando: boolean;
    property Cartera: TCartera read GetCartera;
    property Inversor: TInversorCartera read FInversor;
    property AccionesCartera: TAccionesCartera read FAccionesCartera write FAccionesCartera;
  end;


implementation

uses fmAnadirRetirarCapital,
  UtilForms, fmAnadirValorCartera, 
  fmNuevaCartera, dmInversor, BusCommunication, dmData, dmActualizarDatos;

{$R *.dfm}

resourcestring
  BORRAR_CARTERA = '¿Desea borrar la cartera %s?';


procedure TfCartera.AbrirPosicionExecute(Sender: TObject);
begin
  inherited;
  ShowFormModal(TfAnadirValorCartera, Self);
end;

procedure TfCartera.AnadirCapitalExecute(Sender: TObject);
var f: TfAnadirRetirarCapital;
begin
  inherited;
  f := TfAnadirRetirarCapital.Create(nil);
  try
    f.Anadir := true;
    if f.ShowModal = mrOk then begin
      Inversor.AnadirCapital(f.Capital);
    end;
  finally
    f.Free;
  end;
end;

procedure TfCartera.AnadirExecute(Sender: TObject);
var form: TfNuevaCartera;
begin
  form := TfNuevaCartera.Create(nil);
  try
    with form do
      if ShowModal = mrOk then begin
        Inversor.CrearCartera(Nombre, Capital, Paquetes, USA100, OIDMoneda,
          OIDBroker, Broker);
        FAccionesCartera.ReloadNumCarteras;
        pDetalle.Visible := true;
      end;
  finally
    form.Free;
  end;
end;

procedure TfCartera.BorrarExecute(Sender: TObject);
var msg: string;
begin
  inherited;
  msg := Format(BORRAR_CARTERA, [Inversor.Cartera.qCarteraNOMBRE.Value]);
  if MessageDlg(msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    Inversor.BorrarCuenta;
    FAccionesCartera.ReloadNumCarteras;
    pDetalle.Visible := Cartera.HayCarteras;
  end;
end;

procedure TfCartera.BorrarUpdate(Sender: TObject);
begin
  inherited;
  Borrar.Enabled := Inversor.HayCuentas;
end;

procedure TfCartera.CuentaCarteraBuscarPosicionesExecute(Sender: TObject);
begin
  inherited;
  CuentaCartera.BuscarPosicionesExecute(Sender);
end;

procedure TfCartera.CuentaCarteraCerrarPosicionExecute(Sender: TObject);
begin
  inherited;
  CuentaCartera.CerrarPosicionExecute(Sender);
end;

procedure TfCartera.CuentaCarteraConfirmarExecute(Sender: TObject);
begin
  inherited;
  CuentaCartera.ConfirmarExecute(Sender);
end;

procedure TfCartera.CuentaCarteraPosicionarExecute(Sender: TObject);
begin
  inherited;
  CuentaCartera.PosicionarExecute(Sender);
end;

procedure TfCartera.dsMasterDataChange(Sender: TObject; Field: TField);
var dataset: TDataSet;
  fieldNombre: TStringField;
begin
  inherited;
  dataset := dsMaster.DataSet;
  if (dataset = nil) or (dataSet.IsEmpty) then
    Caption := 'Cartera'
  else begin
    fieldNombre := dataset.FieldByName('NOMBRE') as TStringField;
    if fieldNombre.IsNull then
      Caption := 'Cartera'
    else begin
      if dataset.State in [dsInsert] then
        Caption := 'Cartera - (Nueva cartera)'
      else
        Caption := 'Cartera - ' + fieldNombre.Value;
    end;
  end;
end;

function TfCartera.EstaCalculando: boolean;
begin
  result := CuentaCartera.EstaCalculando;
end;

procedure TfCartera.FechaHoraExecute(Sender: TObject);
begin
  inherited;
  FechaHora.Checked := not FechaHora.Checked;
  CuentaCartera.MostrarFechaHora := FechaHora.Checked;
end;

procedure TfCartera.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

procedure TfCartera.FormCreate(Sender: TObject);
begin
  inherited;
  FInversor := TInversorCartera.Create(Self);
  CuentaCartera.Inversor := Inversor;
  CuentaCartera.Valores := Data.Valores;
//  CuentaCartera.TipoCotizacion := Data.TipoCotizacion;
  dsMaster.DataSet := Cartera.qCartera;
  AddCaptionButtons(Self, [cbAlwaysOnTop, cbMaximize]);
  pDetalle.Visible := Cartera.HayCarteras;
  CuentaCartera.MostrarFechaHora := false;
  FechaHora.Checked := false;

  Bus.RegisterEvent(MessageDatosActualizados, OnDatosActualizados);
end;

function TfCartera.GetCartera: TCartera;
begin
  result := Inversor.Cartera;
end;

procedure TfCartera.InvalidateValoresActualPosicionesAbiertas;
begin
  Cartera.InvalidateValoresActualPosicionesAbiertas;
end;

procedure TfCartera.RefrescarEstrategias;
begin
  Inversor.RefrescarEstrategias;
end;

procedure TfCartera.RetirarCapitalExecute(Sender: TObject);
var capital, capitalDisponible: currency;
var f: TfAnadirRetirarCapital;
begin
  inherited;
  f := TfAnadirRetirarCapital.Create(nil);
  try
    f.Anadir := false;
    if f.ShowModal = mrOk then begin
      capitalDisponible := Inversor.Capital;
      capital := f.Capital;
      if capitalDisponible < capital then begin
        if MessageDlg('El capital a retirar es mayor que el capital del que se dispone. ' +
          '¿Desea continuar?',
          mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        Inversor.RetirarCapital(capital);
      end
      else
        Inversor.RetirarCapital(capital);
    end;
  finally
    f.Free;
  end;
end;

procedure TfCartera.JvDBUltimGrid1ShowTitleHint(Sender: TObject; Field: TField;
  var AHint: string; var ATimeOut: Integer);
begin
  inherited;
  AHint := Field.DisplayLabel;
end;


procedure TfCartera.OnDatosActualizados;
begin
  InvalidateValoresActualPosicionesAbiertas;
end;

end.
