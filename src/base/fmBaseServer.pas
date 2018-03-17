unit fmBaseServer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, Buttons, ExtCtrls,
  ActnList, dmInternalServer, OleCtrls, UserMessages;

type
  TTerminateEvent = procedure (Sender: TObject; e: Exception) of object;

  TfBaseServer = class(TfBase)
    procedure CancelarExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FOnConnect: TNotifyEvent;
    FServer: TInternalServer;
    FCloseOnCancel: boolean;
    procedure SetServer(const Value: TInternalServer);
    procedure CancelCurrentOperationMessage(var Msg: TMessage); message WM_CANCEL_CURRENT_OPERATION;
  protected
    FURLBase: string;
    procedure OnCancelCurrentOperation; virtual;
    procedure OnTerminate(Sender: TObject; e: Exception); virtual;
    procedure OnConnect(Sender: TObject); virtual;
  public
    property CloseOnCancel: boolean read FCloseOnCancel write FCloseOnCancel;
    property Server: TInternalServer read FServer write SetServer;
  end;

implementation

{$R *.dfm}
uses dmConfiguracion;

procedure TfBaseServer.OnTerminate(Sender: TObject; e: Exception);
begin
end;

procedure TfBaseServer.SetServer(const Value: TInternalServer);
begin
  FServer := Value;
  FOnConnect := FServer.OnConnect;
  FServer.OnConnect := OnConnect;
end;

procedure TfBaseServer.OnConnect(Sender: TObject);
begin
  if Assigned(FOnConnect) then
    FOnConnect(Sender);
end;

procedure TfBaseServer.CancelarExecute(Sender: TObject);
begin
  inherited;
  FServer.CancelCurrentOperation;
  PostMessage(Handle, WM_CANCEL_CURRENT_OPERATION, 0, 0);
end;

procedure TfBaseServer.OnCancelCurrentOperation;
begin
end;

procedure TfBaseServer.CancelCurrentOperationMessage(var Msg: TMessage);
begin
  OnCancelCurrentOperation;
  if FCloseOnCancel then
    PostMessage(Handle, WM_CLOSE, 0, 0);
end;

procedure TfBaseServer.FormCreate(Sender: TObject);
begin
  inherited;
  FURLBase := Configuracion.Sistema.URLServidor;
end;

end.
