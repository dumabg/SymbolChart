unit uServices;

interface

uses UtilThread, Contnrs;

type
  TService = class(TProtectedThread)
  end;

  TServiceClass = class of TService;

  TServices = class
  private
    Services: TObjectList;
    ServicesClass: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RegisterService(const ServiceClass: TServiceClass);
    procedure StartAll;
    procedure StopAll;
    function GetService(const ServiceClass: TServiceClass): TService;
  end;

var
  Services: TServices;

  procedure GlobalInitialization;
  procedure GlobalFinalization;

implementation

{ TServices }

constructor TServices.Create;
begin
  inherited;
  Services := TObjectList.Create;
  Services.OwnsObjects := false;
  ServicesClass := TObjectList.Create;
  ServicesClass.OwnsObjects := false;
end;

destructor TServices.Destroy;
begin
  Services.Free;
  ServicesClass.Free;
  inherited;
end;

function TServices.GetService(const ServiceClass: TServiceClass): TService;
var i, num: integer;
begin
  num := Services.Count - 1;
  for i := 0 to num do begin
    if Services[i].ClassType = ServiceClass then begin
      result := TService(Services[i]);
      exit;
    end;
  end;
  result := nil;
end;

procedure TServices.RegisterService(const ServiceClass: TServiceClass);
begin
  ServicesClass.Add(TObject(ServiceClass));
end;

procedure TServices.StartAll;
var i, num: integer;
  Service: TService;
begin
  num := ServicesClass.Count - 1;
  for i := 0 to num do begin
    Service := TServiceClass(ServicesClass.Items[i]).Create(true);
    Service.FreeOnTerminate := true;
    Services.Add(Service);
    Service.Resume;
  end;
end;

procedure TServices.StopAll;
var i, num: integer;
begin
  num := Services.Count - 1;
  for i := 0 to num do
    TService(Services.Items[i]).Cancel;
end;


procedure GlobalInitialization;
begin
  Services := TServices.Create;
end;

procedure GlobalFinalization;
begin
  Services.Free;
end;

end.
