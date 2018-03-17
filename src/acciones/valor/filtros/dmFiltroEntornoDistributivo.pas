unit dmFiltroEntornoDistributivo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroEntornoDistributivo = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;
  end;


implementation

uses dmFiltroFactory, dmFiltroDistribucionDobson,
  dmFiltroDistribucionPapel, dmFiltros, UtilDB;

{$R *.dfm}

{ TFiltroEntornoDistributivo }

function TFiltroEntornoDistributivo.GetDescripcion: string;
begin
  result := 'Entorno distributivo';
end;

function TFiltroEntornoDistributivo.ValorInFilter: boolean;
var papel: currency;
  datasetFiltroPapel, datasetFiltroDobson: TDataSet;

  function sumatorios: currency;
  var denominador: currency;
  begin
    denominador := ValoresPAPEL_ALZA_DOBLE.Value +
          ValoresPAPEL_ALZA_SIMPLE.Value +
          ValoresPAPEL_BAJA_DOBLE.Value +
          ValoresPAPEL_BAJA_SIMPLE.Value;
    if denominador = 0 then
      result := 0
    else
      result := (ValoresDINERO_ALZA_DOBLE.Value +
          ValoresDINERO_BAJA_DOBLE.Value +
          ValoresDINERO_BAJA_SIMPLE.Value +
          ValoresDINERO_ALZA_SIMPLE.Value) /
          denominador;
  end;

begin
  //Entorno distributivo y en distribució són excluyents.
  //Si apareix a distribució, no ha d'apareixe al entorno distributivo
  with getFiltrosFactory do begin
    datasetFiltroPapel := getFiltro(TFiltroDistribucionPapel).ValoresFiltrados;
    datasetFiltroDobson := getFiltro(TFiltroDistribucionDobson).ValoresFiltrados;
    result := not (Locate(datasetFiltroPapel, 'OR_VALOR', ValoresOR_VALOR.Value, [])) or
                  (Locate(datasetFiltroDobson, 'OR_VALOR', ValoresOR_VALOR.Value, []));
  end;

  if result then begin
    // (Només es calcula amb els 4 valors, no l'actual).
    // Si els graus del paper són tots iguals i
    // el sumatori(diner) / sumatori(paper) >= 2.
    // Cap paper ha de ser 0.25.
    papel := ValoresPAPEL_ALZA_DOBLE.Value;
    result :=
       (papel = ValoresPAPEL_BAJA_DOBLE.Value) and
       (papel = ValoresPAPEL_BAJA_SIMPLE.Value) and
       (papel = ValoresPAPEL_ALZA_SIMPLE.Value) and
       (papel <> 0.25) and
       (ValoresPAPEL_ALZA_DOBLE.Value <> 0.25) and
       (ValoresPAPEL_ALZA_SIMPLE.Value <> 0.25) and
       (ValoresPAPEL_BAJA_DOBLE.Value <> 0.25) and
       (ValoresPAPEL_BAJA_SIMPLE.Value <> 0.25) and
       (sumatorios >= 2);
  end;
end;

initialization
  RegisterFiltro(TFiltroEntornoDistributivo);
finalization


end.
