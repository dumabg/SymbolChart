unit fmActualizarDatos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, StdCtrls, Buttons, ExtCtrls, dmActualizarDatos,
  ComCtrls, ActnList, UserMessages, dmLoginServer, DB, GIFImg, fmBaseServer,
  Grids, DBGrids, JvExDBGrids, JvDBGrid, JvDBUltimGrid, JvExComCtrls, JvComCtrls;

const
  WM_ACTUALIZAR_DATOS = WM_USER + 2;

type
  EActualizar = class(Exception);

  TfActualizarDatos = class(TfBaseServer)
    LabelObteniendo: TLabel;
    LabelImportando: TLabel;
    ImageObteniendo: TImage;
    ImageImportando: TImage;
    OperacionEnCursoImage: TImage;
    ProgressBarDescargar: TProgressBar;
    Shape2: TShape;
    ProgressBarImportar: TProgressBar;
    bHecho: TBitBtn;
    bCancelar: TBitBtn;
    JvPageControl: TJvPageControl;
    tsActualizando: TTabSheet;
    tsModificaciones: TTabSheet;
    gModificaciones: TJvDBUltimGrid;
    pStatus: TPanel;
    Shape1: TShape;
    ImageInfo: TImage;
    ImagenError: TImage;
    Mensaje: TLabel;
    dsModificaciones: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TimerCancelarTimer(Sender: TObject);
    procedure bCancelarClick(Sender: TObject);
  private
    ActualidarDone: boolean;
    FLoginState: TLoginState;
    ActualizarDatos: TActualizarDatos;
    ProgressBar: TProgressBar;
    FDiario, FSemanal: boolean;
    procedure Cancelar;
  protected
    procedure OnPerCent(var Msg: TMessage); message WM_PERCENT;
    procedure OnActualizarDatos(var Msg: TMessage); message WM_ACTUALIZAR_DATOS;
    procedure OnModificaciones(Sender: TObject);
  public
    constructor Create(AOwner: TComponent; LoginState: TLoginState;
      const diario, semanal: boolean); reintroduce;
  end;


implementation

uses dmInternalServer, UtilThread, dmImportarDatos;

{$R *.dfm}

resourcestring
  MENSAJE_ERROR_SERVIDOR = 'Servidor no disponible en estos momentos. Inténtelo más tarde.' +
    sLineBreak + 'No se ha descontado ningún crédito.';
  MENSAJE_ERROR = 'No se han actualizado los datos porque se ha producido un error.' + sLineBreak +
    'No se ha descontado ningún crédito.';
  MENSAJE_ABORTADO = 'Actualización abortada por el usuario.' + sLineBreak +
    'No se ha descontado ningún crédito.';
  MENSAJE_ABORTADO_MODIFICACIONES = 'Modificaciones generales canceladas. Datos actualizados correctamente.' + sLineBreak +
    'Las modificaciones generales pendientes se incluirán en la próxima descarga.';
  MENSAJE_ACTUALIZACION_CORRECTA  = 'Actualización completada con éxito.';
  MENSAJE_CONEXION_PERDIDA = 'Se ha perdido la conexión con el servidor y no se han podido recibir todos los datos.' +
    sLineBreak + 'No se ha descontado ningún crédito.';
  MENSAJE_OPERACIONES = 'Existían modificaciones generales pendientes. Modificaciones aplicadas.';
  MENSAJE_CANCELANDO = 'Cancelando, espere un momento por favor.';
  MENSAJE_MODIFICACIONES_PENDIENTES = 'Aplicando modificaciones generales pendientes.';
  MENSAJE_ERROR_MODIFICACIONES = 'Se ha producido un error aplicando modificaciones generales,' + sLineBreak +
    'pero los datos se han actualizado de forma correcta.';
  ERROR_IMPORTAR_MODIFICACIONES = 'Se ha producido un error cuando se realizaban modificaciones generales.' + sLineBreak +
    'Los datos se han actualizado de forma correcta, por lo que podrá consultarlos de forma normal.' + sLineBreak + sLineBreak +
    'A continuación se mostrará una pantalla de error con información sobre el error ocurrido.' + sLineBreak +
    'Sería de gran utilidad enviar el informe de error para poder subsanarlo en la próxima descarga.';


