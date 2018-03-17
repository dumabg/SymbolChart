unit mensajesPanel;

interface

uses windows, messages, classes, graphics, controls, ComCtrls, db, StdCtrls, Htmlview;

const
  OIDSinAsignar = -1;

type
  TOnGetBetaIndex = function (const OIDBeta: string): string of object;

  TMensaje = record
    TipoOID: integer;
    Params: string;
    Mensaje: string;
    Titulo: string;
    IsNull: boolean;
    visible: boolean;
  end;

  TMensajes = array of TMensaje;

  TMensajesPanel = class;

  TMensajesPanel = class(THTMLViewer)
  private
{    type TWordStatus = (wsNone, wsOK, wsCS1, wsCS2, wsCS3);
    var}
    FParagraphSeparation: boolean;
    FTitleSeparation: boolean;
    FWords: TStrings;
    FWords3: TStrings;
    FWords2: TStrings;
    FBetas: TStrings;
    FStyleSheetWords1: string;
    FStyleSheetWords3: string;
    FStyleSheetWords2: string;
    FStyleSheetTitle: string;
    FTamanoFuente: integer;
    FDesconectado: boolean;
    FTextoDesconectado: string;
    FMensajes: TMensajes;
    FOIDPrincipal: integer;
    FOIDBetas: integer;
    FNombreValor: string;
    FOnGetBetaIndex: TOnGetBetaIndex;
    InicioHTML: string;
    AvisoLegalFinHTML: string;
    updating: boolean;
//    styleCS1, styleCS2, styleCS3, endStyle: string;
//    wordsMap: array of array[1..255] of TWordStatus;
    procedure SetTitleSeparation(const Value: boolean);
    procedure SetParagraphSeparation(const Value: boolean);
    procedure SetWords(const Value: TStrings);
    procedure SetWords2(const Value: TStrings);
    procedure SetWords3(const Value: TStrings);
    procedure SetStyleSheetWords1(const Value: string);
    procedure SetStyleSheetWords2(const Value: string);
    procedure SetStyleSheetWords3(const Value: string);
    procedure SetTamanoFuente(const Value: integer);
    procedure SetMensajes(const Value: TMensajes);
    procedure SetDesconectado(const Value: boolean);
    procedure CreateInicioHTML;
    procedure SetOIDBetas(const Value: integer);
    procedure SetOIDPrincipal(const Value: integer);
    function GetAvisoLegal: string;
  protected
    procedure Loaded; override;
    procedure ChangeData;
    function IluminateWords(mensaje: string): string;
//    function GetTitulo(const titulo: string; const tipo: integer): string; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetMensaje(const i: integer): string;
    procedure BeginUpdate;
    procedure EndUpdate;
    property OIDPrincipal: integer read FOIDPrincipal write SetOIDPrincipal default OIDSinAsignar;
    property OIDBetas: integer read FOIDBetas write SetOIDBetas default OIDSinAsignar;
    property Mensajes: TMensajes read FMensajes write SetMensajes;
    property AvisoLegal: string read GetAvisoLegal;    
  published
    property ParagrahSeparation: boolean read FParagraphSeparation write SetParagraphSeparation default true;
    property TitleSeparation: boolean read FTitleSeparation write SetTitleSeparation default true;
    property Words: TStrings read FWords write SetWords;
    property Words2: TStrings read FWords2 write SetWords2;
    property Words3: TStrings read FWords3 write SetWords3;
    property StyleSheetWords1: string read FStyleSheetWords1 write SetStyleSheetWords1;
    property StyleSheetWords2: string read FStyleSheetWords2 write SetStyleSheetWords2;
    property StyleSheetWords3: string read FStyleSheetWords3 write SetStyleSheetWords3;
    property StyleSheetTitle: string read FStyleSheetTitle write FStyleSheetTitle;
    property TamanoFuente: integer read FTamanoFuente write SetTamanoFuente default 12;
    property TextoDesconectado: string read FTextoDesconectado write FTextoDesconectado;
    property Desconectado: boolean read FDesconectado write SetDesconectado;
    property NombreValor: string read FNombreValor write FNombreValor;
    property OnGetBetaIndex: TOnGetBetaIndex read FOnGetBetaIndex write FOnGetBetaIndex;
    property Align;
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind default bkNone;
    property BevelWidth;
    property BorderStyle;
    property BorderWidth;
    property Color default clWhite;
    property Constraints;
    property Ctl3D;
    property Cursor default crDefault;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property Height;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property ScrollBars default ssVertical;
    property Visible;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDock;
    property OnStartDrag;
    property OnDblClick;
  end;


