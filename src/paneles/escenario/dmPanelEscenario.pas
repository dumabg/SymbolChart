unit dmPanelEscenario;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, kbmMemTable, GraficoEscenario;

type
  TPanelEscenario = class(TDataModule)
    Cambios: TkbmMemTable;
    CambiosFECHA: TDateField;
    CambiosCAMBIO: TIBBCDField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure CambiosAfterScroll(DataSet: TDataSet);
  private
    posicionando: boolean;
    FGraficoEscenario: TGraficoEscenario;
    procedure SetGraficoEscenario(const Value: TGraficoEscenario);
    procedure OnPositionChange(Position: integer);
    function GetPosicion: integer;
  public
    property GraficoEscenario: TGraficoEscenario read FGraficoEscenario write SetGraficoEscenario;
    property Posicion: integer read GetPosicion;
  end;

implementation

{$R *.dfm}

uses UtilDB, SCMain, Tipos, Controls, DatosGrafico,
  GraficoEscenarioPositionLayer;

{ TPanelEscenario }

procedure TPanelEscenario.CambiosAfterScroll(DataSet: TDataSet);
begin
  if (not posicionando) and (TEscenarioGraficoPositionLayer.EscenarioGraficoPositionLayer <> nil) then begin
    TEscenarioGraficoPositionLayer.EscenarioGraficoPositionLayer.ChangeEscenarioPosition(
      DataSet.RecordCount - DataSet.RecNo);
  end;
end;

procedure TPanelEscenario.DataModuleCreate(Sender: TObject);
begin
  TEscenarioGraficoPositionLayer.OnEscenarioPositionChange := OnPositionChange;
end;

procedure TPanelEscenario.DataModuleDestroy(Sender: TObject);
begin
  TEscenarioGraficoPositionLayer.OnEscenarioPositionChange := nil;
end;

function TPanelEscenario.GetPosicion: integer;
begin
  result := Cambios.RecordCount - Cambios.RecNo;
end;

procedure TPanelEscenario.OnPositionChange(Position: integer);
begin
  posicionando := true;
  try
    Cambios.RecNo := Cambios.RecordCount - Position;
    GraficoEscenario.InvalidateGrafico;
  finally
    posicionando := false;
  end;
end;

procedure TPanelEscenario.SetGraficoEscenario(const Value: TGraficoEscenario);
var i, from, num, position: integer;
  inspect: TInspectDataSet;
  DatosGrafico: TDatosGrafico;
  UltimoIData: integer;
begin
  FGraficoEscenario := Value;
  if (Value = nil) or (not Value.HayEscenario) then
    Cambios.Close
  else begin
    UltimoIData := TDatosGraficoEscenario(Value.Datos).UltimoIData;
    inspect := StartInspectDataSet(Cambios);
    try
      Cambios.Close;
      from := UltimoIData + 1;
      num := Value.Datos.DataCount - 1;
      Cambios.Open;

      DatosGrafico := Value.Datos;
      for i := num downto from do begin
        if DatosGrafico.IsCambio[i] then begin //Si hay sintonización los cambios serán null
          Cambios.Append;
          CambiosFECHA.Value := DatosGrafico.Fechas[i];
          CambiosCAMBIO.Value := DatosGrafico.Cambio[i];
          Cambios.Post;
        end;
      end;

      position := fSCMain.Grafico.GetGraficoPositionLayer.Position;
      if position > UltimoIData then begin
        Cambios.RecNo := Cambios.RecordCount - (position - UltimoIData - 1);
      end;
    finally
      EndInspectDataSet(inspect);
    end;
  end;
end;

end.
