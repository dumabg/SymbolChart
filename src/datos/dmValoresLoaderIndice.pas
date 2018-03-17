unit dmValoresLoaderIndice;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmValoresLoader, DB, IBCustomDataSet, IBQuery, IBSQL;

type
  TValoresLoaderIndice = class(TValoresLoader)
  private
    OIDIndice: integer;
  protected
    procedure LoadData; override;
  public
    constructor Create(OIDIndice: integer); reintroduce;
  end;


implementation

{$R *.dfm}

{ TValoresLoaderIndice }

constructor TValoresLoaderIndice.Create(OIDIndice: integer);
begin
  inherited Create;
  Self.OIDIndice := OIDIndice;
end;

procedure TValoresLoaderIndice.LoadData;
begin
  qValores.Params[0].AsInteger := OIDIndice;
  inherited LoadData;
end;

end.
