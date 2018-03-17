unit fmBaseBuscar;

interface

uses
  Windows, SysUtils, Classes, Graphics, fmBase, StdCtrls, Grids, DBGrids, DB,
  JvDBUltimGrid, dmBaseBuscar, Controls, JvExDBGrids, JvDBGrid;

type
  TfBaseBuscar = class(TfBase)
    dsValores: TDataSource;
    GridValores: TJvDBUltimGrid;
    eFiltrada: TEdit;
    procedure eBusquedaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure eFiltradaChange(Sender: TObject);
    procedure GridValoresDrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure GridValoresCellClick(Column: TColumn);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    BaseBuscar: TBaseBuscar;
    FDataSet: TDataSet;
    FieldOIDMercado: TIntegerField;
    FCloseOnSelect: boolean;
    Selected: boolean;
  protected
    function GetData: TBaseBuscar; virtual;
    function GetOID_VALOR: integer; virtual;
  public
    procedure AddChar(const c: char);
    property OID_VALOR: integer read GetOID_VALOR;
    property CloseOnSelect: boolean read FCloseOnSelect write FCloseOnSelect;
  end;

const
  VALOR_NO_SELECTED: integer = Low(Integer);

implementation

uses dmDataComun, UtilGrid;

{$R *.dfm}

procedure TfBaseBuscar.GridValoresCellClick(Column: TColumn);
begin
  inherited;
  Selected := true;
  if FCloseOnSelect then
    Close;
end;

procedure TfBaseBuscar.GridValoresDrawDataCell(Sender: TObject;
  const Rect: TRect; Field: TField; State: TGridDrawState);
var valor, resultado: string;
  desde, num, i: integer;
  DefColor: TColor;
  gCanvas: TCanvas;

  procedure NormalText;
  begin
    gCanvas.Font.Style := [];
    if gdSelected in State then
      gCanvas.Font.Color := clWhite
    else
      gCanvas.Font.Color := clBlack;
  end;
begin
  if not Field.IsNull then begin
    gCanvas := GridValores.Canvas;
    gCanvas.FillRect(Rect);
    valor := Field.AsString;
    if field.Tag = TAG_BANDERA then begin
      DataComun.DibujarBandera(FieldOIDMercado.Value, gCanvas, Rect.Left + 2, Rect.Top + 2, gCanvas.Brush.Color);
      NormalText;
      gCanvas.TextOut(Rect.Left + 23, Rect.Top + 2, valor);
    end
    else begin
      if Field.Tag = TAG_BUSQUEDA then begin
        if gdSelected in State then
          gCanvas.Font.Color := clWhite
        else
          gCanvas.Font.Color := clBlack;
        desde := Pos(UpperCase(eFiltrada.Text), UpperCase(valor));
        num := length(eFiltrada.Text);
        if desde >= 1 then begin
          resultado := Copy(valor, 1, desde - 1);
          gCanvas.TextOut(Rect.Left + 2, Rect.Top + 2, resultado);
          i := gCanvas.TextWidth(resultado);
          resultado := Copy(valor, desde, num);
          DefColor := gCanvas.Brush.Color;
          gCanvas.Brush.Color := $008000FF;
          gCanvas.Font.Style := [fsBold];
          gCanvas.Font.Color := clWhite;
          gCanvas.TextOut(Rect.Left + i + 2, Rect.Top + 2, resultado);
          gCanvas.Brush.Color := DefColor;
          if num < length(valor) then begin
            i := i + gCanvas.TextWidth(resultado);
            resultado := Copy(valor, desde + num, length(valor));
            NormalText;
            gCanvas.TextOut(Rect.Left + i + 2, Rect.Top + 2, resultado);
          end;
        end
        else begin
          NormalText;
          gCanvas.TextOut(Rect.Left + 2, Rect.Top + 2, valor);
        end;
      end
      else begin
        NormalText;
        gCanvas.TextOut(Rect.Left + 2, Rect.Top + 2, valor);
      end;
    end;
  end;
end;

procedure TfBaseBuscar.AddChar(const c: char);
begin
  eFiltrada.Text := eFiltrada.Text + c;
  eFiltrada.SelStart := length(eFiltrada.Text);
  eFiltrada.SelLength := 0;
end;

procedure TfBaseBuscar.eBusquedaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  case Key of
    VK_DOWN: begin
      GridValores.SetFocus;
      FDataSet.Next;
    end;
    VK_UP: begin
      GridValores.SetFocus;
      FDataSet.Prior;
    end;
    VK_PRIOR: begin
      GridValores.SetFocus;
      FDataSet.MoveBy(-16);
    end;
    VK_NEXT: begin
      GridValores.SetFocus;
      FDataSet.MoveBy(16);
    end;
  end;
end;

procedure TfBaseBuscar.eFiltradaChange(Sender: TObject);
begin
  inherited;
  BaseBuscar.BuscarFiltrado(eFiltrada.Text);
end;

procedure TfBaseBuscar.FormCreate(Sender: TObject);
begin
  inherited;
  FCloseOnSelect := true;

  BaseBuscar := GetData;
  dsValores.DataSet := BaseBuscar.Valores;
  FDataSet := dsValores.DataSet;
  FieldOIDMercado := BaseBuscar.ValoresOID_MERCADO;

  TUtilGridSort.Create(GridValores);
  ActiveControl := eFiltrada
end;

procedure TfBaseBuscar.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then begin
    Selected := true;
    if FCloseOnSelect then
      Close;
  end;
end;


function TfBaseBuscar.GetData: TBaseBuscar;
begin
  result := TBaseBuscar.Create(Self);
end;

function TfBaseBuscar.GetOID_VALOR: integer;
begin
  if Selected then
    result := FDataSet.FieldByName('OID_VALOR').AsInteger
  else
    result := VALOR_NO_SELECTED;
end;

end.
