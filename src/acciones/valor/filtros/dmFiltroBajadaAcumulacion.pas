unit dmFiltroBajadaAcumulacion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroBajadaAcumulacion = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;
  end;


implementation

{$R *.dfm}

uses dmFiltros;

{ TFiltroBajadaAcumulacion }

function TFiltroBajadaAcumulacion.GetDescripcion: string;
begin
  result := 'Si caen se ordenan para acumulación';
end;

function TFiltroBajadaAcumulacion.ValorInFilter: boolean;
begin
  result := (ValoresDOBSON_BAJO_130.Value > ValoresDOBSON_BAJO_100.Value) and
    (ValoresDOBSON_BAJO_100.Value > ValoresDOBSON_BAJO_70.Value) and
    (ValoresDOBSON_BAJO_70.Value > ValoresDOBSON_BAJO_40.Value) and
    (ValoresDOBSON_BAJO_40.Value > ValoresDOBSON_BAJO_10.Value);
end;

initialization
  RegisterFiltro(TFiltroBajadaAcumulacion);
finalization


end.
