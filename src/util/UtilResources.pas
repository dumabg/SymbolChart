unit UtilResources;

interface
  uses Classes;

  procedure ExtractZippedRCDATA(const resourceName: string; const salida: TStream);

implementation

uses
  Windows, ZLib;

  procedure ExtractZippedRCDATA(const resourceName: string; const salida: TStream);
  var res: TResourceStream;
    DecompressionStream: TDecompressionStream;
    Buffer: array[0..4095] of Char;
    BufLen: Integer;
begin
    res := TResourceStream.Create(HInstance, resourceName, RT_RCDATA);
    try
      DecompressionStream := TDecompressionStream.Create(res);
      try
        BufLen := DecompressionStream.Read(Buffer, SizeOf(Buffer));
        while BufLen > 0 do begin
          salida.Write(Buffer,BufLen);
          BufLen := DecompressionStream.Read(Buffer,SizeOf(Buffer));
        end;
      finally
        DecompressionStream.Free;
      end;
    finally
      res.Free;
    end;
  end;

end.
