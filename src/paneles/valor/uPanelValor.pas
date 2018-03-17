unit uPanelValor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uPanelNotificaciones, DB, ExtCtrls, StdCtrls, DBCtrls, TB2Item,
  TB2Dock, TB2Toolbar, SpTBXItem;

type
  TfrPanelValor = class(TfrPanelNotificaciones)
    ToolbarValor: TSpTBXToolbar;
    TBControlItem2: TTBControlItem;
    PanelValor: TPanel;
    Valor: TDBText;
    Simbolo: TDBText;
    lSeparadorNombreSimbolo: TLabel;
    iBandera: TImage;
    dsValores: TDataSource;
    pBandera: TPanel;
    DBText1: TDBText;
  private
    ultimoMercado: integer;
  protected
    procedure OnValorCambiado; override;
  public
    constructor Create(AOwner: TComponent); override;
    class function GetNombre: string; override;
  end;


implementation

uses dmData, uPanel, UtilDock, dmDataComun;

resourcestring
  NOMBRE = 'Valor';

{$R *.dfm}

{ TfrValor }

constructor TfrPanelValor.Create(AOwner: TComponent);
var defaultDock: TDefaultDock;
begin
  defaultDock.Position := dpArribaBotones;
  defaultDock.Pos := 5000;
  defaultDock.Row := 0;
  inherited CreatePanelNotificaciones(AOwner, defaultDock, [pnValorCambiado]);
  ultimoMercado := -1;
  OnValorCambiado;
end;

class function TfrPanelValor.GetNombre: string;
begin
  result := NOMBRE;
end;

procedure TfrPanelValor.OnValorCambiado;
var oidMercado: integer;
begin
  lSeparadorNombreSimbolo.Visible := Simbolo.Caption <> '';
  oidMercado := Data.ValoresOID_MERCADO.Value;
  if oidMercado <> ultimoMercado then begin
    DataComun.DibujarBandera(oidMercado, iBandera.Canvas, 0, 0, PanelValor.Color);
    ultimoMercado := oidMercado;
  end;
  PanelValor.Repaint;
end;

initialization
  RegisterPanelClass(TfrPanelValor);

end.
