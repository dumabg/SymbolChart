unit dmValoresLoaderPais;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmValoresLoader, DB, IBCustomDataSet, IBQuery;

type
  TValoresLoaderPais = class(TValoresLoader)
  private
    Pais: string;
  protected
    procedure LoadData; override;
  public
    constructor Create(const Pais: string); reintroduce;
  end;


implementation

{$R *.dfm}

{ TValoresLoader1 }

constructor TValoresLoaderPais.Create(const Pais: string);
begin
  inherited Create;
  Self.Pais := Pais;
end;

procedure TValoresLoaderPais.LoadData;
begin
  qValores.Params[0].AsString := Pais;
  inherited;
end;

end.
