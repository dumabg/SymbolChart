unit UtilList;

interface

uses Classes, JclVectors, JclAbstractContainers, SysUtils;

type
  EValueNotFound = class(Exception)
  private
    FName: string;
  public
    property name: string read FName;
  end;

  TNameValueList = class abstract(TObject)
  private
    function GetCount: integer;
    function GetName(const i: integer): string;
    procedure SetName(const i: integer; const Value: string);
  protected
    names: TStringList;
    function GetIndexName(const name: string): integer;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear; virtual;
    property Count: integer read GetCount;
    property Name[const i: integer]: string read GetName write SetName;
  end;

  TNameIntegerValueList = class(TNameValueList)
  private
    type
      TIntegerVector = class(TJclIntegerVector)
      end;
    var
    values: TIntegerVector;
    function GetNameValue(const name: string): integer;
    procedure SetNameValue(const name: string; const Value: integer);
    function GetValue(const i: integer): integer;
    procedure SetValue(const i: integer; const Value: integer);
  public
    property NameValue[const name: string]: integer read GetNameValue write SetNameValue;
    property Value[const i: integer]: integer read GetValue write SetValue;
    procedure Clear; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TNameCurrencyValueList = class(TNameValueList)
  private
    type
      TCurrencyVector = class(TJclExtendedVector)
    end;
    var values: TCurrencyVector;
    function GetNameValue(const name: string): currency;
    procedure SetNameValue(const name: string; const Value: currency);
    function GetValue(const i: integer): currency;
    procedure SetValue(const i: integer; const Value: currency);
  public
    property NameValue[const name: string]: currency read GetNameValue write SetNameValue;
    property Value[const i: integer]: currency read GetValue write SetValue;
    procedure Clear; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TNameStringValueList = class(TNameValueList)
  private
    values: TStringList;
    function GetNameValue(const name: string): string;
    procedure SetNameValue(const name: string; const Value: string);
    function GetValue(const i: integer): string;
    procedure SetValue(const i: integer; Value: string);
  public
    property NameValue[const name: string]: string read GetNameValue write SetNameValue;
    property Value[const i: integer]: string read GetValue write SetValue;
    procedure Clear; override;
    constructor Create; override;
    destructor Destroy; override;    
  end;

implementation

const CAPACITY = 10;

{ TNameIntegerValueList }


procedure TNameIntegerValueList.Clear;
begin
  inherited;
  values.Clear;
end;

constructor TNameIntegerValueList.Create;
begin
  inherited;
  values := TIntegerVector.Create(CAPACITY);
end;

destructor TNameIntegerValueList.Destroy;
begin
  values.Free;
  inherited;
end;

function TNameIntegerValueList.GetValue(const i: integer): integer;
begin
  result := values.Items[i];
end;

function TNameIntegerValueList.GetNameValue(const name: string): integer;
var i: integer;
begin
  i := GetIndexName(name);
  result := values.Items[i];
end;

procedure TNameIntegerValueList.SetValue(const i, Value: integer);
begin
  values.Items[i] := Value;
end;

procedure TNameIntegerValueList.SetNameValue(const name: string;
  const Value: integer);
begin
  names.Add(name);
  values.Add(value);
end;

{ TNameValueList }

procedure TNameValueList.Clear;
begin
  names.Clear;
end;

constructor TNameValueList.Create;
begin
  names := TStringList.Create;
  names.Duplicates := dupError;
end;

destructor TNameValueList.Destroy;
begin
  names.Free;
end;

function TNameValueList.GetCount: integer;
begin
  result := names.Count;
end;

function TNameValueList.GetIndexName(const name: string): integer;
var e: EValueNotFound;
begin
  result := names.IndexOf(name);
  if result = 0 then begin
    e := EValueNotFound.Create('Value not found');
    e.FName := name;
    raise e;
  end;
end;

function TNameValueList.GetName(const i: integer): string;
begin
  result := names[i];
end;

procedure TNameValueList.SetName(const i: integer; const Value: string);
begin
  names[i] := Value;
end;

{ TNameCurrencyValueList }

procedure TNameCurrencyValueList.Clear;
begin
  inherited;
  TCurrencyVector(values).Clear;
end;

constructor TNameCurrencyValueList.Create;
begin
  inherited;
  values := TCurrencyVector.Create(CAPACITY);
end;

destructor TNameCurrencyValueList.Destroy;
begin
  values.Free;
  inherited;
end;

function TNameCurrencyValueList.GetNameValue(const name: string): currency;
var i: integer;
begin
  i := GetIndexName(name);
  result := values.Items[i];
end;

function TNameCurrencyValueList.GetValue(const i: integer): currency;
begin
  result := values.Items[i];
end;

procedure TNameCurrencyValueList.SetNameValue(const name: string;
  const Value: currency);
begin
  names.Add(name);
  values.Add(value);
end;

procedure TNameCurrencyValueList.SetValue(const i: integer; const Value: currency);
begin
  values.Items[i] := Value;
end;

{ TNameStringValueList }

procedure TNameStringValueList.Clear;
begin
  names.Clear;
  values.Clear;
end;

constructor TNameStringValueList.Create;
begin
  inherited;
  values := TStringList.Create;
end;

destructor TNameStringValueList.Destroy;
begin
  values.Free;
  inherited;
end;

function TNameStringValueList.GetNameValue(const name: string): string;
var i: integer;
begin
  i := GetIndexName(name);
  result := values[i];
end;

function TNameStringValueList.GetValue(const i: integer): string;
begin
  result := values[i];
end;

procedure TNameStringValueList.SetNameValue(const name, Value: string);
begin
  names.Add(name);
  values.Add(value);
end;

procedure TNameStringValueList.SetValue(const i: integer; Value: string);
begin
  values[i] := Value;
end;

end.
