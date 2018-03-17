unit fmEstadoCuenta;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, DB, dmEstadoCuenta, StdCtrls, ExtCtrls, DBCtrls,
  Series, dmLoginServer, DbChart, Buttons,
  ActnMan, ActnList, ImgList, fmBase, JvDBUltimGrid,
  XPStyleActnCtrls, Grids, DBGrids, JvExDBGrids, JvDBGrid, TeEngine, TeeProcs,
  Chart;

type
  TfEstadoCuenta = class(TfBase)
    dsCuenta: TDataSource;
    DBChart1: TDBChart;
    Series1: TBarSeries;
    Historico: TJvDBUltimGrid;
    Panel2: TPanel;
    PanelInferior: TPanel;
    Label1: TLabel;
    Panel3: TPanel;
    lSaldo: TLabel;
    ActionManager: TActionManager;
    ImageList: TImageList;
    Exportar: TAction;
    SpeedButton1: TSpeedButton;
    SaveDialog: TSaveDialog;
    Label2: TLabel;
    lCaducidad: TLabel;
    Label3: TLabel;
    lDias: TLabel;
    urlAdquirir: TLabel;
    procedure FormShow(Sender: TObject);
    procedure HistoricoGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure ExportarExecute(Sender: TObject);
    procedure urlAdquirirClick(Sender: TObject);
  private
    cuenta: TEstadoCuenta;
    usuario: string;
  public
    constructor Create(AOwner: TComponent; URLServidor: string; LoginState: TLoginState;
      const usuario: string); reintroduce;
    procedure Conectar;
  end;

implementation

{$R *.dfm}

uses DateUtils, Web, dmConfiguracion, ServerURLs;

procedure TfEstadoCuenta.FormShow(Sender: TObject);
begin
  Caption := Caption + DateTimeToStr(now);
end;

constructor TfEstadoCuenta.Create(AOwner: TComponent; URLServidor: string;
  LoginState: TLoginState; const usuario: string);
begin
  inherited Create(AOwner);
  cuenta := TEstadoCuenta.Create(Self);
  cuenta.AssignLoginState(LoginState);
  Self.usuario := usuario;
end;

procedure TfEstadoCuenta.ExportarExecute(Sender: TObject);
begin
  inherited;
  if SaveDialog.Execute then
    cuenta.Exportar(SaveDialog.FileName);
end;

procedure TfEstadoCuenta.HistoricoGetCellParams(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; Highlight: Boolean);
begin
  if cuenta.TransaccionIMPORTE.Value < 0 then
    Background := RGB(121, 0, 0)
  else
    Background := clGreen;
end;

procedure TfEstadoCuenta.urlAdquirirClick(Sender: TObject);
begin
  inherited;
  AbrirURL(Configuracion.Sistema.URLServidor + URL_RECARGAR + '?user=' + usuario);
end;

procedure TfEstadoCuenta.Conectar;
var ahora, caducidad: TDate;
  dias, saldo: integer;
begin
  cuenta.Conectar;
  caducidad := cuenta.Caducidad;
  lCaducidad.Caption := DateToStr(caducidad);
  ahora := now;
  if ahora > caducidad then begin
    dias := 0;
    saldo := 0;
  end
  else begin
    dias := DaysBetween(ahora, caducidad);
    saldo := cuenta.Saldo;
  end;

  lDias.Caption := IntToStr(dias);
  if dias < 10 then begin
    lCaducidad.Font.Color := clRed;
    lDias.Font.Color := clRed;
  end
  else begin
    lCaducidad.Font.Color := clGreen;
    lDias.Font.Color := clGreen;
  end;

  lSaldo.Caption := IntToStr(saldo);
  if saldo < 10 then
    lSaldo.Color := clRed
  else
    lSaldo.Color := clGreen;
end;

end.
