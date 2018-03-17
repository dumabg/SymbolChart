unit uPanelEscenario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uPanel, ExtCtrls, StdCtrls,
  Escenario, ActnList, TB2Dock, SpTBXItem, DB,
  Grids, DBGrids, JvExDBGrids, JvDBGrid, JvDBUltimGrid, GraficoEscenario,
  dmPanelEscenario, Tipos;

type
  TfrEscenario = class(TfrPanel)
    ToolWindowEscenario: TSpTBXToolWindow;
    pEscenario: TPanel;
    lSintonizacion: TLabel;
    RiesgoMax: TLabel;
    Plusvalia: TLabel;
    NumSesionEscenario: TLabel;
    Label1: TLabel;
    NitidezLabel: TLabel;
    NitidezArriba: TImage;
    NitidezAbajo: TImage;
    Nitidez: TLabel;
    MinProbable: TLabel;
    MinPesimista: TLabel;
    MinEscenario: TLabel;
    MaxProbable: TLabel;
    MaxOptimista: TLabel;
    MaxEscenario: TLabel;
    Label9: TLabel;
    Label8: TLabel;
    Label5: TLabel;
    Label25: TLabel;
    Label22: TLabel;
    Label18: TLabel;
    Label17: TLabel;
    Label16: TLabel;
    Label15: TLabel;
    Label13: TLabel;
    Label12: TLabel;
    Label11: TLabel;
    Label10: TLabel;
    DistanciaMinEscenario: TLabel;
    DistanciaMaxEscenario: TLabel;
    Desviacion: TLabel;
    CoeficienteVarMin: TLabel;
    CoeficienteVarMax: TLabel;
    Bevel13: TBevel;
    Bevel12: TBevel;
    dsCambios: TDataSource;
    Cotizaciones: TJvDBUltimGrid;
    Label2: TLabel;
    FechaMax: TLabel;
    Label3: TLabel;
    FechaMin: TLabel;
    Label14: TLabel;
    procedure dsCambiosDataChange(Sender: TObject; Field: TField);
    procedure CotizacionesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CotizacionesGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
  private
    PanelEscenario: TPanelEscenario;
    FGraficoEscenario: TGraficoEscenario;
    procedure SetEscenario(const escenario: TEscenario; const Fechas: PArrayDate);
    procedure SetEscenarioMultiple(const escenarioMultiple: TEscenarioMultiple);
    procedure SetGraficoEscenario(const grafico: TGraficoEscenario);
  public
    constructor Create(AOwner: TComponent); override;
    class function GetNombre: string; override;
    class function GetVisiblePorDefecto: boolean; override;
    procedure Borrar;
    property GraficoEscenario: TGraficoEscenario read FGraficoEscenario write SetGraficoEscenario;
  end;

implementation

{$R *.dfm}

uses UtilDock, GraficoBolsa, SCMain, GraficoZoom;

resourcestring
  NOMBRE = 'Escenario';

{ TfrEscenario }


procedure TfrEscenario.Borrar;
begin
  Desviacion.Caption := '?';
  MaxEscenario.Caption := '?';
  MinEscenario.Caption := '?';
  DistanciaMaxEscenario.Caption := '?';
  DistanciaMinEscenario.Caption := '?';
  MaxProbable.Caption := '?';
  MinProbable.Caption := '?';
  Plusvalia.Caption := '?';
  RiesgoMax.Caption := '?';
  Nitidez.Caption := '?';
  CoeficienteVarMax.Caption := '?';
  CoeficienteVarMin.Caption := '?';
  MaxOptimista.Caption := '?';
  MinPesimista.Caption := '?';
  NitidezAbajo.Visible := false;
  NitidezArriba.Visible := false;
  NumSesionEscenario.Caption := '?';
  FechaMax.Caption := '?';
  FechaMin.Caption := '?';
  Cotizaciones.Enabled := false;
  FGraficoEscenario := nil;
  PanelEscenario.GraficoEscenario := nil;
end;

procedure TfrEscenario.CotizacionesGetCellParams(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; Highlight: Boolean);
begin
  inherited;
  if Highlight then
    Background := $00408000;
end;

procedure TfrEscenario.CotizacionesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if FGraficoEscenario <> nil then
    FGraficoEscenario.DoKeyUp(Key, Shift);
end;

