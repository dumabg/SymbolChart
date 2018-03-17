unit dmImportarDatos;

interface

uses
  Windows, SysUtils, Classes, DB, IBCustomDataSet, IBQuery, IBSQL,
  AbUnzper, UtilFiles,
  auHTTP, IBUpdateSQL, kbmMemTable, Provider, dmBD, UtilDB, IBDatabase;

type
  EImportarDatos = class(Exception);

  EStructureChange = class(Exception);

  TImportarDatos = class(TDataModule)
    Modificaciones: TkbmMemTable;
    ModificacionesOID_MODIFICACION: TSmallintField;
    ModificacionesCOMENTARIO: TStringField;
    ModificacionesSENTENCIAS: TMemoField;
    ModificacionesHECHO: TBooleanField;
    ModificacionesTIPO: TStringField;
  private
    FPerCentWindowReceiver: HWND;
    canceled: boolean;
    FCommited: boolean;
    FSemanal: boolean;
    FDiario: Boolean;
    IBSQLDiario, IBSQLSemanal, IBSQLComun: TIBSQL;
    NumImportados, Total: integer;
    LastOIDModificacion: integer;
    procedure InicializarTotal(const ZIP: TAbUnZipper);
    procedure import(ZIP: TAbUnZipper);
    procedure AsignarFieldSiguienteValor(const field: TField; const linea: string;
      var posicion: integer);
    function FechaStringToDate(const fecha: string): TDateTime;
    function importData(const ZIP: TAbUnZipper; const SCDatabase: TSCDatabase;
      const tipoBD: TBDDatos; const tabla, dataName: string): integer;
    procedure CargarModificaciones(ZIP: TAbUnZipper);
    procedure ImportarModificacion;
    function GetHayModificaciones: boolean;
    procedure NuevoValor(const iData: TIBSQL);
  protected
    procedure ImportarDatos(fileName: TFileName);
    function getLinea(datos: string; var posicion: integer; var ultimaLinea: boolean): string;
    function getSiguienteValor(linea: string; var posicion: integer): string;
  public
    constructor Create(AOwner: TComponent; IBSQLDiario, IBSQLSemanal, IBSQLComun: TIBSQL); reintroduce;
    procedure CancelCurrentOperation;
    procedure Importar(const DataFileName: TFileName; const PerCentWindowReceiver: HWND);
    procedure ImportarModificaciones(const transaction: TIBTransaction);
    property Diario: Boolean read FDiario write FDiario;
    property Semanal: boolean read FSemanal write FSemanal;
    property Commited: boolean read FCommited;
    property HayModificaciones: boolean read GetHayModificaciones;
  end;

implementation

uses AbUtils, strUtils, dmInternalServer, AbZipTyp, UserServerCalls, UtilString, dmConfiguracion,
  UserMessages, Forms, IB, dmDataComun;

{$R *.dfm}

type
  TTipoDato = record
    outParam: string;
    BD: TSCDatabase;
    tipoBD: TBDDatos;
    tabla: string;
  end;


const
  DELIMITADOR_SENTENCIAS = '#';
  Datos: array[0..15] of TTipoDato = (
    (outParam: 'valor'; BD: scdComun; tipoBD: bddDiaria; tabla: 'valor'),
    (outParam: 'd_sesion'; BD: scdDatos; tipoBD: bddDiaria; tabla: 'sesion'),
    (outParam: 'd_sesion_rentabilidad'; BD: scdDatos; tipoBD: bddDiaria; tabla: 'sesion_rentabilidad'),
    (outParam: 'd_cotizacion'; BD: scdDatos; tipoBD: bddDiaria; tabla: 'cotizacion'),
    (outParam: 'd_cotizacion_rentabilidad'; BD: scdDatos; tipoBD: bddDiaria; tabla: 'cotizacion_rentabilidad'),
    (outParam: 'd_cotizacion_estado'; BD: scdDatos; tipoBD: bddDiaria; tabla: 'cotizacion_estado'),
    (outParam: 'frase'; BD: scdComun; tipoBD: bddDiaria; tabla: 'FRASE'),
    (outParam: 'mensaje'; BD: scdComun; tipoBD: bddDiaria; tabla: 'MENSAJE'),
    (outParam: 'mensaje_frase'; BD: scdComun; tipoBD: bddDiaria; tabla: 'MENSAJE_FRASE'),
    (outParam: 'd_cotizacion_mensaje'; BD: scdDatos; tipoBD: bddDiaria; tabla: 'cotizacion_mensaje'),
    (outParam: 's_sesion'; BD: scdDatos; tipoBD: bddSemanal; tabla: 'sesion'),
    (outParam: 's_sesion_rentabilidad'; BD: scdDatos; tipoBD: bddSemanal; tabla: 'sesion_rentabilidad'),
    (outParam: 's_cotizacion'; BD: scdDatos; tipoBD: bddSemanal; tabla: 'cotizacion'),
    (outParam: 's_cotizacion_rentabilidad'; BD: scdDatos; tipoBD: bddSemanal; tabla: 'cotizacion_rentabilidad'),
    (outParam: 's_cotizacion_estado'; BD: scdDatos; tipoBD: bddSemanal; tabla: 'cotizacion_estado'),
    (outParam: 's_cotizacion_mensaje'; BD: scdDatos; tipoBD: bddSemanal; tabla: 'cotizacion_mensaje'));

