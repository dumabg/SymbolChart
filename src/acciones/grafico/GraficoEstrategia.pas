unit GraficoEstrategia;

interface

uses IncrustedDatosLineLayer, Grafico, Tipos, IncrustedItems, TB2Item, dataPanelEstrategia;

type
  TTipoGraficoEstrategia = (tgeLAL, tgeLAC, tgeA11, tgePRUA, tgeA);

  TGraficoEstrategiaThread = class(TGraficoItemThread)
  private
    tipoGrafico: TTipoGraficoEstrategia;
    tipoGraficoA: integer;
    dataPanelEstrategia: TPanelEstrategia;
  protected
    procedure InternalExecute; override;
  end;

  TGraficoEstrategiaLayer = class(TGraficoItemLayer)
  protected
     procedure OnGraficoDataChanged; override;
     procedure Recalculate(const fromPos, toPos: integer); override;
  public
    constructor Create(Grafico: TGrafico); reintroduce;
  end;

  TGraficoEstrategia = class(TGraficoItem)
  private
    tipoGrafico: TTipoGraficoEstrategia;
    tipoGraficoA: integer;
    dataPanelEstrategia: TPanelEstrategia;
  protected
    function GetLayer: TGraficoItemLayer; override;
    function GetItemThread: TGraficoItemThread; override;
  public
    constructor Create(const Grafico: TGrafico; const itemToNotify: TTBCustomItem;
      const dataPanelEstrategia: TPanelEstrategia;
      const tipoGrafico: TTipoGraficoEstrategia; const tipoGraficoA: integer = -1); reintroduce;
    procedure Run; override;
    property item: TTBCustomItem read itemToNotify;
  end;

implementation

uses dmDataComun, DatosGrafico, Controls, SysUtils;


resourcestring
  TITLE = 'Gráfico estrategia';

{ TGraficoEstrategiaLayer }

constructor TGraficoEstrategiaLayer.Create(Grafico: TGrafico);
begin
  inherited Create(Grafico, true);
end;

procedure TGraficoEstrategiaLayer.OnGraficoDataChanged;
begin
  //No hacemos nada, ya que tiene que repintar después de recalcular todo,
  //no cuando se cambia a un nuevo valor.
end;

procedure TGraficoEstrategiaLayer.Recalculate(const fromPos, toPos: integer);
begin
  DatosLayer.MaximoManual := Grafico.Datos.Maximo;
  DatosLayer.MinimoManual := Grafico.Datos.Minimo;
  inherited Recalculate(fromPos, toPos);
end;

{ TGraficoEstrategia }

constructor TGraficoEstrategia.Create(const Grafico: TGrafico;
  const itemToNotify: TTBCustomItem; const dataPanelEstrategia: TPanelEstrategia;
  const tipoGrafico: TTipoGraficoEstrategia; const tipoGraficoA: integer);
begin
  inherited Create(Grafico, itemToNotify);
  Self.tipoGrafico := tipoGrafico;
  Self.dataPanelEstrategia := dataPanelEstrategia;
  Self.tipoGraficoA := tipoGraficoA;
end;


function TGraficoEstrategia.GetItemThread: TGraficoItemThread;
begin
  result := TGraficoEstrategiaThread.Create;
  TGraficoEstrategiaThread(result).tipoGrafico := tipoGrafico;
  TGraficoEstrategiaThread(result).tipoGraficoA := tipoGraficoA;
  TGraficoEstrategiaThread(result).dataPanelEstrategia := dataPanelEstrategia;
end;

function TGraficoEstrategia.GetLayer: TGraficoItemLayer;
begin
  result := TGraficoEstrategiaLayer.Create(Grafico);
end;

procedure TGraficoEstrategia.Run;
var tipo: string;
begin
  case tipoGrafico of
    tgeLAL: tipo := 'LAL';
    tgeLAC: tipo := 'LAC';
    tgeA11: tipo := 'A11';
    tgePRUA: tipo := 'PRUA';
    tgeA: tipo := 'A' + IntToStr(tipoGraficoA);
  end;
  inherited Run(TITLE, tipo);
end;

{ TGraficoEstrategiaThread }

procedure TGraficoEstrategiaThread.InternalExecute;
var i, num: integer;
  fecha: TDate;
  reglaResult: TReglaResult;
begin
  num := Length(FPFechas^);
  dec(num); //zero based
  for i := 0 to num do begin
    if Terminated then
      exit;
    fecha := FPFechas^[i];
    if (fecha = SIN_FECHA) or (FPCierres^[i] = FDataNull) then begin
      FPDatos^[i] := SIN_CAMBIO;
    end
    else begin
      reglaResult := dataPanelEstrategia.ReglaResult[i];
      case tipoGrafico of
        tgeLAL: FPDatos^[i] := reglaResult.LAL;
        tgeLAC: FPDatos^[i] := reglaResult.LAC;
        tgeA11: FPDatos^[i] := reglaResult.A11;
        tgePRUA: FPDatos^[i] := reglaResult.PRUA;
        tgeA: FPDatos^[i] := reglaResult.A[tipoGraficoA];
      end;
    end;
  end;
end;

end.
