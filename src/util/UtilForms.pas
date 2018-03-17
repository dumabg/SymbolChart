unit UtilForms;

interface

uses Forms, Controls, Classes, JvCaptionButton, Dialogs, ActnList;

type
  TCaptionButtons = set of (cbAlwaysOnTop, cbMaximize);

  TActionForm = class(TComponent)
  private
    Action: TAction;
    Form: TForm;
    FormClass: TFormClass;
    procedure OnExecute(Sender: TObject);
  public
    constructor Create(const AOwner: TComponent; const Action: TAction; const FormClass: TFormClass); reintroduce;
    destructor Destroy; override;
  end;

  function CreateUniqueForm(const formClass: TFormClass; const Owner: TComponent; const name: string): TForm; overload;
  function CreateUniqueForm(const formClass: TFormClass; const Owner: TComponent): TForm; overload;
  function ShowFormModal(const formClass: TFormClass): TModalResult; overload;
  function ShowFormModal(const formClass: TFormClass; const Owner: TComponent): TModalResult; overload;
  function ShowForm(const formClass: TFormClass; const Owner: TComponent; const name: string): TForm; overload;
  function ShowForm(const formClass: TFormClass; const Owner: TComponent): TForm; overload;
  function FindForm(const Owner: TComponent; const name: string): TForm;

  procedure MaximizeRestoreCaptionButton(Form: TCustomForm;
    JvCaptionButton: TJvCaptionButton);

  procedure DrawRounded(Control: TWinControl);

  procedure AddCaptionButtons(const Form: TForm; const buttons: TCaptionButtons);

  function ShowMensaje(const titulo, mensaje: string;
    const DlgType: TMsgDlgType; const Buttons: TMsgDlgButtons): integer;


implementation

uses Windows, Messages, dmRecursosListas, SysUtils;

type
  TCaptionButton = class(TJvCaptionButton)
  protected
    procedure OnClickEvent(Sender: TObject); virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TCaptionButtonAlwaysOnTop = class(TCaptionButton)
  protected
    procedure OnClickEvent(Sender: TObject); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TCaptionButtonMaximize = class(TCaptionButton)
  protected
    procedure OnClickEvent(Sender: TObject); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  procedure AddCaptionButtons(const Form: TForm; const buttons: TCaptionButtons);
  var pos: integer;
  begin
    pos := 0;
    if cbMaximize in buttons then begin
      TCaptionButtonMaximize.Create(Form).Position := pos;
      inc(pos);
    end;
    if cbAlwaysOnTop in buttons then
      TCaptionButtonAlwaysOnTop.Create(Form).Position := pos;
  end;

  procedure MaximizeRestoreCaptionButton(Form: TCustomForm;
    JvCaptionButton: TJvCaptionButton);
  var R:TRect;
    Tasklist : HWnd;
  begin
    if Form.WindowState = wsMaximized then begin
      Form.WindowState := wsNormal;
      JvCaptionButton.Standard := tsbMax;
    end
    else begin
      Form.WindowState := wsMaximized;
      JvCaptionButton.Standard := tsbRestore;
      // Al maximizar la barra de windows tapa un trozo. Se modifica el Height
      // para que vaya por encima de la barra de windows.
      Tasklist := FindWindow('Shell_TrayWnd', nil);
      GetWindowRect(Tasklist, R);
      Form.Height := Form.Height - (R.Bottom - R.Top) - 2;
    end;
  end;


  procedure DrawRounded(Control: TWinControl);
  var
     R: TRect;
     Rgn: HRGN;
  begin
     with Control do
     begin
       R := ClientRect;
       rgn := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, 20, 20) ;
       Perform(EM_GETRECT, 0, lParam(@r)) ;
       InflateRect(r, - 4, - 4) ;
       Perform(EM_SETRECTNP, 0, lParam(@r)) ;
       SetWindowRgn(Handle, rgn, True) ;
       Invalidate;
     end;
  end;

  function ShowFormModal(const formClass: TFormClass; const Owner: TComponent): TModalResult;
  var form: TForm;
  begin
    Screen.Cursor := crHourGlass;
    try
      form := formClass.Create(Owner);
      try
        Screen.Cursor := crDefault;
        result := form.ShowModal;
      finally
        form.Free;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;

  function ShowFormModal(const formClass: TFormClass): TModalResult;
  begin
    result := ShowFormModal(formClass, nil);
  end;

  function FindForm(const Owner: TComponent; const name: string): TForm;
  begin
    result := Owner.FindComponent(name) as TForm;
  end;

  function ShowForm(const formClass: TFormClass; const Owner: TComponent): TForm;
  begin
    result := ShowForm(formClass, Owner, formClass.ClassName);
  end;

  function ShowForm(const formClass: TFormClass; const Owner: TComponent; const name: string): TForm;
  var form: TForm;
  begin
    Screen.Cursor := crHourGlass;
    try
      form := CreateUniqueForm(formClass, Owner, name);
      form.Show;
    finally
      Screen.Cursor := crDefault;
    end;
    result := form;
  end;

  function CreateUniqueForm(const formClass: TFormClass; const Owner: TComponent; const name: string): TForm;
  var form: TForm;
  begin
      form := Owner.FindComponent(name) as TForm;
      if form = nil then begin
        form := formClass.Create(Owner);
        form.Name := name;
      end;
      result := form;
  end;

  function CreateUniqueForm(const formClass: TFormClass; const Owner: TComponent): TForm;
  begin
    result := CreateUniqueForm(formClass, Owner, formClass.ClassName);
  end;

  function ShowMensaje(const titulo, mensaje: string;
    const DlgType: TMsgDlgType; const Buttons: TMsgDlgButtons): integer;
  var flag: integer;
  begin
    case DlgType of
      mtWarning: flag := MB_ICONWARNING;
      mtError: flag := MB_ICONERROR;
      mtInformation: flag := MB_ICONINFORMATION;
      mtConfirmation: flag := MB_ICONQUESTION;
      else
        raise Exception.Create('DlgType not supported');
    end;
    if Buttons = mbYesNo then
      flag := flag + MB_YESNO
    else
      if Buttons = [mbOK] then
        flag := flag + MB_OK
      else
        flag := flag + MB_YESNOCANCEL;

    result := Application.MessageBox(PChar(mensaje), PChar(titulo), flag);
  end;

