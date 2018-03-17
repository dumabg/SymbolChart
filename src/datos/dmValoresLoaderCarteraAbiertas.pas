unit dmValoresLoaderCarteraAbiertas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmValoresLoader, DB, IBCustomDataSet, IBQuery, IBSQL;

type
  TValoresLoaderCarteraAbiertas = class(TValoresLoader)
  private
    OIDCartera: integer;
  protected
    procedure LoadData; override;
  public
    constructor Create(OIDCartera: integer); reintroduce;
  end;


implementation

uses dmBD;

{$R *.dfm}

{ TValoresLoaderCarteraAbiertas }

constructor TValoresLoaderCarteraAbiertas.Create(OIDCartera: integer);
begin
  inherited Create;
  Self.OIDCartera := OIDCartera;
end;

procedure TValoresLoaderCarteraAbiertas.LoadData;
begin
  qValores.Params[0].AsInteger := OIDCartera;
  inherited LoadData;
end;

end.
