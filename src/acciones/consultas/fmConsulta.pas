unit fmConsulta;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, dmConsulta, DB, Grids, DBGrids, JvExDBGrids, JvDBGrid,
  JvDBUltimGrid, Tipos, ExtCtrls, UtilGrid, Menus, ActnList, ImgList, TB2Item,
  SpTBXItem, TB2Dock, TB2Toolbar;

const
  WM_IR_A_VALOR = WM_USER + 1;
type
  TfConsulta = class(TfBase)
    gConsulta: TJvDBUltimGrid;
    dsConsulta: TDataSource;
    SpTBXToolbar1: TSpTBXToolbar;
    SpTBXItem1: TSpTBXItem;
    SpTBXItem2: TSpTBXItem;
    ImageList: TImageList;
    ActionList: TActionList;
    CrearGrupo: TAction;
    CSV: TAction;
    PopupMenu: TPopupMenu;
    Creargrupo1: TMenuItem;
    CSV1: TMenuItem;
    procedure gConsultaCellClick(Column: TColumn);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure gConsultaAfterSort(Sender: TObject);
    procedure CrearGrupoExecute(Sender: TObject);
    procedure CSVExecute(Sender: TObject);
  private
    idSearch: integer;
    widthColumns: array of integer;
    hasWidthColumns: boolean;
    CaptionName: string;
    CaptionNum: string;
    Consulta: TConsulta;
    UltimaOIDSesion: integer;
    procedure OnIrAValor(var Msg: TMessage); message WM_IR_A_VALOR;
    procedure OnNewRow(var Msg: TMessage); message WM_NEW_ROW;
    procedure OnFinishSearch(var Msg: TMessage); message WM_FINISH_SEARCH;
    procedure AjustarColumnas;
    procedure OnCotizacionChange;
    procedure OnTipoCotizacionChange;
    procedure OnMercadoGrupoCambiado;
  public
    constructor Create(AOwner: TComponent; const OID: integer;
      const Valores: PArrayInteger); reintroduce;
    destructor Destroy; override;
    procedure Buscar;
  end;


implementation

uses dmData, BusCommunication, dmAccionesValor, UtilDB, fmBaseNuevo,
  dmConsultaGrupo, fmConsultaNuevoGrupo;

resourcestring
  BUSCANDO = 'Buscando... ';
  EXPORTADO = 'Exportado';
  GRUPO_CREADO = 'Nuevo grupo creado.' + sLineBreak + 'Podrá encontrarlo en Mis Grupos.';

{$R *.dfm}

{ TfConsulta }

procedure TfConsulta.AjustarColumnas;
var num, i, ancho, anchoTotal: integer;
  column: TColumn;
begin
  if Consulta.HayColumnas then begin
    num := gConsulta.Columns.Count;
    SetLength(widthColumns, num);
    Dec(num);
    anchoTotal := 0;
    for i := 0 to num do begin
      column := gConsulta.Columns[i];
      ancho := column.Field.DisplayWidth;
      widthColumns[i] := ancho;
      anchoTotal := anchoTotal + ancho;
      column.Width := ancho;
    end;
    hasWidthColumns := true;
    anchoTotal := anchoTotal + 48;
    if anchoTotal > Screen.Width then
      anchoTotal := Screen.Width - 20;
    Width := anchoTotal;
  end
  else
    Width := 100;
end;

procedure TfConsulta.Buscar;
var m: TMsg;
begin
  CrearGrupo.Enabled := false;
  CSV.Enabled := false;

  Caption := CaptionName + '. ' + BUSCANDO;
  UltimaOIDSesion := Data.OIDSesion;
  gConsulta.Enabled := False;
  dsConsulta.DataSet := nil;
  // Si hay algún mensaje lo sacamos
  while PeekMessage(m, Handle, WM_NEW_ROW, WM_NEW_ROW, PM_REMOVE) do;
  while PeekMessage(m, Handle, WM_FINISH_SEARCH, WM_FINISH_SEARCH, PM_REMOVE) do;
  Inc(idSearch);
  Consulta.Search(idSearch);
end;

procedure TfConsulta.CrearGrupoExecute(Sender: TObject);
var nombre: string;
  consultaGrupo: TConsultaGrupo;
  dataset: TDataSet;
  fConsultaNuevoGrupo: TfConsultaNuevoGrupo;
  crearGrupo: boolean;
begin
  inherited;
  consultaGrupo := TConsultaGrupo.Create(nil);
  try
    fConsultaNuevoGrupo := TfConsultaNuevoGrupo.Create(nil);
    try
      fConsultaNuevoGrupo.ConsultaGrupo := consultaGrupo;
      fConsultaNuevoGrupo.ShowModal;
      nombre := fConsultaNuevoGrupo.Nombre;
      crearGrupo := fConsultaNuevoGrupo.ModalResult = mrOk;
    finally
      fConsultaNuevoGrupo.Free;
    end;
    if crearGrupo then begin
      dataset := dsConsulta.DataSet;
      consultaGrupo.CrearGrupo(nombre, dataset, TIntegerField(dataset.FieldByName('OID_VALOR')));
      ShowMessage(GRUPO_CREADO);
    end;
  finally
    consultaGrupo.Free;
  end;
end;

constructor TfConsulta.Create(AOwner: TComponent; const OID: integer;
  const Valores: PArrayInteger);
