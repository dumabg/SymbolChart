unit fmExportar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, JvExControls, JvgLabel, ExtCtrls, JvExExtCtrls,
  JvWizard, JvWizardRouteMapNodes, StdCtrls, ActnList, Buttons, dmCampos,
  DBCtrls, dmExportar, JvExtComponent, JvPanel,
  fmSelectorCampos, JvLinkLabel, jpeg;

type
  TfExportar = class(TfBase)
    Wizard: TJvWizard;
    WizardRouteMap: TJvWizardRouteMapNodes;
    PageSeleccionar: TJvWizardInteriorPage;
    ActionList: TActionList;
    Abrir: TAction;
    Crear: TAction;
    PageCampos: TJvWizardInteriorPage;
    Label3: TLabel;
    Button1: TButton;
    Seleccionar: TAction;
    Label4: TLabel;
    PageExportar: TJvWizardInteriorPage;
    PageFormato: TJvWizardInteriorPage;
    cbIncluir: TCheckBox;
    Label7: TLabel;
    eSeparador: TEdit;
    Label8: TLabel;
    eComilla: TEdit;
    SaveDialog: TSaveDialog;
    Guardar: TAction;
    SaveDialogFichero: TSaveDialog;
    OpenDialog: TOpenDialog;
    aExportar: TAction;
    PageBienvenida: TJvWizardWelcomePage;
    JvgLabel1: TJvgLabel;
    JvgLabel2: TJvgLabel;
    Image1: TImage;
    PanelCrear: TJvPanel;
    ImageCrear: TImage;
    Label2: TLabel;
    PanelAbrir: TJvPanel;
    ImageAbrir: TImage;
    Label9: TLabel;
    JvPanel1: TJvPanel;
    Image2: TImage;
    Label1: TLabel;
    JvPanel2: TJvPanel;
    Image3: TImage;
    Label5: TLabel;
    JvgLabel3: TJvgLabel;
    QueEs: TJvLinkLabel;
    procedure CrearExecute(Sender: TObject);
    procedure SeleccionarExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure GuardarExecute(Sender: TObject);
    procedure AbrirExecute(Sender: TObject);
    procedure WizardCancelButtonClick(Sender: TObject);
    procedure aExportarExecute(Sender: TObject);
    procedure eSeparadorChange(Sender: TObject);
    procedure eComillaChange(Sender: TObject);
    procedure QueEsLinkClick(Sender: TObject; LinkNumber: Integer;
      LinkText, LinkParam: string);
  private
    fSelectorCampos: TfSelectorCampos;
    fSelectorCamposOnClose: TCloseEvent;
    Campos: TCampos;
    Exportar: TExportar;
    procedure ActivarAcciones(const activar: boolean);
    procedure BotonSiguientePageFormato;
    procedure OnSelectorCamposClose(Sender: TObject; var Action: TCloseAction);
  public
    { Public declarations }
  end;


implementation

uses dmConfiguracion, Web, SCMain;

const
  URL_QUE_ES_CVS = 'http://es.wikipedia.org/wiki/CSV';

resourcestring
  EXPORTACION_REALIZADA = 'Exportación realizada';

{$R *.dfm}

procedure TfExportar.AbrirExecute(Sender: TObject);
var cabecera: boolean;
  comilla, separador: string;
begin
  inherited;
  if OpenDialog.Execute then begin
    try
      fSelectorCampos.Campos := Campos;
      Exportar.AbrirFormato(OpenDialog.FileName, Campos, cabecera, separador, comilla);
      fSelectorCampos.Close;
      cbIncluir.Checked := cabecera;
      eSeparador.Text := separador;
      eComilla.Text := comilla;
      Wizard.ActivePage := PageExportar;
      PageCampos.EnableButton(bkNext, true);
    except
      on e: EFormatoIncorrecto do begin
        MessageDlg(e.Message, mtError, [mbOK], 0);
      end;
    end;
  end;
end;

procedure TfExportar.ActivarAcciones(const activar: boolean);
begin
  fSCMain.DockMenu.Enabled := activar;
end;

procedure TfExportar.aExportarExecute(Sender: TObject);
begin
  inherited;
  if SaveDialog.Execute then begin
    try
      Exportar.CrearFichero(SaveDialog.FileName, Campos, cbIncluir.Checked,
        eSeparador.Text, eComilla.Text);
      ShowMessage(EXPORTACION_REALIZADA);
      Close;
    except
      on e: EFCreateError do begin
        MessageDlg(e.Message, mtError, [mbOK], 0);
      end;
    end;
  end;
end;

procedure TfExportar.BotonSiguientePageFormato;
begin
  PageFormato.EnableButton(bkNext,
    (eSeparador.Text <> '') and (eComilla.Text <> ''));
end;

procedure TfExportar.CrearExecute(Sender: TObject);
begin
  inherited;
  Wizard.SelectNextPage;
end;


procedure TfExportar.eComillaChange(Sender: TObject);
begin
  inherited;
  BotonSiguientePageFormato;
end;

procedure TfExportar.eSeparadorChange(Sender: TObject);
begin
  inherited;
  BotonSiguientePageFormato;
end;

procedure TfExportar.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  ActivarAcciones(true);
  Action := caFree;
end;

procedure TfExportar.FormCreate(Sender: TObject);
begin
  inherited;
  ActivarAcciones(false);
  Exportar := TExportar.Create(Self);
  Campos := TCampos.Create(Self);
  fSelectorCampos := TfSelectorCampos.Create(Self);
  fSelectorCamposOnClose := fSelectorCampos.OnClose;
  // Importante!!! Hacerlo antes de asignar Campos, ya que campos lanza la
  // rutina de búsqueda de campos.
  fSelectorCampos.DataSetCampos := Exportar.qDatos;
  fSelectorCampos.OnClose := OnSelectorCamposClose;
end;

procedure TfExportar.GuardarExecute(Sender: TObject);
begin
  inherited;
  if SaveDialogFichero.Execute then begin
    Exportar.GuardarFormato(SaveDialogFichero.FileName, Campos, cbIncluir.Checked,
      eSeparador.Text, eComilla.Text);
  end;
end;

procedure TfExportar.QueEsLinkClick(Sender: TObject; LinkNumber: Integer;
  LinkText, LinkParam: string);
begin
  inherited;
  AbrirURL(URL_QUE_ES_CVS);
end;

procedure TfExportar.OnSelectorCamposClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assigned(fSelectorCamposOnClose) then
    fSelectorCamposOnClose(Sender, Action);
  Visible := true;
  Wizard.SelectNextPage;
end;

procedure TfExportar.SeleccionarExecute(Sender: TObject);
begin
  inherited;
  Visible := false;
  fSelectorCampos.Campos := Campos;
  fSelectorCampos.Show;
  PageCampos.EnableButton(bkNext, true);
end;

procedure TfExportar.WizardCancelButtonClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
