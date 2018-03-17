unit dmFiltroSubenSubidaLibre;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltroSubidaLibreHamiltoniana, DB,  kbmMemTable;

type
  TFiltroSubenSubidaLibre = class(TFiltroSubidaLibreHamiltoniana)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;    
  end;


implementation

uses dmFiltros;

{$R *.dfm}


{ TFiltroSubenSubidaLibre }

function TFiltroSubenSubidaLibre.GetDescripcion: string;
begin
  result := 'Si suben entran en subida libre';
end;

function TFiltroSubenSubidaLibre.ValorInFilter: boolean;
begin
  // Si primera pujada o pujada doble estan en 180 diner 0.25 paper i
  // que avui no estiguen en pujada lliure
  result := (not inherited ValorInFilter) and
    (ValoresDINERO_ALZA_SIMPLE.Value = 180) and
    (ValoresDINERO_ALZA_DOBLE.Value = 180) and
    (ValoresPAPEL_ALZA_DOBLE.Value = 0.25) and
    (ValoresPAPEL_ALZA_SIMPLE.Value = 0.25);
end;

initialization
  RegisterFiltro(TFiltroSubenSubidaLibre);
finalization
end.
