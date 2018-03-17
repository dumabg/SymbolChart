unit dmExportar;

interface

uses
  SysUtils, Classes, dmCampos, DB, IBCustomDataSet, IBQuery;

type
  EFormatoIncorrecto = class(Exception);

  TExportar = class(TDataModule)
    qDatos: TIBQuery;
    qDatosOID_COTIZACION: TIntegerField;
    qDatosOR_VALOR: TSmallintField;
    qDatosOR_SESION: TSmallintField;
    qDatosDIAS_SEGUIDOS_NUM: TSmallintField;
    qDatosVARIACION: TIBBCDField;
    qDatosMAXIMO: TIBBCDField;
    qDatosMINIMO: TIBBCDField;
    qDatosOID_SESION: TSmallintField;
    qDatosFECHA: TDateField;
    qDatosOR_COTIZACION: TIntegerField;
    qDatosVOLATILIDAD: TIBBCDField;
    qDatosVARIABILIDAD: TIBBCDField;
    qDatosBANDA_ALTA: TIBBCDField;
    qDatosBANDA_BAJA: TIBBCDField;
    qDatosDINERO: TIBBCDField;
    qDatosDINERO_ALZA_DOBLE: TIBBCDField;
    qDatosDINERO_BAJA_DOBLE: TIBBCDField;
    qDatosDINERO_BAJA_SIMPLE: TIBBCDField;
    qDatosDINERO_ALZA_SIMPLE: TIBBCDField;
    qDatosPAPEL: TIBBCDField;
    qDatosPAPEL_ALZA_DOBLE: TIBBCDField;
    qDatosPAPEL_ALZA_SIMPLE: TIBBCDField;
    qDatosPAPEL_BAJA_DOBLE: TIBBCDField;
    qDatosPAPEL_BAJA_SIMPLE: TIBBCDField;
    qDatosDIMENSION_FRACTAL: TIBBCDField;
    qDatosPOTENCIAL_FRACTAL: TSmallintField;
    qDatosRSI_140: TSmallintField;
    qDatosRSI_14: TSmallintField;
    qDatosDOBSON_ALTO_130: TSmallintField;
    qDatosDOBSON_ALTO_100: TSmallintField;
    qDatosDOBSON_ALTO_70: TSmallintField;
    qDatosDOBSON_ALTO_40: TSmallintField;
    qDatosDOBSON_ALTO_10: TSmallintField;
    qDatosDOBSON_130: TSmallintField;
    qDatosDOBSON_100: TSmallintField;
    qDatosDOBSON_70: TSmallintField;
    qDatosDOBSON_40: TSmallintField;
    qDatosDOBSON_10: TSmallintField;
    qDatosDOBSON_BAJO_130: TSmallintField;
    qDatosDOBSON_BAJO_100: TSmallintField;
    qDatosDOBSON_BAJO_70: TSmallintField;
    qDatosDOBSON_BAJO_40: TSmallintField;
    qDatosDOBSON_BAJO_10: TSmallintField;
    qDatosMAXIMO_SE_PREVINO: TIBBCDField;
    qDatosMINIMO_SE_PREVINO: TIBBCDField;
    qDatosMAXIMO_PREVISTO: TIBBCDField;
    qDatosMINIMO_PREVISTO: TIBBCDField;
    qDatosMAXIMO_PREVISTO_APROX: TIBBCDField;
    qDatosMINIMO_PREVISTO_APROX: TIBBCDField;
    qDatosZONA_ALZA_DOBLE: TIBStringField;
    qDatosZONA_ALZA_SIMPLE: TIBStringField;
    qDatosZONA_BAJA_DOBLE: TIBStringField;
    qDatosZONA_BAJA_SIMPLE: TIBStringField;
    qDatosZONA: TIBStringField;
    qDatosPIVOT_POINT: TIBBCDField;
    qDatosPIVOT_POINT_R1: TIBBCDField;
    qDatosPIVOT_POINT_R2: TIBBCDField;
    qDatosPIVOT_POINT_R3: TIBBCDField;
    qDatosPIVOT_POINT_S1: TIBBCDField;
    qDatosPIVOT_POINT_S2: TIBBCDField;
    qDatosPIVOT_POINT_S3: TIBBCDField;
    qDatosSTOP: TIBBCDField;
    qDatosMEDIA_200: TIBBCDField;
    qDatosCAMBIO_ALZA_SIMPLE: TIBBCDField;
    qDatosCAMBIO_ALZA_DOBLE: TIBBCDField;
    qDatosCAMBIO_BAJA_SIMPLE: TIBBCDField;
    qDatosCAMBIO_BAJA_DOBLE: TIBBCDField;
    qDatosPERCENT_ALZA_SIMPLE: TIBBCDField;
    qDatosPERCENT_BAJA_SIMPLE: TIBBCDField;
    qDatosNIVEL_SUBE: TIBStringField;
    qDatosNIVEL_ACTUAL: TIBStringField;
    qDatosNIVEL_BAJA: TIBStringField;
    qDatosAMBIENTE_INTRADIA: TIBStringField;
    qDatosRENTABILIDAD_ABIERTA: TIBBCDField;
    qDatosOR_RENTABILIDAD: TIntegerField;
    qDatosPERCENT_ALZA_DOBLE: TIBBCDField;
    qDatosPERCENT_BAJA_DOBLE: TIBBCDField;
    qDatosNIVEL_ABIERTA: TIBBCDField;
    qDatosTIPO_ABIERTA: TIBStringField;
    qDatosFECHA_INICIO_ABIERTA: TDateField;
    qDatosNIVEL_CERRADA: TIBBCDField;
    qDatosTIPO_CERRADA: TIBStringField;
    qDatosFECHA_INICIO_CERRADA: TDateField;
    qDatosRENTABILIDAD_CERRADA: TIBBCDField;
    qDatosZONA_BAJA_SIMPLE_DESC: TStringField;
    qDatosZONA_BAJA_DOBLE_DESC: TStringField;
    qDatosZONA_ALZA_SIMPLE_DESC: TStringField;
    qDatosZONA_ALZA_DOBLE_DESC: TStringField;
    qDatosZONA_DESC: TStringField;
    qDatosCORRELACION: TSmallintField;
    qDatosPOSICIONADO: TIBBCDField;
    qDatosRIESGO: TIBBCDField;
    qDatosPRESION_VERTICAL: TIBBCDField;
    qDatosPRESION_VERTICAL_ALZA_SIMPLE: TIBBCDField;
    qDatosPRESION_VERTICAL_ALZA_DOBLE: TIBBCDField;
    qDatosPRESION_VERTICAL_BAJA_SIMPLE: TIBBCDField;
    qDatosPRESION_VERTICAL_BAJA_DOBLE: TIBBCDField;
    qDatosPRESION_LATERAL: TIBBCDField;
    qDatosPRESION_LATERAL_ALZA_SIMPLE: TIBBCDField;
    qDatosPRESION_LATERAL_ALZA_DOBLE: TIBBCDField;
    qDatosPRESION_LATERAL_BAJA_SIMPLE: TIBBCDField;
    qDatosPRESION_LATERAL_BAJA_DOBLE: TIBBCDField;
    qDatosAPERTURA: TIBBCDField;
    qDatosCIERRE: TIBBCDField;
    qDatosVOLUMEN: TIntegerField;
    qDatosDIAS_SEGUIDOS_PERCENT: TIBBCDField;
    procedure qDatosBeforeOpen(DataSet: TDataSet);
    procedure qDatosTIPO_ABIERTAGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure qDatosNIVEL_SUBEGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    procedure BuscarDatos;
    function GetTipoPosicion(Sender: TField): string;
  public
    procedure CrearFichero(const fileName: TFileName; const Campos: TCampos;
      const cabecera: boolean; const separador, comilla: string);
    procedure GuardarFormato(const fileName: TFileName; const Campos: TCampos;
      const cabecera: boolean; const separador, comilla: string);
    procedure AbrirFormato(const fileName: TFileName;
      const Campos: TCampos; var cabecera: boolean; var separador, comilla: string);
  end;


