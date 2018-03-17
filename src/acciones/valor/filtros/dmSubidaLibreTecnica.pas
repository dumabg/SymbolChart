unit dmSubidaLibreTecnica;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroSubidaLibreTecnica = class(TFiltro)
  private
    FMaximo: currency;
  protected
    function ValorInFilter: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetDescripcion: string; override;
  end;


implementation

{$R *.dfm}

uses dmFiltros, SCMain;

{ TFiltroSubidaLibreTecnica }

constructor TFiltroSubidaLibreTecnica.Create(AOwner: TComponent);
begin
  inherited;
  FMaximo := fSCMain.Grafico.GetGrafico.Datos.Maximo;
end;

function TFiltroSubidaLibreTecnica.GetDescripcion: string;
begin
  result := 'Subida libre técnica';
end;

function TFiltroSubidaLibreTecnica.ValorInFilter: boolean;
begin
  result := ValoresCIERRE.Value = FMaximo;
end;

initialization
  RegisterFiltro(TFiltroSubidaLibreTecnica);


end.
