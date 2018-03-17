unit dmEstadistica;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, IBQuery;

type
  TDato = record
    Dinero: Currency;
    Papel: Currency;
    Zona: integer;
    Mas_0, Mas_1, Mas_2, Mas_3, Mas: Integer;
    Menos_0, Menos_1, Menos_2, Menos_3, Menos: Integer;
  end;

  TDatos = array of TDato;

  PDato = ^TDato;
  PDatos = ^TDatos;

  TEstadistica = class(TDataModule)
    qData: TIBQuery;
    qDataDINERO: TIBBCDField;
    qDataPAPEL: TIBBCDField;
    qDataZONA: TIBStringField;
    qDataVARIACION: TIBBCDField;
    qDataFLAGS: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
  private
  public
    Datos: TDatos;
  end;

implementation

uses dmBD, dmData, flags;

{$R *.dfm}

procedure TEstadistica.DataModuleCreate(Sender: TObject);
var subida: Currency;
  dinero, papel: currency;
  zona: Byte;
  dato: PDato;
  num: integer;
  flags: TFlags;

  function get(const dinero, papel: Currency; const zona: integer): PDato;
  var i: integer;
  begin
    for i := Low(Datos) to High(Datos) do begin
      if (Datos[i].Dinero = dinero) and (Datos[i].Papel = papel) and
        (Datos[i].Zona = Zona) then begin
          result := @Datos[i];
          exit;
        end;
    end;
    result := nil;
  end;

begin
  flags := TFlags.Create;
  qData.Params[0].AsInteger := Data.OIDValor;
  qData.Open;

  qData.Last;
  subida := qDataVARIACION.Value;
  qData.Prior;
  while not qData.bof do begin
    if qDataDINERO.IsNull then begin
      flags.Free;
      exit;
    end;
    flags.Flags := qDataFLAGS.Value;
    if flags.Es(cInicioCiclo) or flags.Es(cInicioCicloVirtual) then begin
      dinero := qDataDINERO.Value;
      papel := qDataPAPEL.Value;
      zona := qDataZONA.AsInteger;
      dato := get(dinero, papel, zona);
      if dato = nil then begin
        num := Length(Datos);
        SetLength(Datos, num + 1);
        Datos[num].Dinero := dinero;
        Datos[num].Papel := papel;
        Datos[num].Zona := zona;
        Datos[num].Mas_0 := 0;
        Datos[num].Mas_1 := 0;
        Datos[num].Mas_2 := 0;
        Datos[num].Mas_3 := 0;
        Datos[num].Mas := 0;
        Datos[num].Menos_0 := 0;
        Datos[num].Menos_1 := 0;
        Datos[num].Menos_2 := 0;
        Datos[num].Menos_3 := 0;
        Datos[num].Menos := 0;
        dato := @Datos[num];
      end;
      if subida > 0 then begin
        if subida < 1 then begin
          dato^.Mas_0 := dato^.Mas_0 + 1;
        end
        else begin
          if (subida >= 1) and (subida < 2) then begin
            dato^.Mas_1 := dato^.Mas_1 + 1;
          end
          else begin
            if (subida >= 2) and (subida < 3) then begin
              dato^.Mas_2 := dato^.Mas_2 + 1;
            end
            else begin
              if (subida >= 3) and (subida < 4) then begin
                dato^.Mas_3 := dato^.Mas_3 + 1;
              end
              else begin
                dato^.Mas := dato^.Mas + 1;
              end;
            end;
          end;
        end;
      end
      else begin
        if subida > -1 then begin
          dato^.Menos_0 := dato^.Menos_0 + 1;
        end
        else begin
          if (subida <= -1) and (subida > -2) then begin
            dato^.Menos_1 := dato^.Menos_1 + 1;
          end
          else begin
            if (subida <= -2) and (subida > -3) then begin
              dato^.Menos_2 := dato^.Menos_2 + 1;
            end
            else begin
              if (subida <= -3) and (subida > -4) then begin
                dato^.Menos_3 := dato^.Menos_3 + 1;
              end
              else begin
                dato^.Menos := dato^.Menos + 1;
              end;
            end;
          end;
        end;
      end;
    end;
    subida := qDataVARIACION.Value;
    qData.Prior;
  end;
  flags.Free;
end;

end.
