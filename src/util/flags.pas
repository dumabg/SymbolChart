unit flags;

interface

type
  TCaracteristicaFlag = (
    cInicioCiclo, cInicioCicloVirtual, cMantener,
    cPrimeraAdvertencia, cPrimeraAdvertenciaVirtual, cAdvertencia,
    cResistenciaPura, cFranjaResistencia, cAreasResistencia,
    cSoportePuro, cFranjaSoporte, cAreasSoporte,
    cAcumulacion, cPreparandoAcumulacion, cDistribucion, cPreparandoDistribucion,
    cRemontar, cAgregar, cAlza, cFalsaAlarma, cSeguridad, cSiempreCuando,
    cSueloInminente, cSueloBusqueda, cSueloProvisional,
    cTechoInminente, cTechoBusqueda, cTechoProvisional);

  TFlags = class
  private
    FFlags: Integer;
  public
    constructor Create;
    procedure Clear;
    procedure SetCaracteristica(const caracteristica: TCaracteristicaFlag;
      const activa: boolean = true);
    function Es(const caracteristica: TCaracteristicaFlag): boolean;
    function EsOR(const caracteristicas: array of TCaracteristicaFlag): boolean;
    function EsAND(const caracteristicas: array of TCaracteristicaFlag): boolean;
    property Flags: Integer read FFlags write FFlags;
  end;

  function StringToFlag(const cad: string): TCaracteristicaFlag;
  function CaracteristicaToSQL(const caracteristica: TCaracteristicaFlag): string;

implementation

uses Classes, SysUtils;

function StringToFlag(const cad: string): TCaracteristicaFlag;
begin
  if cad = 'ADVERTENCIA' then
    result := cAdvertencia
  else
    if cad = 'Primera ADVERTENCIA' then
      result := cPrimeraAdvertencia
    else
      if cad = 'Primera ADVERTENCIA virtual' then
        result := cPrimeraAdvertenciaVirtual
      else
        if cad = 'INICIO DE CICLO' then
          result := cInicioCiclo
        else
          if cad = 'INICIO VIRTUAL DE CICLO' then
            result := cInicioCicloVirtual
          else
            if cad = 'MANTENER' then
              result := cMantener
            else
              if cad = 'SOPORTE puro' then
                result := cSoportePuro
              else
                if cad = 'Franja de SOPORTE' then
                  result := cFranjaSoporte
                else
                  if cad = 'RESISTENCIA pura' then
                    result := cResistenciaPura
                  else
                    if cad = 'Franja de RESISTENCIA' then
                      result := cFranjaResistencia
                    else
                      if cad = 'SUELO inminente' then
                        result := cSueloInminente
                      else
                        if cad = 'SUELO provisional' then
                          result := cSueloProvisional
                        else
                          if cad = 'Búsqueda de SUELO' then
                            result := cSueloBusqueda
                          else
                            if cad = 'TECHO inminente' then
                              result := cTechoInminente
                            else
                              if cad = 'TECHO provisional' then
                                result := cTechoProvisional
                              else
                                if cad = 'Búsqueda de TECHO' then
                                  result := cTechoBusqueda
                                else
                                  if cad = 'SEGURIDAD' then
                                    result := cSeguridad
                                  else
                                    if cad = 'ACUMULACION' then
                                      result := cAcumulacion
                                    else
                                      if cad = 'Preparando ACUMULACION' then
                                        result := cPreparandoAcumulacion
                                      else
                                        if cad = 'DISTRIBUCION' then
                                          result := cDistribucion
                                        else
                                          if cad = 'Preparando DISTRIBUCION' then
                                            result := cPreparandoDistribucion
                                          else
                                            if cad = 'AGREGAR' then
                                              result := cAgregar
                                            else
                                              if cad = 'ALZA' then
                                                result := cAlza
                                              else
                                                if cad = 'FALSA ALARMA' then
                                                  result := cFalsaAlarma
                                                else
                                                  if cad = 'REMONTAR' then
                                                    result := cRemontar
                                                  else
                                                    if cad = 'SIEMPRE Y CUANDO' then
                                                      result := cSiempreCuando
                                                    else
                                                      raise Exception.Create('No existe flag para ' + cad);
end;


function CaracteristicaToSQL(const caracteristica: TCaracteristicaFlag): string;
var num: integer;
  flag: string;
begin
  num := 1 shl integer(caracteristica);
  flag := IntToStr(num);
  result := '(BIN_AND(CM.FLAGS,' + flag + ') = ' + flag + ')';
end;

{ TFlags }

procedure TFlags.Clear;
begin
  FFlags := 0;
end;

constructor TFlags.Create;
begin
  FFlags := 0;
end;


function TFlags.Es(const caracteristica: TCaracteristicaFlag): boolean;
var bit: integer;
begin
  bit := 1 shl integer(caracteristica);
  result := FFlags and bit = bit;
end;

function TFlags.EsAND(
  const caracteristicas: array of TCaracteristicaFlag): boolean;
var i: integer;
begin
  result := false;
  for i := Low(caracteristicas) to High(caracteristicas) do begin
    result := Es(caracteristicas[i]);
    if not result then
      exit;
  end;
end;

function TFlags.EsOR(
  const caracteristicas: array of TCaracteristicaFlag): boolean;
var i: integer;
begin
  result := false;
  for i := Low(caracteristicas) to High(caracteristicas) do begin
    result := Es(caracteristicas[i]);
    if result then
      exit;
  end;
end;

procedure TFlags.SetCaracteristica(const caracteristica: TCaracteristicaFlag;
  const activa: boolean);
var bit: integer;
begin
  bit := 1 shl integer(caracteristica);
  if activa then
    FFlags := FFlags or bit
  else
    FFlags := FFlags and (not bit);
end;

end.
