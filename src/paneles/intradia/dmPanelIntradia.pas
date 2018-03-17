unit dmPanelIntradia;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery;

type
  TPanelIntradia = class(TDataModule)
    AmbienteIntradia: TIBQuery;
    AmbienteIntradiaOID_AMBIENTE_INTRADIA: TIBStringField;
    AmbienteIntradiaMENSAJE: TIBStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    function GetMsg(const OID: string): string;
  end;

implementation

uses dmBD, UtilDB;

{$R *.dfm}

procedure TPanelIntradia.DataModuleCreate(Sender: TObject);
begin
  OpenDataSet(AmbienteIntradia);
end;

function TPanelIntradia.GetMsg(const OID: string): string;
begin
  if AmbienteIntradia.Locate('OID_AMBIENTE_INTRADIA', OID, []) then
    result := AmbienteIntradiaMENSAJE.Value
  else
    result := '';
end;

end.
