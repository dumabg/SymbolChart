unit KeyHook;

interface

uses
  Windows, Messages, Classes, Forms;

type
  TKeyHookEvent = procedure(Sender: TObject; var Key: Word; Shift: TShiftState;
    KeyName: string; RepeatedKeypress: Boolean) of object;

  TKeyHook = class(TComponent)
  private
    FOnKeyDown, FOnKeyUp: TKeyHookEvent;
  protected
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OnKeyDown: TKeyHookEvent read FOnKeyDown write FOnKeyDown;
    property OnKeyUp: TKeyHookEvent read FOnKeyUp write FOnKeyUp;
  end;

implementation

var
  KeyHookInstance: TKeyHook = nil;
  KeyboardHook: hHook = 0;

function GetKeyName(lParam: LongInt): string;
var
  szKeyName: array[0..$FF] of Char;
begin
  GetKeyNameText(lParam, szKeyName, SizeOf(szKeyName));
  Result := szKeyName;
end;

function KeyboardCallbackProc(nCode: Integer; wParam, lParam: LongInt): LongInt;
  stdcall;
var
  Msg: TMessage;
begin
  Result := 0;

  if nCode = HC_ACTION then
  try
    with KeyHookInstance do
    begin
      Msg.wParam := wParam;
      Msg.lParam := lParam;

      if not Boolean(lParam shr 31) then // key down
        if Assigned(FOnKeyDown) then
        begin
          Msg.Msg := WM_KEYDOWN;
          FOnKeyDown(KeyHookInstance, TWMKey(Msg).CharCode,
            KeyDataToShiftState(TWMKey(Msg).KeyData), GetKeyName(lParam),
            Boolean(lParam shr 30));
        end
        else
      else {// key up} if Assigned(FOnKeyUp) then
      begin
        Msg.Msg := WM_KEYUP;
        FOnKeyUp(KeyHookInstance, TWMKey(Msg).CharCode,
          KeyDataToShiftState(TWMKey(Msg).KeyData), GetKeyName(lParam),
          Boolean(lParam shr 30));
      end;
    end;
  except
  end;

  if (nCode < 0) or (Result = 0) then
    Result := CallNextHookEx(KeyboardHook, nCode, wParam, lParam);
end;

constructor TKeyHook.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  if not (csDesigning in ComponentState) and (KeyHookInstance = nil) then
  begin
    KeyHookInstance := Self;
    KeyboardHook := SetWindowsHookEx(WH_KEYBOARD, @KeyboardCallbackProc, 0,
      GetCurrentThreadID);
  end;
end;

destructor TKeyHook.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    if KeyboardHook <> 0 then
      UnhookWindowsHookEx(KeyboardHook);
    KeyboardHook := 0;
  end;

  inherited Destroy;
end;

end.

