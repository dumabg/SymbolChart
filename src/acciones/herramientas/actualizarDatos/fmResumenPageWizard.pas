unit fmResumenPageWizard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmResumen, ActnList, StdCtrls, Buttons, 
  ExtCtrls, wizard, Grids, DBGrids, JvExDBGrids,
  JvDBGrid, JvDBUltimGrid, DB;

type
  TfResumenPageWizard = class(TfResumen, IWizardPage)
    procedure HechoClick(Sender: TObject);
  private
    wizardMethods: TWizardMethods;
    procedure setWizardMethods(const wizardMethods: TWizardMethods);
    function getForm: TForm;
  public
  end;


implementation

uses fmMensajePageWizard;

{$R *.dfm}

{ TfResumen1 }

function TfResumenPageWizard.getForm: TForm;
begin
  result := Self;
end;

procedure TfResumenPageWizard.HechoClick(Sender: TObject);
var mensajePage: TfMensajePageWizard;
begin
  inherited;
  mensajePage := TfMensajePageWizard.Create(Self);
  if mensajePage.hasMessage then begin
    wizardMethods.AddWizardPage(mensajePage);
    wizardMethods.GotoPage(mensajePage);
  end
  else
    wizardMethods.Close;
end;

procedure TfResumenPageWizard.setWizardMethods(const wizardMethods: TWizardMethods);
begin
  Self.wizardMethods := wizardMethods;
end;

end.
