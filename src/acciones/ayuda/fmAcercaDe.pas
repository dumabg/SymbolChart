unit fmAcercaDe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, fmSplash, JvComponentBase, JvComputerInfoEx, StdCtrls,
  Buttons, JvGIF, JvExControls, JvAnimatedImage, JvGIFCtrl, jpeg, ExtCtrls;

type
  TfAcercaDe = class(TFBase)
    bEnviar: TBitBtn;
    Info: TJvComputerInfoEx;
    lURL: TLabel;
    lMail: TLabel;
    Image2: TImage;
    Image3: TImage;
    lCerrar: TImage;
    lID: TLabel;
    lSO: TLabel;
    lCPU: TLabel;
    lMemoria: TLabel;
    lPantalla: TLabel;
    Label8: TLabel;
    Image1: TImage;
    Bevel1: TBevel;
    lVersion: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure lURLClick(Sender: TObject);
    procedure lMailClick(Sender: TObject);
    procedure bEnviarClick(Sender: TObject);
    procedure lCerrarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

uses dmConfiguracion, UserServerCalls, fmExceptionEnviando, dmInternalServer, Web;

{$R *.dfm}

resourcestring
  GRACIAS = 'Gracias por su colaboración';
  ERROR_ENVIO = 'No se ha podido enviar la información.' + #13 + #13 + '%s';
  PANTALLA = 'Pantalla';
  MEMORIA = 'Memoria';
  CPU = 'CPU';
  SO = 'SO';

procedure TfAcercaDe.bEnviarClick(Sender: TObject);
var bugServerCall: TBugServerCall;
  bugServer: TInternalServer;
  fExcepcionEnviando: TfExcepcionEnviando;
  report: string;
begin
  fExcepcionEnviando := TfExcepcionEnviando.Create(Self);
  try
    fExcepcionEnviando.Show;
    fExcepcionEnviando.Repaint;
    try
      bugServer := TInternalServer.Create(nil);
      try
        bugServerCall := TBugServerCall.Create(bugServer);
        try
          report := lVersion.Caption + sLineBreak + lID.Caption  + sLineBreak + lSO.Caption + sLineBreak +
            lCPU.Caption + sLineBreak + lMemoria.Caption + sLineBreak + lPantalla.Caption;
          bugServerCall.Call('Info', report);
        finally
          bugServerCall.Free;
        end;
      finally
        bugServer.Free;
      end;
      ShowMessage(GRACIAS);
      Close;
    except on E:Exception do
      ShowMessage(Format(ERROR_ENVIO, [E.Message]));
    end;
  finally
    fExcepcionEnviando.Free;
  end;
end;

procedure TfAcercaDe.FormCreate(Sender: TObject);
var id: string;
begin
  inherited;
  lVersion.Caption := '4.4'; //Configuracion.Sistema.Version;
  lPantalla.Caption := PANTALLA + ': ' + IntToStr(Info.Screen.Width) + 'x' + IntToStr(Info.Screen.Height);
  lMemoria.Caption := MEMORIA + ': ' + Format('%2.2n',[Info.Memory.TotalPhysicalMemory/1024/1024/1024]) + 'GB. Free:' +
    Format('%2.2n',[Info.Memory.FreePhysicalMemory/1024/1024/1024]) + 'GB.';
  lCPU.Caption := CPU + ': ' + Info.CPU.Name;
  lSO.Caption := SO + ': ' + Info.OS.ProductName + ' ' + Info.OS.VersionCSDString;
  id := Configuracion.Sistema.GUID;
  lID.Caption := 'ID: ' + Copy(id, 5, 4) + id + Copy(id, 15, 4);
end;

procedure TfAcercaDe.lCerrarClick(Sender: TObject);
begin
  Close;
end;

procedure TfAcercaDe.lMailClick(Sender: TObject);
begin
  AbrirURL('mailto:soporte@symbolchart.com');
end;

procedure TfAcercaDe.lURLClick(Sender: TObject);
begin
  AbrirURL('http://www.symbolchart.com');
end;

end.
