unit fmEditFS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, ExtCtrls, JvExExtCtrls, JvNetscapeSplitter, frEditFS,
  VirtualTrees, frFS;

type
  TfEditableFS = class(TfBase)
    pDetalle: TPanel;
    Splitter: TJvNetscapeSplitter;
    fFS: TfEditFS;
    procedure fFSTreeFSChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure fFSTreeFSStateChange(Sender: TBaseVirtualTree; Enter,
      Leave: TVirtualTreeStates);
  private
  protected
    procedure LoadFile(const OIDFile: integer); virtual; abstract;
  public
  end;

  //Para saber o hacer algo cuando se añade un fichero o una carpeta, se realiza
  //en el FS, no en la parte visual (esta parte). Esta parte visual necesita de
  //un FS para manipular. El FS a manipular se le pasa, por lo que pueden sobrecargarse
  //las funciones necesarias para saber lo que se añade en cada momento.
  //Ejemplo: dmConsultas 

implementation

{$R *.dfm}

procedure TfEditableFS.fFSTreeFSChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var isFile: boolean;
begin
  inherited;
  if Node = nil then
    pDetalle.Visible := false
  else begin
    isFile := fFS.IsFocusedFile;
    pDetalle.Visible := isFile;
    if isFile then
      LoadFile(fFS.OIDNodeFocused);
  end;
end;

procedure TfEditableFS.fFSTreeFSStateChange(Sender: TBaseVirtualTree; Enter,
  Leave: TVirtualTreeStates);
var isFile: boolean;
begin
  inherited;
  isFile := fFS.IsFocusedFile;
  pDetalle.Visible := isFile;
end;

end.
