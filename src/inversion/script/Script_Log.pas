unit Script_Log;

interface

uses Classes, ScriptObject;

type
  TOnLogEvent = procedure (const msg: string) of object;

  TScriptLog = class(TScriptObject)
  private
    FOnLog: TOnLogEvent;
  protected
    function GetScriptInstance: TScriptObjectInstance; override;
  public
    property OnLog: TOnLogEvent read FOnLog write FOnLog;
  end;

  {$METHODINFO ON}
  TLog = class(TScriptObjectInstance)
    procedure Mensaje(mensaje: string);
  end;
  {$METHODINFO OFF}

implementation

{ TLog }

function TScriptLog.GetScriptInstance: TScriptObjectInstance;
begin
  result := TLog.Create;
end;

{ TLog }

procedure TLog.Mensaje(mensaje: string);
begin
  if Assigned(TScriptLog(FScriptObject).FOnLog) then
    TScriptLog(FScriptObject).FOnLog(mensaje);
end;

end.