resourcestring
  ERROR_NO_FILE = 'No se ha encontrado el fichero temporal de descarga.';
  ERROR_NO_DATA = 'No se ha descargado ningún dato.';
  ERROR_CORRUPT_FILE = 'El fichero temporal de descarga está corrupto, no se puede importar.';
  ERROR_TOTAL = 'No se han descargado correctamente los datos.';
  ABORT_MSG = 'Cancelado por el usuario';
  NUEVO_VALOR = 'Se ha incorporado el valor %s - %s al mercado %s.';

procedure TImportarDatos.import(ZIP: TAbUnZipper);
var tabla: string;
  i: integer;
  tipoDato: TTipoDato;

    function internalImport: integer;
    var i: integer;
      found, multiple: boolean;
      importing: string;
    begin
      importing := tipoDato.outParam;
      found := ZIP.FindFile(importing) <> -1;
      multiple := false;
      if not found then begin
        found := ZIP.FindFile(importing + '_0') <> -1;
        multiple := found;
      end;
      if found then begin
        if multiple then begin
          result := 0;
          i := 0;
          repeat
            try
              result := result + importData(ZIP, tipoDato.BD, tipoDato.tipoBD, tipoDato.tabla, importing + '_' + IntToStr(i));
            except
              on e: Exception do begin
                e.Message := e.Message + sLineBreak + 'File=' + tabla + '_' + IntToStr(i);
                raise;
              end;
            end;
            inc(i);
            found := ZIP.FindFile(importing + '_' + IntToStr(i)) <> -1;
          until not found;
        end
        else
          result := importData(ZIP, tipoDato.BD, tipoDato.tipoBD, tipoDato.tabla, importing);
      end
      else
        result := 0;
    end;
begin
  InicializarTotal(ZIP);
  CargarModificaciones(ZIP);
  NumImportados := 0;
  for i := Low(Datos) to High(Datos) do begin
    if canceled then
      raise EAbort.Create(ABORT_MSG);
    tipoDato := Datos[i];
    tabla := tipoDato.tabla;
    internalImport;
  end;
end;

function TImportarDatos.importData(const ZIP: TAbUnZipper; const SCDatabase: TSCDatabase;
    const tipoBD: TBDDatos; const tabla, dataName: string): integer;
var campos: TStringList;
  mem: TStringStream;
  offset, j, numCampos: integer;
  linea: string;
  position, positionValor: integer;
  finalDatos: boolean;
  datos: string;
  iData: TIBSQL;
  perCent: integer;
  esValor: boolean;

    function GetInsert: string;
    var i, num: integer;
      sql, values: string;
    begin
      num := numCampos - 1;
      sql := 'insert into ' + tabla + '(';
      values := '';
      for i := 0 to num do begin
        sql := sql + campos[i];
        values := values + ':' + campos[i];
        if i < num then begin
          sql := sql + ',';
          values := values + ',';
        end;
      end;
      result := sql + ') values (' + values + ')';
    end;

    procedure AmpliarColumnaMensaje(const campo: string; const largo: integer);
    var alterMensaje: TIBSQL;
      transaction: TIBTransaction;
    begin
      transaction := TIBTransaction.Create(nil);
      try
        alterMensaje := TIBSQL.Create(nil);
        try
          alterMensaje.Database := iData.Database;
          transaction.AddDatabase(alterMensaje.Database);
          alterMensaje.Transaction := transaction;
          alterMensaje.SQL.Text := 'alter table cotizacion_mensaje alter ' +
            campo + ' type varchar(' + IntToStr(largo) + ')';
          ExecQuery(alterMensaje, true);
        finally
          alterMensaje.Free;
          end;
      finally
        transaction.Free;
      end;
    end;

    procedure asignarValor(const campo, valor: string);
    begin
      if valor = '<null>' then
        iData.ParamByName(campo).Clear
      else begin
        if Pos('FECHA', campo) > 0 then
          iData.ParamByName(campo).AsDate := FechaStringToDate(valor)
        else begin
          try
            iData.ParamByName(campo).AsString := valor;
          except
            on e: EIBClientError do begin
              if (e.SQLCode = integer(ibxeStringTooLarge)) and (tabla = 'cotizacion_mensaje') then begin
                AmpliarColumnaMensaje(campo, Length(valor));
                raise EStructureChange.Create('');
              end
              else
                raise;
            end;
          end;
        end;
      end;
    end;

