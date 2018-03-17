unit fmPanelEstrategia;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmPanelGrafico, ImgList, TB2Item, SpTBXItem, Menus, ExtCtrls,
  StdCtrls, dataPanelEstrategia, GraficoZoom, fmMensajeEstrategia,
  IncrustedDatosLineLayer, GraficoEstrategia, uToolbarGrafico, GraficoVelas, Tipos;

type
  TfrPanelEstrategia = class(TfrPanelGrafico)
  private
    FCambiosMaximo, FCambiosMinimo: TArrayCurrency;
    PanelEstrategia: TPanelEstrategia;
//    PanelEstrategiaAlcista: TPanelEstrategiaAlcista;
//    PanelEstrategiaBajista: TPanelEstrategiaBajista;
//    GraficoBajistaLayer: TIncrustedDatosLineLayer;
    fMensajeEstrategia: TfMensajeEstrategia;
    Osciladores: TStringList;
//    function getMsgAlcista(const regla: integer; const reglaResult: TReglaResult): string;
//    function getMsgBajista(const regla: integer; const reglaResult: TReglaResult): string;
    procedure Refrescar(const i: integer);
    procedure OnNChanged(const N: currency);
    procedure OnCoeficientesChanged;
    procedure OnOsciladorChanged(const tipo: TTipoGraficoEstrategia;
      const checked: boolean; const tipoA: integer);
    procedure RecalcularOsciladores;
    procedure LoadMaxMin;
  protected
    procedure OnPositionChange; override;
    procedure OnAfterSetData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


implementation

{$R *.dfm}

uses SCMain, GraficoBolsa, UtilDB, DB, DatosGrafico, dmData;


{ TfPanelEstrategia }

constructor TfrPanelEstrategia.Create(AOwner: TComponent);
begin
  inherited;
  Osciladores := TStringList.Create;
  PanelEstrategia := TPanelEstrategia.Create;
  PanelEstrategia.Grafico := Grafico;

  Grafico.ShowPositions := true;
  fMensajeEstrategia := TfMensajeEstrategia.Create(Self);
  fMensajeEstrategia.PanelEstrategia := PanelEstrategia;
  fMensajeEstrategia.GraficoPrincipal := GraficoPrincipal;
  fMensajeEstrategia.OnNChanged := OnNChanged;
  fMensajeEstrategia.OnOsciladorChanged := OnOsciladorChanged;
  fMensajeEstrategia.OnCoeficientesChanged := OnCoeficientesChanged;
  fMensajeEstrategia.Show;

  Height := 1;
end;

destructor TfrPanelEstrategia.Destroy;
var tipo: TTipoGraficoEstrategia;
  i: integer;
  oscilador: TGraficoEstrategia;
begin
  for I := 0 to Osciladores.Count - 1 do begin
    oscilador := TGraficoEstrategia(Osciladores.Objects[i]);
    fSCMain.ToolBarOsciladores.QuitarBoton(TBotonItem(oscilador.Item));
  end;
  Osciladores.Free;
  PanelEstrategia.Free;
//  PanelEstrategiaAlcista.Free;
//  PanelEstrategiaBajista.Free;
  inherited;
end;


procedure TfrPanelEstrategia.OnAfterSetData;
var datos: TDatosGrafico;
begin
  inherited;
  fMensajeEstrategia.ValorCambiado;
  LoadMaxMin;
  datos := fSCMain.Grafico.GetGrafico.Datos;
  PanelEstrategia.LoadData(datos.PCambios, @FCambiosMaximo, @FCambiosMinimo, datos.PFechas);
  RecalcularOsciladores;
end;

procedure TfrPanelEstrategia.OnCoeficientesChanged;
var posicion: integer;
begin
  posicion := PositionLayer.Position;
  OnAfterSetData;
  PositionLayer.Position := posicion;
end;

procedure TfrPanelEstrategia.OnNChanged(const N: currency);
var posicion: integer;
begin
  posicion := PositionLayer.Position;
  PanelEstrategia.N := N;
  PositionLayer.Position := posicion;
  RecalcularOsciladores;
