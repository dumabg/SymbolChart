unit calendar2;

interface

uses Calendar, Graphics, Types, Grids, Classes, Controls, Messages;

type
  TOnEstadoDiaNotify = procedure (const dia: integer; var enabled: boolean) of object;

  TCalendar2 = class(TCalendar)
  private
    FOnEstadoDia: TOnEstadoDiaNotify;
    FColorDisabled: TColor;
    FFontDisabled: TFont;
    MaxDateYear, MaxDateMonth, MaxDateDay: Word;
    MinDateYear, MinDateMonth, MinDateDay: Word;
    FDisableWeekEnds: boolean;
    FOnSelectDay: TNotifyEvent;
    FCurrentDate: TDate;
    FColorCurrent: TColor;
    CoordFocused: TGridCoord;
    FColorFocused: TColor;
    procedure SetColorDisabled(const Value: TColor);
    procedure SetFontDisabled(const Value: TFont);
    procedure SetMaxDate(const Value: TDate);
    procedure SetMinDate(const Value: TDate);
    procedure SetColorCurrent(const Value: TColor);
    function GetCalendarDate: TDate;
    procedure SetCalendarDate(const Value: TDate);
    procedure SetColorFocused(const Value: TColor);
    procedure InvalidateFocused;
    procedure SetCurrentDate(const Value: TDate);
    function GetMaxDate: TDate;
  protected
    function isCeldaEnabled(ACol, ARow: Longint): boolean;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    function SelectCell(ACol, ARow: Longint): Boolean; override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property MaxDate: TDate read GetMaxDate write SetMaxDate;
    property MinDate: TDate write SetMinDate;
    property CurrentDate: TDate read FCurrentDate write SetCurrentDate;
    property CalendarDate: TDate read GetCalendarDate write SetCalendarDate;
  published
    property OnEstadoDia: TOnEstadoDiaNotify read FOnEstadoDia write FOnEstadoDia;
    property ColorDisabled: TColor read FColorDisabled write SetColorDisabled default clLtGray;
    property ColorCurrent: TColor read FColorCurrent write SetColorCurrent default clYellow;
    property ColorFocused: TColor read FColorFocused write SetColorFocused default $00F2E6DE;
    property DisableWeekEnds: boolean read FDisableWeekEnds write FDisableWeekEnds default true;
    property FontDisabled: TFont read FFontDisabled write SetFontDisabled;
    property StartOfWeek default 1;
    property GridLineWidth default 0;
    property OnSelectDay: TNotifyEvent read FOnSelectDay write FOnSelectDay;
  end;


implementation

uses SysUtils, DateUtils;

{ TCalendar2 }


procedure TCalendar2.CMMouseLeave(var Message: TMessage);
begin
  InvalidateFocused;
  CoordFocused.X := 0;
  CoordFocused.Y := 0;
end;

constructor TCalendar2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColorDisabled := clLtGray;
  FFontDisabled := TFont.Create;
  FFontDisabled.Color := clGray;
  GridLineWidth := 0;
  StartOfWeek := 1;
  FDisableWeekEnds := true;
  FCurrentDate := now;
  FColorCurrent := clYellow;
  FColorFocused := $00F2E6DE;
  DefaultDrawing := false;
end;

destructor TCalendar2.Destroy;
begin
  FFontDisabled.Free;
  inherited;
end;


procedure TCalendar2.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
var text: string;
begin
  if ARow = 0 then
    inherited DrawCell(ACol, ARow, ARect, AState)
  else begin
    text := CellText[ACol, ARow];
    if (ACol = CoordFocused.X) and (ARow = CoordFocused.Y) then begin
      Canvas.Brush.Color := FColorFocused;
      Canvas.Font.Assign(Font);
    end
    else begin
      if (YearOf(FCurrentDate) = Year) and (MonthOf(FCurrentDate) = Month) and
        (text <> '') and (StrToInt(text) = DayOf(FCurrentDate)) then begin
        Canvas.Brush.Color := FColorCurrent;
        Canvas.Font.Assign(Font);
      end
      else begin
        if (text='') or (isCeldaEnabled(ACol, ARow)) then begin
            Canvas.Brush.Color := Color;
            Canvas.Font.Assign(Font);
        end
        else begin
          Canvas.Brush.Color := FColorDisabled;
          Canvas.Font.Assign(FFontDisabled);
        end;
      end;
    end;
    with ARect, Canvas do
      TextRect(ARect, Left + (Right - Left - TextWidth(text)) div 2,
        Top + (Bottom - Top - TextHeight(text)) div 2, text);
  end;