//    procedure ClearParams;
//    var i: integer;
//    begin
//      for i := numCampos -1 downto 0 do
//        iData.Params[i].Clear;
//    end;

    procedure inicializarIData;
    begin
      if SCDatabase = scdComun then begin
        iData := IBSQLComun;
      end
      else begin
        if tipoBD = bddDiaria then
          iData := IBSQLDiario
        else
          iData:= IBSQLSemanal;
      end;
      iData.SQL.Text := GetInsert;
    end;

begin
  mem := TStringStream.Create('');
  try
    ZIP.ExtractToStream(dataName, mem);
    if mem.Size <> 0 then begin
      position := 1;
      positionValor := 1;

      datos := mem.DataString;
      if datos = '' then //Si no se consigue ningún dato, se mira si están en UTF8
        datos := UTF8Decode(mem.DataString);
      campos := TStringList.Create;
      try
        linea := getLinea(datos, position, finalDatos);
        offset := Pos(SEPARADOR_COLUMNA, linea);
        if linea <> '' then begin
          while offset <> 0 do begin
            campos.Add(getSiguienteValor(linea, positionValor));
            offset := PosEx(SEPARADOR_COLUMNA, linea, offset + 1);
          end;
          campos.Add(getSiguienteValor(linea, positionValor));
        end;
        numCampos := campos.Count;
        finalDatos := numCampos = 0;
        result := 0;
        if not finalDatos then begin
          inicializarIData;
          esValor := tabla = 'valor';
          repeat
            if canceled then
              raise EAbort.Create(ABORT_MSG);
            inc(result);
            linea := getLinea(datos, position, finalDatos);
            if linea = '' then
              finalDatos := true
            else begin
              positionValor := 1;
              for j := 0 to numCampos - 1 do
                asignarValor(campos[j], getSiguienteValor(linea, positionValor));
              try
                ExecQuery(iData, false);
                if esValor then
                  NuevoValor(iData);
                Inc(NumImportados);
                perCent := Trunc(NumImportados * 100 / Total);
                PostMessage(FPerCentWindowReceiver, WM_PERCENT, perCent, 0);
                Application.ProcessMessages;
              except
                on e: Exception do begin
                  e.Message := e.Message + sLineBreak + 'Linea=' + linea;
                  raise;
                end;
              end;
            end;
          until finalDatos;
        end;
      finally
        campos.Free;
      end;
    end
    else
      result := 0;
  finally
    mem.Free;
  end;
end;

procedure TImportarDatos.Importar(const DataFileName: TFileName;
  const PerCentWindowReceiver: HWND);
begin
  FCommited := false;
  FPerCentWindowReceiver := PerCentWindowReceiver;
  ImportarDatos(DataFileName);
end;

procedure TImportarDatos.ImportarDatos(fileName: TFileName);
var ZIP: TAbUnZipper;
  fileStream: TFileStream;
begin
  if not FileExists(fileName) then
      raise EImportarDatos.Create(ERROR_NO_FILE);

  fileStream := TFileStream.Create(fileName, fmOpenRead);
  try
    if fileStream.Size = 0 then
      raise EImportarDatos.Create(ERROR_NO_DATA);
    if VerifyZip(fileStream) <> atZip then
      raise EImportarDatos.Create(ERROR_CORRUPT_FILE);
  finally
    fileStream.Free;
  end;
  ZIP := TAbUnZipper.Create(nil);
  try
    ZIP.ForceType := true;
    ZIP.ArchiveType := atZip;
    ZIP.FileName := fileName;
//    try
      import(ZIP);
{    finally
      ZIP.CloseArchive;
    end;}
  finally
    ZIP.Free;
  end;
end;


