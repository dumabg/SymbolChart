unit fmCuentaCartera;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frCuentaBase, DB, StdCtrls, ExtCtrls, TeEngine, Series, TeeProcs,
  Chart, JvExExtCtrls, JvNetscapeSplitter, Grids, DBGrids, JvExDBGrids,
  JvDBGrid, JvDBUltimGrid, ComCtrls, ActnList, fmCalculando,
  JvExComCtrls, JvComCtrls, JvExStdCtrls, JvCombobox, JvDBSearchComboBox, ImgList,
  dmCuentaBase, dmInversorCartera, Mask, DBCtrls, JvExMask, JvSpin,
  JvDBSpinEdit, fmPosicionMercado, 
  dmData, SpTBXItem, TB2Item, TB2Dock, TB2Toolbar, JvGIF;

type
  TfCuentaCartera = class(TfCuentaBase)
    tsPosicionesPendientes: TTabSheet;
    tsPosiblePosicionamiento: TTabSheet;
    pcPosiblePosicionamiento: TJvPageControl;
    tsCalculando: TTabSheet;
    frCalculando: TfrCalculando;
    lbLog: TListBox;
    tsResultado: TTabSheet;
    dbgPosiciones: TJvDBUltimGrid;
    TBXToolbar1: TSpTBXToolbar;
    TBControlItem1: TTBControlItem;
    TBXSeparatorItem2: TSpTBXSeparatorItem;
    TBXItem3: TSpTBXItem;
    Estrategias: TJvDBSearchComboBox;
    lEstrategia: TSpTBXLabelItem;
    TBXSeparatorItem1: TSpTBXSeparatorItem;
    ActionList: TActionList;
    BuscarPosiciones: TAction;
    tsInicial: TTabSheet;
    ImageList: TImageList;
    dsEstrategias: TDataSource;
    Posicionar: TAction;
    TBXItem1: TSpTBXItem;
    dbgPosicionesMercado: TJvDBUltimGrid;
    TBXToolbar2: TSpTBXToolbar;
    Confirmar: TAction;
    TBXItem2: TSpTBXItem;
    Descartar: TAction;
    TBXItem4: TSpTBXItem;
    TBXToolbar3: TSpTBXToolbar;
    TBXSeparatorItem3: TSpTBXSeparatorItem;
    PosicionarTodos: TAction;
    TBXItem5: TSpTBXItem;
    DescartarTodos: TAction;
    TBXItem7: TSpTBXItem;
    TBXSeparatorItem4: TSpTBXSeparatorItem;
    TBXSeparatorItem5: TSpTBXSeparatorItem;
    TBXItem8: TSpTBXItem;
    CerrarStops: TAction;
    CerrarPosicion: TAction;
    TBXSeparatorItem7: TSpTBXSeparatorItem;
    TBXItem9: TSpTBXItem;
    ConfirmarTodos: TAction;
    TBXItem10: TSpTBXItem;
    CerrarPosicionTodos: TAction;
    TBXItem6: TSpTBXItem;
    tsCartera: TTabSheet;
    lNombre: TLabel;
    eNombre: TDBEdit;
    Label4: TLabel;
    Label5: TLabel;
    ePaquetes: TJvDBSpinEdit;
    cbUSA100: TDBCheckBox;
    Label3: TLabel;
    Image2: TImage;
    dbtCapital: TDBText;
    Label1: TLabel;
    dbtMoneda: TDBText;
    dsCartera: TDataSource;
    TBXSeparatorItem11: TSpTBXSeparatorItem;
    TBXSeparatorItem12: TSpTBXSeparatorItem;
    TBXSeparatorItem13: TSpTBXSeparatorItem;
    Label6: TLabel;
    dsBrokers: TDataSource;
    dbtBorker: TDBText;
    TBXSeparatorItem14: TSpTBXSeparatorItem;
    TBXSeparatorItem17: TSpTBXSeparatorItem;
    lNumPosibles: TSpTBXLabelItem;
    TBXLabelItem2: TSpTBXLabelItem;
    dbtMoneda2: TDBText;
    cbCuando: TComboBox;
    TBControlItem2: TTBControlItem;
    TBXSeparatorItem18: TSpTBXSeparatorItem;
    procedure BuscarPosicionesExecute(Sender: TObject);
    procedure EstrategiasChange(Sender: TObject);
    procedure PosicionarExecute(Sender: TObject);
    procedure ConfirmarExecute(Sender: TObject);
    procedure ConfirmarUpdate(Sender: TObject);
    procedure DescartarExecute(Sender: TObject);
    procedure PosicionarTodosExecute(Sender: TObject);
    procedure DescartarTodosExecute(Sender: TObject);
    procedure DescartarUpdate(Sender: TObject);
    procedure DescartarTodosUpdate(Sender: TObject);
    procedure CerrarPosicionExecute(Sender: TObject);
    procedure CerrarPosicionUpdate(Sender: TObject);
    procedure CerrarStopsExecute(Sender: TObject);
    procedure ConfirmarTodosUpdate(Sender: TObject);
    procedure ConfirmarTodosExecute(Sender: TObject);
    procedure CerrarStopsUpdate(Sender: TObject);
    procedure CerrarPosicionTodosUpdate(Sender: TObject);
    procedure CerrarPosicionTodosExecute(Sender: TObject);
    procedure dbgPosicionesMercadoGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure GridPosicionDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgPosicionesGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure BuscarPosicionesUpdate(Sender: TObject);
    procedure eNombreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FInversor: TInversorCartera;
    FEstaCalculando: boolean;
    procedure OnCancelar;
    function GetValores: TDataSet;
    procedure SetValores(const Value: TDataSet);
    procedure SetInversor(const Value: TInversorCartera);
    function ShowPosicionMercado(const fPosicionMercado: TfPosicionMercado): TModalResult;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function EstaCalculando: boolean;
    property Valores: TDataSet read GetValores write SetValores;
    property Inversor: TInversorCartera read FInversor write SetInversor;
  end;

