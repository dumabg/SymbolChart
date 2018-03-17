unit fmStopsManuales;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBaseEditar, StdCtrls, Mask, DBCtrls, JvExControls,
  DBActns, ActnList, ActnMan,
  ImgList, ToolWin, Grids, DBGrids,
  JvPageList, Menus, JvExStdCtrls, ExtCtrls, DB, dmStopsManuales,
  ActnCtrls, Buttons, 
  fmBase, JvDBUltimGrid,  JvCombobox, JvDBSearchComboBox,
  XPStyleActnCtrls, JvXPCore, JvXPButtons, JvExDBGrids, JvDBGrid;

type
  TfStopsManuales = class(TfBaseEditar)
    PageList: TJvPageList;
    PageStopsDinamicos: TJvStandardPage;
    PageNuevoStop: TJvStandardPage;
    ActionManager: TActionManager;
    Largo: TAction;
    Corto: TAction;
    Anadir: TDataSetInsert;
    BuscarValor: TAction;
    PosicionInicial: TDBEdit;
    Cambio: TDBEdit;
    Stop: TDBEdit;
    Ganancia: TDBEdit;
    Perdida: TDBEdit;
    rbLargo: TRadioButton;
    rbCorto: TRadioButton;
    iLargo: TImage;
    iCorto: TImage;
    dsStops: TDataSource;
    dsValores: TDataSource;
    ActionToolBar: TActionToolBar;
    ImageList: TImageList;
    bAceptar: TJvXPButton;
    bCancelar: TJvXPButton;
    Label10: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label4: TLabel;
    LabelLargoCorto: TLabel;
    Label9: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    GridStops: TJvDBUltimGrid;
    CambiarCambio: TAction;
    Borrar: TAction;
    Valores: TJvDBSearchComboBox;
    procedure LargoExecute(Sender: TObject);
    procedure CortoExecute(Sender: TObject);
    procedure GridStopsDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure GridStopsGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure AnadirExecute(Sender: TObject);
    procedure bAceptarClick(Sender: TObject);
    procedure bCancelarClick(Sender: TObject);
    procedure LargoUpdate(Sender: TObject);
    procedure CambiarCambioExecute(Sender: TObject);
    procedure CambiarCambioUpdate(Sender: TObject);
    procedure BorrarUpdate(Sender: TObject);
    procedure BorrarExecute(Sender: TObject);
  private
    DataStops: TStopsManuales;
    LastHeight: integer;
    LastWidth: integer;
  protected
    function CheckTDBEdit: boolean; override;
  public
  end;

implementation

uses fmActualizarStopManual, UtilForms, dmConfiguracion;

{$R *.dfm}

resourcestring
  DEBE_SUBIR = 'que debe subir un';
  DEBE_BAJAR = 'que debe bajar un';
  STOP_MENOR_CAMBIO = 'El stop debe ser menor que el cambio';
  STOP_MAYOR_CAMBIO = 'El stop debe ser mayor que el cambio';

const
  MIN_HEIGHT: integer = 366;
  MIN_WIDTH: integer = 524;

procedure TfStopsManuales.LargoExecute(Sender: TObject);
begin
  inherited;
  if DataStops <> nil then begin
    DataStops.StopsLARGO_CORTO.Value := 'L';
    LabelLargoCorto.Caption := DEBE_SUBIR;
  end;
end;

procedure TfStopsManuales.CortoExecute(Sender: TObject);
begin
  inherited;
  if DataStops <> nil then begin
    DataStops.StopsLARGO_CORTO.Value := 'C';
    LabelLargoCorto.Caption := DEBE_BAJAR;
  end;
end;

procedure TfStopsManuales.GridStopsDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var valor: string;
begin
  if Column.Field = DataStops.StopsLARGO_CORTO then begin
    GridStops.Canvas.FillRect(Rect);
    valor := DataStops.StopsLARGO_CORTO.Value;
    if valor = 'L' then
      GridStops.Canvas.Draw(Rect.Left + 2, Rect.Top + 4, iLargo.Picture.Graphic)
    else
      if valor = 'C' then
          GridStops.Canvas.Draw(Rect.Left + 2, Rect.Top + 4, iCorto.Picture.Graphic);
  end;
