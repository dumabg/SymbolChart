unit dmFiltroNeutral;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroNeutral = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;    
  end;


implementation

{$R *.dfm}

uses dmFiltros;

{ TFiltroNeutral }

function TFiltroNeutral.GetDescripcion: string;
begin
  result := 'Neutral a largo';
end;

function TFiltroNeutral.ValorInFilter: boolean;
begin
  // RSI llarg = 50
  result := ValoresRSI_140.Value = 50;
end;

initialization
  RegisterFiltro(TFiltroNeutral);
finalization
end.
