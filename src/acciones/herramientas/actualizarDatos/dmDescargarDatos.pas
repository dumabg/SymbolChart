unit dmDescargarDatos;

interface

uses
  Windows, SysUtils, Classes, DB, IBCustomDataSet, IBQuery, IBSQL, AbBrowse,
  AbUnzper, IBDatabase, dmInternalPerCentServer, dmBD, UtilDB;

type
  TDescargarDatos = class(TInternalPerCentServer)
  private
    function GetOIDValor: integer;
  public
    function Descargar(const BDDiario, BDSemanal, BDComun: TIBDatabase;
      const Diario, Semanal: boolean): TFileName;
  end;

implementation

uses AbUtils, forms, strUtils, dmInternalServer, AbZipTyp,
  UserServerCalls, UtilString, dmConfiguracion, Contnrs,
  dmDataComun;

{$R *.dfm}

function TDescargarDatos.Descargar(const BDDiario, BDSemanal, BDComun: TIBDatabase;
  const Diario, Semanal: boolean): TFileName;
var datosCall: TDatosUserServerCall;
  OIDCotizacionDiario, OIDCotizacionSemanal, OIDSesionDiario,
  OIDSesionSemanal, OIDRentabilidadDiario, OIDRentabilidadSemanal,
  OIDModificacionC, OIDModificacionD, OIDModificacionS, OIDMensaje, OIDFrase: integer;

    function LastOID(const bd: TIBDatabase; const tableName: string): integer;
    var OIDGenerator: TOIDGenerator;
    begin
      if not bd.DefaultTransaction.InTransaction then
        bd.DefaultTransaction.StartTransaction;
      OIDGenerator := TOIDGenerator.Create(bd, tableName);
      try
        result := OIDGenerator.LastOID;
      finally
        OIDGenerator.Free;
      end;
    end;
begin
  if Canceled then
    raise EAbort.Create('');
  Application.ProcessMessages;

  if Diario then begin
    OIDCotizacionDiario := LastOID(BDDiario, 'COTIZACION');
    OIDSesionDiario := LastOID(BDDiario, 'SESION');
    OIDRentabilidadDiario := LastOID(BDDiario, 'SESION_RENTABILIDAD');
  end
  else begin
    OIDCotizacionDiario := High(Integer);
    OIDSesionDiario := High(Integer);
    OIDRentabilidadDiario := High(Integer);
  end;

  if Canceled then
    raise EAbort.Create('');
  Application.ProcessMessages;

  if Semanal then begin
    OIDCotizacionSemanal := LastOID(BDSemanal, 'COTIZACION');
    OIDSesionSemanal := LastOID(BDSemanal, 'SESION');
    OIDRentabilidadSemanal := LastOID(BDSemanal, 'SESION_RENTABILIDAD');
  end
  else begin
    OIDCotizacionSemanal := High(Integer);
    OIDSesionSemanal := High(Integer);
    OIDRentabilidadSemanal := High(Integer);
  end;

  if Canceled then
    raise EAbort.Create('');
  Application.ProcessMessages;

  OIDMensaje := LastOID(BDComun, 'MENSAJE');
  OIDFrase := LastOID(BDComun, 'FRASE');

  with Configuracion.Sistema do begin
    OIDModificacionC := ServidorModificacionComun;
    OIDModificacionD := ServidorModificacionDiaria;
    OIDModificacionS := ServidorModificacionSemanal;
  end;

  if Canceled then
    raise EAbort.Create('');
  Application.ProcessMessages;

  datosCall := TDatosUserServerCall.Create(Self);
  try
    result := datosCall.Call(Diario, Semanal, GetOIDValor, OIDCotizacionDiario, OIDCotizacionSemanal,
      OIDSesionDiario, OIDSesionSemanal, OIDRentabilidadDiario, OIDRentabilidadSemanal,
      OIDModificacionC, OIDModificacionD, OIDModificacionS, OIDMensaje, OIDFrase, False);
  finally
    datosCall.Free;
  end;
  CancelPerCentOperation;
end;


function TDescargarDatos.GetOIDValor: integer;
var valorIterator: TDataValorIterator;
  OIDValor: integer;
begin
  valorIterator := DataComun.ValoresIterator;
  try
    valorIterator.first;
    result := valorIterator.next^.OIDValor;
    while valorIterator.hasNext do begin
      OIDValor := valorIterator.next^.OIDValor;
      if result < OIDValor then
        result := OIDValor;
    end;
  finally
    valorIterator.Free;
  end;
end;

end.
