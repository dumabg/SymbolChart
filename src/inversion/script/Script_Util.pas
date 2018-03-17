unit Script_Util;

interface

uses
  SysUtils, Classes, ScriptObject, Controls;

type
  TScriptUtil = class(TScriptObject)
  protected
    function GetScriptInstance: TScriptObjectInstance; override;
  public
    { Public declarations }
  end;

  {$METHODINFO ON}
  TDiaSemana = (dsLunes, dsMartes, dsMiercoles, dsJueves, dsViernes, dsSabado, dsDomingo);

  TUtil = class(TScriptObjectInstance)
    function CurrToStr(Value: Currency): string;
    function IntToStr(Value: integer): string;
    function DiaSemana(Fecha: TDate): TDiaSemana;
    function Round(Value: currency): integer;
  end;
  {$METHODINFO OFF}

implementation

uses Script;

{ TUtil }

function TUtil.CurrToStr(Value: Currency): string;
begin
  result := SysUtils.CurrToStr(Value);
end;

function TUtil.DiaSemana(Fecha: TDate): TDiaSemana;
var dia: Word;
begin
  dia := DayOfWeek(Fecha);
  case dia of
    1 : result := dsDomingo;
    2 : result := dsLunes;
    3 : result := dsMartes;
    4 : result := dsMiercoles;
    5 : result := dsJueves;
    6 : result := dsViernes;
    7 : result := dsSabado;
    8 : result := dsDomingo;
    else
      raise Exception('DiaSemana incorrecto: ' + IntToStr(dia));
  end;
end;

function TUtil.IntToStr(Value: integer): string;
begin
  result := SysUtils.IntToStr(Value);
end;

function TUtil.Round(Value: currency): integer;
begin
  result := System.Round(Value);
end;

{ TScriptUtil }

function TScriptUtil.GetScriptInstance: TScriptObjectInstance;
begin
  result := TUtil.Create;
end;

initialization
  RegisterEnumeration('TDiaSemana', TypeInfo(TDiaSemana));

end.
