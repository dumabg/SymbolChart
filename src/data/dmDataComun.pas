unit dmDataComun;

interface

uses
  Windows, SysUtils, Classes, DB, IBCustomDataSet, IBQuery, ExtCtrls, Graphics, ImgList,
  Controls, Contnrs;

type
  EDataComun = class(Exception);

  TDataComunMoneda = record
    OIDMoneda: integer;
    Nombre: string;
  end;

  PDataComunMoneda = ^TDataComunMoneda;

  TDataComunMercado = record
    BanderaImageIndex: integer;
    OIDMercado: integer;
    Nombre: string;
    Pais: string;
    Decimales: byte;
    Moneda: PDataComunMoneda;
  end;

  PDataComunMercado = ^TDataComunMercado;

  TDataComunValor = record
    OIDValor: integer;
    Nombre: string;
    Simbolo: string;
    Mercado: PDataComunMercado;
  end;

  PDataComunValor = ^TDataComunValor;

  TPDataComunValores = array of PDataComunValor;

  TDataComunValores = array of TDataComunValor;
  TDataComunMercados = array of TDataComunMercado;
  TDataComunMonedas = array of TDataComunMoneda;
  TDataComunZonas = array[1..8] of string;

  PDataComunValores = ^TDataComunValores;
  PDataComunMercados = ^TDataComunMercados;
  PDataComunMonedas = ^TDataComunMonedas;

  TDataValorIterator = class
    private
      pValores: PDataComunValores;
      pos, num: integer;
      constructor Create(pValores: PDataComunValores);
      function GetCount: integer;
    public
      function hasNext: boolean;
      function next: PDataComunValor;
      procedure first;
      property Count: integer read GetCount;
    end;

  TDataComun = class(TDataModule)
    qMercados: TIBQuery;
    qMercadosOID_MERCADO: TSmallintField;
    qMercadosNOMBRE: TIBStringField;
    qMercadosPAIS: TIBStringField;
    qMercadosBANDERA: TMemoField;
    qMercadosDECIMALES: TSmallintField;
    qMonedas: TIBQuery;
    qMonedasOID_MONEDA: TSmallintField;
    qMonedasMONEDA: TIBStringField;
    qMercadosOR_MONEDA: TSmallintField;
    qValores: TIBQuery;
    qValoresOID_VALOR: TSmallintField;
    qValoresOR_MERCADO: TSmallintField;
    qValoresNOMBRE: TIBStringField;
    qValoresSIMBOLO: TIBStringField;
    ImageListBanderas: TImageList;
    qZonas: TIBQuery;
    qZonasOID_ZONA: TIBStringField;
    qZonasNOMBRE: TIBStringField;
    qSesion: TIBQuery;
    qSesionOID_SESION: TSmallintField;
    qSesionFECHA: TDateField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FValores: TDataComunValores;
    FMercados: TDataComunMercados;
    FMonedas: TDataComunMonedas;
    FZonas: TDataComunZonas;
    FSesionesOID: TBucketList;
    FSesionesDate: TBucketList;
    minOIDMercados, maxOIDMercados: integer;
    minOIDValores, maxOIDValores: integer;
    procedure InitValores;
    procedure InitMercados;
    procedure InitZonas;
    procedure InitSesiones;
    procedure InitMonedas;
    function GetCountMonedas: integer;
    function GetCountMercados: integer;
    function GetCountValores: integer;
    function GetMercados: PDataComunMercados;
    function GetMonedas: PDataComunMonedas;
    function GetValores: PDataComunValores;
    function TDateToPointer(const Date: TDate): Pointer; inline;
    function PointerToTDate(const p: Pointer): TDate; inline;
    function GetValoresIterator: TDataValorIterator;
  public
    function FindMoneda(OIDMoneda: integer): PDataComunMoneda;
    function FindOIDMoneda(const moneda: string): integer;
    function FindMercado(OIDMercado: integer): PDataComunMercado;
    function FindMercadoNombre(const nombre: string): PDataComunMercado;
    function FindValor(OIDValor: integer): PDataComunValor;
    function FindValoresSimbolo(const simbolo: string): TPDataComunValores;
    function FindZona(const id: Byte): string; overload;
    function FindZona(const zona: string): byte; overload;
    function FindOIDSesion(const Fecha: TDate): integer;
    function FindFecha(const OIDSesion: integer): TDate;
    procedure AssignDataSet(const OIDValor: integer;
      const FieldOIDValor: TIntegerField; const FieldNombre: TStringField;
      const FieldSimbolo: TStringField; const FieldOIDMercado: TIntegerField;
      const FieldMercado: TStringField);
{    procedure ActualizarBandera(const OIDMercado: integer; const Image: TImage;
      const useTagCache: boolean = true);}
    procedure DibujarBandera(const OIDMercado: integer; const Canvas: TCanvas;
      const x, y: integer; const ColorFondo: TColor);
    procedure ReloadSesiones;
    procedure ReloadValores;
    property Valores: PDataComunValores read GetValores;
    property Mercados: PDataComunMercados read GetMercados;
    property Monedas: PDataComunMonedas read GetMonedas;
    property CountMonedas: integer read GetCountMonedas;
    property CountMercados: integer read GetCountMercados;
    property CountValores: integer read GetCountValores;
    property ValoresIterator: TDataValorIterator read GetValoresIterator;
  end;

