unit dmFiltroPerforacionCatastrofeAlcista;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltroPerforacionCatastrofe, IBCustomDataSet, IBQuery, DB,
   kbmMemTable;

type
  TFiltroPerforacionCatastrofeAlcista = class(TFiltroPerforacionCatastrofe)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;
  end;



implementation

uses dmFiltros, dmDataComun;

{$R *.dfm}


{ TFiltroPerforacionCatastrofeAlcista }

function TFiltroPerforacionCatastrofeAlcista.GetDescripcion: string;
begin
  result := 'Perforación de catastrofe alcista';
end;

function TFiltroPerforacionCatastrofeAlcista.ValorInFilter: boolean;
begin
  // Si ahir està a A- i avui a AB-
  result := (ValoresZONA.Value = 'AB-') and (GetZonaAyer = 'A-');
end;


initialization
  RegisterFiltro(TFiltroPerforacionCatastrofeAlcista);
finalization
end.
