unit EscenarioController;

interface

uses Classes, GraficoEscenario, Escenario, Tipos, dmTareas, Windows;

type
  TEscenariosFactory = class(TTarea)
  strict private
    FEscenario: TEscenario;
    FNoEncontrado: boolean;
    FSintonizacion: Integer;
    FDesviacionSintonizacion: Currency;
    FIntentosSintonizacion: Integer;
  private
    FEscenarioMultiple: TEscenarioMultiple;
    Grafico: TGraficoEscenario;
    EscenarioMultipleCreator: TEscenarioMultipleCreator;
    EscenarioCreator: TEscenarioCreator;
    RecalcularEscenarioMultiple: boolean;
  protected
    procedure InternalCancel; override;
    procedure FreeResources; override;
    procedure InitializeResources; override;
  public
    procedure InternalExecute; override;
    property EscenarioMultiple: TEscenarioMultiple read FEscenarioMultiple;
    property Escenario: TEscenario read FEscenario;
    property NoEncontrado: boolean read FNoEncontrado;
    property Sintonizacion: Integer read FSintonizacion write FSintonizacion;
    property IntentosSintonizacion: Integer read FIntentosSintonizacion write FIntentosSintonizacion;
    property DesviacionSintonizacion: Currency read FDesviacionSintonizacion write FDesviacionSintonizacion;
  end;

  TEscenarioController = class
  private
    EscenarioMultipleCreator: TEscenarioMultipleCreator;
    EscenariosFactory: TEscenariosFactory;
    EscenarioMultiple: TEscenarioMultiple;
    Escenario: TEscenario;
    Grafico: TGraficoEscenario;
    FOnTerminate: TNotifyEvent;
    FSintonizacion: integer;
    FDesviacionSintonizacion: currency;
    FIntentosSintonizacion: integer;
    FCanceled: boolean;
    FNoEncontrado: boolean;
    criticalSection: TRTLCriticalSection;
    procedure OnTerminateEscenario;
    procedure OnTerminateEscenarioFactory(Sender: TObject);
    procedure OnConfiguracionEscenariosChanged;
  public
    constructor Create(const Grafico: TGraficoEscenario);
    destructor Destroy; override;
    procedure Crear(recalcularEscenarioMultiple: boolean);
    procedure Cancelar;
    procedure Borrar;
    property Sintonizacion: integer read FSintonizacion write FSintonizacion;
    property IntentosSintonizacion: integer read FIntentosSintonizacion write FIntentosSintonizacion;
    property DesviacionSintonizacion: currency read FDesviacionSintonizacion write FDesviacionSintonizacion;
    property OnTerminate: TNotifyEvent read FOnTerminate write FOnTerminate;
    property Canceled: boolean read FCanceled;
    property NoEncontrado: boolean read FNoEncontrado;
  end;

implementation

uses uPanelEscenario, SysUtils, uAcciones, DatosGrafico, dmConfiguracion,
  dmData, BusCommunication, frModuloEscenarios;

const
  MAX_CAMBIOS_PARA_CREAR_ESCENARIO = 640;

{ TEscenarioController }

procedure TEscenarioController.Borrar;
begin
  FreeAndNil(Escenario);
  FreeAndNil(EscenarioMultiple);
end;

procedure TEscenarioController.Cancelar;
begin
  FCanceled := true;
  if EscenariosFactory <> nil then begin
    EscenariosFactory.OnTerminate := nil;
    EscenariosFactory.Cancel;
  end;
  OnTerminateEscenario;
end;

procedure TEscenarioController.Crear(recalcularEscenarioMultiple: boolean);
begin
  FNoEncontrado := true;
  Grafico.Creando := true;
  FreeAndNil(Escenario);
  if EscenariosFactory = nil then begin
    if recalcularEscenarioMultiple then
      FreeAndNil(EscenarioMultiple);
    FCanceled := False;
    EscenarioMultipleCreator.Initialize;
    EscenariosFactory := TEscenariosFactory.Create;
    EscenariosFactory.SetNilOnFree(@EscenariosFactory);
    EscenariosFactory.FreeOnTerminate := true;
    EscenariosFactory.OnTerminate := OnTerminateEscenarioFactory;
    EscenariosFactory.Grafico := Grafico;
    EscenariosFactory.EscenarioMultipleCreator := EscenarioMultipleCreator;
    EscenariosFactory.FEscenarioMultiple := EscenarioMultiple;
    EscenariosFactory.RecalcularEscenarioMultiple := EscenarioMultiple = nil;
    EscenariosFactory.Sintonizacion := FSintonizacion;
    EscenariosFactory.IntentosSintonizacion := FIntentosSintonizacion;
    EscenariosFactory.DesviacionSintonizacion := FDesviacionSintonizacion;
    Tareas.EjecutarTarea(EscenariosFactory, 'Escenario', 'Creando escenario');
  end
  else begin
    EscenariosFactory.OnTerminate := nil;
    EscenariosFactory.Cancel;
    OnTerminateEscenario;
  end;
end;

constructor TEscenarioController.Create(const Grafico: TGraficoEscenario);
begin
  inherited Create;
  InitializeCriticalSection(criticalSection);
  Self.Grafico := Grafico;
  EscenarioMultiple := nil;
  EscenarioMultipleCreator := TEscenarioMultipleCreator.Create;
  Bus.RegisterEvent(MessageConfiguracionEscenarios, OnConfiguracionEscenariosChanged);
  OnConfiguracionEscenariosChanged;
