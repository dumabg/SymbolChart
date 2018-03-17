unit uPanel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TB2Dock, UtilDock;

type
  TfrPanel = class(TFrame)
  private
    FWindow: TTBCustomDockableWindow;
    FOnDestroy: TNotifyEvent;
    FDefaultDock: TDefaultDock;
    function GetWindow: TTBCustomDockableWindow;
    procedure OnClose(Sender: TObject);
  protected
    constructor CreatePanel(Owner: TComponent; const DefaultDock: TDefaultDock); reintroduce;
  public
    destructor Destroy; override;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
    property DefaultDock: TDefaultDock read FDefaultDock write FDefaultDock;
    property Window: TTBCustomDockableWindow read FWindow;
    // Propiedades de clase
    class function GetNombre: string; virtual; abstract;
    class function GetVisiblePorDefecto: boolean; virtual;
  end;

  TfrPanelClass = class of TfrPanel;

  TArrayPanelClass = array of TfrPanelClass;

  procedure RegisterPanelClass(const PanelClass: TfrPanelClass);
  function CreatePanel(const Owner: TComponent; const PanelName: string): TfrPanel;
  function GetPanelClasses: TArrayPanelClass;


implementation

{$R *.dfm}
resourcestring
  GETWINDOW_ERROR = 'El panel no tiene una TTBCustomDockableWindow. No puede crearse.';

var
  panelClasses : TArrayPanelClass;

type
  TTBCustomDockableWindowHacked = class(TTBCustomDockableWindow)
  public
    property Caption;
  end;

function GetPanelClasses: TArrayPanelClass;
begin
  result := panelClasses;
end;

function CreatePanel(const Owner: TComponent; const PanelName: string): TfrPanel;
var i: integer;
  panelClass: TfrPanelClass;
  nombre: string;
begin
  for i := Low(panelClasses) to High(panelClasses) do begin
    panelClass := panelClasses[i];
    if panelClass.ClassName = PanelName then begin
      result := panelClass.Create(Owner);
      nombre := panelClass.GetNombre;
      TTBCustomDockableWindowHacked(result.Window).Caption := nombre;
      exit;
    end;
  end;
  result := nil;
end;

procedure RegisterPanelClass(const PanelClass: TfrPanelClass);
var lon: integer;
begin
  lon := length(panelClasses);
  SetLength(panelClasses, lon + 1);
  panelClasses[lon] := PanelClass;  //zero based
end;

{ TfrPanel }

type
  TCrackCustomDockableWindow = class(TTBCustomDockableWindow)
  public
    property OnClose;
  end;

constructor TfrPanel.CreatePanel(Owner: TComponent; const DefaultDock: TDefaultDock);
begin
  inherited Create(Owner);
  Self.DefaultDock := DefaultDock;
  FWindow := GetWindow;
  TCrackCustomDockableWindow(FWindow).OnClose := OnClose;
//  TranslateComponent(Self);
end;

destructor TfrPanel.Destroy;
begin
  if Assigned(FOnDestroy) then
    FOnDestroy(Self);
  inherited Destroy;
end;

class function TfrPanel.GetVisiblePorDefecto: boolean;
begin
  result := true;
end;

function TfrPanel.GetWindow: TTBCustomDockableWindow;
var i: integer;
begin
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TTBCustomDockableWindow then begin
      result := TTBCustomDockableWindow(Components[i]);
      exit;
    end;
  raise Exception.Create(GETWINDOW_ERROR);
end;

procedure TfrPanel.OnClose(Sender: TObject);
begin
  Free;
end;

end.
