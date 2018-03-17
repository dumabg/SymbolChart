unit frModulo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponentBase, JvErrorIndicator, ImgList;

type
  TfModulo = class(TFrame)
    JvErrorIndicator: TJvErrorIndicator;
    ImageListErrorIndicator: TImageList;
  private
    { Private declarations }
  public
    procedure Guardar; virtual;
    function Comprobar: boolean; virtual;
    procedure MostrarErrores; virtual;
    class function Titulo: string; virtual; abstract;
  end;

implementation

{$R *.dfm}

type
  TJvErrorIndicatorEx = class(TJvErrorIndicator)
  public
    property Controls;
    property Count;
  end;

{ TfModulo }

function TfModulo.Comprobar: boolean;
begin
  JvErrorIndicator.ClearErrors;
  JvErrorIndicator.BeginUpdate;
  result := true;
end;

procedure TfModulo.Guardar;
begin

end;

procedure TfModulo.MostrarErrores;
var i, num: integer;
begin
  num := TJvErrorIndicatorEx(JvErrorIndicator).Count;
  for i := 0 to num - 1 do
    TJvErrorIndicatorEx(JvErrorIndicator).Controls[i].ImagePadding := 3;
  JvErrorIndicator.EndUpdate;
  if num > 0 then
    Application.ActivateHint(
      TJvErrorIndicatorEx(JvErrorIndicator).Controls[0].Control.ClientOrigin);
end;

end.
