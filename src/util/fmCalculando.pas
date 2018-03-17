unit fmCalculando;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, Buttons, StdCtrls, JvExControls, JvAnimatedImage,
  JvGIFCtrl, ExtCtrls, eventos;

type
  TfrCalculando = class(TFrame)
    pCargando: TPanel;
    GIFCargando: TJvGIFAnimator;
    lMensaje: TLabel;
    lDescripcion: TLabel;
    sbCancelar: TSpeedButton;
    ProgressBar: TProgressBar;
    procedure sbCancelarClick(Sender: TObject);
  private
    FOnCancelar: TNotificacionEvent;
    function GetMensaje: string;
    procedure SetMensaje(const Value: string);
    function GetDescripcion: string;
    procedure SetDescripcion(const Value: string);
  protected
//    procedure CMShowingChanged(var M: TMessage); message CM_SHOWINGCHANGED;
  public
    procedure Stop;
    procedure Start;
    constructor Create(AOwner: TComponent); override;
    property Mensaje: string read GetMensaje write SetMensaje;
    property Descripcion: string read GetDescripcion write SetDescripcion;
    property OnCancelar: TNotificacionEvent read FOnCancelar write FOnCancelar;
  end;

implementation

{$R *.dfm}

{ TFrame2 }

{procedure TfrCalculando.CMShowingChanged(var M: TMessage);
begin
  inherited;
  GIFCargando.Animate := Showing;
end;}

constructor TfrCalculando.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  lDescripcion.Caption := '';
end;

function TfrCalculando.GetDescripcion: string;
begin
  result := lDescripcion.Caption;
end;

function TfrCalculando.GetMensaje: string;
begin
  result := lMensaje.Caption;
end;

procedure TfrCalculando.sbCancelarClick(Sender: TObject);
begin
  GIFCargando.Animate := false;
  if Assigned(FOnCancelar) then
    FOnCancelar;
end;

procedure TfrCalculando.SetDescripcion(const Value: string);
begin
  lDescripcion.Caption := Value;
end;

procedure TfrCalculando.SetMensaje(const Value: string);
begin
  lMensaje.Caption := Value;
end;

procedure TfrCalculando.Start;
begin
  GIFCargando.Animate := true;
  sbCancelar.Enabled := true;
end;

procedure TfrCalculando.Stop;
begin
  GIFCargando.Animate := false;
  sbCancelar.Enabled := false;
end;

end.
