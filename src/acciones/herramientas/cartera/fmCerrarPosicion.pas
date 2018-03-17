unit fmCerrarPosicion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, StdCtrls, Mask, JvExMask, JvSpin, ComCtrls, Buttons, ExtCtrls,
  DBCtrls, fmBasePrecio, AppEvnts, frCambioMoneda, JvGIF;

type
  TfCerrarPosicion = class(TfBasePrecio)
    DatePicker: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    TimePicker: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
  private
    FNumAcciones: cardinal;
    FOIDMonedaBase: integer;
    function GetFechaHora: TDateTime;
//    function GetCambioMonedaChecked: boolean;
  protected
    function GetOIDMonedaBase: integer; override;
    function GetNumAcciones: integer; override;
  public
    property FechaHora: TDateTime read GetFechaHora;
    property NumAcciones: cardinal read FNumAcciones write FNumAcciones;
    property OIDMonedaBase: integer read FOIDMonedaBase write FOIDMonedaBase;
//    property CambioMonedaChecked: boolean read GetCambioMonedaChecked;
  end;


implementation



{$R *.dfm}

{ TfCerrarPosicion }

procedure TfCerrarPosicion.FormCreate(Sender: TObject);
begin
  inherited;
  DatePicker.DateTime := now;
  TimePicker.DateTime := now;
end;

{function TfCerrarPosicion.GetCambioMonedaChecked: boolean;
begin
  result := cbCambioMoneda.Checked;
end;}

function TfCerrarPosicion.GetFechaHora: TDateTime;
var ano, mes, dia, hora, minuto, segundo, milisegundo: word;
begin
  DecodeDate(DatePicker.Date, ano, mes, dia);
  DecodeTime(TimePicker.Time, hora, minuto, segundo, milisegundo);
  result := EncodeDate(ano, mes, dia) + EncodeTime(hora, minuto, segundo, milisegundo);
end;

function TfCerrarPosicion.GetNumAcciones: integer;
begin
  result := FNumAcciones;
end;

function TfCerrarPosicion.GetOIDMonedaBase: integer;
begin
  result := FOIDMonedaBase;
end;


end.
