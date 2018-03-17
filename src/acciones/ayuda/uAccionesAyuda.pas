unit uAccionesAyuda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uAcciones, ActnList, ImgList, JvBaseDlg, 
  TB2Item, SpTBXItem, TB2Dock, TB2Toolbar;

type
  TAccionesAyuda = class(TAcciones)
    AcercaDe: TAction;
    Web: TAction;
    WebAyuda: TAction;
    WebForo: TAction;
    Recordatorio: TAction;
    TBXSubmenuItem1: TSpTBXSubmenuItem;
    TBXItem55: TSpTBXItem;
    TBXItem56: TSpTBXItem;
    TBXSeparatorItem19: TSpTBXSeparatorItem;
    TBXItem8: TSpTBXItem;
    TBXSeparatorItem17: TSpTBXSeparatorItem;
    TBXItem46: TSpTBXItem;
    TBXSeparatorItem11: TSpTBXSeparatorItem;
    TBXItem57: TSpTBXItem;
    procedure AcercaDeExecute(Sender: TObject);
    procedure WebExecute(Sender: TObject);
    procedure WebAyudaExecute(Sender: TObject);
    procedure WebForoExecute(Sender: TObject);
    procedure RecordatorioExecute(Sender: TObject);
  private
  protected
  public
    function GetBarras: TBarras; override;
  end;

implementation

{$R *.dfm}

uses UtilForms, fmAcercaDe, Web, dmConfiguracion, ServerURLs, uAccionesHerramientas,
  dmTipOfDay;

procedure TAccionesAyuda.AcercaDeExecute(Sender: TObject);
begin
  ShowFormModal(TfAcercaDe);
end;

function TAccionesAyuda.GetBarras: TBarras;
begin
  SetLength(result, 0);
end;

procedure TAccionesAyuda.RecordatorioExecute(Sender: TObject);
var tip: TTipOfDay;
begin
  tip := TTipOfDay.Create(nil);
  try
    tip.JvTipOfDay.Execute;
  finally
    tip.Free;
  end;
end;

procedure TAccionesAyuda.WebExecute(Sender: TObject);
begin
  AbrirURL(Configuracion.Sistema.URLServidor);
end;

procedure TAccionesAyuda.WebForoExecute(Sender: TObject);
begin
  AbrirURL(Configuracion.Sistema.URLServidor + URL_FORO);
end;

procedure TAccionesAyuda.WebAyudaExecute(Sender: TObject);
begin
  AbrirURL(Configuracion.Sistema.URLServidor + URL_AYUDA);
end;

initialization
  RegisterAccionesAfter(TAccionesAyuda, TAccionesHerramientas);

end.
