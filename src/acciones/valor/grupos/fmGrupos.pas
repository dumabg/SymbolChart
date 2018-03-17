unit fmGrupos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGrids, ActnList, ImgList,
  XPStyleActnCtrls, ActnMan, ToolWin, ActnCtrls, ExtCtrls, StdCtrls,
  Buttons, dmGrupos, DBCtrls, ComCtrls, CheckLst, fmBase, 
  JvExStdCtrls, JvEdit, JvDBSearchEdit, JvCombobox,
  JvDBSearchComboBox, JvExControls, JvExComCtrls,
  JvComCtrls, JvExDBGrids, JvDBGrid, JvXPCore,
  JvXPButtons, dmAccionesValor, JvGIF;

type
  TfGrupos = class(TfBase)
    Panel1: TPanel;
    ActionManager: TActionManager;
    NombreGrupoModificado: TStaticText;
    StaticText3: TStaticText;
    ImageList: TImageList;
    GridDisponibles: TJvDBGrid;
    PageControl: TJvPageControl;
    tsCrearGrupo: TTabSheet;
    tsMain: TTabSheet;
    tsSelecModificar: TTabSheet;
    Label3: TLabel;
    Panel3: TPanel;
    Label4: TLabel;
    rbCrearGrupo: TRadioButton;
    rbModificarGrupo: TRadioButton;
    rbBorrarGrupo: TRadioButton;
    tsModificar: TTabSheet;
    Panel4: TPanel;
    TituloModificar: TLabel;
    CrearGrupo: TAction;
    Panel2: TPanel;
    Label8: TLabel;
    Label7: TLabel;
    DBGrid2: TDBGrid;
    Label5: TLabel;
    NombreGrupo: TEdit;
    Panel5: TPanel;
    Label9: TLabel;
    DBGrid1: TDBGrid;
    Label11: TLabel;
    tsBorrar: TTabSheet;
    Panel6: TPanel;
    Label10: TLabel;
    Label12: TLabel;
    DBGrid3: TDBGrid;
    Siguiente: TAction;
    Anterior: TAction;
    Cerrar: TAction;
    bSiguiente: TJvXPButton;
    bAnterior: TJvXPButton;
    Borrar: TAction;
    ActionToolBar4: TActionToolBar;
    SelecBorrar: TAction;
    SelecValor: TAction;
    SelecTodo: TAction;
    SelecNinguno: TAction;
    SelecInvert: TAction;
    Seleccionados: TListView;
    bCrear: TJvXPButton;
    bBorrar: TJvXPButton;
    bPasarI: TJvXPButton;
    bGuardar: TJvXPButton;
    Guardar: TAction;
    BusquedaValorNombre: TJvDBSearchEdit;
    JvDBSearchComboBox1: TJvDBSearchComboBox;
    Bevel1: TBevel;
    Panel7: TPanel;
    Label2: TLabel;
    ImagenCrearGrupo: TImage;
    ImagenBorrarGrupo: TImage;
    ImagenModificarGrupo: TImage;
    bPasarD: TJvXPButton;
    Panel8: TPanel;
    BusquedaValorSimbolo: TJvDBSearchEdit;
    bCerrar: TJvXPButton;
    rbExportarGrupo: TRadioButton;
    rbImportarGrupo: TRadioButton;
    tsExportar: TTabSheet;
    ImagenExportarGrupo: TImage;
    Label1: TLabel;
    DBGrid4: TDBGrid;
    bExportar: TJvXPButton;
    Exportar: TAction;
    Panel9: TPanel;
    Label6: TLabel;
    ImagenImportarGrupo: TImage;
    dsValores: TDataSource;
    procedure rbCrearGrupoClick(Sender: TObject);
    procedure rbModificarGrupoClick(Sender: TObject);
    procedure rbBorrarGrupoClick(Sender: TObject);
    procedure SiguienteUpdate(Sender: TObject);
    procedure SiguienteExecute(Sender: TObject);
    procedure AnteriorUpdate(Sender: TObject);
    procedure AnteriorExecute(Sender: TObject);
    procedure CrearGrupoExecute(Sender: TObject);
    procedure NombreGrupoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tsCrearGrupoShow(Sender: TObject);
    procedure BorrarExecute(Sender: TObject);
    procedure tsMainShow(Sender: TObject);
    procedure SelecValorExecute(Sender: TObject);
    procedure SelecBorrarExecute(Sender: TObject);
    procedure SelecTodoExecute(Sender: TObject);
    procedure SelecNingunoExecute(Sender: TObject);
    procedure SelecInvertExecute(Sender: TObject);
    procedure SelecUpdate(Sender: TObject);
    procedure SelecValorUpdate(Sender: TObject);
    procedure GridDisponiblesDblClick(Sender: TObject);
    procedure SeleccionadosMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tsModificarShow(Sender: TObject);
    procedure GuardarExecute(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure JvDBSearchComboBox1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BusquedaValorNombreEnter(Sender: TObject);
    procedure BusquedaValorSimboloEnter(Sender: TObject);
    procedure SeleccionadosAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure SeleccionadosCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure SeleccionadosColumnClick(Sender: TObject; Column: TListColumn);
    procedure CerrarExecute(Sender: TObject);
    procedure ExportarExecute(Sender: TObject);
    procedure rbExportarGrupoClick(Sender: TObject);
    procedure rbImportarGrupoClick(Sender: TObject);
  private
    SortColumn: integer;
    data: TGrupos;
    procedure ActivarOpciones;
    procedure AddSeleccionadosItem;
    procedure RefrescarDisponibles;
    procedure ResetImagenCrearGrupo;
    procedure ResetImagenModificarGrupo;
    procedure ResetImagenBorrarGrupo;
    procedure ResetImagenExportarGrupo;
    procedure ImagenPrincipal(const imagen: TImage);
  protected
  public
    constructor Create(const Owner: TComponent; const DataAccionesValor: TDataAccionesValor); reintroduce;
  end;

implementation




{$R *.dfm}

procedure TfGrupos.FormShow(Sender: TObject);
begin
  inherited;
  ImagenPrincipal(ImagenCrearGrupo);
  rbCrearGrupo.SetFocus;
end;

procedure TfGrupos.rbCrearGrupoClick(Sender: TObject);
begin
  rbModificarGrupo.Checked := false;
  rbBorrarGrupo.Checked := false;
  rbExportarGrupo.Checked := false;
  rbImportarGrupo.Checked := false;
  ResetImagenModificarGrupo;
  ResetImagenBorrarGrupo;
  ResetImagenExportarGrupo;
  ImagenImportarGrupo.Visible := false;
  ImagenPrincipal(ImagenCrearGrupo);
end;


procedure TfGrupos.rbExportarGrupoClick(Sender: TObject);
begin
  inherited;
  rbCrearGrupo.Checked := false;
  rbModificarGrupo.Checked := false;
  rbBorrarGrupo.Checked := false;
  rbImportarGrupo.Checked := false;
  ResetImagenCrearGrupo;
  ResetImagenModificarGrupo;
  ResetImagenBorrarGrupo;
  ImagenImportarGrupo.Visible := false;
  ImagenPrincipal(ImagenExportarGrupo);
end;

procedure TfGrupos.rbImportarGrupoClick(Sender: TObject);
begin
  inherited;
  rbCrearGrupo.Checked := false;
  rbModificarGrupo.Checked := false;
  rbBorrarGrupo.Checked := false;
  rbExportarGrupo.Checked := false;
  ResetImagenCrearGrupo;
  ResetImagenModificarGrupo;
  ResetImagenBorrarGrupo;
  ResetImagenExportarGrupo;
  ImagenImportarGrupo.Visible := true;
  ImagenPrincipal(ImagenImportarGrupo);
end;

procedure TfGrupos.rbModificarGrupoClick(Sender: TObject);
begin
  rbCrearGrupo.Checked := false;
  rbBorrarGrupo.Checked := false;
  rbExportarGrupo.Checked := false;
  rbImportarGrupo.Checked := false;
  ResetImagenCrearGrupo;
  ResetImagenBorrarGrupo;
  ResetImagenExportarGrupo;
  ImagenImportarGrupo.Visible := false;  
  ImagenPrincipal(ImagenModificarGrupo);
end;

procedure TfGrupos.rbBorrarGrupoClick(Sender: TObject);
begin
  rbCrearGrupo.Checked := false;
  rbModificarGrupo.Checked := false;
  rbExportarGrupo.Checked := false;
  rbImportarGrupo.Checked := false;
  ResetImagenModificarGrupo;
  ResetImagenCrearGrupo;
  ResetImagenExportarGrupo;
  ImagenImportarGrupo.Visible := false;  
  ImagenPrincipal(ImagenBorrarGrupo);
end;

procedure TfGrupos.SiguienteUpdate(Sender: TObject);
begin
  Siguiente.Enabled :=
    ((PageControl.ActivePage = tsMain) and
     (rbCrearGrupo.Checked or rbModificarGrupo.Checked or rbBorrarGrupo.Checked or
      rbExportarGrupo.Checked or rbImportarGrupo.Checked)) or
    (PageControl.ActivePage = tsSelecModificar);
end;

procedure TfGrupos.SiguienteExecute(Sender: TObject);
var grupo: string;
begin
  if PageControl.ActivePage = tsMain then begin
    ResetImagenCrearGrupo;
    ResetImagenModificarGrupo;
    ResetImagenBorrarGrupo;
    ResetImagenExportarGrupo;
    if rbCrearGrupo.Checked then
      PageControl.ActivePage := tsCrearGrupo
    else
      if rbModificarGrupo.Checked then
        PageControl.ActivePage := tsSelecModificar
      else
        if rbBorrarGrupo.Checked then
          PageControl.ActivePage := tsBorrar
        else
          if rbExportarGrupo.Checked then
            PageControl.ActivePage := tsExportar
          else
            if rbImportarGrupo.Checked then begin
              grupo := '';
              try
                if data.Importar(grupo) then begin
                  ShowMessage('Grupo importado: ' + grupo);
                  ActivarOpciones;
                end;
              except
                on e: GrupoExistenteException do
                  ShowMessage(e.Message);
              end;
            end;
  end
  else begin
    if (PageControl.ActivePage = tsSelecModificar) or
       (PageControl.ActivePage = tsCrearGrupo) then begin
      NombreGrupoModificado.Caption := 'Valores del grupo ' + data.dsGrupos.DataSet.FieldByName('NOMBRE').Value;
      PageControl.ActivePage := tsModificar;
      Guardar.Visible := true;
      Siguiente.Visible := false;
      Anterior.Visible := false;
      Width := Width + 200;
      Height := Height + 200;
      Left := Left - 80;
      if Left < 0 then
        Left := 0;
      Top := Top - 80;
      if Top < 0 then
        Top := 0;
    end;
  end;
end;

procedure TfGrupos.AnteriorUpdate(Sender: TObject);
begin
  Anterior.Enabled := PageControl.ActivePage <> tsMain;
end;

procedure TfGrupos.AnteriorExecute(Sender: TObject);
begin
  if (PageControl.ActivePage = tsCrearGrupo) or
    (PageControl.ActivePage = tsSelecModificar) or
    (PageControl.ActivePage = tsBorrar) or (PageControl.ActivePage = tsExportar) then begin
    PageControl.ActivePage := tsMain;
    if rbCrearGrupo.Checked then
      ImagenPrincipal(ImagenCrearGrupo)
    else
      if rbModificarGrupo.Checked then
        ImagenPrincipal(ImagenModificarGrupo)
      else
        if rbBorrarGrupo.Checked then        
          ImagenPrincipal(ImagenBorrarGrupo)
        else
          if rbExportarGrupo.Checked then
            ImagenPrincipal(ImagenExportarGrupo)
          else
            ImagenPrincipal(ImagenImportarGrupo);
  end
  else
    if PageControl.ActivePage = tsModificar then
      PageControl.ActivePage := tsSelecModificar;
end;

procedure TfGrupos.CerrarExecute(Sender: TObject);
begin
  inherited;
  if data.CambiosEnGrupo then begin
    case MessageDlg('Ha realizado cambios en el grupo.' + #13 + 'Si sale se perderán los cambios.',
      mtConfirmation, [mbOK, mbCancel], 0) of
      mrOk: Close;
    end;
  end
  else
    Close;
end;

procedure TfGrupos.CrearGrupoExecute(Sender: TObject);
begin
  data.CrearGrupo(Trim(NombreGrupo.Text));
  SiguienteExecute(Self);
end;

constructor TfGrupos.Create(const Owner: TComponent;
  const DataAccionesValor: TDataAccionesValor);
begin
  inherited Create(Owner);
  data := TGrupos.Create(Self, DataAccionesValor);
  data.SelectedValues := Seleccionados;
  PageControl.ActivePage := tsMain;
end;

procedure TfGrupos.NombreGrupoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var nombre: string;
begin
  nombre := Trim(NombreGrupo.Text);
  CrearGrupo.Enabled := (nombre <> '') and (not Data.ExisteGrupo(nombre));
end;

procedure TfGrupos.tsCrearGrupoShow(Sender: TObject);
begin
  NombreGrupo.SetFocus;
end;

procedure TfGrupos.BorrarExecute(Sender: TObject);
begin
  data.BorrarGrupoActual;
end;


procedure TfGrupos.BusquedaValorNombreEnter(Sender: TObject);
begin
  inherited;
  data.OrderByNombre := true;
end;

procedure TfGrupos.BusquedaValorSimboloEnter(Sender: TObject);
begin
  inherited;
  data.OrderByNombre := false;
end;

procedure TfGrupos.tsMainShow(Sender: TObject);
begin
  ActivarOpciones;
end;

procedure TfGrupos.SelecValorExecute(Sender: TObject);
var i, num: integer;
begin
  num := GridDisponibles.SelectedRows.Count;
  if num = 0 then begin
    AddSeleccionadosItem;
    data.AnadirActualAlGrupo;
  end
  else begin
    for i := 0 to  num - 1 do begin
      data.Valores.Bookmark := GridDisponibles.SelectedRows.Items[i];
      AddSeleccionadosItem;
      data.AnadirActualAlGrupo;
    end;
  end;
  RefrescarDisponibles;
  GridDisponibles.SelectedRows.Clear;
  data.Valores.First;  
end;

procedure TfGrupos.SelecBorrarExecute(Sender: TObject);
var i: integer;
  Item: TListItem;
begin
  i := 0;
  while i < Seleccionados.Items.Count do begin
    Item := Seleccionados.Items[i];
    if Item.Checked then begin
      data.BorrarValor(Integer(Item.Data));    
      Item.Free;
    end
    else
      inc(i);
  end;
  RefrescarDisponibles;
end;

procedure TfGrupos.RefrescarDisponibles;
begin
  data.RefrescarDisponibles;
end;

procedure TfGrupos.ResetImagenBorrarGrupo;
begin
  ImagenBorrarGrupo.Left := 11;
  ImagenBorrarGrupo.Top := 31;
  ImagenBorrarGrupo.Parent := tsBorrar;
end;

procedure TfGrupos.ResetImagenCrearGrupo;
begin
  ImagenCrearGrupo.Left := 11;
  ImagenCrearGrupo.Top := 31;
  ImagenCrearGrupo.Parent := tsCrearGrupo;
end;

procedure TfGrupos.ResetImagenExportarGrupo;
begin
  ImagenExportarGrupo.Left := 11;
  ImagenExportarGrupo.Top := 31;
  ImagenExportarGrupo.Parent := tsExportar;
end;

procedure TfGrupos.ResetImagenModificarGrupo;
begin
  ImagenModificarGrupo.Left := 11;
  ImagenModificarGrupo.Top := 31;
  ImagenModificarGrupo.Parent := tsSelecModificar;
end;

procedure TfGrupos.SelecTodoExecute(Sender: TObject);
var i, num: integer;
begin
  num := Seleccionados.Items.Count - 1;
  for i:=0 to num do
    Seleccionados.Items[i].Checked := true;
end;

procedure TfGrupos.SelecNingunoExecute(Sender: TObject);
var i, num: integer;
begin
  num := Seleccionados.Items.Count - 1;
  for i:=0 to num do
    Seleccionados.Items[i].Checked := false;
end;

procedure TfGrupos.SelecInvertExecute(Sender: TObject);
var i, num: integer;
begin
  num := Seleccionados.Items.Count - 1;
  for i:=0 to num do
    Seleccionados.Items[i].Checked := not Seleccionados.Items[i].Checked;
end;

procedure TfGrupos.SelecUpdate(Sender: TObject);
var count, checked: integer;

    function checkedCount: integer;
    var i, num: integer;
    begin
      num := count - 1;
      result := 0;
      for i:=0 to num do begin
        if Seleccionados.Items[i].Checked then
          inc(result);
      end;
    end;

begin
  count := Seleccionados.Items.Count;
  checked := checkedCount;
  SelecBorrar.Enabled := checkedCount > 0;
  SelecTodo.Enabled := (count > 0) and (count <> checked);
  SelecNinguno.Enabled := (count > 0) and (checked <> 0);
  SelecInvert.Enabled := count > 0;
end;

procedure TfGrupos.SelecValorUpdate(Sender: TObject);
begin
  SelecValor.Enabled := not (data.Valores.EOF and data.Valores.BOF);
end;

procedure TfGrupos.GridDisponiblesDblClick(Sender: TObject);
begin
  SelecValor.Execute;
end;

procedure TfGrupos.SeleccionadosAdvancedCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
  var DefaultDraw: Boolean);
