unit dmFiltroDistribucionPapel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroDistribucionPapel = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;
  end;

implementation

{$R *.dfm}

uses dmFiltros;

{ TFiltroDistribucionPapel }


function TFiltroDistribucionPapel.GetDescripcion: string;
begin
  result := 'Distribución por papel';
end;

function TFiltroDistribucionPapel.ValorInFilter: boolean;
var papel: currency;

  function sumatorios: currency;
  var denominador: currency;
  begin
    denominador := ValoresPAPEL.Value +
          ValoresPAPEL_ALZA_DOBLE.Value +
          ValoresPAPEL_ALZA_SIMPLE.Value +
          ValoresPAPEL_BAJA_DOBLE.Value +
          ValoresPAPEL_BAJA_SIMPLE.Value;
    if denominador = 0 then
      result := 0
    else
      result := (ValoresDINERO.Value +
          ValoresDINERO_ALZA_DOBLE.Value +
          ValoresDINERO_BAJA_DOBLE.Value +
          ValoresDINERO_BAJA_SIMPLE.Value +
          ValoresDINERO_ALZA_SIMPLE.Value) /
          denominador;
  end;

begin
  // Si els graus del paper són tots iguals i
  // el sumatori(diner) / sumatori(paper) >= 2 i cap diner ha de ser 0.25 i
  // cap paper ha de ser 0.25
  papel := ValoresPAPEL.Value;
  result := (papel = ValoresPAPEL_ALZA_DOBLE.Value) and
     (papel = ValoresPAPEL_BAJA_DOBLE.Value) and
     (papel = ValoresPAPEL_BAJA_SIMPLE.Value) and
     (papel = ValoresPAPEL_ALZA_SIMPLE.Value) and
     (papel <> 0.25) and
     (ValoresDINERO_ALZA_DOBLE.Value <> 0.25) and
     (ValoresDINERO_BAJA_DOBLE.Value <> 0.25) and
     (ValoresDINERO_BAJA_SIMPLE.Value <> 0.25) and
     (ValoresDINERO_ALZA_SIMPLE.Value <> 0.25) and
     (ValoresPAPEL.Value <> 0.25) and
     (ValoresPAPEL_ALZA_DOBLE.Value <> 0.25) and
     (ValoresPAPEL_ALZA_SIMPLE.Value <> 0.25) and
     (ValoresPAPEL_BAJA_DOBLE.Value <> 0.25) and
     (ValoresPAPEL_BAJA_SIMPLE.Value <> 0.25) and
     (sumatorios >= 2);
end;

initialization
  RegisterFiltro(TFiltroDistribucionPapel);
finalization

end.