end;


function TCalendar2.GetCalendarDate: TDate;
begin
  result := inherited CalendarDate;
end;

function TCalendar2.GetMaxDate: TDate;
begin
  result := EncodeDate(MaxDateYear, MaxDateMonth, MaxDateDay);
end;

procedure TCalendar2.InvalidateFocused;
begin
  if (CoordFocused.X <> 0) or (CoordFocused.Y <> 0) then
    InvalidateCell(CoordFocused.X, CoordFocused.Y);
end;

function TCalendar2.isCeldaEnabled(ACol, ARow: Integer): boolean;
var text: string;
  dia: word;
begin
  if (ARow = 0) then
    result := false
  else begin
    if (FDisableWeekEnds) and (ACol > 4) then
      result := false
    else begin
      text := CellText[ACol, ARow];
      if text = '' then
        result := False
      else begin
        dia := StrToInt(text);
        if ((Year = MaxDateYear) and (Month = MaxDateMonth) and (dia > MaxDateDay)) then
          result := false
        else begin
          if ((Year = MinDateYear) and (Month = MinDateMonth) and (dia < MinDateDay)) then
            result := false
          else begin
            result := true;
            if Assigned(FOnEstadoDia) then
              FOnEstadoDia(dia, result);
          end;
        end;
      end;
    end;
  end;
end;

procedure TCalendar2.MouseMove(Shift: TShiftState; X, Y: Integer);
var Coord: TGridCoord;
begin
  inherited MouseMove(Shift, X, Y);
  Coord := MouseCoord(X, Y);
  if isCeldaEnabled(Coord.X, Coord.Y) then begin
    Cursor := crHandPoint;
    if (CoordFocused.X <> Coord.X) or (CoordFocused.Y <> Coord.Y) then begin
      InvalidateCell(CoordFocused.X, CoordFocused.Y);
      InvalidateCell(Coord.X, Coord.Y);
    end;
    CoordFocused := Coord;
  end
  else begin
    InvalidateFocused;
    CoordFocused.X := 0;
    CoordFocused.Y := 0;
    Cursor := crDefault;
  end;
end;

procedure TCalendar2.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var Coord: TGridCoord;
begin
  inherited MouseUp(Button, Shift, X, Y);
  Coord := MouseCoord(X, Y);
  if isCeldaEnabled(Coord.X, Coord.Y) then
    CurrentDate := CalendarDate;
end;

function TCalendar2.SelectCell(ACol, ARow: Integer): Boolean;
begin
  if isCeldaEnabled(ACol, ARow) then
    result := inherited SelectCell(ACol, ARow)
  else begin
    result := false;
  end;
end;

procedure TCalendar2.SetCalendarDate(const Value: TDate);
begin
  inherited CalendarDate := Value;
  CoordFocused.X := 0;
  CoordFocused.Y := 0;
  Invalidate;
end;

procedure TCalendar2.SetColorCurrent(const Value: TColor);
begin
  FColorCurrent := Value;
  Invalidate;
end;

procedure TCalendar2.SetColorDisabled(const Value: TColor);
begin
  FColorDisabled := Value;
  Invalidate;
end;

procedure TCalendar2.SetColorFocused(const Value: TColor);
begin
  FColorFocused := Value;
  InvalidateFocused;
end;

procedure TCalendar2.SetCurrentDate(const Value: TDate);
begin
  FCurrentDate := Value;
  if Assigned(FOnSelectDay) then
    FOnSelectDay(Self);
  Invalidate;
end;

procedure TCalendar2.SetFontDisabled(const Value: TFont);
begin
  FFontDisabled.Assign(Value);
end;


procedure TCalendar2.SetMaxDate(const Value: TDate);
begin
  DecodeDate(Value, MaxDateYear, MaxDateMonth, MaxDateDay);
  if CurrentDate > Value then begin
    CalendarDate := Value;
    CurrentDate := Value;
  end;
  Invalidate;
end;

procedure TCalendar2.SetMinDate(const Value: TDate);
begin
  DecodeDate(Value, MinDateYear, MinDateMonth, MinDateDay);
  if CurrentDate < Value then begin
    CalendarDate := Value;  
    CurrentDate := Value;
  end;
  Invalidate;
end;

end.
