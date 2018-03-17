unit fmActualizarDatosWizard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, OleCtrls, ExtCtrls, wizard,
  Readhtml, FramView, FramBrwz, fmActualizarDatosPageWizard;

type
  TfActualizarDatosWizard = class(TfBase)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    wizard: TWizard;
    actualizarDatos: TfActualizarDatosPageWizard;
    procedure OnClose;
  end;

implementation

{$R *.dfm}

uses fmLoginActualizarPageWizard, fmSaldoPageWizard, fmResumenPageWizard;

procedure TfActualizarDatosWizard.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  wizard.CanClose(CanClose);
end;

procedure TfActualizarDatosWizard.FormCreate(Sender: TObject);
begin
  inherited;
  wizard := TWizard.Create(Self);
  wizard.OnClose := OnClose;
  wizard.AddWizardPage(TfLoginActualizarPageWizard.Create(Self));
  wizard.AddWizardPage(TfSaldoPageWizard.Create(Self));
  actualizarDatos := TfActualizarDatosPageWizard.Create(Self);
  wizard.AddWizardPage(actualizarDatos);
  wizard.AddWizardPage(TfResumenPageWizard.Create(Self));
  wizard.FirstPage;
end;

procedure TfActualizarDatosWizard.FormDestroy(Sender: TObject);
begin
  inherited;
  wizard.Free;
end;

procedure TfActualizarDatosWizard.OnClose;
begin
  Close;
end;

end.
