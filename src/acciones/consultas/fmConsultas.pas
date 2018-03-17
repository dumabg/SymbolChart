unit fmConsultas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmEditFS, ExtCtrls, frFS, JvExExtCtrls, JvNetscapeSplitter,
  dmConsultas, DB, StdCtrls, TB2Item, SpTBXItem, TB2Dock, TB2Toolbar, ActnList, ImgList,
  frEditFS, frEditorCodigoDatos, Grids,
  VirtualTrees, ComCtrls, frEditorCodigo, JvExGrids, JvStringGrid, SynEditTypes;

const
  OUT_VARIABLE_NAME_BUSQUEDA = 'Accept';
  OUT_VARIABLE_NAME_LISTADO = 'Valor';

type
  TfConsultas = class(TfEditableFS)
    ImageList: TImageList;
    ActionList: TActionList;
    AddColumn: TAction;
    DeleteColumn: TAction;
    SpTBXToolbar1: TSpTBXToolbar;
    SpTBXItem2: TSpTBXItem;
    bSelecCaracteristica: TButton;
    lCaracteristica: TLabel;
    EditorCodigoListado: TfEditorCodigoDatos;
    dsColumnas: TDataSource;
    pcConsulta: TPageControl;
    tsBusqueda: TTabSheet;
    tsResultado: TTabSheet;
    rbBuscarCaracteristica: TRadioButton;
    rbBuscarCodigo: TRadioButton;
    EditorCodigoBusqueda: TfEditorCodigoDatos;
    EditColumn: TAction;
    SpTBXItem3: TSpTBXItem;
    SpTBXItem5: TSpTBXItem;
    cbColumnaSimbolo: TCheckBox;
    cbColumnaNombre: TCheckBox;
    Label1: TLabel;
    cbContarMenu: TCheckBox;
    gColumnas: TJvStringGrid;
    lSeleccioneColumna: TLabel;
    lCodigoColumna: TLabel;
    lNombreColumna: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure bSelecCaracteristicaClick(Sender: TObject);
    procedure AddColumnExecute(Sender: TObject);
    procedure DeleteColumnExecute(Sender: TObject);
    procedure DeleteColumnUpdate(Sender: TObject);
    procedure fFSTreeFSFocusChanging(Sender: TBaseVirtualTree; OldNode,
      NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
      var Allowed: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rbBuscarCaracteristicaClick(Sender: TObject);
    procedure rbBuscarCodigoClick(Sender: TObject);
    procedure EditColumnExecute(Sender: TObject);
    procedure EditColumnUpdate(Sender: TObject);
    procedure EditorCodigoListadoEditorChange(Sender: TObject);
    procedure fFSTreeFSStructureChange(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Reason: TChangeReason);
    procedure EditorCodigoListadoaCompilarExecute(Sender: TObject);
    procedure EditorCodigoBusquedaaCompilarExecute(Sender: TObject);
    procedure gColumnasDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure gColumnasColWidthsChanged(Sender: TObject);
    procedure gColumnasClick(Sender: TObject);
    procedure gColumnasColumnMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure gColumnasCaptionClick(Sender: TJvStringGrid; AColumn,
      ARow: Integer);
    procedure gColumnasExit(Sender: TObject);
  private
    Consultas: TConsultas;
    ColSelected: integer;
    procedure CodigoColumnaVisible(const codVisible: boolean);
    procedure CreateColumnas;
    procedure OnAfterCompileBusqueda(const ok: boolean);
    procedure OnAfterCompileResultado(const ok: boolean);
    procedure ActualizarColumna;
    procedure Guardar;
    procedure GuardarCompiled(const ok: boolean);
    procedure UpdateColumnasStatus;
    procedure SeleccionarColumna(const numColumna: integer);
  protected
    procedure LoadFile(const OIDFile: integer); override;
  public
    { Public declarations }
  end;


implementation

uses fmSeleccionarFS, fmBaseNuevo, fmColumna, BDConstants;
{$R *.dfm}

resourcestring
  TITULO_CONSULTA_NUEVA = 'Consulta nueva';
  TITULO_BORRAR_CONSULTA = 'Borrar consulta';
  MSG_BORRAR_CONSULTA = '¿Está seguro de borrar la consulta %s?';
  TITULO_SELECCIONAR_CARACTERISTICA = 'Seleccionar característica';
  TITULO_NUEVA_COLUMNA = 'Nueva columna';

const
  ROW_CURSOR_CHAR = 0;
  ROW_CURSOR_LINE = 1;

procedure TfConsultas.AddColumnExecute(Sender: TObject);
var fColumna: TfColumna;
  columna: TColumna;
  num: integer;
begin
  inherited;
  fColumna := TfColumna.Create(nil);
  try
    if fColumna.ShowModal = mrOk then begin
      ActualizarColumna;
      Consultas.AddColumn(fColumna.Nombre, fColumna.Tipo);
      num := Consultas.ColumnasCount;
      gColumnas.ColCount := num;
      Dec(num);
      columna := Consultas.Columna[num];
      gColumnas.ColWidths[num] := columna.Ancho;
      UpdateColumnasStatus;
      CodigoColumnaVisible(true);      
      SeleccionarColumna(num);
    end;
  finally
    fColumna.Free;
  end;
end;

procedure TfConsultas.bSelecCaracteristicaClick(Sender: TObject);
{var fSeleccionar: TfSeleccionarFS;
  DataSelected: TBasicNodeData;}
begin
  inherited;
{  fSeleccionar := TfSeleccionarFS.Create(nil);
  try
    fSeleccionar.SetFSClass(TCaracteristicas);
    fSeleccionar.Caption := TITULO_SELECCIONAR_CARACTERISTICA;
    if fSeleccionar.ShowModal = mrOK then begin
      DataSelected := fSeleccionar.Selected;
      lCaracteristica.Caption := ' ' + DataSelected.Caption;
      lCaracteristica.Tag := DataSelected.OID;
    end;
  finally
    fSeleccionar.Free;
  end;}
end;

procedure TfConsultas.CodigoColumnaVisible(const codVisible: boolean);
begin
  EditorCodigoListado.Visible := codVisible;
  lCodigoColumna.Visible := codVisible;
  lNombreColumna.Visible := codVisible;
end;

procedure TfConsultas.CreateColumnas;
var i, num: integer;
  columna: TColumna;
begin
  if Consultas.HayColumnas then begin
    num := Consultas.ColumnasCount;
    gColumnas.ColCount := num;
    dec(num);
    gColumnas.OnColWidthsChanged := nil;
    for i := 0 to num do begin
      columna := Consultas.Columna[i];
      //En la fila 0 y 1 guardaremos el cursor
      gColumnas.Objects[i, ROW_CURSOR_CHAR] := TObject(10); // Columna 0 = Char
      gColumnas.Objects[i, ROW_CURSOR_LINE] := TObject(2); // Columna 1 = Line
      gColumnas.ColWidths[i] := columna.Ancho;
    end;
    gColumnas.OnColWidthsChanged := gColumnasColWidthsChanged;
    gColumnas.Options := gColumnas.Options + [goVertLine, goHorzLine];
  end
  else begin
    gColumnas.ColCount := 1; // No puede ser 0
    gColumnas.Options := gColumnas.Options - [goVertLine, goHorzLine];
  end;
end;

procedure TfConsultas.DeleteColumnExecute(Sender: TObject);
begin
  inherited;
  Consultas.DeleteColumn(ColSelected);
  gColumnas.ColCount := Consultas.ColumnasCount;
  ColSelected := -1;
  UpdateColumnasStatus;
  CodigoColumnaVisible(false);
end;

procedure TfConsultas.DeleteColumnUpdate(Sender: TObject);
begin
  inherited;
  DeleteColumn.Enabled := ColSelected <> -1;
  lSeleccioneColumna.Visible := (ColSelected = -1) and (Consultas.HayColumnas);
end;

procedure TfConsultas.EditColumnExecute(Sender: TObject);
var f: TfColumna;
  columna: TColumna;
begin
  inherited;
  f := TfColumna.Create(nil);
  try
    columna := Consultas.Columna[ColSelected];
    f.Nombre := columna.Nombre;
    f.Tipo := columna.Tipo;
    if f.ShowModal = mrOk then begin
      columna.Nombre := f.Nombre;
      if f.Tipo <> columna.Tipo then begin
        columna.Tipo := f.Tipo;
        columna.CodigoCompiled := '';
        SeleccionarColumna(ColSelected);
      end;
    end;
  finally
    f.Free;
  end;
  gColumnas.Invalidate;
end;

procedure TfConsultas.EditColumnUpdate(Sender: TObject);
begin
  inherited;
  EditColumn.Enabled := DeleteColumn.Enabled;
end;

procedure TfConsultas.EditorCodigoBusquedaaCompilarExecute(Sender: TObject);
begin
  inherited;
  EditorCodigoBusqueda.aCompilarExecute(Sender);
end;

procedure TfConsultas.EditorCodigoListadoaCompilarExecute(Sender: TObject);
begin
  inherited;
  EditorCodigoListado.aCompilarExecute(Sender);
end;

procedure TfConsultas.EditorCodigoListadoEditorChange(Sender: TObject);
begin
  inherited;
  EditorCodigoListado.Editor.OnChange := nil;
  Consultas.Columna[ColSelected].CodigoCompiled := '';
  EditorCodigoListado.CodigoCompiled := '';
  EditorCodigoListado.EditorChange(Sender);
  gColumnas.Invalidate;
end;

procedure TfConsultas.fFSTreeFSFocusChanging(Sender: TBaseVirtualTree; OldNode,
  NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
  var Allowed: Boolean);
begin
  Guardar;
end;

procedure TfConsultas.fFSTreeFSStructureChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Reason: TChangeReason);
begin
  inherited;
  if Reason = crChildAdded then
    pcConsulta.ActivePage := tsBusqueda;
