unit fmEstrategias;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBaseMasterDetalle, DB, ExtCtrls, Grids, DBGrids, JvExDBGrids,
  JvDBGrid, JvDBUltimGrid, JvExExtCtrls, JvNetscapeSplitter, dmEstrategias,
  ImgList, ActnList, StdCtrls, DBCtrls,
  DBActns, ComCtrls, Buttons,
  SynEdit,
  ScriptEstrategia, Mask, JvShape, frEditorCodigo,
  TB2Item, SpTBXItem, TB2Dock, TB2Toolbar;

type
  TfEstrategias = class(TfBaseMasterDetalle)
    Label2: TLabel;
    Descripcion: TDBMemo;
    ImageList: TImageList;
    pEstrategia: TPanel;
    Duplicar: TAction;
    TBXItem5: TSpTBXItem;
    TBXSeparatorItem1: TSpTBXSeparatorItem;
    pcEstrategia: TPageControl;
    tsDetalles: TTabSheet;
    tsCodigo: TTabSheet;
    Label1: TLabel;
    Nombre: TDBEdit;
    Label3: TLabel;
    LEDProductivo: TJvShape;
    EditorCodigo: TfEditorCodigo;
    tcTipoEstrategia: TTabControl;
    procedure FormCreate(Sender: TObject);
    procedure AnadirExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LEDProductivoClick(Sender: TObject);
    procedure BorrarExecute(Sender: TObject);
    procedure DuplicarExecute(Sender: TObject);
    procedure DuplicarUpdate(Sender: TObject);
    procedure tcTipoEstrategiaChange(Sender: TObject);
    procedure tcTipoEstrategiaChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure tsCodigoShow(Sender: TObject);
    procedure EditorCodigoCompilarExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Estrategias: TEstrategias;
    xy: TBufferCoord;
    ScriptEstrategia: TScriptEstrategia;
    procedure RecalculateLED;
    procedure BeforeScroll;
    procedure RecuperarEstrategia;
    procedure Guardar;
    procedure AfterScroll;
    function GetTipoEstrategia: TTipoEstrategia;
    function GetTabIndex(const estrategia: TTipoEstrategia): integer;
  public
    procedure IrA(const OIDEstrategia, fila, columna: integer;
      const tipoEstrategia: TTipoEstrategia);
  end;


implementation

uses fmBaseNuevo, SynEditTypes, UtilForms, dmBD;

{$R *.dfm}

resourcestring
  ESTRATEGIA_NUEVA_CAPTION = 'Estrategia nueva';
  CONFIRMACION = 'Se ha modificado el código de la estrategia.' + #13 + #13 +
      '¿Desea guardar la modificación?';
  BORRAR_ESTRATEGIA = 'La estrategia no está vacía, contiene código.' + #13 + #13 +
    '¿Desea realmente borrarla?';
  BORRAR_ESTRATEGIA_ESTUDIOS = 'No se puede borrar la estrategia porque existen ' +
    'estudios creados con esta estrategia.';
  TITULO_BORRAR = 'Borrar estrategia';

procedure TfEstrategias.AnadirExecute(Sender: TObject);
var nombre: string;
begin
  if MostrarNuevo(nombre, ESTRATEGIA_NUEVA_CAPTION, Estrategias.qEstrategiasNOMBRE.Size) then
    Estrategias.AnadirEstrategia(nombre);
end;

procedure TfEstrategias.BeforeScroll;
begin
  Guardar;
end;

procedure TfEstrategias.BorrarExecute(Sender: TObject);
begin
  if Estrategias.hasEstudios then begin
    ShowMensaje(TITULO_BORRAR, BORRAR_ESTRATEGIA_ESTUDIOS, mtConfirmation, [mbOk]);
  end
  else begin
    if Estrategias.hasEstrategia then begin
      if ShowMensaje(TITULO_BORRAR, BORRAR_ESTRATEGIA, mtConfirmation, [mbYes, mbNo]) = mrYes then
        Estrategias.Borrar;
    end
    else
      Estrategias.Borrar;
  end;
end;

procedure TfEstrategias.DuplicarExecute(Sender: TObject);
begin
  inherited;
  Estrategias.Duplicar;
  RecuperarEstrategia;
end;

procedure TfEstrategias.DuplicarUpdate(Sender: TObject);
begin
  inherited;
  Duplicar.Enabled := Borrar.Enabled;
end;

procedure TfEstrategias.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Guardar;
end;

procedure TfEstrategias.FormCreate(Sender: TObject);
begin
  inherited;
  xy := EditorCodigo.CaretXY;
  ScriptEstrategia := TScriptEstrategia.Create;
  EditorCodigo.ScriptEngine := ScriptEstrategia;
  Estrategias := TEstrategias.Create(Self);
  Estrategias.AfterScroll := AfterScroll;
  Estrategias.BeforeScroll := BeforeScroll;