end;


procedure TfStopsManuales.GridStopsGetCellParams(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; Highlight: Boolean);
var stopRoto: boolean;
begin
  with DataStops do begin
    if not StopsOID_STOP.IsNull then begin
      stopRoto := ((StopsCAMBIO.Value < StopsSTOP.Value) and
                   (StopsLARGO_CORTO.Value = 'L')) or
                  ((StopsCAMBIO.Value > StopsSTOP.Value) and
                   (StopsLARGO_CORTO.Value = 'C'));
      if stopRoto then begin
        if Highlight then begin
          Background := clRed;
          AFont.Color := clWhite;
        end
        else begin
          Background := $00EAEAFF;
          AFont.Color := clBlack;
        end;
      end
      else begin
        if Highlight then begin
          Background := clGreen;
          AFont.Color := clWhite;
        end
        else begin
          Background := $00ECFFEC;
          AFont.Color := clBlack;
        end;
      end;
    end;
  end;

{  if Highlight then
    AFont.Style := [fsBold];}
end;

procedure TfStopsManuales.BorrarExecute(Sender: TObject);
begin
  inherited;
  DataStops.BorrarStopManual;
end;

procedure TfStopsManuales.BorrarUpdate(Sender: TObject);
begin
  inherited;
  Borrar.Enabled := DataStops.Stops.RecordCount > 0;
end;

procedure TfStopsManuales.FormCreate(Sender: TObject);
begin
  inherited;
  DataStops := TStopsManuales.Create(Self);
  PageList.ActivePage := PageStopsDinamicos;
end;

procedure TfStopsManuales.AnadirExecute(Sender: TObject);
begin
  inherited;
  DataStops.Stops.Append;
  LastHeight := Height;
  LastWidth := Width;
  Height := MIN_HEIGHT;
  Width := MIN_WIDTH;
  PageList.ActivePage := PageNuevoStop;
end;

procedure TfStopsManuales.bAceptarClick(Sender: TObject);
begin
  inherited;
  if CheckTDBEdit then begin
    DataStops.AnadirStopManual(rbLargo.Checked);
    PageList.ActivePage := PageStopsDinamicos;
  end;
end;

procedure TfStopsManuales.bCancelarClick(Sender: TObject);
begin
  inherited;
  DataStops.Stops.Cancel;
  Height := LastHeight;
  Width := LastWidth;
  PageList.ActivePage := PageStopsDinamicos;
end;

procedure TfStopsManuales.LargoUpdate(Sender: TObject);
begin
  inherited;
  Corto.Checked := not Largo.Checked;
end;

function TfStopsManuales.CheckTDBEdit: boolean;
begin
  result := inherited CheckTDBEdit;
  if result then begin
    with DataStops do begin
      if (StopsLARGO_CORTO.Value = 'L') and (StopsCAMBIO.Value <= StopsSTOP.Value) then begin
        Stop.SetFocus;
        ShowMessage(STOP_MENOR_CAMBIO);
        result := false;
      end
      else
        if (StopsLARGO_CORTO.Value = 'C') and (StopsCAMBIO.Value >= StopsSTOP.Value) then begin
          Stop.SetFocus;
          ShowMessage(STOP_MAYOR_CAMBIO);
          result := false;
        end;
    end;
  end;
end;

procedure TfStopsManuales.CambiarCambioExecute(Sender: TObject);
begin
  if ShowFormModal(TfActualizarStopManual) = mrOK then
    DataStops.GuardarCambios
  else
    dsStops.DataSet.Cancel;
end;

procedure TfStopsManuales.CambiarCambioUpdate(Sender: TObject);
begin
  inherited;
  CambiarCambio.Enabled := DataStops.Stops.RecordCount > 0;
end;

end.
