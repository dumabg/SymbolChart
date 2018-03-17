unit fmBrokers;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBaseMasterDetalle, DBActns, ActnList, DB, Grids, DBGrids, JvExDBGrids,
  JvDBGrid, JvDBUltimGrid, ExtCtrls,
  JvExExtCtrls, JvNetscapeSplitter, dmBrokers, StdCtrls, DBCtrls, JvExStdCtrls,
  JvHtControls, TB2Item,
  SpTBXItem, TB2Dock, TB2Toolbar, JvGIF;

type
  TfBrokers = class(TfBaseMasterDetalle)
    TBXToolbar2: TSpTBXToolbar;
    gComisiones: TJvDBUltimGrid;
    dsBrokerComision: TDataSource;
    ActionListComision: TActionList;
    CopiarTodos: TAction;
    BorrarComision: TAction;
    BorrarTodosComision: TAction;
    TBXItem3: TSpTBXItem;
    TBXItem4: TSpTBXItem;
    TBXItem5: TSpTBXItem;
    TBXSeparatorItem1: TSpTBXSeparatorItem;
    Entrada: TDBMemo;
    MaximoEntrada: TDBMemo;
    MinimoEntrada: TDBMemo;
    Salida: TDBMemo;
    MaximoSalida: TDBMemo;
    MinimoSalida: TDBMemo;
    pInfo: TPanel;
    Image1: TImage;
    JvHTLabel1: TJvHTLabel;
    JvHTLabel2: TJvHTLabel;
    JvHTLabel3: TJvHTLabel;
    CopiarES: TAction;
    CopiarSE: TAction;
    TBXItem6: TSpTBXItem;
    TBXItem7: TSpTBXItem;
    Copiar: TAction;
    Pegar: TAction;
    TBXItem8: TSpTBXItem;
    TBXItem9: TSpTBXItem;
    TBXSeparatorItem2: TSpTBXSeparatorItem;
    Comprobar: TAction;
    TBXSeparatorItem3: TSpTBXSeparatorItem;
    TBXItem10: TSpTBXItem;
    procedure FormCreate(Sender: TObject);
    procedure BorrarTodosComisionExecute(Sender: TObject);
    procedure BorrarComisionExecute(Sender: TObject);
    procedure CopiarTodosExecute(Sender: TObject);
    procedure CopiarESExecute(Sender: TObject);
    procedure CopiarSEExecute(Sender: TObject);
    procedure AnadirExecute(Sender: TObject);
    procedure CopiarExecute(Sender: TObject);
    procedure PegarExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComprobarExecute(Sender: TObject);
    procedure BorrarExecute(Sender: TObject);
  private
    Brokers: TBrokers;
  public
    { Public declarations }
  end;


implementation

uses fmNuevoBroker, UtilForms;

resourcestring
  BROKER_NO_BORRADO_ESTUDIOS =  'No se puede borrar el broker porque está siendo utilizado ' +
      'en los siguientes estudios: ' + sLineBreak + '%s';
  BROKER_NO_BORRADO_CARTERAS = 'No se puede borrar el broker porque está siendo utilizado ' +
      'en las siguientes carteras: ' + sLineBreak + '%s';
  TITULO_BORRAR = 'Borrar broker';
  MENSAJE_BORRAR = '¿Confirma borrar el broker %s?';
  MENSAJE_TODO_CORRECTO = 'Todo correcto';
  MENSAJE_ERROR_FORMULA = 'Error en la fórmula: %s' + sLineBreak + sLineBreak +
        'Mercado: %s' + sLineBreak + 'Columna: %s';

{$R *.dfm}

procedure TfBrokers.AnadirExecute(Sender: TObject);
var fNuevoBroker: TfNuevoBroker;
begin
  fNuevoBroker := TfNuevoBroker.Create(Self);
  try
    if fNuevoBroker.ShowModal = mrOk then
      Brokers.AnadirBroker(fNuevoBroker.Nombre);
  finally
    fNuevoBroker.Free;
  end;
end;

