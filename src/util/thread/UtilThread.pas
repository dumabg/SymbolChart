unit UtilThread;

interface

uses Classes, Forms, Windows, SysUtils, Contnrs, JclDebug;

type
  TDataModuleClass = class of TDataModule;

  ETerminateThread = class(Exception)
  public
    constructor Create; reintroduce;
  end;

  TOnAfterThreadFree = procedure of object;

  TProtectedThread = class;
  PProtectedThread = ^TProtectedThread;
  TProtectedThread = class(TJclDebugThread)
  private
    Initialized: boolean;
    Destroying: boolean;
    FCanceled: Boolean;
    FExecuteTerminated: boolean;
    varPointer: PProtectedThread;
//    FOnAfterThreadFree: TOnAfterThreadFree;
    procedure SetName;
  protected
    function GetName: string; virtual;
    procedure InitializeResources; virtual;
    procedure FreeResources; virtual;
    procedure InternalExecute; virtual; abstract;
    procedure Execute; override;
    procedure InternalCancel; virtual;
    property IsDestroying: boolean read Destroying;
  public
    destructor Destroy; override;
    procedure Cancel;
    procedure SetNilOnFree(varPointer: PProtectedThread);
    property Canceled: Boolean read FCanceled;
    property ExecuteTerminated: boolean read FExecuteTerminated;
//    property OnAfterThreadFree: TOnAfterThreadFree read FOnAfterThreadFree write FOnAfterThreadFree;
  end;

  TAutoCreateDataModules = record
    Name: string;
    DataModuleClass: TDataModuleClass;
  end;

  TDataModules = record
    ThreadID: integer;
    DataModules: TObjectList;
  end;

  TDataModuleManager = class
  private
    CreatingDataModule: boolean;
    CreatingName: string;
    AutoCreateDataModules: array of TAutoCreateDataModules;
    DataModules: array of TDataModules;
    procedure AddDataModule(DataModule: TDataModule);
    procedure RemoveDataModule(DataModule: TDataModule);
    function GetIndexDataModules(const threadId: integer): integer; overload;
    function GetIndexDataModules: integer; overload;
    function GetAutoCreateClass(const Name: string): TDataModuleClass;
    function FindDataModule(const Name: string): TDataModule;
    constructor Create;
  public
    destructor Destroy; override;
    procedure RegisterAutoCreateDataModule(const name: string; const DataModuleClass: TDataModuleClass);
    procedure FreeDataModules(const threadId: integer);
    function GetDataModule(const Name: string): TDataModule;
  end;

var
  DataModuleManager: TDataModuleManager;

  procedure GlobalInitialization;
  procedure GlobalFinalization;

implementation

uses UtilObject, Messages, UtilException, dmThreadDataModule,
  GlobalSyncronization;

const
  WM_THREAD_EXCEPTION = WM_USER + 1;
  WM_THREAD_AFTER_FREE = WM_USER + 2;

type
  EThreadException = class(Exception);

  // Ver en la ayuda: Converting an Unnamed Thread to a Named Thread
  // ms-help://borland.bds5/devwin32/convertinganunnamedthreadtoanamedthread_xml.html
  TThreadNameInfo = record
    FType: LongWord;     // must be 0x1000
    FName: PChar;        // pointer to name (in user address space)
    FThreadID: LongWord; // thread ID (-1 indicates caller thread)
    FFlags: LongWord;    // reserved for future use, must be zero
  end;

  TThreadManager = class
  private
    criticalSection: TRTLCriticalSection;
    threads: TObjectList;
    procedure ThreadExecuted(const thread: TProtectedThread);
    procedure ThreadFinalized(const thread: TProtectedThread);
    procedure WaitForAll;
    constructor Create;
  public
    destructor Destroy; override;
  end;


{  TExceptionLauncher = class(THandledObject)
  private
    criticalSection: TRTLCriticalSection;
    exceptions: TStringList;
    procedure OnThreadException(var Msg: TMessage); message WM_THREAD_EXCEPTION;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ShowException(const e: Exception; const threadName: string);
  end;}

