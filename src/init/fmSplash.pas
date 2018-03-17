unit fmSplash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, JvExControls,
  JvAnimatedImage, JvGIFCtrl, PngImage1, jpeg;

type
  TfSplash = class(TForm)
    Image1: TImage;
    Cargando: TJvGIFAnimator;
    lMensaje: TLabel;
    lVersion: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure CargandoStop(Sender: TObject);
  private
    procedure SetMensaje(const Value: string);
    procedure OnMessageShowedSC;
  public
    property Mensaje: string write SetMensaje;
  end;

  procedure ShowSplash;
  procedure MensajeSplash(const mensaje: string);

implementation

uses
  BusCommunication, SCMain, dmConfiguracion;

{$R *.dfm}


var splash: TfSplash;

{ TfSplash }

procedure MensajeSplash(const mensaje: string);
begin
  splash.Mensaje := mensaje;
end;

procedure ShowSplash;
begin
  splash := TfSplash.Create(Application);
  AnimateWindow(splash.Handle, 500, AW_BLEND);
end;

procedure TfSplash.FormCreate(Sender: TObject);
begin
  inherited;
  Bus.RegisterEvent(MessageSCShowed, OnMessageShowedSC);
  Cargando.Animate := true;
  lVersion.Caption := '4.4'; //Configuracion.Sistema.Version;
end;

procedure TfSplash.OnMessageShowedSC;
begin
  Visible := false;
  Cargando.Animate := false;
  Bus.UnregisterEvent(MessageSCShowed, OnMessageShowedSC);
end;

procedure TfSplash.SetMensaje(const Value: string);
begin
  lMensaje.Caption := Value;
  lMensaje.Repaint;
end;

procedure TfSplash.CargandoStop(Sender: TObject);
begin
  Close;
end;

procedure TfSplash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
  splash := nil;
end;

end.
