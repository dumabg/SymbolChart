unit dmPanelInhibidores;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, dmDataModuleBase;

type
  TPanelInhibidores = class(TDataModuleBase)
    qInhibidor: TIBQuery;
    qInhibidorTOTAL_PERCENT: TIBBCDField;
    qInhibidorINHIBIDOR: TIBStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure OnTipoCotizacionCambiada;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses dmData, UtilDB, dmBD, BusCommunication;

procedure TPanelInhibidores.DataModuleCreate(Sender: TObject);
begin
  OpenDataSet(qInhibidor);
  Bus.RegisterEvent(MessageTipoCotizacionCambiada, OnTipoCotizacionCambiada);
end;

procedure TPanelInhibidores.DataModuleDestroy(Sender: TObject);
begin
  Bus.UnregisterEvent(MessageTipoCotizacionCambiada, OnTipoCotizacionCambiada);
end;

procedure TPanelInhibidores.OnTipoCotizacionCambiada;
begin
  OpenDataSet(qInhibidor);
end;

end.
