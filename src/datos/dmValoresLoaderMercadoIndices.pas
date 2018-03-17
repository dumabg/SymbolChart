unit dmValoresLoaderMercadoIndices;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmValoresLoader, DB, IBCustomDataSet, IBQuery, IBSQL, Valores;

type
  TValoresLoaderMercadoIndices = class(TValoresLoader)
  private
    MercadoIndices: TMercadoIndices;
  protected
    procedure LoadData; override;
  public
    constructor Create(MercadoIndices: TMercadoIndices);
  end;

implementation

uses ConstantsDatosBD;

{$R *.dfm}

{ TValoresLoaderMercadoIndices }

constructor TValoresLoaderMercadoIndices.Create(
  MercadoIndices: TMercadoIndices);
begin
  inherited Create;
  Self.MercadoIndices := MercadoIndices;
end;

procedure TValoresLoaderMercadoIndices.LoadData;
var aux: string;
begin
  case MercadoIndices of
    miTodos:
      aux :=
        'OR_MERCADO>=' + IntToStr(Mercado_Const.OID_IndicesEuropa) + ' and ' +
        'OR_MERCADO<=' + IntToStr(Mercado_Const.OID_IndicesAsia);
    miEuropa:
      aux :=
        'OR_MERCADO=' + IntToStr(Mercado_Const.OID_IndicesEuropa) + ' or ' +
        'OR_MERCADO=' + IntToStr(Mercado_Const.OID_IndicesEspana);
    miAsia:
      aux := 'OR_MERCADO=' + IntToStr(Mercado_Const.OID_IndicesAsia);
    miAmerica:
      aux := 'OR_MERCADO=' + IntToStr(Mercado_Const.OID_IndicesAmerica);
  end;
  qValores.SQL.Text := 'select OID_VALOR from VALOR where ' + aux;
  inherited LoadData;
end;

end.