implementation

uses SysUtils, StrUtils;

resourcestring
  TITULO_AVISO_LEGAL = 'Aviso legal';
  AVISO_LEGAL = ' Los comentarios anteriores no suponen ninguna incitación ' +
    'a la compra venta de acciones, futuros, CFDs, etc., sino que únicamente ' +
    'son anotaciones que un programa informático efectúa automáticamente en ' +
    'función de la evolución histórica de los gráficos y sin intervención ' +
    'humana alguna.';

{ TMensajesPanel }

procedure Split(const Delimiter: Char; const Input: string; const Destination: TStrings);
var i, j: integer;
  cad: string;
begin
   Assert(Assigned(Destination));
   Destination.Clear;
   i := 1;
   j := Pos(Delimiter, Input);
   if j = 0 then begin
    cad := Trim(Input);
    if cad <> '' then
      Destination.Add(cad);
   end
   else begin
     repeat
        cad := Trim(Copy(Input, i, j - i));
        if cad <> '' then
          Destination.Add(cad);
        i := j + 1;
        j := PosEx(Delimiter, Input, i);
     until j = 0;
     cad := Trim(Copy(Input, i, length(input)));
     Destination.Add(cad);
   end;
end;


function TMensajesPanel.GetAvisoLegal: string;
begin
  result := AVISO_LEGAL;
end;

function TMensajesPanel.GetMensaje(const i: integer): string;
{var mensaje, betaIndex: string;
  j: integer;
  oid: string;
  paramsValues: TStringList;}
var params, betaIndex, oid: string;
  mensaje: string;
  j, {k, iNom,} jParam, num, numNom, total{, iIluminate}: integer;
  isMensajeBeta: boolean;
begin
  if FMensajes[i].IsNull then
    result := ''
  else begin
    mensaje := FMensajes[i].Mensaje;
    params := FMensajes[i].Params + '#';
    jParam := 0;
    isMensajeBeta := FMensajes[i].TipoOID = FOIDBetas;
    if isMensajeBeta then begin
      repeat
        inc(jParam);
      until params[jParam] = '#';
      oid := Copy(params, 1, jParam - 1);
      betaIndex := FBetas.Values[oid];
      if betaIndex = '' then begin
        betaIndex := FOnGetBetaIndex(oid);
        FBetas.Add(oid + '=' + betaIndex);
      end;
    end;

    SetLength(result, 10 * 1024); //10k
    num := length(mensaje);
    total := 1;
    j := 0;
