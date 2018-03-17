unit dmPanelRentabilidadValor;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, Controls, dmDataModuleBase;

type
  TRentabilidadValor = class(TDataModuleBase)
    dsCotizacionEstado: TDataSource;
    CotizacionRentabilidad: TIBQuery;
    CotizacionRentabilidadNIVEL_ABIERTA: TIBBCDField;
    CotizacionRentabilidadTIPO_ABIERTA: TIBStringField;
    CotizacionRentabilidadNIVEL_CERRADA: TIBBCDField;
    CotizacionRentabilidadTIPO_CERRADA: TIBStringField;
    CotizacionRentabilidadRENTABILIDAD_CERRADA: TIBBCDField;
    CotizacionRentabilidadFECHA_INICIO_ABIERTA: TDateField;
    CotizacionRentabilidadFECHA_INICIO_CERRADA: TDateField;
    CotizacionRentabilidadINHIBIDOR: TIBStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure CotizacionRentabilidadTIPO_CERRADAGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure OnTipoCotizacionCambiada;
    function GetTAE(rentabilidad: currency; const fechaIni,
      fechaFin: TDate): string;
  public
    function HayRentabilidadAbierta: boolean;
    function RentabilidadAbierta: currency;
    function GetTAEAbierta: string;
    function GetTAECerrada: string;
  end;

implementation

uses dmData, UtilDB, DateUtils, dmBD, BusCommunication;

resourcestring
  LARGO = 'largo';
  CORTO = 'corto';
  sTAE = 'TAE';

{$R *.dfm}

procedure TRentabilidadValor.CotizacionRentabilidadTIPO_CERRADAGetText(
  Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if Sender.Value = 'L' then
    Text := LARGO
  else
    if Sender.Value = 'C' then
      Text := CORTO
    else
      Text := '';
end;

procedure TRentabilidadValor.DataModuleCreate(Sender: TObject);
begin
  OpenDataSet(CotizacionRentabilidad);
  Bus.RegisterEvent(MessageTipoCotizacionCambiada, OnTipoCotizacionCambiada);
end;

procedure TRentabilidadValor.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  Bus.UnregisterEvent(MessageTipoCotizacionCambiada, OnTipoCotizacionCambiada);
end;

function TRentabilidadValor.GetTAE(rentabilidad: currency; const fechaIni, fechaFin: TDate): string;
var dias: integer;
  negativo: boolean;
  TAE: currency;
begin
  if rentabilidad = 0 then
    TAE := 0
  else begin
    dias := DaysBetween(fechaIni, fechaFin);
    if dias = 0 then
      dias := 1;
    negativo := rentabilidad < 0;
    if negativo then
      rentabilidad := -rentabilidad;
    TAE := (((1 + (rentabilidad / 100)) * 365 / dias) - 1) * 100;
    if negativo then
      TAE := -TAE;
  end;
  result := FormatFloat('#0.00%;-#0.00%;0%', TAE) + ' ' + sTAE;
end;

function TRentabilidadValor.GetTAEAbierta: string;
begin
 result := GetTAE(RentabilidadAbierta, CotizacionRentabilidadFECHA_INICIO_ABIERTA.Value,
  Data.CotizacionFECHA.Value);
end;

function TRentabilidadValor.GetTAECerrada: string;
begin
  result := GetTAE(CotizacionRentabilidadRENTABILIDAD_CERRADA.Value,
    CotizacionRentabilidadFECHA_INICIO_CERRADA.Value,
    CotizacionRentabilidadFECHA_INICIO_ABIERTA.Value);
end;

function TRentabilidadValor.HayRentabilidadAbierta: boolean;
begin
  result := not Data.CotizacionEstadoRENTABILIDAD_ABIERTA.IsNull;
end;

procedure TRentabilidadValor.OnTipoCotizacionCambiada;
begin
  OpenDataSet(CotizacionRentabilidad);
end;

function TRentabilidadValor.RentabilidadAbierta: currency;
begin
  result := Data.CotizacionEstadoRENTABILIDAD_ABIERTA.Value;
end;

end.