var
  DataComun: TDataComun;

implementation

uses dmBD, IBDatabase, UtilDB;

resourcestring
  MONEDA_INVALIDA =  'No se ha encontrado la moneda %s';
  VALOR_INVALIDO =  'No se ha encontrado el valor %d';
  MERCADO_INVALIDO =  'No se ha encontrado el mercado %s';
  SESION_INVALIDA = 'No se ha encontrado la sesión %s';

{$R *.dfm}

{
procedure TDataComun.ActualizarBandera(const OIDMercado: integer; const Image: TImage;
  const useTagCache: boolean);

  procedure AssingBandera;
  var bandera: TMemoryStream;
  begin
    bandera := FindMercado(OIDMercado)^.Bandera;
    if bandera = nil then
      Image.Picture := nil
    else begin
      bandera.Position := 0;
      Image.Picture.Bitmap.LoadFromStream(bandera);
    end;
  end;

begin
  if useTagCache then begin
    if Image.Tag <> OIDMercado then
      AssingBandera;
  end
  else
    AssingBandera;
end;
}
procedure TDataComun.AssignDataSet(const OIDValor: integer;
  const FieldOIDValor: TIntegerField; const FieldNombre,
  FieldSimbolo: TStringField; const FieldOIDMercado: TIntegerField;
  const FieldMercado: TStringField);
var valor: PDataComunValor;
begin
  valor := FindValor(OIDValor);
  if FieldOIDValor <> nil then
    FieldOIDValor.Value := valor^.OIDValor;
  if FieldNombre <> nil then
    FieldNombre.Value := valor^.Nombre;
  if FieldSimbolo <> nil then
    FieldSimbolo.Value := valor^.Simbolo;
  if FieldOIDMercado <> nil then
    FieldOIDMercado.Value := valor^.Mercado^.OIDMercado;
  if FieldMercado <> nil then
    FieldMercado.Value := valor^.Mercado^.Nombre;
end;

procedure TDataComun.DataModuleCreate(Sender: TObject);
begin
  FSesionesOID := TBucketList.Create(bl256);
  FSesionesDate := TBucketList.Create(bl256);
  InitZonas;
  InitMonedas;
  InitMercados;
  InitValores;
  InitSesiones;
end;

procedure TDataComun.DataModuleDestroy(Sender: TObject);
begin
  FSesionesOID.Free;
  FSesionesDate.Free;
end;

procedure TDataComun.DibujarBandera(const OIDMercado: integer;
  const Canvas: TCanvas; const x, y: integer; const ColorFondo: TColor);
begin
  Canvas.Brush.Color := ColorFondo;
  Canvas.Brush.Style := bsSolid;
  Canvas.FillRect(Rect(x, y, x + ImageListBanderas.Width, y + ImageListBanderas.Height));
  ImageListBanderas.Draw(Canvas, x, y, FindMercado(OIDMercado)^.BanderaImageIndex);
end;

function TDataComun.FindFecha(const OIDSesion: integer): TDate;
var aux: pointer;
begin
  if FSesionesOID.Find(Pointer(OIDSesion), aux) then
    result := PointerToTDate(aux)
  else
    raise EDataComun.Create(Format(SESION_INVALIDA, [IntToStr(OIDSesion)]));
end;

function TDataComun.FindMercado(OIDMercado: integer): PDataComunMercado;
begin
  result := @FMercados[OIDMercado - minOIDMercados];
end;

function TDataComun.FindMercadoNombre(const nombre: string): PDataComunMercado;
var i: integer;
begin
  for i := Low(FMercados) to High(FMercados) do begin
    if FMercados[i].Nombre = nombre then begin
      result := @FMercados[i];
      exit;
    end;
  end;
  raise EDataComun.Create(Format(MERCADO_INVALIDO, [nombre]));
