unit dmFiltroSubidaDistribucion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroSubidaDistribucion = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;
  end;

implementation

{$R *.dfm}

uses dmFiltros;

{ TFiltroSubidaDistribucion }

function TFiltroSubidaDistribucion.GetDescripcion: string;
begin
  result := 'Si suben se ordenan para distribuir';
end;

function TFiltroSubidaDistribucion.ValorInFilter: boolean;
begin
  result := (ValoresDOBSON_ALTO_130.Value < ValoresDOBSON_ALTO_100.Value) and
    (ValoresDOBSON_ALTO_100.Value < ValoresDOBSON_ALTO_70.Value) and
    (ValoresDOBSON_ALTO_70.Value < ValoresDOBSON_ALTO_40.Value) and
    (ValoresDOBSON_ALTO_40.Value < ValoresDOBSON_ALTO_10.Value);
end;

initialization
  RegisterFiltro(TFiltroSubidaDistribucion);
finalization


end.
