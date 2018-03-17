unit ScriptEngine;

interface

uses
  SysUtils, Classes, uPSComponent, uPSRuntime, upSUtils, ScriptObject,
  dmThreadDataModule, Contnrs;


type
  EScriptEngine = class(Exception);

  EStopScript = class(EScriptEngine);

  TPSPluginClass = class of TPSPlugin;

  TScriptEngine = class(TObject)
  private
    FCode, FCompiledCode: string;
    Compiled, LoadedCompiledCode: boolean;
    FMessages: TStrings;
    FRootObjects, FFunctions: TStringList;
    oldOnCompile, oldOnExecute: TPSEvent;
    FStopped: boolean;
    plugins: TObjectList;
    function GetCode: string;
    function GetCol(i: integer): integer;
    function GetRow(i: integer): integer;
    function GetExecuteErrorMsg: string;
    function GetExecuteErrorCol: integer;
    function GetExecuteErrorRow: integer;
    function GetExecuteErrorPosition: integer;
    function GetHasExceptionError: boolean;
    function GetExceptionMsg: string;
    function GetExceptionObj: string;
    function GetCompiledCode: string;
    procedure SetCompiledCode(const Value: string);
    procedure OnAfterExecuteStop(Sender: TPSScript);
  protected
    PSScript: TPSScriptDebugger;
    procedure OnExecute(Sender: TPSScript); virtual;
    procedure OnCompile(Sender: TPSScript); virtual;
    procedure SetCode(const Value: string); virtual;
    procedure RegisterPlugin(const pluginClass: TPSPluginClass; const scriptClass: TScriptObjectClass);
    procedure RegisterFunction(Ptr: Pointer; const Decl: string);
    procedure RegisterScriptRootClass(const name: string; const scriptObject: TScriptObject);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure ReloadCode;
    procedure RaiseException;
    procedure Stop;
    function Compile: boolean; virtual;
    function Execute: boolean; virtual;
    function GetVariableBoolean(const varName: string): boolean;
    function GetVariableString(const varName: string): string;
    function GetVariableCurrency(const varName: string): currency;
    function GetVariableInteger(const varName: string): integer;
    function IsCompiled: boolean;
    function IsLoadedCompiledCode: Boolean;
    property ExecuteErrorMsg: string read GetExecuteErrorMsg;
    property ExecuteErrorCol: integer read GetExecuteErrorCol;
    property ExecuteErrorRow: integer read GetExecuteErrorRow;
    property ExecuteErrorPosition: integer read GetExecuteErrorPosition;
    property CompiledCode: string read GetCompiledCode write SetCompiledCode;
    property Code: string read GetCode write SetCode;
    property Messages: TStrings read FMessages;
    property ColMessage[i: integer]: integer read GetCol;
    property RowMessage[i: integer]: integer read GetRow;
    property HasExceptionError: boolean read GetHasExceptionError;
    property ExceptionMsg: string read GetExceptionMsg;
    property ExceptionObj: string read GetExceptionObj;
    property RootObjects: TStringList read FRootObjects;
    property Functions: TStringList read FFunctions;
    property Stopped: boolean read FStopped;
  end;


implementation

uses UtilException;

var
   FHasExceptionError: boolean;
   FExceptionMsg: string;
   FExceptionObj: string;
   FExceptionStack: string;

procedure OnException(Sender: TPSExec; ExError: TPSError; const ExParam: tbtstring;
      ExObject: TObject; ProcNo, Position: Cardinal);
begin
  FHasExceptionError := ExError = erException;
  if FHasExceptionError then begin
    FExceptionObj := ExObject.ClassName;
    FExceptionMsg := ExParam;
    FExceptionStack := GetStackTraceString;
  end;
end;

{ TScriptEngine }

function TScriptEngine.Compile: boolean;
var i: integer;
begin
  Messages.Clear;
  if Code = '' then
    Compiled := true
  else begin
    Compiled := PSScript.Compile;
    for i := 0 to PSScript.CompilerMessageCount -1 do begin
      Messages.Add(PSScript.CompilerMessages[i].MessageToString);
    end;
    if Compiled then begin
      LoadedCompiledCode := false;
      FCompiledCode := CompiledCode;
    end;
  end;
  result := Compiled;
end;

constructor TScriptEngine.Create;
begin
  inherited;
  PSScript := TPSScriptDebugger.Create(nil);
  plugins := TObjectList.Create(true);
  FRootObjects := TStringList.Create;
  FFunctions := TStringList.Create;
  FMessages := TStringList.Create;
  PSScript.Exec.OnException := OnException;
  oldOnCompile := PSScript.OnCompile;
  PSScript.OnCompile := OnCompile;
  oldOnExecute := PSScript.OnExecute;
  PSScript.OnExecute := OnExecute;
  Compiled := false;
end;

destructor TScriptEngine.Destroy;
begin
  plugins.Free;
  FFunctions.Free;
  FMessages.Free;
  FRootObjects.Free;
  PSScript.Free;  
  inherited;
end;

function TScriptEngine.Execute: boolean;
begin
  FStopped := false;
  FHasExceptionError := false;
  FExceptionMsg := '';
  FExceptionObj := '';
  if LoadedCompiledCode then
    PSScript.SetCompiled(CompiledCode)
  else
    PSScript.Compile;
  result := PSScript.Execute;
  if FStopped then
    raise EStopScript.Create('');
end;

function TScriptEngine.GetCode: string;
begin
  result := PSScript.Script.Text;
end;

