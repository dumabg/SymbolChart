unit uExceptionsManager;

interface

uses AppEvnts, SysUtils, Contnrs;

type
  ExceptionClass = class of Exception;

  TExceptionManager = class
  private
    Exceptions: TClassList;
    AppEvents: TApplicationEvents;
    constructor Create;
  public
    destructor Destroy; override;
    procedure RegisterKnowExceptionClass(exceptionClass: ExceptionClass);
    procedure OnException(Sender: TObject; E: Exception);
  end;

  procedure GlobalInitialization;
  procedure GlobalFinalization;

  var
    exceptionManager: TExceptionManager;


implementation

uses Forms, Windows, fmException, dmInternalServer, UtilWeb;

  { TExceptionManager }

constructor TExceptionManager.Create;
begin
  AppEvents := TApplicationEvents.Create(nil);
  AppEvents.OnException := OnException;
  Exceptions := TClassList.Create;
end;


destructor TExceptionManager.Destroy;
begin
  AppEvents.Free;
  Exceptions.Free;
  inherited;
end;

procedure TExceptionManager.OnException(Sender: TObject; E: Exception);

  function isRegistered: Boolean;
  var i: integer;
  begin
    for i := Exceptions.Count - 1 downto 0 do begin
      if E is Exceptions[i] then begin
        Result := true;
        exit;
      end;
    end;
    Result := false;
  end;
begin
  if isRegistered then begin
    Application.MessageBox(PChar(E.Message), 'Error', MB_OK + MB_ICONSTOP);
  end
  else begin
     TExceptionDialog.ExceptionHandler(Sender, E);
  end;
end;

procedure TExceptionManager.RegisterKnowExceptionClass(
  exceptionClass: ExceptionClass);
begin
  Exceptions.Add(exceptionClass);
end;

procedure GlobalInitialization;
begin
  exceptionManager := TExceptionManager.Create;
  exceptionManager.RegisterKnowExceptionClass(EAbort);
  exceptionManager.RegisterKnowExceptionClass(EConnectionStatus);
  exceptionManager.RegisterKnowExceptionClass(EConnection);
  exceptionManager.RegisterKnowExceptionClass(ETimeOut);
  fmException.GlobalInitialization;
end;

procedure GlobalFinalization;
begin
  fmException.GlobalFinalization;
  exceptionManager.Free;
end;

end.
