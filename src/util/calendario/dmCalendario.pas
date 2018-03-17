unit dmCalendario;

interface

uses
  SysUtils, Classes, Controls, DB, IBCustomDataSet, IBQuery, dmThreadDataModule;

type
  TCalendario = class(TThreadDataModule)
    qMaxDate: TIBQuery;
    qMinDate: TIBQuery;
    qDias: TIBQuery;
    qDiasFECHA: TDateField;
    qMinDateFECHA: TDateField;
    qMaxDateFECHA: TDateField;
  protected
    FMinDate: TDate;
    ano, mes: word;
    function GetMaxDate: TDate; virtual;
    function GetMinDate: TDate; virtual;
    function GetCurrentDate: TDate;
    procedure BuscarFechas; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CambiarMes(const ano, mes: word);
    function existeDia(const dia: word): boolean;
    property MaxDate: TDate read GetMaxDate;
    property MinDate: TDate read GetMinDate;
    property CurrentDate: TDate read GetCurrentDate;
  end;


implementation

uses dmBD, dmData, dmConfiguracion, UtilDB;

{$R *.dfm}

{ TCalendario }

function TCalendario.GetCurrentDate: TDate;
begin
  result := Data.CotizacionFECHA.Value;
end;

function TCalendario.GetMaxDate: TDate;
begin
  result := qMaxDateFECHA.Value;
end;

function TCalendario.GetMinDate: TDate;
begin
  result := FMinDate;
end;

procedure TCalendario.BuscarFechas;
var tipo: string;
begin
  tipo := Data.TipoCotizacionAsString;
  // Se cachea la fecha mínima porque la query de buscar la fecha mínima es lenta
  FMinDate := Configuracion.ReadDateTime('Calendario.Min', tipo, 0);
  if FMinDate = 0 then begin
    OpenDataSet(qMinDate);
    FMinDate := qMinDateFECHA.Value;
    qMinDate.Close;
    Configuracion.WriteDateTime('Calendario.Min', tipo, FMinDate);
  end;
  qMaxDate.Open;
end;

procedure TCalendario.CambiarMes(const ano, mes: word);
var ini: TDate;
begin
  Self.ano := ano;
  Self.mes := mes;
  qDias.Close;
  ini := EncodeDate(ano, mes, 1);
  qDias.ParamByName('FECHA1').AsDate := ini;
  qDias.ParamByName('FECHA2').AsDate := IncMonth(ini);
  OpenDataSet(qDias);
end;

constructor TCalendario.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BuscarFechas;
end;

function TCalendario.existeDia(const dia: word): boolean;
var fecha: TDate;
begin
  fecha := EncodeDate(ano, mes, dia);
  result := Locate(qDias, 'FECHA', fecha, []);
end;

end.
