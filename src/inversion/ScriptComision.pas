unit ScriptComision;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ScriptExpressionEngine, uPSComponent;

type
  TScriptComision = class(TScriptExpressionEngine)
  private
    FAccion, FEfectivo: currency;
    oldOnCompile: TPSEvent;
    function TransformarExpresion(const expresion: string): string;
    function Percent(const param1, param2: currency): currency;
    procedure PSScriptCompile(Sender: TPSScript);
    procedure PSScriptExecute(Sender: TPSScript);
  protected
    procedure SetExpression(const Value: string); override;
  public
    constructor Create; override;
    function Evaluate: currency;
    property Accion: currency read FAccion write FAccion;
    property Efectivo: currency read FEfectivo write FEfectivo;
  end;


implementation

uses uPSUtils;

constructor TScriptComision.Create;
begin
  inherited;
  oldOnCompile := PSScript.OnCompile;
  PSScript.OnCompile := PSScriptCompile;
  PSScript.OnExecute := PSScriptExecute;
end;

function TScriptComision.Evaluate: currency;
begin
  if (Compile) and (Execute) then
    result := CurrencyResult
  else
    result := 0;
end;

function TScriptComision.Percent(const param1, param2: currency): currency;
begin
  result := param2 * param1 / 100;
end;

procedure TScriptComision.PSScriptCompile(Sender: TPSScript);
begin
  inherited;
  PSSCript.AddMethod(Self, @TScriptComision.PerCent,
    'function Percent(const param1, param2: currency): currency;');
  PSScript.AddRegisteredPTRVariable('accion', 'currency');
  PSScript.AddRegisteredPTRVariable('efectivo', 'currency');
  if Assigned(oldOnCompile) then
    oldOnCompile(Sender);
end;

procedure TScriptComision.PSScriptExecute(Sender: TPSScript);
begin
  inherited;
  Sender.SetPointerToData('ACCION', @Accion, PSScript.FindBaseType(btCurrency));
  Sender.SetPointerToData('EFECTIVO', @Efectivo, PSScript.FindBaseType(btCurrency));
end;

procedure TScriptComision.SetExpression(const Value: string);
begin
  inherited SetExpression(TransformarExpresion(Value));
end;

function TScriptComision.TransformarExpresion(const expresion: string): string;
var arg1, arg2: string;
  i, j, iArg1: integer;
begin
  // PerCent
  result := LowerCase(expresion);
  i := Pos('%', result);
  if i <> -1 then begin
    j := i  - 1;
    while (j > 0) and (result[j] = ' ') do
      dec(j);
    if j > 0 then begin
      while (j > 0) and (result[j] <> ' ') do
        dec(j);
      iArg1 := j;
      arg1 := Trim(Copy(result, j, i - j - 1));  // -1 del %
      j := i + 1;
      while (j <= length(result)) and (result[j] = ' ') do
        inc(j);
      if j < length(result) then begin
        while (j < length(result)) and (result[j] <> ' ') do
          inc(j);
        arg2 := Trim(Copy(result, i + 1, j - i));
        result := Copy(result, 1, iArg1) + ' PerCent(' + arg1 + ',' + arg2 + ') ' +
          Copy(result, j + 1, length(result));
      end;
    end;
  end;
end;

end.
