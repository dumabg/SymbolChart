unit frLoginServer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, dmLoginServer, jpeg, ExtCtrls, frLogin;

type
  TfLoginServer = class(TframeLogin)
    cbRecordar: TCheckBox;
    procedure bIdentificarClick(Sender: TObject);
    procedure cbRecordarClick(Sender: TObject);
  private
    BeforeTryLogin: boolean;
    LoginServer: TLoginServer;
    FIsLogged: boolean;
    FOnLogged: TNotifyEvent;
    procedure CambiarEstado(const activo: boolean);
    function GetLoginState: TLoginState;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property isLogged: boolean read FIsLogged write FIsLogged;
    property OnLogged: TNotifyEvent read FOnLogged write FOnLogged;
    property LoginState: TLoginState read GetLoginState;
  end;

implementation

uses dmConfiguracion, UserServerCalls;

{$R *.dfm}

resourcestring
  ERROR_PERMISSION = 'No puede identificarse porque su usuario está desactivado.' + sLineBreak + sLineBreak +
    'Si acaba de darse de alta, recuerde que recibirá en el correo electrónico que proporcionó un ' +
    'correo para poder activar su usuario.' + sLineBreak + sLineBreak +
    'En caso de que ya hubiera realizado la activación, póngase en contacto con ' +
    'soporte (soporte@symbolchart.com) para solucionar la incidencia.';
  ERROR_USUARIO_NOT_FOUND = 'Usuario o contraseña incorrecta';

procedure TfLoginServer.bIdentificarClick(Sender: TObject);
var GUID, version: string;
begin
  try
    CambiarEstado(false);
    BeforeTryLogin := false;
    GUID := Configuracion.Sistema.GUID;
    version := Configuracion.Sistema.Version;
    try
      case LoginServer.Login(Usuario, Contrasena, GUID, version) of
        lOK: begin
          BeforeTryLogin := false;
          FIsLogged := true;
          if Assigned(FOnLogged) then
            FOnLogged(Self);
        end;
        lErrorPermission: begin
          FIsLogged := false;
          ShowMessage(ERROR_PERMISSION);
        end;
        lErrorUsuarioNotFound: begin
          FIsLogged := false;
          ShowMessage(ERROR_USUARIO_NOT_FOUND);
        end;
      end
    except
      on e: Exception do begin
        FIsLogged := false;
        raise;
      end;
    end;
  finally
    CambiarEstado(true);
  end;
end;

procedure TfLoginServer.CambiarEstado(const activo: boolean);
begin
  eUsuario.Enabled := activo;
  eContrasena.Enabled := activo;
  bIdentificar.Enabled := activo;
end;

procedure TfLoginServer.cbRecordarClick(Sender: TObject);
begin
  Configuracion.Identificacion.RellenoAutomatico := cbRecordar.Checked;
end;

constructor TfLoginServer.Create(AOwner: TComponent);
begin
  inherited;
  LoginServer := TLoginServer.Create(Self);
  if Configuracion.Identificacion.RellenoAutomatico then begin
    eUsuario.Text := Configuracion.Identificacion.Usuario;
    cbRecordar.Checked := True;
  end;
end;

destructor TfLoginServer.Destroy;
begin
  Configuracion.Identificacion.Usuario := eUsuario.Text;
  inherited;
end;

function TfLoginServer.GetLoginState: TLoginState;
begin
  result := LoginServer.LoginState;
end;

end.
