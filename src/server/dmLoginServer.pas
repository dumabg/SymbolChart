unit dmLoginServer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmInternalServer, UserServerCalls, SOAPHTTPTrans, auHTTP;

type
  TLoginState = record
    stateless: boolean;
    clave: string;
    Cookies: TStringList;
  end;

  TLoginResult = UserServerCalls.TLoginUserServerCallResult;
  TLoginServer = class(TInternalServer)
  private
    FLoginState: TLoginState;
    function GetLoginState: TLoginState;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Login(usuario, password, GUID, version: string): TLoginResult;
    procedure Logout; dynamic;
    property LoginState: TLoginState read GetLoginState;
  end;

implementation

{$R *.dfm}


{ TLoginServer }

constructor TLoginServer.Create(AOwner: TComponent);
begin
  inherited;
  FLoginState.Cookies := TStringList.Create;
end;

destructor TLoginServer.Destroy;
begin
  FLoginState.Cookies.Free;
  inherited;
end;

function TLoginServer.GetLoginState: TLoginState;
begin
  result := FLoginState;
end;

function TLoginServer.Login(usuario, password, GUID, version: string): TLoginResult;
var loginCall: TLoginUserServerCall;
begin
  loginCall := TLoginUserServerCall.Create(Self);
  try
    FLoginState.Cookies.Clear;
    result := loginCall.Call(usuario, password, GUID, version);
    if result = lOK then begin
      FLoginState.stateless := loginCall.Stateless;
      if FLoginState.stateless then
        FLoginState.clave := loginCall.Clave
//      else
//        FLoginState.Cookies.Assign(Cookies);
    end;
  finally
    loginCall.Free;
  end;
end;


procedure TLoginServer.Logout;
var logoutCall: TLogoutUserServerCall;
begin
  logoutCall := TLogoutUserServerCall.Create(Self);
  try
    logoutCall.Call;
  finally
    logoutCall.Free;
  end;
end;

end.

