unit fmMapaValores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, mini, dmMapaValores, StdCtrls, CheckLst, ActnList,
  ActnMan, ExtCtrls, ImgList, DBCtrls,
  Buttons, JvComponentBase,
  JvBalloonHint, XPStyleActnCtrls, Grids, DBGrids, JvExDBGrids,
  JvDBGrid, JvDBUltimGrid, DB, TB2Item, SpTBXItem, TB2Dock, TB2Toolbar;

type
  TfMapaValores = class(TfBase)
    Mapa: TMiniMap;
    ActionManager: TActionManager;
    BorrarTodos: TAction;
    SeleccionarTodos: TAction;
    Inversa: TAction;
    Panel1: TPanel;
    Panel2: TPanel;
    ImageList: TImageList;
    Siguiente: TAction;
    Anterior: TAction;
    JvBalloonHint: TJvBalloonHint;
    GridValores: TJvDBUltimGrid;
    dsValores: TDataSource;
    SeleccionarAPos: TAction;
    SeleccionarANeg: TAction;
    SeleccionarABPos: TAction;
    SeleccionarABNeg: TAction;
    SeleccionarBPos: TAction;
    SeleccionarBNeg: TAction;
    Seleccionar0Pos: TAction;
    Seleccionar0Neg: TAction;
    TBXToolbar1: TSpTBXToolbar;
    TBXItem1: TSpTBXItem;
    TBXItem2: TSpTBXItem;
    TBXItem3: TSpTBXItem;
    TBXSeparatorItem1: TSpTBXSeparatorItem;
    TBXItem4: TSpTBXItem;
    TBXItem5: TSpTBXItem;
    TBXItem6: TSpTBXItem;
    TBXItem7: TSpTBXItem;
    TBXItem8: TSpTBXItem;
    TBXItem9: TSpTBXItem;
    TBXItem10: TSpTBXItem;
    TBXSeparatorItem2: TSpTBXSeparatorItem;
    TBXItem11: TSpTBXItem;
    TBXItem12: TSpTBXItem;
    TBControlItem1: TTBControlItem;
    Fecha: TDBText;
    TBXItem13: TSpTBXItem;
    VerSeleccionados: TAction;
    TBXSeparatorItem3: TSpTBXSeparatorItem;
    TBXItem14: TSpTBXItem;
    procedure ValoresClickCheck(Sender: TObject);
    procedure BorrarTodosExecute(Sender: TObject);
    procedure SeleccionarTodosExecute(Sender: TObject);
    procedure InversaExecute(Sender: TObject);
    procedure SiguienteExecute(Sender: TObject);
    procedure AnteriorExecute(Sender: TObject);
    procedure sbSeleccionarFechaClick(Sender: TObject);
    procedure MapaMouseEstado(const X, Y: Integer; const Estados: TEstados);
    procedure JvBalloonHintBalloonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GridValoresUserSort(Sender: TJvDBUltimGrid;
      var FieldsToSort: TSortFields; SortString: string; var SortOK: Boolean);
    procedure GridValoresCellClick(Column: TColumn);
    procedure SeleccionarAPosExecute(Sender: TObject);
    procedure SeleccionarANegExecute(Sender: TObject);
    procedure SeleccionarABPosExecute(Sender: TObject);
    procedure SeleccionarABNegExecute(Sender: TObject);
    procedure SeleccionarBPosExecute(Sender: TObject);
    procedure SeleccionarBNegExecute(Sender: TObject);
    procedure Seleccionar0PosExecute(Sender: TObject);
    procedure Seleccionar0NegExecute(Sender: TObject);
    procedure VerSeleccionadosExecute(Sender: TObject);
    procedure GridValoresDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    MapaValores: TMapaValores;
    ultimaX, ultimaY: integer;
    multiHint, selecting: boolean;
    paginaHint: integer;
    numPaginasHint: integer;
    numValoresHint: integer;
    FEstados: TEstados;
    procedure ValoresAfterScroll(DataSet: TDataSet);
    procedure ShowEstadoActual;
    procedure SetSesion(const Value: integer);
    procedure UpdateEstado;
    procedure MostrarHint;
  public
    property sesion: integer write SetSesion;
  end;


implementation

uses UtilDB;

const
  MAX_NUMERO_VALORES_HINT = 25;

resourcestring
  VALOR = 'valor';
  VALORES = 'valores';
  DINERO = 'Dinero';
  PAPEL = 'Papel';
  MAS_VALORES = 'Pulse aquí para ver más valores (Pág. %d/%d)';

{$R *.dfm}

procedure TfMapaValores.FormCreate(Sender: TObject);
begin
  inherited;
  MapaValores := TMapaValores.Create(Self);
  MapaValores.Valores.AfterScroll := ValoresAfterScroll;
end;

procedure TfMapaValores.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(FEstados);
end;

procedure TfMapaValores.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  selecting := ssShift in Shift;
end;

procedure TfMapaValores.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  selecting := ssShift in Shift;
end;