implementation

{$R *.dfm}

uses UtilException, dmCartera,
  dmMensajeria, fmCerrarPosicion, dmBrokerCartera, UtilForms, dmCuenta,
  fmMultiCerrarPosicion, dmBroker, UtilColors, dmConfiguracion,
  fmScriptError, dmEstrategiaInterpreter;

resourcestring
  TITULO_CARTERA = 'Cartera';
  MENSAJE_CARTERA = 'Se han acabado de calcular los posibles posicionamientos';
  NINGUN_CERRAR_STOPS = 'No se cerrará ninguna posición abierta porque no hay ningún valor con el stop roto';

{ TfCuentaCartera }

procedure TfCuentaCartera.BuscarPosicionesExecute(Sender: TObject);
var fScriptError: TfScriptError;
  OIDEstrategia, numPosiciones: integer;

  function getFormParent: TForm;
  var c: TWinControl;
  begin
    c := Parent;
    while not (c is TForm) do
      c := c.Parent;
    result := TForm(c);
  end;
begin
  FEstaCalculando := true;
  try
    lbLog.Visible := false;
    lbLog.Clear;
    pcPosiblePosicionamiento.ActivePage := tsCalculando;
    pcPosiblePosicionamiento.Repaint;
    try
      BuscarPosiciones.Enabled := false;
      Posicionar.Enabled := false;
      PosicionarTodos.Enabled := false;
      try
        frCalculando.Start;
        OIDEstrategia := Inversor.qEstrategiasOID_ESTRATEGIA.Value;
        Inversor.OIDEstrategia := OIDEstrategia;
        try
          Inversor.BuscarPosiciones(cbCuando.ItemIndex = 0, false);
          pcPosiblePosicionamiento.ActivePage := tsResultado;
          if not getFormParent.Visible then
            Mensajeria.MostrarMensaje(TITULO_CARTERA, MENSAJE_CARTERA);
        except
          on e: EScriptExecution do begin
            fScriptError := TfScriptError.Create(nil, e, OIDEstrategia, e.tipoEstrategia);
            try
              fScriptError.ShowModal;
            finally
              fScriptError.Free;
            end;
            pcPosiblePosicionamiento.ActivePage := tsInicial;
          end;
        end;
      finally
        frCalculando.Stop;
        BuscarPosiciones.Enabled := true;
        if dbgPosiciones.DataSource.DataSet.IsEmpty then begin
          numPosiciones := 0;
        end
        else begin
          Posicionar.Enabled := true;
          PosicionarTodos.Enabled := true;
          numPosiciones := dbgPosiciones.DataSource.DataSet.RecordCount;
        end;
        lNumPosibles.Caption := IntToStr(numPosiciones);
      end;
    except
      on e: EAbort do begin
        ShowMessage(e.Message);
        pcPosiblePosicionamiento.ActivePage := tsInicial;
      end;
{      on e: EJvInterpreterError do begin
        lbLog.Visible := true;
        lbLog.Items.Add('Error al calcularse el valor ' + e.GetInfo('Nombre') + ' + - ' +
          e.GetInfo('Simbolo') + '(' + e.GetInfo('OIDValor') + ') del mercado ' +
          e.GetInfo('Mercado'));
        lbLog.Items.Add(e.Message);
        pcPosiblePosicionamiento.ActivePage := tsInicial;
      end;}
    end;
  finally
    FEstaCalculando := false;
  end;
