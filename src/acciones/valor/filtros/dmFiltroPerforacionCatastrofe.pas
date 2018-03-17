unit dmFiltroPerforacionCatastrofe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  IBCustomDataSet,
  IBQuery, kbmMemTable;

type
  TFiltroPerforacionCatastrofe = class(TFiltro)
    Ayer: TIBQuery;
    AyerZONA: TIBStringField;
  private
  protected
    function GetZonaAyer: string;
  public
  end;


implementation

uses dmBD;

{$R *.dfm}

{ TFiltroPerforacionCatastrofe}


{ TFiltroPerforacionCatastrofe }


function TFiltroPerforacionCatastrofe.GetZonaAyer: string;
begin
  Ayer.Close;
  Ayer.ParamByName('OID_SESION').AsInteger := ValoresOR_SESION.Value;
  Ayer.ParamByName('OID_VALOR').AsInteger := ValoresOR_VALOR.Value;
  Ayer.Open;
  result := AyerZONA.Value;
end;

end.
