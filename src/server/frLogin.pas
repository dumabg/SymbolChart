unit frLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TframeLogin = class(TFrame)
    Image1: TImage;
    UsuarioLabel: TLabel;
    eUsuario: TEdit;
    ContrasenaLabel: TLabel;
    eContrasena: TEdit;
    bIdentificar: TButton;
  private
    function GetContrasena: string;
    function GetUsuario: string;
  protected
    procedure ShowUsuarioNotFound;
  published
  public
    property Usuario: string read GetUsuario;
    property Contrasena: string read GetContrasena;
  end;

implementation

{$R *.dfm}

resourcestring
  ERROR_USUARIO_NOT_FOUND = 'Usuario o contraseña incorrecta';

{ TframeLogin }

function TframeLogin.GetContrasena: string;
begin
  Result := eContrasena.Text;
end;

function TframeLogin.GetUsuario: string;
begin
  result := eUsuario.Text;
end;

procedure TframeLogin.ShowUsuarioNotFound;
begin
  ShowMessage(ERROR_USUARIO_NOT_FOUND);
end;

end.