end;

procedure TfCuentaCartera.BuscarPosicionesUpdate(Sender: TObject);
begin
  inherited;
  BuscarPosiciones.Enabled := not FInversor.qEstrategias.IsEmpty;
end;

procedure TfCuentaCartera.CerrarPosicionExecute(Sender: TObject);
var form: TfCerrarPosicion;
  Cartera: TCartera;
begin
  inherited;
  form := TfCerrarPosicion.Create(Self);
  try
    Cartera := Inversor.Cartera;
    form.OIDMonedaBase := Cartera.OIDMoneda;
    form.Precio := Cartera.PosicionesAbiertasSTOP_DIARIO.Value;
    form.Comision := Cartera.PosicionesAbiertasCOMISION.Value / 2;
    form.OIDValor := Cartera.PosicionesAbiertasOR_VALOR.Value;
    form.NumAcciones := Cartera.PosicionesAbiertasNUM_ACCIONES.Value;
    if form.ShowModal = mrOk then begin
      Inversor.CerrarPosicion(Cartera.PosicionesAbiertasNUM_MOVIMIENTO.Value,
        form.FechaHora, form.Precio, form.Comision, form.MonedaValor);
      RepintarTotales;
    end;
  finally
    form.Free;
  end;
end;

procedure TfCuentaCartera.CerrarPosicionTodosExecute(Sender: TObject);
var form: TfMultiCerrarPosicion;
  Cartera: TCartera;
  resultado: TModalResult;
  cerrados: boolean;
begin
  inherited;
  form := TfMultiCerrarPosicion.Create(Self);
  try
    Cartera := Inversor.Cartera;
    Cartera.PosicionesAbiertas.First;
    cerrados := false;
    while not Cartera.PosicionesAbiertas.Eof do begin
      form.OIDMonedaBase := Cartera.OIDMoneda;
      form.Precio := Cartera.PosicionesAbiertasSTOP_DIARIO.Value;
      form.Comision := Cartera.PosicionesAbiertasCOMISION.Value / 2;
      form.OIDValor := Cartera.PosicionesAbiertasOR_VALOR.Value;
      resultado := form.ShowModal;
      if resultado = mrOk then begin
        cerrados := true;
        Inversor.CerrarPosicion(Cartera.PosicionesAbiertasNUM_MOVIMIENTO.Value,
          form.FechaHora, form.Precio, form.Comision, form.MonedaValor);
      end
      else
        if resultado = mrNo then
          Cartera.PosicionesAbiertas.Next
        else
          break;
    end;
  finally
    form.Free;
  end;
  if cerrados then
    RepintarTotales;
end;

procedure TfCuentaCartera.CerrarPosicionTodosUpdate(Sender: TObject);
begin
  inherited;
  CerrarPosicionTodos.Enabled := CerrarPosicion.Enabled;
end;

procedure TfCuentaCartera.CerrarPosicionUpdate(Sender: TObject);
begin
  inherited;
  CerrarPosicion.Enabled := Inversor.HayPosicionesAbiertas;
end;

procedure TfCuentaCartera.CerrarStopsExecute(Sender: TObject);
var form: TfMultiCerrarPosicion;
  Cartera: TCuenta;
  resultado: TModalResult;
  algunStop: boolean;