{  TAfterThreadFreeLauncher = class(THandledObject)
  private
    criticalSection: TRTLCriticalSection;
    Methods: array of TOnAfterThreadFree;
    procedure OnAfterThreadFree(var Msg: TMessage); message WM_THREAD_AFTER_FREE;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Launch(method: TOnAfterThreadFree);
  end;}


const
  mrWriteRequest = $FFFF; // 65535 concurrent read requests (threads)

type
  TMultiReadExclusiveWriteSynchronizerThread = class(TInterfacedObject, IReadWriteSync)
  private
    FSentinel: Integer;
    FReadSignal: THandle;
    FWriteSignal: THandle;
    FWaitRecycle: Cardinal;
    FWriteRecursionCount: Cardinal;
    tls: TThreadLocalCounter;
    FWriterID: Cardinal;
    FRevisionLevel: Cardinal;
    procedure BlockReaders;
    procedure UnblockReaders;
    procedure UnblockOneWriter;
    procedure WaitForReadSignal;
    procedure WaitForWriteSignal;
  public
    constructor Create;
    destructor Destroy; override;
    procedure BeginRead;
    procedure EndRead;
    function BeginWrite: Boolean;
    procedure EndWrite;
    procedure EndThread(const ThreadID: cardinal);
    property RevisionLevel: Cardinal read FRevisionLevel;
  end;


var
  GlobalNameSpaceThread: TMultiReadExclusiveWriteSynchronizerThread;
  oldGlobalNameSpace: IReadWriteSync;
  ThreadManager: TThreadManager;
//  ExceptionLauncher: TExceptionLauncher;
//  AfterThreadFreeLauncher: TAfterThreadFreeLauncher;


  function FindGlobalComponent(const Name: string): TComponent;
  begin
    result := DataModuleManager.GetDataModule(Name);
  end;


  function FindGlobalComponentAutoCreate(const Name: string): TComponent;
  begin
    result := DataModuleManager.FindDataModule(Name);
  end;

{ TProtectedThread }


destructor TProtectedThread.Destroy;
begin
  try
    FreeResources;
    DataModuleManager.FreeDataModules(ThreadID);
  except
    on e: Exception do begin
      GlobalNameSpaceThread.EndThread(ThreadID);
      GlobalSyncronization.EndThread(ThreadID);
      HandleException(e);
    end;
  end;
  if varPointer <> nil then
    varPointer^ := nil;
{  if Assigned(FOnAfterThreadFree) then
    AfterThreadFreeLauncher.Launch(FOnAfterThreadFree);}
  ThreadManager.ThreadFinalized(Self);
  inherited;
end;

procedure TProtectedThread.Execute;
begin
  try
    ThreadManager.ThreadExecuted(Self);
    FCanceled := false;
    SetName;
    InitializeResources;
    Initialized := true;
    if not Terminated then
      InternalExecute;
  except
    on e: ETerminateThread do begin
    end;
    on e: EAbort do begin
      FCanceled := true;
    end;
    on e: Exception do begin
      GlobalNameSpaceThread.EndThread(ThreadID);
      GlobalSyncronization.EndThread(ThreadID);
      HandleException(e);
    end;
  end;
  Destroying := True;
  FExecuteTerminated := true;
end;

procedure TProtectedThread.FreeResources;
begin

end;

function TProtectedThread.GetName: string;
begin
  result := ClassName;
end;

procedure TProtectedThread.InitializeResources;
begin

end;

procedure TProtectedThread.InternalCancel;
begin

end;

procedure TProtectedThread.SetName;
var name: string;
  ThreadNameInfo: TThreadNameInfo;
