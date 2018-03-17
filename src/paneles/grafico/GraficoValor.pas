unit GraficoValor;

interface

uses IncrustedDatosLineLayer, Grafico, Tipos, IncrustedItems, TB2Item,
  dmGraficoValorLayer;

type
  TGraficoValorThread = class(TGraficoItemThread)
  private
    FPCambios: PArrayValorCambio;
    FDataGraficoValorLayer: TDataGraficoValorLayer;
  protected
    procedure InternalExecute; override;
    property PCambios: PArrayValorCambio read FPCambios write FPCambios;
    property DataGraficoValorLayer: TDataGraficoValorLayer read FDataGraficoValorLayer write FDataGraficoValorLayer;
  end;

  TGraficoValor = class;

  TGraficoValorLayer = class(TGraficoItemLayer)
  public
    constructor Create(Grafico: TGrafico); reintroduce;
  end;

  TGraficoValor = class(TGraficoItem)
  private
    Cambios: ArrayValorCambio;
    Simbolo: string;
    DataGraficoValorLayer: TDataGraficoValorLayer;
  protected
    procedure OnTerminate(Sender: TObject); override;
    function GetLayer: TGraficoItemLayer; override;
    function GetItemThread: TGraficoItemThread; override;
  public
    constructor Create(const Grafico: TGrafico; const itemToNotify: TTBCustomItem;
      const OIDValor: integer); reintroduce;
    destructor Destroy; override;
    procedure Run; override;
  end;

implementation

uses dmDataComun, DatosGrafico, Controls;

resourcestring
  TITLE = 'Gráfico valor';

{ TGraficoValorLayer }

constructor TGraficoValorLayer.Create(Grafico: TGrafico);
begin
  inherited Create(Grafico, true);
end;

{ TGraficoValor }

constructor TGraficoValor.Create(const Grafico: TGrafico;
  const itemToNotify: TTBCustomItem; const OIDValor: integer);
var num: integer;
begin
  inherited Create(Grafico, itemToNotify);
  DataGraficoValorLayer := TDataGraficoValorLayer.Create(nil);
  num := DataGraficoValorLayer.Load(OIDValor);
  SetLength(Cambios, num);
  Simbolo := DataComun.FindValor(OIDValor)^.Simbolo;
end;

destructor TGraficoValor.Destroy;
begin
  if DataGraficoValorLayer <> nil then
    DataGraficoValorLayer.Free;
  inherited;
end;

function TGraficoValor.GetItemThread: TGraficoItemThread;
begin
  result := TGraficoValorThread.Create;
  if DataGraficoValorLayer <> nil then
    TGraficoValorThread(result).DataGraficoValorLayer := DataGraficoValorLayer;
  TGraficoValorThread(result).PCambios := @Cambios;
end;

function TGraficoValor.GetLayer: TGraficoItemLayer;
begin
  result := TGraficoValorLayer.Create(Grafico);
end;

procedure TGraficoValor.OnTerminate(Sender: TObject);
begin
  inherited;
  if DataGraficoValorLayer <> nil then begin
    DataGraficoValorLayer.Free;
    DataGraficoValorLayer := nil;
  end;
end;

procedure TGraficoValor.Run;
begin
  inherited Run(TITLE, Simbolo);
end;

{ TGraficoValorThread }

procedure TGraficoValorThread.InternalExecute;
var i, j, num, numJ: integer;
  fecha: TDate;
begin
  if DataGraficoValorLayer <> nil then
    DataGraficoValorLayer.LoadData(PCambios);
  num := Length(FPFechas^);
  dec(num); //zero based
  j := 0;
  numJ := Length(PCambios^);
  dec(numJ);
  for i := 0 to num do begin
    if Terminated then
      exit;
    fecha := FPFechas^[i];
    while (j < numJ) and (PCambios^[j].Fecha < fecha) do
      inc(j);
    if PCambios^[j].Fecha = fecha then
      FPDatos^[i] := PCambios^[j].Cierre
    else
      FPDatos^[i] := SIN_CAMBIO;
  end;
end;

end.
