unit frValorAnalisis;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, flags, ExtCtrls, StdCtrls;

type
  TValorAnalisis = class(TFrame)
    lValor: TLabel;
    iEstado: TImage;
    procedure lValorClick(Sender: TObject);
  private
    iCorto, iLargo: TImage;
    FFlags: TFlags;
    FOIDValor: integer;
    procedure SetFlags(const Value: TFlags);
    procedure SetOIDValor(const Value: integer);
  public
    constructor Create(const AOwner: TComponent; const iCorto, iLargo: TImage); reintroduce;
    property OIDValor: integer read FOIDValor write SetOIDValor;
    property Flags: TFlags write SetFlags;
  end;

implementation

uses dmData, dmDataComun;

{$R *.dfm}

{ TValorAnalisis }

constructor TValorAnalisis.Create(const AOwner: TComponent; const iCorto, iLargo: TImage);
begin
  inherited Create(AOwner);
  Self.iCorto := iCorto;
  Self.iLargo := iLargo;
end;

procedure TValorAnalisis.lValorClick(Sender: TObject);
begin
  if Sender <> nil then begin
    Screen.Cursor := crHourGlass;
    try
      Data.IrAValor(FOIDValor);
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TValorAnalisis.SetFlags(const Value: TFlags);
begin
  if FFlags = Value then
    exit
  else
    FFlags := Value;

  if FFlags.Es(cMantener) then begin
    lValor.Font.Color := clGreen;
    lValor.Font.Style := [];
    iEstado.Canvas.FillRect(Rect(0, 0, iEstado.Width, iEstado.Height));
  end
  else
    iEstado.Canvas.FillRect(Rect(0, 0, iEstado.Width, iEstado.Height));
    if FFlags.Es(cAdvertencia) then begin
      lValor.Font.Color := clRed;
      lValor.Font.Style := [];
    end
    else
      if FFlags.Es(cInicioCiclo) then begin
        lValor.Font.Color := clGreen;
        lValor.Font.Style := [fsBold];
        iEstado.Canvas.Draw(0, 0, iLargo.Picture.Graphic);
      end
      else
      if FFlags.Es(cPrimeraAdvertencia) then begin
        lValor.Font.Color := clRed;
        lValor.Font.Style := [fsBold];
        iEstado.Canvas.Draw(0, 0, iCorto.Picture.Graphic);
      end
      else
        if FFlags.Es(cInicioCicloVirtual) then begin
          lValor.Font.Color := clGreen;
          lValor.Font.Style := [];
          iEstado.Canvas.Draw(0, 0, iLargo.Picture.Graphic);
        end
        else
          if FFlags.Es(cPrimeraAdvertenciaVirtual) then begin
            lValor.Font.Color := clRed;
            lValor.Font.Style := [];
            iEstado.Canvas.Draw(0, 0, iCorto.Picture.Graphic);
          end;
end;

procedure TValorAnalisis.SetOIDValor(const Value: integer);
var valor: PDataComunValor;
begin
  if FOIDValor <> Value then begin
    FOIDValor := Value;
    valor := DataComun.FindValor(FOIDValor);
    lValor.Caption := valor^.Simbolo  + ' - ' + valor^.Nombre;
  end;
end;

end.