begin
  name := GetName;
  if name <> '' then begin
    ThreadNameInfo.FType := $1000;
    ThreadNameInfo.FName := PAnsiChar(name);
    ThreadNameInfo.FThreadID := $FFFFFFFF;
    ThreadNameInfo.FFlags := 0;
    try
      RaiseException($406D1388, 0, sizeof(ThreadNameInfo) div sizeof(LongWord), @ThreadNameInfo);
    except
    end;
  end;
end;

procedure TProtectedThread.SetNilOnFree(varPointer: PProtectedThread);
begin
  Self.varPointer := varPointer;
end;

procedure TProtectedThread.Cancel;
begin
  FCanceled := true;
  if not Destroying then begin
    if not Suspended then
      Suspend;
    Terminate;
    if Initialized then
      InternalCancel;
    Resume;
  end;
end;

{ TExceptionLauncher }
{
procedure TExceptionLauncher.ShowException(const e: Exception;
  const threadName: string);
var msg: string;
begin
  msg := threadName + ': ' + sLineBreak + e.ClassName + sLineBreak +
      e.Message + sLineBreak + GetStackTraceString;
  EnterCriticalSection(criticalSection);
  try
    exceptions.Add(msg);
  finally
    LeaveCriticalSection(criticalSection);
  end;
  PostMessage(Handle, WM_THREAD_EXCEPTION, 0, 0);
end;

constructor TExceptionLauncher.Create;
begin
  inherited;
  InitializeCriticalSection(criticalSection);
  exceptions := TStringList.Create;
end;

destructor TExceptionLauncher.Destroy;
begin
  DeleteCriticalSection(criticalSection);
  exceptions.Free;
  inherited;
end;

procedure TExceptionLauncher.OnThreadException(var Msg: TMessage);
var msgE: string;
begin
  EnterCriticalSection(criticalSection);
  try
    msgE:= exceptions[0];
    exceptions.Delete(0);
  finally
    LeaveCriticalSection(criticalSection);
  end;
  raise EThreadException.Create(msgE);
end;
}

{ ETerminateThread }

constructor ETerminateThread.Create;
begin
  inherited Create('');
end;


{ TDataModuleManager }

procedure TDataModuleManager.AddDataModule(DataModule: TDataModule);
var i: integer;
begin
  GlobalEnterCriticalSection;
  try
    i := GetIndexDataModules;
    if i = -1 then begin
      i := length(DataModules);
      SetLength(DataModules, i + 1);
      DataModules[i].ThreadID := GetCurrentThreadId;
      DataModules[i].DataModules := TObjectList.Create(false);
    end;
    DataModules[i].DataModules.Add(DataModule);
  finally
    GlobalLeaveCriticalSection;
  end;
end;

constructor TDataModuleManager.Create;
begin
  Classes.AddDataModule := AddDataModule;
  Classes.RemoveDataModule := RemoveDataModule;
end;

destructor TDataModuleManager.Destroy;
var i, j, num: integer;
  dm: TObjectList;
begin
  Classes.AddDataModule := nil;
  Classes.RemoveDataModule := nil;
  num := Length(DataModules) - 1;
  for i := 0 to num do begin
    // Liberamos todos los datamodules que no se haya hecho Free.
    // Deberían quedar solo los AutoCreate del main.
    dm := DataModules[i].DataModules;
    for j := dm.Count - 1 downto 0 do
      dm[j].Free;
    dm.Free;
  end;
  inherited;
end;

function TDataModuleManager.FindDataModule(const Name: string): TDataModule;
var i, num: integer;
  dm: TObjectList;

    function AutoCreate: TDataModule;
    var dataModuleClass: TDataModuleClass;
    begin
      dataModuleClass := GetAutoCreateClass(Name);
      if dataModuleClass <> nil then begin
        CreatingDataModule := true;
        CreatingName := Name;
        Classes.UnRegisterFindGlobalComponentProc(FindGlobalComponent);
        Classes.RegisterFindGlobalComponentProc(FindGlobalComponentAutoCreate);
        try
          try
            result := dataModuleClass.Create(nil);
          finally
            CreatingDataModule := false;
          end;
        finally
          Classes.UnRegisterFindGlobalComponentProc(FindGlobalComponentAutoCreate);
          Classes.RegisterFindGlobalComponentProc(FindGlobalComponent);
        end;
      end
      else
        result := nil;
    end;
