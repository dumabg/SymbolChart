unit fmOsciladores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, TB2Item, SpTBXItem, TB2Dock, TB2Toolbar, fmEditFS, StdCtrls,
  frEditorCodigo, frEditorCodigoDatos, frFS, frEditFS, ExtCtrls, JvExExtCtrls,
  JvNetscapeSplitter, dmOsciladores, VirtualTrees, BDConstants, SpTBXEditors,
  SpTBXExtEditors;

type
  TOsciladorChangeColorEvent = procedure (const OID: Integer; const color: TColor) of object;
  TOsciladorDeleteItem = procedure (const OID: integer) of object;
  TOsciladorChangeName = procedure (const OID: integer; const name: string) of object;

  TfOsciladores = class(TfEditableFS)
    SpTBXToolbar1: TSpTBXToolbar;
    spColorPalette: TSpTBXColorPalette;
    EditorCodigo: TfEditorCodigoDatos;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure fFSTreeFSFocusChanging(Sender: TBaseVirtualTree; OldNode,
      NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
      var Allowed: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure spColorPaletteChange(Sender: TObject);
  private
    Osciladores: TOsciladores;
    FOnChangeColor: TOsciladorChangeColorEvent;
    FOnDeleteItem: TOsciladorDeleteItem;
    FOnChangeName: TOsciladorChangeName;
    procedure OnDeletedItem(const OID: integer);
    procedure OnNameChanged(const OID: integer; const name: string);
    procedure SetOnChangeName(const Value: TOsciladorChangeName);
  protected
    procedure LoadFile(const OIDFile: integer); override;
    procedure Guardar;
  public
    property OnChangeColor: TOsciladorChangeColorEvent read FOnChangeColor write FOnChangeColor;
    property OnDeleteItem: TOsciladorDeleteItem read FOnDeleteItem write FOnDeleteItem;
    property OnChangeName: TOsciladorChangeName read FOnChangeName write SetOnChangeName;
  end;

const
  OSCILADOR_OUT_VARIABLE_NAME = 'oscilador';
  OSCILADOR_OUT_VARIABLE_TYPE = rtCurrency;

implementation

{$R *.dfm}

resourcestring
  TITULO_OSCILADOR_NUEVO = 'Oscilador nuevo';
  TITULO_BORRAR_OSCILADOR = 'Borrar oscilador';
  MSG_BORRAR_OSCILADOR = '¿Está seguro de borrar el oscilador %s?';

procedure TfOsciladores.fFSTreeFSFocusChanging(Sender: TBaseVirtualTree;
  OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
  var Allowed: Boolean);
begin
  Guardar;
end;

procedure TfOsciladores.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Guardar;
end;

procedure TfOsciladores.FormCreate(Sender: TObject);
begin
  Osciladores := TOsciladores.Create(Self);
  Osciladores.OnDelete := OnDeletedItem;
  Osciladores.OnUpdate := OnNameChanged;
  fFS.EditFS := Osciladores;
  fFS.MsgBorrarFichero := MSG_BORRAR_OSCILADOR;
  fFS.TituloFicheroNuevo := TITULO_OSCILADOR_NUEVO;
  fFS.TituloBorrarFichero := TITULO_BORRAR_OSCILADOR;
  EditorCodigo.InitializeScriptEngine(false);
  EditorCodigo.OutVariableName := OSCILADOR_OUT_VARIABLE_NAME;
  EditorCodigo.OutVariableType := OSCILADOR_OUT_VARIABLE_TYPE;
end;

procedure TfOsciladores.Guardar;
begin
  if fFS.IsFocusedFile then begin
    Osciladores.BeginGuardar(fFS.OIDNodeFocused);
    Osciladores.Color := spColorPalette.Color;
    Osciladores.Codigo := EditorCodigo.Codigo;
    if (EditorCodigo.IsCompiled) and (not EditorCodigo.IsLoadedCompiledCode) then
      Osciladores.CodigoCompiled := EditorCodigo.CodigoCompiled;
    Osciladores.EndGuardar;
  end;
end;

procedure TfOsciladores.LoadFile(const OIDFile: integer);
begin
  inherited;
  Osciladores.Load(OIDFile);
  EditorCodigo.Codigo := Osciladores.Codigo;
  EditorCodigo.CodigoCompiled := Osciladores.CodigoCompiled;
  spColorPalette.OnChange := nil;
  spColorPalette.Color := Osciladores.Color;
  spColorPalette.OnChange := spColorPaletteChange;
end;

procedure TfOsciladores.OnDeletedItem(const OID: integer);
begin
  if Assigned(FOnDeleteItem) then
    FOnDeleteItem(OID);
end;

procedure TfOsciladores.OnNameChanged(const OID: integer; const name: string);
begin
  if Assigned(FOnChangeName) then
    FOnChangeName(OID, name);
end;

procedure TfOsciladores.SetOnChangeName(const Value: TOsciladorChangeName);
begin
  Osciladores.OnUpdate := Value;
end;

procedure TfOsciladores.spColorPaletteChange(Sender: TObject);
begin
  inherited;
  if Assigned(FOnChangeColor) then
    FOnChangeColor(fFS.OIDNodeFocused, spColorPalette.Color);
end;

end.
