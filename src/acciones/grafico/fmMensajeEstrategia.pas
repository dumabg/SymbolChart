unit fmMensajeEstrategia;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Tipos, ExtCtrls, GraficoLineas, Spin, ComCtrls,
  GraficoEstrategia, dataPanelEstrategia, Grafico, uEstrategia, JvExComCtrls,
  JvProgressBar, Menus;

type
  TOnNChanged = procedure(const n: currency) of object;
  TOnCoeficientesChanged = procedure of object;
  TOnOsciladorChanged = procedure(const tipo: TTipoGraficoEstrategia;
    const checked: boolean; const tipoA: integer = -1) of object;

  TGrafico2 = class(TGraficoLineas)
  private
    Fechas: TArrayDate;
  protected
    procedure PaintX(const iFrom, iTo: integer); override;
    procedure CalculateAltoEjeX; override;
    procedure SetData(const PCambios: PArrayCurrency); reintroduce;
  end;

  TfMensajeEstrategia = class(TForm)
    gData: TStringGrid;
    pGrafico: TPanel;
    lL: TLabel;
    pcVista: TPageControl;
    tsResumen: TTabSheet;
    sgResumen: TStringGrid;
    tsOsciladores: TTabSheet;
    cbLAL: TCheckBox;
    cbLAC: TCheckBox;
    cbA11: TCheckBox;
    lMensaje: TLabel;
    lSugerencia: TLabel;
    tsAnalisis: TTabSheet;
    Panel1: TPanel;
    bCalcular: TButton;
    sgPosiciones: TStringGrid;
    pTodo: TPanel;
    pResumen: TPanel;
    pIndicadores: TPanel;
    bTodo: TButton;
    lNumGanadoras: TLabel;
    lNumPerdedoras: TLabel;
    sgResumen2: TStringGrid;
    pGrids: TPanel;
    pmResumen: TPopupMenu;
    pmResumen2: TPopupMenu;
    eEA: TLabeledEdit;
    eEB: TLabeledEdit;
    eEXA: TLabeledEdit;
    eEXB: TLabeledEdit;
    eEIA: TLabeledEdit;
    eEIB: TLabeledEdit;
    bAplicar: TButton;
    sgLx: TStringGrid;
    cbPRUA: TCheckBox;
    bCalcularInversa: TButton;
    eEZ: TLabeledEdit;
    eEXZ: TLabeledEdit;
    eEIZ: TLabeledEdit;
    cbAuto: TCheckBox;
    cbAlcista: TCheckBox;
    eLIM: TLabeledEdit;
    cbEstrategiaNormal: TCheckBox;
    cbA1: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
    CheckBox18: TCheckBox;
    CheckBox19: TCheckBox;
    CheckBox20: TCheckBox;
    cbLDA: TCheckBox;
    cbLDB: TCheckBox;
    cbLDZ: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure gDataDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure bCalcularNClick(Sender: TObject);
    procedure sgResumenDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure cbLALClick(Sender: TObject);
    procedure cbLACClick(Sender: TObject);
    procedure cbA11Click(Sender: TObject);
    procedure bTodoClick(Sender: TObject);
    procedure bCalcularClick(Sender: TObject);
    procedure sgPosicionesDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgPosicionesSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure pcVistaChanging(Sender: TObject; var AllowChange: Boolean);
    procedure pcVistaChange(Sender: TObject);
    procedure sgResumen2DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure bAplicarClick(Sender: TObject);
    procedure cbPRUAClick(Sender: TObject);
    procedure cbAClick(Sender: TObject);
  private
    K: TArrayCurrency;
    FGrafico: TGrafico2;
    maximo, minimo: currency;
    iLAL, iLBL, iLAC, iLBC, iLZL, iLZC: integer;
    K12, K11: Currency;
    FOnNChanged: TOnNChanged;
    FOnOsciladorChanged: TOnOsciladorChanged;
    FGraficoPrincipal: TGrafico;
    FPanelEstrategia: TPanelEstrategia;
    FOnCoeficientesChanged: TOnCoeficientesChanged;
    calcularRentabilidad: boolean;
    procedure Rentabilidad(const normal, alcista, inversa: boolean);
    procedure Sort(var A: TArrayCurrency);
    function getSigno(const c1, c2: currency): string;
    procedure SetN(const Value: currency);
    procedure OnMenuItemResumenClick(Sender: TObject);
    procedure OnMenuItemResumen2Click(Sender: TObject);
    function CurrToStrRound(number: currency): string;
  public
    procedure SetData(const PCambios, PMaximos, PMinimos: PArrayCurrency; const i: integer;
      const resultado: TReglaResult);
    procedure ValorCambiado;
    property GraficoPrincipal: TGrafico read FGraficoPrincipal write FGraficoPrincipal;
    property Grafico: TGrafico2 read FGrafico;
    property OnNChanged: TOnNChanged read FOnNChanged write FOnNChanged;
    property OnOsciladorChanged: TOnOsciladorChanged read FOnOsciladorChanged write FOnOsciladorChanged;
    property OnCoeficientesChanged: TOnCoeficientesChanged read FOnCoeficientesChanged write FOnCoeficientesChanged;
    property N: currency write SetN;
    property PanelEstrategia: TPanelEstrategia  read FPanelEstrategia write FPanelEstrategia;
  end;


