unit frEditFS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frFS, ImgList, ActnList, VirtualTrees, TB2Item, SpTBXItem, TB2Dock,
  TB2Toolbar, dmEditFS, ActiveX;

type
  TNuevoFSDialog = function (var nombre: string; var data: Pointer;
    const caption: string; const max: integer): boolean of object;

  TfEditFS = class(TfFS)
    Toolbar: TSpTBXToolbar;
    TBXItem1: TSpTBXItem;
    TBXItem5: TSpTBXItem;
    TBXSeparatorItem1: TSpTBXSeparatorItem;
    TBXItem2: TSpTBXItem;
    TBXItem3: TSpTBXItem;
    TBXSeparatorItem2: TSpTBXSeparatorItem;
    TBXItem4: TSpTBXItem;
    ImageList: TImageList;
    ActionList: TActionList;
    CrearCarpeta: TAction;
    BorrarCarpeta: TAction;
    CrearFichero: TAction;
    BorrarFichero: TAction;
    CambiarNombre: TAction;
    procedure BorrarCarpetaExecute(Sender: TObject);
    procedure CrearCarpetaUpdate(Sender: TObject);
    procedure BorrarFicheroExecute(Sender: TObject);
    procedure BorrarFicheroUpdate(Sender: TObject);
    procedure CambiarNombreExecute(Sender: TObject);
    procedure CambiarNombreUpdate(Sender: TObject);
    procedure CrearCarpetaExecute(Sender: TObject);
    procedure CrearFicheroExecute(Sender: TObject);
    procedure BorrarCarpetaUpdate(Sender: TObject);
    procedure TreeFSDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure TreeFSNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; NewText: WideString);
    procedure TreeFSEdited(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure TreeFSDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure TreeFSDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
  private
    FEditFS: TEditFS;
    FMsgBorrarFichero: string;
    FTituloCarpetaNueva: string;
    FTituloFicheroNuevo: string;
    FTituloBorrarCarpeta: string;
    FMsgBorrarCarpeta: string;
    FTituloBorrarFichero: string;
    FNuevoFSDialog: TNuevoFSDialog;
    procedure SetEditFS(const Value: TEditFS);
  protected
  public
    constructor Create(AOwner: TComponent); override;
//    function Anadir(const carpeta: boolean; const hija: boolean; const nombre: string): integer;
    function AnadirFichero(const focusNewNode: boolean; data: Pointer): integer; overload;
    function AnadirFichero(const nombre: string; data: Pointer; const focusNewNode: Boolean; Node: PVirtualNode): integer; overload;
    function AnadirFicheroFocusedNode(const nombre: string; data: Pointer; const focusNewNode: Boolean): integer;
    function AnadirCarpeta(const focusNewNode: boolean): integer; overload;
    function AnadirCarpeta(const nombre: string; const focusNewNode: Boolean; Node: PVirtualNode): integer; overload;
    function AnadirCarpetaFocusedNode(const nombre: string; const focusNewNode: Boolean): integer;
    procedure Borrar(const Node: PVirtualNode; const confirmacion: boolean);
    procedure BorrarFocusedNode(const confirmacion: boolean);
    property TituloCarpetaNueva: string read FTituloCarpetaNueva write FTituloCarpetaNueva;
    property TituloBorrarCarpeta: string read FTituloBorrarCarpeta write FTituloBorrarCarpeta;
    property MsgBorrarCarpeta: string read FMsgBorrarCarpeta write FMsgBorrarCarpeta;
    property TituloFicheroNuevo: string read FTituloFicheroNuevo write FTituloFicheroNuevo;
    property TituloBorrarFichero: string read FTituloBorrarFichero write FTituloBorrarFichero;
    property MsgBorrarFichero: string read FMsgBorrarFichero write FMsgBorrarFichero;
    property NuevoFSDialog: TNuevoFSDialog read FNuevoFSDialog write FNuevoFSDialog;
    property EditFS: TEditFS read FEditFS write SetEditFS;
  end;


implementation

{$R *.dfm}

uses fmBaseNuevo, UtilForms;

resourcestring
  TITULO_CARPETA_NUEVA = 'Carpeta nueva';
  TITULO_BORRAR_CARPETA = 'Borrar carpeta';
  MSG_BORRAR_CARPETA = '¿Está seguro de borrar la carpeta %s y todo su contenido?';

{ TfFS1 }
{
function TfEditFS.Anadir(const carpeta, hija: boolean; const nombre: string): integer;
var NewNode, Node: PVirtualNode;
  OID: integer;
begin
  Node := TreeFS.FocusedNode;
  if (Node = nil) or ((Node.Parent = TreeFS.RootNode) and (not IsDirectory(Node))) then begin
    if carpeta then
      OID := FEditFS.AddRootDirectory(nombre)
    else
      OID := FEditFS.AddRootFile(nombre);
    Node := TreeFS.RootNode;
  end
  else begin
    if not hija then
      Node := Node.Parent;
    if Node = TreeFS.RootNode then begin
      if carpeta then
        OID := FEditFS.AddRootDirectory(nombre)
      else
        OID := FEditFS.AddRootFile(nombre);
      Node := TreeFS.RootNode;
    end
    else begin
      OID := GetNodeData(Node).OID;
      if carpeta then
        OID := FEditFS.AddDirectory(OID, nombre)
      else
        OID := FEditFS.AddFile(OID, nombre);
    end;
  end;
  // IMPORTANTE hacer el BeginUpdate, sino al crear un nodo, automáticamente
  // se hace un GetText, cuando aún no se ha rellenado el Data. Si se hace un
  // BeginUpdate los GetText se realizan al hacer el EndUpdate.
  TreeFS.BeginUpdate;
  try
    if carpeta then begin
      NewNode := AnadirCarpetaTreeFS(Node, nombre, OID);
      MarkAsLoaded(NewNode);
    end
    else
      NewNode := AnadirFileTreeFS(Node, nombre, OID);
  finally
    TreeFS.EndUpdate;
  end;
  TreeFS.Sort(Node, 0, sdAscending, false);
  TreeFS.FocusedNode := NewNode;
  TreeFS.Selected[NewNode] := true;
  result := OID;
end;
}

function TfEditFS.AnadirCarpeta(const nombre: string; const focusNewNode: Boolean;
  Node: PVirtualNode): integer;
var NewNode: PVirtualNode;
  OID: integer;
begin
  if (Node = nil) or ((Node.Parent = TreeFS.RootNode) and (not IsDirectory(Node))) then begin
    OID := FEditFS.AddRootDirectory(nombre);
    Node := TreeFS.RootNode;
  end
  else begin
    if not IsDirectory(Node) then
      Node := Node.Parent;
    if Node = TreeFS.RootNode then begin
      OID := FEditFS.AddRootDirectory(nombre);
      Node := TreeFS.RootNode;
    end
    else begin
      OID := GetNodeData(Node).OID;
      OID := FEditFS.AddDirectory(OID, nombre)
    end;
  end;
  // IMPORTANTE hacer el BeginUpdate, sino al crear un nodo, automáticamente
  // se hace un GetText, cuando aún no se ha rellenado el Data. Si se hace un
  // BeginUpdate los GetText se realizan al hacer el EndUpdate.
  TreeFS.BeginUpdate;
  try
    NewNode := AnadirCarpetaTreeFS(Node, nombre, OID);
    MarkAsLoaded(NewNode);
  finally
    TreeFS.EndUpdate;
  end;
  TreeFS.Sort(Node, 0, sdAscending, false);
  if focusNewNode then begin
    TreeFS.FocusedNode := NewNode;
    TreeFS.Selected[NewNode] := true;
  end;
  result := OID;
end;

function TfEditFS.AnadirCarpeta(const focusNewNode: boolean): integer;
var nombre: string;
begin
  if MostrarNuevo(nombre, TituloCarpetaNueva, FEditFS.NombreSize) then
    result := AnadirCarpetaFocusedNode(nombre, focusNewNode)
  else
    raise EAbort.Create('');
end;

function TfEditFS.AnadirCarpetaFocusedNode(const nombre: string;
  const focusNewNode: Boolean): integer;
begin
  result := AnadirCarpeta(nombre, focusNewNode, TreeFS.FocusedNode);
end;

function TfEditFS.AnadirFichero(const nombre: string; data: Pointer;
  const focusNewNode: Boolean; Node: PVirtualNode): integer;
var NewNode: PVirtualNode;
  OID: integer;
begin
  if (Node = nil) or ((Node.Parent = TreeFS.RootNode) and (not IsDirectory(Node))) then begin
    OID := FEditFS.AddRootFile(nombre, data);
    Node := TreeFS.RootNode;
  end
  else begin
    if not IsDirectory(Node) then
      Node := Node.Parent;
    if Node = TreeFS.RootNode then begin
      OID := FEditFS.AddRootFile(nombre, data);
      Node := TreeFS.RootNode;
    end
    else begin
      OID := GetNodeData(Node).OID;
      OID := FEditFS.AddFile(OID, nombre, data);
    end;
  end;
  // IMPORTANTE hacer el BeginUpdate, sino al crear un nodo, automáticamente
  // se hace un GetText, cuando aún no se ha rellenado el Data. Si se hace un
  // BeginUpdate los GetText se realizan al hacer el EndUpdate.
  TreeFS.BeginUpdate;
  try
     NewNode := AnadirFileTreeFS(Node, nombre, OID);
  finally
    TreeFS.EndUpdate;
  end;
  TreeFS.Sort(Node, 0, sdAscending, false);
  if focusNewNode then begin
    TreeFS.FocusedNode := NewNode;
    TreeFS.Selected[NewNode] := true;
  end;
  result := OID;
end;

function TfEditFS.AnadirFichero(const focusNewNode: boolean; data: Pointer): Integer;
var nombre: string;
begin
  if Assigned(FNuevoFSDialog) then begin
    if FNuevoFSDialog(nombre, data, TituloFicheroNuevo, FEditFS.NombreSize) then
      result := AnadirFicheroFocusedNode(nombre, data, focusNewNode)
    else
      raise EAbort.Create('');
  end
  else begin
    if MostrarNuevo(nombre, TituloFicheroNuevo, FEditFS.NombreSize) then
      result := AnadirFicheroFocusedNode(nombre, data, focusNewNode)
    else
      raise EAbort.Create('');
  end;
end;

function TfEditFS.AnadirFicheroFocusedNode(const nombre: string;
  data: Pointer; const focusNewNode: Boolean): integer;
begin
  result := AnadirFichero(nombre, data, focusNewNode, TreeFS.FocusedNode);
end;

procedure TfEditFS.Borrar(const Node: PVirtualNode; const confirmacion: boolean);
var Data: TBasicNodeData;
  titulo, msg: string;
begin
  if Node <> nil then begin
    Data := GetNodeData(Node);
    if Data is TDirectoryNode then begin
      titulo := TituloBorrarCarpeta;
      msg := Format(MsgBorrarCarpeta, [Data.Caption]);
    end
    else begin
      titulo := TituloBorrarFichero;
      msg := Format(MsgBorrarFichero, [Data.Caption]);
    end;
    if (not confirmacion) or (ShowMensaje(titulo, msg, mtConfirmation, [mbYes, mbNo]) = mrYes) then begin
      FEditFS.Delete(Data.OID);
      TreeFS.DeleteNode(Node);
    end;
  end;
end;

procedure TfEditFS.BorrarCarpetaExecute(Sender: TObject);
begin
  if IsFocusedDirectory then  
    BorrarFocusedNode(true);
end;

procedure TfEditFS.BorrarCarpetaUpdate(Sender: TObject);
begin
  BorrarCarpeta.Enabled := IsFocusedDirectory;
end;

procedure TfEditFS.BorrarFicheroExecute(Sender: TObject);
begin
  if IsFocusedFile then
    BorrarFocusedNode(true);
end;

procedure TfEditFS.BorrarFicheroUpdate(Sender: TObject);
begin
  BorrarFichero.Enabled := IsFocusedFile;
end;

procedure TfEditFS.BorrarFocusedNode(const confirmacion: boolean);
begin
  Borrar(TreeFS.FocusedNode, confirmacion);
end;

procedure TfEditFS.CambiarNombreExecute(Sender: TObject);
begin
  TreeFS.EditNode(TreeFS.FocusedNode, -1);
end;

procedure TfEditFS.CambiarNombreUpdate(Sender: TObject);
var focusedNode: PVirtualNode;
begin
  focusedNode := TreeFS.FocusedNode;
  CambiarNombre.Enabled := focusedNode <> nil;
end;

procedure TfEditFS.CrearCarpetaExecute(Sender: TObject);
begin
  AnadirCarpeta(true);
end;

procedure TfEditFS.CrearCarpetaUpdate(Sender: TObject);
begin
  BorrarCarpeta.Enabled := IsFocusedDirectory;
end;

procedure TfEditFS.CrearFicheroExecute(Sender: TObject);
begin
  AnadirFichero(true, nil);
end;

constructor TfEditFS.Create(AOwner: TComponent);
begin
  inherited;
  FTituloCarpetaNueva := TITULO_CARPETA_NUEVA;
  FTituloBorrarCarpeta := TITULO_BORRAR_CARPETA;
  FMsgBorrarCarpeta := MSG_BORRAR_CARPETA;
end;

procedure TfEditFS.SetEditFS(const Value: TEditFS);
begin
  FEditFS := Value;
  inherited FS := Value;
end;

procedure TfEditFS.TreeFSDragAllowed(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  inherited;
  Allowed := true;
end;

procedure TfEditFS.TreeFSDragDrop(Sender: TBaseVirtualTree; Source: TObject;
  DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
  Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var srcNode, destNode: PVirtualNode;
  srcData: TBasicNodeData;
  OIDDestino: integer;
begin
  srcNode := TreeFS.FocusedNode;
  if srcNode <> nil then begin
    destNode := TreeFS.DropTargetNode;
    if destNode = nil then
      destNode := TreeFS.RootNode
    else begin
      if GetNodeData(destNode) is TFileNode then
        destNode := destNode.Parent;
    end;
    srcData := GetNodeData(srcNode);
    // IMPORTANTE: Extender el nodo antes de mover, ya que si el nodo no está
    // cargado porque antes no se expandió, el resultado es que se ve solo el nodo
    // movido en el nodo destino, ya que como al mover un nodo en el destino tendrá
    // un nodo, si se expande se cree que ya se han cargado los nodos
    TreeFS.Expanded[destNode] := true;
    // IMPORTANTE: Hacer el moveTo antes del FEditFS.Update, ya que si se hiciera al
    // revés, aparecería el nodo 2 veces si el nodo destino no estuviera cargado,
    // 1 porque cargaría los nodos desde la BD y la otra vez la que pondría el
    // arbol al mover
    TreeFS.MoveTo(srcNode, destNode, amAddChildLast, false);
    if destNode = TreeFS.RootNode then
      OIDDestino := FEditFS.OIDRoot
    else
      OIDDestino := GetNodeData(destNode).OID;
    FEditFS.Update(srcData.OID, OIDDestino, srcData.Caption);
    TreeFS.Sort(destNode, 0, sdAscending, false);
  end;
end;

procedure TfEditFS.TreeFSDragOver(Sender: TBaseVirtualTree; Source: TObject;
  Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
  var Effect: Integer; var Accept: Boolean);
var targetNode, srcNode, rootNode: PVirtualNode;
  targetData, srcData: TBasicNodeData;
begin
  Accept := Source = TreeFS;
  if Accept then begin
    srcNode := TreeFS.FocusedNode;
    srcData := GetNodeData(srcNode);
    Accept := srcNode <> nil;
    if Accept then begin
      targetNode := Sender.DropTargetNode;
      targetData := GetNodeData(targetNode);
      Accept := targetNode <> nil;
      if Accept then begin
        if srcData is TDirectoryNode then begin
          Accept := (not (targetData is TFileNode)) and (targetNode <> srcNode.Parent);
          if Accept then begin
            rootNode := TreeFS.RootNode;
            // Si el src es un directory, no puede moverse a un directory hijo
            while (Accept) and (targetNode <> rootNode) do begin
              Accept := targetNode <> srcNode;
              targetNode := targetNode.Parent;
            end;
          end;
        end
        else
          // srcData is TFileNode o RootNode
          Accept := targetNode <> srcNode.Parent;
      end;
    end;
  end;
end;

procedure TfEditFS.TreeFSEdited(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex);
begin
  TreeFS.Sort(Node.Parent, 0, sdAscending, false);
end;

procedure TfEditFS.TreeFSNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; NewText: WideString);
var Data, ParentData: TBasicNodeData;
  ParentNode: PVirtualNode;
  OIDParent: integer;
begin
  Data := GetNodeData(Node);
  Data.Caption := NewText;
  ParentNode := Node.Parent;
  if ParentNode = TreeFS.RootNode  then
    OIDParent := FEditFS.OIDRoot
  else begin
    ParentData := GetNodeData(ParentNode);
    OIDParent := ParentData.OID;
  end;
  FEditFS.Update(Data.OID, OIDParent, NewText);
end;

end.
