unit ScriptObject;

interface

uses
  SysUtils, Classes, dmThreadDataModule;

type
  TScriptObjectClass = class of TScriptObject;

  TScriptObjectInstance = class;

  TScriptObject = class(TPersistent)
  protected
    FScriptInstance: TScriptObjectInstance;
    function GetScriptInstance: TScriptObjectInstance; virtual; abstract;
  public
    destructor Destroy; override;
    procedure AfterConstruction; override;
    property ScriptInstance: TScriptObjectInstance read FScriptInstance;
  end;

  // Todos los métodos public y published declarados serán mostrados en el GetFunctionProposal
  {$M+}
  {$METHODINFO ON}
  TScriptObjectInstance = class(TObject)
  protected
    FScriptObject: TScriptObject;
  end;
  {$METHODINFO OFF}
  {$M-}

implementation

{ TScriptObject }

procedure TScriptObject.AfterConstruction;
begin
  inherited;
  FScriptInstance := GetScriptInstance;
  FScriptInstance.FScriptObject := Self;
end;

destructor TScriptObject.Destroy;
begin
  FScriptInstance.Free;
  inherited Destroy;
end;

end.
