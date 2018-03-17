unit UtilFiles;

interface

uses classes;

type
  TFileStreamNamed = class (TFileStream)
  private
    FFileName: string;
  public
    constructor Create(const FileName: AnsiString; Mode: Word);
    property FileName: string read FFileName write FFileName;
  end;

  function TempFileName: string;
  function TempFileStream: TFileStreamNamed;
  function ApplicationPath: string;

implementation

uses Windows, Forms, SysUtils;

var appPath: string;

function ApplicationPath: string;
begin
  result := appPath;
end;

function TempFileName: string;
var Temp : array [0..MAX_PATH] of char;
begin
  GetTempPath(MAX_PATH,Temp);
  GetTempFileName(Temp, 'sc', 0, Temp);
  result := string(Temp);
end;


function TempFileStream: TFileStreamNamed;
begin
  result := TFileStreamNamed.Create(TempFileName, fmCreate);
end;


{ TFileStreamNamed }

constructor TFileStreamNamed.Create(const FileName: AnsiString;
  Mode: Word);
begin
  inherited Create(FileName, Mode);
  Self.FileName := FileName;
end;

initialization
  appPath := ExtractFilePath(Application.Exename);

end.
