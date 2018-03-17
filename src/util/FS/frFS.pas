unit frFS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, ImgList,
  ActnList, dmFS, SpTBXItem, TB2Item;


type
  TBasicNodeData = class;

  EFSNoFocusedNodeException = class(Exception);

  TfFS = class(TFrame)
    TreeFS: TVirtualStringTree;
    ImageListTree: TImageList;
    procedure TreeFSGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure TreeFSFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure TreeFSGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure TreeFSGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
      var ImageIndex: Integer);
    procedure TreeFSExpanding(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var Allowed: Boolean);
    procedure TreeFSCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure TreeFSInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure TreeFSPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
  private
    FFS: TFS;
    procedure AnadirRama(const ParentNode: PVirtualNode);
    function GetOIDNodeFocused: integer;
  protected
    procedure SetFS(const Value: TFS);
    function AnadirFileTreeFS(const ParentNode: PVirtualNode; const nombre: string;
      const OID: integer): PVirtualNode;
    function AnadirCarpetaTreeFS(const ParentNode: PVirtualNode; const nombre: string;
      const OID: integer): PVirtualNode;
  public
    procedure MarkAsLoaded(const Node: PVirtualNode);
    function GetNodeData(const Node: PVirtualNode): TBasicNodeData;
    function GetNodeDataFocused: TBasicNodeData;
    function IsFocusedRoot: boolean;
    function IsFocusedDirectory: boolean;
    function IsFocusedFile: boolean;
    function IsDirectory(const Node: PVirtualNode): boolean;
    property OIDNodeFocused: integer read GetOIDNodeFocused;
    property FS: TFS read FFS write SetFS;
  end;

  TBasicNodeData = class
    protected
      FCaption: string;
      FOID: integer;
      FImageIndex: integer;
    public
      constructor Create( const Caption : string; const OID, ImageIndex: integer);
      property Caption: string read FCaption write FCaption;
      property OID: integer read FOID write FOID;
      property ImageIndex: integer read FImageIndex  write FImageIndex;
  end;

  TDirectoryNode = class(TBasicNodeData)
  public
    constructor Create(const Caption : string; const OID: integer); reintroduce;
  end;

  TFileNode = class(TBasicNodeData)
  public
    constructor Create(const Caption : string; const OID: integer); reintroduce;
  end;

implementation

{$R *.dfm}

type
  PBasicNodeRec= ^TBasicNodeRec;
  TBasicNodeRec = record
    node : TBasicNodeData;
    loaded: boolean;
  end;

const
  DIRECTORY_NODE_IMAGE_INDEX = 0;
  FILE_NODE_IMAGE_INDEX = 1;

function TfFS.AnadirCarpetaTreeFS(const ParentNode: PVirtualNode;
  const nombre: string; const OID: integer): PVirtualNode;
var  Data: PBasicNodeRec;
begin
    result := TreeFS.AddChild(ParentNode);
    Data := TreeFS.GetNodeData(result);
    Data^.node := TDirectoryNode.Create(nombre, OID);
    Data^.loaded := false;
end;

function TfFS.AnadirFileTreeFS(const ParentNode: PVirtualNode;
  const nombre: string; const OID: integer): PVirtualNode;
var  Data: PBasicNodeRec;
begin
    result := TreeFS.AddChild(ParentNode);
    Data := TreeFS.GetNodeData(result);
    Data^.node := TFileNode.Create(nombre, OID);
    Data^.loaded := true;
end;

procedure TfFS.AnadirRama(const ParentNode: PVirtualNode);
begin
  TreeFS.BeginUpdate;
  try
    FFS.First;
    while not FFS.Eof do begin
      if FFS.Tipo = fstDirectory then
        AnadirCarpetaTreeFS(ParentNode, FS.Nombre, FS.OID)
      else
        AnadirFileTreeFS(ParentNode, FS.Nombre, FS.OID);
      FFS.Next;
    end;
    FFS.Close;
  finally
    TreeFS.EndUpdate;
  end;
end;


function TfFS.GetNodeData(const Node: PVirtualNode): TBasicNodeData;
var Data: PBasicNodeRec;
begin
  Data := TreeFS.GetNodeData(Node);
  result := Data^.node;
end;

function TfFS.GetNodeDataFocused: TBasicNodeData;
var FocusedNode: PVirtualNode;
begin
  FocusedNode := TreeFS.FocusedNode;
  if FocusedNode = nil then
    result := nil
  else
    result := GetNodeData(FocusedNode);
