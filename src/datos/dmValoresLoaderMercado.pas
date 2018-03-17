unit dmValoresLoaderMercado;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmValoresLoader, DB, IBCustomDataSet, IBQuery, IBSQL;

type
  TValoresLoaderMercado = class(TValoresLoader)
  private
    OIDMercado: integer;
  protected
    procedure LoadData; override;
  public
    constructor Create(OIDMercado: integer); reintroduce;
  end;


implementation

{$R *.dfm}

{ TValoresLoaderMercado }

constructor TValoresLoaderMercado.Create(OIDMercado: integer);
begin
  inherited Create;
  Self.OIDMercado := OIDMercado;
end;

procedure TValoresLoaderMercado.LoadData;
begin
  qValores.Params[0].AsInteger := OIDMercado;
  inherited LoadData;
end;

end.
