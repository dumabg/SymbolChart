unit dmTareas;

interface

uses
  SysUtils, Classes, DB, kbmMemTable, Windows, Messages, dmHandledDataModule,
  UtilThread;

type
  TTareaMessageType = (tmtInfo, tmtWarning, tmtError);

  TTarea = class;

  TOnPerCentNotify = procedure (const Sender: TTarea; const percent: integer) of object;

  TEstadoTarea = (etIndeterminado, etCorriendo, etPausada, etParando);

  TTareaMessage = record
    fecha: TDateTime;
    tipo: TTareaMessageType;
    msg: string;
  end;

  PTareaMessage = ^TTareaMessage;

  TOnMessageNotify = procedure (const Sender: TTarea; const pMsg: PTareaMessage) of object;

  TTarea = class(TProtectedThread)
  private
    fHWnd: HWND;
    FID: integer;
    FOnPerCent: TOnPerCentNotify;
    FOnMessage: TOnMessageNotify;
    FMessages: array of TTareaMessage;
    FMaxPosition: integer;
    function GetPMessage(const index: integer): PTareaMessage;
    function GetMessageCount: integer;
  protected
    lastPercent: integer;
    procedure NotificarTareaEnd;
    procedure DoPerCent(const percent: integer); virtual;
    procedure DoMessage(const tipoMsg: TTareaMessageType; const mensaje: string); virtual;
    procedure DoPerCentPos(const position: integer); virtual;
    procedure InternalCancel; override;    
    property MaxPosition: integer read FMaxPosition write FMaxPosition;
  public
    constructor Create; reintroduce;
    procedure Execute; override;
    property PMessage[const index: integer]: PTareaMessage read GetPMessage;
    property OnMessage: TOnMessageNotify read FOnMessage write FOnMessage;
    property OnPerCent: TOnPerCentNotify read FOnPerCent write FOnPerCent;
    property ID: integer read FID;
    property Percent: integer read lastPercent;
    property MessageCount: integer read GetMessageCount;
  end;

  TTareas = class(THandledDataModule)
    kbmTareas: TkbmMemTable;
    kbmTareasID: TIntegerField;
    kbmTareasTIPO: TStringField;
    kbmTareasDESCRIPCION: TStringField;
    kbmTareasPRIORIDAD: TIntegerField;
    kbmTareasPERCENT: TIntegerField;
    kbmTareasESTADO: TIntegerField;
    procedure kbmTareasPRIORIDADGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure kbmTareasESTADOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure kbmTareasPERCENTGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    lastID: integer;
    listaTareas: TStringList;
    criticalSection: TRTLCriticalSection;
    procedure OnTareaMsg(const id: integer; const msgIndex: integer);
    procedure OnTareaTerminated(const id: integer);
    procedure OnTareaPerCent(const id: integer; const percent: integer);
    function GetPriority: TThreadPriority;
    procedure SetPriority(const Value: TThreadPriority);
    function GetCount: integer;
    function GetEstado: TEstadoTarea;
    function GetTareas(const i: integer): TTarea;
  protected
    procedure WndMethod(var Msg: TMessage); override;
    procedure Kill(const id: integer);
  public
    procedure Parar;
    procedure Reanudar;
    procedure Pausar;
    procedure CancelarTodas;
    function GetTarea(const id: integer): TTarea;
    function GetTareaActual: TTarea;
    function EjecutarTarea(const tarea: TTarea; const tipo, descripcion: string): integer;
    property Priority: TThreadPriority read GetPriority write SetPriority;
    property Count: integer read GetCount;
    property Estado: TEstadoTarea read GetEstado;
    property Tareas[const i: integer]: TTarea read GetTareas;
  end;

  function FormatTareaMessage(const pMsg: PTareaMessage): string;
  function MessageTypeToString(const msgType: TTareaMessageType): string;

  var Tareas: TTareas;

implementation
{$R *.dfm}

uses forms;

const
  WM_TAREA_PER_CENT = WM_USER + 0;
  WM_TAREA_MESSAGE = WM_USER + 1;
  WM_TAREA_END = WM_USER + 2;

