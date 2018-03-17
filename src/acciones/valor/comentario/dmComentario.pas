unit dmComentario;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, datasetObserver;

type
  TCambios = array of currency;

  TdComentario = class(TDataModule)
    EstadoAyer: TIBQuery;
    EstadoAyerDINERO: TIBBCDField;
    EstadoAyerPAPEL: TIBBCDField;
    doCotizacion: TDataSetObserver;
  private
    { Private declarations }
  public
    function getOIDCotizacionDiaAnterior: integer;
//    function getCambioAnterior(NumDias: integer): currency;
    function getCambiosAnteriores(NumDias: integer): TCambios;
    procedure Open(OIDCotizacion: integer);
  end;


implementation

uses dmBD, dmData;

{$R *.dfm}

{ TComentario }

{function TComentario.getCambioAnterior(NumDias: integer): currency;
var field: TField;
  num: integer;
begin
  doCotizacion.StartObserver;
  try
      doCotizacion.Next;
      field := doCotizacion.getField('CAMBIO');
      num := 0;
      while (num < NumDias) and (field.Value = 0) and (not doCotizacion.EOF) do begin
        doCotizacion.Next;
        inc(num);
      end;
      result := field.Value;
  finally
    doCotizacion.EndObserver;
  end;
end;
}

function TdComentario.getCambiosAnteriores(NumDias: integer): TCambios;
var field: TField;
  num: integer;
  valor: currency;
begin
  SetLength(result, NumDias);
  doCotizacion.StartObserver;
  try
      doCotizacion.Next;
      field := doCotizacion.getField('CIERRE');
      num := 0;
      while (num < NumDias) and (not doCotizacion.EOF) do begin
        if not field.IsNull then begin
          valor := field.Value;
          if (valor <> 0) then begin
            result[num] := valor;
            inc(num);
          end;
        end;
        doCotizacion.Next;
      end;
  finally
    doCotizacion.EndObserver;
  end;
end;

function TdComentario.getOIDCotizacionDiaAnterior: integer;
var field: TField;
begin
  doCotizacion.StartObserver;
  try
      doCotizacion.Next;
      field := doCotizacion.getField('OID_COTIZACION');
      while (field.IsNull) and (not doCotizacion.EOF) do
        doCotizacion.Next;
      result := field.Value;
  finally
    doCotizacion.EndObserver;
  end;
end;

procedure TdComentario.Open(OIDCotizacion: integer);
begin
  EstadoAyer.Close;
  EstadoAyer.Params[0].AsInteger := OIDCotizacion;
  EstadoAyer.Open;
end;

end.
