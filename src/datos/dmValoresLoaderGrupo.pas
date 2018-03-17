unit dmValoresLoaderGrupo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmValoresLoader, DB, IBCustomDataSet, IBQuery, IBSQL;

type
  TValoresLoaderGrupo = class(TValoresLoader)
  private
    OIDGrupo: integer;
  protected
    procedure LoadData; override;
  public
    constructor Create(OIDGrupo: integer); reintroduce;
  end;


implementation

uses dmBD;

{$R *.dfm}

{ TValoresLoaderGrupo }

constructor TValoresLoaderGrupo.Create(OIDGrupo: integer);
begin
  inherited Create;
  Self.OIDGrupo := OIDGrupo;
end;

procedure TValoresLoaderGrupo.LoadData;
begin
  qValores.Params[0].AsInteger := OIDGrupo;
  inherited LoadData;
end;

end.
