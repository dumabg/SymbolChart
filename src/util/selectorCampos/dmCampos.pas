unit dmCampos;

interface

uses
  SysUtils, Classes, DBCtrls, Forms, DB, Contnrs, Controls, dmThreadDataModule,
  uPanel;

type
  TCampo = class
    Control: TDBText;
    Field: TField;
    Caption: string;
  end;

  TOnFoundControl = procedure (const container: TfrPanel; const control: TDBText; var accept: boolean) of object;

  TCampos = class(TThreadDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    Campos, Selecteds: TObjectList;
    FOnFoundControl: TOnFoundControl;
    function GetCampo(i: integer): TCampo;
    function GetSelected(i: integer): TCampo;
    function GetSelectedCount: integer;
    function GetCount: integer;
    function GetHint(const control: TControl): string;
  public
    procedure Search(const container: TfrPanel);
    procedure Select(const Caption: string);
    procedure Unselect(const Caption: string);
    procedure UnselectAll;
    property OnFoundControl: TOnFoundControl read FOnFoundControl write FOnFoundControl;
    property Campo[i: integer]: TCampo read GetCampo; default;
    property Count: integer read GetCount;
    property Selected[i: integer]: TCampo read GetSelected;
    property SelectedCount: integer read GetSelectedCount;
  end;


implementation

{$R *.dfm}

{ TCampos }


procedure TCampos.DataModuleCreate(Sender: TObject);
begin
  Campos := TObjectList.Create;
  Selecteds := TObjectList.Create;
  Selecteds.OwnsObjects := false;
end;

procedure TCampos.DataModuleDestroy(Sender: TObject);
begin
  Campos.Free;
  Selecteds.Free;
end;


function TCampos.GetCampo(i: integer): TCampo;
begin
  result := TCampo(Campos.Items[i]);
end;


function TCampos.GetCount: integer;
begin
  result := Campos.Count;
end;

function TCampos.GetHint(const control: TControl): string;
var i: integer;
  hint: string;
begin
  hint := control.Hint;
  i := Pos(sLineBreak, hint);
  if i = 0 then
    i := length(hint);
  result := Trim(Copy(hint, 1, i));
end;

function TCampos.GetSelected(i: integer): TCampo;
begin
  result := TCampo(Selecteds[i]);
end;

function TCampos.GetSelectedCount: integer;
begin
  result := Selecteds.Count;
end;

procedure TCampos.Search(const container: TfrPanel);
var i: integer;
  c: TComponent;
  dbText: TDBText;
  campo: TCampo;
  accept: boolean;
begin
  for i := 0 to container.ComponentCount - 1 do begin
    c := container.Components[i];
    if c is TDBText then begin
      accept := true;
      FOnFoundControl(container, TDBText(c), accept);
      if accept then begin
        campo := TCampo.Create;
        dbText := TDBText(c);
        campo.Control := dbText;
        campo.Field := dbText.Field;
        campo.Caption := GetHint(dbText);
        Campos.Add(campo);
      end;
    end;
  end;
end;

procedure TCampos.Select(const Caption: string);
var i: integer;
begin
  for i := 0 to Campos.Count - 1 do begin
    if TCampo(Campos[i]).Caption = Caption then begin
      Selecteds.Add(Campos[i]);
      exit;
    end;
  end;
end;

procedure TCampos.Unselect(const Caption: string);
var i: integer;
begin
  for i := 0 to Selecteds.Count - 1 do begin
    if TCampo(Selecteds[i]).Caption = Caption then begin
      Selecteds.Remove(Selecteds[i]);
      exit;
    end;
  end;
end;

procedure TCampos.UnselectAll;
begin
  Selecteds.Clear;
end;

end.
