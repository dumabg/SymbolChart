unit dmHandledDataModule;

interface

uses
  SysUtils, Classes, Windows, Messages;

type
  THandledDataModule = class(TDataModule)
  private
    FHandle: HWND;
  protected
    procedure WndMethod(var Msg: TMessage); virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Handle: HWND read FHandle;
  end;


implementation

{$R *.dfm}

{ THandledDataModule }

constructor THandledDataModule.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHandle := AllocateHWnd(WndMethod);
end;

destructor THandledDataModule.Destroy;
begin
  DeallocateHWnd(FHandle);
  inherited;
end;

end.
