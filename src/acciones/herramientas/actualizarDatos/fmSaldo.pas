unit fmSaldo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, ActnList, StdCtrls, Buttons, ExtCtrls,
  dmSaldo, dmLoginServer, JvExControls,
  JvGIFCtrl, Grids, DBGrids, DBCtrls, ComCtrls,
  JvExComCtrls, JvComCtrls,
  DB, JvAnimatedImage, JvExDBGrids, JvDBGrid, JvDBUltimGrid, GIFImg, JvGIF,
  JvExExtCtrls, JvImage, JvGradient, JvXPCore, JvXPButtons, fmBaseServer;

type
  TfSaldo = class(TfBaseServer)
    JvPageControl: TJvPageControl;
    tsConsultando: TTabSheet;
    tsSaldo: TTabSheet;
    tsSinBonos: TTabSheet;
    pConsultandoDatos: TPanel;
    Shape1: TShape;
    lConsultandoDatos: TLabel;
    Cargando: TJvGIFAnimator;
    ImagenError: TImage;
    ImagenInfo: TImage;
    pSinBono: TPanel;
    Label1: TLabel;
    Image2: TImage;
    Label6: TLabel;
    urlAqui: TLabel;
    Label3: TLabel;
    JvGradient1: TJvGradient;
    pSusCreditos: TJvGradient;
    lDisp: TLabel;
    lDescDiarios: TLabel;
    lFechaDiarios: TLabel;
    lFechaSemanal: TLabel;
    lDescSemanal: TLabel;
    lDisponibles: TLabel;
    urlAdquirir: TLabel;
    lCosteDiario: TLabel;
    Label5: TLabel;
    lCosteSemanal: TLabel;
    lCaducanDesc: TLabel;
    lCaducidad: TLabel;
    lTituloDisp: TLabel;
    cbDiarios: TCheckBox;
    cbSemanales: TCheckBox;
    bDescargar: TBitBtn;
    bCancelar: TBitBtn;
    bHecho: TBitBtn;
    Label2: TLabel;
    lDias: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    procedure bCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure dsBonosDataChange(Sender: TObject; Field: TField);
    procedure urlAdquirirClick(Sender: TObject);
    procedure cbDiariosClick(Sender: TObject);
    procedure OnClickDatosDiarios(Sender: TObject);
    procedure OnClickDatosSemanales(Sender: TObject);
    procedure bHechoClick(Sender: TObject);
    procedure urlAquiClick(Sender: TObject);
  private
    FData: TSaldo;
    yaCreados: boolean;
    cancelado: boolean;
    LoginState: TLoginState;
    usuario: string;
    procedure Cancelar;
    procedure ErrorConsultando(const msg: string);
    procedure OnLoadData(Sender: TObject);
    function GetDiario: boolean;
    function GetSemanal: boolean;
  protected
    procedure DoShow; override;
  public
    constructor Create(AOwner: TComponent; LoginState: TLoginState; const usuario: string); reintroduce;
    property Diario: boolean read GetDiario;
    property Semanal: boolean read GetSemanal;
  end;


implementation

uses Web, dmInternalServer, ServerURLs, dmConfiguracion, UserServerCalls,
  UtilThread, DateUtils;

type
  TConnectionError = (ceConnectionLost, ceDataFileException, ceConnection, ceException);

  TSaldoThread = class(TProtectedThread)
  private
    Data: TSaldo;
    FFormSaldo: TfSaldo;
    FLoginState: TLoginState;
    FError: boolean;
    FTipoError: TConnectionError;
    FMsgError: string;
  protected
    procedure InternalCancel; override;
    procedure FreeResources; override;
    procedure InternalExecute; override;
  public
    property FormSaldo: TfSaldo read FFormSaldo write FFormSaldo;
    property LoginState: TLoginState read FLoginState write FLoginState;
    property Error: boolean read FError write FError;
    property TipoError: TConnectionError read FTipoError;
    property MsgError: string read FMsgError write FMsgError;
  end;