implementation

{$R *.dfm}

uses GR32, StrUtils, DatosGrafico, dmData, math;

const
  COL_FECHA_ENTRADA: integer = 1;
  COL_FECHA_SALIDA: integer = 3;
  COL_FECHA_PERDIDA: integer = 9;

{ TfMensajeEstrategia }

procedure TfMensajeEstrategia.bAplicarClick(Sender: TObject);
//var EA, EB, EZ, EXA, EXB, EXZ, EIA, EIB, EIZ: currency;
begin
//  if not TryStrToCurr(eEA.Text, EA) then begin
//    ShowMessage('EA incorrecta');
//    exit;
//  end;
//  if not TryStrToCurr(eEB.Text, EB) then begin
//    ShowMessage('EB incorrecta');
//    exit;
//  end;
//  if not TryStrToCurr(eEXA.Text, EXA) then begin
//    ShowMessage('EXA incorrecta');
//    exit;
//  end;
//  if not TryStrToCurr(eEXB.Text, EXB) then begin
//    ShowMessage('EXB incorrecta');
//    exit;
//  end;
//  if not TryStrToCurr(eEIA.Text, EIA) then begin
//    ShowMessage('EIA incorrecta');
//    exit;
//  end;
//  if not TryStrToCurr(eEIB.Text, EIB) then begin
//    ShowMessage('EIB incorrecta');
//    exit;
//  end;
//  if not TryStrToCurr(eEZ.Text, EZ) then begin
//    ShowMessage('EZ incorrecta');
//    exit;
//  end;
//  if not TryStrToCurr(eEXZ.Text, EXZ) then begin
//    ShowMessage('EXZ incorrecta');
//    exit;
//  end;
//  if not TryStrToCurr(eEIZ.Text, EIZ) then begin
//    ShowMessage('EIZ incorrecta');
//    exit;
//  end;
//  FPanelEstrategia.EA := EA;
//  FPanelEstrategia.EB := EB;
//  FPanelEstrategia.EXA := EXA;
//  FPanelEstrategia.EXB := EXB;
//  FPanelEstrategia.EIA := EIA;
//  FPanelEstrategia.EIB := EIB;
//  FPanelEstrategia.EZ := EZ;
//  FPanelEstrategia.EXZ := EXZ;
//  FPanelEstrategia.EIZ := EIZ;
  FPanelEstrategia.ActivarInversaLDA := cbLDA.Checked;
  FPanelEstrategia.ActivarInversaLDB := cbLDB.Checked;
  FPanelEstrategia.ActivarInversaLDZ := cbLDZ.Checked;
  FOnCoeficientesChanged;
end;

procedure TfMensajeEstrategia.bCalcularClick(Sender: TObject);
var LIM: Currency;
begin
  if not TryStrToCurr(eLIM.Text, LIM) then begin
    ShowMessage('LIM incorrecta');
    exit;
  end;
  FPanelEstrategia.LIM := LIM;
  Rentabilidad(cbEstrategiaNormal.Checked, cbAlcista.Checked, Sender = bCalcularInversa);
end;

procedure TfMensajeEstrategia.bCalcularNClick(Sender: TObject);
//var n: currency;
begin
//  if TryStrToCurr(eN.Text, n) then begin
//    if n <> 0 then
//      OnNChanged(n);
//  end
//  else
//    ShowMessage('N incorrecta');
end;

procedure TfMensajeEstrategia.bTodoClick(Sender: TObject);
begin
  if bTodo.Caption = '>' then begin
    Width := 1024;
    bTodo.Caption := '<';
  end
  else begin
    Width := bTodo.Left + bTodo.Width + 12;
    bTodo.Caption := '>';
  end;
end;

procedure TfMensajeEstrategia.cbA11Click(Sender: TObject);
begin
  OnOsciladorChanged(tgeA11, cbA11.Checked);
