unit dmMapaValores;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, kbmMemTable,
  dmUltimGridSorter;

type
  TMapaValores = class(TUltimGridSorter)
    qValores: TIBQuery;
    Valores: TkbmMemTable;
    ValoresOID_VALOR: TSmallintField;
    ValoresNOMBRE: TIBStringField;
    ValoresSIMBOLO: TIBStringField;
    ValoresDINERO: TIBBCDField;
    ValoresPAPEL: TIBBCDField;
    ValoresZONA: TIBStringField;
    ValoresPAIS: TIBStringField;
    ValoresSELECCIONADO: TBooleanField;
    qValoresOR_VALOR: TSmallintField;
    qValoresDINERO: TIBBCDField;
    qValoresPAPEL: TIBBCDField;
    qValoresZONA: TIBStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure ValoresFilterRecord(DataSet: TDataSet; var Accept: Boolean);
  private
    procedure SetOIDSesion(const Value: integer);
    function GetVerSeleccionados: boolean;
    procedure SetVerSeleccionados(const Value: boolean);
  public
    procedure Seleccionar;
    procedure SeleccionarZona(const zona: string);
    procedure DiaSiguiente;
    procedure DiaAnterior;
    property OIDSesion: integer write SetOIDSesion;
    property VerSeleccionados: boolean read GetVerSeleccionados write SetVerSeleccionados;
  end;


implementation

uses dmBD, dmData, UtilDB, dmDataComun;

{$R *.dfm}

{ TMapaValores }

procedure TMapaValores.DataModuleCreate(Sender: TObject);
begin
  OIDSesion := Data.OIDSesion;
  DefaultField := ValoresSELECCIONADO;
end;

procedure TMapaValores.DiaAnterior;
begin
  Data.dsCotizacion.DataSet.Next;
  OIDSesion := Data.OIDSesion;
end;

procedure TMapaValores.DiaSiguiente;
begin
  Data.dsCotizacion.DataSet.Prior;
  OIDSesion := Data.OIDSesion;
end;

function TMapaValores.GetVerSeleccionados: boolean;
begin
  result := Valores.Filtered;
end;

procedure TMapaValores.Seleccionar;
begin
  Valores.Edit;
  ValoresSELECCIONADO.Value := not ValoresSELECCIONADO.Value;
  Valores.Post;
end;

procedure TMapaValores.SeleccionarZona(const zona: string);
var inspect: TInspectDataSet;
  filtered: boolean;
begin
  filtered := Valores.Filtered;
  if filtered then begin
    inspect := StartInspectDataSet(Valores);
    Valores.Filtered := false;
  end;
  SeleccionarCampo(zona, ValoresZONA);
  if filtered then begin
    EndInspectDataSet(inspect);
    Valores.Filtered := true;
  end;
end;

procedure TMapaValores.SetOIDSesion(const Value: integer);
var OIDsValores: TStringList;
  events: TDataSetEvents;
  pDataComun: PDataComunValor;
  OIDValor: integer;
begin
  events := DisableEventsDataSet(Valores);
  try
    if Valores.Active then begin
      OIDsValores := TStringList.Create;
      Valores.First;
      while not Valores.Eof do begin
        if ValoresSELECCIONADO.Value then
          OIDsValores.Add(ValoresOID_VALOR.AsString);
        Valores.Next;
      end;
    end
    else
      OIDsValores := nil;

    qValores.Close;
    qValores.ParamByName('OID_SESION').AsInteger := Value;
    qValores.Open;
    qValores.First;
    Valores.Close;
    Valores.Open;
    while not qValores.Eof do begin
      Valores.Append;
      OIDValor := qValoresOR_VALOR.Value;
      pDataComun := DataComun.FindValor(OIDValor);
      ValoresOID_VALOR.Value := OIDValor;
      ValoresNOMBRE.Value := pDataComun^.Nombre;
      ValoresSIMBOLO.Value := pDataComun^.Simbolo;
      ValoresDINERO.Value := qValoresDINERO.Value;
      ValoresPAPEL.Value := qValoresPAPEL.Value;
      ValoresZONA.Value := DataComun.FindZona(qValoresZONA.AsInteger);
      ValoresPAIS.Value := pDataComun^.Mercado^.Pais;
      ValoresSELECCIONADO.Value := (OIDsValores = nil) or
        (OIDsValores.IndexOf(qValoresOR_VALOR.AsString) > -1);
      Valores.Post;
      qValores.Next;
    end;
    qValores.Close;
    Valores.First;
  finally
    EnableEventsDataSet(Valores, events);
    FreeAndNil(OIDsValores);
  end;
end;

procedure TMapaValores.SetVerSeleccionados(const Value: boolean);
begin
  Valores.Filtered := Value;
end;

procedure TMapaValores.ValoresFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  inherited;
  Accept := ValoresSELECCIONADO.Value;
end;

end.