implementation

uses dmBD, dmData, dmDataComun, UtilDB;

{$R *.dfm}

resourcestring
  E_FORMATO_INCORRECTO = 'El fichero seleccionado no es un fichero de exportación de datos válido';
  LARGO = 'largo';
  CORTO = 'corto';

const
  CABECERA_FICHERO_VIEJO = 'EFP 1';
  CABECERA_FICHERO_NUEVO = 'ESC 1';

{ TExportar }

procedure TExportar.AbrirFormato(const fileName: TFileName;
    const Campos: TCampos; var cabecera: boolean; var separador, comilla: string);
var dat: TStringList;
  cad: string;
  num, i: integer;
begin
  dat := TStringList.Create;
  try
    dat.LoadFromFile(fileName);
    if (dat.Count = 0) or ((dat[0] <> CABECERA_FICHERO_VIEJO) and (dat[0] <> CABECERA_FICHERO_NUEVO)) then
      raise EFormatoIncorrecto.Create(E_FORMATO_INCORRECTO);
    cad := dat.Values['cabecera'];
    if cad = 'N'  then
      cabecera := false
    else
      cabecera := true;
    separador := dat.Values['separador'];
    comilla := dat.Values['comilla'];
    cad := dat.Values['NumCampos'];
    try
      num := StrToInt(cad);
    except
      raise EFormatoIncorrecto.Create(E_FORMATO_INCORRECTO);
    end;
    Campos.UnselectAll;
    for i := 1 to num do begin
      cad := dat.Values['campo.' + IntToStr(i)];
      if cad = '' then
        raise EFormatoIncorrecto.Create(E_FORMATO_INCORRECTO)
      else
        Campos.Select(cad);
    end;
  finally
    FreeAndNil(dat);
  end;
