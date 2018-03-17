unit fmEstadoCuentaCargando;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, fmBaseServer, ActnList, StdCtrls, Buttons, 
  ExtCtrls, UserMessages, ComCtrls, OleCtrls, JvExControls, 
  JvAnimatedImage, JvGIFCtrl;

type
  TfEstadoCuentaCargando = class(TfBaseServer)
    ProgressBar: TProgressBar;
    Label1: TLabel;
    Cargando: TJvGIFAnimator;
  private
  public
    procedure OnPerCent(var Msg: TMessage); message WM_PERCENT;
  end;

implementation

{$R *.dfm}

{ TfCuentaCargando }

procedure TfEstadoCuentaCargando.OnPerCent(var Msg: TMessage);
var perCent: integer;
begin
  perCent := Msg.WParam;
  ProgressBar.Position := perCent;
end;

end.
