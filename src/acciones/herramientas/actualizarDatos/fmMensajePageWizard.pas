unit fmMensajePageWizard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmMensaje, ActnList, OleCtrls, Buttons,
  JvExControls, ExtCtrls, wizard, Readhtml,
  FramView, FramBrwz, JvXPCore, JvXPButtons;

type
  TfMensajePageWizard = class(TfMensaje, IWizardPage)
    procedure HechoClick(Sender: TObject);
  private
    wizardMethods: TWizardMethods;
    procedure setWizardMethods(const wizardMethods: TWizardMethods);
    function getForm: TForm;
  public
    function hasMessage: boolean;
  end;

implementation

uses UserServerCalls;

{$R *.dfm}

{ TfMensajePageWizard }

function TfMensajePageWizard.getForm: TForm;
begin
  result := Self;
end;

function TfMensajePageWizard.hasMessage: boolean;
var serverCall: TMensajeServerCall;
  msg: string;
begin
  serverCall := TMensajeServerCall.Create;
  try
    try
      msg := serverCall.Call;
      result := msg <> 'no';
      if result then
        URI := msg;
    except
      on e: Exception do
        result := false;
    end;
  finally
    serverCall.Free;
  end;
end;

procedure TfMensajePageWizard.HechoClick(Sender: TObject);
begin
  inherited;
  wizardMethods.Close;
end;

procedure TfMensajePageWizard.setWizardMethods(
  const wizardMethods: TWizardMethods);
begin
  Self.wizardMethods := wizardMethods;
end;

end.