procedure TfActualizarDatos.OnPerCent(var Msg: TMessage);
var perCent: integer;
begin
  perCent := Msg.WParam;
  ProgressBar.Position := perCent;
end;

procedure TfActualizarDatos.TimerCancelarTimer(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfActualizarDatos.bCancelarClick(Sender: TObject);
begin
  inherited;
  Cancelar;
end;

procedure TfActualizarDatos.Cancelar;
begin
  bCancelar.Enabled := false;
  ImagenError.Visible := true;
  Mensaje.Caption := MENSAJE_CANCELANDO;
  ActualizarDatos.Cancel;
end;

constructor TfActualizarDatos.Create(AOwner: TComponent;
  LoginState: TLoginState; const diario, semanal: boolean);
begin
  inherited Create(AOwner);
  FDiario := diario;
  FSemanal := semanal;
  FLoginState := LoginState;
  JvPageControl.ActivePage := tsActualizando;
end;

procedure TfActualizarDatos.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  CanClose := ActualidarDone;
end;

procedure TfActualizarDatos.FormCreate(Sender: TObject);
begin
  inherited;
  bHecho.Top := bCancelar.Top;
end;

procedure TfActualizarDatos.FormShow(Sender: TObject);
begin
  inherited;
  ActualizarDatos := TActualizarDatos.Create(Self, FDiario, FSemanal, Handle, OnModificaciones);
  PostMessage(Handle, WM_ACTUALIZAR_DATOS, 0, 0);
end;

procedure TfActualizarDatos.OnActualizarDatos(var Msg: TMessage);
begin
  try
    LabelObteniendo.Font.Style := LabelObteniendo.Font.Style + [fsBold];
    ProgressBar := ProgressBarDescargar;

    try
      bCancelar.Visible := true;
      ActualizarDatos.DescargarDatos(FLoginState);

      ImageObteniendo.Visible := true;
      ProgressBar.Position := ProgressBar.Max;

      OperacionEnCursoImage.Top := LabelImportando.Top;
      LabelImportando.Font.Style := LabelImportando.Font.Style + [fsBold];

      ProgressBar := ProgressBarImportar;
      ActualizarDatos.ImportarDatos(FLoginState);

      bCancelar.Enabled := false;
      ProgressBar.Position := ProgressBar.Max;
      ImageImportando.Visible := true;
      OperacionEnCursoImage.Visible := false;
      {                   if dmActualizar.Operaciones.RecordCount > 0 then begin
        Mensaje.Caption := MENSAJE_ACTUALIZACION_CORRECTA + #13 +
                           MENSAJE_OPERACIONES;
        bVerModificaciones.Visible := true;
      end
      else}
        Mensaje.Caption := MENSAJE_ACTUALIZACION_CORRECTA;
      ImageInfo.Visible := true;
    except
      on e: EAbort do begin
        ImagenError.Visible := true;
        if JvPageControl.ActivePage = tsModificaciones then
          Mensaje.Caption := MENSAJE_ABORTADO_MODIFICACIONES
        else
          Mensaje.Caption := MENSAJE_ABORTADO;
      end;
      on e: Exception do begin
        if JvPageControl.ActivePage = tsModificaciones then begin
          Mensaje.Caption := MENSAJE_ERROR_MODIFICACIONES;
          ImageInfo.Visible := true;
          ShowMessage(ERROR_IMPORTAR_MODIFICACIONES);
        end
        else begin
          Mensaje.Caption := MENSAJE_ERROR;
          ImagenError.Visible := true;
        end;
        raise;
      end;
    end;
  finally
    ActualidarDone := true;
    bCancelar.Visible := false;
    bHecho.Visible := true;
    gModificaciones.Enabled := true;
  end;
end;



procedure TfActualizarDatos.OnModificaciones(Sender: TObject);
begin
  JvPageControl.ActivePage := tsModificaciones;
  Mensaje.Caption := MENSAJE_MODIFICACIONES_PENDIENTES;
  Application.ProcessMessages;
end;

end.