var loader: TSaldoThread;

resourcestring
 MSG_SERVER_AL_DIA = 'No hay ningún cambio pendiente. Está al día.';
 MSG_SERVER_SERVIDOR_NO_DISPONIBLE = 'El servidor no está disponible en estos ' +
   'momentos. Vuelva a intentarlo más tarde.';
 MSG_SERVER_COMUMINICACION_CORTADA = 'Se ha cortado la comunicación con el ' +
  'servidor y no se han podido recibir todos los datos. Vuelva a intentarlo.';
 MSG_SERVER_ERROR = 'No se han podido recuperar los datos.';
 MSG_CANCELANDO = 'Cancelando, espere un momento por favor.';
 CREDITO = 'crédito';

{$R *.dfm}


procedure TfSaldo.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  CanClose := loader = nil;
  if not CanClose then
    Cancelar;
end;

procedure TfSaldo.FormCreate(Sender: TObject);
begin
  inherited;
  JvPageControl.ActivePage :=  tsConsultando;
end;

function TfSaldo.GetDiario: boolean;
begin
  Result := cbDiarios.Checked;
end;

function TfSaldo.GetSemanal: boolean;
begin
  result := cbSemanales.Checked;
end;

procedure TfSaldo.ErrorConsultando(const msg: string);
begin
  lConsultandoDatos.Caption := msg;
  lConsultandoDatos.Font.Color := clRed;
  Cargando.Visible := false;
  bCancelar.Visible := true;
  ImagenError.Top := bCancelar.Top - 5;
  ImagenError.Visible := true;
end;

procedure TfSaldo.DoShow;
begin
  inherited;
  Cargando.Animate := true;
  loader := TSaldoThread.Create(true);
  loader.FormSaldo := Self;
  loader.LoginState := LoginState;
  loader.FreeOnTerminate := true;
  loader.OnTerminate := OnLoadData;
  loader.Resume;
end;

procedure TfSaldo.OnClickDatosDiarios(Sender: TObject);
begin
  cbDiarios.Checked := not cbDiarios.Checked;
  cbDiariosClick(Sender);
end;

procedure TfSaldo.OnClickDatosSemanales(Sender: TObject);
begin
  cbSemanales.Checked := not cbSemanales.Checked;
  cbDiariosClick(Sender);
end;

procedure TfSaldo.OnLoadData(Sender: TObject);
var dataLoader: TSaldoThread;
  status: TStatusResult;
  coste, dias: integer;
  cad: string;
  caducidad: TDateTime;
