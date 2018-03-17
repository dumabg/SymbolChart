unit dmRentabilidadMercado;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, dmThreadDataModule;

type
  TRentabilidadMercado = class(TDataModule)
    MercadoRentabilidad: TIBQuery;
    MercadoRentabilidadPERCENT_CORTO_ABIERTO_GANANCIAS: TIBBCDField;
    MercadoRentabilidadPERCENT_CORTO_ABIERTO_PERDIDAS: TIBBCDField;
    MercadoRentabilidadPERCENT_CORTO_CERRADO_GANANCIAS: TIBBCDField;
    MercadoRentabilidadPERCENT_CORTO_CERRADO_PERDIDAS: TIBBCDField;
    MercadoRentabilidadPERCENT_LARGO_ABIERTO_GANANCIAS: TIBBCDField;
    MercadoRentabilidadPERCENT_LARGO_ABIERTO_PERDIDAS: TIBBCDField;
    MercadoRentabilidadPERCENT_LARGO_CERRADO_GANANCIAS: TIBBCDField;
    MercadoRentabilidadPERCENT_LARGO_CERRADO_PERDIDAS: TIBBCDField;
  private
  public
    procedure Load(OIDSesion, OIDMercado: integer);
    procedure Close;
  end;


implementation

uses dmBD, ConstantsDatosBD;

{$R *.dfm}

{ TRentabilidadMercado }

procedure TRentabilidadMercado.Close;
begin
  MercadoRentabilidad.Close;
end;

procedure TRentabilidadMercado.Load(OIDSesion, OIDMercado: integer);
begin
  MercadoRentabilidad.Close;
  MercadoRentabilidad.ParamByName('OID_SESION').AsInteger := OIDSesion;
  if (OIDMercado = Mercado_Const.OID_EstadosUnidos_NASDAQ) or
    (OIDMercado = Mercado_Const.OID_ETF_USA) then
    OIDMercado := Mercado_Const.OID_EstadosUnidos_NYSE;
  MercadoRentabilidad.ParamByName('OID_MERCADO').AsInteger := OIDMercado;
  MercadoRentabilidad.Open;
end;

end.