begin
  inherited;
  algunStop := false;
  form := TfMultiCerrarPosicion.Create(Self);
  try
    Cartera := Inversor.Cartera;
    Cartera.PosicionesAbiertas.First;
    while not Cartera.PosicionesAbiertas.Eof do begin
      if Cartera.StopRoto(tcDiaria) then begin
        algunStop := true;
        form.OIDMonedaBase := Cartera.OIDMoneda;
        form.Precio := Cartera.PosicionesAbiertasSTOP_DIARIO.Value;
        form.Comision := Cartera.PosicionesAbiertasCOMISION.Value / 2;
        form.OIDValor := Cartera.PosicionesAbiertasOR_VALOR.Value;
        resultado := form.ShowModal;
        if resultado = mrOk then begin
          Inversor.CerrarPosicion(Cartera.PosicionesAbiertasNUM_MOVIMIENTO.Value,
            form.FechaHora, form.Precio, form.Comision, form.MonedaValor);
        end
        else begin
          if resultado = mrNo then
            Cartera.PosicionesAbiertas.Next
          else
            break;
        end;
      end
      else
        Cuenta.PosicionesAbiertas.Next;
    end;
  finally
    form.Free;
  end;
  if algunStop then
    RepintarTotales
  else
    ShowMessage(NINGUN_CERRAR_STOPS);
end;

procedure TfCuentaCartera.CerrarStopsUpdate(Sender: TObject);
begin
  inherited;
  CerrarStops.Enabled := CerrarPosicion.Enabled;
end;

procedure TfCuentaCartera.ConfirmarExecute(Sender: TObject);
var fPosicionMercado: TfPosicionMercado;
begin
  inherited;
  fPosicionMercado := TfPosicionMercado.Create(nil);
  try
    if ShowPosicionMercado(fPosicionMercado) = mrOk then begin
      Inversor.Confirmar(fPosicionMercado.Precio, fPosicionMercado.Comision,
        fPosicionMercado.MonedaValor);
    end;
  finally
    fPosicionMercado.Free;
  end;
end;

procedure TfCuentaCartera.ConfirmarTodosExecute(Sender: TObject);
var fPosicionMercado: TfPosicionMercado;
  Broker: TBroker;
begin
  inherited;
  fPosicionMercado := TfPosicionMercado.Create(nil);
  try
    Broker := Inversor.Broker;
    Broker.qBrokerPosiciones.First;
    while not Broker.qBrokerPosiciones.Eof do begin
      if ShowPosicionMercado(fPosicionMercado) = mrOk then begin
        Inversor.Confirmar(fPosicionMercado.Precio, fPosicionMercado.Comision,
          fPosicionMercado.MonedaValor);
      end
      else
        break;
    end;
  finally
    fPosicionMercado.Free;
  end;
end;

procedure TfCuentaCartera.ConfirmarTodosUpdate(Sender: TObject);
begin
  inherited;
  ConfirmarTodos.Enabled := Confirmar.Enabled;
end;

procedure TfCuentaCartera.ConfirmarUpdate(Sender: TObject);
begin
  inherited;
  Confirmar.Enabled := Inversor.HayPosicionesMercado;
end;

constructor TfCuentaCartera.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  frCalculando.OnCancelar := OnCancelar;
  pcPosiblePosicionamiento.ActivePageIndex := 0;
  pcPosiciones.ActivePageIndex := 0;
  Configuracion.Grids.LoadColumns(dbgPosicionesMercado);
end;

procedure TfCuentaCartera.dbgPosicionesGetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; Highlight: Boolean);
var g: TJvDBUltimGrid;
begin
  inherited;
  g := Sender as TJvDBUltimGrid;
  DefaultCellColors(g, Field, Afont, Background);
  if g.Row = g.CurrentDrawRow then begin
    AFont.Style := [fsBold];
    Background :=  IncreaseColor(Background);
  end;
end;

procedure TfCuentaCartera.dbgPosicionesMercadoGetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; Highlight: Boolean);
var g: TJvDBUltimGrid;
begin
  inherited;
  g := Sender as TJvDBUltimGrid;
  DefaultCellColors(g, Field, Afont, Background);
  if g.Row = g.CurrentDrawRow then begin
    AFont.Style := [fsBold];
    Background := IncreaseColor(Background);
  end;
end;

procedure TfCuentaCartera.DescartarExecute(Sender: TObject);
begin
  inherited;
  Inversor.Descartar;
end;

procedure TfCuentaCartera.DescartarTodosExecute(Sender: TObject);
begin
  inherited;
  Inversor.DescartarTodos;
end;