//    iIluminate := 1;
    repeat
      inc(j);
      if mensaje[j] = '#' then begin
        inc(jParam);
        // Si hay un error y los parámetros empiezan por #.
        // Ejemplo: NASDAQ Composite 11/11/10
        if params[jParam] = '#' then begin
          result[total] := '?';
          inc(jParam);
          inc(total);
        end
        else begin
          repeat
            result[total] := params[jParam];
            inc(jParam);
            inc(total);
          until params[jParam] = '#';
        end;
      end
      else begin
        if mensaje[j] = '%' then begin
          if (mensaje[j + 1] = 'N') and (mensaje[j + 2] = 'O') and
             (mensaje[j + 3] = 'M') and (mensaje[j + 4] = '%') then begin
            numNom := length(FNombreValor);
            CopyMemory(@result[total], @FNombreValor[1], numNom);
            total := total + numNom;
            j := j + 4;
          end
          else begin
            if (mensaje[j + 1] = 'I') and (mensaje[j + 2] = '%') and (isMensajeBeta) then begin
              numNom := length(betaIndex);
              CopyMemory(@result[total], @betaIndex[1], numNom);
              total := total + numNom;
              j := j + 2;
            end
            else begin
              result[total] := mensaje[j];
              inc(total);
            end;
          end;
        end
        else begin
          result[total] := mensaje[j];
          inc(total);
        end;
      end;
    until j >= num;
    SetLength(result, total - 1);
  end;

{    mensaje := FMensajes[i].Mensaje;
    paramsValues := TStringList.Create;
    try
      Split('#', FMensajes[i].Params, paramsValues);
      if FMensajes[i].TipoOID = FOIDBetas then begin
        oid := paramsValues[0];
        paramsValues.Delete(0);
        betaIndex := FBetas.Values[oid];
        if betaIndex = '' then begin
          betaIndex := FOnGetBetaIndex(oid);
          FBetas.Add(oid + '=' + betaIndex);
        end;
        mensaje := StringReplace(mensaje, '%I%', betaIndex, [rfReplaceAll]);
      end;
      for j := 0 to paramsValues.Count - 1 do begin
        mensaje := StringReplace(mensaje, '#', paramsValues[j], []);
      end;
    finally
      paramsValues.Free;
    end;
    result := StringReplace(mensaje, '%NOM%', FNombreValor, [rfReplaceAll]);}
end;

{function TMensajesPanel.GetTitulo(const titulo: string; const tipo: integer): string;
begin
  result := '<a href="' + IntToStr(tipo) + '" id="t">' + titulo + '</a>';
end;}

procedure TMensajesPanel.BeginUpdate;
begin
  updating := true;
end;

procedure TMensajesPanel.ChangeData;
var i, tipo: integer;
  mensaje, text: string;
begin
  if (csLoading in ComponentState) or (FDesconectado) or
    (FOIDPrincipal = OIDSinAsignar) or (FOIDBetas = OIDSinAsignar) then begin
    Clear;
{    text := '<html><body></body></html>';
    LoadString(text, '', HTMLType);}
    exit;
  end;
  text := InicioHTML;
  for i := Low(FMensajes) to High(FMensajes) do begin
    if FMensajes[i].visible then begin
      mensaje := GetMensaje(i);
      if mensaje <> '' then begin
        tipo := FMensajes[i].TipoOID;
        if tipo = FOIDPrincipal then begin
          text := text + IluminateWords(mensaje);
        end
        else begin
          text := text +
            '<a href="' + IntToStr(tipo) + '" id="t">' + FMensajes[i].Titulo + '</a>';
  //            GetTitulo(FMensajes[i].Titulo, tipo);
          if FTitleSeparation then
            text := text + '<br/>'
          else
            text := text + '. ';
           text := text +  IluminateWords(mensaje);
        end;
        if FParagraphSeparation then begin
          text := text + '<br/>';
        end;
      text := text + '<br/>';
      end;
    end;
  end;
  text := text + AvisoLegalFinHTML;
  LoadString(text, '', HTMLType);
end;

constructor TMensajesPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParagraphSeparation := true;
  FTitleSeparation := true;
  FWords := TStringList.Create;
  FWords2 := TStringList.Create;
  FWords3 := TStringList.Create;
  FBetas := TStringList.Create;
  FTamanoFuente := 12;
  FOIDPrincipal := OIDSinAsignar;
  FOIDBetas := OIDSinAsignar;

  ScrollBars := ssVertical;
  NoSelect := true;
  Cursor := crDefault;
  ScrollBars := ssVertical;
  DefBackground := clWhite;

