unit fmAnalisisRapido;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBaseFormConfig, dmAnalisisRapido, WebAdapt, flags,
  StdCtrls, DBCtrls, ExtCtrls, frValorAnalisis,
  TB2Dock, TB2Toolbar, SpTBXItem, fmBase;

type
  TfAnalisisRapido = class(TfBaseFormConfig)
    ScrollBox: TScrollBox;
    Panel1: TPanel;
    AnalisisToolbar: TSpTBXToolbar;
    PanelPie: TFlowPanel;
    Panel3: TPanel;
    lNumInicioCiclo: TLabel;
    Label1: TLabel;
    iLargo: TImage;
    Panel4: TPanel;
    lNumInicioCicloVirtual: TLabel;
    Label4: TLabel;
    Image1: TImage;
    Panel5: TPanel;
    Label2: TLabel;
    lNumMantener: TLabel;
    pBarra: TPanel;
    pA: TPanel;
    pPAV: TPanel;
    pPA: TPanel;
    pM: TPanel;
    pICV: TPanel;
    pIC: TPanel;
    Panel2: TPanel;
    Label5: TLabel;
    lTotalLargos: TLabel;
    Panel6: TPanel;
    iCorto: TImage;
    Label3: TLabel;
    lNumPrimeraAdv: TLabel;
    Panel7: TPanel;
    Image2: TImage;
    lAdvVir: TLabel;
    lNumPrimeraAdvVirtual: TLabel;
    Panel8: TPanel;
    lAdv: TLabel;
    lNumAdv: TLabel;
    Panel9: TPanel;
    Label7: TLabel;
    lTotalCortos: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ScrollBoxMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    listAnalisis: TStringList;
    AnalisisRapido: TAnalisisRapido;
    inicioCiclo, inicioCicloVirtual, mantener, primeraAdv, primeraAdvVirtual,
    advertencia, numValores: integer;
    procedure CrearValores;
    procedure CrearBarra;
    procedure OnCotizacionCambiada;
    procedure OnGrupoCambiado;
    procedure RedistribuirValores;
  public
    { Public declarations }
  end;


implementation

uses dmData, dmConfiguracion, uAcciones, uAccionesValor, BusCommunication,
  dmDataComun, dmAccionesValor;

{$R *.dfm}

resourcestring
  TITULO = 'Análisis rápido';

type
  TStringListCrack = class(TStringList);

function OrdenarValores(List: TStringList; Index1, Index2: Integer): Integer;
var OIDValor1, OIDValor2: integer;
  valor1, valor2: PDataComunValor;
begin
  OIDValor1 := TValorAnalisis(List.Objects[Index1]).OIDValor;
  OIDValor2 := TValorAnalisis(List.Objects[Index2]).OIDValor;
  valor1 := DataComun.FindValor(OIDValor1);
  valor2 := DataComun.FindValor(OIDValor2);
  if valor1^.Simbolo = valor2^.Simbolo then begin
    result := TStringListCrack(List).CompareStrings(valor1^.Nombre, valor2^.Nombre);
  end
  else begin
    result := TStringListCrack(List).CompareStrings(valor1^.Simbolo, valor2^.Simbolo);
  end;
end;

procedure TfAnalisisRapido.CrearBarra;
var ancho, acumulado: integer;
  divAnchoNumValores: Single;
begin
  ancho := pBarra.Width;
  if numValores <> 0 then begin
    // Si ancho --> numValores
    //       x  --> inicioCiclo
    divAnchoNumValores := ancho / numValores;
    pIC.Width := Round(inicioCiclo * divAnchoNumValores);
    acumulado := pIC.Width;
    pICV.Width := Round(inicioCicloVirtual * divAnchoNumValores);
    pICV.Left := acumulado;
    acumulado := acumulado + pICV.Width;
    pM.Width := Round(mantener * divAnchoNumValores);
    pM.Left := acumulado;
    acumulado := acumulado + pM.Width;
    pPA.Width := Round(primeraAdv * divAnchoNumValores);
    pPA.Left := acumulado;
    acumulado := acumulado + pPA.Width;
    pPAV.Width := Round(primeraAdvVirtual * divAnchoNumValores);
    pPAV.Left := acumulado;
    acumulado := acumulado + pPAV.Width;
    pA.Width := Round(advertencia * divAnchoNumValores);
    pA.Left := acumulado;
  end;
