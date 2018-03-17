unit fmAnadirRetirarCapital;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, StdCtrls, Buttons, JvExStdCtrls, JvEdit, JvValidateEdit,
  ExtCtrls;

type
  TfAnadirRetirarCapital = class(TfBase)
    eCapital: TJvValidateEdit;
    Label1: TLabel;
    Label2: TLabel;
    bOk: TBitBtn;
    bCancel: TBitBtn;
    Bevel2: TBevel;
    procedure eCapitalKeyPress(Sender: TObject; var Key: Char);
  private
    function GetCapital: currency;
    procedure SetAnadir(const Value: boolean);
  public
    property Capital: currency read GetCapital;
    property Anadir: boolean write SetAnadir;
  end;


implementation

{$R *.dfm}

procedure TfAnadirRetirarCapital.eCapitalKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  bOk.Enabled := eCapital.Value > 0;
end;

function TfAnadirRetirarCapital.GetCapital: currency;
begin
  result := eCapital.Value;
end;

procedure TfAnadirRetirarCapital.SetAnadir(const Value: boolean);
begin
  if Value then begin
    Caption := 'Añadir Capital';
    bOK.Caption := 'Añadir';
  end
  else begin
    Caption := 'Retirar Capital';
    bOK.Caption := 'Retirar';
  end;
end;

end.
