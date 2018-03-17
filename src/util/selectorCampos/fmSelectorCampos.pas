unit fmSelectorCampos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, StdCtrls, CheckLst, Contnrs, ImgList, ActnList, ToolWin,
  ActnMan, ActnCtrls, XPStyleActnCtrls, DBCtrls,
  dmCampos, DB, ExtCtrls, ALHintBalloon, uPanel;

type
  TfSelectorCampos = class(TfBase)
    clbCampos: TCheckListBox;
    ActionManager: TActionManager;
    ActionToolBar1: TActionToolBar;
    Quitar: TAction;
    SeleccionarNinguno: TAction;
    SeleccionarTodos: TAction;
    SeleccionarInverso: TAction;
    Subir: TAction;
    Bajar: TAction;
    ImageList: TImageList;
    ActionManager2: TActionManager;
    Ver: TAction;
    Panel1: TPanel;
    ALHintBalloonControl: TALHintBalloonControl;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure QuitarExecute(Sender: TObject);
    procedure SeleccionarNingunoExecute(Sender: TObject);
    procedure SeleccionarTodosExecute(Sender: TObject);
    procedure SeleccionarInversoExecute(Sender: TObject);
    procedure SubirExecute(Sender: TObject);
    procedure BajarExecute(Sender: TObject);
    procedure SubirUpdate(Sender: TObject);
    procedure BajarUpdate(Sender: TObject);
    procedure VerUpdate(Sender: TObject);
    procedure VerExecute(Sender: TObject);
    procedure QuitarUpdate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    ControlCampos: TObjectList;
    FCampos: TCampos;
    FDataSetCampos: TDataSet;
    function GetHint(const control: TControl): string;
    procedure SeleccionarControl(const control: TDBText);
    procedure OnFoundControl(const container: TfrPanel; const control: TDBText; var accept: boolean);
    procedure OnCampoClick(Sender: TObject);
    procedure InitializeControl(Control: TDBText);
    procedure SetCampos(const Value: TCampos);
  public
    property Campos: TCampos read FCampos write SetCampos;
    property DataSetCampos: TDataSet read FDataSetCampos write FDataSetCampos;
  end;


implementation

uses dmRecursosListas, uAcciones, uAccionesVer, uPanelValor,
  uPanelIntradia;

{$R *.dfm}


type
  TControlCampo = class
    OldFontStyle: TFontStyles;
    OldOnClick: TNotifyEvent;
    OldCursor: TCursor;
    Control: TDBText;
  end;

procedure TfSelectorCampos.BajarExecute(Sender: TObject);
var index: integer;
begin
  inherited;
  index := clbCampos.ItemIndex;
  if index <> -1 then begin
    clbCampos.Items.Move(index, index + 1);
    clbCampos.ItemIndex := index + 1;
  end;
end;

procedure TfSelectorCampos.BajarUpdate(Sender: TObject);
var index: integer;
begin
  inherited;
  index := clbCampos.ItemIndex;
  Bajar.Enabled := (index <> -1) and (index < clbCampos.Count - 1);
end;

procedure TfSelectorCampos.FormClose(Sender: TObject; var Action: TCloseAction);
var i: integer;
  controlCampo: TControlCampo;
  control: TDBText;
begin
  inherited;
  for i := 0 to ControlCampos.Count - 1 do begin
    controlCampo := TControlCampo(ControlCampos[i]);
    control := controlCampo.Control;
    control.OnClick := controlCampo.OldOnClick;
    control.Font.Style := controlCampo.OldFontStyle;
    control.Cursor := controlCampo.OldCursor;
  end;
end;

procedure TfSelectorCampos.FormCreate(Sender: TObject);
begin
  inherited;
  TRecursosListas.Create(Self);
end;

procedure TfSelectorCampos.FormDestroy(Sender: TObject);
begin
  inherited;
  ControlCampos.Free;
  FCampos.Free;
end;

function TfSelectorCampos.GetHint(const control: TControl): string;
var i: integer;
  hint: string;
begin
  hint := control.Hint;
  i := Pos(sLineBreak, hint);
  if i = 0 then
    i := length(hint);
  result := Trim(Copy(hint, 1, i));
end;

procedure TfSelectorCampos.InitializeControl(Control: TDBText);
begin
  Control.Font.Style := Control.Font.Style + [fsUnderline];
  Control.Cursor := crHandPoint;
  Control.OnClick := OnCampoClick;
end;

procedure TfSelectorCampos.OnCampoClick(Sender: TObject);
begin
  SeleccionarControl(Sender as TDBText);
  Campos.Select(GetHint(Sender as TDBText));
end;

procedure TfSelectorCampos.OnFoundControl(const container: TfrPanel; const control: TDBText;
  var accept: boolean);
begin
    if container is TfrPanelValor then begin
      accept := (control = TfrPanelValor(container).Valor) or
        (control = TfrPanelValor(container).Simbolo);
    end
    else begin
      if container is TfrPanelIntradia then begin
        accept := control <> TfrPanelIntradia(container).FechaEstado2;
      end
      else begin
        try
          accept := FDataSetCampos.FieldByName(control.DataField) <> nil;
        except
          // FieldByName lanza excepción si no encuentra el field
          on EDatabaseError do
            accept := false;
        end;
      end;
    end;
end;

