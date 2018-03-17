unit dmFiltroResistencia;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroResistencia = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;    
  end;


implementation

{$R *.dfm}

uses dmFiltros;

{ TFiltroResistencia }

function TFiltroResistencia.GetDescripcion: string;
begin
  result := 'Resistencia';
end;

function TFiltroResistencia.ValorInFilter: boolean;
begin
//  result := ValoresMENSAJE_RESISTENCIA_SOPORTE.Value = 'R';
  result := false;
  { TODO : Resistencia soporte }
end;

initialization
  RegisterFiltro(TFiltroResistencia);
finalization
end.