begin
  inherited;
  Sender.Canvas.Brush.Color := clWhite;
end;

procedure TfGrupos.SeleccionadosColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  inherited;
  SortColumn := Column.Index;
  Seleccionados.AlphaSort;
end;

procedure TfGrupos.SeleccionadosCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  inherited;
  if SortColumn = 0 then
    Compare := CompareText(Item1.Caption, Item2.Caption)
  else
    Compare := CompareText(Item1.SubItems[SortColumn - 1], Item2.SubItems[SortColumn - 1]);
end;

procedure TfGrupos.SeleccionadosMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Item: TListItem;
begin
  Item := Seleccionados.GetItemAt(X, Y);
  if Item <> nil then
    Item.Checked := not Item.Checked;
end;

procedure TfGrupos.tsModificarShow(Sender: TObject);
var item: TListItem;
  OIDValor: integer;
begin
  data.CargarValoresGrupo;
  Seleccionados.Clear;
  Seleccionados.Items.BeginUpdate;
  try
    data.ValoresGrupo.First;
    while not data.ValoresGrupo.EOF do begin
      item := Seleccionados.Items.Add;
      item.Caption := data.ValoresGrupoNOMBRE.Value;
      OIDValor := data.ValoresGrupoOID_VALOR.Value;
      item.Data := Pointer(OIDValor);
      item.SubItems.Add(data.ValoresGrupoSIMBOLO.Value);
      item.SubItems.Add(data.GetMercados(OIDValor));
      data.ValoresGrupo.Next;
    end;
  finally
    Seleccionados.Items.EndUpdate;
  end;
  RefrescarDisponibles;
  BusquedaValorNombre.SetFocus;
