unit dmEstrategiaInterpreterBD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dmEstrategiaInterpreter, DB, IBCustomDataSet, IBQuery,
  IBDatabase, kbmMemTable;

type
  TEstrategiaInterpreterBD = class(TEstrategiaInterpreter)
    qEstrategia: TIBQuery;
    qEstrategiaESTRATEGIA_APERTURA: TMemoField;
    qEstrategiaESTRATEGIA_CIERRE: TMemoField;
    qEstrategiaESTRATEGIA_APERTURA_POSICIONADO: TMemoField;
    qEstrategiaESTRATEGIA_CIERRE_POSICIONADO: TMemoField;
  private
    { Private declarations }
  public
    constructor Create(const AOwner: TComponent; const Valores: TDataSet;
      const OIDEstrategia: integer); reintroduce;
  end;


implementation

uses UtilDB, dmBD;



{$R *.dfm}

{ TEstrategiaInterpreterBD }

constructor TEstrategiaInterpreterBD.Create(const AOwner: TComponent;
  const Valores: TDataSet; const OIDEstrategia: integer);

    function GetEstrategia(field: TMemoField): string;
    var i: integer;
      empty: boolean;
    begin
      result := Trim(field.Value);
      empty := false;
      if length(result) > length('begin end.') then begin
        if UpCase(result[1]) = 'B' then begin
          if UpCase(result[2]) = 'E' then begin
            if UpCase(result[3]) = 'G' then begin
              if UpCase(result[4]) = 'I' then begin
                if UpCase(result[5]) = 'N' then begin
                  i := 6;
                  while (length(result) > i) and (result[i] = ' ') do
                    inc(i);
                  if length(result) - i = 4 then begin
                    if UpCase(result[i]) = 'E' then begin
                      inc(i);
                      if UpCase(result[i]) = 'N' then begin
                        inc(i);
                        if UpCase(result[i]) = 'D' then begin
                          inc(i);
                          if result[i] = '.' then begin
                            empty := true;
                          end;
                        end;
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end
      else
        empty := true;
      if empty then
        result := '';
    end;
begin
  inherited Create(AOwner, Valores);
  qEstrategia.Params[0].AsInteger := OIDEstrategia;
  OpenDataSet(qEstrategia);
  EstrategiaApertura := GetEstrategia(qEstrategiaESTRATEGIA_APERTURA);
  EstrategiaCierre := GetEstrategia(qEstrategiaESTRATEGIA_CIERRE);
  EstrategiaAperturaPosicionado := GetEstrategia(qEstrategiaESTRATEGIA_APERTURA_POSICIONADO);
  EstrategiaCierrePosicionado := GetEstrategia(qEstrategiaESTRATEGIA_CIERRE_POSICIONADO);
end;

end.
