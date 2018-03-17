unit dmFiltroSobrecompradoCorto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroSobrecompradoCorto = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;    
  end;

implementation

{$R *.dfm}

uses dmFiltros;

{ TFiltroSobrecompradoCorto }

function TFiltroSobrecompradoCorto.GetDescripcion: string;
begin
  result := 'Sobrecomprado a corto';
end;

function TFiltroSobrecompradoCorto.ValorInFilter: boolean;
begin
  // RSI curt > 70
  result := ValoresRSI_14.Value > 70;
end;


initialization
  RegisterFiltro(TFiltroSobrecompradoCorto);
finalization
end.
