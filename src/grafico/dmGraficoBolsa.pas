unit dmGraficoBolsa;

interface

uses
  SysUtils, Classes, IBCustomDataSet, IBUpdateSQL, DB, IBQuery, IBSQL,
  Contnrs, GraficoLineasLayer;

type
  TDataGraficoBolsa = class(TDataModule)
    qLineas: TIBQuery;
    qLineasOID_LINEA: TSmallintField;
    qLineasOR_VALOR: TSmallintField;
    qLineasY1: TIBBCDField;
    qLineasY2: TIBBCDField;
    dLineas: TIBSQL;
    iLinea: TIBSQL;
    qLineasTIPO: TIBStringField;
    qLineasX1: TDateField;
    qLineasX2: TDateField;
  private
    { Private declarations }
  public
    procedure GuardarLineas(const OIDValor: integer; const lineas: TObjectList);
    procedure CargarLineasLayer(const lineasLayer: TGraficoLinesLayer);
    function CargarLineas: boolean;
  end;


implementation

uses dmBD, UtilDB, dmData;

{$R *.dfm}

{ TDataGraficoBolsa }

function TDataGraficoBolsa.CargarLineas: boolean;
begin
  qLineas.Close;
  qLineas.Params[0].AsInteger := Data.OIDValor;
  qLineas.Open;
  result := not qLineas.IsEmpty;
end;

procedure TDataGraficoBolsa.CargarLineasLayer(const lineasLayer: TGraficoLinesLayer);
var linea: TLine;
  linePoint: TLinePoint;
  lineas: TObjectList;
begin
  try
    lineas := lineasLayer.Lineas;
    while not qLineas.Eof do begin
      if qLineasTIPO.Value = 'N' then begin
        linePoint.x := qLineasX1.Value;
        linePoint.y := qLineasY1.Value;
        linea := TLine.Create(lineasLayer, linePoint);
        linePoint.x := qLineasX2.Value;
        linePoint.y := qLineasY2.Value;
        linea.PointB := linePoint;
      end
      else begin
        if qLineasTIPO.Value = 'H' then begin
          linea := THorizontalLine.Create(lineasLayer, qLineasY1.Value);
        end
        else begin
          if qLineasTIPO.Value = 'V' then begin
            linea := TVerticalLine.Create(lineasLayer, qLineasX1.Value);
          end
          else
            raise Exception.Create('Tipo de línea desconocido: ' + qLineasTIPO.Value);
        end;
      end;
      lineas.Add(linea);
      qLineas.Next;
    end;
  finally
    qLineas.Close;
  end;
end;

procedure TDataGraficoBolsa.GuardarLineas(const OIDValor: integer; const lineas: TObjectList);
var i, num, OIDLinea: Integer;
  linea : TLine;
  OIDGenerator: TOIDGenerator;

    function GetTipoLine: string;
    begin
      if linea is THorizontalLine then
        result := 'H'
      else begin
        if linea is TVerticalLine then
          result := 'V'
        else
          result := 'N';
      end;
    end;
begin
  dLineas.Params[0].AsInteger := OIDValor;
  ExecQuery(dLineas, false);

  OIDGenerator := TOIDGenerator.Create(BD.IBDatabaseUsuario, 'LINEA');
  try
    OIDLinea := OIDGenerator.NextOID;
  finally
    OIDGenerator.Free;
  end;
  num := lineas.Count - 1;
  for i := 0 to num do begin
    linea := lineas[i] as TLine;
    iLinea.ParamByName('OID_LINEA').AsInteger := OIDLinea;
    iLinea.ParamByName('OR_VALOR').AsInteger := OIDValor;
    iLinea.ParamByName('TIPO').AsString := GetTipoLine;
    if linea is THorizontalLine then begin
      iLinea.ParamByName('Y1').AsCurrency := linea.PointA.y;
      iLinea.ParamByName('X1').Clear;
      iLinea.ParamByName('X2').Clear;
      iLinea.ParamByName('Y2').Clear;
    end
    else begin
      if linea is TVerticalLine then begin
        iLinea.ParamByName('X1').AsDate := linea.PointA.x;
        iLinea.ParamByName('Y1').Clear;
        iLinea.ParamByName('X2').Clear;
        iLinea.ParamByName('Y2').Clear;
      end
      else begin
        iLinea.ParamByName('Y1').AsCurrency := linea.PointA.y;
        iLinea.ParamByName('X1').AsDate := linea.PointA.x;
        iLinea.ParamByName('X2').AsDate := linea.PointB.x;
        iLinea.ParamByName('Y2').AsCurrency := linea.PointB.y;
      end;
    end;
    ExecQuery(iLinea, false);
    inc(OIDLinea);
  end;
  iLinea.Transaction.CommitRetaining;
end;

end.
