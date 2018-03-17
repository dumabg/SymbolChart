unit dmFiltroLimiteSobrecompraCorto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroLimiteSobrecompraCorto = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;    
  end;


implementation

{$R *.dfm}

uses dmFiltros;

{ TFiltroLimiteSobrecompraCorto }

function TFiltroLimiteSobrecompraCorto.GetDescripcion: string;
begin
  result := 'Límite de sobrecompra a corto';
end;

function TFiltroLimiteSobrecompraCorto.ValorInFilter: boolean;
begin
  // RSI curt = 70
  result := ValoresRSI_14.Value = 70;
end;

initialization
  RegisterFiltro(TFiltroLimiteSobrecompraCorto);
finalization


end.