begin
  if CreatingDataModule and (CreatingName = Name) then
    result := nil
  else begin
    i := GetIndexDataModules;
    if i <> -1 then begin
      dm := DataModules[i].DataModules;
      num := dm.Count - 1;
      for i := 0 to num do begin
        result := TDataModule(dm[i]);
        if CompareText(Result.Name, Name) = 0 then
          exit;
      end;
    end;
    result := AutoCreate;
  end;
end;

procedure TDataModuleManager.FreeDataModules(const threadId: integer);
var i, j, lon: integer;
  dm: TObjectList;
begin
  i := GetIndexDataModules(threadId);
  if i <> -1 then begin
    dm := DataModules[i].DataModules;
    lon := dm.Count - 1;
    for j := lon downto 0 do
      dm[j].Free;
    dm.Free;
    lon := length(DataModules) - 1;
    if i < lon then
      System.Move(DataModules[i + 1], DataModules[i], (lon - i) * SizeOf(TDataModules));
    SetLength(DataModules, lon); // ya restado -1 antes
  end;
end;

function TDataModuleManager.GetDataModule(const Name: string): TDataModule;
begin
  GlobalEnterCriticalSection;
  try
    result := FindDataModule(Name);
  finally
    GlobalLeaveCriticalSection;
  end;
end;

function TDataModuleManager.GetIndexDataModules(
  const threadId: integer): integer;
var i, num: integer;
begin
  num := Length(DataModules) - 1;
  for i := 0 to num do begin
    if DataModules[i].ThreadID = threadID then begin
      result := i;
      Exit;
    end;
  end;
  result := -1;
end;

function TDataModuleManager.GetIndexDataModules: integer;
begin
  result := GetIndexDataModules(GetCurrentThreadId);
end;

function TDataModuleManager.GetAutoCreateClass(const Name: string): TDataModuleClass;
var i, num: Integer;
begin
  num := Length(AutoCreateDataModules) - 1;
  for i := 0 to num do begin
    if CompareText(AutoCreateDataModules[i].Name, Name) = 0 then begin
      result := AutoCreateDataModules[i].DataModuleClass;
      exit;
    end;
  end;
  result := nil;
end;

procedure TDataModuleManager.RegisterAutoCreateDataModule(const name: string;
  const DataModuleClass: TDataModuleClass);
var num: integer;
begin
  num := Length(AutoCreateDataModules);
  SetLength(AutoCreateDataModules, num + 1);
  AutoCreateDataModules[num].Name := name;
  AutoCreateDataModules[num].DataModuleClass := DataModuleClass;
end;

procedure TDataModuleManager.RemoveDataModule(DataModule: TDataModule);
var i: integer;
begin
  GlobalEnterCriticalSection;
  try
    i := GetIndexDataModules;
    if i <> -1 then
      DataModules[i].DataModules.Remove(DataModule);
  finally
    GlobalLeaveCriticalSection;
  end;
end;

{ TAfterThreadFreeLauncher }
{
constructor TAfterThreadFreeLauncher.Create;
begin
  inherited;
  InitializeCriticalSection(criticalSection);
end;

destructor TAfterThreadFreeLauncher.Destroy;
begin
  DeleteCriticalSection(criticalSection);
  inherited;
end;

procedure TAfterThreadFreeLauncher.Launch(method: TOnAfterThreadFree);
begin
  EnterCriticalSection(criticalSection);
  try
    SetLength(Methods, length(Methods) + 1);
    Methods[Length(Methods) - 1] := method;
    PostMessage(Handle, WM_THREAD_AFTER_FREE, 0, 0);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

procedure TAfterThreadFreeLauncher.OnAfterThreadFree(var Msg: TMessage);
var i: integer;
begin
  EnterCriticalSection(criticalSection);
  try
    for i := Length(Methods) - 1 downto 0 do
      Methods[i];
    SetLength(Methods, 0);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;
}
{ TMultiReadExclusiveWriteSynchronizerThread }

