unit dmEstrategiaCartera;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmEstrategiaInterpreterBD, DB, IBCustomDataSet, IBQuery, 
  dmData, kbmMemTable;

type
  TEstrategiaCartera = class(TEstrategiaInterpreterBD)
    qSesion: TIBQuery;
    qSesionOR_VALOR: TSmallintField;
    qSesionFECHA: TDateField;
  private
  protected
    function CambioEntrada: currency; override;
    procedure CerrarPosicion; override;
    procedure AntesAbrirSesionValor(const OIDValor: integer); override;
    procedure AntesCerrarSesionValor(const OIDValor: integer); override;
    procedure AntesAbrirSesionPosicionadoValor(const OIDValor: integer); override;
    procedure AntesCerrarSesionPosicionadoValor(const OIDValor: integer); override;
  public
    constructor Create(const AOwner: TComponent; const Valores: TDataSet;
      const OIDEstrategia: integer); reintroduce;
  end;



implementation

uses dmBD, dmDataComun;

{$R *.dfm}

{ TEstrategiaCartera }

procedure TEstrategiaCartera.AntesAbrirSesionPosicionadoValor(
  const OIDValor: integer);
begin
end;

procedure TEstrategiaCartera.AntesAbrirSesionValor(const OIDValor: integer);
begin
  if qSesion.Locate('OR_VALOR', OIDValor, []) then
    ExecEstrategiaApertura(OIDValor, DataComun.FindOIDSesion(qSesionFECHA.Value));
end;

procedure TEstrategiaCartera.AntesCerrarSesionPosicionadoValor(
  const OIDValor: integer);
begin
end;

procedure TEstrategiaCartera.AntesCerrarSesionValor(const OIDValor: integer);
begin
  if qSesion.Locate('OR_VALOR', OIDValor, []) then
    ExecEstrategiaCierre(OIDValor, DataComun.FindOIDSesion(qSesionFECHA.Value));
end;

function TEstrategiaCartera.CambioEntrada: currency;
begin
  result := 0;
end;

procedure TEstrategiaCartera.CerrarPosicion;
begin
end;

constructor TEstrategiaCartera.Create(const AOwner: TComponent;
  const Valores: TDataSet; const OIDEstrategia: integer);
begin
  inherited Create(Aowner, Valores, OIDEstrategia);
  // Ver query. Si un valor lleva más de 7 días sin cotizar, no se considera
//  qSesion.ParamByName('TIPO').AsString := TipoCotizacionToString(TipoCotizacion);
  qSesion.Open;
  qSesion.First;
end;

end.
