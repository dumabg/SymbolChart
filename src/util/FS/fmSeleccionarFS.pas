unit fmSeleccionarFS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, ExtCtrls, frFS,dmFS, StdCtrls, Buttons, VirtualTrees;

type
  TSelections = set of TFSType;

  TFSClass = class of TFS;

  TfSeleccionarFS = class(TfBase)
    fFS: TfFS;
    Panel1: TPanel;
    bSeleccionar: TBitBtn;
    BitBtn2: TBitBtn;
    procedure fFS1TreeFSChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private
    FSelections: TSelections;
    function GetSelected: TBasicNodeData;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetFSClass(const FSClass: TFSClass);
    property Selections: TSelections read FSelections write FSelections;
    property Selected: TBasicNodeData read GetSelected;
  end;

implementation

{$R *.dfm}

constructor TfSeleccionarFS.Create(AOwner: TComponent);
begin
  inherited;
  Include(FSelections, fstFile);
end;

procedure TfSeleccionarFS.fFS1TreeFSChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  inherited;
  bSeleccionar.Enabled := ((fFS.IsFocusedDirectory) and (fstDirectory in FSelections)) or
    ((fFs.IsFocusedFile) and (fstFile in FSelections));
end;

function TfSeleccionarFS.GetSelected: TBasicNodeData;
begin
  result := fFS.GetNodeDataFocused;
end;

procedure TfSeleccionarFS.SetFSClass(const FSClass: TFSClass);
begin
  fFS.FS := FSClass.Create(Self);
end;

end.
