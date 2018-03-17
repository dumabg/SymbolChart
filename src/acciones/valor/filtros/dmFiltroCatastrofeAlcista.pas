unit dmFiltroCatastrofeAlcista;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltroPerforacionCatastrofe, IBCustomDataSet, IBQuery, DB, 
  kbmMemTable;

type
  TFiltroCatastrofeAlcista = class(TFiltroPerforacionCatastrofe)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;
  end;

implementation

uses dmFiltros;

{$R *.dfm}

{ TFiltroPerforacionCatastrofe1 }

function TFiltroCatastrofeAlcista.GetDescripcion: string;
begin
  result := 'Catastrofe alcista';
end;

function TFiltroCatastrofeAlcista.ValorInFilter: boolean;
begin
  // Si ahir està a AB- i avui a A-
  result := (ValoresZONA.Value = 'A-') and (GetZonaAyer = 'AB-');
end;

initialization
  RegisterFiltro(TFiltroCatastrofeAlcista);
finalization

end.
