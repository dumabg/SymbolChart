unit fmBaseNuevo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, StdCtrls, Buttons, ExtCtrls, AppEvnts;

type
  TfBaseNuevo = class(TfBase)
    bCrear: TBitBtn;
    bCancelar: TBitBtn;
    eNombre: TEdit;
    Label1: TLabel;
    Bevel2: TBevel;
    procedure eNombreKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    procedure SetMax(const Value: integer);
    procedure SetNombre(const Value: string);
  protected
    function GetNombre: string;
    function CheckEnableCrearButton: boolean; virtual;
  public
    property Nombre: string read GetNombre write SetNombre;
    property Max: integer write SetMax;
  end;

  function MostrarNuevo(var nombre: string; const caption: string; const max: integer): boolean;

implementation

{$R *.dfm}

  function MostrarNuevo(var nombre: string; const caption: string; const max: integer): boolean;
  var fNuevo: TfBaseNuevo;
  begin
    fNuevo := TfBaseNuevo.Create(nil);
    try
      fNuevo.Caption := caption;
      fNuevo.Max := max;
      result := fNuevo.ShowModal = mrOk;
      nombre := fNuevo.Nombre;
    finally
      fNuevo.Free;
    end;
  end;

{ TfTipoEstudioNuevo }

function TfBaseNuevo.CheckEnableCrearButton: boolean;
begin
  result := Trim(eNombre.Text) <> '';
end;

procedure TfBaseNuevo.eNombreKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  bCrear.Enabled := CheckEnableCrearButton;
end;

procedure TfBaseNuevo.FormShow(Sender: TObject);
begin
  inherited;
  bCrear.Enabled := CheckEnableCrearButton;
end;

function TfBaseNuevo.GetNombre: string;
begin
  result := Trim(eNombre.Text);
end;

procedure TfBaseNuevo.SetMax(const Value: integer);
begin
  eNombre.MaxLength := Value;
end;

procedure TfBaseNuevo.SetNombre(const Value: string);
begin
  eNombre.Text := Value;
end;

end.
