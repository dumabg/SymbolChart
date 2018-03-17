unit dmThreadDataModule;

interface

uses
  Classes;

type
  TThreadDataModule = class(TDataModule)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses GlobalSyncronization;

{ TThreadDataModule }

constructor TThreadDataModule.Create(AOwner: TComponent);
begin
  GlobalEnterCriticalSection;
  try
    inherited;
  finally
    GlobalLeaveCriticalSection;
  end;
end;

destructor TThreadDataModule.Destroy;
begin
  GlobalEnterCriticalSection;
  try
    inherited;
  finally
    GlobalLeaveCriticalSection;
  end;
end;

end.
