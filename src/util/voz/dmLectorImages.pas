unit dmLectorImages;

interface

uses
  SysUtils, Classes, ImgList, Controls;

type
  TLectorImages = class(TDataModule)
    ImageListVoz: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LectorImages: TLectorImages;

implementation

{$R *.dfm}

end.
