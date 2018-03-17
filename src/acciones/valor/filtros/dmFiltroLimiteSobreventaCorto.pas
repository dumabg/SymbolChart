unit dmFiltroLimiteSobreventaCorto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroLimiteSobreventaCorto = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;    
  end;


implementation

{$R *.dfm}

uses dmFiltros;

{ TFiltroLimiteSobreventaCorto }

function TFiltroLimiteSobreventaCorto.GetDescripcion: string;
begin
  result := 'Límite de sobreventa a corto';
end;

function TFiltroLimiteSobreventaCorto.ValorInFilter: boolean;
begin
  // RSI curt = 30
  result := ValoresRSI_14.Value = 30;
end;

initialization
  RegisterFiltro(TFiltroLimiteSobreventaCorto);
finalization
end.
