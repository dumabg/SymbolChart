unit ScriptExpressionEngine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ScriptEngine, uPSComponent;

type
  TScriptExpressionEngine = class(TScriptEngine)
  private
    oldOnCompile: TPSEvent;
    procedure PSScriptCompile(Sender: TPSScript);
    function GetCurrencyResult: currency;
  protected
    function GetExpression: string;
    procedure SetExpression(const Value: string); virtual;
  public
    constructor Create; override;
    property CurrencyResult: currency read GetCurrencyResult;
    property Expression: string read GetExpression write SetExpression;
  end;

implementation

uses uPSRuntime;

const SCRIPT_RESULT = '__RESULT';

{ TScriptExpressionEngine }

constructor TScriptExpressionEngine.Create;
begin
  inherited;
  oldOnCompile := PSScript.OnCompile;
  PSScript.OnCompile := PSScriptCompile;
end;

function TScriptExpressionEngine.GetCurrencyResult: currency;
begin
  result := VGetCurrency(PSScript.GetVariable(SCRIPT_RESULT));
end;

function TScriptExpressionEngine.GetExpression: string;
begin
  result := PSScript.Script.Text;
end;

procedure TScriptExpressionEngine.PSScriptCompile(Sender: TPSScript);
begin
  inherited;
  PSScript.AddRegisteredVariable(SCRIPT_RESULT, 'currency');
  if Assigned(oldOnCompile) then
    oldOnCompile(Sender);
end;

procedure TScriptExpressionEngine.SetExpression(const Value: string);
begin
  PSScript.Script.Clear;
  PSScript.Script.Add('begin');
  PSScript.Script.Add(SCRIPT_RESULT + ':=' + Value + ';');
  PSScript.Script.Add('end.');
end;

end.
