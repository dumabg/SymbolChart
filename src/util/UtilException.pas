unit UtilException;

interface

uses SysUtils, Classes, Windows;

type
  ESymbolChart = class(Exception)
  protected
    function GetTechnicalInfo: string; virtual;
  public
    procedure AfterConstruction; override;
  end;


  ExceptionHelper = class helper for Exception
  public
    procedure ClearInfo;
    procedure AddInfo(const name, info: string);
    function GetInfo(const name: string): string;
  end;

  function GetStackTrace: TStringList;
  function GetStackTraceString: string;

implementation

uses
  JclDebug;

var GlobalInfo: TStringList;

  function GetStackTrace: TStringList;
  var stack: TJclStackInfoList;
  begin
   result := TStringList.Create;
    try
      stack := JclLastExceptStackList;
      if Assigned(stack) then begin
        try
          stack.AddToStrings(result);
        finally
          stack.Free;
        end;
      end;
    except
    end;
  end;

  function GetStackTraceString: string;
   var stack: TStringList;
  begin
    try
      stack := GetStackTrace;
      try
        result := stack.Text;
      finally
        stack.Free;
      end;
    except
      result := '';
    end;
  end;


{ TExceptionClassHelper }

procedure ExceptionHelper.AddInfo(const name, info: string);
begin
  GlobalInfo.Add(name + '=' + info);
end;

procedure ExceptionHelper.ClearInfo;
begin
  GlobalInfo.Clear;
end;

function ExceptionHelper.GetInfo(const name: string): string;
begin
  result := GlobalInfo.Values[name];
end;

{ ESymbolChart }

procedure ESymbolChart.AfterConstruction;
var techInfo: string;
begin
  inherited;
  Message := Message + sLineBreak + sLineBreak +
    'Información técnica del error: ' + ClassName;
  techInfo := GetTechnicalInfo;
  if techInfo <> '' then
    Message := Message + sLineBreak + techInfo;
end;

function ESymbolChart.GetTechnicalInfo: string;
begin
  result := '';
end;

initialization
  GlobalInfo := TStringList.Create;
finalization
  FreeAndNil(GlobalInfo);
end.