procedure TImportarDatos.ImportarModificacion;
var iData: TIBSQL;
  sentencias: TStringList;
  tipo: string;
  OIDModificacion: integer;

    procedure Importar;
    var i: integer;
    begin
      for i := 0 to sentencias.Count - 1 do begin
        Application.ProcessMessages;
        if canceled then
          raise EAbort.Create(ABORT_MSG);
        iData.SQL.Clear;
        iData.SQL.Text := sentencias[i];
        ExecQuery(iData, false);
      end;
    end;
begin
  sentencias := TStringList.Create;
  try
    tipo := ModificacionesTIPO.Value;
    if tipo = 'C' then
      iData := IBSQLComun
    else begin
      if tipo = 'D' then
        iData := IBSQLDiario
      else begin
        if tipo = 'S' then
          iData := IBSQLSemanal
        else
          raise EImportarDatos.Create('Tipo modificación desconocido: ' + tipo);
      end;
    end;

    Split(DELIMITADOR_SENTENCIAS, ModificacionesSENTENCIAS.Value, sentencias);
    Importar;

    OIDModificacion := ModificacionesOID_MODIFICACION.Value;
    if tipo = 'C' then begin
      if Configuracion.Sistema.ServidorModificacionComun < OIDModificacion then
        Configuracion.Sistema.ServidorModificacionComun := OIDModificacion;
    end
    else begin
      if tipo = 'D' then begin
        if Configuracion.Sistema.ServidorModificacionDiaria < OIDModificacion then        
          Configuracion.Sistema.ServidorModificacionDiaria := OIDModificacion;
      end
      else begin
        if Configuracion.Sistema.ServidorModificacionSemanal < OIDModificacion then        
          Configuracion.Sistema.ServidorModificacionSemanal := OIDModificacion;
      end;
    end;
    Configuracion.Sistema.Commit;
  finally
    sentencias.Free;
  end;
end;

procedure TImportarDatos.ImportarModificaciones(const transaction: TIBTransaction);
begin
  Modificaciones.First;
  repeat
    Application.ProcessMessages;
    if canceled then
      raise EAbort.Create(ABORT_MSG);
    transaction.StartTransaction;
    try
      // Las OID_MODIFICACION < 0 son mensajes incorporados en Modificaciones,
      // como NuevoValor
      if ModificacionesOID_MODIFICACION.Value > 0 then
        ImportarModificacion;
      Modificaciones.Edit;
      ModificacionesHECHO.Value := true;
      Modificaciones.Post;
      transaction.Commit;
      Modificaciones.Next;
    except
      on e: Exception do begin
        transaction.Rollback;
        raise;
      end;
    end;
  until Modificaciones.Eof;
end;


function TImportarDatos.getLinea(datos: string;
  var posicion: integer; var ultimaLinea: boolean): string;
var i: integer;
begin
  i := PosEx(SEPARADOR_LINEA, datos, posicion);
  if i = 0 then begin
    ultimaLinea := true;
    i := length(datos) + 1;
  end
  else
    ultimaLinea := false;
  if posicion = 0 then
    result := Copy(datos, posicion, i - posicion - 1)
  else
    result := Copy(datos, posicion, i - posicion);
  posicion := i + 1;
end;

function TImportarDatos.getSiguienteValor(linea: string; var posicion: integer): string;
var i: integer;
begin
  i := PosEx(SEPARADOR_COLUMNA, linea, posicion);
  if i = 0 then
    i := length(linea) + 1;
  if posicion = 0 then
    result := Copy(linea, posicion, i - posicion - 1)
  else
    result := Copy(linea, posicion, i - posicion);
  posicion := i + 1;
end;

procedure TImportarDatos.AsignarFieldSiguienteValor(const field: TField;
  const linea: string; var posicion: integer);
var valor: string;
begin
  valor := getSiguienteValor(linea, posicion);
  if valor = '<null>' then
    field.Clear
  else begin
    if field is TDateField then
      (field as TDateField).Value := FechaStringToDate(valor)
    else begin
      if field is TNumericField then begin
        // La parte fraccionario de un número viene con . y aquí
        field.AsString := StringReplace(valor, '.', DecimalSeparator, []);
      end
      else
        field.AsString := valor;
    end;
  end;
end;

procedure TImportarDatos.CancelCurrentOperation;
begin
  inherited;
  canceled := true;
end;

