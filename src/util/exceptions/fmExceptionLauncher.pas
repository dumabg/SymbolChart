unit fmExceptionLauncher;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

const
  WM_THREAD_EXCEPTION = WM_USER + 1;
  WM_SHOW_EXCEPTION = WM_USER + 2;

type
  TfExceptionLauncher = class(TForm)
  private
    FExMsg: string;
    procedure OnThreadException(var Msg: TMessage); message WM_THREAD_EXCEPTION;
    procedure OnShowException(var Msg: TMessage); message WM_SHOW_EXCEPTION;
  public
    property ExMsg: string read FExMsg write FExMsg;
  end;

  var
  fExceptionLauncher: TfExceptionLauncher;

implementation

uses ExceptionsState;

{$R *.dfm}

type
  EThread = class(Exception);

{ TfExceptionLauncher }

procedure TfExceptionLauncher.OnShowException(var Msg: TMessage);
begin
  Visible := true;
end;

procedure TfExceptionLauncher.OnThreadException(var Msg: TMessage);
begin
  if not IsShowingException then
    raise EThread.Create(FExMsg);
end;

initialization
//  fExceptionLauncher := TfExceptionLauncher.Create(nil);

end.
