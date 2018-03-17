unit dmConsultasMenu;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery, kbmMemTable,
  Contnrs, Windows, dmHandledDataModule, UtilThread, ScriptEditorCodigoDatos,
  dmThreadDataModule;

type
  TConsultasMenuData = class(TThreadDataModule)
    qConsulta: TIBQuery;
    qConsultaOR_FS: TIntegerField;
    qConsultaCODIGO_COMPILED: TMemoField;
    procedure DataModuleCreate(Sender: TObject);
  private
  end;

  TArrayInteger = array of integer;
  PArrayInteger = ^TArrayInteger;

  TConsultaCountThread = class(TProtectedThread)
  private
    FOIDValores: TArrayInteger;
    FItems: TArrayInteger;
    FOIDSesion: Integer;
    FHandle: HWND;
    Script: TScriptEditorCodigoDatos;
    procedure SetOIDValores(const Value: PArrayInteger);
    procedure SetItems(const Value: PArrayInteger);
  protected
    function GetName: string; override;
    procedure InitializeResources; override;
    procedure FreeResources; override;
    procedure InternalCancel; override;
    procedure InternalExecute; override;
  public
    property OIDSesion: Integer write FOIDSesion;
    property OIDValores: PArrayInteger write SetOIDValores;
    property Items: PArrayInteger write SetItems;
    property Handle: HWND write FHandle;
  end;


  TConsultasMenu = class
  private
    consultaThread: TConsultaCountThread;
    HandleNotification: HWND;
    ValoresSesion: TArrayInteger;
    UltimoOIDSesion: integer;
    procedure OnTerminateCalculate(Sender: TObject);
  public
    constructor Create(const HandleNotification: HWND);
    destructor Destroy; override;
    procedure Find(const OIDValores, Items: PArrayInteger);
  end;


implementation

uses dmBD, dmData, fmConsultas, BDConstants, UtilDB,
  uAccionesConsultas, ScriptEngine, IBSQL;

{$R *.dfm}


procedure TConsultasMenuData.DataModuleCreate(Sender: TObject);
begin
  OpenDataSetRecordCount(qConsulta);
end;


{ TConsultaCountThread }

procedure TConsultaCountThread.FreeResources;
begin
  Script.Free;
end;

function TConsultaCountThread.GetName: string;
begin
  result := 'ConsultaCount';
end;

procedure TConsultaCountThread.InitializeResources;
begin
  Script := TScriptEditorCodigoDatos.Create(true);
end;

procedure TConsultaCountThread.InternalExecute;
var i, j, num, numValores, count: integer;
  compiledCode: string;
  Data: TConsultasMenuData;
begin
  try
    Data := TConsultasMenuData.Create(nil);
    try
      Script.ResultType := rtBoolean;
      Script.OutVariableName := OUT_VARIABLE_NAME_BUSQUEDA;
      Script.OIDSesion := FOIDSesion;
      num := Length(FItems) - 1;
      numValores := Length(FOIDValores) - 1;
      for i := 0 to num do begin
        if Terminated then
          raise ETerminateThread.Create;
        // en item.Tag está el OID_CONSULTA
        if Data.qConsulta.Locate('OR_FS', FItems[i], []) then begin
          count := 0;
          compiledCode := Data.qConsultaCODIGO_COMPILED.Value;
          if compiledCode = '' then
            PostMessage(FHandle, WM_MENU_COUNT, FItems[i], 0)
          else begin
            Script.CompiledCode := compiledCode;
            for j := 0 to numValores do begin
              if Terminated then
                raise ETerminateThread.Create;
              Script.OIDValor := FOIDValores[j];
              if Script.Execute then begin
                if Script.ValueBoolean then
                  inc(count);
              end
              else begin
                Script.CompiledCode := compiledCode;
              end;
            end;
            if Terminated then
              raise ETerminateThread.Create;
            PostMessage(FHandle, WM_MENU_COUNT, FItems[i], count);
          end;
        end;
      end;
    finally
      Data.Free;
    end;
  except
    on EStopScript do;
  end;
end;

procedure TConsultaCountThread.InternalCancel;
begin
  inherited;
  Script.Stop;
end;

procedure TConsultaCountThread.SetItems(const Value: PArrayInteger);
begin
  FItems := Copy(Value^, 0, Length(Value^));
end;

procedure TConsultaCountThread.SetOIDValores(const Value: PArrayInteger);
begin
  FOIDValores := Copy(Value^, 0, Length(Value^));
end;

{ TConsultasMenu }

constructor TConsultasMenu.Create(const HandleNotification: HWND);
begin
  inherited Create;
  Self.HandleNotification := HandleNotification;
  UltimoOIDSesion := 0;
end;

destructor TConsultasMenu.Destroy;
begin
  if consultaThread <> nil then begin
    consultaThread.OnTerminate := nil;
    consultaThread.Cancel;
  end;
  inherited;
end;

procedure TConsultasMenu.Find(const OIDValores, Items: PArrayInteger);
var OIDSesion: integer;

  procedure ReloadValoresSesion;
  var i, j, num: integer;
    field: TIBXSQLVAR;
    OIDValor: integer;
    qValoresSesion: TIBSQL;
  begin
    qValoresSesion := TIBSQL.Create(nil);
    try
      qValoresSesion.Database := BD.GetDatabase(scdDatos);
      qValoresSesion.SQL.Text := 'select OR_VALOR from cotizacion ' +
        'where OR_SESION = :OID_SESION and not CIERRE is null';
      qValoresSesion.Params[0].AsInteger := OIDSesion;
      qValoresSesion.ExecQuery;
      num := Length(OIDValores^);
      SetLength(ValoresSesion, num);
      i := 0;
      dec(num);
      field := qValoresSesion.Fields[0];
      while not qValoresSesion.Eof do begin
        OIDValor := field.Value;
        for j := 0 to num do begin
          if OIDValor = OIDValores^[j] then begin
            ValoresSesion[i] := OIDValor;
            Inc(i);
            break;
          end;
        end;
        qValoresSesion.Next;
      end;
      SetLength(ValoresSesion, i);
    finally
      qValoresSesion.Free;
    end;
  end;

  procedure LaunchThread;
  begin
    consultaThread := TConsultaCountThread.Create(true);
    consultaThread.FreeOnTerminate := true;
    consultaThread.OnTerminate := OnTerminateCalculate;
    consultaThread.Handle := HandleNotification;
    consultaThread.OIDValores := @ValoresSesion;
    consultaThread.OIDSesion := Data.OIDSesion;
    consultaThread.Items := Items;
    consultaThread.Resume;
  end;
begin
  OIDSesion := Data.OIDSesion;
  if UltimoOIDSesion <> OIDSesion then
    ReloadValoresSesion;

  if consultaThread = nil then begin
    LaunchThread;
  end
  else begin
    consultaThread.OnTerminate := nil;
    consultaThread.Cancel;
    LaunchThread;
  end;
end;

procedure TConsultasMenu.OnTerminateCalculate(Sender: TObject);
begin
  consultaThread := nil;
end;


end.
