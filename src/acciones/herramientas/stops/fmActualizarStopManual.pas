unit fmActualizarStopManual;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, DBCtrls, DB, StdCtrls, Mask, fmBaseEditar, Buttons;

type
  TfActualizarStopManual = class(TfBaseEditar)
    Label1: TLabel;
    DBEdit1: TDBEdit;
    dsStops: TDataSource;
    Label2: TLabel;
    DBText1: TDBText;
    Label3: TLabel;
    lCambio: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

uses dmStopsManuales;

{$R *.dfm}

procedure TfActualizarStopManual.FormShow(Sender: TObject);
begin
  inherited;
  lCambio.Caption := dsStops.DataSet.FieldByName('CAMBIO').AsString;
  dsStops.DataSet.Edit;
end;

end.
