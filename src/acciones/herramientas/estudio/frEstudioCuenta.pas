unit frEstudioCuenta;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frCuentaBase, DB, StdCtrls, ExtCtrls, TeEngine, Series, TeeProcs,
  Chart, JvExExtCtrls, JvNetscapeSplitter, Grids, DBGrids, JvExDBGrids,
  JvDBGrid, JvDBUltimGrid, ComCtrls, DBCtrls, Mask, Buttons, ActnList, ImgList,
  dmCuentaBase, SpTBXItem, TB2Item, TB2Dock, TB2Toolbar;

type
  TfEstudioCuenta = class(TfCuentaBase)
    tsCaracteristicas: TTabSheet;
    Label1: TLabel;
    dbeNombre: TDBEdit;
    dsEstudio: TDataSource;
    Label2: TLabel;
    dbeDescripcion: TDBMemo;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    dbtDesde: TDBText;
    dbtHasta: TDBText;
    dbtCapital: TDBText;
    dbtPaquetes: TDBText;
    Label7: TLabel;
    Label17: TLabel;
    dbtNombreTipo: TDBText;
    Label18: TLabel;
    dbtDescripcionTipo: TDBMemo;
    sbCargar: TSpeedButton;
    ActionList: TActionList;
    ImageList: TImageList;
    Cargar: TAction;
    Bevel1: TBevel;
    dbcUSA100: TDBCheckBox;
    Label19: TLabel;
    dbtGrupo: TDBText;
    Descargar: TAction;
    tsMensajes: TTabSheet;
    JvDBUltimGrid1: TJvDBUltimGrid;
    dsMensajes: TDataSource;
  private
  protected
    procedure SetCuenta(const Value: TCuentaBase); override;
  public
  end;

implementation

uses dmEstudios;

{$R *.dfm}

{ TfEstudioCuenta }

procedure TfEstudioCuenta.SetCuenta(const Value: TCuentaBase);
begin
  if Value = nil then begin
    sbCargar.Action := Cargar;
    tsMensajes.TabVisible := false;
  end
  else begin
    sbCargar.Action := Descargar;
    tsMensajes.TabVisible := not dsMensajes.DataSet.IsEmpty;
  end;
  inherited SetCuenta(Value);
end;

end.
