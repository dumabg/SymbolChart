unit dmDataModuleBase;

interface

uses
  SysUtils, Classes, IBQuery, dmThreadDataModule;

type
  TDataModuleBase = class(TThreadDataModule)
  protected
    function CanPrepare(const q: TIBQuery): boolean; virtual;
    procedure Loaded; override;
  public
  end;

implementation

{$R *.dfm}

{ TDataModuleBase }

function TDataModuleBase.CanPrepare(const q: TIBQuery): boolean;
begin
  result := true;
end;

procedure TDataModuleBase.Loaded;
var i, num: integer;
  c: TComponent;
begin
  inherited;
  num := ComponentCount - 1;
  for i := 0 to num do begin
    c := Components[i];
    if c is TIBQuery then
      if CanPrepare(TIBQuery(c)) then
        TIBQuery(c).Prepare;
  end;
end;

end.
