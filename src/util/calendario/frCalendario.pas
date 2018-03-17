unit frCalendario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Calendar, ExtCtrls, StdCtrls,
  calendar2, dmCalendarioValor, Buttons, ActnList, eventos, dmCalendario;

type
  TframeCalendario = class(TFrame)
    Panel1: TPanel;
    Panel2: TPanel;
    Fechas: TComboBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ActionList: TActionList;
    aAnterior: TAction;
    aSiguiente: TAction;
    Cerrar: TSpeedButton;
    procedure FechasChange(Sender: TObject);
    procedure FechasDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure aAnteriorExecute(Sender: TObject);
    procedure aAnteriorUpdate(Sender: TObject);
    procedure aSiguienteUpdate(Sender: TObject);
    procedure aSiguienteExecute(Sender: TObject);
  private
    Calendar: TCalendar2;
    DataCalendar: TCalendario;
    FOnSelectDay: TNotificacionEvent;
    FMinDate: TDate;
    procedure Initialize;
    procedure OnEstadoDia(const dia: integer; var enabled: boolean);
    procedure CalendarSelectDay(Sender: TObject);
    function GetDate: TDate;
    procedure SetMinDate(const Value: TDate);
    procedure SetDate(Value: TDate);
    function GetMaxDate: TDate;
  public
    procedure CreateCalendar(const OIDValor: integer); overload;
    procedure CreateCalendar; overload;
    property OnSelectDay: TNotificacionEvent read FOnSelectDay write FOnSelectDay;
    property Date: TDate read GetDate write SetDate;
    property MinDate: TDate read FMinDate write SetMinDate;
    property MaxDate: TDate read GetMaxDate;
  end;


implementation

uses DateUtils, dmData;

resourcestring
  ENERO = 'enero';
  FEBRERO = 'febrero';
  MARZO = 'marzo';
  ABRIL = 'abril';
  MAYO = 'mayo';
  JUNIO = 'junio';
  JULIO = 'julio';
  AGOSTO = 'agosto';
  SEPTIEMBRE = 'septiembre';
  OCTUBRE = 'octubre';
  NOVIEMBRE = 'noviembre';
  DICIEMBRE = 'diciembre';

const
  meses: array [1..12] of string = (ENERO, FEBRERO, MARZO, ABRIL, MAYO, JUNIO,
  JULIO, AGOSTO, SEPTIEMBRE, OCTUBRE, NOVIEMBRE, DICIEMBRE);

  SIN_VALOR = Low(integer);

{$R *.dfm}

procedure TframeCalendario.CalendarSelectDay(Sender: TObject);
begin
  if DataCalendar is TCalendarioValor then
    Data.IrACotizacionConFecha(Calendar.CalendarDate);
  if Assigned(FOnSelectDay) then
    FOnSelectDay;
end;

procedure TframeCalendario.CreateCalendar;
begin
  CreateCalendar(SIN_VALOR);
end;

procedure TframeCalendario.CreateCalendar(const OIDValor: integer);
var ano, mes, aux: word;
begin
  Calendar := TCalendar2.Create(Self);
  Calendar.Parent := Panel1;
  Calendar.Align := alClient;

  if OIDValor = SIN_VALOR then
    DataCalendar := TCalendario.Create(Self)
  else
    DataCalendar := TCalendarioValor.Create(Self, OIDValor);
  DecodeDate(DataCalendar.CurrentDate, ano, mes, aux);
  DataCalendar.CambiarMes(ano, mes);

  Calendar.CurrentDate := DataCalendar.CurrentDate;
  Calendar.CalendarDate := DataCalendar.CurrentDate;
  Calendar.MaxDate := DataCalendar.MaxDate;
  MinDate := DataCalendar.MinDate;

  Calendar.OnSelectDay := CalendarSelectDay;
  Calendar.OnEstadoDia := OnEstadoDia;
end;

procedure TframeCalendario.Initialize;
var j, ano : Word;
  fechaMin, fechaMax: TDate;
