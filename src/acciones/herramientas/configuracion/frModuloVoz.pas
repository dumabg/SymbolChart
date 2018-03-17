unit frModuloVoz;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frModulo, ImgList, JvComponentBase, JvErrorIndicator,
  ExtCtrls, StdCtrls, ComCtrls, ToolWin, dmLector;

type
  TfModuloVoz = class(TfModulo)
    gbAttrs: TGroupBox;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    tbRate: TTrackBar;
    tbVolume: TTrackBar;
    GroupBox1: TGroupBox;
    tbProbarVoz: TToolBar;
    btnPlay: TToolButton;
    btnStop: TToolButton;
    mVozPrueba: TMemo;
    cbVoz: TComboBox;
    Image1: TImage;
    urlVoz: TLabel;
    procedure btnPlayClick(Sender: TObject);
    procedure cbVozChange(Sender: TObject);
    procedure tbRateChange(Sender: TObject);
    procedure tbVolumeChange(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure urlVozClick(Sender: TObject);
  private
    Lector: TLector;
    procedure OnHablaFinalizada;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Guardar; override;
    class function Titulo: string; override;
  end;


implementation

uses dmLectorImages, Web, ServerURLs, dmConfiguracion, StrUtils;

resourcestring
  TITULO_MODULO = 'Voz';

{$R *.dfm}

procedure TfModuloVoz.btnPlayClick(Sender: TObject);
begin
  btnStop.Enabled := true;
  btnPlay.Enabled := false;
  Lector.Habla(ReplaceText(mVozPrueba.Text, 'SymbolChart', 'symbol chart'));
end;

procedure TfModuloVoz.btnStopClick(Sender: TObject);
begin
  Lector.ParaDeHablar;
  OnHablaFinalizada;
end;

procedure TfModuloVoz.cbVozChange(Sender: TObject);
begin
  Lector.VozActiva := cbVoz.ItemIndex;
end;

constructor TfModuloVoz.Create(AOwner: TComponent);

  procedure EnableVoz(const enable: boolean);
  begin
    cbVoz.Enabled := enable;
    tbRate.Enabled := enable;
    tbVolume.Enabled := enable;
    btnPlay.Enabled := enable;
    mVozPrueba.Enabled := enable;
  end;
begin
  inherited Create(AOwner);
  Lector := TLector.Create(Self);
  try
    // No se puede poner el InitializeVoices en el constructor del TLectorFP
    // porque si tira una excepción esta no se porque no se coge en el except
    Lector.InitializeVoices;
    EnableVoz(true);
  except
    Lector.MostrarErrorVoz;
    FreeAndNil(Lector);
    EnableVoz(false);
    exit;
  end;
  Lector.OnHablaFinalizada := OnHablaFinalizada;
  Lector.CargarNombreVoces(cbVoz.Items);
  tbVolume.Position := Lector.Volume;
  tbRate.Position := Lector.Rate;
  cbVoz.ItemIndex := Lector.VozActiva;
end;

procedure TfModuloVoz.Guardar;
begin
  Configuracion.Voz.Velocidad := Lector.Rate;
  Configuracion.Voz.Volumen := Lector.Volume;
  Configuracion.Voz.Activa := Lector.VozActiva;
end;

procedure TfModuloVoz.OnHablaFinalizada;
begin
  btnStop.Enabled := false;
  btnPlay.Enabled := true;
end;

procedure TfModuloVoz.tbRateChange(Sender: TObject);
begin
  Lector.Rate := tbRate.Position;
end;

procedure TfModuloVoz.tbVolumeChange(Sender: TObject);
begin
  Lector.Volume := tbVolume.Position;
end;

class function TfModuloVoz.Titulo: string;
begin
  result := TITULO_MODULO;
end;

procedure TfModuloVoz.urlVozClick(Sender: TObject);
begin
  inherited;
  AbrirURL(Configuracion.Sistema.URLServidor + URL_VOZ);
end;

end.
