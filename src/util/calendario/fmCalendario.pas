unit fmCalendario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frCalendario, Buttons;

type
  TfCalendario = class(TForm)
    FrameCalendario: TframeCalendario;
    procedure FormCreate(Sender: TObject);
    procedure FrameCalendarioCerrarClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
  protected
    procedure OnSelectDay;
  public
    constructor Create(const AOwner: TComponent; const OIDValor: integer); reintroduce;
  end;


implementation

{$R *.dfm}

{ TfCalendario }

constructor TfCalendario.Create(const AOwner: TComponent;
  const OIDValor: integer);
begin
  inherited Create(AOwner);
  FrameCalendario.CreateCalendar(OIDValor);
end;

procedure TfCalendario.FormCreate(Sender: TObject);
begin
  FrameCalendario.OnSelectDay := OnSelectDay;
end;

procedure TfCalendario.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TfCalendario.FrameCalendarioCerrarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfCalendario.OnSelectDay;
begin
  ModalResult := mrOk;
end;

end.
