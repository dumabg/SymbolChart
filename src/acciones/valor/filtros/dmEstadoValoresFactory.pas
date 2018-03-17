unit dmEstadoValoresFactory;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmEstadoValores, DB, IBCustomDataSet, IBQuery;

type
  TEstadoValoresFactory = class;
  TEstadoValoresFactoryClass = class of TEstadoValoresFactory;

  TEstadoValoresFactory = class(TEstadoValores)
    Valores: TIBQuery;
    procedure DataModuleCreate(Sender: TObject);
  protected
    procedure reloadValores;
  public
    procedure Clear;
  end;

function getEstadoValoresFactory(EstadoValoresFactoryClass:TEstadoValoresFactoryClass) : TEstadoValoresFactory;
procedure deleteEstadoValoresFactory;

implementation

uses dmData, dmBD;

var factory: TEstadoValoresFactory;

{$R *.dfm}

procedure deleteEstadoValoresFactory;
begin
  FreeAndNil(factory);
end;

function getEstadoValoresFactory(EstadoValoresFactoryClass:TEstadoValoresFactoryClass): TEstadoValoresFactory;
begin
  if factory = nil then
    factory := EstadoValoresFactoryClass.Create(nil);
  result := factory;
  if not result.Valores.Active then
    result.reloadValores;
end;

procedure TEstadoValoresFactory.Clear;
begin
  Valores.Close;
end;

procedure TEstadoValoresFactory.DataModuleCreate(Sender: TObject);
begin
  inherited;
  reloadValores;
end;

procedure TEstadoValoresFactory.reloadValores;
begin
  Valores.Close;
  Valores.ParamByName('OID_SESION').AsInteger := data.OIDSesion;
  Valores.Open;
end;

initialization
finalization
if factory <> nil then
  factory.Free;
end.
