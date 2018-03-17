unit BusCommunication;

interface

uses Windows, UtilObject, Messages, Classes;

type
  TBusMessage = class
  end;

  TBusMessageClass = class of TBusMessage;

  TBusMessageEvent = procedure of object;

  TBus = class
  private
    type
      TBusMessageEvents = array of TBusMessageEvent;
      TRegisteredBusMessage = record
        BusMessageClass: TBusMessageClass;
        RegisteredEvents: TBusMessageEvents;
      end;
    var
    RegisteredBusMessages: array of TRegisteredBusMessage;
    // Si se están enviando eventos, podría ser que el evento enviado llamara a
    // UnregisterEvent. Si esto pasa, no puede quitarse el evento del array, ya
    // que al estar enviando eventos (en SendEvent), el bucle que itera por ellos
    // daría error al cambiar la longitud. Además podría pasar que no sólo se
    // desregistrase el evento actual, sino eventos posteriores. Para evitar esto
    // se marca como nil. En SendEvent una vez a lanzado todos los eventos y si
    // se ha activado el flag unregisteredEvents, entonces itera nuevamente por
    // los eventos y todos los que están a nil los desregistra.
    sendingEvents: boolean;
    iMUnregistered: TList;
    unregisteredEvents: boolean;
    function GetBusMessageClassIndex(const busMessageClass: TBusMessageClass): integer;
    procedure UnregisterEvents;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure RegisterEvent(const busMessageClass: TBusMessageClass;
      const event: TBusMessageEvent);
    procedure UnregisterEvent(const busMessageClass: TBusMessageClass;
      const event: TBusMessageEvent);
    procedure SendEvent(const busMessageClass: TBusMessageClass);
  end;

  var Bus: TBus;

  procedure GlobalInitialization;
  procedure GlobalFinalization;


//{$DEFINE OUTPUT_DEBUG_STRING}

implementation

uses GlobalSyncronization, SysUtils;

{ TBus }

constructor TBus.Create;
begin
  inherited;
  iMUnregistered := TList.Create;
end;

destructor TBus.Destroy;
begin
  iMUnregistered.Free;
  inherited;
end;

function TBus.GetBusMessageClassIndex(
  const busMessageClass: TBusMessageClass): integer;
var i, num: integer;
begin
  num := length(RegisteredBusMessages) - 1;
  for i := 0 to num do begin
    if RegisteredBusMessages[i].BusMessageClass = busMessageClass then begin
      result := i;
      exit;
    end;
  end;
  result := -1;
end;

procedure TBus.RegisterEvent(const busMessageClass: TBusMessageClass;
      const event: TBusMessageEvent);
var i, num, lon: integer;
begin
  GlobalEnterCriticalSection;
  {$IFDEF OUTPUT_DEBUG_STRING}
  OutputDebugString(PAnsiChar('Register IN ' + busMessageClass.ClassName + ' ' + IntToStr(GetCurrentThreadId)));
  {$ENDIF}
  try
    i := GetBusMessageClassIndex(busMessageClass);
    if i = -1 then begin // Not found
      num := length(RegisteredBusMessages);
      SetLength(RegisteredBusMessages, num + 1);
      RegisteredBusMessages[num].BusMessageClass := busMessageClass;
      i := num;
    end;
    lon := length(RegisteredBusMessages[i].RegisteredEvents) + 1;
    SetLength(RegisteredBusMessages[i].RegisteredEvents, lon);
    RegisteredBusMessages[i].RegisteredEvents[lon - 1] := event; //zero based
  finally
    GlobalLeaveCriticalSection;
  end;
  {$IFDEF OUTPUT_DEBUG_STRING}
  OutputDebugString(PAnsiChar('Register OUT ' + busMessageClass.ClassName + ' ' + IntToStr(GetCurrentThreadId)));
  {$ENDIF}
end;

