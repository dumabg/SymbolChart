unit uPanelCotizaciones;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uPanel, Grids, DBGrids, JvExDBGrids, JvDBGrid, JvDBUltimGrid,
  TB2Dock, SpTBXItem, Buttons, StdCtrls, DBCtrls, ExtCtrls;

type
  TfrPanelCotizaciones = class(TfrPanel)
    ToolWindowCotizaciones: TSpTBXToolWindow;
    Cotizaciones: TJvDBUltimGrid;
    procedure ToolWindowCotizacionesDockChanged(Sender: TObject);
    procedure CotizacionesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    class function GetNombre: string; override;
  end;


implementation

uses dmData, UtilDock, fmCalendario, GraficoPositionLayer,
  SCMain;

{$R *.dfm}

resourcestring
  NOMBRE = 'Cotizaciones';

{ TfrPanelCotizaciones }

procedure TfrPanelCotizaciones.CotizacionesKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  // Necesario porque sino se procesan las teclas de izquierda y derecha y el
  // control mueve el dataset en dirección inversa a la deseada. El form ya
  // procesa la izquierda y derecha pasando la tecla al gráfico.
  Key := 0;
end;

constructor TfrPanelCotizaciones.Create(AOwner: TComponent);
var defaultDock: TDefaultDock;
begin
  defaultDock.Position := dpAbajo;
  defaultDock.Pos := 0;
  defaultDock.Row := 1;
  inherited CreatePanel(AOwner, defaultDock);
end;

class function TfrPanelCotizaciones.GetNombre: string;
begin
  result := NOMBRE;
end;

procedure TfrPanelCotizaciones.ToolWindowCotizacionesDockChanged(
  Sender: TObject);
var pos: TTBDockPosition;
  dock: TTBDock;
begin
  inherited;
  dock := ToolWindowCotizaciones.CurrentDock;
  if dock <> nil then
    pos := dock.Position
  else
    pos := dpTop;
  ToolWindowCotizaciones.FullSize := (pos = dpLeft) or (pos = dpRight);
end;

initialization
  RegisterPanelClass(TfrPanelCotizaciones);

end.
