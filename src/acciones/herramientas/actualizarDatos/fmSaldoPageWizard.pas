unit fmSaldoPageWizard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmSaldo, ActnList, StdCtrls, Buttons, ExtCtrls, wizard,
  JvExControls, DBCtrls, DB, Grids, DBGrids, JvExDBGrids,
  ComCtrls, JvExComCtrls, GIFImg, JvExExtCtrls, JvGradient, JvXPCore,
  JvXPButtons, JvAnimatedImage, JvGIFCtrl, JvComCtrls;

type
  TfSaldoPage = class;

  TfSaldoPageWizard = class(TComponent, IWizardPage)
  private
    form: TfSaldoPage;
    wizardMethods: TWizardMethods;
    procedure setWizardMethods(const wizardMethods: TWizardMethods);
  public
    function getForm: TForm;
  end;


  TfSaldoPage = class(TfSaldo)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bDescargarClick(Sender: TObject);
  private
    wizardMethods: TWizardMethods;
  public
    procedure setWizardMethods(const wizardMethods: TWizardMethods);
  end;


implementation

uses fmLoginActualizarPageWizard;

{$R *.dfm}

{ TfSaldoPage }

procedure TfSaldoPage.bDescargarClick(Sender: TObject);
begin
  inherited;
  wizardMethods.NextPage;
end;

procedure TfSaldoPage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  wizardMethods.Close;
end;

procedure TfSaldoPage.setWizardMethods(
  const wizardMethods: TWizardMethods);
begin
  Self.wizardMethods := wizardMethods;
end;


{ TfSaldoPageWizard }

function TfSaldoPageWizard.getForm: TForm;
var loginPage: TfLoginActualizarPageWizard;
begin
  if form = nil then begin
    loginPage := wizardMethods.getPreviousPage as TfLoginActualizarPageWizard;
    form := TfSaldoPage.Create(Self, loginPage.LoginState, loginPage.Usuario);
    form.setWizardMethods(wizardMethods);
  end;
  result := form;
end;

procedure TfSaldoPageWizard.setWizardMethods(
  const wizardMethods: TWizardMethods);
begin
  Self.wizardMethods := wizardMethods;
end;

end.
