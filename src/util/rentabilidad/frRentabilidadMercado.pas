unit frRentabilidadMercado;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Gauges, ExtCtrls, dmRentabilidadMercado, GIFImg;

type
  TfRentabilidadMercado = class(TFrame)
    pGananciasCerradoUSA: TPanel;
    Image11: TImage;
    Label47: TLabel;
    Label49: TLabel;
    pGananciasAbiertoUSA: TPanel;
    Image15: TImage;
    lLargo: TLabel;
    Label36: TLabel;
    gAbiertoGananciaLargos: TGauge;
    gAbiertoPerdidasLargos: TGauge;
    gAbiertoGananciasCortos: TGauge;
    gAbiertoPerdidasCortos: TGauge;
    gCerradoPerdidasLargos: TGauge;
    gCerradoGananciasCortos: TGauge;
    gCerradoPerdidasCortos: TGauge;
    gCerradoGananciasLargos: TGauge;
    lCerradoGananciasLargos: TLabel;
    lCerradoPerdidasLargos: TLabel;
    lCerradoGananciasCortos: TLabel;
    lCerradoPerdidasCortos: TLabel;
    lAbiertoGananciaLargos: TLabel;
    lAbiertoPerdidasLargos: TLabel;
    lAbiertoGananciasCortos: TLabel;
    lAbiertoPerdidasCortos: TLabel;
    Bevel1: TBevel;
  private
    lastOIDMercado, lastOIDSesion: integer;
    rentabilidad: TRentabilidadMercado;
    procedure ConfigControls(const maxAbiertas, maxCerradas: currency);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Reset;
    procedure Load(const OIDSesion, OIDMercado: integer); overload;
    procedure Load(const OIDSesion, OIDMercado: integer;
      const maxAbiertas, maxCerradas: currency); overload;
//    procedure Close;
  end;

implementation

{$R *.dfm}

uses IBCustomDataSet;

{ TfRentabilidadMercado }

procedure TfRentabilidadMercado.Load(const OIDSesion, OIDMercado: integer);
var maxCerradas, maxAbiertas: currency;
begin
  if (lastOIDMercado <> OIDMercado) or (lastOIDSesion <> OIDSesion) then begin
    lastOIDMercado := OIDMercado;
    lastOIDSesion := OIDSesion;
    rentabilidad.Load(OIDSesion, OIDMercado);

    maxAbiertas := 0;
    if maxAbiertas < rentabilidad.MercadoRentabilidadPERCENT_CORTO_ABIERTO_GANANCIAS.Value then
      maxAbiertas := rentabilidad.MercadoRentabilidadPERCENT_CORTO_ABIERTO_GANANCIAS.Value;
    if maxAbiertas < rentabilidad.MercadoRentabilidadPERCENT_CORTO_ABIERTO_PERDIDAS.Value then
      maxAbiertas := rentabilidad.MercadoRentabilidadPERCENT_CORTO_ABIERTO_PERDIDAS.Value;
    if maxAbiertas < rentabilidad.MercadoRentabilidadPERCENT_LARGO_ABIERTO_GANANCIAS.Value then
      maxAbiertas := rentabilidad.MercadoRentabilidadPERCENT_LARGO_ABIERTO_GANANCIAS.Value;
    if maxAbiertas < rentabilidad.MercadoRentabilidadPERCENT_LARGO_ABIERTO_PERDIDAS.Value then
      maxAbiertas := rentabilidad.MercadoRentabilidadPERCENT_LARGO_ABIERTO_PERDIDAS.Value;

    maxCerradas := 0;
    if maxCerradas < rentabilidad.MercadoRentabilidadPERCENT_CORTO_CERRADO_GANANCIAS.Value then
      maxCerradas := rentabilidad.MercadoRentabilidadPERCENT_CORTO_CERRADO_GANANCIAS.Value;
    if maxCerradas < rentabilidad.MercadoRentabilidadPERCENT_CORTO_CERRADO_PERDIDAS.Value then
      maxCerradas := rentabilidad.MercadoRentabilidadPERCENT_CORTO_CERRADO_PERDIDAS.Value;
    if maxCerradas < rentabilidad.MercadoRentabilidadPERCENT_LARGO_CERRADO_GANANCIAS.Value then
      maxCerradas := rentabilidad.MercadoRentabilidadPERCENT_LARGO_CERRADO_GANANCIAS.Value;
    if maxCerradas < rentabilidad.MercadoRentabilidadPERCENT_LARGO_CERRADO_PERDIDAS.Value then
      maxCerradas := rentabilidad.MercadoRentabilidadPERCENT_LARGO_CERRADO_PERDIDAS.Value;

    ConfigControls(maxAbiertas, maxCerradas);
  end;
