unit dmInternalUserServer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmInternalServer, dmLoginServer;

type
  TInternalUserServer = class(TInternalServer)
  private
    Stateless: boolean;
    Clave: string;
  protected
    procedure ConnectSincrono(const URLConnection: string; const buffer: TStream;
      const operation: string; params: TStringList; const attach: TFileName); override;
  public
    procedure AssignLoginState(const LoginState: TLoginState);
  end;


implementation

{$R *.dfm}

{ TInternalUserServer }

procedure TInternalUserServer.AssignLoginState(
  const LoginState: TLoginState);
begin
  Stateless := LoginState.Stateless;
  if Stateless then
    Clave := LoginState.Clave
//  else
//    Cookies.Assign(LoginState.Cookies);
end;

procedure TInternalUserServer.ConnectSincrono(const URLConnection: string;
  const buffer: TStream; const operation: string; params: TStringList;
  const attach: TFileName);
var freeParams: boolean;
begin
  if Stateless then begin
    if params = nil then begin
      params := TStringList.Create;
      freeParams := true;
    end
    else
      freeParams := false;
    params.Add('c=' + clave);
  end
  else
    freeParams := false;
  try
    inherited;
  finally
    if freeParams then
      params.Free;
  end;
end;


end.
