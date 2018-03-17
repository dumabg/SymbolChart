unit GlobalSyncronization;

interface

  procedure GlobalEnterCriticalSection;
  procedure GlobalLeaveCriticalSection;
  procedure EndThread(const threadID: Cardinal);

  procedure GlobalInitialization;
  procedure GlobalFinalization;

implementation

uses Windows, SysUtils;

var
  criticalSection: TRTLCriticalSection;

//{$DEFINE OUTPUT_DEBUG_STRING}

procedure GlobalEnterCriticalSection;
begin
  EnterCriticalSection(criticalSection);
  {$IFDEF OUTPUT_DEBUG_STRING}
  OutputDebugString(PAnsiChar('GlobalEnterCriticalSection - ' + IntToStr(GetCurrentThreadId)));
  {$ENDIF}
end;

procedure GlobalLeaveCriticalSection;
begin
 LeaveCriticalSection(criticalSection);
  {$IFDEF OUTPUT_DEBUG_STRING}
  OutputDebugString(PAnsiChar('GlobalLeaveCriticalSection - ' + IntToStr(GetCurrentThreadId)));
  {$ENDIF}
end;

procedure EndThread(const threadID: Cardinal);
begin
  if criticalSection.OwningThread = threadID then
    LeaveCriticalSection(criticalSection);
end;

procedure GlobalInitialization;
begin
  InitializeCriticalSection(criticalSection);
end;

procedure GlobalFinalization;
begin
  DeleteCriticalSection(criticalSection);
end;

end.
