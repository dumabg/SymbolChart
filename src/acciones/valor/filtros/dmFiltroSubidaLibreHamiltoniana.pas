unit dmFiltroSubidaLibreHamiltoniana;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB, kbmMemTable;

type
  TFiltroSubidaLibreHamiltoniana = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;
  end;

implementation

{$R *.dfm}

uses dmFiltros;

{ TFiltroSubidaLibre }

function TFiltroSubidaLibreHamiltoniana.GetDescripcion: string;
begin
  result := 'Subida libre hamiltoniana';
end;

function TFiltroSubidaLibreHamiltoniana.ValorInFilter: boolean;
begin
  result := (ValoresDINERO.Value = 180) and (ValoresPAPEL.Value = 0.25);
end;

initialization
  RegisterFiltro(TFiltroSubidaLibreHamiltoniana);
finalization
end.
