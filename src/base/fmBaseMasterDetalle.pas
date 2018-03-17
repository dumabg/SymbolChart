unit fmBaseMasterDetalle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, ExtCtrls, JvExExtCtrls, JvNetscapeSplitter, Grids, DBGrids,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid, DB, ActnList, DBActns, AppEvnts,
  TB2Item, SpTBXItem, TB2Dock, TB2Toolbar;

type
  TfBaseMasterDetalle = class(TfBase)
    gMaster: TJvDBUltimGrid;
    Splitter: TJvNetscapeSplitter;
    pDetalle: TPanel;
    dsMaster: TDataSource;
    pMaster: TPanel;
    ActionList: TActionList;
    TBXToolbar1: TSpTBXToolbar;
    TBXItem1: TSpTBXItem;
    Anadir: TAction;
    TBXItem2: TSpTBXItem;
    Borrar: TDataSetDelete;
    procedure dsMasterDataChange(Sender: TObject; Field: TField);
    procedure AnadirExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

uses dmRecursosListas;

{$R *.dfm}

procedure TfBaseMasterDetalle.AnadirExecute(Sender: TObject);
begin
  inherited;
  dsMaster.DataSet.Append;
end;

procedure TfBaseMasterDetalle.dsMasterDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;
  gMaster.Enabled := (dsMaster.DataSet <> nil) and (not dsMaster.DataSet.IsEmpty);
  pDetalle.Visible := gMaster.Enabled;
end;

end.
