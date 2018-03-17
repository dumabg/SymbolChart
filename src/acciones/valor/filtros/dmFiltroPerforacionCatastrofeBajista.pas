unit dmFiltroPerforacionCatastrofeBajista;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltroPerforacionCatastrofe, IBCustomDataSet, IBQuery, DB,
   kbmMemTable;

type
  TFiltroPerforacionCatastrofeBajista = class(TFiltroPerforacionCatastrofe)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;    
  end;


implementation

uses dmFiltros;

{$R *.dfm}

{ TFiltroPerforacionCatastrofeBajista }

function TFiltroPerforacionCatastrofeBajista.GetDescripcion: string;
begin
  result := 'Perforación de catastrofe bajista';
end;

function TFiltroPerforacionCatastrofeBajista.ValorInFilter: boolean;
begin
  // Si ahir està a B+ i avui a AB+
  result := (ValoresZONA.Value = 'AB+') and (GetZonaAyer = 'B+');
end;


initialization
  RegisterFiltro(TFiltroPerforacionCatastrofeBajista);
finalization
end.
