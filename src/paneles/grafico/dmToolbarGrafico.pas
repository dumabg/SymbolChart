unit dmToolbarGrafico;

interface

uses
  SysUtils, Classes, IBSQL, Graphics;

type
  TToolbarGrafico = class(TDataModule)
    uColor: TIBSQL;
  private
    { Private declarations }
  public
    procedure ModificarColor(const OIDFS: integer; const color: TColor);
  end;



implementation

uses dmBD, UtilDB;

{$R *.dfm}

{ TPanelGrafico }

procedure TToolbarGrafico.ModificarColor(const OIDFS: integer;
  const color: TColor);
begin
  uColor.ParamByName('COLOR').AsInteger := color;
  uColor.ParamByName('OIDFS').AsInteger := OIDFS;
  ExecQuery(uColor, true);
end;


end.