end;

procedure TfMensajeEstrategia.cbAClick(Sender: TObject);
var cb: TCheckBox;
  i: integer;
begin
  cb := TCheckBox(Sender);
  i := StrToInt(Copy(cb.Caption, 2, 4));
  OnOsciladorChanged(tgeA, cb.Checked, i);
end;

procedure TfMensajeEstrategia.cbLACClick(Sender: TObject);
begin
  OnOsciladorChanged(tgeLAC, cbLAC.Checked);
end;

procedure TfMensajeEstrategia.cbLALClick(Sender: TObject);
begin
  OnOsciladorChanged(tgeLAL, cbLAL.Checked);
end;

procedure TfMensajeEstrategia.cbPRUAClick(Sender: TObject);
begin
  OnOsciladorChanged(tgePRUA, cbPRUA.Checked);
end;

function TfMensajeEstrategia.CurrToStrRound(number: currency): string;
var factor: double;
begin
  factor := Math.IntPower(10, -4);
  result := CurrToStr(Round(number / factor) * factor);
end;

procedure TfMensajeEstrategia.FormCreate(Sender: TObject);
const resumenRows: array[0..14] of string = ('VMA-VMB-VMZ',
  'DA-DB-DZ', 'DFA-DFB-DFZ', 'VTA-VTB-VTZ', 'DSA-DSB-DSZ', 'LDA-LDB-LDZ', 'LAL-LBL-LZL',
  'LAC-LBC-LZC', 'PRUA-PRDA', 'PRUB-PRDB', 'PRUZ-PRDZ', 'OSA-OSB-OSZ',
  'm HRA-HRB-HRC', 'r HRA-HRB-HRC', 'HRA-HRB-HRC'
  );
const resumen2Rows: array[1..6] of string = ('A', 'B', 'XA', 'IA', 'XB', 'IB');
var i: integer;
  menuItem: TMenuItem;
begin
  gData.ColWidths[0] := 20;
  for i := 1 to 23 do
    gData.Cells[0, i] := IntToStr(i);
  gData.Cells[1, 0] := 'Max';
  gData.Cells[2, 0] := 'K';
  gData.Cells[3, 0] := 'Min';
  gData.Cells[4, 0] := 'A';
  gData.Cells[5, 0] := 'B';
  gData.Cells[6, 0] := 'Z';

  sgResumen.RowCount := Length(resumenRows);
  sgResumen.ColWidths[0] := 80;
  sgResumen.ColWidths[1] := 60;
  for i := 0 to sgResumen.RowCount - 1 do begin
    sgResumen.Cells[0, i] := resumenRows[i];
    menuItem := TMenuItem.Create(Self);
    menuItem.Caption := resumenRows[i];
    menuItem.Checked := true;
    menuItem.OnClick := OnMenuItemResumenClick;
    pmResumen.Items.Add(menuItem);
  end;

  sgResumen2.RowCount := Length(resumen2Rows) + 1;
  sgResumen2.ColWidths[0] := 20;
  sgResumen2.Cells[1, 0] := 'LD';
  sgResumen2.Cells[2, 0] := 'D/DM';
  sgResumen2.Cells[3, 0] := 'DS';
  sgResumen2.Cells[4, 0] := 'DF/DFM';
  for i := 1 to sgResumen2.RowCount - 1 do begin
    sgResumen2.Cells[0, i] := resumen2Rows[i];
    menuItem := TMenuItem.Create(Self);
    menuItem.Caption := resumen2Rows[i];
    menuItem.Checked := true;
    menuItem.OnClick := OnMenuItemResumen2Click;
    pmResumen2.Items.Add(menuItem);
  end;

  sgLx.ColWidths[0] := sgResumen2.ColWidths[0];
  sgLx.Cells[1, 0] := 'LDA1';
  sgLx.Cells[2, 0] := 'LDA2';
  sgLx.Cells[3, 0] := 'LDB1';
  sgLx.Cells[4, 0] := 'LDB2';

  sgPosiciones.Cells[0, 0] := 'Tipo';
  sgPosiciones.Cells[1, 0] := 'Entrada';
  sgPosiciones.Cells[2, 0] := 'Nivel E';
  sgPosiciones.Cells[3, 0] := 'Salida';
  sgPosiciones.Cells[4, 0] := 'Nivel S';
  sgPosiciones.Cells[5, 0] := 'Resultado';
  sgPosiciones.Cells[6, 0] := '% Resultado';
  sgPosiciones.Cells[7, 0] := 'Pérdida max.';
  sgPosiciones.Cells[8, 0] := '% pérdida max.';
  sgPosiciones.Cells[9, 0] := 'Fecha pérdida';

  FGrafico := TGrafico2.Create(Self);
  FGrafico.Align := alClient;
  FGrafico.Margins.Left := 5;
  FGrafico.Margins.Right := 5;
  FGrafico.AlignWithMargins := true;
  FGrafico.ZoomActive := false;
  FGrafico.ShowPositions := true;
  FGrafico.Parent := pGrafico;

  pcVista.ActivePage := tsResumen;

  Width := bTodo.Left + bTodo.Width + 12;