procedure TMultiReadExclusiveWriteSynchronizerThread.BeginRead;
var
  Thread: PThreadInfo;
  WasRecursive: Boolean;
  SentValue: Integer;
begin
  GlobalEnterCriticalSection;
  exit;

{$IFDEF DEBUG_MREWS}
  Debug('Read enter');
{$ENDIF}

  tls.Open(Thread);
  Inc(Thread.RecursionCount);
  WasRecursive := Thread.RecursionCount > 1;

  if FWriterID <> GetCurrentThreadID then
  begin
{$IFDEF DEBUG_MREWS}
    Debug('Trying to get the ReadLock (we did not have a write lock)');
{$ENDIF}
    // In order to prevent recursive Reads from causing deadlock,
    // we need to always WaitForReadSignal if not recursive.
    // This prevents unnecessarily decrementing the FSentinel, and
    // then immediately incrementing it again.
    if not WasRecursive then
    begin
      // Make sure we don't starve writers. A writer will
      // always set the read signal when it is done, and it is initially on.
      WaitForReadSignal;
      while (InterlockedDecrement(FSentinel) <= 0) do
      begin
  {$IFDEF DEBUG_MREWS}
        Debug('Read loop');
  {$ENDIF}
        // Because the InterlockedDecrement happened, it is possible that
        // other threads "think" we have the read lock,
        // even though we really don't. If we are the last reader to do this,
        // then SentValue will become mrWriteRequest
        SentValue := InterlockedIncrement(FSentinel);
        // So, if we did inc it to mrWriteRequest at this point,
        // we need to signal the writer.
        if SentValue = mrWriteRequest then
          UnblockOneWriter;

        // This sleep below prevents starvation of writers
        Sleep(0);

  {$IFDEF DEBUG_MREWS}
        Debug('Read loop2 - waiting to be signaled');
  {$ENDIF}
        WaitForReadSignal;
  {$IFDEF DEBUG_MREWS}
        Debug('Read signaled');
  {$ENDIF}
      end;
    end;
  end;
{$IFDEF DEBUG_MREWS}
  Debug('Read lock');
{$ENDIF}
end;

function TMultiReadExclusiveWriteSynchronizerThread.BeginWrite: Boolean;
var
  Thread: PThreadInfo;
  HasReadLock: Boolean;
  ThreadID: Cardinal;
  Test: Integer;
  OldRevisionLevel: Cardinal;