resourcestring
    PRIORITY_IDLE = 'Bajísima';
    PRIORITY_LOWEST = 'Muy baja';
    PRIORITY_LOWER = 'Baja';
    PRIORITY_NORMAL = 'Normal';
    PRIORITY_HIGHER = 'Alta';
    PRIORITY_HIGHEST = 'Muy alta';
    PRIORITY_TIMECRITICAL = 'Altísima';

    ESTADO_CORRIENDO = 'Corriendo';
    ESTADO_PAUSADA = 'Pausada';
    ESTADO_PARANDO = 'Parando';

    MESSAGE_TYPE_INFO = 'I';
    MESSAGE_TYPE_WARNING = 'W';
    MESSAGE_TYPE_ERROR = 'E';

  function MessageTypeToString(const msgType: TTareaMessageType): string;
  begin
    case msgType of
      tmtInfo : result := MESSAGE_TYPE_INFO;
      tmtWarning : result := MESSAGE_TYPE_WARNING;
      tmtError : result := MESSAGE_TYPE_ERROR;
    end;
  end;

  function FormatTareaMessage(const pMsg: PTareaMessage): string;
  begin
    result := '[' + DateTimeToStr(pMsg^.fecha) + '] [' +
      MessageTypeToString(pMsg^.tipo) + '] ' + pMsg^.msg;
  end;

{ TTareas }

function TTareas.EjecutarTarea(const tarea: TTarea; const tipo,
  descripcion: string): integer;
begin
  kbmTareas.Append;
  kbmTareasID.Value := lastID;
  kbmTareasTIPO.Value := tipo;
  kbmTareasDESCRIPCION.Value := descripcion;
  kbmTareasPERCENT.Clear;
  kbmTareasPRIORIDAD.Value := Integer(tarea.Priority);
  kbmTareasESTADO.Value := Integer(etCorriendo);
  kbmTareas.Post;
  listaTareas.AddObject(IntToStr(lastID), tarea);
  tarea.FID := lastID;
  tarea.fHWnd := Handle;
  tarea.Resume;
  result := lastID;
  inc(lastID);
end;

procedure TTareas.CancelarTodas;
//var i: Integer;
begin
{  EnterCriticalSection(criticalSection);
  for i := listaTareas.Count - 1 downto 0 do
    TTarea(listaTareas.Objects[i]).Cancel;
  LeaveCriticalSection(criticalSection);}
  while listaTareas.Count > 0 do
    Application.ProcessMessages;
end;

procedure TTareas.DataModuleCreate(Sender: TObject);
begin
  InitializeCriticalSection(criticalSection);
  listaTareas := TStringList.Create;
  lastID := 0;
  kbmTareas.Open;
end;

procedure TTareas.DataModuleDestroy(Sender: TObject);
begin
  listaTareas.Free;
  DeleteCriticalSection(criticalSection);
end;

function TTareas.GetCount: integer;
begin
  result := listaTareas.Count;
end;

function TTareas.GetEstado: TEstadoTarea;
begin
  result := TEstadoTarea(kbmTareasESTADO.Value);
end;

function TTareas.GetPriority: TThreadPriority;
begin
  result := GetTareaActual.Priority;
end;

function TTareas.GetTarea(const id: integer): TTarea;
var i: integer;
begin
  i := listaTareas.IndexOf(IntToStr(id));
  if i = -1 then
    result := nil
  else
    result := TTarea(listaTareas.Objects[i]);
end;

function TTareas.GetTareaActual: TTarea;
begin
  result := GetTarea(kbmTareasID.Value);
end;

function TTareas.GetTareas(const i: integer): TTarea;
begin
  result := TTarea(listaTareas.Objects[i]);
end;

procedure TTareas.Kill(const id: integer);
var i: integer;
begin
  if kbmTareas.Locate('ID', id, []) then begin
    kbmTareas.Delete;
    i := listaTareas.IndexOf(IntToStr(id));
    listaTareas.Delete(i);
  end;
end;

procedure TTareas.Parar;
var tarea: TTarea;
begin
  kbmTareas.Edit;
  kbmTareasESTADO.Value := integer(etParando);
  kbmTareas.Post;
  tarea := GetTareaActual;
  tarea.Cancel;
end;

procedure TTareas.Pausar;
begin
  kbmTareas.Edit;
  kbmTareasESTADO.Value := integer(etPausada);
  kbmTareas.Post;
  GetTareaActual.Suspend;
end;

procedure TTareas.Reanudar;
begin
  kbmTareas.Edit;
  kbmTareasESTADO.Value := integer(etCorriendo);
  kbmTareas.Post;
  GetTareaActual.Resume;
end;