procedure TImportarDatos.CargarModificaciones(ZIP: TAbUnZipper);
var tabla, tipo: string;
  procedure cargar(const nombre: string);
  var datos, linea: string;
    i: integer;
    mem: TStringStream;
    ultimaLinea: boolean;
    posicionValor: integer;
  begin
    mem := TStringStream.Create('');
    try
      ZIP.ExtractToStream(nombre, mem);
      if mem.Size <> 0 then begin
        datos := mem.DataString;
        if datos = '' then //Si no se consigue ningún dato, se mira si están en UTF8
          datos := UTF8Decode(mem.DataString);
        i := 1;
        ultimaLinea := false;
        // Cabecera
        linea := getLinea(datos, i, ultimaLinea);
        if not ultimaLinea then begin
          repeat
            if canceled then
              raise EAbort.Create(ABORT_MSG);
            linea := getLinea(datos, i, ultimaLinea);
            posicionValor := 1;
            Modificaciones.Append;
            ModificacionesHECHO.Value := false;
            ModificacionesTIPO.Value := tipo;
            AsignarFieldSiguienteValor(ModificacionesOID_MODIFICACION, linea, posicionValor);
            AsignarFieldSiguienteValor(ModificacionesCOMENTARIO, linea, posicionValor);
            AsignarFieldSiguienteValor(ModificacionesSENTENCIAS, linea, posicionValor);
            Modificaciones.Post;
          until ultimaLinea;
        end;
      end;
    finally
      mem.Free;
    end;
  end;

  procedure buscar;
  var i: integer;
    found, multiple: boolean;
  begin
    found := ZIP.FindFile(tabla) <> -1;
    multiple := false;
    if not found then begin
      found := ZIP.FindFile(tabla + '_0') <> -1;
      multiple := found;
    end;
    if found then begin
      if multiple then begin
        i := 0;
        repeat
          cargar(tabla + '_' + IntToStr(i));
          inc(i);
          found := ZIP.FindFile(tabla + '_' + IntToStr(i)) <> -1;
        until not found;
      end
      else
        cargar(tabla);
    end;
  end;

begin
  //MUY IMPORTANTE!. Si al actualizar los datos se reinicia la actualización porque
  //se necesitaba ampliar el espacio de alguna de las columnas de cotizacion_mensaje,
  //CargaModificaciones se llamará 2 veces, con lo cual las modificaciones aparecerán
  //duplicadas. Para que esto no ocurra, primero cerramos Modificaciones, por
  //si ya se hubieran cargado los modificaciones anteriormente.
  Modificaciones.Close;
  //
  Modificaciones.Open;
  tipo := 'C';
  tabla := 'modificacion_c';
  buscar;
  tipo := 'D';
  tabla := 'modificacion_d';
  buscar;
  tipo := 'S';
  tabla := 'modificacion_s';
  buscar;
end;


procedure TImportarDatos.InicializarTotal(const ZIP: TAbUnZipper);
var mem: TStringStream;
begin
  mem := TStringStream.Create('');
  try
    ZIP.ExtractToStream('total', mem);
    if mem.Size <> 0 then begin
      total := StrToInt(mem.DataString);
    end
    else
      raise EImportarDatos.Create(ERROR_TOTAL);
  finally
    mem.Free;
  end;
end;

procedure TImportarDatos.NuevoValor(const iData: TIBSQL);
begin
  dec(LastOIDModificacion);
  Modificaciones.Append;
  ModificacionesOID_MODIFICACION.Value := LastOIDModificacion;
  ModificacionesCOMENTARIO.Value := Format(NUEVO_VALOR,
    [iData.ParamByName('SIMBOLO').AsString,
     iData.ParamByName('NOMBRE').AsString,
     DataComun.FindMercado(iData.ParamByName('OR_MERCADO').AsInteger)^.Pais]);
  Modificaciones.Post;
end;

constructor TImportarDatos.Create(AOwner: TComponent; IBSQLDiario, IBSQLSemanal,
  IBSQLComun: TIBSQL);
begin
  inherited Create(AOwner);
  Self.IBSQLDiario := IBSQLDiario;
  Self.IBSQLSemanal := IBSQLSemanal;
  Self.IBSQLComun := IBSQLComun;
  LastOIDModificacion := 0;
  FCommited := false;
end;

function TImportarDatos.FechaStringToDate(const fecha: string): TDateTime;
begin
  result := EncodeDate(StrToInt(Copy(fecha, 0, 4)),
                StrToInt(Copy(fecha, 6, 2)),
                StrToInt(Copy(fecha, 9, 2)));
end;

function TImportarDatos.GetHayModificaciones: boolean;
begin
  result := not Modificaciones.IsEmpty;
end;

end.
