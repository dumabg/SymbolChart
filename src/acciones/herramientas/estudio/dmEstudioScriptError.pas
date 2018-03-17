unit dmEstudioScriptError;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery;

type
  TEstudioScriptError = class(TDataModule)
    qEstrategia: TIBQuery;
    qEstrategiaESTRATEGIA_APERTURA: TMemoField;
    qEstrategiaESTRATEGIA_APERTURA_POSICIONADO: TMemoField;
    qEstrategiaESTRATEGIA_CIERRE: TMemoField;
    qEstrategiaESTRATEGIA_CIERRE_POSICIONADO: TMemoField;
  private
    { Private declarations }
  public
    constructor Create(Owner: TComponent; const OIDEstrategia: integer); reintroduce;
  end;


implementation

uses UtilDB, dmBD;

{$R *.dfm}

{ TEstudioScriptError }

constructor TEstudioScriptError.Create(Owner: TComponent;
  const OIDEstrategia: integer);
begin
  inherited Create(Owner);
  qEstrategia.Params[0].AsInteger := OIDEstrategia;
  OpenDataSet(qEstrategia);
end;

end.
