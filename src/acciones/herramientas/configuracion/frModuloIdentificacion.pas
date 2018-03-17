unit frModuloIdentificacion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ExtCtrls, frModulo, JvComponentBase,
  JvErrorIndicator, ImgList, frUsuario;

type
  TfModuloIdentificacion = class(TfModulo)
    lUsuarioBloqueo: TLabel;
    lContrasena: TLabel;
    lContrasena2: TLabel;
    eUsuarioBloqueo: TEdit;
    eContrasenaBloqueo: TEdit;
    eContrasena2Bloqueo: TEdit;
    cbObligatorio: TCheckBox;
    cbRellenar: TCheckBox;
    fUsuario1: TfUsuario;
    lUsuario: TLabel;
    eUsuario: TEdit;
    cbBloquear: TCheckBox;
    procedure cbRellenarClick(Sender: TObject);
    procedure cbBloquearClick(Sender: TObject);
  private
    procedure EstadoRellenar;
    procedure EstadoBloquear;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Guardar; override;
    function Comprobar: boolean; override;
    class function Titulo: string; override;
  end;

implementation

uses dmLoginServer, dmConfiguracion, ServerURLs, Web;

resourcestring
  TITULO_MODULO = 'Identificación';

{$R *.dfm}

resourcestring
  ERROR_CONTRASENAS_DIFERENTES = 'Las contraseñas no son iguales';
  ERROR_USUARIO_BLOQUEO = 'Debe especificarse un nombre de usuario';

function TfModuloIdentificacion.Comprobar: boolean;
begin
  inherited Comprobar;
  if cbBloquear.Checked then begin
    result := eContrasenaBloqueo.Text = eContrasena2Bloqueo.Text;
    if not result then begin
      JvErrorIndicator.Error[eContrasenaBloqueo] := ERROR_CONTRASENAS_DIFERENTES;
      JvErrorIndicator.Error[eContrasena2Bloqueo] := ERROR_CONTRASENAS_DIFERENTES;
    end
    else begin
      result := Trim(eUsuarioBloqueo.Text) <> '';
      if not Result then
        JvErrorIndicator.Error[eUsuarioBloqueo] := ERROR_USUARIO_BLOQUEO;
    end;
  end
  else begin
    if cbRellenar.Checked then begin
      result := Trim(eUsuario.Text) <> '';
      if not result then
        JvErrorIndicator.Error[eUsuario] := ERROR_USUARIO_BLOQUEO;
    end
    else
      Result := True;
  end;
end;

procedure TfModuloIdentificacion.cbBloquearClick(Sender: TObject);
begin
  inherited;
  EstadoBloquear;
end;

procedure TfModuloIdentificacion.cbRellenarClick(Sender: TObject);
begin
  inherited;
  EstadoRellenar;
end;

constructor TfModuloIdentificacion.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  eUsuario.Text := Configuracion.Identificacion.Usuario;
  eUsuarioBloqueo.Text := Configuracion.Identificacion.UsuarioBloquear;
  eContrasenaBloqueo.Text := Configuracion.Identificacion.ContrasenaBloquear;
  eContrasena2Bloqueo.Text := eContrasenaBloqueo.Text;
  cbBloquear.Checked := Configuracion.Identificacion.Bloquear;
  cbObligatorio.Checked := Configuracion.Identificacion.AlEntrar;
  cbRellenar.Checked := Configuracion.Identificacion.RellenoAutomatico;
  EstadoBloquear;
  EstadoRellenar;
end;

procedure TfModuloIdentificacion.EstadoBloquear;
begin
  lUsuarioBloqueo.Enabled := cbBloquear.Checked;
  lContrasena.Enabled := cbBloquear.Checked;
  lContrasena2.Enabled := cbBloquear.Checked;
  cbObligatorio.Enabled := cbBloquear.Checked;
  eUsuarioBloqueo.Enabled := cbBloquear.Checked;
  eContrasenaBloqueo.Enabled := cbBloquear.Checked;
  eContrasena2Bloqueo.Enabled := cbBloquear.Checked;
end;

procedure TfModuloIdentificacion.EstadoRellenar;
begin
  lUsuario.Enabled := cbRellenar.Checked;
  eUsuario.Enabled := cbRellenar.Checked;
end;

procedure TfModuloIdentificacion.Guardar;
begin
  Configuracion.Identificacion.Usuario := eUsuario.Text;
  Configuracion.Identificacion.UsuarioBloquear := eUsuarioBloqueo.Text;
  Configuracion.Identificacion.ContrasenaBloquear := eContrasenaBloqueo.Text;
  Configuracion.Identificacion.Bloquear := cbBloquear.Checked;
  Configuracion.Identificacion.AlEntrar := cbObligatorio.Checked;
  Configuracion.Identificacion.RellenoAutomatico := cbRellenar.Checked;
end;

class function TfModuloIdentificacion.Titulo: string;
begin
  result := TITULO_MODULO;
end;

end.
