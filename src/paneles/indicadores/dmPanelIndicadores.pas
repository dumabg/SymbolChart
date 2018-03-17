unit dmPanelIndicadores;

interface

uses
  SysUtils, Classes;

type
  TPanelIndicadores = class(TDataModule)
  private
    function GetNivel(const nivel: string): integer;
    function GetNivelSube: integer;
    function GetNivelBaja: integer;
    function GetNivelActual: integer;
    function GetExisteCambio: boolean;
    function GetExistePotencialFractal: boolean;
    function GetSubePotencialFractal: boolean;
    function GetExisteDobson: boolean;
    function GetExisteDobsonAlto: boolean;
    function GetExisteDobsonBajo: boolean;
  public
    function CalcularMaxMin(var maximo, minimo: currency): boolean;
    property SubePotencialFractal: boolean read GetSubePotencialFractal;
    property ExisteCambio: boolean read GetExisteCambio;
    property ExistePotencialFractal: boolean read GetExistePotencialFractal;
    property ExisteDobson: boolean read GetExisteDobson;
    property ExisteDobsonAlto: boolean read GetExisteDobsonAlto;
    property ExisteDobsonBajo: boolean read GetExisteDobsonBajo;
    property NivelSube: integer read GetNivelSube;
    property NivelBaja: integer read GetNivelBaja;
    property NivelActual: integer read GetNivelActual;
  end;


implementation

{$R *.dfm}

uses dmData, UtilDB;

{ TPanelIndicadores }

function TPanelIndicadores.CalcularMaxMin(var maximo, minimo: currency): boolean;
var cambio: currency;
  inspect: TInspectDataSet;
begin
  if Data.Cotizacion.IsEmpty then begin
    result := false;
  end
  else begin
    inspect := StartInspectDataSet(Data.Cotizacion);
    try
      Data.Cotizacion.First;
      cambio := Data.CotizacionCIERRE.Value;
      maximo := cambio;
      minimo := cambio;
      repeat
        Data.Cotizacion.Next;
        cambio := Data.CotizacionCIERRE.Value;
        if cambio <> DIA_SIN_COTIZAR then begin
          if maximo < cambio then
            maximo := cambio;
          if minimo > cambio then
            minimo := cambio;
        end;
      until Data.Cotizacion.Eof;
      result := true;
    finally
      EndInspectDataSet(inspect);
    end;
  end;
end;

function TPanelIndicadores.GetExisteCambio: boolean;
begin
  result := Data.CotizacionCIERRE.Value <> DIA_SIN_COTIZAR;
end;

function TPanelIndicadores.GetExisteDobson: boolean;
begin
  result := not Data.CotizacionEstadoDOBSON_130.IsNull;
end;

function TPanelIndicadores.GetExisteDobsonAlto: boolean;
begin
  result := not Data.CotizacionEstadoDOBSON_ALTO_130.IsNull;
end;

function TPanelIndicadores.GetExisteDobsonBajo: boolean;
begin
  result := not Data.CotizacionEstadoDOBSON_BAJO_130.IsNull;
end;

function TPanelIndicadores.GetExistePotencialFractal: boolean;
begin
  result := not Data.CotizacionEstadoPOTENCIAL_FRACTAL.IsNull;
end;

function TPanelIndicadores.GetNivel(const nivel: string): integer;
begin
  if nivel = 'A' then
    result := 10
  else
    result := StrToInt(nivel);
end;

function TPanelIndicadores.GetNivelActual: integer;
begin
  result := GetNivel(Data.CotizacionEstadoNIVEL_ACTUAL.Value);
end;

function TPanelIndicadores.GetNivelBaja: integer;
begin
  result := GetNivel(Data.CotizacionEstadoNIVEL_BAJA.Value);
end;

function TPanelIndicadores.GetNivelSube: integer;
begin
  result := GetNivel(Data.CotizacionEstadoNIVEL_SUBE.Value);
end;

function TPanelIndicadores.GetSubePotencialFractal: boolean;
begin
  result := Data.CotizacionEstadoPOTENCIAL_FRACTAL.Value >= 0;
end;

end.
