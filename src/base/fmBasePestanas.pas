unit fmBasePestanas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, ComCtrls, JvExComCtrls, JvComCtrls;

type
  TFrameClass = class of TFrame;

  // Crea las pestañas al vuelo a partir de frames
  TfBasePestanas = class(TfBase)
    PageControl: TJvPageControl;
  private
    FrameClasses: array of TFrameClass;
    Frames: array of TFrame;
    procedure TabSheetShow(Sender: TObject);
  public
    procedure AnadirPestana(const nombre: string; const frameClass: TFrameClass);
  end;


implementation

{$R *.dfm}

{ TfBasePestanas }

procedure TfBasePestanas.AnadirPestana(const nombre: string;
  const frameClass: TFrameClass);
var ts: TTabSheet;
  i: integer;
begin
  ts := TTabSheet.Create(Self);
  ts.PageControl := PageControl;
  ts.Caption := nombre;
  i := ts.PageIndex; //zero based
  if Length(FrameClasses) <= i then
    SetLength(FrameClasses, Length(FrameClasses) + 1);
  FrameClasses[i] := frameClass;
  ts.OnShow := TabSheetShow;
end;

procedure TfBasePestanas.TabSheetShow(Sender: TObject);
var i: integer;
  frame: TFrame;
  ts: TTabSheet;
begin
  ts := TTabSheet(Sender);
  i := ts.PageIndex; //zero based
  if Frames[i] = nil then begin
    frame := FrameClasses[i].Create(Self);
    frame.Parent := ts;
    frame.Align := alClient;
    frame.Visible := true;
    Frames[i] := frame;
  end;
end;

end.