end;

function TDataComun.FindMoneda(OIDMoneda: integer): PDataComunMoneda;
begin
  result := @FMonedas[OIDMoneda];
end;

function TDataComun.FindOIDMoneda(const moneda: string): integer;
var i: integer;
begin
  for i := Low(FMonedas) to High(FMonedas) do begin
    if FMonedas[i].Nombre = moneda then begin
      result := FMonedas[i].OIDMoneda;
      exit;
    end;
  end;
  raise EDataComun.Create(Format(MONEDA_INVALIDA, [moneda]));
end;

function TDataComun.FindOIDSesion(const Fecha: TDate): integer;
var aux: pointer;
begin
  if FSesionesDate.Find(TDateToPointer(Fecha), Pointer(aux)) then
    result := Integer(aux)
  else
    raise EDataComun.Create(Format(SESION_INVALIDA, [DateToStr(Fecha)]));
end;

function TDataComun.FindValor(OIDValor: integer): PDataComunValor;
begin
  result := @FValores[OIDValor - minOIDValores];
end;

function TDataComun.FindValoresSimbolo(const simbolo: string): TPDataComunValores;
var i: integer;
begin
  SetLength(result, 0);
  for i := Low(FValores) to High(FValores) do begin
    if FValores[i].Simbolo = simbolo then begin
      SetLength(result, length(result) + 1);
      result[length(result) - 1] := @FValores[i];
    end;
  end;
end;

function TDataComun.FindZona(const zona: string): byte;
var i: integer;
begin
  for i := Low(FZonas) to High(FZonas) do begin
    if FZonas[i] = zona then begin
      result := i;
      exit;
    end;
  end;
  raise EDataComun.Create('Zona desconocida: ' + zona);
end;

function TDataComun.FindZona(const id: Byte): string;
begin
  result := FZonas[id];
end;

function TDataComun.GetCountMonedas: integer;
begin
  result := length(FMonedas);
end;

function TDataComun.GetCountValores: integer;
begin
  result := length(FValores);
end;

function TDataComun.GetMercados: PDataComunMercados;
begin
  result := @FMercados;
end;

function TDataComun.GetMonedas: PDataComunMonedas;
begin
  result := @FMonedas;
end;

function TDataComun.GetValores: PDataComunValores;
begin
  result := @FValores;
end;

function TDataComun.GetValoresIterator: TDataValorIterator;
begin
  result := TDataValorIterator.Create(@FValores);
end;

procedure TDataComun.InitMercados;
var OID: integer;
  Bandera: TMemoryStream;
  BanderaBitmap: TBitmap;
begin
  qMercados.Open;

  minOIDMercados := qMercadosOID_MERCADO.Value;
  qMercados.Last;
  maxOIDMercados:= qMercadosOID_MERCADO.Value;
  SetLength(FMercados, maxOIDMercados - minOIDMercados + 1);

  qMercados.First;
  while not qMercados.Eof do begin
    OID := qMercadosOID_MERCADO.Value;
    with FMercados[OID - minOIDMercados] do begin
      OIDMercado := OID;
      Nombre := qMercadosNOMBRE.Value;
      Pais := qMercadosPAIS.Value;
      if qMercadosBANDERA.IsNull then
        BanderaImageIndex := -1
      else begin
        Bandera := TMemoryStream.Create;
        try
          qMercadosBANDERA.SaveToStream(Bandera);
          Bandera.Position := 0;
          BanderaBitmap := TBitmap.Create;
          try
            BanderaBitmap.LoadFromStream(Bandera);
            BanderaImageIndex := ImageListBanderas.AddMasked(BanderaBitmap, clFuchsia)
          finally
            BanderaBitmap.Free;
          end;
        finally
          Bandera.Free;
        end;
      end;
      Decimales := qMercadosDECIMALES.Value;
      Moneda := FindMoneda(qMercadosOR_MONEDA.Value);
    end;
    qMercados.Next;
  end;

  qMercados.Close;
end;

procedure TDataComun.InitMonedas;
var OID: integer;
begin
  qMonedas.Open;

  // Estan ordenados por desc para que el primer valor sea el máximo OID
  // Sumamos 1 porque el array es zero based. El primer elemento, el 0, no
  // servirá para nada.
  SetLength(FMonedas, qMonedasOID_MONEDA.Value + 1);

  qMonedas.First;
  while not qMonedas.Eof do begin
    OID := qMonedasOID_MONEDA.Value;
    with FMonedas[OID] do begin
      OIDMoneda := OID;
      Nombre := qMonedasMONEDA.Value;
    end;
    qMonedas.Next;
  end;

  qMonedas.Close;