end;

procedure TfrPanelEstrategia.OnOsciladorChanged(const tipo: TTipoGraficoEstrategia;
  const checked: boolean; const tipoA: integer);
var GraficoEstrategia: TGraficoEstrategia;
  item: TBotonItem;
  titulo: string;
  i: Integer;
begin
  case tipo of
    tgeLAL: titulo := 'LAL';
    tgeLAC: titulo := 'LAC';
    tgeA11: titulo := 'A11';
    tgePRUA: titulo := 'PRUA';
    tgeA: titulo := 'A' + IntToStr(tipoA);
  end;
  if checked then begin
    item := TBotonItem.Create(Self);
    item.OID := Integer(tipo);
    item.Titulo := titulo;
    GraficoEstrategia := TGraficoEstrategia.Create(GraficoPrincipal, item, PanelEstrategia, tipo, tipoA);
    fSCMain.ToolBarOsciladores.AnadirGrafico(item, GraficoEstrategia, clWhite);
    Osciladores.AddObject(titulo, GraficoEstrategia);
  end
  else begin
    i := Osciladores.IndexOf(titulo);
    if i <> -1 then begin
      fSCMain.ToolBarOsciladores.QuitarBoton(TBotonItem(TGraficoEstrategia(Osciladores.Objects[i]).Item));
      Osciladores.Delete(i);
    end;
  end;
end;

procedure TfrPanelEstrategia.OnPositionChange;
begin
  inherited;
  Refrescar(PositionLayer.Position);
end;

procedure TfrPanelEstrategia.RecalcularOsciladores;
var i: Integer;
  graficoEstrategia: TGraficoEstrategia;
begin
  for i := 0 to Osciladores.Count - 1 do begin
    graficoEstrategia := TGraficoEstrategia(Osciladores.Objects[i]);
    graficoEstrategia.Run;
  end;
end;

procedure TfrPanelEstrategia.Refrescar(const i: integer);
var regla: currency;
  reglaResult: TReglaResult;
begin
  regla := Grafico.Datos.Cambio[i];
  reglaResult := PanelEstrategia.ReglaResult[i];
  fMensajeEstrategia.SetData(GraficoPrincipal.Datos.PCambios, @FCambiosMaximo, @FCambiosMinimo, i,
    reglaResult);
  fMensajeEstrategia.N := reglaResult.NCalculado;
end;


procedure TfrPanelEstrategia.LoadMaxMin;
const CAMBIOS_MINIMOS : integer = 640;
var i, j, num: integer;
  DataSet: TDataSet;
  inspect: TInspectDataSet;
  FieldMaximo, FieldMinimo: TNumericField;
begin
  FieldMaximo := Data.CotizacionMAXIMO;
  FieldMinimo := Data.CotizacionMINIMO;
  DataSet := FieldMaximo.DataSet;
  inspect := StartInspectDataSet(DataSet);
  try
    DataSet.Last;
    num := DataSet.RecordCount;
    j := 0;
    if num < CAMBIOS_MINIMOS then begin
      SetLength(FCambiosMaximo, CAMBIOS_MINIMOS);
      SetLength(FCambiosMinimo, CAMBIOS_MINIMOS);
      j := CAMBIOS_MINIMOS - num - 1;
      for i := 0 to j do begin
        FCambiosMaximo[i] := SIN_CAMBIO;
        FCambiosMinimo[i] := SIN_CAMBIO;
      end;
      num := CAMBIOS_MINIMOS;
      inc(j);
    end
    else begin
      SetLength(FCambiosMaximo, num);
      SetLength(FCambiosMinimo, num);
    end;
    dec(num);
    for i := j to num do begin
      FCambiosMaximo[i] := FieldMaximo.AsCurrency;
      FCambiosMinimo[i] := FieldMinimo.AsCurrency;
      DataSet.Prior;
    end;
  finally
    EndInspectDataSet(inspect);
  end;
end;


end.
