unit fmBaseEditar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, DB;

type
  TfBaseEditar = class(TfBase)
    procedure OnCurrencyKeyPress(Sender: TObject; var Key: Char);
  private
  protected
    function CheckTDBEdit: boolean; virtual;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DBCtrls;

{ TfBaseEditar }

function TfBaseEditar.CheckTDBEdit: boolean;
var i, num: integer;
  component: TComponent;
  dbEdit: TDBEdit;
  field: TField;
begin
  result := true;
  num := ComponentCount - 1;
  for i := 0 to num do begin
    component := Components[i];
    if component is TDBEdit then begin
      dbEdit := TDBEdit(component);
      field := dbEdit.Field;
      if (field.Required) and (field.Visible) and (Trim(dbEdit.EditText)='') then begin
        dbEdit.SetFocus;      
        ShowMessage('El campo ''' + field.DisplayName + ''' no puede dejarse en blanco, debe rellenarse.');
        result := false;
        exit;
      end;
    end;
  end;
end;

procedure TfBaseEditar.OnCurrencyKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ['0'..'9',','] then begin
    if (Key = ',') and (Pos(',', (Sender as TDBEdit).EditText) <> 0) then
      Key := #0;
  end
  else
    Key := #0;
end;

end.
