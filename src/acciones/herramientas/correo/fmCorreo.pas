unit fmCorreo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, DB, dmCorreo, ExtCtrls, JvExExtCtrls, JvNetscapeSplitter,
  Htmlview, Grids, DBGrids, JvExDBGrids, JvDBGrid, JvDBUltimGrid,
  ActnList, ImgList, TB2Item, SpTBXItem, TB2Dock, TB2Toolbar;

type
  TfCorreo = class(TfBase)
    gMensajes: TJvDBUltimGrid;
    MensajeViewer: THTMLViewer;
    Splitter: TJvNetscapeSplitter;
    dsCorreo: TDataSource;
    TBXToolbar1: TSpTBXToolbar;
    ActionList: TActionList;
    ImageList: TImageList;
    Obtener: TAction;
    Borrar: TAction;
    TBXItem1: TSpTBXItem;
    TBXItem2: TSpTBXItem;
    TBXSeparatorItem1: TSpTBXSeparatorItem;
    procedure FormCreate(Sender: TObject);
    procedure ObtenerExecute(Sender: TObject);
    procedure BorrarExecute(Sender: TObject);
    procedure BorrarUpdate(Sender: TObject);
    procedure MensajeViewerHotSpotClick(Sender: TObject; const SRC: string;
      var Handled: Boolean);
  private
    Correo: TCorreo;
    procedure OnCorreoAfterScroll(DataSet: TDataSet);
  public
  end;

implementation

uses Web;


{$R *.dfm}

resourcestring
  ERROR_CORREO = 'No se ha podido comprobar el correo. Inténtelo más tarde.';
  NO_HAY_CORREO_NUEVO = 'No hay ningún correo nuevo.';

{ TfCorreo }

procedure TfCorreo.BorrarExecute(Sender: TObject);
begin
  inherited;
  Correo.Borrar;
end;

procedure TfCorreo.BorrarUpdate(Sender: TObject);
begin
  inherited;
  Borrar.Enabled := Correo.HayCorreo;
end;

procedure TfCorreo.FormCreate(Sender: TObject);
begin
  inherited;
  Correo := TCorreo.Create(Self);
  Correo.qCorreo.AfterScroll := OnCorreoAfterScroll;
  OnCorreoAfterScroll(nil);
end;

procedure TfCorreo.MensajeViewerHotSpotClick(Sender: TObject; const SRC: string;
  var Handled: Boolean);
begin
  inherited;
  AbrirURL(src);
  Handled := true;
end;

procedure TfCorreo.ObtenerExecute(Sender: TObject);
var hayNuevosMsg: boolean;
begin
  inherited;
  Obtener.Enabled := false;
  try
    if Correo.Obtener(hayNuevosMsg) then begin
      if not hayNuevosMsg then
        ShowMessage(NO_HAY_CORREO_NUEVO);
    end
    else
      ShowMessage(ERROR_CORREO);
  finally
    Obtener.Enabled := true;
  end;
end;

procedure TfCorreo.OnCorreoAfterScroll(DataSet: TDataSet);
var s: TStringList;
begin
  s := TStringList.Create;
  try
    s.Add(Correo.qCorreoMENSAJE.Value);
    MensajeViewer.LoadStrings(s, '');
  finally
    s.Free;
  end;
end;

end.
