unit dmConsultaGrupo;

interface

uses
  SysUtils, Classes, IBSQL, DB, IBCustomDataSet, IBQuery;

type
  TConsultaGrupo = class(TDataModule)
    iGrupo: TIBSQL;
    iGrupoValor: TIBSQL;
    qExisteGrupo: TIBQuery;
    qExisteGrupoCOUNT: TIntegerField;
  private
    { Private declarations }
  public
    procedure CrearGrupo(const nombre: string; const dataSet: TDataSet;
      const field: TIntegerField);
    function ExisteGrupo(const nombre: string): Boolean;
  end;


implementation

uses dmBD, UtilDB, uAcciones, uAccionesValor, dmAccionesValor;

{$R *.dfm}

{ TConsultaGrupo }

procedure TConsultaGrupo.CrearGrupo(const nombre: string;
  const dataSet: TDataSet; const field: TIntegerField);
var OIDGrupo: integer;
  inspect: TInspectDataSet;
  param: TIBXSQLVAR;
  accionesValor: TAccionesValor;
  DataAccionesValor: TDataAccionesValor;
begin
  accionesValor := GetAcciones(TAccionesValor) as TAccionesValor;
  DataAccionesValor := accionesValor.DataAccionesValor;
  if DataAccionesValor.ExisteGrupo(nombre) then begin
    OIDGrupo := DataAccionesValor.ResetGrupo(nombre);
  end
  else
    OIDGrupo := DataAccionesValor.AnadirGrupo(nombre);
  accionesValor.CreateMisGrupos;
  inspect := StartInspectDataSet(dataset);
  try
    iGrupoValor.ParamByName('OR_GRUPO').Value := OIDGrupo;
    param := iGrupoValor.ParamByName('OR_VALOR');
    dataset.First;
    while not dataset.Eof do begin
      param.AsInteger := field.Value;
      ExecQuery(iGrupoValor, false);
      dataset.Next;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
  iGrupoValor.Transaction.CommitRetaining;
end;

function TConsultaGrupo.ExisteGrupo(const nombre: string): Boolean;
begin
  qExisteGrupo.Close;
  qExisteGrupo.Params[0].AsString := nombre;
  qExisteGrupo.Open;
  result := qExisteGrupoCOUNT.Value > 0;
end;

end.
