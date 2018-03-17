unit dmFiltroCatastrofeBajista;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltroPerforacionCatastrofe, IBCustomDataSet, IBQuery, DB, 
  kbmMemTable;

type
  TFiltroCatastrofeBajista = class(TFiltroPerforacionCatastrofe)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;
  end;

implementation

uses dmFiltros;

{$R *.dfm}

{ TFiltroPerforacionCatastrofe1 }

function TFiltroCatastrofeBajista.GetDescripcion: string;
begin
  result := 'Catastrofe bajista';
end;

function TFiltroCatastrofeBajista.ValorInFilter: boolean;
begin
  // Si ahir està a AB+ i avui a B+
  result := (ValoresZONA.Value = 'B+') and (GetZonaAyer = 'AB+');
end;

initialization
  RegisterFiltro(TFiltroCatastrofeBajista);
finalization

end.
