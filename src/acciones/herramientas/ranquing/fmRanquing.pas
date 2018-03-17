unit fmRanquing;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, dmRanquing, VirtualTrees;

type
  TfRanquing = class(TfBase)
    vtRanquing: TVirtualStringTree;
    procedure FormShow(Sender: TObject);
    procedure vtRanquingGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure vtRanquingCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vtRanquingHeaderClick(Sender: TVTHeader; Column: TColumnIndex;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure vtRanquingInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure vtRanquingFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
  private
    Ranquing: TRanquing;
    resultado: TPosiciones;
  public
    constructor Create(AOwner: TComponent); override;
  end;


implementation

uses dmDataComun;

type
  TTreeData = record
    iResultado: integer;
  end;

{$R *.dfm}

{ TfRanquing }

constructor TfRanquing.Create(AOwner: TComponent);
begin
  inherited;
  Ranquing := TRanquing.Create(Self);
end;

procedure TfRanquing.FormShow(Sender: TObject);
begin
  inherited;
  Ranquing.Calculate;
  resultado := Ranquing.Resultado;
  vtRanquing.NodeDataSize := SizeOf(TTreeData);
  vtRanquing.RootNodeCount := length(resultado);
end;

procedure TfRanquing.vtRanquingCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  NodeData1, NodeData2: ^TTreeData;
  i1, i2: integer;
begin
  inherited;
  NodeData1 := Sender.GetNodeData(Node1);
  i1 := NodeData1^.iResultado;
  NodeData2 := Sender.GetNodeData(Node2);
  i2 := NodeData2^.iResultado;
  case Column of
    0: begin
      result := CompareStr(DataComun.FindValor(resultado[i1].OIDValor)^.Simbolo,
        DataComun.FindValor(resultado[i2].OIDValor)^.Simbolo);
    end;
    1: begin
      result := CompareStr(DataComun.FindValor(resultado[i1].OIDValor)^.Nombre,
        DataComun.FindValor(resultado[i2].OIDValor)^.Nombre);
    end;
    2: begin
      result := resultado[i1].puntos - resultado[i2].puntosAnt;
    end;
    3: begin
      result := resultado[i1].PuntosAnt - resultado[i2].Puntos;
    end;
    4: begin
      result := resultado[i1].Incremento - resultado[i2].Incremento;
    end;
  end;
end;

procedure TfRanquing.vtRanquingFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  NodeData: ^TTreeData;
  i: integer;
begin
  inherited;
  NodeData := Sender.GetNodeData(Node);
  i := NodeData^.iResultado;
  Ranquing.IrA(i);
end;

procedure TfRanquing.vtRanquingGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  NodeData: ^TTreeData;
  i: integer;
begin
  inherited;
  NodeData := Sender.GetNodeData(Node);
  i := NodeData^.iResultado;
  case Column of
    0: begin
      CellText := DataComun.FindValor(resultado[i].OIDValor)^.Simbolo;
    end;
    1: begin
      CellText := DataComun.FindValor(resultado[i].OIDValor)^.Nombre;
    end;
    2: begin
      CellText := IntToStr(resultado[i].puntosAnt);
    end;
    3: begin
      CellText := IntToStr(resultado[i].Puntos);
    end;
    4: begin
      CellText := IntToStr(resultado[i].Incremento);
    end;
  end;
end;

procedure TfRanquing.vtRanquingHeaderClick(Sender: TVTHeader;
  Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
    if (vtRanquing.Header.SortColumn <> Column) then
         vtRanquing.Header.SortColumn := Column
    else if (vtRanquing.Header.SortDirection = sdAscending) then
         vtRanquing.Header.SortDirection := sdDescending
      else
         vtRanquing.Header.SortDirection := sdAscending;

    vtRanquing.SortTree( Column, vtRanquing.Header.SortDirection );
end;

procedure TfRanquing.vtRanquingInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  NodeData: ^TTreeData;
begin
  inherited;
  NodeData := Sender.GetNodeData(Node);
  NodeData^.iResultado := Node.Index;
end;

end.
