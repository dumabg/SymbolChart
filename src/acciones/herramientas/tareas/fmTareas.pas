unit fmTareas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, dmTareas, ActnList, TB2Item, SpTBXItem, TB2Dock, TB2Toolbar,
  ImgList, DB, ExtCtrls, Grids, DBGrids, JvExDBGrids, JvDBGrid, JvDBUltimGrid;

type
  TfTareas = class(TfBase)
    gTareas: TJvDBUltimGrid;
    Panel1: TPanel;
    dsTareas: TDataSource;
    ImageList: TImageList;
    SpTBXToolbar1: TSpTBXToolbar;
    SpTBXItem2: TSpTBXItem;
    iPausarReanudar: TSpTBXItem;
    ActionList: TActionList;
    Pausar: TAction;
    Reanudar: TAction;
    Parar: TAction;
    procedure PausarExecute(Sender: TObject);
    procedure ReanudarExecute(Sender: TObject);
    procedure PararExecute(Sender: TObject);
    procedure PararUpdate(Sender: TObject);
    procedure ReanudarUpdate(Sender: TObject);
    procedure PausarUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure PausarReanudar;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfTareas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

procedure TfTareas.PararExecute(Sender: TObject);
begin
  inherited;
  Tareas.Parar;
end;

procedure TfTareas.PararUpdate(Sender: TObject);
begin
  inherited;
  Parar.Enabled := Tareas.Count > 0;
end;

procedure TfTareas.PausarExecute(Sender: TObject);
begin
  inherited;
  PausarReanudar;
  Tareas.Pausar;
end;

procedure TfTareas.PausarReanudar;
begin
  if iPausarReanudar.Action = Pausar then
    iPausarReanudar.Action := Reanudar
  else
    iPausarReanudar.Action := Pausar;
end;

procedure TfTareas.PausarUpdate(Sender: TObject);
begin
  inherited;
  Pausar.Enabled := Tareas.Estado = etCorriendo;
end;

procedure TfTareas.ReanudarExecute(Sender: TObject);
begin
  inherited;
  PausarReanudar;
  Tareas.Reanudar;
end;

procedure TfTareas.ReanudarUpdate(Sender: TObject);
begin
  inherited;
  Reanudar.Enabled := Tareas.Estado = etPausada;
end;

end.
