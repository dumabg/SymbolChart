unit fmLoginActualizarPageWizard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmLoginActualizar, ActnList, StdCtrls, Buttons, ExtCtrls,
  wizard, JvExControls, 
  JvXPCore, JvXPButtons, GIFImg, frUsuario, frLoginServer;

type
  TfLoginActualizarPageWizard = class(TfLoginActualizar, IWizardPage)
  private
    wizardMethods: TWizardMethods;
    procedure setWizardMethods(const wizardMethods: TWizardMethods);
    function getForm: TForm;
  protected
    procedure OnLogged(Sender: TObject); override;
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

{ TfLoginPageWizard }

function TfLoginActualizarPageWizard.getForm: TForm;
begin
  result := Self;
end;

procedure TfLoginActualizarPageWizard.OnLogged;
begin
  inherited;
  wizardMethods.NextPage;
end;

procedure TfLoginActualizarPageWizard.setWizardMethods(
  const wizardMethods: TWizardMethods);
begin
  Self.wizardMethods := wizardMethods;
end;

end.
