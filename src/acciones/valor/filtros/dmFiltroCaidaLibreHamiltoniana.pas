unit dmFiltroCaidaLibreHamiltoniana;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  IBCustomDataSet,
  IBQuery, kbmMemTable;

type
  TFiltroCaidaLibreHamiltoniana = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;
  end;

implementation

{$R *.dfm}

uses dmFiltros;

{ TFiltroBajadaLibre }

function TFiltroCaidaLibreHamiltoniana.GetDescripcion: string;
begin
  result := 'Caída libre hamiltoniana';
end;

function TFiltroCaidaLibreHamiltoniana.ValorInFilter: boolean;
begin
  result := (ValoresDINERO.Value = 0.25) and (ValoresPAPEL.Value = 180);
end;

initialization
  RegisterFiltro(TFiltroCaidaLibreHamiltoniana);
finalization
end.
