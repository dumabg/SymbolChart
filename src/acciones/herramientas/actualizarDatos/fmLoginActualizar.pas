unit fmLoginActualizar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, dmLoginServer, StdCtrls, Buttons, ExtCtrls,
  ActnList, fmBaseServer, OleCtrls, GIFImg, frUsuario, fmLogin, frLoginServer,
  frLogin;

type
  TfLoginActualizar = class;

  TfLoginActualizar = class(TfLogin)
  private
    function GetLoginState: TLoginState;
    function GetUsuario: string;
  protected
    procedure OnLogged(Sender: TObject); virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    property LoginState: TLoginState read GetLoginState;
    property Usuario: string read GetUsuario;
  end;

implementation

{$R *.dfm}

constructor TfLoginActualizar.Create(AOwner: TComponent);
begin
  inherited;
  fLoginServer.OnLogged := OnLogged;
end;

function TfLoginActualizar.GetLoginState: TLoginState;
begin
  Result := fLoginServer.LoginState;
end;

function TfLoginActualizar.GetUsuario: string;
begin
  result := fLoginServer.Usuario;
end;


end.
