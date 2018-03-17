unit dataPanelEstrategia;

interface

uses Grafico, Tipos, IncrustedDatosLineLayer, uEstrategia;

type
  DataCacheInteger = record
    OIDSesion: Integer;
    Cierre: Currency;
    Valor: integer;
  end;
  TArrayDataCacheInteger = array of DataCacheInteger;
  PArrayDataCacheInteger = ^TArrayDataCacheInteger;

  TReglaResult = TEstrategiaResult;

  TEntrada = record
    alcista: boolean;
    fecha: TDateTime;
    posicion: currency;
    posicionMaximaPerdida: currency;
    fechaMaximaPerdida: TDateTime;
  end;

  TEntradas = array of TEntrada;

  TPosicion = record
    alcista: boolean;
    entrada: TDateTime;
    posicionEntrada: Currency;
    salida: TDateTime;
    posicionSalida: Currency;
    posicionMaximaPerdida: Currency;
    fechaMaximaPerdida: TDateTime;
  end;

  TPosiciones = array of TPosicion;

  TPanelEstrategia = class
  private
    FixedValues: TArrayCurrency;
    Cambios: TArrayCurrency;
    FPCambios, FPMaximos, FPMinimos: PArrayCurrency;
    FPFechas: PArrayDate;
    Estrategia: TEstrategia;
    ReglaResults: array of TReglaResult;
    FGrafico: TGrafico;
    FN: currency;
    FLIM: Currency;
    FPosiciones: TPosiciones;
    FPosicionesAbiertas: TPosiciones;
    FNumPosicionesAbiertas: integer;
    function GetReglaResult(i: integer): TReglaResult;
    function CalculateRegla(const i: integer): currency;
    procedure SetGrafico(const Value: TGrafico);
