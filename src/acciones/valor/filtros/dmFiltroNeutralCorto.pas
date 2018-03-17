unit dmFiltroNeutralCorto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroNeutralCorto = class(TFiltro)
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;    
  end;


implementation

{$R *.dfm}

uses dmFiltros;

{ TFiltroNeutralCorto }

function TFiltroNeutralCorto.GetDescripcion: string;
begin
  result := 'Neutral a corto';
end;

function TFiltroNeutralCorto.ValorInFilter: boolean;
begin
  // 30 < RSI curt < 70
  result := (ValoresRSI_14.Value > 30) and (ValoresRSI_14.Value < 70);
end;


initialization
  RegisterFiltro(TFiltroNeutralCorto);
finalization
end.
