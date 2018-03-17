unit fmColumna;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBaseNuevo, StdCtrls, Buttons, ExtCtrls, BDConstants;

type
  TfColumna = class(TfBaseNuevo)
    cbTipo: TComboBox;
    lTipo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cbTipoChange(Sender: TObject);
  private
    function GetTipo: TResultType;
    procedure SetTipo(const Value: TResultType);
  protected
    function CheckEnableCrearButton: boolean; override;
  public
    property Tipo: TResultType read GetTipo write SetTipo;
  end;


implementation

{$R *.dfm}

procedure TfColumna.cbTipoChange(Sender: TObject);
begin
  bCrear.Enabled := CheckEnableCrearButton;
end;

function TfColumna.CheckEnableCrearButton: boolean;
begin
  result := (inherited CheckEnableCrearButton) and (cbTipo.ItemIndex <> -1);
end;

procedure TfColumna.FormCreate(Sender: TObject);
var i: TResultType;
begin
  inherited;
  Max := 25;
  for i := Low(TResultType) to High(TResultType) do
    cbTipo.Items.Add(GetResultTypeString(i));
end;

function TfColumna.GetTipo: TResultType;
begin
  result := TResultType(cbTipo.ItemIndex);
end;

procedure TfColumna.SetTipo(const Value: TResultType);
begin
  cbTipo.ItemIndex := Integer(Value);
end;

end.