{  styleCS1 := '<span id="e1">';
  styleCS2 := '<span id="e2">';
  styleCS3 := '<span id="e3">';
  endStyle := '</span>';}
  AvisoLegalFinHTML := '<br/><b>' + TITULO_AVISO_LEGAL + ':</b><br/>' +
    AVISO_LEGAL + '</body></html>';
end;


procedure TMensajesPanel.CreateInicioHTML;
begin
  InicioHTML := '<html><head><style type="text/css">#e1{' + FStyleSheetWords1 + '}' +
    '#e2{' + FStyleSheetWords2 + '}' +
    '#e3{' + FStyleSheetWords3 + '}' +
    '#t{' + FStyleSheetTitle + '}' +
    'body{font-size:' + IntToStr(FTamanoFuente) + 'px}' +
    '</style></head><body>';
end;

destructor TMensajesPanel.Destroy;
begin
  FWords.Free;
  FWords2.Free;
  FWords3.Free;
  FBetas.Free;
  inherited Destroy;
end;

procedure TMensajesPanel.EndUpdate;
begin
  updating := false;
  ChangeData;
end;

procedure TMensajesPanel.Loaded;
begin
  inherited Loaded;
  CreateInicioHTML;
  ChangeData;
end;

procedure TMensajesPanel.SetDesconectado(const Value: boolean);
begin
  if FDesconectado <> Value then begin
    FDesconectado := Value;
    ChangeData;
  end;
end;

procedure TMensajesPanel.SetMensajes(const Value: TMensajes);
begin
  FMensajes := Value;
  if (not updating) and (not (csLoading in ComponentState)) then
    ChangeData;
end;

procedure TMensajesPanel.SetOIDBetas(const Value: integer);
begin
  FOIDBetas := Value;
  if not updating then
    ChangeData;
end;

procedure TMensajesPanel.SetOIDPrincipal(const Value: integer);
begin
  FOIDPrincipal := Value;
  if not updating then
    ChangeData;
end;

procedure TMensajesPanel.SetParagraphSeparation(const Value: boolean);
begin
  FParagraphSeparation := Value;
  if (not updating) and (not (csLoading in ComponentState)) then
    ChangeData;
end;

procedure TMensajesPanel.SetStyleSheetWords1(const Value: string);
begin
  FStyleSheetWords1 := Value;
  if (not updating) and (not (csLoading in ComponentState)) then begin
    CreateInicioHTML;
    ChangeData;
  end;
end;

procedure TMensajesPanel.SetStyleSheetWords2(const Value: string);
begin
  FStyleSheetWords2 := Value;
  if (not updating) and (not (csLoading in ComponentState)) then begin
    CreateInicioHTML;
    ChangeData;
  end;
end;

procedure TMensajesPanel.SetStyleSheetWords3(const Value: string);
begin
  FStyleSheetWords3 := Value;
  if (not updating) and (not (csLoading in ComponentState)) then begin
    CreateInicioHTML;
    ChangeData;
  end;
end;

procedure TMensajesPanel.SetTamanoFuente(const Value: integer);
begin
  if FTamanoFuente <> Value then begin
    FTamanoFuente := Value;
    CreateInicioHTML;
    if (not updating) and (not (csLoading in ComponentState)) then
      ChangeData;
  end;
end;

procedure TMensajesPanel.SetTitleSeparation(const Value: boolean);
begin
  FTitleSeparation := Value;
  if (not updating) and (not (csLoading in ComponentState)) then
    ChangeData;
end;

procedure TMensajesPanel.SetWords(const Value: TStrings);
begin
  FWords.Assign(Value);
  ChangeData;
end;


function TMensajesPanel.IluminateWords(mensaje: string): string;

    procedure Iluminate(const Words: TStrings; style: string);
    var i: integer;
      word: string;
    begin
      style := '<span id="' + style + '">';
      for i := 0 to Words.Count - 1 do begin
        word := Words[i];
        result := StringReplace(result, word, style + word + '</span>', [rfReplaceAll]);
      end;
    end;
