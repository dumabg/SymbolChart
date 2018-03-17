unit UtilImages;

interface

procedure CaptureScreen(AFileName : string);
procedure CaptureApplication(AFileName: string);

implementation

uses Windows, Graphics, Forms;

procedure CaptureApplication(AFileName: string);
const
  CAPTUREBLT = $40000000;
var
  hdcScreen : HDC;
  hdcCompatible : HDC;
  bmp : TBitmap;
  hbmScreen : HBITMAP;
begin
  // Create a normal DC and a memory DC for the entire screen. The
  // normal DC provides a "snapshot" of the screen contents. The
  // memory DC keeps a copy of this "snapshot" in the associated
  // bitmap.
  hdcScreen := CreateDC('DISPLAY', nil, nil, nil);
  hdcCompatible := CreateCompatibleDC(hdcScreen);
  // Create a compatible bitmap for hdcScreen.

  hbmScreen := CreateCompatibleBitmap(hdcScreen,
                       GetDeviceCaps(hdcScreen, HORZRES),
                       GetDeviceCaps(hdcScreen, VERTRES));

  // Select the bitmaps into the compatible DC.
  SelectObject(hdcCompatible, hbmScreen);
  bmp := TBitmap.Create;
  bmp.Handle := hbmScreen;
  BitBlt(hdcCompatible,
                 0,0,
                 Application.MainForm.Width, Application.MainForm.Height,
                 hdcScreen,
                 Application.MainForm.Left, Application.MainForm.Top,
                 SRCCOPY OR CAPTUREBLT);
  bmp.SaveToFile(AFileName);
  bmp.Free;
  DeleteDC(hdcScreen);
  DeleteDC(hdcCompatible);
end;

procedure CaptureScreen(AFileName : string);
const
  CAPTUREBLT = $40000000;
var
  hdcScreen : HDC;
  hdcCompatible : HDC;
  bmp : TBitmap;
  hbmScreen : HBITMAP;
begin
  // Create a normal DC and a memory DC for the entire screen. The
  // normal DC provides a "snapshot" of the screen contents. The
  // memory DC keeps a copy of this "snapshot" in the associated
  // bitmap.

  hdcScreen := CreateDC('DISPLAY', nil, nil, nil);
  hdcCompatible := CreateCompatibleDC(hdcScreen);
  // Create a compatible bitmap for hdcScreen.

  hbmScreen := CreateCompatibleBitmap(hdcScreen,
                       GetDeviceCaps(hdcScreen, HORZRES),
                       GetDeviceCaps(hdcScreen, VERTRES));

  // Select the bitmaps into the compatible DC.
  SelectObject(hdcCompatible, hbmScreen);
  bmp := TBitmap.Create;
  bmp.Handle := hbmScreen;
  BitBlt(hdcCompatible,
                 0,0,
                 bmp.Width, bmp.Height,
                 hdcScreen,
                 0,0,
                 SRCCOPY OR CAPTUREBLT);
  bmp.SaveToFile(AFileName);
  bmp.Free;
  DeleteDC(hdcScreen);
  DeleteDC(hdcCompatible);
end;


end.