procedure TfMapaValores.FormShow(Sender: TObject);
begin
  inherited;
  SeleccionarTodos.Execute;
end;

procedure TfMapaValores.GridValoresCellClick(Column: TColumn);
begin
  inherited;
  if Column.Index = 0 then begin
    GridValoresDblClick(nil);
  end;
end;

procedure TfMapaValores.GridValoresDblClick(Sender: TObject);
begin
  inherited;
  if MapaValores.Valores.RecordCount > 0 then begin
    selecting := true;
    MapaValores.Seleccionar;
    UpdateEstado;
    ShowEstadoActual;
    selecting := false;
  end;
end;

procedure TfMapaValores.GridValoresUserSort(Sender: TJvDBUltimGrid;
  var FieldsToSort: TSortFields; SortString: string; var SortOK: Boolean);
begin
  inherited;
  GridValores.UnselectAll;
  MapaValores.Sort(MapaValores.Valores, FieldsToSort);
  SortOK := true;
end;

procedure TfMapaValores.SetSesion(const Value: integer);
begin
  Mapa.BorrarEstados;
  MapaValores.OIDSesion := Value;
  UpdateEstado;
end;

procedure TfMapaValores.ValoresAfterScroll(DataSet: TDataSet);
begin
  if not selecting then
    ShowEstadoActual;
end;

procedure TfMapaValores.ValoresClickCheck(Sender: TObject);
begin
  UpdateEstado;
end;

procedure TfMapaValores.VerSeleccionadosExecute(Sender: TObject);
begin
  inherited;
  GridValores.UnselectAll;
  VerSeleccionados.Checked := not VerSeleccionados.Checked;
  MapaValores.VerSeleccionados := VerSeleccionados.Checked;
end;

procedure TfMapaValores.BorrarTodosExecute(Sender: TObject);
begin
  inherited;
  MapaValores.SeleccionarNinguno(GridValores.SelectedRows);
  UpdateEstado;
  if VerSeleccionados.Checked then
    GridValores.UnselectAll;
end;

procedure TfMapaValores.Seleccionar0NegExecute(Sender: TObject);
begin
  inherited;
  GridValores.UnselectAll;
  MapaValores.SeleccionarZona('0-');
  UpdateEstado;
end;

procedure TfMapaValores.Seleccionar0PosExecute(Sender: TObject);
begin
  inherited;
  GridValores.UnselectAll;
  MapaValores.SeleccionarZona('0+');
  UpdateEstado;
end;

procedure TfMapaValores.SeleccionarABNegExecute(Sender: TObject);
begin
  inherited;
  GridValores.UnselectAll;
  MapaValores.SeleccionarZona('AB-');
  UpdateEstado;
end;

procedure TfMapaValores.SeleccionarABPosExecute(Sender: TObject);
begin
  inherited;
  GridValores.UnselectAll;
  MapaValores.SeleccionarZona('AB+');
  UpdateEstado;
end;

procedure TfMapaValores.SeleccionarANegExecute(Sender: TObject);
begin
  inherited;
  GridValores.UnselectAll;
  MapaValores.SeleccionarZona('A-');
  UpdateEstado;
end;

procedure TfMapaValores.SeleccionarAPosExecute(Sender: TObject);
begin
  inherited;
  GridValores.UnselectAll;
  MapaValores.SeleccionarZona('A+');
  UpdateEstado;
end;

procedure TfMapaValores.SeleccionarBNegExecute(Sender: TObject);
begin
  inherited;
  GridValores.UnselectAll;
  MapaValores.SeleccionarZona('B-');
  UpdateEstado;
end;

procedure TfMapaValores.SeleccionarBPosExecute(Sender: TObject);
begin
  inherited;
  GridValores.UnselectAll;
  MapaValores.SeleccionarZona('B+');
  UpdateEstado;
end;

procedure TfMapaValores.SeleccionarTodosExecute(Sender: TObject);
begin
  inherited;
  MapaValores.SeleccionarTodos(GridValores.SelectedRows);
  UpdateEstado;
end;

procedure TfMapaValores.InversaExecute(Sender: TObject);
begin
  inherited;
  MapaValores.SeleccionarInverso(GridValores.SelectedRows);
  UpdateEstado;
  if VerSeleccionados.Checked then
    GridValores.UnselectAll;
end;

procedure TfMapaValores.JvBalloonHintBalloonClick(Sender: TObject);
begin
  inherited;
  if multiHint then begin
    inc(paginaHint);
    if paginaHint > numPaginasHint - 1 then
      paginaHint := 0;
    MostrarHint;
  end;
end;

procedure TfMapaValores.MapaMouseEstado(const X, Y: Integer;
  const Estados: TEstados);
