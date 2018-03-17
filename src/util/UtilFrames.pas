unit UtilFrames;

interface

uses Forms, ActnList, Classes, Controls;

type
  TFrameClass = class of TFrame;

  TActionFrame = class(TComponent)
  private
    Action: TAction;
    Frame: TFrame;
    FrameClass: TFrameClass;
    Parent: TWinControl;
    procedure OnExecute(Sender: TObject);
    procedure SetChecked(const Value: boolean);
    function GetChecked: boolean;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(const AOwner: TComponent; const Action: TAction;
      const FrameClass: TFrameClass; const Parent: TWinControl); reintroduce;
    destructor Destroy; override;
    property Checked: boolean read GetChecked write SetChecked;
  end;

implementation

uses SysUtils;

{ TActionFrame }

constructor TActionFrame.Create(const AOwner: TComponent; const Action: TAction;
  const FrameClass: TFrameClass; const Parent: TWinControl);
begin
  inherited Create(AOwner);
  Self.Action := Action;
  Self.FrameClass := FrameClass;
  Self.Parent := Parent;
  Action.OnExecute := OnExecute;
  if Action.Checked then
    OnExecute(nil);
end;

destructor TActionFrame.Destroy;
begin
  if Frame <> nil then
    Frame.Free;
  inherited;
end;

function TActionFrame.GetChecked: boolean;
begin
  Result := Action.Checked;
end;

procedure TActionFrame.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  //Solo puede lanzarse la notificación de Remove si el Frame tiene un Parent
  //y éste se lo carga
  if (AComponent = Frame) and (Operation = opRemove) then begin
    Frame := nil;
    Action.Checked := False;
  end;
end;

procedure TActionFrame.OnExecute(Sender: TObject);
begin
  if Frame = nil then begin
    Frame := FrameClass.Create(Self);
    if Parent <> nil then
      Frame.Parent := Parent;
    Frame.Show;
    Action.Checked := true;
  end
  else begin
    FreeAndNil(Frame);
    Action.Checked := False;
  end;
end;

procedure TActionFrame.SetChecked(const Value: boolean);
begin
  if Action.Checked <> Value then
    OnExecute(nil);
end;

end.
