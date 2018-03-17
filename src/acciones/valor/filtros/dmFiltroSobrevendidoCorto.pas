unit dmFiltroSobrevendidoCorto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroSobrevendidoCorto = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;    
  end;

implementation

{$R *.dfm}

uses dmFiltros;

{ TFiltroSobrevendidoCorto }

function TFiltroSobrevendidoCorto.GetDescripcion: string;
begin
  result := 'Sobrevendido a corto';
end;

function TFiltroSobrevendidoCorto.ValorInFilter: boolean;
begin
  // RSI curt < 30
  result := ValoresRSI_14.Value < 30;
end;

initialization
  RegisterFiltro(TFiltroSobrevendidoCorto);
finalization
end.
