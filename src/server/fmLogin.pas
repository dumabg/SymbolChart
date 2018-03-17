unit fmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, frUsuario, frLoginServer, dmLoginServer, frLogin;

type
  TfLogin = class(TfBase)
    fLoginServer: TfLoginServer;
    fUsuario: TfUsuario;
  private
    FCloseOnLogged: boolean;
    function GetIsLogged: boolean;
    function GetLoginState: TLoginState;
    procedure OnLogged(Sender: TObject);
    procedure SetCloseOnLogged(const Value: boolean);
  protected
    procedure DoShow; override;
  public
    property IsLogged: boolean read GetIsLogged;
    property LoginState: TLoginState read GetLoginState;
    property CloseOnLogged: boolean read FCloseOnLogged write SetCloseOnLogged;
  end;

implementation

{$R *.dfm}

{ TfLogin }

function TfLogin.GetIsLogged: boolean;
begin
  result := fLoginServer.isLogged;
end;

function TfLogin.GetLoginState: TLoginState;
begin
  result := fLoginServer.LoginState;
end;

procedure TfLogin.DoShow;
begin
  inherited;
  if fLoginServer.Usuario = '' then
    fLoginServer.eUsuario.SetFocus
  else
    fLoginServer.eContrasena.SetFocus;
end;

procedure TfLogin.OnLogged(Sender: TObject);
begin
  Close;
end;

procedure TfLogin.SetCloseOnLogged(const Value: boolean);
begin
  FCloseOnLogged := Value;
  if FCloseOnLogged then
    fLoginServer.OnLogged := OnLogged
  else
    fLoginServer.OnLogged := nil;  
end;

end.
