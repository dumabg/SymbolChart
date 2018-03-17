unit fmActualizarDatosPageWizard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBaseServer, ActnList, StdCtrls, Buttons, ExtCtrls,
  fmActualizarDatos, ComCtrls, wizard, GIFImg, Grids, DBGrids, JvExDBGrids,
  JvDBGrid, JvDBUltimGrid, JvExComCtrls, JvComCtrls, DB;

type
  TfActualizarDatosPage = class;

  TfActualizarDatosPageWizard = class(TComponent, IWizardPage)
  private
    form: TfActualizarDatosPage;
    wizardMethods: TWizardMethods;
    procedure setWizardMethods(const wizardMethods: TWizardMethods);
    function getForm: TForm;
  end;

  TfActualizarDatosPage = class(TfActualizarDatos)
    procedure VerCambiosClick(Sender: TObject);
    procedure bHechoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bVerModificacionesClick(Sender: TObject);
    procedure TimerCancelarTimer(Sender: TObject);
    procedure bHechoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FWizardMethods: TWizardMethods;
  public
    property wizardMethods: TWizardMethods write FWizardMethods;
  end;


implementation

uses fmLoginActualizarPageWizard, fmMensajePageWizard, fmSaldo;

{$R *.dfm}

{ TfActualizarDatosPageWizard }


procedure TfActualizarDatosPage.bHechoClick(Sender: TObject);
var mensajePage: TfMensajePageWizard;
begin
  mensajePage := TfMensajePageWizard.Create(Self);
  if mensajePage.hasMessage then begin
    FWizardMethods.AddWizardPage(mensajePage);
    FWizardMethods.GotoPage(mensajePage);
  end
  else
    FWizardMethods.Close;
end;

procedure TfActualizarDatosPage.bHechoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
//
end;

procedure TfActualizarDatosPage.bVerModificacionesClick(Sender: TObject);
begin
  FWizardMethods.NextPage;
end;

procedure TfActualizarDatosPage.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FWizardMethods.Close;
end;

procedure TfActualizarDatosPage.TimerCancelarTimer(Sender: TObject);
begin
  inherited;

end;

{ TfActualizarDatosPageWizard }

procedure TfActualizarDatosPageWizard.setWizardMethods(
  const wizardMethods: TWizardMethods);
begin
  Self.wizardMethods := wizardMethods;
end;


function TfActualizarDatosPageWizard.getForm: TForm;
var loginPage: TfLoginActualizarPageWizard;
  saldo: TfSaldo;
begin
  if form = nil then begin
    loginPage := wizardMethods.getPage(0) as TfLoginActualizarPageWizard;
    saldo := (wizardMethods.getPage(1) as TfSaldo);
    form := TfActualizarDatosPage.Create(Self, loginPage.LoginState,
      saldo.Diario, saldo.Semanal);
    form.wizardMethods := wizardMethods;
  end;
  result := form;
end;


procedure TfActualizarDatosPage.VerCambiosClick(Sender: TObject);
begin
  inherited;
  FWizardMethods.NextPage;
end;

end.
