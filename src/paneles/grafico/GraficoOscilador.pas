unit GraficoOscilador;

interface

uses Grafico, GR32, Graphics, Tipos, DatosGrafico, UtilThread,
  ScriptEditorCodigoDatos, TB2Item, IncrustedItems, SysUtils;

type
  TGraficoOsciladorLayer = class(TGraficoItemLayer)
  protected
    procedure Recalculate(const fromPos, toPos: integer); override;
  end;

  TGraficoOscilador = class;

  TGraficoOsciladorThread = class(TGraficoItemThread)
  private
    i, num: Integer;
    Script: TScriptEditorCodigoDatos;
    FCompiledCode: string;
    FOIDValor: Integer;
  protected
    procedure InitializeResources; override;
    procedure FreeResources; override;
    procedure InternalExecute; override;
    procedure InternalCancel; override;
    property CompiledCode: string read FCompiledCode write FCompiledCode;
  public
    procedure Restart; override;
    property OIDValor: Integer read FOIDValor write FOIDValor;
  end;

  TOnOsciladorCalculated = procedure (Sender: TGraficoOscilador;
    itemToNotify: TTBCustomItem; stopped: boolean) of object;

  TGraficoOscilador = class(TGraficoItem)
  private
    CompiledCode: string;
  protected
    procedure InitializeDatosThread; override;
    function GetLayer: TGraficoItemLayer; override;
    function GetItemThread: TGraficoItemThread; override;
  public
    constructor Create(const Grafico: TGrafico; const CodigoCompiled: string;
      const itemToNotify: TTBCustomItem); reintroduce;
    procedure Run; override;
  end;

implementation

uses GraficoZoom, fmOsciladores, dmDataComun, ScriptEngine, dmData, Controls,
  UtilException, ScriptDataCache, Script_Datos;

resourcestring
  OSCILADOR_TITLE = 'Gráfico oscilador';

{ TGraficoOsciladorLayer }

procedure TGraficoOsciladorLayer.Recalculate(const fromPos, toPos: integer);
begin
  DatosLayer.MaximoManual := Grafico.Datos.Maximo;
  DatosLayer.MinimoManual := Grafico.Datos.Minimo;
  inherited Recalculate(fromPos, toPos);
end;

{ TGraficoOsciladorThread }

procedure TGraficoOsciladorThread.InternalExecute;
var fecha: TDate;
begin
  Restart;
  Script.CompiledCode := CompiledCode;
  while (not Terminated) and (i <= num) do begin
    DoPerCentPos(i);
    fecha := FPFechas^[i];
    if (fecha = SIN_FECHA) or (FPCierres^[i] = FDataNull) then begin
      FPDatos^[i] := SIN_CAMBIO;
    end
    else begin
      Script.OIDSesion := DataComun.FindOIDSesion(fecha);
      Script.OIDValor := FOIDValor;
      try
        if not Script.Execute then begin
          FPDatos^[i] := SIN_CAMBIO;
          if not Script.EDatoNotFound then
            Script.RaiseException;
        end
        else
          FPDatos^[i] := Script.ValueCurrency;
      except
        on e: EStopScript do begin
          if not Terminated then begin
            FPDatos^[i] := SIN_CAMBIO;
            if not Script.EDatoNotFound then
                Script.CompiledCode := CompiledCode;
          end;
        end;
      end;
    end;
    inc(i);
  end;
end;

procedure TGraficoOsciladorThread.Restart;
begin
  inherited;
  if not IsDestroying then begin
    i := 0;
    num := Length(FPFechas^) - 1;
    MaxPosition := num;
    if Script <> nil then    
      Script.Stop;
  end;
end;

procedure TGraficoOsciladorThread.FreeResources;
begin
  inherited;
  Script.Free;
  Script := nil;
end;

procedure TGraficoOsciladorThread.InitializeResources;
begin
  inherited;
  Script := TScriptEditorCodigoDatos.Create(false);
  Script.OutVariableName := OSCILADOR_OUT_VARIABLE_NAME;
  Script.ResultType := OSCILADOR_OUT_VARIABLE_TYPE;
  Script.CompiledCode := CompiledCode;
end;

procedure TGraficoOsciladorThread.InternalCancel;
begin
  if Script <> nil then
    Script.Stop;
end;

{ TGraficoOscilador }

constructor TGraficoOscilador.Create(const Grafico: TGrafico;
  const CodigoCompiled: string; const itemToNotify: TTBCustomItem);
begin
  inherited Create(Grafico, itemToNotify);
  CompiledCode := CodigoCompiled;
end;

function TGraficoOscilador.GetItemThread: TGraficoItemThread;
begin
  result := TGraficoOsciladorThread.Create;
  TGraficoOsciladorThread(result).CompiledCode := CompiledCode;
end;

function TGraficoOscilador.GetLayer: TGraficoItemLayer;
begin
  Result := TGraficoOsciladorLayer.Create(Grafico, true);
end;

procedure TGraficoOscilador.InitializeDatosThread;
begin
  inherited;
  if thread <> nil then
    TGraficoOsciladorThread(thread).OIDValor := Data.OIDValor;
end;

procedure TGraficoOscilador.Run;
begin
  inherited Run(OSCILADOR_TITLE, itemToNotify.Caption);
end;

end.
