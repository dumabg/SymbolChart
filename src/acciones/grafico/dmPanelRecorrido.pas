unit dmPanelRecorrido;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmThreadDataModule, DB, IBQuery, Grafico, Tipos, IBCustomDataSet;

type
  TPanelRecorrido = class(TThreadDataModule)
    qRecorrido: TIBQuery;
    qRecorridoOR_SESION: TSmallintField;
    qRecorridoCORRELACION: TSmallintField;
    qRecorridoFECHA: TDateField;
  private
    Cambios: TArrayCurrency;
    FGrafico: TGrafico;
    FGraficoPrincipal: TGrafico;
    procedure SetGrafico(const Value: TGrafico);
  public
    procedure LaunchQuery;
    procedure LoadData;
    property Grafico: TGrafico read FGrafico write SetGrafico;
    property GraficoPrincipal: TGrafico read FGraficoPrincipal write FGraficoPrincipal;
  end;


implementation

uses dmBD, UtilDB, dmData, DatosGrafico;

{$R *.dfm}

procedure TPanelRecorrido.LaunchQuery;
begin
  qRecorrido.Close;
  qRecorrido.Params[0].AsInteger := Data.OIDValor;
  qRecorrido.Open;
end;

procedure TPanelRecorrido.LoadData;
var i, num: integer;
  pFechas: PArrayDate;
  fecha: TDate;
  inspect: TInspectDataSet;
begin
  num := GraficoPrincipal.Datos.DataCount;
  SetLength(Cambios, num);
  pFechas := GraficoPrincipal.Datos.PFechas;
  i := 0;
  inspect := StartInspectDataSet(qRecorrido);
  try
    while (not qRecorrido.Eof) and (i < num) do begin
      fecha := qRecorridoFECHA.Value;
      if pFechas^[i] = fecha then begin
        Cambios[i] := qRecorridoCORRELACION.Value;
        inc(i);
        qRecorrido.Next;
      end
      else begin
        if pFechas^[i] < fecha then begin
          Cambios[i] := SIN_CAMBIO;
          inc(i);
        end
        else
          qRecorrido.Next;
      end;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
  while i < num do begin
    Cambios[i] := SIN_CAMBIO;
    inc(i);
  end;
  Grafico.SetData(@Cambios, pFechas);
end;

procedure TPanelRecorrido.SetGrafico(const Value: TGrafico);
begin
  FGrafico := Value;
  Grafico.ShowDecimals := false;
  Grafico.Datos.MaximoManual := 100;
  Grafico.Datos.MinimoManual := -100;
  Grafico.Datos.DataNull := SIN_CAMBIO;
end;

end.
