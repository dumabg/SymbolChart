unit fmMultiCerrarPosicion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmCerrarPosicion, ComCtrls, StdCtrls, Buttons, frCambioMoneda, Mask,
  JvExMask, JvSpin, ExtCtrls, JvGIF;

type
  TfMultiCerrarPosicion = class(TfCerrarPosicion)
    bNoCerrarla: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

end.
