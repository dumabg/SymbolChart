unit fmBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AppEvnts;

type
  TfBase = class(TForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure InsideComponentEnabled(component: TComponent; const enabled: boolean);
    procedure InsideComponent(component: TComponent);
  protected
    procedure DoShow; override;
    procedure SetEnabled(Value: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Loaded; override;
  end;


implementation

{$R *.dfm}

uses ExtCtrls;

type
  TControlCracked = class(TControl)
  public
    property Font;
  end;


constructor TfBase.Create(AOwner: TComponent);
begin
  Screen.Cursor := crHourGlass;
  inherited Create(AOwner);
end;

procedure TfBase.DoShow;
begin
  inherited DoShow;
  Screen.Cursor := crDefault;
end;

procedure TfBase.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TfBase.InsideComponent(component: TComponent);
var i, num: integer;
begin
  if component is TCustomPanel then
    TCustomPanel(component).ParentBackground := false;

  num := component.ComponentCount - 1;
  for i:=0 to num do begin
    InsideComponent(component.Components[i]);
  end;
end;

procedure TfBase.InsideComponentEnabled(component: TComponent;
  const enabled: boolean);
var i, num: integer;
begin
  if component is TControl then begin
    TControl(component).Enabled := enabled;
    if enabled then
      TControlCracked(component).Font.Color := component.Tag
    else begin
      component.Tag := TControlCracked(component).Font.Color;
      TControlCracked(component).Font.Color := clGrayText;
    end;
  end;
  num := component.ComponentCount - 1;
  for i:=0 to num do begin
    InsideComponentEnabled(component.Components[i], enabled);
  end;
end;

procedure TfBase.Loaded;
var i: integer;
begin
  inherited Loaded;
  for i:=0 to ComponentCount - 1 do begin
    InsideComponent(Components[i]);
  end;
end;

procedure TfBase.SetEnabled(Value: Boolean);
var i: integer;
begin
  inherited;
  for i:=0 to ComponentCount - 1 do begin
    InsideComponentEnabled(Components[i], Value);
  end;
end;

end.
