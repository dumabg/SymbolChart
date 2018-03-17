unit frEditorCodigoDatos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frEditorCodigo, ActnList, ImgList, SynEditHighlighter,
  SynHighlighterPas, SynCompletionProposal, TB2Item, SpTBXItem, TB2Dock,
  TB2Toolbar, Buttons, StdCtrls, ExtCtrls, ComCtrls, SynEdit, ScriptEditorCodigoDatos,
  JvGIF, BDConstants, JvExControls, JvLinkLabel;

type
  TfEditorCodigoDatos = class(TfEditorCodigo)
    Image1: TImage;
    lInfoVariable: TJvLinkLabel;
    pAyuda: TPanel;
  private
    ScriptDatos: TScriptEditorCodigoDatos;
    function GetOutVariableName: string;
    procedure SetOutVariableName(const Value: string);
    function GetOutVariableType: TResultType;
    procedure SetOutVariableType(const Value: TResultType);
  protected
  public
    destructor Destroy; override;
    procedure InitializeScriptEngine(const verticalCache: boolean);
    property OutVariableName: string read GetOutVariableName write SetOutVariableName;
    property OutVariableType: TResultType read GetOutVariableType write SetOutVariableType;
  end;


implementation

{$R *.dfm}

{ TfEditorCodigoDatos }

destructor TfEditorCodigoDatos.Destroy;
begin
  ScriptDatos.Free;
  inherited;
end;

function TfEditorCodigoDatos.GetOutVariableName: string;
begin
  result := ScriptDatos.OutVariableName;
end;

function TfEditorCodigoDatos.GetOutVariableType: TResultType;
begin
  result := ScriptDatos.ResultType;
end;

procedure TfEditorCodigoDatos.InitializeScriptEngine(
  const verticalCache: boolean);
begin
  ScriptDatos := TScriptEditorCodigoDatos.Create(verticalCache);
  ScriptEngine := ScriptDatos;
end;

procedure TfEditorCodigoDatos.SetOutVariableName(const Value: string);
begin
  ScriptDatos.OutVariableName := Value;
  lInfoVariable.UpdateDynamicTag(0, Value);
end;

procedure TfEditorCodigoDatos.SetOutVariableType(const Value: TResultType);
begin
  ScriptDatos.ResultType := Value;
  lInfoVariable.UpdateDynamicTag(1, GetResultTypeString(Value));
end;

end.