function TScriptEngine.GetCol(i: integer): integer;
begin
  result := PSScript.CompilerMessages[i].Col;
end;

function TScriptEngine.GetCompiledCode: string;
begin
  result := FCompiledCode;
  if result = '' then begin
    PSScript.GetCompiled(result);
    if result <> '' then
      FCompiledCode := result;
  end;
end;

function TScriptEngine.GetExceptionMsg: string;
begin
  result := FExceptionMsg;
end;

function TScriptEngine.GetExceptionObj: string;
begin
  result := FExceptionObj;
end;

function TScriptEngine.GetExecuteErrorCol: integer;
begin
  result := PSSCript.ExecErrorCol;
end;

function TScriptEngine.GetExecuteErrorMsg: string;
begin
  result := PSScript.ExecErrorToString;
end;

function TScriptEngine.GetExecuteErrorPosition: integer;
begin
  result := PSScript.ExecErrorPosition;
end;

function TScriptEngine.GetExecuteErrorRow: integer;
begin
  result := PSSCript.ExecErrorRow;
end;

function TScriptEngine.GetHasExceptionError: boolean;
begin
  result := FHasExceptionError;
end;

function TScriptEngine.GetRow(i: integer): integer;
begin
  result := PSScript.CompilerMessages[i].Row;
end;

function TScriptEngine.GetVariableBoolean(const varName: string): boolean;
begin
  result := VGetUInt(PSScript.GetVariable(varName)) <> 0;
end;

function TScriptEngine.GetVariableCurrency(const varName: string): currency;
begin
  result := VGetCurrency(PSScript.GetVariable(varName));
end;

function TScriptEngine.GetVariableInteger(const varName: string): integer;
begin
  result := VGetInt(PSScript.GetVariable(varName));
end;

function TScriptEngine.GetVariableString(const varName: string): string;
begin
  result := VGetString(PSScript.GetVariable(varName));
end;

function TScriptEngine.IsCompiled: boolean;
begin
  result := Compiled;
end;

function TScriptEngine.IsLoadedCompiledCode: Boolean;
begin
  result := LoadedCompiledCode;
end;

procedure TScriptEngine.OnAfterExecuteStop(Sender: TPSScript);
begin
  // Si se llama a Stop, para detener el script la única manera de hacerlo
  // es en el evento OnRunLine llamar contínuamente a Stop. Cuando acaba el
  // script debemos quitar el evento, sino si se ejecuta otro script estaría
  // asignado el evento y solo empezar pararía
  Sender.Exec.OnRunLine := nil;
  PSScript.OnAfterExecute := nil;
end;

procedure TScriptEngine.OnCompile(Sender: TPSScript);
var i: integer;
  obj: TScriptObject;
begin
  for i := 0 to rootObjects.Count - 1 do begin
    obj := rootObjects.Objects[i] as TScriptObject;
    Sender.AddRegisteredVariable(rootObjects[i], obj.ScriptInstance.ClassName);
  end;
  for i := 0 to Functions.Count - 1 do begin
    Sender.AddFunction(Pointer(Functions.Objects[i]), Functions[i]);
  end;
  if Assigned(oldOnCompile) then
    oldOnCompile(Sender);
end;

procedure TScriptEngine.OnExecute(Sender: TPSScript);
var i: integer;
  obj: TScriptObject;
begin
  for i := 0 to rootObjects.Count - 1 do begin
    obj := rootObjects.Objects[i] as TScriptObject;
    Sender.SetVarToInstance(rootObjects[i], obj.ScriptInstance);
  end;
  if Assigned(oldOnExecute) then
    oldOnExecute(Sender);
end;

procedure TScriptEngine.RaiseException;
begin
  if FHasExceptionError then
    raise EScriptEngine.Create(FExceptionObj + ':' + sLineBreak +
      FExceptionMsg + sLineBreak + FExceptionStack);
end;

procedure TScriptEngine.RegisterFunction(Ptr: Pointer; const Decl: string);
begin
  Functions.AddObject(Decl, Ptr);
end;

procedure TScriptEngine.RegisterPlugin(const pluginClass: TPSPluginClass;
  const scriptClass: TScriptObjectClass);
var plugin: TPSPlugin;
begin
  plugin := pluginClass.Create(nil);
  plugins.Add(plugin);
  TPSPluginItem(PSScript.Plugins.Add).Plugin := plugin;
  RegisterClass(scriptClass);
end;

procedure TScriptEngine.RegisterScriptRootClass(const name: string;
  const scriptObject: TScriptObject);
begin
  FRootObjects.AddObject(name, scriptObject);
end;

procedure TScriptEngine.ReloadCode;
begin
  SetCode(FCode);
end;

procedure TScriptEngine.SetCode(const Value: string);
begin
  FCode := Value;
  PSScript.Script.Text := Value;
  Compiled := false;
end;

procedure TScriptEngine.SetCompiledCode(const Value: string);
begin
  FCompiledCode := Value;
  LoadedCompiledCode := Value <> '';
  if LoadedCompiledCode then
    PSScript.SetCompiled(Value);
end;

procedure OnRunLine(Sender: TPSExec);
begin
  Sender.Stop;
end;

procedure TScriptEngine.Stop;
begin
  FStopped := true;
  if PSScript.Running then begin
    PSScript.OnAfterExecute := OnAfterExecuteStop;
    // Para detener el script la única manera de hacerlo
    // es en el evento OnRunLine llamar contínuamente a Stop.
    PSScript.Exec.OnRunLine := OnRunLine;
  end;
end;

end.
