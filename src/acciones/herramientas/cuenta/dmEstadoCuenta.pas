unit dmEstadoCuenta;

interface

uses
  SysUtils, Classes, DB, Controls, ActnList, dmInternalPerCentServer, auHTTP, kbmMemTable;

type
  TEstadoCuenta = class(TInternalPerCentServer)
    Operacion: TkbmMemTable;
    OperacionOID_OPERACION: TIntegerField;
    OperacionNOMBRE: TStringField;
    Transaccion: TkbmMemTable;
    TransaccionOID_TRANSACCION: TIntegerField;
    TransaccionOR_OPERACION: TIntegerField;
    TransaccionOPERACION: TStringField;
    TransaccionFECHA_HORA: TDateTimeField;
    Totales: TkbmMemTable;
    TotalesPOS: TIntegerField;
    TotalesFECHA: TStringField;
    TotalesIMPORTE: TIntegerField;
    TransaccionIMPORTE: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure TotalesPOSGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  private
    FCaducidad: TDate;
    function GetSaldo: integer;
  public
    procedure Conectar;
    procedure Exportar(const fileName: TFileName);
    property Saldo: Integer read GetSaldo;
    property Caducidad: TDate read FCaducidad;
  end;



implementation

uses dmInternalServer, DateUtils, fmEstadoCuentaCargando,
  Windows, Forms, UserServerCalls, UtilDB;

{$R *.dfm}

{ TCuenta }

procedure TEstadoCuenta.Conectar;
var call: TEstadoCuentaServerCall;
  fecha, aux: TDate;
  importe: integer;
  i: integer;
  cad: string;
  fCuentaCargando: TfEstadoCuentaCargando;
begin
  fCuentaCargando := TfEstadoCuentaCargando.Create(nil);
  try
    fCuentaCargando.Server := Self;
    PerCentWindowReceiver := fCuentaCargando.Handle;
    fCuentaCargando.CloseOnCancel := false;
    fCuentaCargando.Show;

    Transaccion.Close;
    Operacion.Close;
    Totales.Close;
    Operacion.Open;
    Transaccion.Open;
    Totales.Open;

    call := TEstadoCuentaServerCall.Create(Self);
    try
      call.Call(Operacion, Transaccion);
      FCaducidad := call.Caducidad;
    finally
      call.Free;
    end;

    Transaccion.First;
    aux := Now;
    for i:=1 to 11 do begin
      fecha := TransaccionFECHA_HORA.Value;
      importe := 0;
      while (MonthOf(fecha) = MonthOf(aux)) and (YearOf(fecha) = YearOf(aux)) and
        (not Transaccion.Eof) do begin
        if TransaccionIMPORTE.Value < 0 then
          importe := importe - TransaccionIMPORTE.Value;
        Transaccion.Next;
        fecha := TransaccionFECHA_HORA.Value;
      end;
      Totales.Append;
      TotalesPOS.Value := 12 - i;
      cad := IntToStr(MonthOf(aux));
      if length(cad) = 1 then
        cad := '0' + cad;
      cad := cad + '/' + Copy(IntToStr(YearOf(aux)), 3, 2);
      TotalesFECHA.Value := cad;
      TotalesIMPORTE.Value := importe;
      Totales.Post;
      aux := IncMonth(aux, -1);
    end;
    Transaccion.First;
  finally
    fCuentaCargando.Free;
  end;
end;

procedure TEstadoCuenta.DataModuleCreate(Sender: TObject);
begin
  inherited;
  Operacion.Open;
  Transaccion.Open;
end;

procedure TEstadoCuenta.Exportar(const fileName: TFileName);
var s: TStringList;
  inspect: TInspectDataSet;
begin
  s := TStringList.Create;
  try
    s.Add('Fecha Hora,Operacion,Importe');
    inspect := StartInspectDataSet(Transaccion);
    try
      Transaccion.First;
      while not Transaccion.Eof do begin
        s.Add(TransaccionFECHA_HORA.AsString + ',' +
          '"' + TransaccionOPERACION.Value + '",' +
          TransaccionIMPORTE.AsString);
        Transaccion.Next;
      end;
    finally
      EndInspectDataSet(inspect);
    end;
    s.SaveToFile(fileName);
  finally
    s.Free;
  end;
end;

procedure TEstadoCuenta.TotalesPOSGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  inherited;
  Text := TotalesFECHA.AsString;
end;

function TEstadoCuenta.GetSaldo: integer;
var inspect: TInspectDataSet;
begin
  result := 0;
  inspect := StartInspectDataSet(Transaccion);
  try
    Transaccion.Last;
    while not Transaccion.Bof do begin
      result := result + TransaccionIMPORTE.Value;
      Transaccion.Prior;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;

end.
