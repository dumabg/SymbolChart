unit IncrustedItems;

interface

uses Graphics, GR32, IncrustedDatosLineLayer, dmTareas, Tipos, Grafico, TB2Item;

type
  TGraficoItem = class;

  TGraficoItemLayer = class(TIncrustedDatosLineLayer)
  private
    FGraficoItem: TGraficoItem;
    FOnDestroyLayer: TNotificacion;
    FCalculating: boolean;
    // Cuando se sale del programa el grafico hace free de todas las incrusted layers.
    // Posteriormente, se hace free del uPanelGrafico, que contiene los apuntadores
    // a TGraficoOscilador. Como TGraficoOscilador también tiene un apuntador al
    // Layer y hace free, se produce un access violation. Para remediarlo, se pone
    // un evento en el Destroy que coge TGraficoOsiclador, poniendo su apuntador del Layer a nil.
    property OnDestroyLayer: TNotificacion read FOnDestroyLayer write FOnDestroyLayer;
  protected
    procedure OnGraficoDataChanged; override;
    procedure OnBeforeGraficoDataChange; override;
    procedure Recalculate(const fromPos, toPos: integer); override;
    procedure RecalculateTransformados(const fromPos, toPos: integer); override;
    property Calculating: boolean read FCalculating write FCalculating;
  public
    destructor Destroy; override;
  end;

  TGraficoItemThread = class(TTarea)
  protected
    FDataNull: integer;
    FPCierres: PArrayCurrency;
    FPFechas: PArrayDate;
    FPDatos: PArrayCurrency;
  public
    procedure Restart; virtual;
    property DataNull: integer read FDataNull write FDataNull;
    property PFechas: PArrayDate read FPFechas write FPFechas;
    property PCierres: PArrayCurrency read FPCierres write FPCierres;
    property PDatos: PArrayCurrency read FPDatos write FPDatos;
  end;

  TOnCalculated = procedure (Sender: TGraficoItem; itemToNotify: TTBCustomItem;
    stopped: boolean) of object;

  TGraficoItem = class
  private
    InternalLayer: TGraficoItemLayer;
    FVisible: boolean;
    FColor: TColor32;
    FDatos: TArrayCurrency;
    FOnCalculated: TOnCalculated;
    FCalculated: boolean;
    FItemImageIndexCalculating: integer;
    function GetColor: TColor;
    procedure SetColor(const Value: TColor);
    procedure SetVisible(const Value: boolean);
    procedure OnLayerDestroyed;
    function GetDatos: PArrayCurrency;
  protected
    Grafico: TGrafico;
    itemToNotify: TTBCustomItem;
    thread: TGraficoItemThread;
    Layer: TGraficoItemLayer;
    procedure InitializeDatosThread; virtual;
    procedure OnBeforeGraficoDataChange; virtual;
    procedure OnGraficoDataChanged; virtual;
    procedure OnTerminate(Sender: TObject); virtual;
    function GetLayer: TGraficoItemLayer; virtual; abstract;
    function GetItemThread: TGraficoItemThread; virtual; abstract;
    procedure DestroyThread;
    procedure Run(const title, desc: string); overload;
  public
    constructor Create(const Grafico: TGrafico; const itemToNotify: TTBCustomItem);
    destructor Destroy; override;
    procedure Cancel;
    procedure Run; overload; virtual; abstract;
    property PDatos: PArrayCurrency read GetDatos;
    property Color: TColor read GetColor write SetColor;
    property Visible: boolean read FVisible write SetVisible;
    property Calculated: boolean read FCalculated;
    property OnCalculated: TOnCalculated read FOnCalculated write FOnCalculated;
    property ItemImageIndexCalculating: integer read FItemImageIndexCalculating write FItemImageIndexCalculating;
  end;


implementation

{ TGraficoItem }

procedure TGraficoItem.Cancel;
begin
  DestroyThread;
  if Layer <> nil then begin
    Layer.OnDestroyLayer := nil;
    Layer.Free;
  end;
end;

constructor TGraficoItem.Create(const Grafico: TGrafico; const itemToNotify: TTBCustomItem);
begin
  FCalculated := false;
  Self.Grafico := Grafico;
  Self.itemToNotify := itemToNotify;
end;

destructor TGraficoItem.Destroy;
begin
  Cancel;
  inherited;
end;

procedure TGraficoItem.DestroyThread;
begin
  if thread <> nil then begin
    thread.Suspend;
    thread.OnTerminate := nil;
    thread.FreeOnTerminate := true;
    thread.Cancel;
    thread.Resume;
    thread := nil;
  end;