end;

procedure TfAnalisisRapido.CrearValores;
var flags: TFlags;
  valor: TValorAnalisis;
  i: integer;
  totalLargos, totalCortos, OIDValor: integer;
  sOIDValor: string;
begin
  inicioCiclo := 0;
  inicioCicloVirtual := 0;
  mantener := 0;
  primeraAdv := 0;
  primeraAdvVirtual := 0;
  advertencia := 0;
  flags := TFlags.Create;
  try
    AnalisisRapido.qParams.First;
    while not AnalisisRapido.qParams.Eof do begin
      flags.Flags := AnalisisRapido.qParamsFLAGS.Value;
      if Flags.Es(cMantener) then
        inc(mantener)
      else
        if Flags.Es(cAdvertencia) then
          inc(advertencia)
        else
          if Flags.Es(cInicioCiclo) then
            inc(inicioCiclo)
          else
          if Flags.Es(cPrimeraAdvertencia) then
            inc(primeraAdv)
          else
            if Flags.Es(cInicioCicloVirtual) then
              inc(inicioCicloVirtual)
            else
              if Flags.Es(cPrimeraAdvertenciaVirtual) then
                inc(primeraAdvVirtual);
      OIDValor := AnalisisRapido.qParamsOR_VALOR.Value;
      sOIDValor := IntToStr(OIDValor);
      i := listAnalisis.IndexOf(sOIDValor);
      if i = -1 then begin
        valor := TValorAnalisis.Create(Self, iCorto, iLargo);
        valor.Name := 'a' + sOIDValor;
        valor.Parent := ScrollBox;
        valor.OIDValor := OIDValor;
        listAnalisis.AddObject(IntToStr(OIDValor), valor);
      end
      else
        valor := TValorAnalisis(listAnalisis.Objects[i]);
      valor.Flags := flags;
      AnalisisRapido.qParams.Next;
    end;
  finally
    flags.Free;
  end;
  listAnalisis.CustomSort(OrdenarValores);

  lNumMantener.Caption := IntToStr(mantener);
  lNumInicioCiclo.Caption := IntToStr(inicioCiclo);
  lNumInicioCicloVirtual.Caption := IntToStr(inicioCicloVirtual);
  lNumAdv.Caption := IntToStr(advertencia);
  lNumPrimeraAdv.Caption := IntToStr(primeraAdv);
  lNumPrimeraAdvVirtual.Caption := IntToStr(primeraAdvVirtual);
  totalCortos := advertencia + primeraAdv + primeraAdvVirtual;
  totalLargos := inicioCiclo + inicioCicloVirtual + mantener;
  numValores := totalLargos + totalCortos;
  // Si NumValores - 100%
  //      totalLargos - X
  if numValores = 0 then begin
    lTotalLargos.Caption := '';
    lTotalCortos.Caption := '';
  end
  else begin
    lTotalLargos.Caption := IntToStr(totalLargos) + ' - ' +
      IntToStr(totalLargos * 100 div numValores) + '%';
    lTotalCortos.Caption := IntToStr(totalCortos) + ' - ' +
      IntToStr(totalCortos * 100 div numValores) + '%';
  end;
end;

procedure TfAnalisisRapido.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

procedure TfAnalisisRapido.FormCreate(Sender: TObject);
begin
  inherited;
  listAnalisis := TStringList.Create;
  AnalisisRapido := TAnalisisRapido.Create(Self);
  AnalisisRapido.Open;
  AnalisisToolBar.LinkSubItems := (GetAcciones(TAccionesValor) as TAccionesValor).MenuGrupos;