begin
  inherited Create(AOwner);
  idSearch := Low(integer);
  Consulta := TConsulta.Create(Self);
  Consulta.HandleNotification := Handle;
  Consulta.Valores := Valores;
  Consulta.Load(OID);
  TUtilGridSort.Create(gConsulta);
  Bus.RegisterEvent(MessageCotizacionCambiada, OnCotizacionChange);
  Bus.RegisterEvent(MessageTipoCotizacionCambiada, OnTipoCotizacionChange);
  Bus.RegisterEvent(MessageMercadoGrupoCambiado, OnMercadoGrupoCambiado);
end;

procedure TfConsulta.CSVExecute(Sender: TObject);
var ugCSV: TUtilGridCSV;
begin
  inherited;
  ugCSV := TUtilGridCSV.Create(gConsulta);
  try
    ugCSV.DefaultFileName := CaptionName;
    if ugCSV.Exportar then
      ShowMessage(EXPORTADO);
  finally
    ugCSV.Free;
  end;
end;

destructor TfConsulta.Destroy;
begin
  Bus.UnregisterEvent(MessageCotizacionCambiada, OnCotizacionChange);
  Bus.UnregisterEvent(MessageTipoCotizacionCambiada, OnTipoCotizacionChange);
  Bus.UnregisterEvent(MessageMercadoGrupoCambiado, OnMercadoGrupoCambiado);
  inherited;
end;

procedure TfConsulta.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Consulta.Cancel;  
  Action := caFree;
end;

procedure TfConsulta.FormShow(Sender: TObject);
var lon: integer;
begin
  inherited;
  lon := length(Caption);
  if Caption[lon] = ')' then begin
    dec(lon);
    CaptionNum := '';
    while Caption[lon] in ['0'..'9'] do begin
      CaptionNum := Caption[lon] + CaptionNum;
      dec(lon);
    end;
    if Caption[lon] = '(' then begin
      dec(lon);
      CaptionName := Copy(Caption, 1, lon);
    end
    else begin
      CaptionNum := '?';
      CaptionName := Caption;
    end;
  end
  else begin
    CaptionNum := '?';
    CaptionName := Caption + ' ';
  end;
  Caption := CaptionName + '. ' + BUSCANDO + '(?/' + CaptionNum + ')';
end;

procedure TfConsulta.gConsultaAfterSort(Sender: TObject);
begin
  inherited;
  dsConsulta.DataSet.First;
end;

procedure TfConsulta.gConsultaCellClick(Column: TColumn);
begin
  inherited;
  PostMessage(Handle, WM_IR_A_VALOR, 0, 0);
end;

procedure TfConsulta.OnNewRow(var Msg: TMessage);
var num: integer;
  m: TMsg;
begin
  num := Msg.WParam;
  while PeekMessage(m, Handle, WM_NEW_ROW, WM_NEW_ROW, PM_REMOVE) do
    num := m.WParam;
  Caption := CaptionName + '. ' + BUSCANDO + '(' + IntToStr(num) + '/' + CaptionNum + ')';
end;

procedure TfConsulta.OnTipoCotizacionChange;
begin
  UltimaOIDSesion := -1;
  Consulta.Reset;
end;

procedure TfConsulta.OnCotizacionChange;
var i: integer;
begin
  if UltimaOIDSesion <> Data.OIDSesion then begin
    if hasWidthColumns then begin
      for i := gConsulta.Columns.Count - 1 downto 0 do
        widthColumns[i] := gConsulta.Columns[i].Width;
    end;
    UltimaOIDSesion := Data.OIDSesion;
    Buscar;
  end;
end;

procedure TfConsulta.OnFinishSearch(var Msg: TMessage);
var i: integer;
begin
  if Msg.WParam = idSearch then begin
    dsConsulta.DataSet := Consulta.Consulta;
    if hasWidthColumns then begin
      for i := gConsulta.Columns.Count - 1 downto 0 do
        gConsulta.Columns[i].Width := widthColumns[i];
    end
    else
      AjustarColumnas;

    i := Length(CaptionName) - 2;
    if Copy(CaptionName, i, 3) = '(?)' then
      CaptionName := Copy(CaptionName, 1, i - 1);
    Caption := CaptionName + '(' + IntToStr(Consulta.Count) + ')';
    gConsulta.Enabled := true;
    //Si se hace otra búsqueda, será porque se ha cambiado de sesión, por lo que
    // no se sabe el número de valores que cumplirán
    CaptionNum := '?';
  end;

  CrearGrupo.Enabled := true;
  CSV.Enabled := true;
end;


procedure TfConsulta.OnIrAValor(var Msg: TMessage);
begin
  Data.IrAValor(Consulta.ConsultaOID_VALOR.Value);
end;

procedure TfConsulta.OnMercadoGrupoCambiado;
var inspect: TInspectDataSet;
  i: integer;
  OIDValores: TArrayInteger;
begin
  SetLength(OIDValores, Data.Valores.RecordCount);
  inspect := StartInspectDataSet(Data.Valores);
  try
    i := 0;
    Data.Valores.First;
    while not Data.Valores.Eof do begin
      OIDValores[i] := Data.ValoresOID_VALOR.Value;
      Data.Valores.Next;
      inc(i);
    end;
  finally
    EndInspectDataSet(inspect);
  end;
  Consulta.Valores := @OIDValores;
  OnTipoCotizacionChange;
  Buscar;
end;

end.
