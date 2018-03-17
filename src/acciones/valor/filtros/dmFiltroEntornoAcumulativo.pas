unit dmFiltroEntornoAcumulativo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroEntornoAcumulativo = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;
  end;


implementation

uses dmFiltroAcumulacionDinero, dmFiltroAcumulacionDobson, dmFiltroFactory, dmFiltros,
  UtilDB;

{$R *.dfm}

{ TFiltroEntornoAcumulativo }

function TFiltroEntornoAcumulativo.GetDescripcion: string;
begin
  result := 'Entorno acumulativo';
end;

function TFiltroEntornoAcumulativo.ValorInFilter: boolean;
var dinero: currency;
  datasetFiltroDinero, datasetFiltroAcumulacion: TDataSet;

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
  //Entorno acumulativo y en acumulació són excluyents.
  // Si apareix a acumulació, no ha d'apareixe al entorno acumulativo
  with getFiltrosFactory do begin
    datasetFiltroDinero := getFiltro(TFiltroAcumulacionDinero).ValoresFiltrados;
    datasetFiltroAcumulacion := getFiltro(TFiltroAcumulacionDobson).ValoresFiltrados;
    result := not (Locate(datasetFiltroDinero, 'OR_VALOR', ValoresOR_VALOR.Value, [])) or
                  (Locate(datasetFiltroAcumulacion, 'OR_VALOR', ValoresOR_VALOR.Value, []));
  end;

  if result then begin
    //(Només es calcula amb els 4 valors, no l'actual).
    // Si els graus del diner són tots iguals i
    // el sumatori(diner) / sumatori(paper) <= 0.5.
    // Cap diner ha ser 0.25.
    dinero := ValoresDINERO_ALZA_DOBLE.Value;
    result :=
       (dinero = ValoresDINERO_BAJA_DOBLE.Value) and
       (dinero = ValoresDINERO_BAJA_SIMPLE.Value) and
       (dinero = ValoresDINERO_ALZA_SIMPLE.Value) and
       (dinero <> 0.25) and
       (ValoresDINERO_ALZA_DOBLE.Value <> 0.25) and
       (ValoresDINERO_BAJA_DOBLE.Value <> 0.25) and
       (ValoresDINERO_BAJA_SIMPLE.Value <> 0.25) and
       (ValoresDINERO_ALZA_SIMPLE.Value <> 0.25) and
       (sumatorios <= 0.5);
  end;
end;

initialization
  RegisterFiltro(TFiltroEntornoAcumulativo);
finalization
end.