begin
  result := true;
  GlobalEnterCriticalSection;
  exit;
  {
    States of FSentinel (roughly - during inc/dec's, the states may not be exactly what is said here):
    mrWriteRequest:         A reader or a writer can get the lock
    1 - (mrWriteRequest-1): A reader (possibly more than one) has the lock
    0:                      A writer (possibly) just got the lock, if returned from the main write While loop
    < 0, but not a multiple of mrWriteRequest: Writer(s) want the lock, but reader(s) have it.
          New readers should be blocked, but current readers should be able to call BeginRead
    < 0, but a multiple of mrWriteRequest: Writer(s) waiting for a writer to finish
  }


{$IFDEF DEBUG_MREWS}
  Debug('Write enter------------------------------------');
{$ENDIF}
  Result := True;
  ThreadID := GetCurrentThreadID;
  if FWriterID <> ThreadID then  // somebody or nobody has a write lock
  begin
    // Prevent new readers from entering while we wait for the existing readers
    // to exit.
    BlockReaders;

    OldRevisionLevel := FRevisionLevel;

    tls.Open(Thread);
    // We have another lock already. It must be a read lock, because if it
    // were a write lock, FWriterID would be our threadid.
    HasReadLock := Thread.RecursionCount > 0;

    if HasReadLock then    // acquiring a write lock requires releasing read locks
      InterlockedIncrement(FSentinel);

{$IFDEF DEBUG_MREWS}
    Debug('Write before loop');
{$ENDIF}
    // InterlockedExchangeAdd returns prev value
    while InterlockedExchangeAdd(FSentinel, -mrWriteRequest) <> mrWriteRequest do
    begin
{$IFDEF DEBUG_MREWS}
      Debug('Write loop');
      Sleep(1000); // sleep to force / debug race condition
      Debug('Write loop2a');
{$ENDIF}

      // Undo what we did, since we didn't get the lock
      Test := InterlockedExchangeAdd(FSentinel, mrWriteRequest);
      // If the old value (in Test) was 0, then we may be able to
      // get the lock (because it will now be mrWriteRequest). So,
      // we continue the loop to find out. Otherwise, we go to sleep,
      // waiting for a reader or writer to signal us.

      if Test <> 0 then
      begin
        {$IFDEF DEBUG_MREWS}
        Debug('Write starting to wait');
        {$ENDIF}
        WaitForWriteSignal;
      end
      {$IFDEF DEBUG_MREWS}
      else
        Debug('Write continue')
      {$ENDIF}
    end;

    // At the EndWrite, first Writers are awoken, and then Readers are awoken.
    // If a Writer got the lock, we don't want the readers to do busy
    // waiting. This Block resets the event in case the situation happened.
    BlockReaders;

    // Put our read lock marker back before we lose track of it
    if HasReadLock then
      InterlockedDecrement(FSentinel);

    FWriterID := ThreadID;

    Result := Integer(OldRevisionLevel) = (InterlockedIncrement(Integer(FRevisionLevel)) - 1);
  end;

  Inc(FWriteRecursionCount);
{$IFDEF DEBUG_MREWS}
  Debug('Write lock-----------------------------------');
{$ENDIF}
end;

procedure TMultiReadExclusiveWriteSynchronizerThread.BlockReaders;
begin
  ResetEvent(FReadSignal);
end;

constructor TMultiReadExclusiveWriteSynchronizerThread.Create;
begin
  inherited Create;
{  FSentinel := mrWriteRequest;
  FReadSignal := CreateEvent(nil, True, True, nil);  // manual reset, start signaled
  FWriteSignal := CreateEvent(nil, False, False, nil); // auto reset, start blocked
  FWaitRecycle := INFINITE;
  tls := TThreadLocalCounter.Create;}
end;

destructor TMultiReadExclusiveWriteSynchronizerThread.Destroy;
begin
//  BeginWrite;
  inherited Destroy;
{  CloseHandle(FReadSignal);
  CloseHandle(FWriteSignal);
  tls.Free;}
end;

procedure TMultiReadExclusiveWriteSynchronizerThread.EndRead;
var
  Thread: PThreadInfo;
  Test: Integer;
begin
  GlobalLeaveCriticalSection;
  exit;

{$IFDEF DEBUG_MREWS}
  Debug('Read end');
{$ENDIF}
  tls.Open(Thread);
  Dec(Thread.RecursionCount);
  if (Thread.RecursionCount = 0) then
  begin
     tls.Delete(Thread);

    // original code below commented out
    if (FWriterID <> GetCurrentThreadID) then
    begin
      Test := InterlockedIncrement(FSentinel);
      // It is possible for Test to be mrWriteRequest
      // or, it can be = 0, if the write loops:
      // Test := InterlockedExchangeAdd(FSentinel, mrWriteRequest) + mrWriteRequest;
      // Did not get executed before this has called (the sleep debug makes it happen faster)
      {$IFDEF DEBUG_MREWS}
      Debug(Format('Read UnblockOneWriter may be called. Test=%d', [Test]));
      {$ENDIF}
      if Test = mrWriteRequest then
        UnblockOneWriter
      else if Test <= 0 then // We may have some writers waiting
      begin
        if (Test mod mrWriteRequest) = 0 then
          UnblockOneWriter; // No more readers left (only writers) so signal one of them
      end;
    end;
  end;
{$IFDEF DEBUG_MREWS}
  Debug('Read unlock');
{$ENDIF}
end;

procedure TMultiReadExclusiveWriteSynchronizerThread.EndThread(
  const ThreadID: cardinal);
begin
  if FWriterID = ThreadID then
    EndWrite;
end;

procedure TMultiReadExclusiveWriteSynchronizerThread.EndWrite;
var
  Thread: PThreadInfo;
begin
  GlobalLeaveCriticalSection;
  exit;
{$IFDEF DEBUG_MREWS}
  Debug('Write end');
{$ENDIF}
  assert(FWriterID = GetCurrentThreadID);
  tls.Open(Thread);
  Dec(FWriteRecursionCount);
  if FWriteRecursionCount = 0 then
  begin
    FWriterID := 0;
    InterlockedExchangeAdd(FSentinel, mrWriteRequest);
    {$IFDEF DEBUG_MREWS}
    Debug('Write about to UnblockOneWriter');
    {$ENDIF}
    UnblockOneWriter;
    {$IFDEF DEBUG_MREWS}
    Debug('Write about to UnblockReaders');
    {$ENDIF}
    UnblockReaders;
  end;
  if Thread.RecursionCount = 0 then
    tls.Delete(Thread);
{$IFDEF DEBUG_MREWS}
  Debug('Write unlock');
{$ENDIF}
end;

procedure TMultiReadExclusiveWriteSynchronizerThread.UnblockOneWriter;
begin
  SetEvent(FWriteSignal);
end;

procedure TMultiReadExclusiveWriteSynchronizerThread.UnblockReaders;
begin
  SetEvent(FReadSignal);
end;

procedure TMultiReadExclusiveWriteSynchronizerThread.WaitForReadSignal;
begin
  WaitForSingleObject(FReadSignal, FWaitRecycle);
end;

procedure TMultiReadExclusiveWriteSynchronizerThread.WaitForWriteSignal;
begin
  WaitForSingleObject(FWriteSignal, FWaitRecycle);
end;

{ TThreadManager }

constructor TThreadManager.Create;
begin
  InitializeCriticalSection(criticalSection);
  threads := TObjectList.Create(false);
end;

destructor TThreadManager.Destroy;
begin
  DeleteCriticalSection(criticalSection);
  threads.Free;
end;

procedure TThreadManager.ThreadExecuted(const thread: TProtectedThread);
begin
  EnterCriticalSection(criticalSection);
  try
    threads.Add(thread);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

procedure TThreadManager.ThreadFinalized(const thread: TProtectedThread);
var i: integer;
begin
  EnterCriticalSection(criticalSection);
  try
    i := threads.IndexOf(thread);
    if i <> -1 then
      threads.Delete(i);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

procedure TThreadManager.WaitForAll;
begin
  while threads.Count > 0 do
    Application.ProcessMessages;
end;

procedure GlobalInitialization;
begin
//  AfterThreadFreeLauncher := TAfterThreadFreeLauncher.Create;
  DataModuleManager := TDataModuleManager.Create;
  ThreadManager := TThreadManager.Create;
  Classes.RegisterFindGlobalComponentProc(FindGlobalComponent);
  GlobalNameSpaceThread := TMultiReadExclusiveWriteSynchronizerThread.Create;
  oldGlobalNameSpace := GlobalNameSpace;
  GlobalNameSpace := GlobalNameSpaceThread;
end;

procedure GlobalFinalization;
begin
  ThreadManager.WaitForAll;
  ThreadManager.Free;
  DataModuleManager.Free;
  Classes.UnRegisterFindGlobalComponentProc(FindGlobalComponent);
  GlobalNameSpace := oldGlobalNameSpace;
//  AfterThreadFreeLauncher.Free;
end;

end.
