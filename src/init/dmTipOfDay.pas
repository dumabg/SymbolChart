unit dmTipOfDay;

interface

uses
  SysUtils, Classes, Dialogs, JvBaseDlg, JvTipOfDay;

type
  TTipOfDay = class(TDataModule)
    JvTipOfDay: TJvTipOfDay;
  private
    procedure OnMessageShowedSC;
    procedure Registrar;
  public
  end;

  procedure GlobalInitialization;

implementation

uses
  dmConfiguracion, SCMain, BusCommunication;

{$R *.dfm}


procedure TTipOfDay.OnMessageShowedSC;
begin
  if Configuracion.Recordatorio.MostrarAlIniciar then begin
    JvTipOfDay.Options := [toShowOnStartUp]; // Para que muestre el check seleccionado
    JvTipOfDay.Execute;
    Configuracion.Recordatorio.MostrarAlIniciar := toShowOnStartUp in JvTipOfDay.Options;
  end;
  Bus.UnregisterEvent(MessageSCShowed, OnMessageShowedSC);
  Free;
end;

procedure TTipOfDay.Registrar;
begin
  Bus.RegisterEvent(MessageSCShowed, OnMessageShowedSC);
end;

procedure GlobalInitialization;
begin
  //Se crea y se llama a registrar porque el TTipOfDay también se crea desde
  //uAccionesAyuda, y el MessageSCShowed solo se debe realizar cuando se inicia
  //la aplicación.
  TTipOfDay.Create(nil).Registrar;
end;

end.