end;

procedure TfMensajeEstrategia.gDataDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var S: string;
begin
  if (ARow = 0) or (ACol = 0) then
    exit;

  gData.Canvas.Font.Style := [fsBold];
  gData.Canvas.Font.Color := clBlack;
  if ((ARow = iLAC) and (ACol = 4)) or ((ARow = iLBC) and (ACol = 5)) or
    ((ARow = iLZC) and (ACol = 6)) then begin
    gData.Canvas.Brush.Color := $00D9FFD9;
    gData.Canvas.FillRect(Rect);
    S := gData.Cells[ACol, ARow];
    gData.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end
  else begin
    if ((ARow = iLAL) and (ACol = 4)) or ((ARow = iLBL) and (ACol = 5)) or
      ((ARow = iLZL) and (ACol = 6)) then begin
      gData.Canvas.Brush.Color := $00D5D5FF;
      gData.Canvas.FillRect(Rect);
      S := gData.Cells[ACol, ARow];
      gData.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
    end
    else begin
      if ((ACol = 4) or (ACol = 5) or (ACol = 6)) and (ARow = 11) then begin
        gData.Canvas.Brush.Color := clYellow;
        gData.Canvas.FillRect(Rect);
        S := gData.Cells[ACol, ARow];
        gData.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
      end;
    end;
  end;
end;

function TfMensajeEstrategia.getSigno(const c1, c2: currency): string;
begin
  if c1 < c2 then
    result := '<'
  else
    if c1 > c2 then
      result := '>'
    else
      result := '=';
end;

procedure TfMensajeEstrategia.OnMenuItemResumen2Click(Sender: TObject);
var item: TMenuItem;
begin
  item := TMenuItem(Sender);
  item.Checked := not item.Checked;
  sgResumen2.Invalidate;
end;

procedure TfMensajeEstrategia.OnMenuItemResumenClick(Sender: TObject);
var item: TMenuItem;
begin
  item := TMenuItem(Sender);
  item.Checked := not item.Checked;
  sgResumen.Invalidate;
end;

procedure TfMensajeEstrategia.pcVistaChange(Sender: TObject);
begin
  if pcVista.ActivePage = tsAnalisis then
    Width := sgPosiciones.Width + 10;
end;

procedure TfMensajeEstrategia.pcVistaChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if pcVista.ActivePage = tsAnalisis then begin
    if pcVista.Tag <> 0 then begin
      Width := pcVista.Tag;
      pcVista.Tag := 0;
    end;
  end
  else
    pcVista.Tag := Width;
end;

procedure TfMensajeEstrategia.Rentabilidad(const normal, alcista, inversa: Boolean);
var posiciones: TPosiciones;
  posicion: TPosicion;
  i, j, num, numGanadoras, numPerdedoras: integer;
  posicionSalida, posicionEntrada, resta, totalGanadora, totalPerdedora, perCent: currency;
begin
  if normal then
    FPanelEstrategia.CalcularRentabilidadNormal(Data.OIDValor, alcista, inversa)
  else
    FPanelEstrategia.CalcularRentabilidad2(alcista, inversa);
