unit dmRentabilidadMercados;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery;

type
  TRentabilidadMercados = class(TDataModule)
    qRentabilidadMercados: TIBQuery;
    qRentabilidadMercadosOR_SESION: TIntegerField;
    qRentabilidadMercadosOR_MERCADO: TIntegerField;
    qRentabilidadMercadosPERCENT_CORTO_ABIERTO_GANANCIAS: TIBBCDField;
    qRentabilidadMercadosPERCENT_CORTO_CERRADO_GANANCIAS: TIBBCDField;
    qRentabilidadMercadosPERCENT_LARGO_ABIERTO_GANANCIAS: TIBBCDField;
    qRentabilidadMercadosPERCENT_LARGO_CERRADO_GANANCIAS: TIBBCDField;
    qRentabilidadMercadosPERCENT_CORTO_ABIERTO_PERDIDAS: TIBBCDField;
    qRentabilidadMercadosPERCENT_CORTO_CERRADO_PERDIDAS: TIBBCDField;
    qRentabilidadMercadosPERCENT_LARGO_ABIERTO_PERDIDAS: TIBBCDField;
    qRentabilidadMercadosPERCENT_LARGO_CERRADO_PERDIDAS: TIBBCDField;
  private
    function GetOIDSesion: integer;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure GetMax(var maxAbiertas, maxCerradas: currency);
    property OIDSesion: integer read GetOIDSesion;
  end;

implementation

uses dmBD, dmData;

{$R *.dfm}

constructor TRentabilidadMercados.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  qRentabilidadMercados.ParamByName('OID_SESION').AsInteger := data.OIDSesion;
  qRentabilidadMercados.Open;
end;

procedure TRentabilidadMercados.GetMax(var maxAbiertas, maxCerradas: currency);
begin
  maxAbiertas := 0;
  maxCerradas := 0;
  while not qRentabilidadMercados.Eof do begin
    if maxAbiertas < qRentabilidadMercadosPERCENT_CORTO_ABIERTO_GANANCIAS.Value then
      maxAbiertas := qRentabilidadMercadosPERCENT_CORTO_ABIERTO_GANANCIAS.Value;
    if maxAbiertas < qRentabilidadMercadosPERCENT_CORTO_ABIERTO_PERDIDAS.Value then
      maxAbiertas := qRentabilidadMercadosPERCENT_CORTO_ABIERTO_PERDIDAS.Value;
    if maxAbiertas < qRentabilidadMercadosPERCENT_LARGO_ABIERTO_GANANCIAS.Value then
      maxAbiertas := qRentabilidadMercadosPERCENT_LARGO_ABIERTO_GANANCIAS.Value;
    if maxAbiertas < qRentabilidadMercadosPERCENT_LARGO_ABIERTO_PERDIDAS.Value then
      maxAbiertas := qRentabilidadMercadosPERCENT_LARGO_ABIERTO_PERDIDAS.Value;

    if maxCerradas < qRentabilidadMercadosPERCENT_CORTO_CERRADO_GANANCIAS.Value then
      maxCerradas := qRentabilidadMercadosPERCENT_CORTO_CERRADO_GANANCIAS.Value;
    if maxCerradas < qRentabilidadMercadosPERCENT_CORTO_CERRADO_PERDIDAS.Value then
      maxCerradas := qRentabilidadMercadosPERCENT_CORTO_CERRADO_PERDIDAS.Value;
    if maxCerradas < qRentabilidadMercadosPERCENT_LARGO_CERRADO_GANANCIAS.Value then
      maxCerradas := qRentabilidadMercadosPERCENT_LARGO_CERRADO_GANANCIAS.Value;
    if maxCerradas < qRentabilidadMercadosPERCENT_LARGO_CERRADO_PERDIDAS.Value then
      maxCerradas := qRentabilidadMercadosPERCENT_LARGO_CERRADO_PERDIDAS.Value;

    qRentabilidadMercados.Next;
  end;
end;

function TRentabilidadMercados.GetOIDSesion: integer;
begin
  result := data.OIDSesion;
end;

end.