end;

procedure TfConsultas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Guardar;
end;

procedure TfConsultas.FormCreate(Sender: TObject);
begin
  inherited;
  ColSelected := -1;
  Consultas := TConsultas.Create(Self);
  fFS.EditFS := Consultas;
  fFS.MsgBorrarFichero := MSG_BORRAR_CONSULTA;
  fFS.TituloFicheroNuevo := TITULO_CONSULTA_NUEVA;
  fFS.TituloBorrarFichero := TITULO_BORRAR_CONSULTA;
  lCaracteristica.Tag := SIN_CARACTERISTICA;
  EditorCodigoBusqueda.InitializeScriptEngine(true);
  EditorCodigoBusqueda.OutVariableName := OUT_VARIABLE_NAME_BUSQUEDA;
  EditorCodigoBusqueda.OutVariableType := rtBoolean;
  EditorCodigoBusqueda.OnAfterCompile := OnAfterCompileBusqueda;
  EditorCodigoListado.InitializeScriptEngine(true);
  EditorCodigoListado.OutVariableName := OUT_VARIABLE_NAME_LISTADO;
  EditorCodigoListado.OnAfterCompile := OnAfterCompileResultado;
  pcConsulta.ActivePage := tsBusqueda;
end;

procedure TfConsultas.gColumnasCaptionClick(Sender: TJvStringGrid; AColumn,
  ARow: Integer);
