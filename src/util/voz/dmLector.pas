unit dmLector;

interface

uses
  SysUtils, Classes, OleServer, SpeechLib_TLB, Controls, tipos;

type
  TLector = class;

  TThreadLector = class(TThread)
  private
    InPause: boolean;
    Stopped: boolean;
    Paused: boolean;
    Resumed: boolean;
    FVoice: TSpVoice;
    FLector: TLector;
    FTexto: string;
  public
    procedure Execute; override;
    procedure Pause;
    procedure Stop;
    property Voice: TSpVoice read FVoice;
    property Lector: TLector read FLector write FLector;
    property Texto: string read FTexto write FTexto;
  end;


  EErrorLector = class(Exception);

  TLector = class(TDataModule)
    SpVoice: TSpVoice;
    procedure SpVoiceVoiceChange(ASender: TObject; StreamNumber: Integer;
      StreamPosition: OleVariant; const VoiceObjectToken: ISpeechObjectToken);
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    Texto: string;
    FVozActiva: integer;
    voices: ISpeechObjectTokens;
    FOnHablaFinalizada: TNotificacion;
    t: TThreadLector;
    procedure SetVozActiva(const Value: integer);
    function GetRate: integer;
    procedure SetRate(const Value: integer);
    function GetVolume: integer;
    procedure SetVolume(const Value: integer);
    function PrepararTexto(const texto: string): string;
    procedure OnThreadFinish (Sender: TObject);
    procedure Habla; overload;
  public
    procedure MostrarErrorVoz;
    procedure InitializeVoices;
    procedure Habla(const titulo, texto: string); overload;
    procedure Habla(const texto: string); overload;
    procedure ParaDeHablar;
    procedure Pausa;
    procedure CargarNombreVoces(const voces: TStrings);
    property VozActiva: integer read FVozActiva write SetVozActiva;
    property Rate: integer read GetRate write SetRate;
    property Volume: integer read GetVolume write SetVolume;
    property OnHablaFinalizada: TNotificacion read FOnHablaFinalizada write FOnHablaFinalizada;
  end;


implementation

uses Windows, ActiveX, StrUtils, Forms, ServerURLs, UtilForms, Web,
  dmConfiguracion, Dialogs;

{$R *.dfm}

type
  TOperacion = (oParar, oReproducir, oPausa);

const
  Traduccion: array [1..16, 1..2] of string =
    ( ('NO','no'),('A-','A menos'),('A+','A más'),('AB+','A be más'),('AB-','A be menos'),
    ('B-','be menos'),('B+','be más'),('0+','0 más'),('0-','0 menos'),
    ('etc.', 'etcétera'), ('RSI', 'erre ese i '), ('(-)', 'negativo'),
    ('(L)', 'largo'), ('(C)', 'corto'), ('(LC)', 'largo y corto'),
    ('Swing Trading', 'suing treiding')
    );

resourcestring
  TITULO_ERROR_VOZ = 'Error de voz';
  MSG_ERROR_VOZ = 'No se puede contactar con el sistema de voz ' +
      'de Windows. La causa más probable es que no esté instalado o configurado correctamente.' +
      sLineBreak + sLineBreak + '¿Desea consultar el apartado de ayuda sobre la voz?';

{ TLector }

procedure TLector.CargarNombreVoces(const voces: TStrings);
var i: integer;
  SOToken: ISpeechObjectToken;
begin
  voces.Clear;
  try
    InitializeVoices;
    for i := 0 to voices.Count - 1 do begin
      SOToken := voices.Item(I);
      voces.Add(SOToken.GetDescription(0));
    end;
  except
    raise EErrorLector.Create('');
  end;
end;

procedure TLector.DataModuleCreate(Sender: TObject);
begin
  InitializeVoices;
end;

procedure TLector.DataModuleDestroy(Sender: TObject);
begin
  if t<>nil then begin
    t.OnTerminate := nil;
    t.Stop;
  end;
end;

