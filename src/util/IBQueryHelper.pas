unit IBQueryHelper;

interface

uses
  IBQuery;

type
  TIBQueryHelper = class helper for TIBQuery
  public
    procedure CancelQuery;
  end;

implementation

uses
  IBIntf, IBExternals, IBHeader;


type
  IBCustomDataSetCrack = class
  private
    FGDSLibrary : IGDSLibrary;
  end;

{ TIBQueryHelper }

procedure TIBQueryHelper.CancelQuery;
var sv: ISC_STATUS;
  handle: TISC_STMT_HANDLE;
begin
  handle := StmtHandle;
  IBCustomDataSetCrack(Self).FGDSLibrary.isc_dsql_free_statement(@sv, @handle, 4);
end;

end.