//    FPanelEstrategia.CalcularRentabilidadSugerencia(inversa);
  posiciones := FPanelEstrategia.Posiciones;
  num := length(posiciones);
  sgPosiciones.RowCount := num + 1;
  numGanadoras := 0;
  numPerdedoras := 0;
  totalGanadora := 0;
  totalPerdedora := 0;
  for i := 0 to num - 1 do begin
    posicion := posiciones[i];
    j := i + 1;
    posicionSalida := posicion.posicionSalida;
    posicionEntrada := posicion.posicionEntrada;
    if posicion.alcista then begin
      sgPosiciones.Cells[0, j] := 'L';
      resta := posicionSalida - posicionEntrada;
    end
    else begin
      sgPosiciones.Cells[0, j] := 'C';
      resta := posicionEntrada - posicionSalida;
    end;
    sgPosiciones.Cells[5, j] := CurrToStrRound(resta);
    perCent := resta / posicionEntrada * 100;
    if resta > 0 then begin
      Inc(numGanadoras);
      totalGanadora := totalGanadora + perCent;
    end
    else begin
      Inc(numPerdedoras);
      totalPerdedora := totalPerdedora + perCent;
    end;
    sgPosiciones.Cells[6, j] := CurrToStrRound(perCent) + '%';
    sgPosiciones.Cells[1, j] := DateToStr(posicion.entrada);
    sgPosiciones.Cells[2, j] := CurrToStrRound(posicionEntrada);
    sgPosiciones.Cells[3, j] := DateToStr(posicion.salida);
    sgPosiciones.Cells[4, j] := CurrToStrRound(posicionSalida);
    resta := posicion.posicionMaximaPerdida - posicionEntrada;
    sgPosiciones.Cells[7, j] := CurrToStrRound(resta);
    sgPosiciones.Cells[8, j] := CurrToStrRound(resta / posicionEntrada * 100);
    sgPosiciones.Cells[9, j] := DateToStr(posicion.fechaMaximaPerdida);
  end;
  lNumGanadoras.Caption := IntToStr(numGanadoras) + '   ' + CurrToStrRound(totalGanadora) + '%';
  lNumPerdedoras.Caption := IntToStr(numPerdedoras) + '   ' + CurrToStrRound(totalPerdedora) + '%';

  if FPanelEstrategia.NumPosicionesAbiertas > 0 then begin
    num := sgPosiciones.RowCount + 1;
    sgPosiciones.RowCount := num;
    for i := 0 to 9 do
      sgPosiciones.Cells[i, num - 1] := '';
    sgPosiciones.RowCount := num + FPanelEstrategia.NumPosicionesAbiertas;
    for j := 0 to FPanelEstrategia.NumPosicionesAbiertas - 1 do begin
      posicion := FPanelEstrategia.PosicionesAbiertas[j];
      posicionSalida := posicion.posicionSalida;
      posicionEntrada := posicion.posicionEntrada;
      if posicion.alcista then begin
        sgPosiciones.Cells[0, num] := 'L';
        resta := posicionSalida - posicionEntrada;
      end
      else begin
        sgPosiciones.Cells[0, num] := 'C';
        resta := posicionEntrada - posicionSalida;
      end;
      perCent := resta / posicionEntrada * 100;
      sgPosiciones.Cells[5, num] := CurrToStrRound(resta);
      sgPosiciones.Cells[6, num] := CurrToStrRound(perCent) + '%';
      sgPosiciones.Cells[1, num] := DateToStr(posicion.entrada);
      sgPosiciones.Cells[2, num] := CurrToStrRound(posicionEntrada);
      sgPosiciones.Cells[3, num] := '';
      sgPosiciones.Cells[4, num] := CurrToStrRound(posicionSalida);
      resta := posicion.posicionMaximaPerdida - posicionEntrada;
      sgPosiciones.Cells[7, num] := CurrToStrRound(resta);
      sgPosiciones.Cells[8, num] := CurrToStrRound(resta / posicionEntrada * 100);
      sgPosiciones.Cells[9, num] := DateToStr(posicion.fechaMaximaPerdida);
      inc(num);
    end;
  end;
  lMensaje.Caption := '';
end;

procedure TfMensajeEstrategia.SetData(const PCambios, PMaximos, PMinimos: PArrayCurrency;
  const i: integer; const resultado: TReglaResult);
var A, B, Z, MA, MI: TArrayCurrency;
  j, j2: integer;
  sLAL, sLAC, sLBL, sLBC, mHR, rHR: string;
