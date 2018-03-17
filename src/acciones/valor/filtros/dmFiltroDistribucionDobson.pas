unit dmFiltroDistribucionDobson;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  IBCustomDataSet,
  IBQuery, kbmMemTable;

type
  TFiltroDistribucionDobson = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;
  end;

implementation

{$R *.dfm}

uses dmFiltros;

{ TFiltroDistribucionDobson }

function TFiltroDistribucionDobson.GetDescripcion: string;
begin
  result := 'Distribución por Dobson';
end;

function TFiltroDistribucionDobson.ValorInFilter: boolean;
begin
  result := (ValoresDOBSON_130.Value < ValoresDOBSON_100.Value) and
    (ValoresDOBSON_100.Value < ValoresDOBSON_70.Value) and
    (ValoresDOBSON_70.Value < ValoresDOBSON_40.Value) and
    (ValoresDOBSON_40.Value < ValoresDOBSON_10.Value);
end;

initialization
  RegisterFiltro(TFiltroDistribucionDobson);
finalization
end.
