unit imagesMensajesPanel;

interface

uses mensajesPanel, ImgList, Classes;

type
  TImagesMensajesPanel = class(TMensajesPanel)
  private
    FImagesCount: integer;
    FImages: TCustomImageList;
    FImageChangeLink: TChangeLink;
    procedure SetImages(const Value: TCustomImageList);
    procedure ImageListChange(Sender: TObject);
    procedure ImageRequest(Sender: TObject; const SRC: string; var Stream: TMemoryStream);
  protected
    function GetTitulo(const titulo: string; const tipo: integer): string; //override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Images: TCustomImageList read FImages write SetImages;
  end;

implementation

uses SysUtils, Graphics;
{ TImagesMensajesPanel }

constructor TImagesMensajesPanel.Create(AOwner: TComponent);
begin
  inherited;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  OnImageRequest := ImageRequest;
end;

destructor TImagesMensajesPanel.Destroy;
begin
  FImageChangeLink.Free;
  inherited;
end;

function TImagesMensajesPanel.GetTitulo(const titulo: string;
  const tipo: integer): string;
var i: integer;
begin
//  result := inherited GetTitulo(titulo, tipo);
  for i := FImagesCount downto 0 do begin
    result := '<img src="' + IntToStr(i) + '" alt="reproducir"> ' + result;
  end;
end;

procedure TImagesMensajesPanel.ImageListChange(Sender: TObject);
begin
  FImagesCount := FImages.Count - 1;
  ChangeData;
end;

procedure TImagesMensajesPanel.ImageRequest(Sender: TObject; const SRC: string;
  var Stream: TMemoryStream);
var i: integer;
  bitmap: TBitmap;
begin
  i := StrToInt(src);
  bitmap := TBitmap.Create;
  try
    FImages.GetBitmap(i, bitmap);
    Stream := TMemoryStream.Create;
    bitmap.SaveToStream(Stream);
  finally
    bitmap.Free;
  end;
end;

procedure TImagesMensajesPanel.SetImages(const Value: TCustomImageList);
begin
  if FImages <> nil then FImages.UnRegisterChanges(FImageChangeLink);
  FImages := Value;
  FImagesCount := FImages.Count - 1;
  if FImages <> nil then
  begin
    FImages.RegisterChanges(FImageChangeLink);
    FImages.FreeNotification(Self);
  end
end;

end.
