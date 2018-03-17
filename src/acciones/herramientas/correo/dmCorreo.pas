unit dmCorreo;

interface

uses
  SysUtils, Classes, IBCustomDataSet, IBUpdateSQL, DB, IBQuery;

type
  TCorreo = class(TDataModule)
    qCorreo: TIBQuery;
    qCorreoOID_CORREO: TIntegerField;
    qCorreoFECHA_HORA: TDateTimeField;
    qCorreoTITULO: TIBStringField;
    qCorreoMENSAJE: TMemoField;
    uCorreo: TIBUpdateSQL;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Borrar;
    function Obtener(var hayNuevosMsg: boolean): boolean;
    function HayCorreo: boolean;
  end;

implementation

uses dmBD, dmMensajeria;

{$R *.dfm}

procedure TCorreo.Borrar;
begin
  qCorreo.Delete;
  BD.IBTransactionUsuario.CommitRetaining;
end;

procedure TCorreo.DataModuleCreate(Sender: TObject);
begin
  qCorreo.Open;
end;

function TCorreo.HayCorreo: boolean;
begin
  result := not qCorreo.IsEmpty;
end;

function TCorreo.Obtener(var hayNuevosMsg: boolean): boolean;
var oid: integer;
begin
  try
    Mensajeria.ChequearCorreo;
    hayNuevosMsg := Mensajeria.HayNuevosCorreos;
    if not qCorreo.IsEmpty then
      oid := qCorreoOID_CORREO.Value
    else
      oid := -1;
    qCorreo.Close;
    qCorreo.Open;
    if not qCorreo.IsEmpty then
      qCorreo.Locate('OID_CORREO', oid, []);
    result := true;
  except
    result := false;
  end;
end;

end.