begin
  inherited;
  if (AColumn <> -1) and (ColSelected <> AColumn) then begin
    ActualizarColumna;
    SeleccionarColumna(AColumn);
  end;
end;

procedure TfConsultas.gColumnasClick(Sender: TObject);
begin
  inherited;
  gColumnasCaptionClick(nil, gColumnas.Col, 0);
end;

procedure TfConsultas.gColumnasColumnMoved(Sender: TObject; FromIndex,
  ToIndex: Integer);
begin
  inherited;
  Consultas.MoveColumna(FromIndex, ToIndex);
  if FromIndex = ColSelected then
    ColSelected := ToIndex;
end;

procedure TfConsultas.gColumnasColWidthsChanged(Sender: TObject);
var i, num: Integer;
begin
  inherited;
  num := gColumnas.ColCount - 1;
  for i := 0 to num do
    Consultas.Columna[i].Ancho := gColumnas.ColWidths[i];
end;

procedure TfConsultas.gColumnasDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var columna: TColumna;
  Canvas: TCanvas;
begin
  inherited;
  Canvas := gColumnas.Canvas;
  if Consultas.HayColumnas then begin
    columna := Consultas.Columna[ACol];
    if ARow = 1 then begin
      if columna.HasCodigoCompiled then
        Canvas.Brush.Color := $00E6FFE6
      else
        Canvas.Brush.Color := $00DFDFFF;
    end;
    Canvas.FillRect(Rect);
    Canvas.Font.Color := clBlack;
    if ACol = ColSelected then
      Canvas.Font.Style := [fsBold]
    else
      Canvas.Font.Style := [];
    if ARow = 0 then
      Canvas.TextRect(Rect, Rect.Left + 2, 3, columna.Nombre)
    else
      Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 3, columna.TipoAsString);
  end
  else begin
    Canvas.Brush.Color := gColumnas.Color;
    Canvas.FillRect(Rect);
  end;
end;

procedure TfConsultas.gColumnasExit(Sender: TObject);
begin
  inherited;
  ActualizarColumna;
end;

procedure TfConsultas.Guardar;
var tipo: TTipoConsulta;
begin
  if fFS.IsFocusedFile then begin
{    if rbBuscarCaracteristica.Checked then
      tipo := tcCaracteristica
    else}
      tipo := tcCodigo;
    ActualizarColumna;
    Consultas.Guardar(tipo, fFS.OIDNodeFocused, lCaracteristica.Tag,
      EditorCodigoBusqueda.Codigo, cbColumnaSimbolo.Checked,
      cbColumnaNombre.Checked, cbContarMenu.Checked);
  end;
