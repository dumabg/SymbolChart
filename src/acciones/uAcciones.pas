unit uAcciones;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ImgList, UtilDock, SpTBXItem, TB2Dock, TB2Toolbar;

type
  TBarra = record
    Toolbar: TSpTBXToolbar;
    Dock: TDefaultDock;
  end;

  TBarras = array of TBarra;

  TAcciones = class(TFrame)
    ImageList: TImageList;
    ActionList: TActionList;
    ToolbarMenu: TSpTBXToolbar;
    Toolbar: TSpTBXToolbar;
    procedure ActionListExecute(Action: TBasicAction; var Handled: Boolean);
  private
  protected
  public
    function GetBarras: TBarras; virtual;
    procedure DoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState); virtual;
  end;

  TAccionesClass = class of TAcciones;

  TAAcciones = array of TAcciones;

  procedure RegisterAcciones(const acciones: TAcciones; const accionesClass: TAccionesClass);
  procedure RegisterAccionesAfter(const AccionesClass, After: TAccionesClass);
  function GetAccionesRegistradas: TAAcciones;
  function GetAcciones(const acciones: TAccionesClass): TAcciones;
  procedure CreateAcciones(const Owner: TComponent);
//  procedure ActivarAcciones(const activar: boolean);

implementation

{$R *.dfm}

uses Contnrs;

var
  aAcciones: TAAcciones;
  aAccionesClass: TClassList;
{
procedure ActivarAcciones(const activar: boolean);
var i: integer;

    procedure Activa(acciones: TAcciones);
    var i: integer;
      actionList: TActionList;
      action: TAction;
    begin
      actionList := acciones.ActionList;
      for i := 0 to actionList.ActionCount - 1 do begin
        action := (actionList.Actions[i] as TAction);
        if activar then begin
          action.Enabled := action.Tag = 1;
        end
        else begin
          if action.Enabled then
            action.Tag := 1
          else
            action.Tag := 0;
          action.Enabled := false;
        end;
      end;
    end;
begin
  for i := Low(aAcciones) to High(aAcciones) do begin
    Activa(aAcciones[i]);
  end;
end;
}
function GetAccionesRegistradas: TAAcciones;
begin
  result := aAcciones;
end;

function GetAcciones(const acciones: TAccionesClass): TAcciones;
var i: integer;
begin
  for i := Low(aAcciones) to High(aAcciones) do
    if aAcciones[i].ClassType = acciones then begin
      result := aAcciones[i];
      exit;
    end;
  result := nil;
end;

procedure RegisterAcciones(const acciones: TAcciones; const accionesClass: TAccionesClass);
var i, num: integer;
begin
  i := aAccionesClass.Add(AccionesClass);
  num := aAccionesClass.Count;
  SetLength(aAcciones, num);
  aAcciones[i] := acciones;
end;


procedure RegisterAccionesAfter(const AccionesClass, After: TAccionesClass);
var i: integer;
begin
  if After = nil then
    aAccionesClass.Add(AccionesClass)
  else begin
    i := aAccionesClass.IndexOf(After);
    if i > 0 then
      aAccionesClass.Insert(i + 1, AccionesClass)
    else
      aAccionesClass.Add(AccionesClass);
  end;
end;

procedure CreateAcciones(const Owner: TComponent);
var i, num: integer;
begin
  num := aAccionesClass.Count;
  SetLength(aAcciones, num);
  for i := 0 to num - 1 do
    aAcciones[i] := TAccionesClass(aAccionesClass[i]).Create(Owner);
end;

{ TAcciones }

procedure TAcciones.ActionListExecute(Action: TBasicAction;
  var Handled: Boolean);
begin
  (Action as TAction).Enabled := false;
  try
    Action.OnExecute(Action);
  finally
    (Action as TAction).Enabled := true;
  end;
  Handled := true;
end;

procedure TAcciones.DoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

function TAcciones.GetBarras: TBarras;
begin
  SetLength(result, 1);
  with result[0] do begin
    Toolbar := Self.ToolBar;
    Dock.Pos := Self.Toolbar.DockPos;
    Dock.Row := Self.Toolbar.DockRow;
  end;
end;

initialization
  aAccionesClass := TClassList.Create;
finalization
  aAccionesClass.Free;
end.
