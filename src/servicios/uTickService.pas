unit uTickService;

interface

uses Classes, SyncObjs, BusCommunication, uServices;

const
  DEFAULT_FLASH_INTERVAL: integer = 1000;

type
  MessageTick = class(TBusMessage);
  MessageTick2 = class(TBusMessage);

  TTickService = class(TService)
  private
    tick2: boolean;
    FSleepEvent: TEvent;
    FInterval: integer;
    FEnabled: boolean;
    procedure SetEnabled(const Value: boolean);
  protected
    procedure InternalExecute; override;
    procedure InternalCancel; override;
    procedure InitializeResources; override;
    procedure FreeResources; override;
  public
    procedure AfterConstruction; override;
    property Interval: integer read FInterval write FInterval;
    property Enabled: boolean read FEnabled write SetEnabled;
  end;


  procedure GlobalInitialization;

implementation

{ TTickService }

procedure TTickService.InitializeResources;
begin
  inherited;
  //Creo un evento que nunca se lanzará. Así para simular el tick el theard
  // realizará un WaitFor al evento de FIntervalo milisegundos. Como el evento
  // nunca se lanza, al final el WaitFor caduca y es cuando se determina que hay
  // un tick, realizando nuevament un WaitFor
  FSleepEvent := TEvent.Create(nil, True, False, '');
  FEnabled := false;
  FInterval := DEFAULT_FLASH_INTERVAL;
end;

procedure TTickService.InternalCancel;
begin
  inherited;
  FSleepEvent.SetEvent;
end;

procedure TTickService.InternalExecute;
begin
  Enabled := true;
  while not Terminated do begin
    if FEnabled then begin
      if tick2 then
        Bus.SendEvent(MessageTick2)
      else
        Bus.SendEvent(MessageTick);
      tick2 := not tick2;
    end;
    FSleepEvent.WaitFor(FInterval);
  end;
end;

procedure TTickService.AfterConstruction;
begin
  inherited;
  Priority := tpLowest;
end;

procedure TTickService.FreeResources;
begin
  inherited;
  FSleepEvent.Free;
end;

procedure TTickService.SetEnabled(const Value: boolean);
begin
  if FEnabled <> Value then begin
    FEnabled := Value;
    if FEnabled then
      Resume
    else
      Suspend;
  end;
end;


procedure GlobalInitialization;
begin
  Services.RegisterService(TTickService);
end;

end.