constructor TfrEscenario.Create(AOwner: TComponent);
var defaultDock: TDefaultDock;
begin
  defaultDock.Position := dpFlotando;
  defaultDock.Parent := dpAbajo;
  defaultDock.X := 100;
  defaultDock.Y := 100;
  inherited CreatePanel(AOwner, defaultDock);
  PanelEscenario := TPanelEscenario.Create(Self);
  if fSCMain.Grafico.Tipo <> tgbEscenario then
    fSCMain.Grafico.Tipo := tgbEscenario;
  GraficoEscenario := fSCMain.Grafico.GetGrafico as TGraficoEscenario;
end;

procedure TfrEscenario.dsCambiosDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  NumSesionEscenario.Caption := IntToStr(PanelEscenario.Posicion + 1);
end;

class function TfrEscenario.GetNombre: string;
begin
  result := NOMBRE;
end;

class function TfrEscenario.GetVisiblePorDefecto: boolean;
begin
  result := false;
end;

procedure TfrEscenario.SetEscenario(const escenario: TEscenario; const Fechas: PArrayDate);
var distanciaMax, distanciaMin, ultimoI: integer;
begin
  if escenario = nil then begin
    MaxEscenario.Caption := '';
    MinEscenario.Caption := '';
    DistanciaMaxEscenario.Caption := '';
    DistanciaMinEscenario.Caption := '';
    Desviacion.Caption := '';
    lSintonizacion.Caption := '';
  end
  else begin
    MaxEscenario.Caption := CurrToStrF(escenario.Max, ffCurrency, CurrencyDecimals);
    MinEscenario.Caption := CurrToStrF(escenario.Min, ffCurrency, CurrencyDecimals);
    distanciaMax := escenario.DistanciaMax;
    distanciaMin := escenario.DistanciaMin;
    DistanciaMaxEscenario.Caption := IntToStr(distanciaMax);
    DistanciaMinEscenario.Caption := IntToStr(distanciaMin);
    Desviacion.Caption := FormatFloat('#0.00', escenario.DesviacionSintonizacion) + '%';
    lSintonizacion.Caption := IntToStr(escenario.Sintonizacion);
    ultimoI := TDatosGraficoEscenario(FGraficoEscenario.Datos).UltimoIData;
    FechaMax.Caption := DateToStr(Fechas^[ultimoI + distanciaMax]);
    FechaMin.Caption := DateToStr(Fechas^[ultimoI + distanciaMin]);
  end;
end;

procedure TfrEscenario.SetEscenarioMultiple(const escenarioMultiple: TEscenarioMultiple);
var nitidezGrafico: currency;
begin
  if escenarioMultiple = nil then begin
    Borrar;
  end
  else begin
    MaxOptimista.Caption := CurrToStrF(escenarioMultiple.MaxOptimista, ffCurrency, CurrencyDecimals);
    MinPesimista.Caption := CurrToStrF(escenarioMultiple.MinPesimista, ffCurrency, CurrencyDecimals);
    MaxProbable.Caption := CurrToStrF(escenarioMultiple.MaxMediaEscenarios, ffCurrency, CurrencyDecimals);
    MinProbable.Caption := CurrToStrF(escenarioMultiple.MinMediaEscenarios, ffCurrency, CurrencyDecimals);
    Plusvalia.Caption := FormatFloat('#0.00', escenarioMultiple.PlusvaliaMaxima) + '%';
    CoeficienteVarMax.Caption := FormatFloat('#0.000', escenarioMultiple.CoeficienteVariacionMax);
    CoeficienteVarMin.Caption := FormatFloat('#0.000', escenarioMultiple.CoeficienteVariacionMin);
    RiesgoMax.Caption := FormatFloat('#0.00', escenarioMultiple.Riesgo) + '%';
    nitidezGrafico := escenarioMultiple.NitidezEscenarios;
    Nitidez.Caption := FormatFloat('#0', abs(nitidezGrafico));
    if nitidezGrafico > 0 then begin
      NitidezArriba.Left := 24;
      NitidezAbajo.Left := 11;
    end
    else begin
      NitidezArriba.Left := 9;
      NitidezAbajo.Left := 25;
    end;
    NitidezAbajo.Visible := true;
    NitidezArriba.Visible := true;
  end;
end;

procedure TfrEscenario.SetGraficoEscenario(const grafico: TGraficoEscenario);
begin
  FGraficoEscenario := grafico;
  SetEscenario(TDatosGraficoEscenario(grafico.Datos).Escenario, grafico.Datos.PFechas);
  SetEscenarioMultiple(TDatosGraficoEscenario(grafico.Datos).EscenarioMultiple);
  PanelEscenario.GraficoEscenario := grafico;
  Cotizaciones.Enabled := true;
end;

initialization
  RegisterPanelClass(TfrEscenario);

end.
