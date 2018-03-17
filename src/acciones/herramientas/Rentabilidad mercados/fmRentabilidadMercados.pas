unit fmRentabilidadMercados;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, DB, StdCtrls, frRentabilidadMercado,
  dmRentabilidadMercados, DBCtrls, ExtCtrls, Buttons;

type
  TfRentabilidadMercados = class(TfBase)
    dsMercados: TDataSource;
    btCerrar: TBitBtn;
    procedure btCerrarClick(Sender: TObject);
  private
    data: TRentabilidadMercados;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses dmDataComun, ConstantsDatosBD;

{$R *.dfm}

procedure TfRentabilidadMercados.btCerrarClick(Sender: TObject);
begin
  inherited;
  Close;
end;

constructor TfRentabilidadMercados.Create(AOwner: TComponent);
var etiqueta: TLabel;
  top: integer;
  maxAbiertas, maxCerradas: currency;
  rent: TfRentabilidadMercado;
  bandera: TImage;
  bevel: TBevel;
  mercados: PDataComunMercados;
  i, OIDMercado: integer;
  sI: string;
  colActual: integer;
const col0: integer = 24;
  col1: integer = 383;
begin
  inherited Create(AOwner);
  data := TRentabilidadMercados.Create(Self);
  data.GetMax(maxAbiertas, maxCerradas);
  top := 26;
  mercados := DataComun.Mercados;
  colActual := col0;
  for i := Low(mercados^) to High(mercados^) do begin
    OIDMercado := mercados^[i].OIDMercado;
    if ((OIDMercado < Mercado_Const.OID_IndicesEuropa) or (OIDMercado > Mercado_Const.OID_IndicesAsia))
      and (OIDMercado < Mercado_Const.OID_ETF_USA) and (OIDMercado > Mercado_Const.OID_EstadosUnidos_NASDAQ) then begin
      sI := IntToStr(i);
      bandera := TImage.Create(Self);
      bandera.Parent := Self;
      bandera.Name := 'b' + sI;
      bandera.Left := colActual;
      bandera.Top := top;
      DataComun.DibujarBandera(OIDMercado, bandera.Canvas, 0, 0, Color);
      etiqueta := TLabel.Create(Self);
      etiqueta.Name := 'l' + sI;
      etiqueta.Parent := Self;
      etiqueta.Left := colActual + 22;
      etiqueta.Top := top;
      etiqueta.Font.Style := [fsBold];
      etiqueta.Caption := mercados^[i].Nombre;
      if mercados^[i].Pais <> mercados^[i].Nombre then
        etiqueta.Caption := mercados^[i].Pais + ' - ' + etiqueta.Caption;
      rent := TfRentabilidadMercado.Create(Self);
      rent.Name := 'r' + sI;
      rent.Parent := Self;
      rent.Left := colActual;
      rent.top := top + 20;
      rent.Load(data.OIDSesion, OIDMercado, maxAbiertas, maxCerradas);
      bevel := TBevel.Create(Self);
      bevel.Name := 'be' + sI;
      bevel.Parent := Self;
      bevel.Shape := bsBottomLine;
      bevel.Width := rent.Width;
      bevel.Height := 10;
      bevel.top := rent.Top + rent.Height;
      bevel.left := colActual;
      if colActual = col0 then
        colActual := col1
      else begin
        colActual := col0;
        top := top + 100;
      end;
    end;
  end;
  {$WARNINGS OFF}
  // Variable rent might not have been initialized
  Width := 383 + rent.Width + 30;
  {$WARNINGS ON}
  Height := top + 100 + btCerrar.Height + 20;
  top := 10;
  bevel := TBevel.Create(Self);
  bevel.Name := 'be_';
  bevel.Parent := Self;
  bevel.Shape := bsBottomLine;
  bevel.Width := rent.Width;
  bevel.Height := 10;
  bevel.top := top;
  bevel.left := 24;
  bevel := TBevel.Create(Self);
  bevel.Name := 'be_2';
  bevel.Parent := Self;
  bevel.Shape := bsBottomLine;
  bevel.Width := rent.Width;
  bevel.Height := 10;
  bevel.top := top;
  bevel.left := 383;
end;

end.
