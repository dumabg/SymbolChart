unit dmFiltroAcumulacionDobson;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroAcumulacionDobson = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;
  end;


implementation

{$R *.dfm}

uses dmFiltros;

{ TFiltroAcumulacionDobson }

function TFiltroAcumulacionDobson.GetDescripcion: string;
begin
  result := 'Acumulación por Dobson';
end;

function TFiltroAcumulacionDobson.ValorInFilter: boolean;
begin
  result := (ValoresDOBSON_130.Value > ValoresDOBSON_100.Value) and
    (ValoresDOBSON_100.Value > ValoresDOBSON_70.Value) and
    (ValoresDOBSON_70.Value > ValoresDOBSON_40.Value) and
    (ValoresDOBSON_40.Value > ValoresDOBSON_10.Value);
end;

initialization
  RegisterFiltro(TFiltroAcumulacionDobson);
finalization


end.