end;

function TfFS.GetOIDNodeFocused: integer;
var FocusedNode: PVirtualNode;
begin
  FocusedNode := TreeFS.FocusedNode;
  if FocusedNode = nil then
    raise EFSNoFocusedNodeException.Create('')
  else
    result := GetNodeData(FocusedNode).OID;;
end;

function TfFS.IsDirectory(const Node: PVirtualNode): boolean;
begin
  result := GetNodeData(Node) is TDirectoryNode;
end;

function TfFS.IsFocusedDirectory: boolean;
var FocusedNode: PVirtualNode;
begin
  FocusedNode := TreeFS.FocusedNode;
  if FocusedNode = nil then
    result := false
  else
    result := GetNodeData(FocusedNode) is TDirectoryNode;
end;

function TfFS.IsFocusedFile: boolean;
var FocusedNode: PVirtualNode;
begin
  FocusedNode := TreeFS.FocusedNode;
  if FocusedNode = nil then
    result := false
  else
    result := GetNodeData(FocusedNode) is TFileNode;
end;

function TfFS.IsFocusedRoot: boolean;
var FocusedNode: PVirtualNode;
begin
  FocusedNode := TreeFS.FocusedNode;
  result := (FocusedNode = nil) or (FocusedNode.Parent = TreeFS.RootNode);
end;

procedure TfFS.MarkAsLoaded(const Node: PVirtualNode);
begin
   PBasicNodeRec(TreeFS.GetNodeData(Node))^.loaded := true;
end;

procedure TfFS.SetFS(const Value: TFS);
begin
  FFS := Value;
  FS.LoadRoot;
  AnadirRama(nil);
end;

procedure TfFS.TreeFSCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var Data1, Data2 : TBasicNodeData;
  Data1Dir, Data2Dir: boolean;
begin
  Data1 := GetNodeData(Node1);
  Data2 := GetNodeData(Node2);
  Data1Dir := Data1 is TDirectoryNode;
  Data2Dir := Data2 is TDirectoryNode;
  // Los 2 son directorios o ficheros
  if Data1Dir = Data2Dir then
    result := WideCompareText(Data1.Caption, Data2.Caption)
  else begin
    if (Data1Dir) and (not Data2Dir) then
      result := 1;
  end;
end;

procedure TfFS.TreeFSExpanding(Sender: TBaseVirtualTree; Node: PVirtualNode;
  var Allowed: Boolean);
var Data: PBasicNodeRec;
begin
  Data := TreeFS.GetNodeData(Node);
  Allowed := Data^.node is TDirectoryNode;
  if (Allowed) and (not Data^.loaded) then begin
    if Node.Parent = nil then
      FS.LoadRoot
    else
      FS.Load(Data^.node.OID);
    AnadirRama(Node);
    Data^.loaded := true;
  end;
end;

procedure TfFS.TreeFSFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var Data: PBasicNodeRec;
begin
  Data := Sender.GetNodeData(Node);
  Data^.node.Free;
  Data^.node := nil;
end;

procedure TfFS.TreeFSGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean;
  var ImageIndex: Integer);
begin
  ImageIndex := GetNodeData(Node).ImageIndex;
end;

procedure TfFS.TreeFSGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TBasicNodeRec);
end;

procedure TfFS.TreeFSGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  CellText := GetNodeData(Node).Caption;
end;

procedure TfFS.TreeFSInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var Data: PBasicNodeRec;
begin
  Data := Sender.GetNodeData(Node);
  if (Data^.node is TDirectoryNode) and (FS.ChildCount(Data^.node.OID) > 0) then
    Include(InitialStates, ivsHasChildren);
end;

procedure TfFS.TreeFSPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
end;

{ TBasicNodeData }

constructor TBasicNodeData.Create(const Caption: string; const OID,
  ImageIndex: Integer);
begin
  FCaption := Caption;
  FOID := OID;
  FImageIndex := ImageIndex;
end;

{ TDirectoryNode }

constructor TDirectoryNode.Create(const Caption: string; const OID: integer);
begin
  inherited Create(Caption, OID, DIRECTORY_NODE_IMAGE_INDEX);
end;

{ TFileNode }

constructor TFileNode.Create(const Caption: string; const OID: integer);
begin
  inherited Create(Caption, OID, FILE_NODE_IMAGE_INDEX);
end;

end.
