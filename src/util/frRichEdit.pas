unit frRichEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, JvExStdCtrls, JvCombobox, JvColorCombo, TB2Item, Mask,
  JvExMask, JvSpin, ImgList, ComCtrls, SpTBXItem, TB2Dock, TB2Toolbar;

type
  TfRichEdit = class(TFrame)
    reTexto: TRichEdit;
    TBXToolbar1: TSpTBXToolbar;
    ToolbarImages: TImageList;
    TBControlItem1: TTBControlItem;
    FontSize: TJvSpinEdit;
    TBControlItem2: TTBControlItem;
    FontName: TJvFontComboBox;
  private
    function GetTexto: string;
    procedure SetTexto(const Value: string);
  public
    property Texto: string read GetTexto write SetTexto;
  end;

implementation

{$R *.dfm}

{ TfRichEdit }

function TfRichEdit.GetTexto: string;
begin
  result := reTexto.Lines.Text;
end;

procedure TfRichEdit.SetTexto(const Value: string);
begin
  reTexto.Lines.Text := Value;
end;

end.
