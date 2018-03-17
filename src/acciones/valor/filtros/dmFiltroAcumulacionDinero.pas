unit dmFiltroAcumulacionDinero;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroAcumulacionDinero = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;
  end;

implementation

{$R *.dfm}

uses dmFiltros;

{ TFiltroAcumulacionDinero }

function TFiltroAcumulacionDinero.GetDescripcion: string;
begin
  result := 'Acumulación por dinero';
end;

function TFiltroAcumulacionDinero.ValorInFilter: boolean;
var dinero: currency;

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
  //Si els graus del diner són tots iguals i
  //el sumatori(diner) / sumatori(paper) =< 0.5 i
  //cap paper ha de ser 0.25 i
  //cap diner ha ser 0.25
  dinero := ValoresDINERO.Value;
  result := (dinero = ValoresDINERO_ALZA_DOBLE.Value) and
     (dinero = ValoresDINERO_BAJA_DOBLE.Value) and
     (dinero = ValoresDINERO_BAJA_SIMPLE.Value) and
     (dinero = ValoresDINERO_ALZA_SIMPLE.Value) and
     (dinero <> 0.25) and
     (ValoresDINERO_ALZA_DOBLE.Value <> 0.25) and
     (ValoresDINERO_BAJA_DOBLE.Value <> 0.25) and
     (ValoresDINERO_BAJA_SIMPLE.Value <> 0.25) and
     (ValoresDINERO_ALZA_SIMPLE.Value <> 0.25) and
     (ValoresPAPEL.Value <> 0.25) and
     (ValoresPAPEL_ALZA_DOBLE.Value <> 0.25) and
     (ValoresPAPEL_ALZA_SIMPLE.Value <> 0.25) and
     (ValoresPAPEL_BAJA_DOBLE.Value <> 0.25) and
     (ValoresPAPEL_BAJA_SIMPLE.Value <> 0.25) and
     (sumatorios <= 0.5);
end;

initialization
  RegisterFiltro(TFiltroAcumulacionDinero);
finalization


end.