end;

function TGraficoItem.GetColor: TColor;
begin
  result := WinColor(FColor);
end;

function TGraficoItem.GetDatos: PArrayCurrency;
begin
  result := @FDatos;
end;

procedure TGraficoItem.InitializeDatosThread;
var PFechas: PArrayDate;
begin
  PFechas := Grafico.Datos.PFechas;
  SetLength(FDatos, Length(PFechas^));
  thread.PFechas := PFechas;
  thread.PCierres := Grafico.Datos.PCambios;
  thread.DataNull := Grafico.Datos.DataNull;
  thread.PDatos := @FDatos;
end;

procedure TGraficoItem.OnBeforeGraficoDataChange;
begin
  if thread <> nil then
    thread.Suspend;
end;

procedure TGraficoItem.OnGraficoDataChanged;
begin
  if thread = nil then begin
    Run;
  end
  else begin
    if (thread.ExecuteTerminated) then begin
      if thread.Suspended then begin //Dejamos acabar el anterior thread
        thread.OnTerminate := nil;
        while thread.Suspended do
          thread.Resume;
      end;
      Run;
    end
    else begin
      if InternalLayer <> nil then begin
        Layer := InternalLayer;
        Layer.DatosLayer.Clear;
        Layer.SetVisibleWithoutUpdate(false);
      end;
      InitializeDatosThread;
      thread.Restart;
      while thread.Suspended do
        thread.Resume;
    end;
  end;
  Grafico.Update;
end;

procedure TGraficoItem.OnLayerDestroyed;
begin
  Layer := nil;
end;

procedure TGraficoItem.OnTerminate(Sender: TObject);
var canceled: boolean;
begin
  canceled := thread.Canceled;
  if not canceled then begin
    Layer.PDatosLayer := PDatos;
    Layer.Calculating := false;
    Layer.Recalculate;
    Layer.Color := FColor;
    Layer.Visible := FVisible;
  end;
  // MUY IMPORTANTE!! Poner el thread a nil antes de lanzar el evento, ya que
  // en el oscilador se mira si hay thread o no para hacer Free y ya estamos
  // dentro del Free, por lo que se produciría un access violation.
  thread := nil;
  FCalculated := true;
  if Assigned(FOnCalculated) then
    FOnCalculated(Self, itemToNotify, canceled);
  Grafico.InvalidateGrafico;
end;

procedure TGraficoItem.Run(const title, desc: string);
begin
  FCalculated := false;
  itemToNotify.ImageIndex := FItemImageIndexCalculating;
  if InternalLayer <> nil then
    Layer := InternalLayer
  else begin
    Layer := GetLayer;
    Layer.FGraficoItem := Self;
    Layer.OnDestroyLayer := OnLayerDestroyed;
    InternalLayer := Layer;
  end;
  Layer.DatosLayer.Clear;
  Layer.SetVisibleWithoutUpdate(false);
  Layer.Calculating := true;
  thread := GetItemThread;
  thread.OnTerminate := OnTerminate;
  thread.FreeOnTerminate := true;
  InitializeDatosThread;
  Tareas.EjecutarTarea(thread, title, desc);
end;

procedure TGraficoItem.SetColor(const Value: TColor);
begin
  FColor := Color32(Value);
  if Layer <> nil then begin
    Layer.Color := FColor;
    Layer.Update;
  end;
end;

procedure TGraficoItem.SetVisible(const Value: boolean);
begin
  FVisible := Value;
  if Layer <> nil then begin
    Layer.Visible := FVisible;
    Layer.Update;
  end;
end;

{ TGraficoItemLayer }

destructor TGraficoItemLayer.Destroy;
begin
  if Assigned(FOnDestroyLayer) then
    FOnDestroyLayer;
  inherited;
end;

procedure TGraficoItemLayer.OnBeforeGraficoDataChange;
begin
  FGraficoItem.OnBeforeGraficoDataChange;
end;

procedure TGraficoItemLayer.OnGraficoDataChanged;
begin
  FGraficoItem.OnGraficoDataChanged;
end;

procedure TGraficoItemLayer.Recalculate(const fromPos, toPos: integer);
begin
  if not FCalculating then
    inherited;
end;

procedure TGraficoItemLayer.RecalculateTransformados(const fromPos,
  toPos: integer);
begin
  if not FCalculating then
    inherited;
end;

{ TGraficoItemThread }

procedure TGraficoItemThread.Restart;
begin
end;


end.