procedure TfSelectorCampos.QuitarExecute(Sender: TObject);
var i: integer;
  controlCampo: TControlCampo;
  control: TDBText;
  algunoQuitado: boolean;

  procedure QuitarCampo(const index: integer);
  begin
    controlCampo := TControlCampo(clbCampos.Items.Objects[index]);
    Campos.Unselect(GetHint(controlCampo.Control));
    control := controlCampo.Control;
    InitializeControl(control);
    clbCampos.Items.Delete(index);
  end;

begin
  inherited;
  i := 0;
  algunoQuitado := false;
  while i < clbCampos.Count do begin
    if clbCampos.Checked[i] then begin
      QuitarCampo(i);
      algunoQuitado := true;
    end
    else
      inc(i);
  end;
  if (not algunoQuitado) and (clbCampos.ItemIndex <> -1) then begin
    QuitarCampo(clbCampos.ItemIndex);
  end;
end;

procedure TfSelectorCampos.QuitarUpdate(Sender: TObject);
begin
  inherited;
  Quitar.Enabled := clbCampos.Items.Count > 0;
  SeleccionarTodos.Enabled := Quitar.Enabled;
  SeleccionarNinguno.Enabled := Quitar.Enabled;
  SeleccionarInverso.Enabled := Quitar.Enabled;
end;

procedure TfSelectorCampos.SeleccionarControl(const control: TDBText);
var controlCampo: TControlCampo;
  i: integer;
  encontrado: boolean;
  hint: string;
begin
  encontrado := false;
  for i := 0 to ControlCampos.Count - 1 do begin
    controlCampo := TControlCampo(ControlCampos[i]);
    hint := GetHint(control);
    if GetHint(controlCampo.Control) = hint then begin
      //Puede haber más de un control que muestro lo mismo, pero solo añadimos a
      //la lista uno.
      if not encontrado then begin
        clbCampos.AddItem(hint, controlCampo);
        encontrado := true;
      end;
      with controlCampo.Control do begin
        Font.Style := Font.Style - [fsUnderline];
        OnClick := nil;
        Cursor := crDefault;
      end;
    end;
  end;
end;

procedure TfSelectorCampos.SeleccionarInversoExecute(Sender: TObject);
var i: integer;
begin
  inherited;
  for i := 0 to clbCampos.Count - 1 do begin
    clbCampos.Checked[i] := not clbCampos.Checked[i];
  end;
end;

procedure TfSelectorCampos.SeleccionarNingunoExecute(Sender: TObject);
var i: integer;
begin
  inherited;
  for i := 0 to clbCampos.Count - 1 do begin
    clbCampos.Checked[i] := false;
  end;
end;

procedure TfSelectorCampos.SeleccionarTodosExecute(Sender: TObject);
var i: integer;
begin
  inherited;
  for i := 0 to clbCampos.Count - 1 do begin
    clbCampos.Checked[i] := true;
  end;
end;

procedure TfSelectorCampos.SetCampos(const Value: TCampos);
var i: integer;
  Campo: TCampo;
  ControlCampo: TControlCampo;
  Control: TDBText;
  c: TComponent;
  accionesVer: TAccionesVer;
begin
  FreeAndNil(ControlCampos);
  ControlCampos := TObjectList.Create;
  ControlCampos.OwnsObjects := true;
  clbCampos.Clear;
  FCampos := Value;
  if FCampos.Count = 0 then begin
    accionesVer := TAccionesVer(GetAcciones(TAccionesVer));
    FCampos.OnFoundControl := OnFoundControl;
    for i := 0 to accionesVer.ComponentCount - 1 do begin
      c := accionesVer.Components[i];
      if c is TfrPanel then
        FCampos.Search(TfrPanel(c));
    end;
  end;
  for i := 0 to FCampos.Count - 1 do begin
    Campo := FCampos[i];
    ControlCampo := TControlCampo.Create;
    Control := Campo.Control;
    ControlCampo.Control := Control;
    ControlCampo.OldFontStyle := Control.Font.Style;
    ControlCampo.OldOnClick := Control.OnClick;
    ControlCampo.OldCursor := Control.Cursor;
    InitializeControl(Control);
    ControlCampos.Add(ControlCampo);
  end;

  for i := 0 to FCampos.SelectedCount - 1 do begin
    SeleccionarControl(FCampos.Selected[i].Control);
  end;
end;


procedure TfSelectorCampos.SubirExecute(Sender: TObject);
var index: integer;
begin
  inherited;
  index := clbCampos.ItemIndex;
  if index <> -1 then begin
    clbCampos.Items.Move(index, index - 1);
    clbCampos.ItemIndex := index - 1;
  end;
end;

procedure TfSelectorCampos.SubirUpdate(Sender: TObject);
var index: integer;
begin
  inherited;
  index := clbCampos.ItemIndex;
  Subir.Enabled := (index <> -1) and (index > 0);
end;

procedure TfSelectorCampos.VerExecute(Sender: TObject);
var controlCampo: TControlCampo;
  control: TDBText;
  i: integer;
  position: TALHintBalloonArrowPosition;
begin
  inherited;
  i := clbCampos.ItemIndex;
  if i = -1 then
    exit;
  controlCampo := TControlCampo(clbCampos.Items.Objects[i]);
  control := controlCampo.Control;

  if control.Alignment = taRightJustify then
    position := bapTopRight
  else
    position := bapTopLeft;
  ALHintBalloonControl.ShowTextHintBalloon(bmtNone, '', GetHint(control),
    control.Canvas.TextWidth(control.Hint), 0, 0, control, position);
end;

procedure TfSelectorCampos.VerUpdate(Sender: TObject);
begin
  inherited;
  Ver.Enabled := clbCampos.ItemIndex <> -1;
end;

end.
