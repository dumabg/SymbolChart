unit fmPosicionMercado;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, StdCtrls, Mask, JvExMask, JvSpin, Buttons, fmBasePrecio,
  ExtCtrls, frCambioMoneda, AppEvnts, JvGIF;

type
  TfPosicionMercado = class(TfBasePrecio)
  private
    FNumAcciones: cardinal;
    FOIDMoneda: integer;
  protected
    function GetOIDMonedaBase: integer; override;
    function GetNumAcciones: integer; override;
  public
    property NumAcciones: cardinal read FNumAcciones write FNumAcciones;
    property OIDMoneda: integer read FOIDMoneda write FOIDMoneda;
  end;

implementation



{$R *.dfm}

{ TfPosicionMercado }

{ TfPosicionMercado }

function TfPosicionMercado.GetNumAcciones: integer;
begin
  result := FNumAcciones;
end;

function TfPosicionMercado.GetOIDMonedaBase: integer;
begin
  result := FOIDMoneda;
end;

end.
