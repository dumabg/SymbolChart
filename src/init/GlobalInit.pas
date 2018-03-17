unit GlobalInit;

interface

  procedure GlobalInitialization;
  procedure GlobalFinalization;

implementation

uses dmBD, UtilThread, dmMensajeria, BusCommunication, dmTipOfDay,
  uServices, uTickService, dmDataComunSesion, GlobalSyncronization,
  dmEstrategiaInterpreter, uExceptionsManager, Windows;

  function AlreadyRunning(const AIdentifier: string): Boolean;
  begin
    CreateMutex(nil, False, PChar(AIdentifier));
    result := GetLastError = ERROR_ALREADY_EXISTS;
  end;

  procedure GlobalInitialization;
  var PrevInstance: THandle;
  begin
    if AlreadyRunning('SymbolChartApp') then begin
      PrevInstance := FindWindow('TfSCMain', nil);
      if PrevInstance <> 0 then
        SetForegroundWindow(PrevInstance);
      Halt(1);
    end
    else begin
      uExceptionsManager.GlobalInitialization;
      GlobalSyncronization.GlobalInitialization;
      BusCommunication.GlobalInitialization;
      UtilThread.GlobalInitialization;
      dmBD.GlobalInitialization;
      dmDataComunSesion.GlobalInitialization;
      uServices.GlobalInitialization;
      uTickService.GlobalInitialization;
      dmMensajeria.GlobalInitialization;
      dmTipOfDay.GlobalInitialization;
      dmEstrategiaInterpreter.GlobalInitialization;
    end;
  end;

  procedure GlobalFinalization;
  begin
    uServices.GlobalFinalization;
    dmMensajeria.GlobalFinalization;
    dmDataComunSesion.GlobalFinalization;
    UtilThread.GlobalFinalization;
    BusCommunication.GlobalFinalization;
    GlobalSyncronization.GlobalFinalization;
    uExceptionsManager.GlobalFinalization;
  end;


end.