procedure TfCuentaCartera.DescartarTodosUpdate(Sender: TObject);
begin
  inherited;
  DescartarTodos.Enabled := Inversor.HayPosicionesMercado;
end;

procedure TfCuentaCartera.DescartarUpdate(Sender: TObject);
begin
  inherited;
  Descartar.Enabled := Inversor.HayPosicionesMercado;
end;

destructor TfCuentaCartera.Destroy;
begin
  if tsPosicionesPendientes.Visible then
    Configuracion.Grids.SaveColumns(dbgPosicionesMercado);
  inherited;
end;

procedure TfCuentaCartera.eNombreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
    FInversor.Cartera.qCartera.Post;
end;

function TfCuentaCartera.EstaCalculando: boolean;
begin
  result := FEstaCalculando;
end;

procedure TfCuentaCartera.EstrategiasChange(Sender: TObject);
begin
  inherited;
  Estrategias.Hint := Inversor.qEstrategiasDESCRIPCION.Value;
end;

function TfCuentaCartera.GetValores: TDataSet;
begin
  result := Inversor.Valores;
end;

procedure TfCuentaCartera.GridPosicionDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var Canvas: TCanvas;
begin
  if (Column.FieldName = 'OPERACION') and (not Column.Field.IsNull) then begin
    Canvas := (Sender as TDBGrid).Canvas;
    Canvas.FillRect(Rect);
    if Column.Field.AsString = 'C' then
      Canvas.Draw(Rect.Left + 2, Rect.Top + 4, iLargo.Picture.Graphic)
    else
      Canvas.Draw(Rect.Left + 3, Rect.Top + 4, iCorto.Picture.Graphic);
  end
  else
    inherited;
end;

procedure TfCuentaCartera.OnCancelar;
begin
  Inversor.CancelarBusquedaPosiciones;
end;


procedure TfCuentaCartera.PosicionarExecute(Sender: TObject);
begin
  inherited;
  if not Inversor.Posicionar then
    ShowMensaje('Posicionar', 'No se ha podido posicionar el valor porque ' +
      'no hay suficiente saldo en el paquete a invertir.', mtWarning, [mbOk]);
end;

procedure TfCuentaCartera.PosicionarTodosExecute(Sender: TObject);
begin
  inherited;
  if not Inversor.PosicionarTodos then
    ShowMensaje('Posicionar', 'No se ha podido posicionar alguno de los valores porque ' +
      'no hay suficiente saldo en el paquete a invertir.', mtWarning, [mbOk]);
end;

procedure TfCuentaCartera.SetInversor(const Value: TInversorCartera);
begin
  FInversor := Value;
  Cuenta := FInversor.Cartera;
  dsCuentaMovimientos.DataSet := Cuenta.CuentaMovimientos;
  dsCurvaCapital.DataSet := Cuenta.CurvaCapital;
  dsPosicionesCerradas.DataSet := Cuenta.PosicionesCerradas;
  dsPosicionesAbiertas.DataSet := Cuenta.PosicionesAbiertas;
  dsCartera.DataSet := FInversor.Cartera.qCartera;
end;

procedure TfCuentaCartera.SetValores(const Value: TDataSet);
begin
  Inversor.Valores := Value;
end;

function TfCuentaCartera.ShowPosicionMercado(
  const fPosicionMercado: TfPosicionMercado): TModalResult;
var
  Broker: TBrokerCartera;
  OIDValor, num: integer;
begin
  Broker := Inversor.Broker as TBrokerCartera;
  fPosicionMercado.Precio := Broker.qBrokerPosicionesCAMBIO.Value;
  fPosicionMercado.NumAcciones := Broker.qBrokerPosicionesNUM_ACCIONES.Value;
  fPosicionMercado.OIDMoneda := Broker.Cuenta.OIDMoneda;
  OIDValor := Broker.qBrokerPosicionesOR_VALOR.Value;
  num := Broker.qBrokerPosicionesNUM_ACCIONES.Value;
  fPosicionMercado.Comision := Broker.GetComision(OIDValor, num,
    num * Broker.qBrokerPosicionesCAMBIO.Value,
    Broker.qBrokerPosicionesOPERACION.Value = 'C', true);
  // IMPORTANTE!! La asignación a OIDValor se debe hacer siempre después de la de OIDMoneda
  fPosicionMercado.OIDValor := OIDValor;
  result := fPosicionMercado.ShowModal;
end;

end.