end;

procedure TfGrupos.ActivarOpciones;
var hayGrupos: boolean;
begin
  hayGrupos := data.HayGrupos;
  rbBorrarGrupo.Enabled := hayGrupos;
  rbModificarGrupo.Enabled := hayGrupos;
  rbExportarGrupo.Enabled := hayGrupos;
  if (not hayGrupos) and (rbBorrarGrupo.Checked or rbModificarGrupo.Checked or
    rbExportarGrupo.Checked) then
    rbCrearGrupo.Checked := true;
end;

procedure TfGrupos.AddSeleccionadosItem;
var item: TListItem;
  OIDValor: integer;
  simbolo: string;
begin
  Seleccionados.Items.BeginUpdate;
  try
    item := Seleccionados.Items.Add;
    item.Caption := data.ValoresNOMBRE.Value;
    simbolo := data.ValoresSIMBOLO.Value;
    OIDValor := data.ValoresOID_VALOR.Value;
    item.Data := Pointer(OIDValor);
    item.SubItems.Add(simbolo);
    item.SubItems.Add(data.GetMercados(OIDValor));
    item.Selected := true;
    item.MakeVisible(false);
  finally
    Seleccionados.Items.EndUpdate;
  end;
end;

procedure TfGrupos.GuardarExecute(Sender: TObject);
begin
  inherited;
  data.Commit;
  Close;
end;

procedure TfGrupos.ImagenPrincipal(const imagen: TImage);
begin
  imagen.Left := 415;
  imagen.Top := 145;
  imagen.Parent := tsMain;
end;

procedure TfGrupos.JvDBSearchComboBox1Change(Sender: TObject);
begin
  inherited;
  BusquedaValorNombre.SetFocus;
end;

procedure TfGrupos.DBGrid1DblClick(Sender: TObject);
begin
  inherited;
  Siguiente.Execute;
end;

procedure TfGrupos.ExportarExecute(Sender: TObject);
begin
  inherited;
  if Data.Exportar then
    Close;
end;

end.