//  AnalisisToolBar.LinkSubitems.Items[1].Visible := false;
  Bus.RegisterEvent(MessageCotizacionCambiada, OnCotizacionCambiada);
  Bus.RegisterEvent(MessageMercadoGrupoCambiado, OnGrupoCambiado);
  OnCotizacionCambiada;
end;


procedure TfAnalisisRapido.FormDestroy(Sender: TObject);
begin
  inherited;
  // Sera = nil si se cierra el programa con el análisis abierto
  if AnalisisToolBar.LinkSubitems <> nil then
    AnalisisToolBar.LinkSubitems.Items[1].Visible := true;
  listAnalisis.Free;
  Bus.UnregisterEvent(MessageCotizacionCambiada, OnCotizacionCambiada);
  Bus.UnregisterEvent(MessageMercadoGrupoCambiado, OnGrupoCambiado);
end;

procedure TfAnalisisRapido.FormResize(Sender: TObject);
begin
  inherited;
  PanelPie.AutoSize := true;
  PanelPie.AutoSize := false;
  CrearBarra;
  RedistribuirValores;
end;

procedure TfAnalisisRapido.OnCotizacionCambiada;
begin
  Screen.Cursor := crHourGlass;
  try
    AnalisisRapido.Open;
    Caption := TITULO + ' - ' + StringReplace(AnalisisToolbar.LinkSubitems.Caption, '&&', '&', [rfReplaceAll]);
    CrearValores;
    CrearBarra;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfAnalisisRapido.OnGrupoCambiado;
var i: integer;
begin
  Screen.Cursor := crHourGlass;
  try
    ScrollBox.Visible := false;
    try
          //No existe ScrollBox.BeginUpdate, lo simulamos
      SendMessage(ScrollBox.Handle, wm_SetRedraw, Ord(False), 0);
      try
        for i := 0 to listAnalisis.Count - 1 do
          listAnalisis.Objects[i].Free;
        listAnalisis.Clear;
        OnCotizacionCambiada;
        RedistribuirValores;
      finally
        //No existe ScrollBox.EndUpdate, lo simulamos
        SendMessage(ScrollBox.Handle, wm_SetRedraw, Ord(True), 0);
        RedrawWindow(ScrollBox.Handle, Nil, 0, RDW_ERASE or RDW_INVALIDATE or
                RDW_FRAME or RDW_ALLCHILDREN);
      end;
    finally
      ScrollBox.Visible := true;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfAnalisisRapido.RedistribuirValores;
var i, col, ancho, alto, numCols, num, valorTop: integer;
  valor: TValorAnalisis;
begin
  num := listAnalisis.Count;
  if num = 0 then
    exit;

  Screen.Cursor := crHourGlass;
  try
    ScrollBox.Visible := false;
    try
      //No existe ScrollBox.BeginUpdate, lo simulamos
      SendMessage(ScrollBox.Handle, wm_SetRedraw, Ord(False), 0);
      try
        ScrollBox.VertScrollBar.Position := 0;
        valor := TValorAnalisis(listAnalisis.Objects[0]);
        numCols := ScrollBox.Width div valor.Width;
        alto := valor.Height;
        ancho := valor.Width;
        dec(num);
        col := 0;
        valorTop := 0;
        for i := 0 to num do begin
          valor := TValorAnalisis(listAnalisis.Objects[i]);
          valor.Left := col * ancho;
          valor.Top := valorTop;
          inc(col);
          if col = numCols then begin
            col := 0;
            valorTop := valorTop + alto;
          end;
        end;
      finally
        //No existe ScrollBox.EndUpdate, lo simulamos
        SendMessage(ScrollBox.Handle, wm_SetRedraw, Ord(True), 0);
        RedrawWindow(ScrollBox.Handle, Nil, 0, RDW_ERASE or RDW_INVALIDATE or
                RDW_FRAME or RDW_ALLCHILDREN);
      end;
    finally
      ScrollBox.Visible := true;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfAnalisisRapido.ScrollBoxMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  inherited;
  ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Position - WheelDelta;
end;

end.
