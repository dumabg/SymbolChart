unit frSeleccionFechas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, ActnList, frCalendario;

type
  TfSeleccionFechas = class(TFrame)
    ActionList: TActionList;
    DesdeAno: TAction;
    DesdeMes: TAction;
    DesdeFecha: TAction;
    DesdePrimerDia: TAction;
    HastaUltimoDia: TAction;
    HastaFecha: TAction;
    PanelDesde: TPanel;
    ePrincipioAno: TEdit;
    SeleccionAno: TUpDown;
    Label4: TLabel;
    PanelHasta: TPanel;
    Label6: TLabel;
    CalendarioDesde: TframeCalendario;
    CalendarioHasta: TframeCalendario;
    lDesde: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lHasta: TLabel;
    procedure DesdeAnoExecute(Sender: TObject);
    procedure DesdeMesExecute(Sender: TObject);
    procedure DesdeFechaExecute(Sender: TObject);
    procedure DesdePrimerDiaExecute(Sender: TObject);
    procedure HastaUltimoDiaExecute(Sender: TObject);
  private
    function GetDesde: TDate;
    function GetHasta: TDate;
    procedure OnSelectDayDesde;
    procedure OnSelectDayHasta;
    procedure SetDesde(const Value: TDate);
    procedure SetHasta(const Value: TDate);
  public
    constructor Create(AOwner: TComponent); override;
    property Desde: TDate read GetDesde write SetDesde;
    property Hasta: TDate read GetHasta write SetHasta;
  end;

implementation

{$R *.dfm}

uses DateUtils;

constructor TfSeleccionFechas.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SeleccionAno.Max := YearOf(now);
  SeleccionAno.Position := SeleccionAno.Max;

  CalendarioDesde.CreateCalendar;
  SeleccionAno.Min := YearOf(CalendarioDesde.MinDate);
  CalendarioHasta.CreateCalendar;
  CalendarioDesde.OnSelectDay := OnSelectDayDesde;
  CalendarioHasta.OnSelectDay := OnSelectDayHasta;
  OnSelectDayDesde;
  OnSelectDayHasta;
end;

procedure TfSeleccionFechas.DesdeAnoExecute(Sender: TObject);
begin
  CalendarioDesde.Date := EncodeDate(SeleccionAno.Position, 1, 1);
  CalendarioHasta.MinDate := CalendarioDesde.Date;
end;

procedure TfSeleccionFechas.DesdeFechaExecute(Sender: TObject);
begin
  CalendarioHasta.MinDate := CalendarioDesde.Date;
end;

procedure TfSeleccionFechas.DesdeMesExecute(Sender: TObject);
var dia, mes, ano: Word;
begin
  DecodeDate(now, ano, mes, dia);
  CalendarioDesde.Date := EncodeDate(ano, mes, 1);
  CalendarioHasta.MinDate := CalendarioDesde.Date;
end;

procedure TfSeleccionFechas.DesdePrimerDiaExecute(Sender: TObject);
begin
  CalendarioDesde.Date := CalendarioDesde.MinDate;
  CalendarioHasta.MinDate := CalendarioDesde.MinDate;
end;

function TfSeleccionFechas.GetDesde: TDate;
begin
  result := CalendarioDesde.Date;
end;

function TfSeleccionFechas.GetHasta: TDate;
begin
  result := CalendarioHasta.Date;
end;

procedure TfSeleccionFechas.HastaUltimoDiaExecute(Sender: TObject);
begin
  CalendarioHasta.Date := CalendarioHasta.MaxDate;
end;

procedure TfSeleccionFechas.OnSelectDayDesde;
begin
  CalendarioHasta.MinDate := CalendarioDesde.Date;
  lDesde.Caption := DateToStr(CalendarioDesde.Date);
end;

procedure TfSeleccionFechas.OnSelectDayHasta;
begin
  lHasta.Caption := DateToStr(CalendarioHasta.Date);
end;

procedure TfSeleccionFechas.SetDesde(const Value: TDate);
begin
  CalendarioDesde.Date := Value;
end;

procedure TfSeleccionFechas.SetHasta(const Value: TDate);
begin
  CalendarioHasta.Date := Value;
end;

end.