end;

{procedure TfRentabilidadMercado.Close;
  procedure config(const g: TGauge; const l: TLabel);
  begin
    g.Progress := 0;
    l.Caption := '-';
  end;
begin
  rentabilidad.Close;
  config(gAbiertoGananciaLargos, lAbiertoGananciaLargos);
  config(gAbiertoGananciaLargos, lAbiertoGananciaLargos);
  config(gAbiertoPerdidasLargos, lAbiertoPerdidasLargos);
  config(gAbiertoGananciasCortos, lAbiertoGananciasCortos);
  config(gAbiertoPerdidasCortos, lAbiertoPerdidasCortos);
  config(gCerradoGananciasLargos, lCerradoGananciasLargos);
  config(gCerradoPerdidasLargos, lCerradoPerdidasLargos);
  config(gCerradoGananciasCortos, lCerradoGananciasCortos);
  config(gCerradoPerdidasCortos, lCerradoPerdidasCortos);
end;}

procedure TfRentabilidadMercado.ConfigControls(const maxAbiertas, maxCerradas: currency);

  procedure config(const g: TGauge; const l: TLabel; const field: TIBBCDField; const max: currency);
  begin
    if field.IsNull then begin
      l.Caption := '-';
      g.Progress := 0;
    end
    else begin
      if max = 0 then
        g.Progress := 0
      else
        g.Progress := Round((field.Value * 100) / max);
      l.Caption := field.DisplayText;
    end;
  end;
begin
  config(gAbiertoGananciaLargos, lAbiertoGananciaLargos,
    rentabilidad.MercadoRentabilidadPERCENT_LARGO_ABIERTO_GANANCIAS, maxAbiertas);
  config(gAbiertoPerdidasLargos, lAbiertoPerdidasLargos,
    rentabilidad.MercadoRentabilidadPERCENT_LARGO_ABIERTO_PERDIDAS, maxAbiertas);
  config(gAbiertoGananciasCortos, lAbiertoGananciasCortos,
    rentabilidad.MercadoRentabilidadPERCENT_CORTO_ABIERTO_GANANCIAS, maxAbiertas);
  config(gAbiertoPerdidasCortos, lAbiertoPerdidasCortos,
    rentabilidad.MercadoRentabilidadPERCENT_CORTO_ABIERTO_PERDIDAS, maxAbiertas);

  config(gCerradoGananciasLargos, lCerradoGananciasLargos,
    rentabilidad.MercadoRentabilidadPERCENT_LARGO_CERRADO_GANANCIAS, maxCerradas);
  config(gCerradoPerdidasLargos, lCerradoPerdidasLargos,
    rentabilidad.MercadoRentabilidadPERCENT_LARGO_CERRADO_PERDIDAS, maxCerradas);
  config(gCerradoGananciasCortos, lCerradoGananciasCortos,
    rentabilidad.MercadoRentabilidadPERCENT_CORTO_CERRADO_GANANCIAS, maxCerradas);
  config(gCerradoPerdidasCortos, lCerradoPerdidasCortos,
    rentabilidad.MercadoRentabilidadPERCENT_CORTO_CERRADO_PERDIDAS, maxCerradas);
end;

constructor TfRentabilidadMercado.Create(AOwner: TComponent);
begin
  inherited;
  rentabilidad := TRentabilidadMercado.Create(Self);
  lastOIDMercado := -1;
  lastOIDSesion := -1;
end;

procedure TfRentabilidadMercado.Load(const OIDSesion, OIDMercado: integer;
  const maxAbiertas, maxCerradas: currency);
begin
  if (lastOIDMercado <> OIDMercado) or (lastOIDSesion <> OIDSesion) then begin
    lastOIDMercado := OIDMercado;
    lastOIDSesion := OIDSesion;
    rentabilidad.Load(OIDSesion, OIDMercado);
    ConfigControls(maxAbiertas, maxCerradas);
  end;
end;

procedure TfRentabilidadMercado.Reset;
begin
  lastOIDMercado := -1;
  lastOIDSesion := -1;
end;

end.