begin
  iLAL := resultado.iLAL + 1;
  iLBL := resultado.iLBL + 1;
  iLAC := resultado.iLAC + 1;
  iLBC := resultado.iLBC + 1;
  iLZL := resultado.iLZL + 1;
  iLZC := resultado.iLZC + 1;
  K := Copy(PCambios^, i - 22, 23);
  MA := Copy(PMaximos^, i - 22, 23);
  MI := Copy(PMinimos^, i - 22, 23);
  A := Copy(K, 2, 21);
  Sort(A);
  B := Copy(K, 1, 21);
  Sort(B);
  Z := Copy(K, 0, 21);
  Sort(Z);
  K12 := K[11];
  K11 := K[10];
  maximo := 0;
  minimo := 9999999999;
  for j := 0 to 20 do begin
    j2 := j + 1;
    gData.Cells[1, j2] := CurrToStrRound(MA[j]);
    gData.Cells[2, j2] := CurrToStrRound(K[j]);
    gData.Cells[3, j2] := CurrToStrRound(MI[j]);
    gData.Cells[4, j2] := CurrToStrRound(A[j]);
    gData.Cells[5, j2] := CurrToStrRound(B[j]);
    gData.Cells[6, j2] := CurrToStrRound(Z[j]);
    if K[j] > maximo then
      maximo := K[j];
    if K[j] < minimo then
      minimo := K[j];
  end;
  gData.Cells[1, 22] := CurrToStrRound(MA[21]);
  gData.Cells[1, 23] := CurrToStrRound(MA[22]);
  gData.Cells[2, 22] := CurrToStrRound(K[21]);
  gData.Cells[2, 23] := CurrToStrRound(K[22]);
  gData.Cells[3, 22] := CurrToStrRound(MI[21]);
  gData.Cells[3, 23] := CurrToStrRound(MI[22]);
  if K12 > maximo then
    maximo := K12;
  if K12 < minimo then
    minimo := K12;
  FGrafico.SetData(@K);

  sLAL := CurrToStrRound(resultado.LAL);
  sLAC := CurrToStrRound(resultado.LAC);
  sLBL := CurrToStrRound(resultado.LBL);
  sLBC := CurrToStrRound(resultado.LBC);
  lL.Caption := 'K11(' + CurrToStrRound(K[10]) + ') ' + getSigno(K[10], resultado.LBC) + ' LBC(' + sLBC + ')    ' +
    'K11(' + CurrToStrRound(K[10]) + ') ' + getSigno(K[10], resultado.LBL) + ' LBL(' + sLBL + ')' + sLineBreak +
    'K12(' + CurrToStrRound(K[11]) + ') ' + getSigno(K[11], resultado.LAC) + ' LAC(' + sLAC + ')    ' +
    'K12(' + CurrToStrRound(K[11]) + ') ' + getSigno(K[11], resultado.LAL) + ' LAL(' + sLAL + ')';
  sgResumen.Cells[1, 0] := CurrToStrRound(resultado.VMA);
  sgResumen.Cells[2, 0] := CurrToStrRound(resultado.VMB);
  sgResumen.Cells[3, 0] := CurrToStrRound(resultado.VMZ);
  sgResumen.Cells[1, 1] := CurrToStrRound(resultado.DA);
  sgResumen.Cells[2, 1] := CurrToStrRound(resultado.DB);
  sgResumen.Cells[3, 1] := CurrToStrRound(resultado.DZ);
  sgResumen.Cells[1, 2] := CurrToStrRound(resultado.DFA);
  sgResumen.Cells[2, 2] := CurrToStrRound(resultado.DFB);
  sgResumen.Cells[3, 2] := CurrToStrRound(resultado.DFZ);
  sgResumen.Cells[1, 3] := CurrToStrRound(resultado.VTA);
  sgResumen.Cells[2, 3] := CurrToStrRound(resultado.VTB);
  sgResumen.Cells[3, 3] := CurrToStrRound(resultado.VTZ);
  sgResumen.Cells[1, 4] := CurrToStrRound(resultado.DSA);
  sgResumen.Cells[2, 4] := CurrToStrRound(resultado.DSB);
  sgResumen.Cells[3, 4] := CurrToStrRound(resultado.DSZ);
  sgResumen.Cells[1, 5] := CurrToStrRound(resultado.LDA);
  sgResumen.Cells[2, 5] := CurrToStrRound(resultado.LDB);
  sgResumen.Cells[3, 5] := CurrToStrRound(resultado.LDZ);
  sgResumen.Cells[1, 6] := CurrToStrRound(resultado.LAL);
  sgResumen.Cells[2, 6] := CurrToStrRound(resultado.LBL);
  sgResumen.Cells[3, 6] := CurrToStrRound(resultado.LZL);
  sgResumen.Cells[1, 7] := CurrToStrRound(resultado.LAC);
  sgResumen.Cells[2, 7] := CurrToStrRound(resultado.LBC);
  sgResumen.Cells[3, 7] := CurrToStrRound(resultado.LZC);
  sgResumen.Cells[1, 8] := CurrToStrRound(resultado.PRUA);
  sgResumen.Cells[2, 8] := CurrToStrRound(resultado.PRDA);
  sgResumen.Cells[1, 9] := CurrToStrRound(resultado.PRUB);
  sgResumen.Cells[2, 9] := CurrToStrRound(resultado.PRDB);
  sgResumen.Cells[1, 10] := CurrToStrRound(resultado.PRUZ);
  sgResumen.Cells[2, 10] := CurrToStrRound(resultado.PRDZ);
  sgResumen.Cells[1, 11] := CurrToStrRound(resultado.OSA);
  sgResumen.Cells[2, 11] := CurrToStrRound(resultado.OSB);
  sgResumen.Cells[3, 11] := CurrToStrRound(resultado.OSZ);
  sgResumen.Cells[1, 12] := IntToStr(resultado.mHRA);
  sgResumen.Cells[2, 12] := IntToStr(resultado.mHRB);
  sgResumen.Cells[3, 12] := IntToStr(resultado.mHRC);
  sgResumen.Cells[1, 13] := IntToStr(resultado.rHRA);
  sgResumen.Cells[2, 13] := IntToStr(resultado.rHRB);
  sgResumen.Cells[3, 13] := IntToStr(resultado.rHRC);
  sgResumen.Cells[1, 14] := CurrToStrRound(resultado.HRA);
  sgResumen.Cells[2, 14] := CurrToStrRound(resultado.HRB);
  sgResumen.Cells[3, 14] := CurrToStrRound(resultado.HRC);