procedure TTareas.SetPriority(const Value: TThreadPriority);
begin
  kbmTareas.Edit;
  kbmTareasPRIORIDAD.Value := Integer(Value);
  kbmTareas.Post;
  GetTareaActual.Priority := Value;
end;

procedure TTareas.kbmTareasESTADOGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else begin
    case TEstadoTarea(Sender.AsInteger) of
      etCorriendo : Text := ESTADO_CORRIENDO;
      etPausada : Text := ESTADO_PAUSADA;
      etParando : Text := ESTADO_PARANDO;
    end;
  end;
end;

procedure TTareas.kbmTareasPERCENTGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := Sender.AsString + '%';
end;

procedure TTareas.kbmTareasPRIORIDADGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else begin
    case TThreadPriority(Sender.AsInteger) of
      tpIdle : Text := PRIORITY_IDLE;
      tpLowest : Text := PRIORITY_LOWEST;
      tpLower : Text := PRIORITY_LOWER;
      tpNormal : Text := PRIORITY_NORMAL;
      tpHigher : Text := PRIORITY_HIGHER;
      tpHighest : Text := PRIORITY_HIGHEST;
      tpTimeCritical : Text := PRIORITY_TIMECRITICAL;
    end;
  end;
end;

procedure TTareas.WndMethod(var Msg: TMessage);
begin
  case Msg.Msg of
    WM_TAREA_PER_CENT: OnTareaPerCent(Msg.WParam, Msg.LParam);
    WM_TAREA_MESSAGE: OnTareaMsg(Msg.WParam, Msg.LParam);
    WM_TAREA_END: OnTareaTerminated(Msg.WParam);
  end;
end;

procedure TTareas.OnTareaMsg(const id, msgIndex: integer);
var tarea: TTarea;
begin
  tarea := GetTarea(id);
  if Assigned(tarea.OnMessage) then
    tarea.OnMessage(tarea, tarea.PMessage[msgIndex]);
end;

procedure TTareas.OnTareaPerCent(const id, percent: integer);
var bookmark: TBookmarkStr;
  tarea: TTarea;
begin
  bookmark := kbmTareas.Bookmark;
  try
    if kbmTareas.Locate('ID', id, []) then begin
      kbmTareas.Edit;
      kbmTareasPERCENT.Value := percent;
      kbmTareas.Post;
    end;
  finally
    kbmTareas.Bookmark := bookmark;
  end;

  tarea := GetTarea(id);
  if (tarea <> nil) and (not tarea.Terminated) then begin
    if Assigned(tarea.OnPerCent) then
      tarea.OnPerCent(tarea, percent);
  end;
end;

procedure TTareas.OnTareaTerminated(const id: integer);
begin
  EnterCriticalSection(criticalSection);
  Kill(id);
  LeaveCriticalSection(criticalSection);
end;

{ TTarea }

constructor TTarea.Create;
begin
  inherited Create(true);
  lastPercent := 0;
  SetLength(FMessages, 0);
end;

procedure TTarea.DoMessage(const tipoMsg: TTareaMessageType; const mensaje: string);
var count: integer;
begin
  count := length(FMessages) + 1;
  SetLength(FMessages, count);
  // zero based
  dec(count);
  with FMessages[count] do begin
    fecha := now;
    tipo := tipoMsg;
    msg := mensaje;
  end;
  PostMessage(fHWnd, WM_TAREA_MESSAGE, ID, count);
end;

procedure TTarea.DoPerCent(const percent: integer);
begin
  if lastPercent <> percent then begin
    lastPercent := percent;
    PostMessage(fHWnd, WM_TAREA_PER_CENT, ID, percent);
  end;
end;

procedure TTarea.DoPerCentPos(const position: integer);
begin
  DoPerCent(Round(position / FMaxPosition * 100));
end;

procedure TTarea.Execute;
begin
  inherited;
  NotificarTareaEnd;
end;

function TTarea.GetMessageCount: integer;
begin
  result := length(FMessages);
end;

function TTarea.GetPMessage(const index: integer): PTareaMessage;
begin
  result := @FMessages[index];
end;

procedure TTarea.InternalCancel;
begin
  inherited;
//  NotificarTareaEnd;
end;

procedure TTarea.NotificarTareaEnd;
var m: TMsg;
begin
  while PeekMessage(m, fHWnd, WM_TAREA_PER_CENT, WM_TAREA_END, PM_REMOVE) do;
  SendMessage(fHWnd, WM_TAREA_END, ID, 0);
end;

end.