end;

procedure TfConsultas.GuardarCompiled(const ok: boolean);
var codigoCompiled: string;
begin
  if ok then
    codigoCompiled := EditorCodigoBusqueda.CodigoCompiled
  else
    codigoCompiled := '';
  Consultas.UpdateCodigoCompiledBusqueda(fFS.OIDNodeFocused, codigoCompiled);
end;

procedure TfConsultas.ActualizarColumna;
begin
  inherited;
  if ColSelected <> -1 then begin
    Consultas.Columna[ColSelected].Codigo := EditorCodigoListado.Editor.Text;
    gColumnas.Objects[ColSelected, ROW_CURSOR_CHAR] := TObject(EditorCodigoListado.Editor.CaretX);
    gColumnas.Objects[ColSelected, ROW_CURSOR_LINE] := TObject(EditorCodigoListado.Editor.CaretY);
  end;
end;

procedure TfConsultas.LoadFile(const OIDFile: integer);
begin
  Consultas.Load(OIDFile);
  lCaracteristica.Caption := Consultas.Caracteristica;
  lCaracteristica.Tag := Consultas.OIDCaracteristica;
  rbBuscarCaracteristica.Checked := Consultas.Tipo = tcCaracteristica;
  rbBuscarCodigo.Checked := not rbBuscarCaracteristica.Checked;
  EditorCodigoBusqueda.Codigo := Consultas.Codigo;
  EditorCodigoBusqueda.CodigoCompiled := Consultas.CodigoCompiled;
  cbColumnaSimbolo.Checked := Consultas.ColumnaSimbolo;
  cbColumnaNombre.Checked := Consultas.ColumnaNombre;
  cbContarMenu.Checked := Consultas.ContarValores;
  // Columnas
  ColSelected := -1;
  CodigoColumnaVisible(false);
  CreateColumnas;
  UpdateColumnasStatus;
end;

procedure TfConsultas.OnAfterCompileBusqueda(const ok: boolean);
begin
  Guardar;
  GuardarCompiled(ok);
  gColumnas.Invalidate;
end;

procedure TfConsultas.OnAfterCompileResultado(const ok: boolean);
var codigoCompiled: string;
begin
  if ok then begin
    codigoCompiled := EditorCodigoListado.CodigoCompiled;
    EditorCodigoListado.Editor.OnChange := EditorCodigoListadoEditorChange;
  end
  else
    codigoCompiled := '';
  Consultas.Columna[ColSelected].CodigoCompiled := codigoCompiled;
  gColumnas.Invalidate;
end;

procedure TfConsultas.rbBuscarCaracteristicaClick(Sender: TObject);
begin
  inherited;
  rbBuscarCodigo.Checked := not rbBuscarCaracteristica.Checked;
end;

procedure TfConsultas.rbBuscarCodigoClick(Sender: TObject);
begin
  inherited;
  rbBuscarCaracteristica.Checked := not rbBuscarCodigo.Checked;
end;


procedure TfConsultas.SeleccionarColumna(const numColumna: integer);
var columna: TColumna;
  coord: TBufferCoord;
begin
  ColSelected := numColumna;
  columna := Consultas.Columna[numColumna];
  EditorCodigoListado.Codigo := columna.Codigo;
  EditorCodigoListado.CodigoCompiled := columna.CodigoCompiled;
  EditorCodigoListado.OutVariableType := columna.Tipo;
  EditorCodigoListado.Editor.OnChange := EditorCodigoListadoEditorChange;
  lNombreColumna.Caption := columna.Nombre;
  gColumnas.Invalidate;
  CodigoColumnaVisible(true);
  EditorCodigoListado.Editor.SetFocus;
  coord.Char := Integer(gColumnas.Objects[ColSelected, ROW_CURSOR_CHAR]);
  coord.Line := Integer(gColumnas.Objects[ColSelected, ROW_CURSOR_LINE]);
  EditorCodigoListado.Editor.CaretXY := coord;
end;

procedure TfConsultas.UpdateColumnasStatus;
begin
  if Consultas.HayColumnas then begin
    gColumnas.Options := gColumnas.Options + [goVertLine, goHorzLine];
    gColumnas.Enabled := true;
  end
  else begin
    gColumnas.Options := gColumnas.Options - [goVertLine, goHorzLine];
    gColumnas.Enabled := false;
  end;
end;

end.
