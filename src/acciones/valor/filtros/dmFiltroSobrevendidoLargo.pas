unit dmFiltroSobrevendidoLargo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroSobrevendidoLargo = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;    
  end;


implementation

{$R *.dfm}

uses dmFiltros;

{ TFiltroSobrevendidoLargo }

function TFiltroSobrevendidoLargo.GetDescripcion: string;
begin
  result := 'Sobrevendido a largo';
end;

function TFiltroSobrevendidoLargo.ValorInFilter: boolean;
begin
  // RSI llarg < 50
  result := ValoresRSI_140.Value < 50;
end;


initialization
  RegisterFiltro(TFiltroSobrevendidoLargo);
finalization
end.
