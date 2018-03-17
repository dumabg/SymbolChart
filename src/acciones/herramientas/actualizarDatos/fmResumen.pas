unit fmResumen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBaseServer, ActnList, StdCtrls, Buttons, 
  ExtCtrls, Grids, DBGrids, JvExDBGrids, JvDBGrid,
  JvDBUltimGrid, DB;

type
  TfResumen = class(TfBaseServer)
    Hecho: TBitBtn;
    JvDBUltimGrid1: TJvDBUltimGrid;
    dsOperaciones: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses dmActualizarDatos;

{$R *.dfm}

end.
