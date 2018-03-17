unit ScriptEditorCodigoDatos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ScriptDatosEngine, uPSComponent, BDConstants, Script_Datos, Script_Util;

type
  TScriptEditorCodigoDatos = class(TScriptDatosEngine)
  private
    Util: TScriptUtil;
    sResultType: string;
    FResultType: TResultType;
    FOutVariableName: string;
    function GetValueBoolean: boolean;
    function GetValueCurrency: currency;
    function GetValueInteger: integer;
    function GetValueString: string;
    procedure SetOIDValor(const Value: integer);
    procedure SetResultType(const Value: TResultType);
    function GetOIDValor: integer;
    function GetOIDSesion: Integer;
    procedure SetOIDSesion(const Value: Integer);
  protected
    procedure OnCompile(Sender: TPSScript); override;
  public
    constructor Create(const verticalCache: boolean); reintroduce;
    destructor Destroy; override;
    property ResultType: TResultType read FResultType write SetResultType;
    property OIDValor: integer read GetOIDValor write SetOIDValor;
    property OIDSesion: Integer read GetOIDSesion write SetOIDSesion;
    property ValueString: string read GetValueString;
    property ValueBoolean: boolean read GetValueBoolean;
    property ValueInteger: integer read GetValueInteger;
    property ValueCurrency: currency read GetValueCurrency;
    property OutVariableName: string read FOutVariableName write FOutVariableName;
  end;


implementation

uses uPSI_Mensaje, upSI_Datos, upSI_Util, Script_Mensaje, uPSRuntime;

{ TScriptEditorCodigoDatos }

constructor TScriptEditorCodigoDatos.Create(const verticalCache: boolean);
begin
  inherited;
  // MUY IMPORTANTE el orden de registro de los plugin si un plugin usa
  // tipos definidos en otro plugin
  RegisterPlugin(TPSImport_Util, TScriptUtil);
  Util := TScriptUtil.Create;
  RegisterScriptRootClass('Util', Util);
end;

destructor TScriptEditorCodigoDatos.Destroy;
begin
  Util.Free;
  inherited;
end;

function TScriptEditorCodigoDatos.GetOIDSesion: Integer;
begin
  result := Datos.OIDSesion;
end;

function TScriptEditorCodigoDatos.GetOIDValor: integer;
begin
  result := Datos.OIDValor;
end;

function TScriptEditorCodigoDatos.GetValueBoolean: boolean;
begin
  Result := GetVariableBoolean(FOutVariableName);
end;

function TScriptEditorCodigoDatos.GetValueCurrency: currency;
begin
  result := GetVariableCurrency(FOutVariableName);
end;

function TScriptEditorCodigoDatos.GetValueInteger: integer;
begin
  result := GetVariableInteger(FOutVariableName);
end;

function TScriptEditorCodigoDatos.GetValueString: string;
begin
  result := GetVariableString(FOutVariableName);
end;

procedure TScriptEditorCodigoDatos.OnCompile(Sender: TPSScript);
begin
  if FOutVariableName <> '' then
    Sender.AddRegisteredVariable(FOutVariableName, sResultType);
  inherited;
end;

procedure TScriptEditorCodigoDatos.SetOIDSesion(const Value: Integer);
begin
  Datos.OIDSesion := Value;
end;

procedure TScriptEditorCodigoDatos.SetOIDValor(const Value: integer);
begin
  Datos.OIDValor := Value;
end;

procedure TScriptEditorCodigoDatos.SetResultType(const Value: TResultType);
begin
  FResultType := Value;
  case FResultType of
    rtBoolean: sResultType := 'boolean';
    rtString: sResultType := 'string';
    rtInteger: sResultType := 'integer';
    rtCurrency: sResultType := 'currency';
  end;
end;

end.