{ TCaptionButtonAlwaysOnTop }

constructor TCaptionButtonAlwaysOnTop.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Images := RecursosListas.ImageListAlwaysOnTop;
  ImageIndex := 0;
end;

procedure TCaptionButtonAlwaysOnTop.OnClickEvent(Sender: TObject);
var Form: TForm;
begin
  Form := Owner as TForm;
  if Form.FormStyle = fsNormal then begin
    Form.FormStyle := fsStayOnTop;
    Standard := tsbMinimizeToTray;
  end
  else begin
    Form.FormStyle := fsNormal;
    Standard := tsbNone;
  end;
end;

{ TCaptionButton }

constructor TCaptionButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  OnClick := OnClickEvent;
end;

{ TCaptionButtonMaximize }

constructor TCaptionButtonMaximize.Create(AOwner: TComponent);
var Form: TForm;
begin
  inherited Create(AOwner);
  Form := AOwner as TForm;
  if Form.WindowState = wsMaximized then
    Standard := tsbRestore
  else
    Standard := tsbMax;
end;

procedure TCaptionButtonMaximize.OnClickEvent(Sender: TObject);
begin
  MaximizeRestoreCaptionButton(Owner as TForm, Self);
end;


{ TActionForm }

constructor TActionForm.Create(const AOwner: TComponent; const Action: TAction;
  const formClass: TFormClass);
begin
  inherited Create(AOwner);
  Self.FormClass := FormClass;
  Self.Action := Action;
  Action.OnExecute := OnExecute;
  if Action.Checked then
    OnExecute(nil);
end;

destructor TActionForm.Destroy;
begin
  if Form <> nil then
    Form.Free;
  inherited;
end;

procedure TActionForm.OnExecute(Sender: TObject);
begin
  if Form = nil then begin
    Form := FormClass.Create(nil);
    Form.Show;
    Action.Checked := true;
  end
  else begin
    FreeAndNil(Form);
    Action.Checked := False;
  end;
end;

end.
