unit frEditorCodigo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ScriptEngine, Buttons, StdCtrls, ExtCtrls, ComCtrls, SynEdit,
  ImgList, SynEditHighlighter, SynHighlighterPas, SynCompletionProposal, Script,
  ActnList, SpTBXItem, TB2Item, TB2Dock, TB2Toolbar;

type
  TOnAfterCompile = procedure (const ok: boolean) of object;

  TfEditorCodigo = class(TFrame)
    SynCompletionProposalParams: TSynCompletionProposal;
    SynPasSyn: TSynPasSyn;
    SynCompletionProposalCode: TSynCompletionProposal;
    Editor: TSynEdit;
    StatusBar: TStatusBar;
    pInfo: TPanel;
    lbInfo: TListBox;
    pCerrarInfo: TPanel;
    sbCloseInfo: TSpeedButton;
    ToolbarEstrategia: TSpTBXToolbar;
    TBXItem4: TSpTBXItem;
    TBXSeparatorItem2: TSpTBXSeparatorItem;
    ImageList: TImageList;
    ActionListEditor: TActionList;
    aCompilar: TAction;
    pToolbarEditorCodigo: TPanel;
    pEstadoCompilacion: TPanel;
    procedure SynCompletionProposalParamsCancelled(Sender: TObject);
    procedure SynCompletionProposalParamsClose(Sender: TObject);
    procedure SynCompletionProposalParamsExecute(Kind: TSynCompletionType;
      Sender: TObject; var CurrentInput: string; var x, y: Integer;
      var CanExecute: Boolean);
    procedure EditorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SynCompletionProposalCodeExecute(Kind: TSynCompletionType;
      Sender: TObject; var CurrentInput: string; var x, y: Integer;
      var CanExecute: Boolean);
    procedure EditorChange(Sender: TObject);
    procedure EditorStatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure lbInfoClick(Sender: TObject);
    procedure sbCloseInfoClick(Sender: TObject);
    procedure aCompilarExecute(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
  private
    Script: TScript;
    FScriptEngine: TScriptEngine;
    ShowingProposalParams: boolean;
    FOnAfterCompile: TOnAfterCompile;
    procedure ColorIndicadorCompilado;
    function GetCodigo: string;
    procedure SetCodigo(const Value: string);
    function GetCaretY: integer;
    procedure SetCaretY(const Value: integer);
    function GetCaretX: integer;
    procedure SetCaretX(const Value: integer);
    function GetCaretXY: TBufferCoord;
    procedure SetCaretXY(const Value: TBufferCoord);
    procedure SetScriptEngine(const Value: TScriptEngine);
    function GetCodigoCompiled: string;
    procedure SetCodigoCompiled(const Value: string);
  protected
  public
    destructor Destroy; override;
    function Compilar(codigo: string): boolean;
    function IsCompiled: boolean;
    function IsLoadedCompiledCode: Boolean;
    property ScriptEngine: TScriptEngine read FScriptEngine write SetScriptEngine;
    property Codigo: string read GetCodigo write SetCodigo;
    property CodigoCompiled: string read GetCodigoCompiled write SetCodigoCompiled;
    property CaretX: integer read GetCaretX write SetCaretX;
    property CaretY: integer read GetCaretY write SetCaretY;
    property CaretXY: TBufferCoord read GetCaretXY write SetCaretXY;
    property OnAfterCompile: TOnAfterCompile read FOnAfterCompile write FOnAfterCompile;
  end;

implementation

{$R *.dfm}

resourcestring
  CORRECTO = 'Correcto';
  ERROR = 'Error';
  MODIFICADO = 'Modificado';
  SOBREESCRIBIR = 'Sobreescribir';
  INSERTAR = 'Insertar';
  SOLO_LECTURA = 'Sólo lectura';

const
  INDEX_PANEL_COMPILACION = 3;
  COLOR_COMPILADO = $00E6FFE6;
  COLOR_NO_COMPILADO = $00DFDFFF;

procedure TfEditorCodigo.ColorIndicadorCompilado;
begin
  if IsLoadedCompiledCode or IsCompiled then
    pEstadoCompilacion.Color := COLOR_COMPILADO
  else
    pEstadoCompilacion.Color := COLOR_NO_COMPILADO;
end;

function TfEditorCodigo.Compilar(codigo: string): boolean;
begin
  codigo := Trim(codigo);
  if codigo <> '' then begin
    pInfo.Visible := false;
    FScriptEngine.Code := codigo;
    result := FScriptEngine.Compile;
    if result then begin
      StatusBar.Panels[INDEX_PANEL_COMPILACION].Text := CORRECTO;
    end
    else begin
      pInfo.Visible := true;
      lbInfo.Items.Assign(FScriptEngine.Messages);
      StatusBar.Panels[INDEX_PANEL_COMPILACION].Text := ERROR;
    end;
    Editor.Modified := false;
  end
  else
    Result := false;
end;

procedure TfEditorCodigo.aCompilarExecute(Sender: TObject);
var ok: boolean;
begin
  ok := Compilar(Editor.Text);
  ColorIndicadorCompilado;
  if Assigned(FOnAfterCompile) then
    FOnAfterCompile(ok);
end;

destructor TfEditorCodigo.Destroy;
begin
  Script.Free;
  inherited;
end;

procedure TfEditorCodigo.EditorChange(Sender: TObject);
begin
  Editor.Modified := true;
end;

procedure TfEditorCodigo.EditorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) and (ShowingProposalParams) then begin
    Key := 0;
    SynCompletionProposalParams.CancelCompletion;
  end
  else
    inherited;
