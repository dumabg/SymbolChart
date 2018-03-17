unit fmPlusvaliaRiesgo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, dmPlusvaliaRiesgo, VirtualTrees;

type
  TfPlusvaliaRiesgo = class(TfBase)
    vtPlusvaliaRiesgo: TVirtualStringTree;
    procedure FormCreate(Sender: TObject);
    procedure vtPlusvaliaRiesgoGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vtPlusvaliaRiesgoInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vtPlusvaliaRiesgoHeaderClick(Sender: TVTHeader;
      Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure vtPlusvaliaRiesgoCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vtPlusvaliaRiesgoFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    PlusvaliaRiesgo: TPlusvaliaRiesgo;
    PDataPlusvaliaRiesgo: PArrayDataPlusvaliaRiesgo;
  public
    { Public declarations }
  end;


implementation

uses dmDataComun;

{$R *.dfm}

type
  TTreeData = record
    i: integer;
  end;

procedure TfPlusvaliaRiesgo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

procedure TfPlusvaliaRiesgo.FormCreate(Sender: TObject);
begin
  inherited;
  PlusvaliaRiesgo := TPlusvaliaRiesgo.Create(Self);
  PlusvaliaRiesgo.Calculate;
  PDataPlusvaliaRiesgo := PlusvaliaRiesgo.PDataPlusvaliaRiesgo;
  vtPlusvaliaRiesgo.NodeDataSize := SizeOf(TTreeData);
  vtPlusvaliaRiesgo.RootNodeCount := PlusvaliaRiesgo.Count;
end;

procedure TfPlusvaliaRiesgo.vtPlusvaliaRiesgoCompareNodes(
  Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex;
  var Result: Integer);
var
  NodeData1, NodeData2: ^TTreeData;
  i1, i2: integer;
begin
  inherited;
  NodeData1 := Sender.GetNodeData(Node1);
  i1 := NodeData1^.i;
  NodeData2 := Sender.GetNodeData(Node2);
  i2 := NodeData2^.i;
  case Column of
    0: begin
      result := CompareStr(DataComun.FindValor(PDataPlusvaliaRiesgo^[i1].OIDValor)^.Simbolo,
        DataComun.FindValor(PDataPlusvaliaRiesgo^[i2].OIDValor)^.Simbolo);
    end;
    1: begin
      result := CompareStr(DataComun.FindValor(PDataPlusvaliaRiesgo^[i1].OIDValor)^.Nombre,
        DataComun.FindValor(PDataPlusvaliaRiesgo^[i2].OIDValor)^.Nombre);
    end;
    2: begin
      result := CompareStr(DataComun.FindValor(PDataPlusvaliaRiesgo^[i1].OIDValor)^.Mercado^.Nombre,
        DataComun.FindValor(PDataPlusvaliaRiesgo^[i2].OIDValor)^.Mercado^.Nombre);
    end;
    3: begin
      if PDataPlusvaliaRiesgo^[i1].plusvalia >= PDataPlusvaliaRiesgo^[i2].plusvalia then
        result := 1
      else
        result := -1;
    end;
    4: begin
      if PDataPlusvaliaRiesgo^[i1].Riesgo >= PDataPlusvaliaRiesgo^[i2].Riesgo then
        Result := 1
      else
        result := -1;
    end;
    5: begin
      if (PDataPlusvaliaRiesgo^[i1].plusvalia - PDataPlusvaliaRiesgo^[i1].Riesgo) >=
        (PDataPlusvaliaRiesgo^[i2].plusvalia - PDataPlusvaliaRiesgo^[i2].Riesgo) then
        result := 1
      else
        result := -1;
    end;
  end;
end;

procedure TfPlusvaliaRiesgo.vtPlusvaliaRiesgoFocusChanged(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var
  NodeData: ^TTreeData;
begin
  inherited;
  NodeData := Sender.GetNodeData(Node);
  PlusvaliaRiesgo.IrA(NodeData^.i);
end;

procedure TfPlusvaliaRiesgo.vtPlusvaliaRiesgoGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  NodeData: ^TTreeData;
  i: integer;
begin
  inherited;
  NodeData := Sender.GetNodeData(Node);
  i := NodeData^.i;
  case Column of
    0: begin
      CellText := DataComun.FindValor(PDataPlusvaliaRiesgo^[i].OIDValor)^.Simbolo;
    end;
    1: begin
      CellText := DataComun.FindValor(PDataPlusvaliaRiesgo^[i].OIDValor)^.Nombre;
    end;
    2: begin
      CellText := DataComun.FindValor(PDataPlusvaliaRiesgo^[i].OIDValor)^.Mercado^.Nombre;
    end;
    3: begin
      CellText := FormatFloat('#0.00', PDataPlusvaliaRiesgo^[i].plusvalia) + '%';
    end;
    4: begin
      CellText := FormatFloat('#0.00', PDataPlusvaliaRiesgo^[i].riesgo) + '%';
    end;
    5: begin
      CellText := FormatFloat('#0.00', PDataPlusvaliaRiesgo^[i].plusvalia - PDataPlusvaliaRiesgo^[i].riesgo) + '%';
    end;
  end;
end;

procedure TfPlusvaliaRiesgo.vtPlusvaliaRiesgoHeaderClick(Sender: TVTHeader;
  Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  if (vtPlusvaliaRiesgo.Header.SortColumn <> Column) then
         vtPlusvaliaRiesgo.Header.SortColumn := Column
    else if (vtPlusvaliaRiesgo.Header.SortDirection = sdAscending) then
         vtPlusvaliaRiesgo.Header.SortDirection := sdDescending
      else
         vtPlusvaliaRiesgo.Header.SortDirection := sdAscending;

  vtPlusvaliaRiesgo.SortTree( Column, vtPlusvaliaRiesgo.Header.SortDirection );
end;

procedure TfPlusvaliaRiesgo.vtPlusvaliaRiesgoInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  NodeData: ^TTreeData;
begin
  inherited;
  NodeData := Sender.GetNodeData(Node);
  NodeData^.i := Node.Index;
end;

end.
