unit dmConfiguracion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmSistemaStorage, JvComponentBase, IBCustomDataSet, IBUpdateSQL,
  DB, IBQuery, dmConfigSistema, ConfigVersion,
  ConfigEscenarios, ConfigIdentificacion, dmConfigMensajes,
  ConfigRecordatorio, ConfigVoz, ConfigGrids, IBDatabase;

type
  TConfiguracion = class(TSistemaStorage)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FSistema: TConfigSistema;
    FVersion: TConfigVersion;
    FEscenarios: TConfigEscenarios;
    FIdentificacion: TConfigIdentificacion;
    FMensajes: TConfigMensajes;
    FRecordatorio: TConfigRecordatorio;
    FVoz: TConfigVoz;
    FGrids: TConfigGrids;
  public
    property Sistema: TConfigSistema read FSistema;
    property Version: TConfigVersion read FVersion;
    property Escenarios: TConfigEscenarios read FEscenarios;
    property Identificacion: TConfigIdentificacion read FIdentificacion;
    property Mensajes: TConfigMensajes read FMensajes;
    property Recordatorio: TConfigRecordatorio read FRecordatorio;
    property Voz: TConfigVoz read FVoz;
    property Grids: TConfigGrids read FGrids;
  end;

var
  Configuracion: TConfiguracion;

implementation
{$R *.dfm}

procedure TConfiguracion.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FSistema := TConfigSistema.Create(Self);
  FVersion := TConfigVersion.Create;
  FEscenarios := TConfigEscenarios.Create;
  FIdentificacion := TConfigIdentificacion.Create;
  FMensajes := TConfigMensajes.Create(Self);
  FRecordatorio := TConfigRecordatorio.Create;
  FVoz := TConfigVoz.Create;
  FGrids := TConfigGrids.Create;
end;


procedure TConfiguracion.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  FVersion.Free;
  FEscenarios.Free;
  FIdentificacion.Free;
  FRecordatorio.Free;
  FVoz.Free;
  FGrids.Free;
end;


end.