begin
  if not ((ultimaX = X) and (ultimaY = Y)) then begin
    FreeAndNil(FEstados);
    FEstados := Estados;
    numValoresHint := FEstados.Count;
    if numValoresHint > 0 then begin
      ultimaX := X;
      ultimaY := Y;
      multiHint := numValoresHint > MAX_NUMERO_VALORES_HINT;
      if multiHint then begin
        numPaginasHint := (numValoresHint div MAX_NUMERO_VALORES_HINT);
        if (numValoresHint mod MAX_NUMERO_VALORES_HINT) > 0 then
          inc(numPaginasHint);
      end;
      paginaHint := 0;
      MostrarHint;
    end;
  end;
end;


procedure TfMapaValores.MostrarHint;
var i, hasta, desde: integer;
  estado: TEstado;
  cad, cabecera, perCent: string;
begin
  desde := paginaHint * MAX_NUMERO_VALORES_HINT;
  hasta := desde + MAX_NUMERO_VALORES_HINT;
  cabecera := IntToStr(numValoresHint);
  if numValoresHint = 1 then
     cabecera := cabecera + ' ' + VALOR
  else
     cabecera := cabecera + ' ' + VALORES;
  estado := FEstados[0];
  perCent := FormatFloat('#0.00%', numValoresHint / Mapa.Estados.Count * 100);
  cabecera := cabecera + ' (' + perCent + ')';
  cabecera := cabecera + ' | ' + DINERO + ' ' + CurrToStr(estado.Dinero) +
    ' | ' + PAPEL + ' ' +
    CurrToStr(estado.Papel) + ' | ' + estado.zona;
  // zero based
  if hasta >= numValoresHint  then begin
    hasta := numValoresHint - 1;
  end;
  for i := desde to hasta do begin
    estado := FEstados[i];
    cad := cad + estado.Nombre + ' - ' + estado.Simbolo + sLineBreak;
  end;
  if multiHint then begin
    for i := hasta - desde to MAX_NUMERO_VALORES_HINT do begin
      cad := cad + sLineBreak;
    end;
    cad := cad + sLineBreak + Format(MAS_VALORES, [paginaHint + 1, numPaginasHint]);
  end;
  JvBalloonHint.ActivateHintPos(Self, Point(ultimaX + 10, ultimaY + 10), cabecera , cad, 0);
end;

procedure TfMapaValores.sbSeleccionarFechaClick(Sender: TObject);
{var fCalendario: TfCalendario;
  x, y: integer;
  p: TPoint;
  cambiar: boolean;}
begin
{  inherited;
  fCalendario := TfCalendario.Create(nil);
  try
    x := sbSeleccionarFecha.Width;
    y := sbSeleccionarFecha.Height;
    p := sbSeleccionarFecha.ClientToScreen(Point(x, y));
    fCalendario.Left := p.x  - fCalendario.Width;
    if p.y + fCalendario.Height > Screen.Height then
      fCalendario.Top := p.Y - fCalendario.Height - sbSeleccionarFecha.Height - 1
    else
      fCalendario.Top := p.y + 1;
    cambiar := fCalendario.ShowModal = mrOk;
  finally
    fCalendario.Free;
  end;
  if cambiar then
    sesion := data.dsCotizacion.DataSet.FieldByName('OR_SESION').AsInteger;}
end;

procedure TfMapaValores.UpdateEstado;
var inspect: TInspectDataSet;
begin
  selecting := true;
  try
    inspect := StartInspectDataSet(MapaValores.Valores);
    try
      JvBalloonHint.CancelHint;
      Mapa.BorrarEstados;
      MapaValores.Valores.First;
      while not MapaValores.Valores.Eof do begin
        if MapaValores.ValoresSELECCIONADO.Value then begin
          Mapa.AddEstado(MapaValores.ValoresNOMBRE.Value,
            MapaValores.ValoresSIMBOLO.Value,
            MapaValores.ValoresDINERO.Value,
            MapaValores.ValoresPAPEL.Value,
            MapaValores.ValoresZONA.Value,
            clYellow);
        end;
        MapaValores.Valores.Next;
      end;
    finally
      EndInspectDataSet(inspect);
    end;
  finally
    selecting := false;
  end;
end;

procedure TfMapaValores.SiguienteExecute(Sender: TObject);
begin
  inherited;
  GridValores.UnselectAll;
  MapaValores.DiaSiguiente;
  UpdateEstado;
end;

procedure TfMapaValores.ShowEstadoActual;
var estado: TEstado;
  p: TPoint;
  estados: TEstados;
begin
  if MapaValores.ValoresSELECCIONADO.Value then begin
    estado := Mapa.GetEstado(MapaValores.ValoresNOMBRE.Value);
    if estado <> nil then begin
      ultimaX := -1;
      ultimaY := -1;
      p := Mapa.GetXY(estado);
      estados := Mapa.GetEstadosXY(p.X, p.Y);
      MapaMouseEstado(p.X, p.Y, estados);
    end;
  end
  else
    JvBalloonHint.CancelHint;
end;

procedure TfMapaValores.AnteriorExecute(Sender: TObject);
begin
  inherited;
  GridValores.UnselectAll;
  MapaValores.DiaAnterior;
  UpdateEstado;
end;

end.