end;

procedure TfEditorCodigo.EditorStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);

    procedure Posicion;
    begin
      StatusBar.Panels[0].Text := IntToStr(Editor.CaretY) + ':' + IntToStr(Editor.CaretX);
    end;

    procedure InsertMode;
    begin
      if Editor.InsertMode then
        StatusBar.Panels[2].Text := INSERTAR
      else
        StatusBar.Panels[2].Text := SOBREESCRIBIR;
    end;

    procedure Modified;
    begin
      if Editor.Modified then begin
        //Inicializamos el scriptengine sin código, para que desmarque el flag
        // de IsCompiled. Cuando se pulse compilar ya se asignará el código final
        FScriptEngine.Code := '';
        CodigoCompiled := '';
        StatusBar.Panels[INDEX_PANEL_COMPILACION].Text := '';
        StatusBar.Panels[1].Text := MODIFICADO;
        ColorIndicadorCompilado;
      end
      else
        StatusBar.Panels[1].Text := '';
    end;

    procedure ReadOnly;
    begin
      if Editor.ReadOnly then
        StatusBar.Panels[2].Text := SOLO_LECTURA
      else
        InsertMode;
    end;
begin
  if scAll in Changes then begin
      Posicion;
      Modified;
      ReadOnly;
  end
  else begin
    if (scCaretX in Changes) or (scCaretY in Changes) or (scLeftChar in Changes)
      or (scTopLine in Changes) then Posicion;
    if scInsertMode in Changes then InsertMode;
    if scModified in Changes then Modified;
    if scReadOnly in Changes then ReadOnly;
  end;
end;

function TfEditorCodigo.GetCaretX: integer;
begin
  result := Editor.CaretX;
end;

function TfEditorCodigo.GetCaretXY: TBufferCoord;
begin
  result := Editor.CaretXY;
end;

function TfEditorCodigo.GetCaretY: integer;
begin
  result := Editor.CaretY;
end;

function TfEditorCodigo.GetCodigo: string;
begin
  result := Editor.Text;
end;

function TfEditorCodigo.GetCodigoCompiled: string;
begin
  Result := ScriptEngine.CompiledCode;
end;

function TfEditorCodigo.IsCompiled: boolean;
begin
  Result := ScriptEngine.IsCompiled;
end;

function TfEditorCodigo.IsLoadedCompiledCode: Boolean;
begin
  result := ScriptEngine.IsLoadedCompiledCode;
end;

procedure TfEditorCodigo.lbInfoClick(Sender: TObject);
var i: integer;
begin
  inherited;
  i := lbInfo.ItemIndex;
  if i <> -1 then begin
    Editor.CaretX := FScriptEngine.ColMessage[i];
    Editor.CaretY := FScriptEngine.RowMessage[i];
  end;
  Editor.SetFocus;
