unit ConfigVisual;

interface

const
  VISTA_POR_DEFECTO: string = 'ð';
  VISTA_NINGUNA: string = '';

type
  // NO se debe heredar de TSistemaStorage (o de TConfiguracion),
  // ya que éste crea una conexión a la BD independiente y controla que solo
  // haya un acceso con crital sections, por lo que si se creara otro objeto,
  // sería otra conexión diferente y ya no habría sólo un acceso. Se debe delegar.
  TConfiguracionVisual = class
  private
    FVista: string;
    procedure SetVista(const Value: string);
  public
    procedure DeleteSeccion(const seccion: string);
    procedure Delete(const seccion, clave: string);
    function ReadCurrency(const seccion: string; const clave: string; const default: currency): currency;
    function ReadString(const seccion: string; const clave: string; const default: string): string;
    function ReadInteger(const seccion: string; const clave: string; const default: integer): integer;
    function ReadBoolean(const seccion: string; const clave: string; const default: boolean): boolean;
    function ReadDateTime(const seccion: string; const clave: string; const default: TDateTime): TDateTime;
    procedure WriteCurrency(const seccion: string; const clave: string; const valor: currency);
    procedure WriteString(const seccion: string; const clave: string; const valor: string);
    procedure WriteInteger(const seccion: string; const clave: string; const valor: integer);
    procedure WriteBoolean(const seccion: string; const clave: string; const valor: boolean);
    procedure WriteDateTime(const seccion: string; const clave: string; const valor: TDateTime);
    constructor Create;
    property Vista: string read FVista write SetVista;
  end;

  var ConfiguracionVisual: TConfiguracionVisual;

implementation

uses dmConfiguracion, SysUtils;

{ TConfiguracionVisual }

constructor TConfiguracionVisual.Create;
begin
  inherited;
  FVista := VISTA_NINGUNA;
end;

procedure TConfiguracionVisual.Delete(const seccion, clave: string);
begin
  Configuracion.Delete(FVista + '.' + seccion, clave);
end;

procedure TConfiguracionVisual.DeleteSeccion(const seccion: string);
begin
  Configuracion.DeleteSeccion(FVista + '.' + seccion);
end;

function TConfiguracionVisual.ReadBoolean(const seccion, clave: string;
  const default: boolean): boolean;
var s: string;
begin
  if FVista = VISTA_POR_DEFECTO then
    result := default
  else begin
    s := '.' + seccion;
    if FVista <> VISTA_NINGUNA then
      s := FVista + s;
    result := Configuracion.ReadBoolean(s, clave, default);
  end;
end;

function TConfiguracionVisual.ReadCurrency(const seccion, clave: string;
  const default: currency): currency;
var s: string;
begin
  if FVista = VISTA_POR_DEFECTO then
    result := default
  else begin
    s := '.' + seccion;
    if FVista <> VISTA_NINGUNA then
      s := FVista + s;
    result := Configuracion.ReadCurrency(s, clave, default);
  end;
end;

function TConfiguracionVisual.ReadDateTime(const seccion, clave: string;
  const default: TDateTime): TDateTime;
var s: string;
begin
  if FVista = VISTA_POR_DEFECTO then
    result := default
  else begin
    s := '.' + seccion;
    if FVista <> VISTA_NINGUNA then
      s := FVista + s;
    result := Configuracion.ReadDateTime(s, clave, default);
  end;
end;

function TConfiguracionVisual.ReadInteger(const seccion, clave: string;
  const default: integer): integer;
var s: string;
begin
  if FVista = VISTA_POR_DEFECTO then
    result := default
  else begin
    s := '.' + seccion;
    if FVista <> VISTA_NINGUNA then
      s := FVista + s;
    result := Configuracion.ReadInteger(s, clave, default);
  end;
end;

function TConfiguracionVisual.ReadString(const seccion, clave,
  default: string): string;
var s: string;
begin
  if FVista = VISTA_POR_DEFECTO then
    result := default
  else begin
    s := '.' + seccion;
    if FVista <> VISTA_NINGUNA then
      s := FVista + s;
    result := Configuracion.ReadString(s, clave, default);
  end;
end;

procedure TConfiguracionVisual.SetVista(const Value: string);
begin
  FVista := UpperCase(Value);
end;

procedure TConfiguracionVisual.WriteBoolean(const seccion, clave: string;
  const valor: boolean);
begin
  Configuracion.WriteBoolean(FVista + '.' + seccion, clave, valor);
end;

procedure TConfiguracionVisual.WriteCurrency(const seccion, clave: string;
  const valor: currency);
begin
  Configuracion.WriteCurrency(FVista + '.' + seccion, clave, valor);
end;

procedure TConfiguracionVisual.WriteDateTime(const seccion, clave: string;
  const valor: TDateTime);
begin
  Configuracion.WriteDateTime(FVista + '.' + seccion, clave, valor);
end;

procedure TConfiguracionVisual.WriteInteger(const seccion, clave: string;
  const valor: integer);
begin
  Configuracion.WriteInteger(FVista + '.' + seccion, clave, valor);
end;

procedure TConfiguracionVisual.WriteString(const seccion, clave, valor: string);
begin
  Configuracion.WriteString(FVista + '.' + seccion, clave, valor);
end;


end.
