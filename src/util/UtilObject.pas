unit UtilObject;

interface

uses Windows, Messages;

type
  THandledObject = class
  private
    FHandle: HWND;
  protected
    procedure WndMethod(var Msg: TMessage); virtual;
  public
    constructor Create;
    destructor Destroy; override;
    property Handle: HWND read FHandle;
  end;

implementation

uses Classes;

{ THandledObject }

constructor THandledObject.Create;
begin
  inherited;
  FHandle := AllocateHWnd(WndMethod);
end;

destructor THandledObject.Destroy;
begin
  DeallocateHWnd(FHandle);
  inherited;
end;

procedure THandledObject.WndMethod(var Msg: TMessage);
begin
  Dispatch(Msg);
end;

end.