//  sgResumen2.Cells[1, 1] := CurrToStrRound(resultado.LDA);
//  sgResumen2.Cells[1, 2] := CurrToStrRound(resultado.LDB);
//  sgResumen2.Cells[1, 3] := CurrToStrRound(resultado.LDXA);
//  sgResumen2.Cells[1, 4] := CurrToStrRound(resultado.LDIA);
//  sgResumen2.Cells[1, 5] := CurrToStrRound(resultado.LDXB);
//  sgResumen2.Cells[1, 6] := CurrToStrRound(resultado.LDIB);
//
//  sgResumen2.Cells[2, 1] := CurrToStrRound(resultado.DA);
//  sgResumen2.Cells[2, 2] := CurrToStrRound(resultado.DB);
//  sgResumen2.Cells[2, 3] := CurrToStrRound(resultado.DMAX);
//  sgResumen2.Cells[2, 4] := CurrToStrRound(resultado.DMAI);
//  sgResumen2.Cells[2, 5] := CurrToStrRound(resultado.DMBX);
//  sgResumen2.Cells[2, 6] := CurrToStrRound(resultado.DMBI);
//
//  sgResumen2.Cells[3, 1] := CurrToStrRound(resultado.DSA);
//  sgResumen2.Cells[3, 2] := CurrToStrRound(resultado.DSB);
//  sgResumen2.Cells[3, 3] := CurrToStrRound(resultado.DSXA);
//  sgResumen2.Cells[3, 4] := CurrToStrRound(resultado.DSIA);
//  sgResumen2.Cells[3, 5] := CurrToStrRound(resultado.DSXB);
//  sgResumen2.Cells[3, 6] := CurrToStrRound(resultado.DSIB);
//
//  sgResumen2.Cells[4, 1] := CurrToStrRound(resultado.DFA);
//  sgResumen2.Cells[4, 2] := CurrToStrRound(resultado.DFB);
//  sgResumen2.Cells[4, 3] := CurrToStrRound(resultado.DFMAX);
//  sgResumen2.Cells[4, 4] := CurrToStrRound(resultado.DFMAI);
//  sgResumen2.Cells[4, 5] := CurrToStrRound(resultado.DFMBX);
//  sgResumen2.Cells[4, 6] := CurrToStrRound(resultado.DFMBI);
//
//  sgLx.Cells[1, 1] := CurrToStrRound(resultado.LDA1);
//  sgLx.Cells[2, 1] := CurrToStrRound(resultado.LDA2);
//  sgLx.Cells[3, 1] := CurrToStrRound(resultado.LDB1);
//  sgLx.Cells[4, 1] := CurrToStrRound(resultado.LDB2);
//
  lMensaje.Caption := resultado.Msg;
//  lSugerencia.Caption := resultado.SubMsg;
//  if calcularRentabilidad then
//    Rentabilidad(cbEstrategiaNormal.Checked, cbAlcista.Checked, False);
end;

procedure TfMensajeEstrategia.SetN(const Value: currency);
begin
//  eN.Text := CurrToStrRound(Value);
//  sgResumen.Cells[1, 6] := eN.Text;
end;


procedure TfMensajeEstrategia.sgPosicionesDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var Fmt: integer;
  s: string;
