unit fmConfiguracion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  BusCommunication, fmBase, JvExControls, JvXPCore,
  JvXPButtons, ExtCtrls, ComCtrls, frModulo;

type
  TfModuloClass = class of TfModulo;

  TfConfiguracion = class(TfBase)
    Panel1: TPanel;
    bAceptar: TJvXPButton;
    bCancelar: TJvXPButton;
    tvOpciones: TTreeView;
    procedure bCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bAceptarClick(Sender: TObject);
    procedure tvOpcionesChange(Sender: TObject; Node: TTreeNode);
  private
    Instancia: array[0..7] of TfModulo;
    lastModuloVisible: TfModulo;
    procedure LoadModulo(const i: integer);
    procedure SetModulo(const Value: TfModuloClass);
  public
    property Modulo: TfModuloClass write SetModulo;
  end;

  procedure AbrirConfiguracion(const aModulo: TfModuloClass);


implementation

uses dmConfiguracion, SCMain,
  frModuloEscenarios, frModuloIdentificacion, frModuloMensajes,
  frModuloRecordatorio, frModuloVersion, frModuloVoz;

const
  Modulos: array [0..4] of TfModuloClass = //zero based, ya que las pestañas lo son
    (TfModuloEscenarios, TfModuloIdentificacion,
     TfModuloMensajes, TfModuloRecordatorio, TfModuloVoz);

{$R *.dfm}

procedure AbrirConfiguracion(const aModulo: TfModuloClass);
begin
  with TfConfiguracion.Create(nil) do begin
    try
      Modulo := aModulo;
      ShowModal;
{      if ConfiguracionFP.MustRestartApp then
        PostMessage(fSCMain.Handle, WM_CLOSE, 0, 0);}
    finally
      Free;
    end;
  end;
end;

procedure TfConfiguracion.bAceptarClick(Sender: TObject);
var i: integer;
  modulo: TfModulo;
begin
  for i := Low(Modulos) to High(Modulos) do begin
    modulo := Instancia[i];
    if modulo <> nil then begin
      if modulo.Comprobar then begin
        modulo.Guardar;
      end
      else begin
        modulo.MostrarErrores;
        exit;
      end;
    end;
  end;
  ModalResult := mrOk;
end;

procedure TfConfiguracion.bCancelarClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
  Close;
end;

{procedure TfConfiguracion.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not ConfiguracionFP.MustRestartApp then begin
    ConfiguracionFP.auAutoUpgrader.OnHostUnreachable := nil;
    if (ModalResult = mrOk) and (cbRellenar.Checked) and (Contrasena.Text <> Contrasena2.Text) then begin
      Action := caNone;
      PageControl.ActivePage := tsIdentificacion;
      ShowMessage('Las contraseña no son iguales.' + #13 + #10 +
        'Por favor, vuélvalas a escribir');
      Contrasena2.Clear;
      Contrasena.Clear;
      Contrasena.SetFocus;
    end;
  end;
end;    }

procedure TfConfiguracion.FormCreate(Sender: TObject);
var i: integer;
  tn: TTreeNode;
begin
  inherited;
  for i := Low(Modulos) to High(Modulos) do begin
    tn := tvOpciones.Items.AddChild(nil, Modulos[i].Titulo);
    tn.Data := Pointer(i);
    Instancia[i] := nil;
  end;
end;

procedure TfConfiguracion.LoadModulo(const i: integer);
var modulo: TfModulo;
begin
  inherited;
  if lastModuloVisible <> nil then
   lastModuloVisible.Visible := false;
  if Instancia[i] = nil then begin
    modulo := Modulos[i].Create(Self);
    modulo.Parent := Self;
    modulo.Align := alClient;
    Instancia[i] := modulo;
  end
  else
    Instancia[i].Visible := true;
  lastModuloVisible := Instancia[i];
end;

procedure TfConfiguracion.SetModulo(const Value: TfModuloClass);
var i, j: integer;
begin
  for i := Low(Modulos) to High(Modulos) do begin
    if Modulos[i] = Value then begin
      for j := tvOpciones.Items.Count - 1 downto 0 do begin
        if integer(tvOpciones.Items[j].Data) = i then begin
          tvOpciones.Items[j].Selected := true;
          Exit;
        end;
      end;
    end;
  end;
end;

procedure TfConfiguracion.tvOpcionesChange(Sender: TObject; Node: TTreeNode);
var i: integer;
begin
  inherited;
  i := integer(Node.Data);
  LoadModulo(i);
end;

end.
