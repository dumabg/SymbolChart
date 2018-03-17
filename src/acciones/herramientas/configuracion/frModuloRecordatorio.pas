unit frModuloRecordatorio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frModulo, ImgList, JvComponentBase, JvErrorIndicator, StdCtrls,
  JvBaseDlg, JvTipOfDay;

type
  TfModuloRecordatorio = class(TfModulo)
    cbRecordatorio: TCheckBox;
    bVerRecordatorio: TButton;
    procedure bVerRecordatorioClick(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure Guardar; override;
    class function Titulo: string; override;    
  end;


implementation

uses dmConfiguracion, dmTipOfDay;

resourcestring
  TITULO_MODULO = 'Recordatorio';

{$R *.dfm}

procedure TfModuloRecordatorio.bVerRecordatorioClick(Sender: TObject);
var tip: TTipOfDay;
begin
  inherited;
  tip := TTipOfDay.Create(nil);
  try
    tip.JvTipOfDay.Options := [toHideStartupCheckbox];
    tip.JvTipOfDay.Execute;
  finally
    tip.Free;
  end;
end;

constructor TfModuloRecordatorio.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  cbRecordatorio.Checked := Configuracion.Recordatorio.MostrarAlIniciar;
end;

procedure TfModuloRecordatorio.Guardar;
begin
  Configuracion.Recordatorio.MostrarAlIniciar := cbRecordatorio.Checked;
end;

class function TfModuloRecordatorio.Titulo: string;
begin
  result := TITULO_MODULO;
end;

end.
