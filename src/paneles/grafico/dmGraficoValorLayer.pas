unit dmGraficoValorLayer;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, dmThreadDataModule, Controls;

type
  ValorCambio = record
    Fecha: TDate;
    Cierre: currency;
  end;

  ArrayValorCambio = array of ValorCambio;

  PArrayValorCambio = ^ArrayValorCambio;

  TDataGraficoValorLayer = class(TThreadDataModule)
    qCotizacion: TIBQuery;
    qCotizacionFECHA: TDateField;
    qCotizacionCIERRE: TIBBCDField;
  private
  public
    function Load(const OIDValor: integer): Integer;
    procedure LoadData(ResultData: PArrayValorCambio);
  end;


implementation

uses dmBD, UtilDB;

{$R *.dfm}

{ TDataGraficoValorLayer }

function TDataGraficoValorLayer.Load(const OIDValor: integer): Integer;
begin
  qCotizacion.Close;
  qCotizacion.Params[0].AsInteger := OIDValor;
  OpenDataSetRecordCount(qCotizacion);
  result := qCotizacion.RecordCount;
end;

procedure TDataGraficoValorLayer.LoadData(ResultData: PArrayValorCambio);
var i: integer;
begin
  i := 0;
  while not qCotizacion.Eof do begin
    with ResultData^[i] do begin
      Fecha := qCotizacionFECHA.Value;
      Cierre := qCotizacionCIERRE.Value;
    end;
    inc(i);
    qCotizacion.Next;
  end;

{  for i := Length(FechasGrafico^) - 1 downto 0 do begin
    if qCotizacion.Locate('FECHA', FechasGrafico^[i], []) then
      ResultData^[i] := qCotizacionCAMBIO.Value
    else
      ResultData^[i] := SIN_CAMBIO;
  end;}
end;


end.
