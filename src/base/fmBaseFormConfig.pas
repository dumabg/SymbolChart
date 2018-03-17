unit fmBaseFormConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase;

type
  TFormConfig = set of (fcSize, fcPosition, fcWindowState);

  TfBaseFormConfig = class(TfBase)
  private
  protected
    FormConfig: TFormConfig;
    procedure LoadFormConfig(const seccion: string); virtual;
    procedure SaveFormConfig(const seccion: string); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AfterConstruction; override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses dmConfiguracion;

{ TfBaseFormConfig }

procedure TfBaseFormConfig.AfterConstruction;
begin
  inherited;
  Position := poDesigned;
  LoadFormConfig(ClassName);
end;

constructor TfBaseFormConfig.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormConfig := [fcSize, fcPosition];
end;

destructor TfBaseFormConfig.Destroy;
begin
  SaveFormConfig(ClassName);
  inherited;
end;

procedure TfBaseFormConfig.LoadFormConfig(const seccion: string);
begin
  if fcSize in FormConfig then begin
    Width := Configuracion.ReadInteger(seccion, 'Width', Width);
    Height := Configuracion.ReadInteger(seccion, 'Height', Height);
  end;
  if fcPosition in FormConfig then begin
    Left := Configuracion.ReadInteger(seccion, 'Left', Left);
    Top := Configuracion.ReadInteger(seccion, 'Top', Top);
  end;
  if fcWindowState in FormConfig then
    WindowState := TWindowState(Configuracion.ReadInteger(seccion, 'WindowState', Integer(WindowState)));
end;

procedure TfBaseFormConfig.SaveFormConfig(const seccion: string);
var pl: TWindowPlacement;
  r: TRect;
begin
  pl.length := SizeOf(TWindowPlacement);
  GetWindowPlacement(Handle, @pl);
  r := pl.rcNormalPosition;
  if fcSize in FormConfig then begin
    Configuracion.WriteInteger(seccion, 'Width', r.Right - r.Left);
    Configuracion.WriteInteger(seccion, 'Height', r.Bottom - r.Top);
  end;
  if fcPosition in FormConfig then begin
    Configuracion.WriteInteger(seccion, 'Left', r.Left);
    Configuracion.WriteInteger(seccion, 'Top', r.Top);
  end;
  if fcWindowState in FormConfig then begin
    if WindowState = wsMinimized then
      Configuracion.WriteInteger(seccion, 'WindowState', Integer(wsNormal))
    else
      Configuracion.WriteInteger(seccion, 'WindowState', Integer(WindowState));
  end;
end;

end.
