unit dmPanelSwing;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, flags, dmDataModuleBase,
  mensajesPanel;

type
  TPanelSwing = class(TDataModuleBase)
    CotizacionMensajes: TIBQuery;
    CotizacionMensajesOR_AVANCE: TIntegerField;
    CotizacionMensajesFLAGS: TIntegerField;
    CotizacionMensajesOR_SUGERENCIA: TIntegerField;
    qMensaje: TIBQuery;
    qMensajeES: TMemoField;
    CotizacionMensajesPARAMS_SUGERENCIA: TIBStringField;
    CotizacionMensajesOR_SONDEOS: TIntegerField;
    CotizacionMensajesPARAMS_SONDEOS: TIBStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FMensajes: TMensajes;
    function GetFlagsMensajes: TFlags;
    procedure OnTipoCotizacionCambiada;
  public
    function HayMensajeAvance: boolean;
    function NuevoMensaje: TMensajes;
    property FlagsMensajes: TFlags read GetFlagsMensajes;
  end;

implementation

uses dmData, UtilDB, dmBD, BusCommunication;

{$R *.dfm}


procedure TPanelSwing.DataModuleCreate(Sender: TObject);
begin
  SetLength(FMensajes, 1);
  OpenDataSet(CotizacionMensajes);
  Bus.RegisterEvent(MessageTipoCotizacionCambiada, OnTipoCotizacionCambiada);
end;

procedure TPanelSwing.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  Bus.UnregisterEvent(MessageTipoCotizacionCambiada, OnTipoCotizacionCambiada);
end;

function TPanelSwing.GetFlagsMensajes: TFlags;
begin
  result := TFlags.Create;
  result.Flags := CotizacionMensajesFLAGS.Value;
end;

function TPanelSwing.HayMensajeAvance: boolean;
begin
  result := not CotizacionMensajesOR_AVANCE.IsNull;
end;

function TPanelSwing.NuevoMensaje: TMensajes;
var cad: string;
begin
  qMensaje.Close;;
//  qMensaje.Params[0].AsInteger := CotizacionMensajesOR_SUGERENCIA.Value;
  qMensaje.Params[0].AsInteger := CotizacionMensajesOR_SONDEOS.Value;
  qMensaje.Open;
  cad := '';
  while not qMensaje.Eof do begin
    cad := cad + qMensajeES.Value + '. ';
    qMensaje.Next;
  end;
  FMensajes[0].mensaje := cad;
//  FMensajes[0].Params := CotizacionMensajesPARAMS_SUGERENCIA.AsString;
  FMensajes[0].Params := CotizacionMensajesPARAMS_SONDEOS.AsString;
  FMensajes[0].TipoOID := 0;
  FMensajes[0].Titulo := '';
//  FMensajes[0].IsNull := CotizacionMensajesOR_SUGERENCIA.IsNull;
  FMensajes[0].IsNull := CotizacionMensajesOR_SONDEOS.IsNull;
  FMensajes[0].visible := true;
  result := FMensajes;
end;

procedure TPanelSwing.OnTipoCotizacionCambiada;
begin
  OpenDataSet(CotizacionMensajes);
end;

end.
