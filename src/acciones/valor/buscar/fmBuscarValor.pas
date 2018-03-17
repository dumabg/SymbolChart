unit fmBuscarValor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, Buttons, Grids,
  DBGrids, ActnMan, ActnList, ImgList, XPStyleActnCtrls,
  ExtCtrls, fmBaseBuscar,

  ComCtrls, JvExDBGrids, JvDBGrid, JvDBUltimGrid, dmBuscarValor,
  dmBaseBuscar, Menus, SpTBXItem, TB2Item, TB2Dock, TB2Toolbar;

type
  TfBuscarValor = class(TfBaseBuscar)
    ActionList: TActionList;
    Ir: TAction;
    IrAuto: TAction;
    ImageList: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure GridValoresCellClick(Column: TColumn);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure IrExecute(Sender: TObject);
    procedure IrAutoExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    BuscarValor: TBuscarValor;
    procedure OnAfterScroll(Sender: TDataSet);
  protected
    function GetData: TBaseBuscar; override;
    procedure IrAValor;
  end;

implementation

uses UtilForms, dmData;

{$R *.dfm}

procedure TfBuscarValor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  CloseOnSelect := False;
  Action := caFree;
end;

procedure TfBuscarValor.FormCreate(Sender: TObject);
begin
  inherited;
  dsValores.DataSet.AfterScroll := OnAfterScroll;
  AddCaptionButtons(Self, [cbAlwaysOnTop]);
end;

procedure TfBuscarValor.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  case Key of
    VK_RETURN: begin
      IrAValor;
      if FormStyle <> fsStayOnTop then
        Close;
    end;
  end;
end;

procedure TfBuscarValor.FormShow(Sender: TObject);
begin
  inherited;
  Ir.Enabled := dsValores.DataSet.RecordCount > 0;
  IrAuto.Enabled := Ir.Enabled;
end;

function TfBuscarValor.GetData: TBaseBuscar;
begin
  if BuscarValor = nil then
    BuscarValor := TBuscarValor.Create(Self);
  result := BuscarValor;
end;

procedure TfBuscarValor.GridValoresCellClick(Column: TColumn);
begin
  inherited;
  if not IrAuto.Checked then
    IrAValor;
  if FormStyle <> fsStayOnTop then
    Close;
end;

procedure TfBuscarValor.IrAutoExecute(Sender: TObject);
begin
  IrAuto.Checked := not IrAuto.Checked;
  if IrAuto.Checked then
    IrAValor;
end;

procedure TfBuscarValor.IrAValor;
begin
  Data.IrAValor(OID_VALOR);
end;

procedure TfBuscarValor.IrExecute(Sender: TObject);
begin
  IrAValor;
  if FormStyle <> fsStayOnTop then
    Close;
end;

procedure TfBuscarValor.OnAfterScroll(Sender: TDataSet);
begin
  if IrAuto.Checked then
    IrAValor;
end;

{procedure TfBuscarValor.RefrescarResultadoBusqueda;
var data: TStringStream;
  resultado, valor: string;
  desde, num: integer;
begin
  ResultadoBusqueda.Clear;
  resultado := '<html>';
  resultado := resultado +
    '<head><style type="text/css">img{margin-right:5px}{'+
    'body{font-size:12px}{' +
    '</style></head><body>';


  BuscarValor.Encontrados.First;
  while not BuscarValor.Encontrados.Eof do begin
    valor := BuscarValor.EncontradosVALOR.Value;
    desde := BuscarValor.EncontradosDESDE.Value;
    num := length(eBusqueda.Text);
    resultado := resultado + '<img src="' + BuscarValor.EncontradosOID_MERCADO.AsString + '">';
    if desde > 1 then
      resultado := resultado + Copy(valor, 1, desde - 1);
    resultado := resultado + '<b>' + Copy(valor, desde, num) + '</b>';
    if num < length(valor) then
      resultado := resultado + Copy(valor, desde + num, length(valor));
    resultado := resultado + '<br/>';
    BuscarValor.Encontrados.Next;
  end;

  resultado := resultado + '</body></html>';

  data := TStringStream.Create(resultado);
  try
    ResultadoBusqueda.LoadFromStream(data);
  finally
    data.Free;
  end;
end;

procedure TfBuscarValor.ResultadoBusquedaImageRequest(Sender: TObject;
  const SRC: string; var Stream: TMemoryStream);
begin
  inherited;
//  Stream := BuscarValor.GetBandera(StrToInt(src));
end;
}
end.