end;

procedure TfEstrategias.FormDestroy(Sender: TObject);
begin
  // Al liberar Estrategias se lanza un evento de DataChange y provoca que se
  // llame a dsMasterDataChange, por lo que dará un AccessViolation.
  dsMaster.OnDataChange := nil;
  ScriptEstrategia.Free;
  inherited;
end;

procedure TfEstrategias.FormShow(Sender: TObject);
begin
  inherited;
  RecuperarEstrategia;
end;

function TfEstrategias.GetTabIndex(const estrategia: TTipoEstrategia): integer;
begin
  case estrategia of
    teApertura: result := 0;
    teAperturaPosicionado: result := 1;
    teCierre: result := 2;
    teCierrePosicionado: result := 3;
    else raise Exception.Create('Tipo de estrategia desconocido ' + IntToStr(integer(estrategia)));
  end;
end;

function TfEstrategias.GetTipoEstrategia: TTipoEstrategia;
begin
  case tcTipoEstrategia.TabIndex of
    0 : result := teApertura;
    1 : result := teAperturaPosicionado;
    2 : result := teCierre;
    3 : result := teCierrePosicionado;
    else
      raise Exception.Create('Tipo de estrategia erróneo');
  end;
end;

procedure TfEstrategias.Guardar;
begin
  if not Estrategias.IsEmpty then begin
    Estrategias.ModificarEstrategia(EditorCodigo.Codigo, GetTipoEstrategia);
    Estrategias.GuardarEstrategias;
  end;
end;

procedure TfEstrategias.IrA(const OIDEstrategia, fila, columna: integer;
  const tipoEstrategia: TTipoEstrategia);
begin
  pcEstrategia.ActivePage := tsCodigo;
  Estrategias.IrA(OIDEstrategia);
  EditorCodigo.Editor.SetFocus;
  EditorCodigo.CaretX := columna;
  EditorCodigo.CaretY := fila;
  tcTipoEstrategia.TabIndex := GetTabIndex(tipoEstrategia);
end;

procedure TfEstrategias.LEDProductivoClick(Sender: TObject);
begin
  inherited;
  Estrategias.ToggleStatus;
  RecalculateLED;
end;

procedure TfEstrategias.AfterScroll;
begin
  RecuperarEstrategia;
  RecalculateLED;
end;

procedure TfEstrategias.RecalculateLED;
begin
  if Estrategias.isProductivo then
    LEDProductivo.Brush.Color := clLime
  else
    LEDProductivo.Brush.Color := clRed;
end;

procedure TfEstrategias.RecuperarEstrategia;
var lastXY: TBufferCoord;
begin
  lastXY := EditorCodigo.CaretXY;
  EditorCodigo.Codigo := Estrategias.GetEstrategia(GetTipoEstrategia);
  EditorCodigo.Editor.Modified := false;
  EditorCodigo.CaretXY := xy;
  xy := lastXY;
end;

procedure TfEstrategias.tcTipoEstrategiaChange(Sender: TObject);
begin
  inherited;
  RecuperarEstrategia;
  if (EditorCodigo.CaretX = 1) and (EditorCodigo.CaretY = 1) then
    EditorCodigo.CaretY := 2;
end;

procedure TfEstrategias.tcTipoEstrategiaChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  inherited;
  Guardar;
  AllowChange := true;
end;

procedure TfEstrategias.tsCodigoShow(Sender: TObject);
begin
  inherited;
  if (EditorCodigo.CaretX = 1) and (EditorCodigo.CaretY = 1) then
    EditorCodigo.CaretY := 2;
end;

procedure TfEstrategias.EditorCodigoCompilarExecute(Sender: TObject);

  procedure Error(const tipoEstrategia: TTipoEstrategia);
  begin
    tcTipoEstrategia.TabIndex := GetTabIndex(tipoEstrategia);
    RecuperarEstrategia;
  end;

  function Compile(const estrategia: TTipoEstrategia): boolean;
  var codigo: string;
  begin
    codigo := Estrategias.GetEstrategia(estrategia);
    result := EditorCodigo.Compilar(codigo);
  end;

begin
  inherited;
  Guardar;
  if Compile(teApertura) then begin
    if Compile(teAperturaPosicionado) then begin
      if Compile(teCierre) then begin
        if not Compile(teCierrePosicionado) then
          Error(teCierrePosicionado);
      end
      else
        Error(teCierre);
    end
    else
      Error(teAperturaPosicionado);
  end
  else
    Error(teApertura);
end;

end.
