unit UtilInterfaces;

interface

uses Classes, dmThreadDataModule;

type
  //NCR = No Count Ref
  TInterfacedObjectNCR = class(TInterfacedPersistent)
  protected
    function _AddRef: Integer; reintroduce; stdcall;
    function _Release: Integer; reintroduce; stdcall;
  end;

  TDataModuleNCR = class(TThreadDataModule)
  protected
    function _AddRef: Integer; reintroduce; stdcall;
    function _Release: Integer; reintroduce; stdcall;
  end;

implementation

{$R *.dfm}

{ TInterfacedObjectNCR }

function TInterfacedObjectNCR._AddRef: Integer;
begin
  result := -1;
end;

function TInterfacedObjectNCR._Release: Integer;
begin
  result := -1;
end;

{ TDataModuleNCR }

function TDataModuleNCR._AddRef: Integer;
begin
  result := -1;
end;

function TDataModuleNCR._Release: Integer;
begin
  result := -1;
end;

end.


