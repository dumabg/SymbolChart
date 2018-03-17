unit dmFiltroSuelo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroSuelo = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;    
  end;


implementation

uses dmEstadoValores, dmFiltros;

{$R *.dfm}

{ TFiltroSuelo }

function TFiltroSuelo.GetDescripcion: string;
begin
  result := 'Suelo';
end;

function TFiltroSuelo.ValorInFilter: boolean;
begin
  result := (ValoresDINERO.Value = 0.25) and
            (ValoresDINERO_ALZA_DOBLE.Value = 0.25) and
            (ValoresDINERO_BAJA_DOBLE.Value = 0.25) and
            (ValoresDINERO_BAJA_SIMPLE.Value = 0.25) and
            (ValoresDINERO_ALZA_SIMPLE.Value = 0.25) and
            (ValoresPAPEL.Value = ValoresPAPEL_ALZA_DOBLE.Value) and
            (ValoresPAPEL_ALZA_DOBLE.Value = ValoresPAPEL_ALZA_SIMPLE.Value) and
            (ValoresPAPEL_ALZA_SIMPLE.Value = ValoresPAPEL_BAJA_DOBLE.Value) and
            (ValoresPAPEL_BAJA_DOBLE.Value = ValoresPAPEL_BAJA_SIMPLE.Value);
end;

initialization
  RegisterFiltro(TFiltroSuelo);
finalization
end.
