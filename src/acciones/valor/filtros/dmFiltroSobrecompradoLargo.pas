unit dmFiltroSobrecompradoLargo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroSobrecompradoLargo = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;    
  end;


implementation

{$R *.dfm}

uses dmFiltros;

{ TFiltroSobrecompradoLargo }

function TFiltroSobrecompradoLargo.GetDescripcion: string;
begin
  result := 'Sobrecomprado a largo';
end;

function TFiltroSobrecompradoLargo.ValorInFilter: boolean;
begin
  // RSI llarg > 50
  result := ValoresRSI_140.Value > 50;
end;

initialization
  RegisterFiltro(TFiltroSobrecompradoLargo);
finalization
end.
