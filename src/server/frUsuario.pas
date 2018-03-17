unit frUsuario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ActnList, Buttons, StdCtrls, GIFImg, ExtCtrls;

type
  TfUsuario = class(TFrame)
    Shape4: TShape;
    Image2: TImage;
    Label1: TLabel;
    lAlta: TLabel;
    bAlta: TSpeedButton;
    Label2: TLabel;
    lRecordar: TLabel;
    bRecordar: TSpeedButton;
    ActionList: TActionList;
    Recordar: TAction;
    Alta: TAction;
    Shape1: TShape;
    procedure RecordarExecute(Sender: TObject);
    procedure AltaExecute(Sender: TObject);
  private
  public
  end;

implementation

{$R *.dfm}

uses Web, ServerURLs, dmConfiguracion;

procedure TfUsuario.AltaExecute(Sender: TObject);
begin
  AbrirURL(Configuracion.Sistema.URLServidor + URL_ALTA);
end;

procedure TfUsuario.RecordarExecute(Sender: TObject);
begin
  AbrirURL(Configuracion.Sistema.URLServidor + URL_RECORDAR);
end;

end.