begin
  Fechas.Clear;
  fechaMin := EncodeDate(YearOf(FMinDate), MonthOf(FMinDate), 1);
  fechaMax := DataCalendar.MaxDate;
  fechaMax := EncodeDate(YearOf(fechaMax), MonthOf(fechaMax), 1);
  j := MonthOf(fechaMax);
  ano := YearOf(fechaMax);
  while fechaMin <= fechaMax do begin
    Fechas.AddItem(IntToStr(ano) + ' - ' + meses[j], TObject(j * 10000 + ano));
    if (Calendar.Year = ano) and (Calendar.Month = j) then
      Fechas.ItemIndex := Fechas.Items.Count - 1;
    dec(j);
    if j = 0 then begin
      j := 12;
      dec(ano);
    end;
    fechaMax := IncMonth(fechaMax, -1);
  end;
end;

procedure TframeCalendario.FechasChange(Sender: TObject);
var num, i: integer;
  ano, mes: word;
begin
  i := Fechas.ItemIndex;
  if i <> -1 then begin
    num := Integer(Fechas.Items.Objects[i]);
    ano := num mod 10000;
    mes := num div 10000;
    DataCalendar.CambiarMes(ano, mes);
    Calendar.CalendarDate := EncodeDate(ano, mes, 1);
  end;
end;

procedure TframeCalendario.FechasDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var num: integer;
begin
 with Fechas.Canvas do
  begin
    if odSelected in State then
      Brush.Color := clBlue
    else begin
      num := Integer(Fechas.Items.Objects[Index]);
      if num = 0 then
        Brush.Color := clWhite
      else
        if num mod 2 = 0 then
          Brush.Color := $00E1E1FF
        else
          Brush.Color := $00E8FFFF;
    end;
    FillRect(Rect);
    TextOut(Rect.Left, Rect.Top, Fechas.Items[Index]);
  end;
end;


function TframeCalendario.GetDate: TDate;
begin
  result := Calendar.CurrentDate;
end;

function TframeCalendario.GetMaxDate: TDate;
begin
  result := Calendar.MaxDate;
end;

procedure TframeCalendario.aAnteriorExecute(Sender: TObject);
begin
  Fechas.ItemIndex := Fechas.ItemIndex + 1;
  FechasChange(nil);
end;

procedure TframeCalendario.aAnteriorUpdate(Sender: TObject);
begin
  aSiguiente.Enabled := Fechas.ItemIndex > 0;
end;

procedure TframeCalendario.aSiguienteUpdate(Sender: TObject);
begin
  aAnterior.Enabled := Fechas.ItemIndex < Fechas.Items.Count - 1;
end;

procedure TframeCalendario.aSiguienteExecute(Sender: TObject);
begin
  Fechas.ItemIndex := Fechas.ItemIndex - 1;
  FechasChange(nil);
end;


procedure TframeCalendario.OnEstadoDia(const dia: integer;
  var enabled: boolean);
begin
  enabled := DataCalendar.existeDia(dia);
end;

procedure TframeCalendario.SetDate(Value: TDate);
var ano, mes, dia, diaI: word;
begin
  if Value < FMinDate then
    Value := FMinDate;
  if Value > DataCalendar.MaxDate then
    Value := DataCalendar.MaxDate;
  DecodeDate(Value, ano, mes, dia);
  DataCalendar.CambiarMes(ano, mes);
  diaI := dia;
  while (dia > 0) and (not DataCalendar.existeDia(dia)) do
    dec(dia);
  if dia = 0 then begin
    dia := diaI;
    while not DataCalendar.existeDia(dia) do
      inc(dia);
  end;
  Value := EncodeDate(ano, mes, dia);
  Calendar.CurrentDate := Value;
  Calendar.CalendarDate := Value;
  Initialize;
end;

procedure TframeCalendario.SetMinDate(const Value: TDate);
begin
  FMinDate := Value;
  Calendar.MinDate := Value;
  Initialize;
  FechasChange(nil);
end;

end.