end;


destructor TEscenarioController.Destroy;
begin
  if Escenario <> nil then
    Escenario.Free;
  EscenarioMultipleCreator.Free;
  if EscenarioMultiple <> nil then
    EscenarioMultiple.Free;
  DeleteCriticalSection(criticalSection);
  inherited;
end;

procedure TEscenarioController.OnConfiguracionEscenariosChanged;
begin
  FSintonizacion := Configuracion.Escenarios.Sintonizacion;
  FIntentosSintonizacion := Configuracion.Escenarios.Intentos;
  if Configuracion.Escenarios.DesviacionAutomatico then begin
    // En el porcentaje de filtro para encontrar los días sincronizados en los escenarios
    // examinar los porcentajes de variabilidad y volatilidad y tomar por defecto EL MENOR DE LOS DOS
    if Data.CotizacionEstadoVARIABILIDAD.Value > Data.CotizacionEstadoVOLATILIDAD.Value then
      FDesviacionSintonizacion :=  Data.CotizacionEstadoVOLATILIDAD.Value
    else
      FDesviacionSintonizacion := Data.CotizacionEstadoVARIABILIDAD.Value;
  end
  else
    FDesviacionSintonizacion := Configuracion.Escenarios.DesviacionPerCent;
end;

procedure TEscenarioController.OnTerminateEscenario;
begin
  EnterCriticalSection(criticalSection);
  try
    Grafico.Creando := false;
    if Assigned(FOnTerminate) then
      FOnTerminate(Self);
  finally
    LeaveCriticalSection(criticalSection);
  end;
end;

procedure TEscenarioController.OnTerminateEscenarioFactory(Sender: TObject);
var factory: TEscenariosFactory;
begin
  factory := Sender as TEscenariosFactory;
  FCanceled := factory.Canceled;
  FNoEncontrado := factory.NoEncontrado;
  EscenarioMultiple := factory.EscenarioMultiple;
  Escenario := factory.Escenario;
  if (not FCanceled) and (not FNoEncontrado) then begin
    TDatosGraficoEscenario(Grafico.Datos).EscenarioMultiple := EscenarioMultiple;
    TDatosGraficoEscenario(Grafico.Datos).Escenario := Escenario;
  end
  else begin
    TDatosGraficoEscenario(Grafico.Datos).EscenarioMultiple := nil;
    TDatosGraficoEscenario(Grafico.Datos).Escenario := nil;
  end;
  OnTerminateEscenario;
end;

{ TEscenarioCreator }

procedure TEscenariosFactory.InternalExecute;
var Cambios: array of currency;
  i, j: integer;
  DatosGrafico: TDatosGrafico;
begin
  i := TDatosGraficoEscenario(Grafico.Datos).UltimoIData;
  j := MAX_CAMBIOS_PARA_CREAR_ESCENARIO;
  SetLength(Cambios, MAX_CAMBIOS_PARA_CREAR_ESCENARIO);
  dec(j); //zero based
  DatosGrafico := Grafico.Datos;
  while (i >= 0) and (j >= 0) do begin
    if DatosGrafico.IsCambio[i] then begin
      Cambios[j] := DatosGrafico.Cambio[i];
      dec(j);
    end;
    dec(i);
  end;
  //Hay menos cambios que MAX_CAMBIOS_PARA_CREAR_ESCENARIO, por lo que se ha de
  //reducir el array para que contenga solo los cambios.
  if j > 0 then begin
    Inc(j);
    for i := j to MAX_CAMBIOS_PARA_CREAR_ESCENARIO - 1 do begin
      Cambios[i - j] := Cambios[i];
    end;
    SetLength(Cambios, MAX_CAMBIOS_PARA_CREAR_ESCENARIO - j);
  end;
  if (RecalcularEscenarioMultiple) or (FEscenarioMultiple = nil) then begin
    EscenarioMultipleCreator.Cambios := @Cambios;
    FreeAndNil(FEscenarioMultiple);
    EscenarioMultipleCreator.CrearEscenarioMultiple;
    FEscenarioMultiple := EscenarioMultipleCreator.EscenarioMultiple;
  end;
  FreeAndNil(FEscenario);
  EscenarioCreator.Cambios := @Cambios;
  EscenarioCreator.CrearEscenario(FEscenarioMultiple);
  FEscenario := EscenarioCreator.Escenario;
  FNoEncontrado := EscenarioCreator.NoEncontrado;
end;

procedure TEscenariosFactory.FreeResources;
begin
  if Canceled or FNoEncontrado then begin
    if FEscenario = nil then begin
      if (EscenarioCreator <> nil) and (EscenarioCreator.Escenario <> nil) then
        EscenarioCreator.Escenario.Free;
    end
    else
      FreeAndNil(FEscenario);
  end;
  EscenarioCreator.Free;
  inherited;
end;

procedure TEscenariosFactory.InitializeResources;
begin
  inherited;
  EscenarioCreator := TEscenarioCreator.Create;
  EscenarioCreator.Sintonizacion := FSintonizacion;
  EscenarioCreator.IntentosSintonizacion := FIntentosSintonizacion;
  EscenarioCreator.DesviacionSintonizacion := FDesviacionSintonizacion;
end;

procedure TEscenariosFactory.InternalCancel;
begin
  inherited;
  EscenarioMultipleCreator.Cancelar;
  EscenarioCreator.Cancelar;
end;

end.
