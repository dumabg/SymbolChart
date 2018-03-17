unit fmEstudios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, JvExDBGrids, JvDBGrid, JvDBUltimGrid,
  ActnList, dmEstudios, JvExControls,
  JvAnimatedImage, JvGIFCtrl, ExtCtrls, StdCtrls, ComCtrls, JvExComCtrls,
  JvComCtrls, frCuentaBase, Buttons, JvExExtCtrls, JvNetscapeSplitter,
  frEstudioCuenta, fmBase, AppEvnts,
  fmBaseMasterDetalle, DBActns, Menus, TB2Item, SpTBXItem, TB2Dock, TB2Toolbar,
  fmEditFS, frFS, frEditFS, dmTareas, VirtualTrees;

type
  TfEstudios = class(TfEditableFS)
    pCargando: TPanel;
    lMensaje: TLabel;
    ProgressBar: TProgressBar;
    sbCancelar: TSpeedButton;
    fEstudioCuenta: TfEstudioCuenta;
    procedure FormCreate(Sender: TObject);
    procedure sbCancelarClick(Sender: TObject);
    procedure fEstudioCuentaCargarExecute(Sender: TObject);
    procedure fEstudioCuentaDescargarExecute(Sender: TObject);
    procedure gMasterEnter(Sender: TObject);
    procedure fFSBorrarFicheroExecute(Sender: TObject);
    procedure fFSTreeFSStructureChange(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Reason: TChangeReason);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    Estudios: TEstudios;
    function OnEstudioNuevo(var nombre: string; var data: Pointer;
      const caption: string; const max: integer): boolean;
    procedure OnPerCentNotify(const Sender: TTarea; const percent: integer);
    procedure OnEstudioCreated(const OID: integer);
    procedure OnEstudioCanceled(const OID: integer);
  protected
    procedure LoadFile(const OIDFile: integer); override;
  public
    function EstaCalculando: boolean;
  end;

implementation

uses dmRecursosListas, fmEstudioNuevo, dmEstudio, uAcciones, uAccionesValor;

{$R *.dfm}

resourcestring
  CALCULANDO = 'Calculando';
  CANCELANDO = 'Cancelando';
  ESTUDIO_CANCELADO = 'Estudio cancelado';
  CREADO_ESTUDIO_TITULO = 'Estudios';
  CREADO_ESTUDIO_MSG = 'Ha finalizado la creación del estudio %s';

  TITULO_ESTUDIO_NUEVO = 'Estudio nuevo';
  TITULO_BORRAR_ESTUDIO = 'Borrar estudio';
  MSG_BORRAR_ESTUDIO = '¿Está seguro de borrar el estudio %s?';


procedure TfEstudios.fEstudioCuentaCargarExecute(Sender: TObject);
begin
  inherited;
  fEstudioCuenta.Cuenta := Estudios.Cuenta;
  fEstudioCuenta.MostrarFechaHora := false;
  fEstudioCuenta.sbCargar.Action := fEstudioCuenta.Descargar;
end;

procedure TfEstudios.fEstudioCuentaDescargarExecute(Sender: TObject);
begin
  inherited;
  fEstudioCuenta.Cuenta := nil;
  fEstudioCuenta.sbCargar.Action := fEstudioCuenta.Cargar;
end;

procedure TfEstudios.fFSBorrarFicheroExecute(Sender: TObject);
begin
  inherited;
  fFS.BorrarFicheroExecute(Sender);
  pDetalle.Visible := fFS.EditFS.Count > 0;
end;

procedure TfEstudios.fFSTreeFSStructureChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Reason: TChangeReason);
begin
  inherited;
  pDetalle.Visible := fFS.EditFS.Count > 0;
end;

procedure TfEstudios.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  CanClose := pCargando.Visible = false;
end;

