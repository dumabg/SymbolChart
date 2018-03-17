unit fmBaseCabeceraValor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, ExtCtrls, StdCtrls, AppEvnts;

type
  TfBaseCabeceraValor = class(TfBase)
    PanelValor: TPanel;
    lValor: TLabel;
    lSimbolo: TLabel;
    lSeparadorNombreSimbolo: TLabel;
    iBandera: TImage;
  protected
    procedure SetOIDValor(const Value: integer); virtual;
  public
    property OIDValor: integer write SetOIDValor;
  end;


implementation

uses dmDataComun;

{$R *.dfm}

{ TfBaseCabeceraValor }

procedure TfBaseCabeceraValor.SetOIDValor(const Value: integer);
var valor: PDataComunValor;
begin
  valor := DataComun.FindValor(Value);
  lValor.Caption := valor^.Nombre;
  lSimbolo.Caption := valor^.Simbolo;
  DataComun.DibujarBandera(valor^.Mercado^.OIDMercado, iBandera.Canvas, 0, 0, PanelValor.Color);
  iBandera.Invalidate;
end;

end.