procedure TBus.SendEvent(const busMessageClass: TBusMessageClass);
var i, iM: integer;
begin
  GlobalEnterCriticalSection;
  {$IFDEF OUTPUT_DEBUG_STRING}
  OutputDebugString(PAnsiChar('SendEvent IN ' + busMessageClass.ClassName + ' ' + IntToStr(GetCurrentThreadId)));
  {$ENDIF}
  try
    iM := GetBusMessageClassIndex(busMessageClass);
    if iM <> -1 then begin
      // Ver comentario en la declaración de la variable
      unregisteredEvents := false;
      sendingEvents := true;
      try
        for i := 0 to length(RegisteredBusMessages[iM].RegisteredEvents) - 1 do
          if Assigned(RegisteredBusMessages[iM].RegisteredEvents[i]) then begin
            RegisteredBusMessages[iM].RegisteredEvents[i];
          end;
      finally
        sendingEvents := false;
      end;
      if unregisteredEvents then
        UnregisterEvents;
    end;
  finally
    GlobalLeaveCriticalSection;
  end;
  {$IFDEF OUTPUT_DEBUG_STRING}
  OutputDebugString(PAnsiChar('SendEvent OUT ' + busMessageClass.ClassName + ' ' + IntToStr(GetCurrentThreadId)));
  {$ENDIF}
end;

procedure TBus.UnregisterEvent(const busMessageClass: TBusMessageClass;
  const event: TBusMessageEvent);
var i, iM, lon: integer;
begin
  GlobalEnterCriticalSection;
  {$IFDEF OUTPUT_DEBUG_STRING}
  OutputDebugString(PAnsiChar('Unregister IN ' + busMessageClass.ClassName + ' ' + IntToStr(GetCurrentThreadId)));
  {$ENDIF}
  try
    iM := GetBusMessageClassIndex(busMessageClass);
    assert(iM <> -1);
    lon := length(RegisteredBusMessages[iM].RegisteredEvents) - 1; //zero based
    assert(lon >= 0);
    // Ver comentario en la declaración de la variable
    unregisteredEvents := true;
    if iMUnregistered.IndexOf(Pointer(iM)) = -1 then
      iMUnregistered.Add(Pointer(iM));
    for i := 0 to lon do begin
      if (TMethod(RegisteredBusMessages[iM].RegisteredEvents[i]).Code = TMethod(event).Code) and
         (TMethod(RegisteredBusMessages[iM].RegisteredEvents[i]).Data = TMethod(event).Data) then begin
        RegisteredBusMessages[iM].RegisteredEvents[i] := nil;
        break;
      end;
    end;
    if not sendingEvents then
      UnregisterEvents;
  finally
    GlobalLeaveCriticalSection;
  end;
  {$IFDEF OUTPUT_DEBUG_STRING}
  OutputDebugString(PAnsiChar('Unregister OUT ' + busMessageClass.ClassName + ' ' + IntToStr(GetCurrentThreadId)));
  {$ENDIF}
end;

procedure TBus.UnregisterEvents;
var i, iiMU, iM, lon, num: integer;
begin
  GlobalEnterCriticalSection;
  try
    num := iMUnregistered.Count - 1;
    for iiMU := 0 to num do begin
      iM := Integer(iMUnregistered[iiMU]);
      lon := length(RegisteredBusMessages[iM].RegisteredEvents) - 1;
      i := lon;
      while i >= 0 do begin
        if not Assigned(RegisteredBusMessages[iM].RegisteredEvents[i]) then begin
          if lon = 0 then
            SetLength(RegisteredBusMessages[iM].RegisteredEvents, 0)
          else begin
            if i < lon then begin
              System.Move(RegisteredBusMessages[iM].RegisteredEvents[i + 1],
                  RegisteredBusMessages[iM].RegisteredEvents[i], (lon - i) * SizeOf(TBusMessageEvent));
            end;
            SetLength(RegisteredBusMessages[iM].RegisteredEvents, lon); // ya restado -1 antes
            dec(lon);
          end;
        end;
        dec(i);
      end;
    end;
    iMUnregistered.Clear;
  finally
    GlobalLeaveCriticalSection;
    unregisteredEvents := false;
  end;
end;

procedure GlobalInitialization;
begin
  Bus := TBus.Create;
end;

procedure GlobalFinalization;
begin
  Bus.Free;
end;

end.
