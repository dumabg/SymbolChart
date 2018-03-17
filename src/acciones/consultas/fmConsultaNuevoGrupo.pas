unit fmConsultaNuevoGrupo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBaseNuevo, StdCtrls, Buttons, ExtCtrls, dmConsultaGrupo;

type
  TfConsultaNuevoGrupo = class(TfBaseNuevo)
    procedure FormCreate(Sender: TObject);
    procedure bCrearClick(Sender: TObject);
  private
    FConsultaGrupo: TConsultaGrupo;
  public
    property ConsultaGrupo: TConsultaGrupo read FConsultaGrupo write FConsultaGrupo;
  end;


implementation

uses UtilForms;

{$R *.dfm}

resourcestring
  YA_EXISTE_GRUPO = 'Ya existe un grupo con este nombre.' + sLineBreak +
    '¿Desea sobreescribirlo?';

procedure TfConsultaNuevoGrupo.bCrearClick(Sender: TObject);
begin
  inherited;
  if ConsultaGrupo.ExisteGrupo(Nombre) then begin
    if ShowMensaje('', YA_EXISTE_GRUPO, mtConfirmation, mbYesNo) = mrYes then
      ModalResult := mrOk;
  end
  else
    ModalResult := mrOk;
end;

procedure TfConsultaNuevoGrupo.FormCreate(Sender: TObject);
begin
  inherited;
  Max := 30;
end;

end.
