unit fmRecordatorio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, JvExControls, JvGradientHeaderPanel, StdCtrls,
  ExtCtrls, Buttons, GIFImg, JvGIF;

type
  TTipo = (ttPanel, ttBarra);

  TfRecordatorio = class(TfBase)
    lRecuerde: TLabel;
    JvGradientHeaderPanel1: TJvGradientHeaderPanel;
    Image2: TImage;
    BitBtn1: TBitBtn;
    cbMostrarRecordatorio: TCheckBox;
    Image1: TImage;
  private
    procedure SetNombre(const Value: string);
    function GetMostrarProximaVez: boolean;
    procedure SetTipo(const Value: TTipo);
  public
    property Nombre: string write SetNombre;
    property Tipo: TTipo write SetTipo;
    property MostrarProximaVez: boolean read GetMostrarProximaVez;
  end;


implementation

{$R *.dfm}

resourcestring
  EL_PANEL = 'el panel';
  PANELES = 'Paneles';
  LA_BARRA = 'la barra';
  BARRAS = 'Barras';

{ TfRecordatorio }

function TfRecordatorio.GetMostrarProximaVez: boolean;
begin
  result := not cbMostrarRecordatorio.Checked;
end;

procedure TfRecordatorio.SetNombre(const Value: string);
begin
  lRecuerde.Caption := StringReplace(lRecuerde.Caption, '%2', Value, []);
end;

procedure TfRecordatorio.SetTipo(const Value: TTipo);
begin
  if Value = ttPanel then begin
    lRecuerde.Caption := StringReplace(lRecuerde.Caption, '%1', EL_PANEL, []);
    lRecuerde.Caption := StringReplace(lRecuerde.Caption, '%3', PANELES, []);
  end
  else begin
    lRecuerde.Caption := StringReplace(lRecuerde.Caption, '%1', LA_BARRA, []);
    lRecuerde.Caption := StringReplace(lRecuerde.Caption, '%3', BARRAS, []);
  end;
end;

end.
