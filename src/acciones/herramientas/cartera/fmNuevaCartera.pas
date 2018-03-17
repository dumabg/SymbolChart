unit fmNuevaCartera;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBaseNuevo, StdCtrls, Buttons, JvExStdCtrls, 
  ExtCtrls, Mask, JvExMask, JvSpin, DB, JvCombobox,
  JvDBSearchComboBox, AppEvnts, dmNuevaCartera,
  JvGIF;

type
  TfNuevaCartera = class(TfBaseNuevo)
    eCapital: TJvSpinEdit;
    Label4: TLabel;
    Label5: TLabel;
    ePaquetes: TJvSpinEdit;
    cbUSA100: TCheckBox;
    Label10: TLabel;
    Image3: TImage;
    Label2: TLabel;
    scMoneda: TJvDBSearchComboBox;
    dsMoneda: TDataSource;
    Label6: TLabel;
    scbBroker: TJvDBSearchComboBox;
    dsBrokers: TDataSource;
    lMoneda: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure scMonedaChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    NuevaCartera: TNuevaCartera;
    function GetCapital: integer;
    function GetPaquetes: integer;
    function GetUSA100: boolean;
    function GetNombre: string;
    function GetOIDMoneda: integer;
    function GetOIDBroker: integer;
    function GetBroker: string;
  public
    property Capital: integer read GetCapital;
    property Paquetes: integer read GetPaquetes;
    property USA100: boolean read GetUSA100;
    property Nombre: string read GetNombre;
    property OIDMoneda: integer read GetOIDMoneda;
    property Broker: string read GetBroker;
    property OIDBroker: integer read GetOIDBroker;
  end;


implementation

uses dmConfiguracion;

{$R *.dfm}

resourcestring
  SIN_BROKERS = 'Para poder crear una cartera es necesario tener definido como mínimo 1 broker.' +
    sLineBreak + 'Para ello seleccione en el menú Herramientas la opción Brokers.';

{ TfNuevaCartera }

procedure TfNuevaCartera.FormCreate(Sender: TObject);
begin
  inherited;
  NuevaCartera := TNuevaCartera.Create(Self);
  scMonedaChange(nil);
end;

procedure TfNuevaCartera.FormShow(Sender: TObject);
begin
  inherited;
  if NuevaCartera.qBrokers.IsEmpty then begin
    ShowMessage(SIN_BROKERS);
    ModalResult := mrCancel;
    PostMessage(Handle, WM_CLOSE, 0, 0);
  end;
end;

function TfNuevaCartera.GetBroker: string;
begin
  result := scbBroker.Text;
end;

function TfNuevaCartera.GetCapital: integer;
begin
  result := eCapital.AsInteger;
end;

function TfNuevaCartera.GetNombre: string;
begin
  result := eNombre.Text;
end;

function TfNuevaCartera.GetOIDBroker: integer;
begin
  result := NuevaCartera.qBrokersOID_BROKER.Value;
end;

function TfNuevaCartera.GetOIDMoneda: integer;
begin
  result := dsMoneda.DataSet.FieldByName('OID_MONEDA').AsInteger;
end;

function TfNuevaCartera.GetPaquetes: integer;
begin
  result := ePaquetes.AsInteger;
end;

function TfNuevaCartera.GetUSA100: boolean;
begin
  result := cbUSA100.Checked;
end;

procedure TfNuevaCartera.scMonedaChange(Sender: TObject);
begin
  inherited;
  lMoneda.Caption := scMoneda.Text;
end;

end.
