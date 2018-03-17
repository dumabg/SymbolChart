unit dmFiltroNoblementeAlza;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroNoblementeAlza = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;    
  end;


implementation

uses dmEstadoValores, dmFiltros;

{$R *.dfm}

{ TNoblementeAlza }

function TFiltroNoblementeAlza.GetDescripcion: string;
begin
  result := 'Noblemente al alza';
end;

function TFiltroNoblementeAlza.ValorInFilter: boolean;
{
  Tot el paper ha d'estar a 0.25.
  El diner:
    A la primera baixa te que disminuir respect a la posició actual.
    La segona baixa ha de disminuir més que a la primera.
    A la primera alça ha d'aumentar el diner i a la segona encara més.
}
begin
  result := // Tot el paper ha d'estar a 0.25
            (ValoresPAPEL.Value = 0.25) and
            (ValoresPAPEL_ALZA_DOBLE.Value = 0.25) and
            (ValoresPAPEL_ALZA_SIMPLE.Value = 0.25) and
            (ValoresPAPEL_BAJA_DOBLE.Value = 0.25) and
            (ValoresPAPEL_BAJA_SIMPLE.Value = 0.25) and
            // A la primera baixa te que disminuir respect a la posició actual.
            (ValoresDINERO_BAJA_SIMPLE.Value < ValoresDINERO.Value) and
            // La segona baixa ha de disminuir més que a la primera.
            (ValoresDINERO_BAJA_DOBLE.Value < ValoresDINERO_BAJA_SIMPLE.Value) and
            // A la primera alça ha d'aumentar el diner i a la segona encara més.
            (ValoresDINERO_ALZA_SIMPLE.Value > ValoresDINERO.Value) and
            (ValoresDINERO_ALZA_DOBLE.Value > ValoresDINERO_ALZA_SIMPLE.Value);
end;

initialization
  RegisterFiltro(TFiltroNoblementeAlza);
finalization
end.
