unit dmServerVersion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmInternalServer;

type
  TServerVersion = class(TInternalServer)
  private
  public
    function getVersion: string;
  end;


implementation

uses UserServerCalls;

{$R *.dfm}

{ TVersion }

function TServerVersion.getVersion: string;
var versionCall: TVersionUserServerCall;
begin
  versionCall := TVersionUserServerCall.Create(Self);
  try
    result := versionCall.Call;
  finally
    versionCall.Free;
  end;
end;

end.