end;

procedure TExportar.BuscarDatos;
begin
  qDatos.Params[0].AsDateTime := Data.Sesion;
  OpenDataSet(qDatos);
end;

function Ordenar(List: TStringList; Index1, Index2: Integer): Integer;
var OIDValor1, OIDValor2: integer;
  nombre1, nombre2: string;
begin
  OIDValor1 := Integer(List.Objects[Index1]);
  nombre1 := DataComun.FindValor(OIDValor1)^.Nombre;
  OIDValor2 := Integer(List.Objects[Index2]);
  nombre2 := DataComun.FindValor(OIDValor2)^.Nombre;
  if nombre1 = nombre2 then begin
    nombre1 := DataComun.FindValor(OIDValor1)^.Simbolo;
    nombre2 := DataComun.FindValor(OIDValor2)^.Simbolo;
  end;
  result := AnsiCompareText(nombre1, nombre2);
end;

procedure TExportar.CrearFichero(const fileName: TFileName; const Campos: TCampos;
  const cabecera: boolean; const separador, comilla: string);
var dat: TStringList;
  i, num, OIDValor: integer;
  cad, fieldName: string;
begin
  dat := TStringList.Create;
  try
    num := Campos.SelectedCount - 1;

    BuscarDatos;
    qDatos.First;
    while not qDatos.Eof do begin
      OIDValor := qDatosOR_VALOR.Value;
      cad := '';
      for i := 0 to num do begin
        cad := cad + comilla;
        fieldName := Campos.Selected[i].Field.FieldName;
        if fieldName = 'SIMBOLO' then begin
          cad := cad + DataComun.FindValor(OIDValor)^.Simbolo;
        end
        else begin
          if fieldName = 'NOMBRE' then begin
            cad := cad + DataComun.FindValor(OIDValor)^.Nombre;
          end
          else begin
            cad := cad + qDatos.FieldByName(fieldName).DisplayText;
          end;
        end;
        cad := cad + comilla;
        if i < num then
          cad := cad + separador;
      end;
      dat.AddObject(cad, TObject(OIDValor));
      qDatos.Next;
    end;

    dat.CustomSort(Ordenar);

    if cabecera then begin
      cad := '';
      for i := 0 to num do begin
        cad := cad + Campos.Selected[i].Caption;
        if i < num then
          cad := cad + separador;
      end;
      dat.Insert(0, cad);
    end;

    dat.SaveToFile(fileName);
  finally
    dat.Free;
  end;
end;

function TExportar.GetTipoPosicion(Sender: TField): string;
begin
 if Sender.Value = 'L' then
    result := LARGO
  else
    if Sender.Value = 'C' then
      result := CORTO
    else
      result := '';
end;

procedure TExportar.GuardarFormato(const fileName: TFileName; const Campos: TCampos;
      const cabecera: boolean; const separador, comilla: string);
var dat: TStringList;
  cad: string;
  i, num: integer;
begin
  dat := TStringList.Create;
  try
    dat.Add(CABECERA_FICHERO_NUEVO);
    cad := 'cabecera=';
    if cabecera then
      cad := cad + 'S'
    else
      cad := cad + 'N';
    dat.Add(cad);
    dat.Add('separador=' + separador);
    dat.Add('comilla=' + comilla);
    num := Campos.SelectedCount;
    dat.Add('NumCampos=' + IntToStr(num));
    for i := 0 to num - 1 do begin
      dat.Add('campo.' + IntToStr(i + 1) + '=' + Campos.Selected[i].Caption);
    end;
    dat.SaveToFile(fileName);
  finally
    dat.Free;
  end;
end;

procedure TExportar.qDatosBeforeOpen(DataSet: TDataSet);
begin
  qDatos.ParamByName('OID_SESION').AsInteger := data.CotizacionOR_SESION.Value;
end;

procedure TExportar.qDatosNIVEL_SUBEGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  data.CotizacionEstadoNIVELGetText(Sender, Text, DisplayText);
end;

procedure TExportar.qDatosTIPO_ABIERTAGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := GetTipoPosicion(Sender);
end;

end.
