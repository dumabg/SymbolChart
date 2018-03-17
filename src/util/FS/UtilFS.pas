unit UtilFS;

interface

uses dmFS, SpTBXItem, Classes, frFS;

type
  TMenuFSItem = class(TSpTBXItem)
  private
    FOID: integer;
  public
    property OID: integer read FOID;
  end;

  TFSClass = class of TFS;

  PCrearMenuItemFunction = function (const AOwner: TComponent; const FS: TFS;
    const data: TBasicNodeData): TSpTBXItem;

  procedure CreateMenuFormFS(const AOwner: TComponent; const menuRoot: TSpTBXItem;
    const FSClass: TFSClass; const menuClick: TNotifyEvent;
    const CrearMenuItemFunction: PCrearMenuItemFunction); overload;
  procedure CreateMenuFormFS(const AOwner: TComponent; const menuRoot: TSpTBXItem;
    const FSClass: TFSClass; const menuClick: TNotifyEvent); overload;

  function GetMenuItem(const menuRoot: TSpTBXItem; const OID: Integer): TMenuFSItem;

implementation

uses VirtualTrees;

  function GetMenuItem(const menuRoot: TSpTBXItem; const OID: Integer): TMenuFSItem;
  var i, num: integer;
    subItem: TSpTBXItem;
  begin
    num := menuRoot.Count - 1;
    for i := 0 to num do begin
      subItem := TSpTBXItem(menuRoot.Items[i]);
      if (subItem is TMenuFSItem) and (TMenuFSItem(subItem).OID = OID) then begin
        result := TMenuFSItem(subItem);
        exit;
      end
      else begin
        if subItem.Count > 0 then begin
          result := GetMenuItem(subItem, OID);
          if result <> nil then
            exit;
        end;
      end;
    end;
    result := nil;
  end;


  function CrearMenuItem(const AOwner: TComponent; const FS: TFS;
    const data: TBasicNodeData): TSpTBXItem;
  begin
    result := TMenuFSItem.Create(AOwner);
    result.Caption := data.Caption;
  end;

  procedure CreateMenuFormFS(const AOwner: TComponent; const menuRoot: TSpTBXItem;
    const FSClass: TFSClass; const menuClick: TNotifyEvent);
  begin
    CreateMenuFormFS(AOwner, menuRoot, FSClass, menuClick, CrearMenuItem);
  end;

  procedure CreateMenuFormFS(const AOwner: TComponent; const menuRoot: TSpTBXItem;
    const FSClass: TFSClass; const menuClick: TNotifyEvent;
    const CrearMenuItemFunction: PCrearMenuItemFunction);
  var  menu: TSpTBXItem;
    root, node: PVirtualNode;
    data: TBasicNodeData;
    tree: TVirtualStringTree;
    fFS: TfFS;
    FSData: TFS;

    procedure CrearMenu(const nivel: TSpTBXItem; node: PVirtualNode);
    begin
      while node <> nil do begin
        data := fFS.GetNodeData(node);
        if data is TDirectoryNode then begin
          menu := TSpTBXSubmenuItem.Create(AOwner);
          menu.Caption := data.Caption;
          nivel.Add(menu);
          tree.Expanded[node] := true;
          CrearMenu(menu, tree.GetFirstChild(node));
        end
        else begin
          menu := CrearMenuItemFunction(AOwner, FSData, data);
          if menu <> nil then begin
            if menu is TMenuFSItem then
              TMenuFSItem(menu).FOID := data.OID;
            menu.OnClick := menuClick;
            nivel.Add(menu);
          end;
        end;
          node := tree.GetNextSibling(node);
      end;
    end;
  begin
    fFS := TfFS.Create(nil);
    try
      FSData := FSClass.Create(nil);
      try
        fFS.FS := FSData;
        tree := fFS.TreeFS;
        root := tree.RootNode;
        node := tree.GetFirstChild(root);
        CrearMenu(menuRoot, node);
      finally
        FSData.Free;
      end;
    finally
      fFS.Free;
    end;
  end;

end.
