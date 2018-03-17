unit dmAccionesCartera;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery;

type
  TAccionesCartera = class(TDataModule)
    qCountCarteras: TIBQuery;
    qCountCarterasCOUNT: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
  private
    FHayCarteras: boolean;
  public
    procedure ReloadNumCarteras;
    property HayCarteras: boolean read FHayCarteras;
  end;

implementation

uses UtilDB, dmBD;

{$R *.dfm}

procedure TAccionesCartera.DataModuleCreate(Sender: TObject);
begin
  ReloadNumCarteras;
end;

procedure TAccionesCartera.ReloadNumCarteras;
begin
  OpenDataSet(qCountCarteras);
  FHayCarteras := qCountCarterasCOUNT.Value > 0;
  qCountCarteras.Close;
end;

end.