end;

procedure TfEditorCodigo.sbCloseInfoClick(Sender: TObject);
begin
  pInfo.Visible := false;
end;

procedure TfEditorCodigo.SetCaretX(const Value: integer);
begin
  Editor.CaretX := Value;
end;

procedure TfEditorCodigo.SetCaretXY(const Value: TBufferCoord);
begin
  Editor.CaretXY := Value;
end;

procedure TfEditorCodigo.SetCaretY(const Value: integer);
begin
  Editor.CaretY := Value;
end;

procedure TfEditorCodigo.SetCodigo(const Value: string);
var xy: TBufferCoord;
begin
  if Trim(Value) = '' then
    Editor.Text := 'begin' + sLineBreak + sLineBreak + 'end.'
  else
    Editor.Text := Value;
  xy.Char := 1;
  xy.Line := 2;
  Editor.CaretXY := xy;
  Editor.Modified := false;
  FScriptEngine.Code := codigo;
  CodigoCompiled := '';
  ColorIndicadorCompilado;
  StatusBar.Panels[INDEX_PANEL_COMPILACION].Text := '';
end;

procedure TfEditorCodigo.SetCodigoCompiled(const Value: string);
begin
  ScriptEngine.CompiledCode := Value;
  ColorIndicadorCompilado;
end;

procedure TfEditorCodigo.SetScriptEngine(const Value: TScriptEngine);
begin
  Script := TScript.Create(Value);
  FScriptEngine := Value;
  ColorIndicadorCompilado;
end;

procedure TfEditorCodigo.StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  if Panel.Index = INDEX_PANEL_COMPILACION then begin
    if Panel.Text <> '' then begin
      if Panel.Text = CORRECTO then begin
        with StatusBar.Canvas do begin
          Brush.Color := clGreen;
          Font.Color := clWhite;
          FillRect(Rect);
          TextRect(Rect, Rect.Left + 3, Rect.Top + 1, CORRECTO);
        end;
      end
      else begin
        if Panel.Text = ERROR then begin
          with StatusBar.Canvas do begin
            Brush.Color := clRed;
            Font.Color := clWhite;
            FillRect(Rect);
            TextRect(Rect, Rect.Left + 3, Rect.Top + 1, ERROR);
          end;
        end;
      end;
    end;
  end;
end;

procedure TfEditorCodigo.SynCompletionProposalCodeExecute(
  Kind: TSynCompletionType; Sender: TObject; var CurrentInput: string; var x,
  y: Integer; var CanExecute: Boolean);
var Editor: TCustomSynEdit;
  InsertList: TStrings;
  ItemsList: TStrings;
begin
  inherited;
  Editor := TSynCompletionProposal(Sender).Editor;
  InsertList := TSynCompletionProposal(Sender).InsertList;
  ItemsList := TSynCompletionProposal(Sender).ItemList;
  InsertList.Clear;
  ItemsList.Clear;
  CanExecute := Script.GetProposal(Editor.Lines, Editor.CaretY - 1, Editor.CaretX - 1,
    ItemsList, InsertList);
end;

procedure TfEditorCodigo.SynCompletionProposalParamsCancelled(Sender: TObject);
begin
  ShowingProposalParams := false;
end;

procedure TfEditorCodigo.SynCompletionProposalParamsClose(Sender: TObject);
begin
  ShowingProposalParams := false;
end;

procedure TfEditorCodigo.SynCompletionProposalParamsExecute(
  Kind: TSynCompletionType; Sender: TObject; var CurrentInput: string; var x,
  y: Integer; var CanExecute: Boolean);
var numParametro: integer;
begin
  TSynCompletionProposal(Sender).ItemList.Clear;
  CanExecute := Script.GetFunctionParametersHint(Editor.LineText, Editor.CaretX,
     TSynCompletionProposal(Sender).ItemList, numParametro);
  if CanExecute then
    TSynCompletionProposal(Sender).Form.CurrentIndex := numParametro;
  ShowingProposalParams := CanExecute;
end;

end.
