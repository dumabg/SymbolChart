unit dmPanelRSI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmThreadDataModule, Grafico, Tipos, DB, IBCustomDataSet, IBQuery,
  IncrustedDatosLineLayer;

type
  TPanelRSI = class(TThreadDataModule)
    qRSI: TIBQuery;
    qRSIOR_SESION: TSmallintField;
    qRSIFECHA: TDateField;
    qRSIRSI_14: TSmallintField;
    qRSIRSI_140: TSmallintField;
  private
    Cambios140: TArrayCurrency;
    Cambios14: TArrayCurrency;
    FGrafico: TGrafico;
    FGraficoPrincipal: TGrafico;
    FRSI140IncrustedLayer: TIncrustedDatosLineLayer;
    procedure SetGrafico(const Value: TGrafico);
    procedure OnAfterSetDataGrafico;
  public
    procedure LaunchQuery;
    procedure LoadData;
    property Grafico: TGrafico read FGrafico write SetGrafico;
    property GraficoPrincipal: TGrafico read FGraficoPrincipal write FGraficoPrincipal;
    property RSI140IncrustedLayer: TIncrustedDatosLineLayer read FRSI140IncrustedLayer write FRSI140IncrustedLayer;
  end;


implementation

uses dmBD, DatosGrafico, UtilDB, dmData, GR32;

{$R *.dfm}

{ TPanelRSI }

procedure TPanelRSI.LaunchQuery;
begin
  qRSI.Close;
  qRSI.Params[0].AsInteger := Data.OIDValor;
  qRSI.Open;
end;

procedure TPanelRSI.LoadData;
var i, num: integer;
  pFechas: PArrayDate;
  fecha: TDate;
  inspect: TInspectDataSet;
begin
  num := GraficoPrincipal.Datos.DataCount;
  SetLength(Cambios140, num);
  SetLength(Cambios14, num);
  pFechas := GraficoPrincipal.Datos.PFechas;
  i := 0;
  inspect := StartInspectDataSet(qRSI);
  try
    while (not qRSI.Eof) and (i < num) do begin
      fecha := qRSIFECHA.Value;
      if pFechas^[i] = fecha then begin
        Cambios14[i] := qRSIRSI_14.Value;
        Cambios140[i] := qRSIRSI_140.Value;
        inc(i);
        qRSI.Next;
      end
      else begin
        if pFechas^[i] < fecha then begin
          Cambios14[i] := SIN_CAMBIO;
          Cambios140[i] := SIN_CAMBIO;
          inc(i);
        end
        else
          qRSI.Next;
      end;
    end;
  finally
     EndInspectDataSet(inspect);
  end;
  while i < num do begin
    Cambios14[i] := SIN_CAMBIO;
    Cambios140[i] := SIN_CAMBIO;
    inc(i);
  end;
  Grafico.SetData(@Cambios14, pFechas);
end;

procedure TPanelRSI.OnAfterSetDataGrafico;
begin
  FRSI140IncrustedLayer.PDatosLayer := @Cambios140;
end;

procedure TPanelRSI.SetGrafico(const Value: TGrafico);
begin
  FGrafico := Value;
  Grafico.ShowDecimals := false;
  Grafico.Datos.MaximoManual := 100;
  Grafico.Datos.MinimoManual := 0;
  Grafico.Datos.DataNull := SIN_CAMBIO;
  Grafico.RegisterEvent(MessageGraficoAfterSetData, OnAfterSetDataGrafico);
end;

end.
