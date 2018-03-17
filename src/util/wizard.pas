unit wizard;

interface

uses Controls, Classes, Forms;

type
  TWizard = class;

  IWizardPage = interface;

  // Simula una interface (amb interfaces peta),
  // que podrà cridar la pàgina per comunicarse amb el wizard
  TWizardMethods = class
  private
    wizard: TWizard;
    constructor Create(wizard: TWizard);
  public
    procedure NextPage;
    procedure PreviousPage;
    procedure FirstPage;
    procedure LastPage;
    procedure Close;
    function getPreviousPage: TForm;
    procedure AddWizardPage(const page: IWizardPage);
    procedure GotoPage(const page: IWizardPage);
    function getPage(const index: integer): TForm;
  end;

  // Simula una interface que ha d'implementar la pàgina
  IWizardPage = interface
    procedure setWizardMethods(const wizardMethods: TWizardMethods);
    function getForm: TForm;
  end;

  TOnCloseEvent = procedure of object;

  TWizard = class(TObject)
  private
    wizardMethods: TWizardMethods;
    pages: TInterfaceList;
    position: integer;
    FContainer: TWinControl;
    FOnClose: TOnCloseEvent;
    procedure CleanContainer;
    function getForm(const pageNumber: integer): TForm;
    procedure ShowPage(const pageNumber: integer);
  public
    destructor Destroy; override;
    constructor Create(const Container: TWinControl); reintroduce;
    procedure NextPage;
    procedure PreviousPage;
    procedure FirstPage;
    procedure LastPage;
    function getPreviousPage: TForm;
    procedure AddWizardPage(const page: IWizardPage);
    procedure GotoPage(const page: IWizardPage);
    procedure CanClose(var CanClose: boolean);
    property OnClose: TOnCloseEvent read FOnClose write FOnClose;
  end;

implementation

{ TWizard }

procedure TWizard.AddWizardPage(const page: IWizardPage);
begin
  pages.Add(page);
  page.setWizardMethods(wizardMethods);
end;


procedure TWizard.CanClose(var CanClose: boolean);
var form: TForm;
begin
  form := getForm(position);
  if Assigned(form.OnCloseQuery) then
    form.OnCloseQuery(Self, CanClose);
end;

procedure TWizard.CleanContainer;
begin
  if FContainer.ControlCount > 0 then
    FContainer.RemoveControl(FContainer.Controls[0]);
end;

constructor TWizard.Create(const Container: TWinControl);
begin
  inherited Create;
  pages := TInterfaceList.Create;
  wizardMethods := TWizardMethods.Create(Self);
  position := 0;
  FContainer := Container;
end;


destructor TWizard.Destroy;
begin
  wizardMethods.Free;
  pages.Free;
  inherited;
end;

procedure TWizard.FirstPage;
begin
  ShowPage(0);
end;

function TWizard.getForm(const pageNumber: integer): TForm;
begin
  result := IWizardPage(pages[pageNumber]).getForm;
end;

function TWizard.getPreviousPage: TForm;
begin
  if position > 0 then begin
    result := getForm(position - 1);
  end
  else
    result := nil;
end;

procedure TWizard.GotoPage(const page: IWizardPage);
var i: integer;
begin
  for i := 0 to pages.Count - 1 do begin
    if IWizardPage(pages[i]).getForm = page.getForm then begin
      position := i;
      ShowPage(position);
      exit;
    end;
  end;
end;

procedure TWizard.LastPage;
begin
  ShowPage(pages.Count - 1);
end;

procedure TWizard.NextPage;
begin
  if position < pages.Count - 1 then begin
    inc(position);
    ShowPage(position);
  end;
end;

procedure TWizard.PreviousPage;
begin
  if position > 0 then begin
    dec(position);
    ShowPage(position);
  end;
end;

procedure TWizard.ShowPage(const pageNumber: integer);
var form: TForm;
begin
  form := getForm(pageNumber);
  CleanContainer;
  form.Parent := FContainer;
  form.BorderStyle := bsNone;
  form.Align := alClient;
  form.Show;
end;


{ TWizardMethods }

procedure TWizardMethods.AddWizardPage(const page: IWizardPage);
begin
  wizard.AddWizardPage(page);
end;

procedure TWizardMethods.Close;
begin
  if Assigned(wizard.FOnClose) then
    wizard.FOnClose;
end;

constructor TWizardMethods.Create(wizard: TWizard);
begin
  Self.wizard := wizard;
end;

procedure TWizardMethods.FirstPage;
begin
  wizard.FirstPage;
end;

function TWizardMethods.getPage(const index: integer): TForm;
begin
  result := wizard.getForm(index);
end;

function TWizardMethods.getPreviousPage: TForm;
begin
  result := wizard.getPreviousPage;
end;

procedure TWizardMethods.GotoPage(const page: IWizardPage);
begin
  wizard.GotoPage(page);
end;

procedure TWizardMethods.LastPage;
begin
  wizard.LastPage;
end;

procedure TWizardMethods.NextPage;
begin
  wizard.NextPage;
end;

procedure TWizardMethods.PreviousPage;
begin
  wizard.PreviousPage;
end;

end.
