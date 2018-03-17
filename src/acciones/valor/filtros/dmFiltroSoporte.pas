unit dmFiltroSoporte;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroSoporte = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;    
  end;


implementation

uses dmEstadoValores, dmFiltros;

{$R *.dfm}

{ TFiltroSoporte }

function TFiltroSoporte.GetDescripcion: string;
begin
  result := 'Soporte';
end;

function TFiltroSoporte.ValorInFilter: boolean;
begin
//  result := ValoresMENSAJE_RESISTENCIA_SOPORTE.Value = 'S';
  result := false;
  { TODO : Resistencia soporte }
end;

initialization
  RegisterFiltro(TFiltroSoporte);
finalization
end.