begin
  result := mensaje;
  Iluminate(FWords, 'e1');
  Iluminate(FWords2, 'e2');
  Iluminate(FWords3, 'e3');
end;

procedure TMensajesPanel.SetWords2(const Value: TStrings);
begin
  FWords2.Assign(Value);
  ChangeData;
end;

procedure TMensajesPanel.SetWords3(const Value: TStrings);
begin
  FWords3.Assign(Value);
  ChangeData;
end;

{
procedure TMensajesPanel.WordsChanged;
var max: integer;

  function GetMaxLength(words: TStrings): integer; overload;
  var num, i: integer;
    palabra: string;
  begin
    result := 0;
    num := words.Count - 1;
    for i := 0 to num do begin
      palabra := Words[i];
      if length(palabra) > result then
        result := length(palabra);
    end;
  end;

  function GetMaxLength: integer; overload;
  var aux: integer;
  begin
    result := GetMaxLength(Words);
    aux := GetMaxLength(Words2);
    if aux > result then
      result := aux;
    aux := GetMaxLength(Words3);
    if aux > result then
      result := aux;
  end;

  procedure MapWords(words: TStrings; status: TWordStatus);
  var num, i, j: integer;
    palabra: string;
  begin
    num := words.Count - 1;
    for i := 0 to num do begin
      palabra := Words[i];
      for j := 1 to length(palabra) do begin
        wordsMap[j - 1][byte(palabra[j])] := wsOK;
      end;
      dec(j);
      wordsMap[j][byte(' ')] := status;
      wordsMap[j][byte('.')] := status;
      wordsMap[j][byte(',')] := status;
      wordsMap[j][byte(';')] := status;
      wordsMap[j][byte(':')] := status;
    end;
  end;

begin
  max := GetMaxLength;

  SetLength(wordsMap, max + 1);
  FillChar(wordsMap[Low(wordsMap)], length(wordsMap) * sizeof(TWordStatus), wsNone);

  MapWords(Words, wsCS1);
  MapWords(Words2, wsCS2);
  MapWords(Words3, wsCS3);
end;}


{
if wordsMap[0][byte(mensaje[j])] = wsOK then begin
            k := j;
            iIluminate := 0;
            repeat
              inc(k);
              inc(iIluminate);
            until wordsMap[iIluminate][byte(mensaje[k])] <> wsOK;
            case wordsMap[iIluminate][byte(mensaje[k])] of
              wsCS1: begin
                numNom := length(styleCS1);
                CopyMemory(@result[total], @styleCS1[1], numNom);
                total := total + numNom;
                CopyMemory(@result[total], @mensaje[j], iIluminate);
                total := total + iIluminate;
                numNom := length(endStyle);
                CopyMemory(@result[total], @endStyle[1], numNom);
                total := total + numNom;
                j := j + iIluminate - 1;
              end;
              wsCS2: begin
                numNom := length(styleCS2);
                CopyMemory(@result[total], @styleCS2[1], numNom);
                total := total + numNom;
                CopyMemory(@result[total], @mensaje[j], iIluminate);
                total := total + iIluminate;
                numNom := length(endStyle);
                CopyMemory(@result[total], @endStyle[1], numNom);
                total := total + numNom;
                j := j + iIluminate - 1;
              end;
              wsCS3: begin
                numNom := length(styleCS3);
                CopyMemory(@result[total], @styleCS3[1], numNom);
                total := total + numNom;
                CopyMemory(@result[total], @mensaje[j], iIluminate);
                total := total + iIluminate;
                numNom := length(endStyle);
                CopyMemory(@result[total], @endStyle[1], numNom);
                total := total + numNom;
                j := j + iIluminate - 1;
              end;
              else begin
                result[total] := mensaje[j];
                inc(total);
              end;
            end;
          end
          }

end.