begin
  if cancelado then begin
    // Importante, sino al hacer el CanClose no vale nil y no sale
    loader := nil;
    Close;
  end
  else begin
    dataLoader := Sender as TSaldoThread;
    if dataLoader.Error then begin
      case dataLoader.TipoError of
        ceConnectionLost: ErrorConsultando(MSG_SERVER_COMUMINICACION_CORTADA);
        ceDataFileException: ErrorConsultando(MSG_SERVER_COMUMINICACION_CORTADA);
        ceConnection: ErrorConsultando(MSG_SERVER_SERVIDOR_NO_DISPONIBLE);
        ceException: ErrorConsultando(MSG_SERVER_ERROR);
      end;
    end
    else begin
      status := FData.Status;
      case status of
        srError: begin
          ErrorConsultando(MSG_SERVER_ERROR);
        end;
        srAlDia: begin
          Cargando.Visible := false;
          lConsultandoDatos.Caption := MSG_SERVER_AL_DIA;
          bHecho.Top := bCancelar.Top;
          bCancelar.Visible := false;
          bHecho.Visible := true;
          ImagenInfo.Top := bHecho.Top;
          ImagenInfo.Visible := true;
        end;
        srSinCredito: begin
          JvPageControl.ActivePage := tsSinBonos;
        end;
        srDatos: begin
          lDisponibles.Caption := IntToStr(FData.Creditos);
          caducidad := FData.FechaCaducidad;
          lCaducidad.Caption := DateToStr(caducidad);
          dias := DaysBetween(now, caducidad);
          lDias.Caption := IntToStr(dias);
          if FData.HayDiario then begin
            lFechaDiarios.Caption := DateToStr(FData.FechaDiario);
            coste := FData.CosteDiario;
            cad := IntToStr(coste) + ' ' + CREDITO;
            if coste > 1 then
              cad := cad + 's';
            lCosteDiario.Caption := cad;
            lCosteDiario.Visible := true;
            cbDiarios.Visible := true;
          end
          else begin
            lCosteDiario.Visible := false;
            cbDiarios.Visible := false;
          end;
          if FData.HaySemanal then begin
            lFechaSemanal.Caption := DateToStr(FData.FechaSemanal);
            coste := FData.CosteSemanal;
            cad := IntToStr(coste) + ' ' + CREDITO;
            if coste > 1 then
              cad := cad + 's';
            lCosteSemanal.Caption := cad;
            cbSemanales.Visible := true;
          end
          else begin
            lCosteSemanal.Visible := false;
            cbSemanales.Visible := false;
          end;
          JvPageControl.ActivePage := tsSaldo;
        end;
      end;
    end;
    yaCreados := true;
    loader := nil;
  end;
//  Cargando.Animate := false;
  Cargando.Free;
end;


procedure TfSaldo.urlAdquirirClick(Sender: TObject);
begin
  inherited;
  AbrirURL(Configuracion.Sistema.URLServidor + URL_RECARGAR + '?user=' + usuario);
end;

procedure TfSaldo.urlAquiClick(Sender: TObject);
begin
  inherited;
  urlAdquirirClick(Sender);
end;

procedure TfSaldo.bCancelarClick(Sender: TObject);
begin
  inherited;
  if loader = nil then
    Close
  else
    Cancelar;
end;

procedure TfSaldo.bHechoClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TfSaldo.Cancelar;
begin
  cancelado := true;
  bCancelar.Enabled := false;
  if loader <> nil then begin
    loader.Cancel;
  end;
  ErrorConsultando(MSG_CANCELANDO);
end;

procedure TfSaldo.cbDiariosClick(Sender: TObject);
begin
  inherited;
  bDescargar.Enabled := cbDiarios.Checked or cbSemanales.Checked;
end;

constructor TfSaldo.Create(AOwner: TComponent; LoginState: TLoginState;
  const usuario: string);
begin
  inherited Create(AOwner);
  Self.LoginState := LoginState;
  Self.usuario := usuario;
  yaCreados := false;
end;


procedure TfSaldo.dsBonosDataChange(Sender: TObject; Field: TField);
begin
  inherited;
end;

{ TSaldoThread }

procedure TSaldoThread.InternalExecute;
begin
  Data := TSaldo.Create(nil);
  Data.AssignLoginState(LoginState);
  try
    Data.LoadData;
    FError := false;
  except
    on e: EConnectionRead do begin
      FTipoError := ceConnectionLost;
      FError := true;
    end;
    on e: EDataFile do begin
      FTipoError := ceDataFileException;
      FError := true;
    end;
    on e: EConnection do begin
      FTipoError := ceConnection;
      FError := true;
    end;
    on e: EConnectionStatus do begin
      FTipoError := ceConnection;
      FError := true;
    end;
    on e: Exception do begin
      FTipoError := ceException;
      FMsgError := e.ClassName + ': ' + e.Message;
      FError := true;
    end;
  end;
  FFormSaldo.FData := Data;
end;

procedure TSaldoThread.FreeResources;
begin
  inherited;
  if Data <> nil then
    Data.Free;
end;

procedure TSaldoThread.InternalCancel;
begin
  if Data <> nil then
    Data.Cancel;
end;


end.
