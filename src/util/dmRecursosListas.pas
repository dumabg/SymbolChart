unit dmRecursosListas;

interface

uses
  SysUtils, Classes, ImgList, Controls, dmThreadDataModule;

type
  TRecursosListas = class(TThreadDataModule)
    ImageList: TImageList;
    ImageListAlwaysOnTop: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RecursosListas: TRecursosListas;

implementation

{$R *.dfm}

end.