end;

procedure TDataComun.InitSesiones;
var bdDiaria, bdSemanal: TIBDatabase;
  aux, pOIDSesion, pFecha: Pointer;
begin
  bdDiaria := BD.GetNewDatabase(nil, scdDatos, bddDiaria);
  try
    qSesion.Database := bdDiaria;
    qSesion.Transaction := bdDiaria.DefaultTransaction;
    qSesion.Open;
    while not qSesion.Eof do begin
      pFecha := TDateToPointer(qSesionFECHA.Value);
      pOIDSesion := Pointer(qSesionOID_SESION.Value);
      if not FSesionesOID.Find(pOIDSesion, aux) then
        FSesionesOID.Add(pOIDSesion, pFecha);
      if not FSesionesDate.Find(pFecha, aux) then
        FSesionesDate.Add(pFecha, pOIDSesion);
      qSesion.Next;
    end;
    qSesion.Close;
  finally
    bdDiaria.Free;
  end;

  bdSemanal := BD.GetNewDatabase(nil, scdDatos, bddSemanal);
  try
    qSesion.Database := bdSemanal;
    qSesion.Transaction := bdSemanal.DefaultTransaction;
    qSesion.Open;
    while not qSesion.Eof do begin
      pFecha := TDateToPointer(qSesionFECHA.Value);
      pOIDSesion := Pointer(qSesionOID_SESION.Value);
      if not FSesionesOID.Find(pOIDSesion, aux) then
        FSesionesOID.Add(pOIDSesion, pFecha);
      if not FSesionesDate.Find(pFecha, aux) then
        FSesionesDate.Add(pFecha, pOIDSesion);
      qSesion.Next;
    end;
    qSesion.Close;
  finally
    bdSemanal.Free;
  end;
end;

procedure TDataComun.InitValores;
var OID: integer;
begin
  qValores.Open;

  minOIDValores := qValoresOID_VALOR.Value;
  qValores.Last;
  maxOIDValores := qValoresOID_VALOR.Value;
  SetLength(FValores, maxOIDValores - minOIDValores  + 1);
  // Pueden haber huecos, que ningún valor tengo un OID determinado.
  // Inicializamos el array a 0. Si el OIDValor=0,
  // significará que no hay valor
  ZeroMemory(FValores, Length(FValores));

  qValores.First;
  while not qValores.Eof do begin
    OID := qValoresOID_VALOR.Value;
    with FValores[OID - minOIDValores] do begin
      OIDValor := OID;
      Nombre := qValoresNOMBRE.Value;
      Simbolo := qValoresSIMBOLO.Value;
      Mercado := FindMercado(qValoresOR_MERCADO.Value);
    end;
    qValores.Next;
  end;

  qValores.Close;
end;

procedure TDataComun.InitZonas;
begin
  qZonas.Open;
  while not qZonas.Eof do begin
    FZonas[qZonasOID_ZONA.AsInteger] := qZonasNOMBRE.Value;
    qZonas.Next;
  end;
  qZonas.Close;
end;

function TDataComun.PointerToTDate(const p: Pointer): TDate;
var aux: double;
begin
  aux := integer(p);
  result := TDate(aux);
end;

procedure TDataComun.ReloadSesiones;
begin
  InitSesiones;
end;

procedure TDataComun.ReloadValores;
begin
  SetLength(FValores, 0);
  InitValores;
end;

function TDataComun.TDateToPointer(const Date: TDate): Pointer;
begin
  result := Pointer(integer(Trunc(Date)));
end;

function TDataComun.GetCountMercados: integer;
begin
  result := length(FMercados);
end;

{ TDataValorIterator }

constructor TDataValorIterator.Create(pValores: PDataComunValores);
begin
  Self.pValores := pValores;
  num := length(pValores^) - 1;
  first;
end;

procedure TDataValorIterator.first;
begin
  pos := -1;
end;

function TDataValorIterator.GetCount: integer;
var i: integer;
begin
  result := 0;
  for i := 0 to num do begin
    // Un OIDValor = 0 significa que no hay valor
    if pValores^[i].OIDValor > 0 then
      inc(result);
  end;
end;

function TDataValorIterator.hasNext: boolean;
begin
  result := pos < num;
end;

function TDataValorIterator.next: PDataComunValor;
begin
  Inc(pos);
  // Un OIDValor = 0 significa que no hay valor
  while pValores^[pos].OIDValor = 0 do begin
    Inc(pos);
  end;
  result := @pValores^[pos];
end;

end.
