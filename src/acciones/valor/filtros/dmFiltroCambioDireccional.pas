unit dmFiltroCambioDireccional;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmFiltro, DB,  kbmMemTable;

type
  TFiltroCambioDireccional = class(TFiltro)
    ValoresFiltradosCAMBIO_DIRECCIONAL: TCurrencyField;
    procedure ValoresFiltradosBeforePost(DataSet: TDataSet);
  private
    CambioDireccional: currency;
  protected
    function ValorInFilter: boolean; override;
  public
    function GetDescripcion: string; override;    
  end;

implementation

{$R *.dfm}

uses dmFiltros;

{ TFiltroCambioDireccional }

function TFiltroCambioDireccional.ValorInFilter: boolean;
begin
  // Volatilitat / Variabilidad >= 2.
  //S'ha de mostrar el resultat de la divisió.
  CambioDireccional := ValoresVOLATILIDAD.Value / ValoresVARIABILIDAD.Value;
  result := CambioDireccional >=2;
end;

procedure TFiltroCambioDireccional.ValoresFiltradosBeforePost(
  DataSet: TDataSet);
begin
  inherited;
  ValoresFiltradosCAMBIO_DIRECCIONAL.Value := CambioDireccional;
end;

function TFiltroCambioDireccional.GetDescripcion: string;
begin
  result := 'Cambio direccional';
end;

initialization
  RegisterFiltro(TFiltroCambioDireccional);
finalization
end.