begin
  if (ARow <> 0) and ((ACol = 5) or (ACol = 6)) then begin
    s := sgPosiciones.Cells[ACol, ARow];
    if s = '' then begin
      sgPosiciones.Canvas.Brush.Color := clWhite;
      sgPosiciones.Canvas.FillRect(Rect);
    end
    else begin
      if StartsText('-', sgPosiciones.Cells[5, ARow]) then begin
        sgPosiciones.Canvas.Brush.Color := clRed
      end
      else
          sgPosiciones.Canvas.Brush.Color := clGreen;
      sgPosiciones.Canvas.Font.Color := clWhite;
      sgPosiciones.Canvas.FillRect(Rect);
      Fmt := DT_SINGLELINE or DT_VCENTER or DT_RIGHT;
      Rect.Right := Rect.Right - 3;
      DrawText(sgPosiciones.Canvas.Handle, PChar(s), -1, Rect, Fmt);
    end;
  end;
end;

procedure TfMensajeEstrategia.sgPosicionesSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var s: string;
begin
  if (Arow <> 0) and ((ACol = COL_FECHA_ENTRADA) or (ACol = COL_FECHA_SALIDA) or
    (ACol = COL_FECHA_PERDIDA)) then begin
    s := sgPosiciones.Cells[ACol, Arow];
    if s <> '' then
      Data.IrACotizacionConFecha(StrToDate(s));
  end;
end;

procedure TfMensajeEstrategia.sgResumen2DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var Fmt: integer;
  item: TMenuItem;
begin
  if (ACol <> 0) and (ARow <> 0) then begin
    sgResumen2.Canvas.FillRect(Rect);
    item := pmResumen2.Items[ARow - 1];
    if item.Checked  then begin
      sgResumen2.Canvas.Font.Style := [fsBold];
      Fmt := DT_SINGLELINE or DT_VCENTER or DT_LEFT;
      Rect.Left := Rect.Left + 3;
      DrawText(sgResumen2.Canvas.Handle, PChar(sgResumen2.Cells[ACol, ARow]), -1, Rect,
        Fmt);
    end;
  end;
end;

procedure TfMensajeEstrategia.sgResumenDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var Fmt: integer;
  item: TMenuItem;
begin
  sgResumen.Canvas.FillRect(Rect);
  item := pmResumen.Items[ARow];
  if item.Checked  then begin
    if ACol > 0 then
    begin
      sgResumen.Canvas.Font.Style := [fsBold];
    end
    else
      sgResumen.Canvas.Font.Style := [];
    Fmt := DT_SINGLELINE or DT_VCENTER or DT_LEFT;
    Rect.Left := Rect.Left + 3;
    DrawText(sgResumen.Canvas.Handle, PChar(sgResumen.Cells[ACol, ARow]), -1, Rect,
      Fmt);
  end;
end;

procedure TfMensajeEstrategia.Sort(var A: TArrayCurrency);
var
  aux: currency;
  i, num: Integer;
  Check: Boolean;
begin
  num := Length(A);
  dec(num);
  repeat
    Check:=False;
    i:=0;
    repeat
      if A[i] > A[i+1] then begin
        aux:=A[i];
        A[i]:=A[i+1];
        A[i+1]:=aux;
        Check:=True;
      end;
      Inc(i);
    until(i>=num);
  until(not Check);
end;

procedure TfMensajeEstrategia.ValorCambiado;
var i: integer;
begin
  lNumGanadoras.Caption := '?';
  lNumPerdedoras.Caption := '?';
  sgPosiciones.RowCount := 2;
  for i := 0 to sgPosiciones.ColCount - 1 do
    sgPosiciones.Cells[i, 1] := '';
  calcularRentabilidad := cbAuto.Checked;
end;

{ TGrafico2 }

procedure TGrafico2.CalculateAltoEjeX;
begin
  FAltoEjeX := 30;
end;

procedure TGrafico2.PaintX(const iFrom, iTo: integer);
var i, x, y, anchoText: integer;
  text: string;
begin
  i := iTo;
  y := Height - 13;
  Bitmap.Font.Size := 8;
  Bitmap.SetStipple([Color32(60, 60, 60), 0, 0, 0, 0]);
  while i >= iFrom do begin
    text := IntToStr(i + 1);
    anchoText := Bitmap.TextWidth(text);
    x := Datos.XTransformados[i];
    Bitmap.VertLineTSP(x, 0, y);
    Bitmap.Textout(x - (anchoText div 2), y, text);
    dec(i);
  end;
end;

procedure TGrafico2.SetData(const PCambios: PArrayCurrency);
begin
  SetLength(Fechas, length(PCambios^));
  inherited SetData(PCambios, @Fechas);
end;

end.
