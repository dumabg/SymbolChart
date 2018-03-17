unit fmBaseFormVisualConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, fmBaseFormConfig;

type
  TfBaseFormVisualConfig = class(TfBase)
  private
  protected
    FormConfig: TFormConfig;
    seccion: string;
    DefaultWidth, DefaultHeight, DefaultLeft, DefaultTop: integer;
    DefaultWindowState: TWindowState;
    procedure LoadFormConfig; virtual;
    procedure SaveFormConfig; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses ConfigVisual, BusCommunication, uAccionesVer;

{ TfBaseFormVisualConfig }

procedure TfBaseFormVisualConfig.AfterConstruction;
begin
  inherited;
  Position := poDesigned;
  LoadFormConfig;
end;

constructor TfBaseFormVisualConfig.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  seccion := ClassName;
  FormConfig := [fcSize, fcPosition];
  Bus.RegisterEvent(MessageVistaGuardando, SaveFormConfig);
  Bus.RegisterEvent(MessageVistaCargando, LoadFormConfig);
end;

destructor TfBaseFormVisualConfig.Destroy;
begin
  SaveFormConfig;
  Bus.UnregisterEvent(MessageVistaGuardando, SaveFormConfig);
  Bus.UnregisterEvent(MessageVistaCargando, LoadFormConfig);
  inherited;
end;

procedure TfBaseFormVisualConfig.LoadFormConfig;
begin
  if fcSize in FormConfig then begin
    Width := ConfiguracionVisual.ReadInteger(seccion, 'Width', DefaultWidth);
    Height := ConfiguracionVisual.ReadInteger(seccion, 'Height', DefaultHeight);
  end;
  if fcPosition in FormConfig then begin
    Left := ConfiguracionVisual.ReadInteger(seccion, 'Left', DefaultLeft);
    Top := ConfiguracionVisual.ReadInteger(seccion, 'Top', DefaultTop);
  end;
  if fcWindowState in FormConfig then
    WindowState := TWindowState(ConfiguracionVisual.ReadInteger(seccion, 'WindowState', Integer(DefaultWindowState)));
end;

procedure TfBaseFormVisualConfig.SaveFormConfig;
var pl: TWindowPlacement;
  r: TRect;
begin
  pl.length := SizeOf(TWindowPlacement);
  GetWindowPlacement(Handle, @pl);
  r := pl.rcNormalPosition;
  if fcSize in FormConfig then begin
    ConfiguracionVisual.WriteInteger(seccion, 'Width', r.Right - r.Left);
    ConfiguracionVisual.WriteInteger(seccion, 'Height', r.Bottom - r.Top);
  end;
  if fcPosition in FormConfig then begin
    ConfiguracionVisual.WriteInteger(seccion, 'Left', r.Left);
    ConfiguracionVisual.WriteInteger(seccion, 'Top', r.Top);
  end;
  if fcWindowState in FormConfig then begin
    if WindowState = wsMinimized then
      ConfiguracionVisual.WriteInteger(seccion, 'WindowState', Integer(wsNormal))
    else
      ConfiguracionVisual.WriteInteger(seccion, 'WindowState', Integer(WindowState));
  end;
end;

end.
