unit dmFiltroCaenBajadaLibre;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  dmFiltroCaidaLibreHamiltoniana;

type
  TFiltroCaenBajadaLibre = class(TFiltroCaidaLibreHamiltoniana)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;    
  end;


implementation

{$R *.dfm}

uses dmFiltros;

{ TFiltroCaenCaidaLibre }

function TFiltroCaenBajadaLibre.GetDescripcion: string;
begin
  result := 'Si bajan entran en caída libre hamiltoniana';
end;

function TFiltroCaenBajadaLibre.ValorInFilter: boolean;
begin
  // Si la baixa o baixa doble estan a 0.25 diner i 180 paper i
  // que avui no estiguen en caiguda lliure
  result := (not inherited ValorInFilter) and
    (ValoresDINERO_BAJA_DOBLE.Value = 0.25) and
    (ValoresDINERO_BAJA_SIMPLE.Value = 0.25) and
    (ValoresPAPEL_BAJA_DOBLE.Value = 180) and
    (ValoresPAPEL_BAJA_SIMPLE.Value = 180);
end;


initialization
  RegisterFiltro(TFiltroCaenBajadaLibre);
finalization
end.