procedure TfEstudios.FormCreate(Sender: TObject);
begin
  inherited;
  Estudios := TEstudios.Create(Self);
  fFS.EditFS := Estudios;
  fFS.NuevoFSDialog := OnEstudioNuevo;
  fFS.TituloFicheroNuevo := TITULO_ESTUDIO_NUEVO;
  fFS.TituloBorrarFichero := TITULO_BORRAR_ESTUDIO;
  fFS.MsgBorrarFichero := MSG_BORRAR_ESTUDIO;
  pCargando.Visible := false;
  fEstudioCuenta.Visible := false;
//  AddCaptionButtons(Self, [cbAlwaysOnTop, cbMaximize]);
end;

procedure TfEstudios.gMasterEnter(Sender: TObject);
begin
  inherited;
  fEstudioCuenta.Visible := true;
end;

procedure TfEstudios.LoadFile(const OIDFile: integer);
begin
  fEstudioCuentaDescargarExecute(nil);
  Estudios.LoadEstudio(OIDFile);
  fEstudioCuenta.Visible := pCargando.Visible = false;
end;

function TfEstudios.EstaCalculando: boolean;
begin
 result := Estudios.EstaCalculando;
end;

procedure TfEstudios.OnEstudioCanceled(const OID: integer);
begin
  fFS.BorrarFocusedNode(false);
  fFS.Enabled := true;
  pCargando.Visible := false;
  pDetalle.Visible := fFS.EditFS.Count > 0;
  ShowMessage(ESTUDIO_CANCELADO);
end;

procedure TfEstudios.OnEstudioCreated(const OID: integer);
begin
  fFS.Enabled := true;
  pCargando.Visible := false;
  LoadFile(OID);
  fEstudioCuenta.Visible := true;
end;

function TfEstudios.OnEstudioNuevo(var nombre: string; var data: Pointer;
  const caption: string; const max: integer): boolean;
var EstudioNuevo: TfEstudioNuevo;
  pEstudioParams: PTEstudioParams;
begin
  EstudioNuevo := TfEstudioNuevo.Create(nil);
  try
    if EstudioNuevo.ShowModal = mrOk then begin
      fFS.Enabled := false;
      nombre := EstudioNuevo.Nombre;
      New(pEstudioParams);
      pEstudioParams^.Capital := EstudioNuevo.Capital;
      pEstudioParams^.Descripcion := EstudioNuevo.Descripcion;
      pEstudioParams^.Desde := EstudioNuevo.Desde;
      pEstudioParams^.Hasta := EstudioNuevo.Hasta;
      pEstudioParams^.OIDEstrategia := EstudioNuevo.OIDEstrategia;
      pEstudioParams^.Paquetes := EstudioNuevo.Paquetes;
      pEstudioParams^.Usa100 := EstudioNuevo.USA100;
      pEstudioParams^.Grupo := TAccionesValor(GetAcciones(TAccionesValor)).MenuGrupos.Caption;
      pEstudioParams^.Nombre := nombre;
      pEstudioParams^.OIDMoneda := EstudioNuevo.OIDMoneda;
      pEstudioParams^.OIDBroker := EstudioNuevo.OIDBroker;
      pEstudioParams^.OnPerCent := OnPerCentNotify;
      pEstudioParams^.OnEstudioCreated := OnEstudioCreated;
      pEstudioParams^.OnEstudioCanceled := OnEstudioCanceled;
      data := pEstudioParams;

      pDetalle.Visible := true; //Si es el primer estudio, el pDetalle estará
      sbCancelar.Enabled := true;
      lMensaje.Caption := CALCULANDO;
      pCargando.Visible := true;
      ProgressBar.Max := 100;
      ProgressBar.Position := 0;
      ProgressBar.Visible := true;
      sbCancelar.Visible := true;
      fEstudioCuenta.Visible := false;

      result := true;
    end
    else
      result := false;
  finally
    EstudioNuevo.Free;
  end;
end;

procedure TfEstudios.OnPerCentNotify(const Sender: TTarea;
  const percent: integer);
begin
  ProgressBar.Position := percent;
end;

procedure TfEstudios.sbCancelarClick(Sender: TObject);
begin
  inherited;
  sbCancelar.Enabled := false;
  lMensaje.Caption := CANCELANDO;
  Estudios.Cancelar;
end;

end.