procedure TfBrokers.BorrarComisionExecute(Sender: TObject);
begin
  inherited;
  Brokers.Borrar;
end;

procedure TfBrokers.BorrarExecute(Sender: TObject);
var msg: string;
begin
  if ShowMensaje(TITULO_BORRAR, Format(MENSAJE_BORRAR, [Brokers.qBrokerNOMBRE.Value]),
    mtConfirmation, [mbYes, mbNo]) = mrYes then begin
    if not Brokers.BorrarBroker then begin
      if not Brokers.qBrokerCartera.IsEmpty then begin
        Brokers.qBrokerCartera.First;
        msg := '';
        while not Brokers.qBrokerCartera.Eof do begin
          msg := msg + sLineBreak + '   ' + Brokers.qBrokerCarteraNOMBRE.Value;
          Brokers.qBrokerCartera.Next;
        end;
        msg := Format(BROKER_NO_BORRADO_CARTERAS, [msg]);
        ShowMessage(msg);
      end;

      if not Brokers.qBrokerEstudios.IsEmpty then begin
        Brokers.qBrokerEstudios.First;
        msg := '';
        while not Brokers.qBrokerEstudios.Eof do begin
          msg := msg + sLineBreak + '   ' + Brokers.qBrokerEstudiosNOMBRE.Value;
          Brokers.qBrokerEstudios.Next;
        end;
        msg := Format(BROKER_NO_BORRADO_ESTUDIOS, [msg]);
        ShowMessage(msg);
      end;
    end;
  end;
end;

procedure TfBrokers.BorrarTodosComisionExecute(Sender: TObject);
begin
  inherited;
  Brokers.BorrarTodo;
end;

procedure TfBrokers.ComprobarExecute(Sender: TObject);
var i: integer;
begin
  inherited;
  try
    Brokers.Comprobar;
    ShowMessage(MENSAJE_TODO_CORRECTO);
  except
    on e: EComprobar do begin
      // Nos posicionamos en la fila-columna donde se ha producido el error
      for i := 0 to gComisiones.Columns.Count - 1 do begin
        if gComisiones.Columns[i].Field = e.Columna then begin
          gComisiones.Col := i + 1;
          break;
        end;
      end;
      ShowMessage(Format(MENSAJE_ERROR_FORMULA,
        [e.Message, e.Mercado, e.Columna.DisplayLabel]));
    end;
  end;
end;

procedure TfBrokers.CopiarESExecute(Sender: TObject);
begin
  inherited;
  //Al pasar el foco a otro componente, hace un post automáticamente si se estuviera editando
  gMaster.SetFocus;
  Brokers.CopiarES;
end;

procedure TfBrokers.CopiarExecute(Sender: TObject);
begin
  inherited;
  //Al pasar el foco a otro componente, hace un post automáticamente si se estuviera editando
  gMaster.SetFocus;
  Brokers.Copiar;
  Pegar.Enabled := true;
end;

procedure TfBrokers.CopiarSEExecute(Sender: TObject);
begin
  inherited;
  //Al pasar el foco a otro componente, hace un post automáticamente si se estuviera editando
  gMaster.SetFocus;
  Brokers.CopiarSE;
end;

procedure TfBrokers.CopiarTodosExecute(Sender: TObject);
begin
  inherited;
  //Al pasar el foco a otro componente, hace un post automáticamente si se estuviera editando
  gMaster.SetFocus;
  Brokers.CopiarTodos;
end;

procedure TfBrokers.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  //Al pasar el foco a otro componente, hace un post automáticamente si se estuviera editando
  if gMaster.Enabled then
    gMaster.SetFocus;
end;

procedure TfBrokers.FormCreate(Sender: TObject);
begin
  inherited;
  Brokers := TBrokers.Create(Self);
end;

procedure TfBrokers.PegarExecute(Sender: TObject);
begin
  inherited;
  //Al pasar el foco a otro componente, hace un post automáticamente si se estuviera editando
  gMaster.SetFocus;
  Brokers.Pegar;
end;

end.
