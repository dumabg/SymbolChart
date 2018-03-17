unit dmFiltroCaidaLibreTecnica;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroCaidaLibreTecnica = class(TFiltro)
  private
    FMinimo: currency;
  protected
    function ValorInFilter: boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetDescripcion: string; override;
  end;


implementation

uses dmFiltros, SCMain;

{$R *.dfm}

{ TFiltroCaidaLibreTecnica }

constructor TFiltroCaidaLibreTecnica.Create(AOwner: TComponent);
begin
  inherited;
  FMinimo := fSCMain.Grafico.GetGrafico.Datos.Minimo;
end;

function TFiltroCaidaLibreTecnica.GetDescripcion: string;
begin
  result := 'Caída libre técnica';
end;

function TFiltroCaidaLibreTecnica.ValorInFilter: boolean;
begin
  result := ValoresCIERRE.Value = FMinimo;
end;

initialization
  RegisterFiltro(TFiltroCaidaLibreTecnica);


end.
