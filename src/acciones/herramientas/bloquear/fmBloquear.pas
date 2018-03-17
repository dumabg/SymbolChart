unit fmBloquear;

interface

uses
  Windows, fmLogin, StdCtrls, frUsuario, Classes, Controls, Forms, frLoginServer,
  jpeg, ExtCtrls, frLogin;

type
  TfBloquear = class(TForm)
    bCerrar: TButton;
    fLogin: TframeLogin;
    procedure bCerrarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fLoginbIdentificarClick(Sender: TObject);
  private
    FCerrarAplicacion: boolean;
    FIsLogged: boolean;
  public
    property CerrarAplicacion: boolean read FCerrarAplicacion;
    property IsLogged: boolean read FIsLogged;
  end;


implementation

uses dmConfiguracion, Dialogs;

resourcestring
  ERROR_USUARIO_NOT_FOUND = 'Usuario o contraseña incorrecta';
{$R *.dfm}

procedure TfBloquear.bCerrarClick(Sender: TObject);
begin
  inherited;
  FCerrarAplicacion := true;
  Close;
end;


procedure TfBloquear.fLoginbIdentificarClick(Sender: TObject);
begin
  if (Configuracion.Identificacion.UsuarioBloquear <> fLogin.Usuario) or
    (Configuracion.Identificacion.ContrasenaBloquear <> fLogin.Contrasena) then begin
     ShowMessage(ERROR_USUARIO_NOT_FOUND);
  end
  else begin
    FIsLogged := true;
    Close;
  end;
end;

procedure TfBloquear.FormCreate(Sender: TObject);
begin
  inherited;
  FIsLogged := false;
end;


end.