function TLector.GetRate: integer;
begin
  try
    result := SpVoice.Rate;
  except
    raise EErrorLector.Create('');
  end;
end;

function TLector.GetVolume: integer;
begin
  try
    result := SpVoice.Volume;
  except
    raise EErrorLector.Create('');
  end;
end;

procedure TLector.Habla(const titulo, texto: string);
begin
  if titulo <> '' then
    Habla(titulo + '.' + sLineBreak + texto)
  else
    Habla(texto);
end;

procedure TLector.Habla(const texto: string);
begin
  Self.Texto := texto;
  if t = nil then
    Habla;
end;

procedure TLector.Habla;
begin
  t := TThreadLector.Create(true);
  t.FreeOnTerminate := true;
  t.Lector := Self;
  t.OnTerminate := OnThreadFinish;
  t.Texto := PrepararTexto(Texto);
  Texto := '';
  t.Resume;
end;

procedure TLector.InitializeVoices;
begin
  try
    voices := SpVoice.GetVoices('', '');
  except
    raise EErrorLector.Create('');
  end;
end;

procedure TLector.MostrarErrorVoz;
begin
  if ShowMensaje(TITULO_ERROR_VOZ, MSG_ERROR_VOZ, mtError, mbYesNo) = mrYes then
    AbrirURL(Configuracion.Sistema.URLServidor + URL_VOZ);
end;

procedure TLector.OnThreadFinish(Sender: TObject);
begin
  t := nil;
  OnHablaFinalizada;
end;

procedure TLector.ParaDeHablar;
begin
  if t <> nil then
    t.Stop;
end;

procedure TLector.Pausa;
begin
  if t <> nil then
    t.Pause;
end;

function TLector.PrepararTexto(const texto: string): string;
var i: integer;
begin
  result := texto;
  for i := Low(Traduccion) to High(Traduccion) do
    result := ReplaceStr(result, Traduccion[i][1], Traduccion[i][2]);
end;

procedure TLector.SetRate(const Value: integer);
begin
  try
    SpVoice.Rate := Value;
  except
    raise EErrorLector.Create('');
  end;
end;

procedure TLector.SetVolume(const Value: integer);
begin
  try
    SpVoice.Volume := Value;
  except
    raise EErrorLector.Create('');
  end;
end;

procedure TLector.SetVozActiva(const Value: integer);
begin
  if Value < voices.Count then
    FVozActiva := Value;
end;

procedure TLector.SpVoiceVoiceChange(ASender: TObject; StreamNumber: Integer;
  StreamPosition: OleVariant; const VoiceObjectToken: ISpeechObjectToken);
begin
  FVozActiva := StreamNumber;
end;

{ TThreadLector }

procedure TThreadLector.Execute;
var completeEvent: integer;
begin
  inherited;
  InPause := false;
  CoInitialize(nil);
  FVoice := TSpVoice.Create(nil);
  try
    try
    FVoice.AutoConnect := false;
    FVoice.ConnectKind := ckNewInstance;
    FVoice.Connect;
    except
      on e: Exception do begin
        e.ClassName;
      end;
    end;
    FVoice.Voice := Lector.Voices.Item(Lector.VozActiva);
    FVoice.Rate := Lector.Rate;
    FVoice.Volume := Lector.Volume;
    FVoice.Speak(FTexto, SVSFlagsAsync);
    completeEvent := FVoice.SpeakCompleteEvent;
    while (not Stopped) and (WaitForSingleObject(completeEvent, 500) = WAIT_TIMEOUT) do begin
      if Resumed then begin
        FVoice.Resume;
        Resumed := false;
      end;
      if Paused then begin
        FVoice.Pause;
        Paused := false;
      end;
    end;
    if Stopped then begin
      FVoice.Disconnect;
      Stopped := false;
    end;
  finally
    FVoice.Free;
  end;
end;

procedure TThreadLector.Pause;
begin
  if InPause then
    Resumed := true
  else
    Paused := true;
  InPause := not InPause;
end;

procedure TThreadLector.Stop;
begin
  Stopped := true;
end;

end.
