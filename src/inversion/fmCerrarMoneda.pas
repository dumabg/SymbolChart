unit fmCerrarMoneda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmCambioMoneda, StdCtrls, Buttons, frCambioMoneda, ExtCtrls;

type
  TfCerrarMoneda = class(TfCambioMoneda2)
    cbCompras: TCheckBox;
    cbVentas: TCheckBox;
  private
    function GetCompras: boolean;
    function GetVentas: boolean;
    { Private declarations }
  public
    property Compras: boolean read GetCompras;
    property Ventas: boolean read GetVentas;
  end;

implementation

{$R *.dfm}

{ TfCerrarMoneda }

function TfCerrarMoneda.GetCompras: boolean;
begin
  result := cbCompras.Checked;
end;

function TfCerrarMoneda.GetVentas: boolean;
begin
  result := cbVentas.Checked;
end;

end.
