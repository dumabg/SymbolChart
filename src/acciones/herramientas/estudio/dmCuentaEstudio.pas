unit dmCuentaEstudio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, IBCustomDataSet, IBQuery, 
  IBSQL, dmCuenta, kbmMemTable;

type
  TCuentaEstudio = class(TCuenta)
  private
  protected
  public
    constructor Create(const AOwner: TComponent; const nombre: string;
      const OIDMoneda: integer); overload;
    function TienePosicionAbierta(const OIDValor: integer): boolean;
    procedure BeginEstudio;
    procedure EndEstudio;
    procedure Unload;
  end;

implementation

{$R *.dfm}



{ TCuentaEstudio }

procedure TCuentaEstudio.BeginEstudio;
begin
  inicializando := true;
end;

constructor TCuentaEstudio.Create(const AOwner: TComponent;
  const nombre: string; const OIDMoneda: integer);
begin
  inherited Create(AOwner, OIDMoneda);
  Crear(OIDMoneda);
end;

procedure TCuentaEstudio.EndEstudio;
begin
  inicializando := false;
end;

function TCuentaEstudio.TienePosicionAbierta(const OIDValor: integer): boolean;
begin
  result := PosicionesAbiertas.Locate('OR_VALOR', OIDValor, []);
end;

procedure TCuentaEstudio.Unload;
begin
  CuentaMovimientos.Close;
  CurvaCapital.Close;
  PosicionesAbiertas.Close;
  PosicionesCerradas.Close;
end;

end.

