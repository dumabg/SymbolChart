unit fmScriptError;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, dmEstrategiaInterpreter, ExtCtrls, StdCtrls, SynEdit,
  ComCtrls, Buttons, SynEditHighlighter, SynHighlighterPas, fmEstrategias, dmEstrategias;

type
  TfScriptError = class(TfBase)
    Editor: TSynEdit;
    lMensaje: TLabel;
    StatusBar: TStatusBar;
    sbEditar: TSpeedButton;
    SynPasSyn: TSynPasSyn;
    procedure lMensajeClick(Sender: TObject);
    procedure sbEditarClick(Sender: TObject);
    procedure EditorStatusChange(Sender: TObject; Changes: TSynStatusChanges);
  private
    Estrategias: TfEstrategias;
    OIDEstrategia, fila, col: integer;
    tipoEstrategia: TTipoEstrategia;
    procedure EstrategiasClose(Sender: TObject; var Action: TCloseAction);
  public
    constructor Create(AOwner: TComponent; const e: EScriptExecution;
      const OIDEstrategia: integer; const tipoEstrategia: TTipoEstrategia); reintroduce;
  end;

implementation

{$R *.dfm}

uses dmEstudioScriptError, UtilException;

{ TfEstudioScriptError }

constructor TfScriptError.Create(AOwner: TComponent;
  const e: EScriptExecution; const OIDEstrategia: integer;
  const tipoEstrategia: TTipoEstrategia);
var EstudioScriptError: TEstudioScriptError;
  posicion: string;
  mensaje: string;
begin
  inherited Create(AOwner);
  Self.OIDEstrategia := OIDEstrategia;
  Self.tipoEstrategia := tipoEstrategia;
  mensaje := e.mensaje;
  if mensaje = 'No Error' then begin
    mensaje := 'Error en el código';
    posicion := '   ';
  end
  else begin
    fila := e.fila;
    col := e.columna;
    posicion := '   en ' + IntToStr(fila) + ':' + IntToStr(col);
  end;
  lMensaje.Caption := '   ' + mensaje + sLineBreak + posicion +
    ' cuando se procesaba el valor ' + e.GetInfo('Simbolo') + ' - ' +
    e.GetInfo('Nombre') + ' (' + e.GetInfo('OIDValor') + ') del mercado ' +
    e.GetInfo('Mercado');
  EstudioScriptError := TEstudioScriptError.Create(nil, OIDEstrategia);
  try
    case TipoEstrategia of
      teApertura: Editor.Lines.Text := EstudioScriptError.qEstrategiaESTRATEGIA_APERTURA.Value;
      teAperturaPosicionado: Editor.Lines.Text := EstudioScriptError.qEstrategiaESTRATEGIA_APERTURA_POSICIONADO.Value;
      teCierre: Editor.Lines.Text := EstudioScriptError.qEstrategiaESTRATEGIA_CIERRE.Value;
      teCierrePosicionado: Editor.Lines.Text := EstudioScriptError.qEstrategiaESTRATEGIA_CIERRE_POSICIONADO.Value;
    end;
    Editor.CaretX := col;
    Editor.CaretY := fila;
    lMensaje.Hint := 'Mensaje de error. Al hacer clic se irá a la posición ' +
      posicion;
  finally
    EstudioScriptError.Free;
  end;
end;

procedure TfScriptError.EditorStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin
  inherited;
  with StatusBar, Editor do
    Panels[0].Text := IntToStr(CaretY) + ':' + IntToStr(CaretX);
end;

procedure TfScriptError.EstrategiasClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FreeAndNil(Estrategias);
end;

procedure TfScriptError.lMensajeClick(Sender: TObject);
begin
  inherited;
  Editor.CaretX := col;
  Editor.CaretY := fila;
end;

procedure TfScriptError.sbEditarClick(Sender: TObject);
begin
  inherited;
  if Estrategias = nil then begin
    Estrategias := TfEstrategias.Create(Self);
    Estrategias.OnClose := EstrategiasClose;
  end;
  Estrategias.Show;
  Estrategias.IrA(OIDEstrategia, fila, col, tipoEstrategia);
end;

end.