//    procedure RecalculateN(const i: integer);
    procedure SetN(const Value: currency);
    procedure SetEA(const Value: currency);
    procedure SetEB(const Value: currency);
    procedure SetEIA(const Value: currency);
    procedure SetEIB(const Value: currency);
    procedure SetEXA(const Value: currency);
    procedure SetEXB(const Value: currency);
    procedure SetEIZ(const Value: currency);
    procedure SetEXZ(const Value: currency);
    procedure SetEZ(const Value: currency);
    procedure SetLIM(const Value: currency);
    procedure LoadCotizacionMensaje(const OIDValor: integer; const arrayInteger: PArrayDataCacheInteger);
    procedure SetActivarInversaLDA(const Value: boolean);
    procedure SetActivarInversaLDB(const Value: boolean);
    procedure SetActivarInversaLDZ(const Value: boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadData(const PCambios, PMaximos, PMinimos: PArrayCurrency; const PFechas: PArrayDate);
    procedure CalcularRentabilidadSugerencia(const inversa: boolean);
    procedure CalcularRentabilidad(const alcista, inversa: boolean);
    procedure CalcularRentabilidad2(alcista, inversa: boolean);    
    procedure CalcularRentabilidadNormal(const OIDValor: integer; const alcista, inversa: boolean);
    procedure CalcularRentabilidadEntrarSalir(const alcista, inversa: boolean);
    property ReglaResult[i: integer]: TReglaResult read GetReglaResult;
    property Grafico: TGrafico read FGrafico write SetGrafico;
    property Posiciones: TPosiciones read FPosiciones;
    property PosicionesAbiertas: TPosiciones read FPosicionesAbiertas;
    property NumPosicionesAbiertas: integer read FNumPosicionesAbiertas;
    property N: currency write SetN;
    property EA: currency write SetEA;
    property EB: currency write SetEB;
    property EXA: currency write SetEXA;
    property EIA: currency write SetEIA;
    property EXB: currency write SetEXB;
    property EIB: currency write SetEIB;
    property EZ: currency write SetEZ;
    property EXZ: currency write SetEXZ;
    property EIZ: currency write SetEIZ;
    property LIM: currency read FLIM write SetLIM;
    property ActivarInversaLDA: boolean write SetActivarInversaLDA;
    property ActivarInversaLDB: boolean write SetActivarInversaLDB;
    property ActivarInversaLDZ: boolean write SetActivarInversaLDZ;
  end;

implementation

uses DatosGrafico, SCMain, Controls, dmBD, UtilDB, IBSQL, IBDatabase,
  dmDataComun, flags, mabg;

{ TPanelEstrategia }

procedure TPanelEstrategia.CalcularRentabilidad(const alcista, inversa: boolean);
var iPosiciones, i, j, k, num: Integer;
//  sugerencia: TSugerencia;
//  K22, K23, K21: currency;
  reglaCumplida: boolean;
  cierre: Currency;
  K21, K22, K23, B11, A13, A9: currency;
  RSIA, RSIB, OSZ, OSB, OSA: currency;
  desde: integer;
  entradas: array of TEntrada;
  numEntradas: integer;
  A11, Z11, LAL, LBL, LBC, LAC, LZC, LZL: Currency;
  K20: currency;

  procedure calcularMaximaPerdida;
  var j: Integer;
  begin
    if alcista then begin
      for j := 0 to numEntradas - 1 do begin
        if cierre < entradas[j].posicionMaximaPerdida then begin
            entradas[j].posicionMaximaPerdida := cierre;
            entradas[j].fechaMaximaPerdida := FPFechas^[i];
        end;
      end;
    end
    else begin
      for j := 0 to numEntradas - 1 do begin
        if cierre > entradas[j].posicionMaximaPerdida then begin
          entradas[j].posicionMaximaPerdida := cierre;
          entradas[j].fechaMaximaPerdida := FPFechas^[i];
        end;
      end;
    end;
  end;

begin
  SetLength(FPosiciones, 0);
  SetLength(entradas, 0);
  numEntradas := 0;
  iPosiciones := 0;
  num := length(ReglaResults) - 1;
  desde := 0;
  while FPCambios^[desde] = SIN_CAMBIO do
    Inc(desde);
  for I := desde + 23 to num do begin
    cierre := FPCambios^[i];
    K23 := cierre;
    K22 := FPCambios^[i - 1];
    K21 := FPCambios^[i - 2];
    K20 := FPCambios^[i - 3];
    RSIA := ReglaResult[i].RSIA;
    RSIB := ReglaResult[i].RSIB;
    OSA := ReglaResult[i].OSA;
    OSB := ReglaResult[i].OSB;
    OSZ := ReglaResult[i].OSZ;
//    IPU := ReglaResult[i].IPU;
//    VOLA := ReglaResult[i].VOLA;
    B11 := ReglaResult[i].B11;
    A13 := ReglaResult[i].A13;
    A9 := ReglaResult[i].A9;

    A11 := ReglaResult[i].A11;
    Z11 := ReglaResult[i].Z11;
    LBC := ReglaResult[i].LBC;
    LAC := ReglaResult[i].LAC;
    LAL := ReglaResult[i].LAL;
    LBL := ReglaResult[i].LBL;
    LZC := ReglaResult[i].LZC;
    LZL := ReglaResult[i].LZL;
    if numEntradas > 0 then begin
      if alcista then begin
        reglaCumplida := (K20>K21) AND (K21>K22) and (K22>K23);
//          ((K22 >= B11) AND (K23 < A13)) or
//          ((OSZ >=  100) AND (OSB >= 100) AND (OSA < 100))
      end
      else begin
//        reglaCumplida := not ((OSB <= LIM) and (OSA < LIM));
        reglaCumplida := false;
      end;
      calcularMaximaPerdida;
      if reglaCumplida then begin
        SetLength(FPosiciones, iPosiciones + numEntradas);
        k := 0;
        for j := iPosiciones to iPosiciones + numEntradas - 1 do begin
          FPosiciones[j].alcista := entradas[k].alcista;
          FPosiciones[j].entrada := entradas[k].fecha;
          FPosiciones[j].posicionEntrada := entradas[k].posicion;
          FPosiciones[j].salida := FPFechas^[i];
          FPosiciones[j].posicionSalida := cierre;
          FPosiciones[j].posicionMaximaPerdida := entradas[k].posicionMaximaPerdida;
          FPosiciones[j].fechaMaximaPerdida := entradas[k].fechaMaximaPerdida;
          Inc(k);
        end;
        numEntradas := 0;
        SetLength(entradas, 0);
        Inc(iPosiciones);
        ReglaResults[i].Msg := 'CERRAR'; //'SALIDA';
      end
      else begin
        if alcista then begin
          ReglaResults[i].Msg := 'MANTENER LARGO';
        end
        else
          ReglaResults[i].Msg := 'MANTENER CORTO';
//        ReglaResults[i].Msg := 'MANTENER';
      end;
    end
    else begin
//        if ((K22 >= B11) AND (K23 < A13)) or
//          ((OSZ >=  100) AND (OSB >= 100) AND (OSA < 100)) then
      if (K20>K21) AND (K21>K22) and (K22>K23) then
        ReglaResults[i].Msg := '(SALIR)'
      else
        ReglaResults[i].Msg := '';
    end;

    if alcista then
      reglaCumplida :=
        (K20<K21) AND (K21<K22) and (K22 < K23)
//        ((OSZ <= -100) AND (OSB <= -100) AND (OSA > -100)) or
//        ((K22 <= B11) AND (K23 > A9))
    else
//          reglaCumplida := (OSB > LIM) and (OSA <= LIM);
      reglaCumplida := false;
    if reglaCumplida then begin
      if numEntradas = 0 then begin
        inc(numEntradas);
        SetLength(entradas, numEntradas);
        if inversa then
          entradas[numEntradas - 1].alcista := not alcista
        else
          entradas[numEntradas - 1].alcista := alcista;
        entradas[numEntradas - 1].fecha := FPFechas^[i];
        entradas[numEntradas - 1].posicion := cierre;
        entradas[numEntradas - 1].posicionMaximaPerdida := cierre;
        entradas[numEntradas - 1].fechaMaximaPerdida := FPFechas^[i];
        if ReglaResults[i].Msg <> '' then
          ReglaResults[i].Msg := ReglaResults[i].Msg + '. ';
        if alcista then
          ReglaResults[i].Msg := ReglaResults[i].Msg + 'LARGO'
        else
          ReglaResults[i].Msg := ReglaResults[i].Msg + 'CORTO';
      end
      else begin
        if ReglaResults[i].Msg <> '' then
          ReglaResults[i].Msg := ReglaResults[i].Msg + '. ';
        ReglaResults[i].Msg := ReglaResults[i].Msg + '(ENTRAR)';
      end;
    end
    else begin
      if ReglaResults[i].Msg <> '' then
        ReglaResults[i].Msg := ReglaResults[i].Msg + '. ';
      ReglaResults[i].Msg := ReglaResults[i].Msg + 'ESPERAR';
    end;

    OSA := ReglaResults[i].OSA;
    OSB := ReglaResults[i].OSB;
    OSZ := ReglaResults[i].OSZ;
    if (OSZ < -100) and (OSB < -100) and (OSA < -100) and (OSA < OSB) then
      ReglaResults[i].Msg := ReglaResults[i].Msg + '. ACELERACIÓN BAJISTA';
    if (OSZ < -100) AND (OSB < -100) AND (OSA < -100) AND (OSA >= OSB) then
      ReglaResults[i].Msg := ReglaResults[i].Msg + '. FRENADO BAJISTA';
    if (OSZ > 100) and (OSB > 100) and (OSA > 100) AND (OSA > OSB) then
      ReglaResults[i].Msg := ReglaResults[i].Msg + '. ACELERACIÓN ALCISTA';
    if (OSZ > 100) AND (OSB > 100) AND (OSA > 100) AND (OSA <= OSB) then
      ReglaResults[i].Msg := ReglaResults[i].Msg + '. FRENADO ALCISTA';
    if (RSIA < 30) AND (RSIA >= 20) then
      ReglaResults[i].Msg := ReglaResults[i].Msg + '. SOBREVENDIDO';
    if (RSIA < 20) AND (RSIA >= 10) then
      ReglaResults[i].Msg := ReglaResults[i].Msg + '. MUY SOBREVENDIDO';
    if (RSIA < 10) then
      ReglaResults[i].Msg := ReglaResults[i].Msg + '. EXTREMADAMENTE SOBREVENDIDO';
    if (RSIA > 70) AND (RSIA <= 80) then
      ReglaResults[i].Msg := ReglaResults[i].Msg + '. SOBRECOMPRADO';
    if (RSIA > 80) AND (RSIA <= 90) then
      ReglaResults[i].Msg := ReglaResults[i].Msg + '. MUY SOBRECOMPRADO';
    if (RSIA > 90) then
      ReglaResults[i].Msg := ReglaResults[i].Msg + '. EXTREMADAMENTE SOBRECOMPRADO';
  end;

  FNumPosicionesAbiertas := numEntradas;
  SetLength(FPosicionesAbiertas, numEntradas);
  for i := 0 to numEntradas - 1 do begin
    FPosicionesAbiertas[i].alcista := entradas[i].alcista;
    FPosicionesAbiertas[i].entrada := entradas[i].fecha;
    FPosicionesAbiertas[i].posicionEntrada := entradas[i].posicion;
    FPosicionesAbiertas[i].posicionMaximaPerdida := entradas[i].posicionMaximaPerdida;
    FPosicionesAbiertas[i].fechaMaximaPerdida := entradas[i].fechaMaximaPerdida;
    FPosicionesAbiertas[i].salida := FPFechas^[num];
    FPosicionesAbiertas[i].posicionSalida := FPCambios^[num];
  end;
end;

procedure TPanelEstrategia.CalcularRentabilidad2(alcista,
  inversa: boolean);
var iPosiciones, i, j, k, num: Integer;
//  sugerencia: TSugerencia;
//  K22, K23, K21: currency;
  reglaCumplida: boolean;
  cierre: Currency;
  K21, K22, K23, B11, A13, A9: currency;
  RSIA, RSIB, OSZ, OSB, OSA: currency;
  desde: integer;
  entradas: array of TEntrada;
  numEntradas: integer;
  A11, Z11, LAL, LBL, LBC, LAC, LZC, LZL: Currency;
  K20: currency;
//  MAX20, MAX21, MAX22, MAX23, MIN20, MIN21, MIN22, MIN23: Currency;

  procedure calcularMaximaPerdida;
  var j: Integer;
  begin
    if alcista then begin
      for j := 0 to numEntradas - 1 do begin
        if cierre < entradas[j].posicionMaximaPerdida then begin
            entradas[j].posicionMaximaPerdida := cierre;
            entradas[j].fechaMaximaPerdida := FPFechas^[i];
        end;
      end;
    end
    else begin
      for j := 0 to numEntradas - 1 do begin
        if cierre > entradas[j].posicionMaximaPerdida then begin
          entradas[j].posicionMaximaPerdida := cierre;
          entradas[j].fechaMaximaPerdida := FPFechas^[i];
        end;
      end;
    end;
  end;

  procedure abrirPosicion;
  begin
    if numEntradas = 0 then begin
      inc(numEntradas);
      SetLength(entradas, numEntradas);
      if inversa then
        entradas[numEntradas - 1].alcista := not alcista
      else
        entradas[numEntradas - 1].alcista := alcista;
      entradas[numEntradas - 1].fecha := FPFechas^[i];
      if entradas[numEntradas - 1].alcista then begin
        entradas[numEntradas - 1].posicion := cierre; // FPMaximos^[i];
        entradas[numEntradas - 1].posicionMaximaPerdida := cierre; // FPMaximos^[i];
      end
      else begin
        entradas[numEntradas - 1].posicion := cierre;  //FPMinimos^[i];
        entradas[numEntradas - 1].posicionMaximaPerdida := cierre; // FPMinimos^[i];
      end;
      entradas[numEntradas - 1].fechaMaximaPerdida := FPFechas^[i];
      if ReglaResults[i].Msg <> '' then
        ReglaResults[i].Msg := ReglaResults[i].Msg + '. ';
      if alcista then
        ReglaResults[i].Msg := ReglaResults[i].Msg + 'LARGO'
      else
        ReglaResults[i].Msg := ReglaResults[i].Msg + 'CORTO';
    end
    else begin
      if ReglaResults[i].Msg <> '' then
        ReglaResults[i].Msg := ReglaResults[i].Msg + '. ';
      ReglaResults[i].Msg := ReglaResults[i].Msg + '(ENTRAR)';
    end;
  end;

begin
  SetLength(FPosiciones, 0);
  SetLength(entradas, 0);
  reglaCumplida := false;
  numEntradas := 0;
  iPosiciones := 0;
  num := length(ReglaResults) - 1;
  desde := 0;
  while FPCambios^[desde] = SIN_CAMBIO do
    Inc(desde);
  for I := desde + 23 to num do begin
    cierre := FPCambios^[i];
    K23 := cierre;
    K22 := FPCambios^[i - 1];
    K21 := FPCambios^[i - 2];
    K20 := FPCambios^[i - 3];
//    MAX23 := FPMaximos^[i];
//    MAX22 := FPMaximos^[i - 1];
//    MAX21 := FPMaximos^[i - 2];
//    MAX20 := FPMaximos^[i - 3];
//    MIN23 := FPMinimos^[i];
//    MIN22 := FPMinimos^[i - 1];
//    MIN21 := FPMinimos^[i - 2];
//    MIN20 := FPMinimos^[i - 3];
    RSIA := ReglaResult[i].RSIA;
    RSIB := ReglaResult[i].RSIB;
    OSA := ReglaResult[i].OSA;
    OSB := ReglaResult[i].OSB;
    OSZ := ReglaResult[i].OSZ;
//    IPU := ReglaResult[i].IPU;
//    VOLA := ReglaResult[i].VOLA;
    B11 := ReglaResult[i].B11;
    A13 := ReglaResult[i].A13;
    A9 := ReglaResult[i].A9;

    A11 := ReglaResult[i].A11;
    Z11 := ReglaResult[i].Z11;
    LBC := ReglaResult[i].LBC;
    LAC := ReglaResult[i].LAC;
    LAL := ReglaResult[i].LAL;
    LBL := ReglaResult[i].LBL;
    LZC := ReglaResult[i].LZC;
    LZL := ReglaResult[i].LZL;
    if numEntradas > 0 then begin
      calcularMaximaPerdida;
      if reglaCumplida then begin
        SetLength(FPosiciones, iPosiciones + numEntradas);
        k := 0;
        for j := iPosiciones to iPosiciones + numEntradas - 1 do begin
          FPosiciones[j].alcista := entradas[k].alcista;
          FPosiciones[j].entrada := entradas[k].fecha;
          FPosiciones[j].posicionEntrada := entradas[k].posicion;
          FPosiciones[j].salida := FPFechas^[i];
          if entradas[k].alcista then
            FPosiciones[j].posicionSalida := cierre //FPMinimos^[i]
          else
            FPosiciones[j].posicionSalida := cierre; // FPMaximos^[i];
          FPosiciones[j].posicionMaximaPerdida := entradas[k].posicionMaximaPerdida;
          FPosiciones[j].fechaMaximaPerdida := entradas[k].fechaMaximaPerdida;
          Inc(k);
        end;
        numEntradas := 0;
        SetLength(entradas, 0);
        Inc(iPosiciones);
        ReglaResults[i].Msg := 'CERRAR'; //'SALIDA';
        reglaCumplida := false;
      end
      else begin
        if alcista then begin
          //salida
          reglaCumplida := (K23 < A11) and (K22 >= B11) and (K21 >= Z11) and (K23 < K22) and
            (K22 <= K21) and (K21 <= K20);
          //(K20>K21) AND (K21>K22) and (K22>K23);
        end
        else begin
          reglaCumplida := false;
        end;
        if alcista then begin
          ReglaResults[i].Msg := 'MANTENER LARGO';
        end
        else
          ReglaResults[i].Msg := 'MANTENER CORTO';
      end;
    end
    else begin
      if reglaCumplida then begin
        abrirPosicion;
        reglaCumplida := false;
      end
      else begin
        if ReglaResults[i].Msg <> '' then
          ReglaResults[i].Msg := ReglaResults[i].Msg + '. ';
        ReglaResults[i].Msg := ReglaResults[i].Msg + 'ESPERAR';
        if alcista then
          // entrada
          reglaCumplida := (K23 > A11) and (K22 <= B11) and (K21 <= Z11) and (K23 > K22) and
            (K22 >= K21) and (K21 >= K20)
        else
          reglaCumplida := false;
      end;
    end;
  end;

  FNumPosicionesAbiertas := numEntradas;
  SetLength(FPosicionesAbiertas, numEntradas);
  for i := 0 to numEntradas - 1 do begin
    FPosicionesAbiertas[i].alcista := entradas[i].alcista;
    FPosicionesAbiertas[i].entrada := entradas[i].fecha;
    FPosicionesAbiertas[i].posicionEntrada := entradas[i].posicion;
    FPosicionesAbiertas[i].posicionMaximaPerdida := entradas[i].posicionMaximaPerdida;
    FPosicionesAbiertas[i].fechaMaximaPerdida := entradas[i].fechaMaximaPerdida;
    FPosicionesAbiertas[i].salida := FPFechas^[num];
    FPosicionesAbiertas[i].posicionSalida := FPCambios^[num];
  end;
end;

procedure TPanelEstrategia.CalcularRentabilidadEntrarSalir(const alcista,
  inversa: boolean);
var iPosiciones, i, num: Integer;
  dentro, first: boolean;
  reglaCumplida: boolean;
  entradaAlcista: boolean;
  entradaFecha: TDate;
  entradaPosicion: currency;
  posicionMaximaPerdida: currency;
  fechaMaximaPerdida: TDateTime;
  cierre: Currency;
  LAL, LAC: currency;
  desde: integer;
  K23, K22, K21, A11, B11, LBC, LZC, Z11, LZL, LBL: currency;
  K20: currency;
begin
  SetLength(FPosiciones, 0);
  iPosiciones := 0;
  dentro := False;
  num := length(ReglaResults) - 1;
  while FPCambios^[desde] = SIN_CAMBIO do
    Inc(desde);
  first := True;
  for I := desde + 3 to num do begin
    cierre := FPCambios^[i];
    K23 := cierre;
    K22 := FPCambios^[i - 1];
    K21 := FPCambios^[i - 2];
    K20 := FPCambios^[i - 3];
    LAL := ReglaResult[i].LAL;
    LAC := ReglaResult[i].LAC;
    A11 := ReglaResult[i].A11;
    B11 := ReglaResult[i].B11;
    LBC := ReglaResult[i].LBC;
    LZC := ReglaResult[i].LZC;
    Z11 := ReglaResult[i].Z11;
    LZL := ReglaResult[i].LZL;
    LBL := ReglaResult[i].LBL;
    if first then begin
       if false then begin
         entradaAlcista := true; //Está al contrario porque despues hay un not entradaAlcista
         first := false;
       end
       else begin
          if (K20<K21) AND (K21<K22) and
        (((K21<=LZC) AND (K22>=LBC) AND (K23>LAC)) OR
        ((K21<=Z11) AND (K22>=B11) AND (K23>A11)) OR
        ((K21<=LZL) AND (K22>=LBL) AND (K23>LAL))) then begin
            entradaAlcista := false; //Está al contrario porque despues hay un not entradaAlcista
            first := false;
          end;
       end;
       ReglaResults[i].Msg := '';
    end
    else begin
      if dentro then begin
        if entradaAlcista then begin
          reglaCumplida := ((K22<=K21) AND (K23<K22)) and
        (((K21>=LZC) AND (K22<=LBC) AND (K23<LAC)) OR
        ((K21>=Z11) AND (K22<=B11) AND (K23<A11)) OR
        ((K21>=LZL) AND (K22<=LBL) AND (K23<LAL)));
          if cierre < posicionMaximaPerdida then begin
            posicionMaximaPerdida := cierre;
            fechaMaximaPerdida := FPFechas^[i];
          end;
        end
        else begin
          reglaCumplida := ((K22>=K21) AND (K23>K22)) and
        (((K21<=LZC) AND (K22>=LBC) AND (K23>LAC)) OR
        ((K21<=Z11) AND (K22>=B11) AND (K23>A11)) OR
        ((K21<=LZL) AND (K22>=LBL) AND (K23>LAL)));
          if cierre > posicionMaximaPerdida then begin
            posicionMaximaPerdida := cierre;
            fechaMaximaPerdida := FPFechas^[i];
          end;
        end;
        if reglaCumplida then begin
          SetLength(FPosiciones, iPosiciones + 1);
          FPosiciones[iPosiciones].alcista := entradaAlcista;
          FPosiciones[iPosiciones].entrada := entradaFecha;
          FPosiciones[iPosiciones].posicionEntrada := entradaPosicion;
          FPosiciones[iPosiciones].salida := FPFechas^[i];
          FPosiciones[iPosiciones].posicionSalida := cierre;
          FPosiciones[iPosiciones].posicionMaximaPerdida := posicionMaximaPerdida;
          FPosiciones[iPosiciones].fechaMaximaPerdida := fechaMaximaPerdida;
          dentro := false;
          Inc(iPosiciones);
          if entradaAlcista then
            ReglaResults[i].Msg := 'CIERRA LARGO'
          else
            ReglaResults[i].Msg := 'CIERRA CORTO';
        end
        else begin
          if entradaAlcista then
            ReglaResults[i].Msg := 'MANTENER LARGO'
          else
            ReglaResults[i].Msg := 'MANTENER CORTO';
        end;
      end
      else begin
        entradaAlcista := not entradaAlcista;
        entradaFecha := FPFechas^[i];
        entradaPosicion := cierre;
        posicionMaximaPerdida := cierre;
        fechaMaximaPerdida := entradaFecha;
        if entradaAlcista then
          ReglaResults[i].Msg := 'ABRE LARGO'
        else
          ReglaResults[i].Msg := 'ABRE CORTO';
        dentro := true;
      end;
    end;
  end;

  if dentro then
    FNumPosicionesAbiertas := 1
  else
    FNumPosicionesAbiertas := 0;
  SetLength(FPosicionesAbiertas, FNumPosicionesAbiertas);
  if FNumPosicionesAbiertas > 0 then begin
    FPosicionesAbiertas[0].alcista := entradaAlcista;
    FPosicionesAbiertas[0].entrada := entradaFecha;
    FPosicionesAbiertas[0].posicionEntrada := entradaPosicion;
    FPosicionesAbiertas[0].posicionMaximaPerdida := posicionMaximaPerdida;
    FPosicionesAbiertas[0].fechaMaximaPerdida := fechaMaximaPerdida;
    FPosicionesAbiertas[0].salida := FPFechas^[num];
    FPosicionesAbiertas[0].posicionSalida := FPCambios^[num];
  end;
end;

procedure TPanelEstrategia.CalcularRentabilidadNormal(const OIDValor: integer; const alcista,
  inversa: boolean);
var iPosiciones, i, num: Integer;
  dentro: boolean;
  reglaCumplida: boolean;
  entradaAlcista: boolean;
  entradaFecha: TDate;
  entradaPosicion: currency;
  posicionMaximaPerdida: currency;
  fechaMaximaPerdida: TDateTime;
  cierre: currency;
  MensajeFlagsCache: TArrayDataCacheInteger;
  flags: TFlags;
  icMensaje, paMensaje: array[0..1] of TCaracteristicaFlag;
begin
  flags := TFlags.Create;
  icMensaje[0] := cInicioCiclo;
  icMensaje[1] := cInicioCicloVirtual;
  paMensaje[0] := cPrimeraAdvertencia;
  paMensaje[1] := cPrimeraAdvertenciaVirtual;
  SetLength(MensajeFlagsCache, 0);
  LoadCotizacionMensaje(OIDValor, PArrayDataCacheInteger(@MensajeFlagsCache));
  SetLength(FPosiciones, 0);
  iPosiciones := 0;
  dentro := False;
  num := length(MensajeFlagsCache) - 1;
  for I := 0 to num do begin
    cierre := MensajeFlagsCache[i].Cierre;
    flags.Flags := MensajeFlagsCache[i].Valor;
    if dentro then begin
      if alcista then begin
        reglaCumplida := flags.EsOR(paMensaje);
        if cierre < posicionMaximaPerdida then begin
          posicionMaximaPerdida := cierre;
          fechaMaximaPerdida := DataComun.FindFecha(MensajeFlagsCache[i].OIDSesion);
        end;
      end
      else begin
        reglaCumplida := flags.EsOR(icMensaje);
        if cierre > posicionMaximaPerdida then begin
          posicionMaximaPerdida := cierre;
          fechaMaximaPerdida := DataComun.FindFecha(MensajeFlagsCache[i].OIDSesion);
        end;
      end;
      if reglaCumplida then begin
        SetLength(FPosiciones, iPosiciones + 1);
        FPosiciones[iPosiciones].alcista := entradaAlcista;
        FPosiciones[iPosiciones].entrada := entradaFecha;
        FPosiciones[iPosiciones].posicionEntrada := entradaPosicion;
        FPosiciones[iPosiciones].salida := DataComun.FindFecha(MensajeFlagsCache[i].OIDSesion);
        FPosiciones[iPosiciones].posicionSalida := cierre;
        FPosiciones[iPosiciones].posicionMaximaPerdida := posicionMaximaPerdida;
        FPosiciones[iPosiciones].fechaMaximaPerdida := fechaMaximaPerdida;
        dentro := false;
        Inc(iPosiciones);
        ReglaResults[i].Msg := 'CERRAR';
      end
      else begin
        if alcista then
          ReglaResults[i].Msg := 'MANTENER LARGO'
        else
          ReglaResults[i].Msg := 'MANTENER CORTO';
      end;
    end
    else begin
      if alcista then
        reglaCumplida := flags.EsOR(icMensaje)
        else
        reglaCumplida := flags.EsOR(paMensaje);
      if reglaCumplida then begin
        dentro := true;
        if inversa then
          entradaAlcista := not alcista
        else
          entradaAlcista := alcista;
        entradaFecha := DataComun.FindFecha(MensajeFlagsCache[i].OIDSesion);
        entradaPosicion := cierre;
        posicionMaximaPerdida := cierre;
        fechaMaximaPerdida := entradaFecha;
        if alcista then
          ReglaResults[i].Msg := 'LARGO'
        else
          ReglaResults[i].Msg := 'CORTO';
      end
      else
        ReglaResults[i].Msg := 'ESPERAR';
    end;
  end;


  if dentro then
    FNumPosicionesAbiertas := 1
  else
    FNumPosicionesAbiertas := 0;
  SetLength(FPosicionesAbiertas, FNumPosicionesAbiertas);
  if FNumPosicionesAbiertas > 0 then begin
    FPosicionesAbiertas[0].alcista := entradaAlcista;
    FPosicionesAbiertas[0].entrada := entradaFecha;
    FPosicionesAbiertas[0].posicionEntrada := entradaPosicion;
    FPosicionesAbiertas[0].posicionMaximaPerdida := posicionMaximaPerdida;
    FPosicionesAbiertas[0].fechaMaximaPerdida := fechaMaximaPerdida;
    FPosicionesAbiertas[0].posicionSalida := MensajeFlagsCache[num].Cierre;;
    FPosicionesAbiertas[0].salida := DataComun.FindFecha(MensajeFlagsCache[num].OIDSesion);
  end;
  flags.Free;
end;

procedure TPanelEstrategia.CalcularRentabilidadSugerencia(
  const inversa: boolean);
var iPosiciones, i, num: Integer;
  dentro: boolean;
//  sugerencia: TSugerencia;
//  K22, K23, K21: currency;
  reglaCumplida: boolean;
  entradaAlcista: boolean;
  entradaFecha: TDate;
  entradaPosicion: currency;
  posicionMaximaPerdida: currency;
  fechaMaximaPerdida: TDateTime;
  cierre: Currency;
  LAL, LAC: currency;
  desde: integer;
  sugerencia: TSugerencia;

  function intentarEntrar: boolean;
  begin
      reglaCumplida := (sugerencia = tLargo) or (sugerencia = tCorto);
      if reglaCumplida then begin
        dentro := true;
        entradaAlcista := sugerencia = tLargo;
        if inversa then
          entradaAlcista := not entradaAlcista;
        entradaFecha := FPFechas^[i];
        entradaPosicion := cierre;
        posicionMaximaPerdida := cierre;
        fechaMaximaPerdida := entradaFecha;
        if entradaAlcista then
          ReglaResults[i].Msg := 'LARGO'
        else
          ReglaResults[i].Msg := 'CORTO';
      end;
      Result := reglaCumplida;
  end;
begin
  SetLength(FPosiciones, 0);
  iPosiciones := 0;
  dentro := False;
  num := length(ReglaResults) - 1;
  desde := 2;
  while FPCambios^[desde] = SIN_CAMBIO do
    Inc(desde);
  for I := desde to num do begin
    cierre := FPCambios^[i];
    LAL := ReglaResult[i].LAL;
    LAC := ReglaResult[i].LAC;
    sugerencia := ReglaResult[i].sugerencia;
    if dentro then begin
      if entradaAlcista then begin
        reglaCumplida := (sugerencia = tCorto) or (sugerencia = tEsperar);
        if cierre < posicionMaximaPerdida then begin
          posicionMaximaPerdida := cierre;
          fechaMaximaPerdida := FPFechas^[i];
        end;
      end
      else begin
        reglaCumplida := (sugerencia = tLargo) or (sugerencia = tEsperar);
        if cierre > posicionMaximaPerdida then begin
          posicionMaximaPerdida := cierre;
          fechaMaximaPerdida := FPFechas^[i];
        end;
      end;
      if reglaCumplida then begin
        SetLength(FPosiciones, iPosiciones + 1);
        FPosiciones[iPosiciones].alcista := entradaAlcista;
        FPosiciones[iPosiciones].entrada := entradaFecha;
        FPosiciones[iPosiciones].posicionEntrada := entradaPosicion;
        FPosiciones[iPosiciones].salida := FPFechas^[i];
        FPosiciones[iPosiciones].posicionSalida := cierre;
        FPosiciones[iPosiciones].posicionMaximaPerdida := posicionMaximaPerdida;
        FPosiciones[iPosiciones].fechaMaximaPerdida := fechaMaximaPerdida;
        dentro := false;
        Inc(iPosiciones);
        if (sugerencia = tLargo) or (sugerencia = tCorto) then begin
          if intentarEntrar then
            ReglaResults[i].Msg := 'CERRAR. ' + ReglaResults[i].Msg
          else
            ReglaResults[i].Msg := 'CERRAR';
        end
        else
          ReglaResults[i].Msg := 'CERRAR'; //'SALIDA';
      end
      else begin
        if entradaAlcista then
          ReglaResults[i].Msg := 'MANTENER'
        else
          ReglaResults[i].Msg := 'MANTENER';
      end;
    end
    else begin
      if not intentarEntrar then
        ReglaResults[i].Msg := 'ESPERAR';
    end;
  end;

  if dentro then
    FNumPosicionesAbiertas := 1
  else
    FNumPosicionesAbiertas := 0;
  SetLength(FPosicionesAbiertas, FNumPosicionesAbiertas);
  if FNumPosicionesAbiertas > 0 then begin
    FPosicionesAbiertas[0].alcista := entradaAlcista;
    FPosicionesAbiertas[0].entrada := entradaFecha;
    FPosicionesAbiertas[0].posicionEntrada := entradaPosicion;
    FPosicionesAbiertas[0].posicionMaximaPerdida := posicionMaximaPerdida;
    FPosicionesAbiertas[0].fechaMaximaPerdida := fechaMaximaPerdida;
    FPosicionesAbiertas[0].salida := FPFechas^[num];
    FPosicionesAbiertas[0].posicionSalida := FPCambios^[num];
  end;
end;

function TPanelEstrategia.CalculateRegla(const i: integer): currency;
var j: integer;
begin
  j := i - 1;
  ReglaResults[i] := Estrategia.Calculate(FPCambios, FPMaximos, FPMinimos, i,
    ReglaResults[j].LAL, ReglaResults[j].LAC, ReglaResults[j].LBC, ReglaResults[j].LBL);
//  Result := ReglaResults[i].resultado;
  result := ReglaResults[i].PRUA - ReglaResult[i].PRDA;
end;

constructor TPanelEstrategia.Create;
begin
  inherited;
  FN := -1;
  Estrategia := TEstrategia.Create;
  SetLength(FixedValues, 1);
  FixedValues[0] := 0;
  FLIM := 0;
end;

destructor TPanelEstrategia.Destroy;
begin
  Estrategia.Free;
  inherited;
end;

function TPanelEstrategia.GetReglaResult(i: integer): TReglaResult;
begin
  result := ReglaResults[i];
end;

procedure TPanelEstrategia.LoadCotizacionMensaje(const OIDValor: integer; const arrayInteger: PArrayDataCacheInteger);
var fieldOIDSesion, fieldCampo, fieldCierre: TIBXSQLVAR;
  i, num: integer;
  qData: TIBSQL;
  database: TIBDatabase;
begin
  database := BD.GetNewDatabase(nil, scdDatos, BD.BDDatos);
  try
    qData := TIBSQL.Create(nil);
    try
      qData.Database := database;
      qData.Transaction := database.DefaultTransaction;

      qData.SQL.Text := 'select count(*) from cotizacion c, cotizacion_mensaje cm, sesion s where ' +
        'c.OR_VALOR=:OID_VALOR and not c.CIERRE is null and c.OID_COTIZACION = cm.OR_COTIZACION and ' +
        'c.OR_SESION = s.OID_SESION';
      qData.Params[0].Value := OIDValor;
      ExecQuery(qData, false);
      num := qData.Fields[0].AsInteger;

      qData.Close;
      qData.SQL.Text := 'select c.OR_SESION, cm.FLAGS, c.CIERRE from cotizacion c, cotizacion_mensaje cm, sesion s where ' +
        'c.OR_VALOR=:OID_VALOR and not c.CIERRE is null and c.OID_COTIZACION = cm.OR_COTIZACION and ' +
        'c.OR_SESION = s.OID_SESION order by s.FECHA';
      qData.Params[0].Value := OIDValor;
      ExecQuery(qData, true);

      SetLength(arrayInteger^, num);
      fieldOIDSesion := qData.Fields[0];
      fieldCampo := qData.Fields[1];
      fieldCierre := qData.Fields[2];
      i := 0;
      while not qData.Eof do begin
        arrayInteger^[i].OIDSesion := fieldOIDSesion.AsInteger;
        arrayInteger^[i].Valor := fieldCampo.AsInteger;
        arrayInteger^[i].Cierre := fieldCierre.AsCurrency;
        qData.Next;
        inc(i);
      end;
    finally
      qData.Free;
    end;
  finally
    database.Free;
  end;
end;

procedure TPanelEstrategia.LoadData(const PCambios, PMaximos, PMinimos: PArrayCurrency; const PFechas: PArrayDate);
var i, j, num: integer;
begin
  FPCambios := PCambios;
  FPMaximos := PMaximos;
  FPMinimos := PMinimos;
  FPFechas := PFechas;
  num := Length(PCambios^);
  SetLength(Cambios, num);
  SetLength(ReglaResults, num);
  i := 0;
  while PCambios^[i] = SIN_CAMBIO do begin
    Cambios[i] := SIN_CAMBIO;
    inc(i);
  end;
  for j := 0 to 22 do begin
    Cambios[i] := SIN_CAMBIO;
    Inc(i);
  end;
  while i < num do begin
    Cambios[i] := CalculateRegla(i);
    inc(i);
  end;
  Grafico.SetData(@Cambios, pFechas);

  mabg.calcular(PCambios, PFechas);
end;

//procedure TPanelEstrategia.RecalculateN(const i: integer);
//var NA, NB, NCalculado: currency;
//begin
//  if FN = -1 then begin
//    NA := (A[10] + A[0]) / A[10];
//    NB := (B[10] + B[0]) / B[10];
//    NCalculado := (NA + NB) / 2;
//  end
//  else
//    NCalculado := FN;
//
//  ReglaResults[i].NCalculado := NCalculado;
//  ReglaResults[i].LDA := (ReglaResult[i].D1A + ReglaResult[i].D2A) / NCalculado;
//  ReglaResults[i].LDB := (ReglaResult[i].D1B + ReglaResult[i].D2B) / NCalculado;
//
//  CalcularLAL(i);
//  CalcularLAC(i);
//  CalcularLBC(i);
//  CalcularLBL(i);
//  CalcularResultado(i);
//  CalcularResultado2(i);
//end;


procedure TPanelEstrategia.SetActivarInversaLDA(const Value: boolean);
begin
  Estrategia.ActivarInversaLDA := value;
end;

procedure TPanelEstrategia.SetActivarInversaLDB(const Value: boolean);
begin
  Estrategia.ActivarInversaLDB := value;
end;

procedure TPanelEstrategia.SetActivarInversaLDZ(const Value: boolean);
begin
  Estrategia.ActivarInversaLDZ := value;
end;

procedure TPanelEstrategia.SetEA(const Value: currency);
begin
  Estrategia.EA := Value;
end;

procedure TPanelEstrategia.SetEB(const Value: currency);
begin
  Estrategia.EB := Value;
end;

procedure TPanelEstrategia.SetEIA(const Value: currency);
begin
  Estrategia.EIA := Value;
end;

procedure TPanelEstrategia.SetEIB(const Value: currency);
begin
  Estrategia.EIB := Value;
end;

procedure TPanelEstrategia.SetEIZ(const Value: currency);
begin
  Estrategia.EIZ := Value;
end;

procedure TPanelEstrategia.SetEXA(const Value: currency);
begin
  Estrategia.EXA := Value;
end;

procedure TPanelEstrategia.SetEXB(const Value: currency);
begin
  Estrategia.EXB := Value;
end;

procedure TPanelEstrategia.SetEXZ(const Value: currency);
begin
  Estrategia.EXZ := Value;
end;

procedure TPanelEstrategia.SetEZ(const Value: currency);
begin
  Estrategia.EZ := Value;
end;

procedure TPanelEstrategia.SetGrafico(const Value: TGrafico);
begin
  FGrafico := Value;
  FGrafico.Datos.MaximoManual := 100;
  FGrafico.Datos.MinimoManual := -100;
  FGrafico.Datos.DataNull := SIN_CAMBIO;
  FGrafico.ManualDecimals := 3;
//  FGrafico.ShowDecimals := false;
  FGrafico.FixedYValues := @FixedValues;
end;

procedure TPanelEstrategia.SetLIM(const Value: currency);
begin
  FLIM := Value;
end;

procedure TPanelEstrategia.SetN(const Value: currency);
begin
  FN := Value;
//  LoadData;
end;

end.
