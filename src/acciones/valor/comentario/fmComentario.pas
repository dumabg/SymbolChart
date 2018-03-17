unit fmComentario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, fmBase, StdCtrls, DBCtrls, ComCtrls, dmComentario,
  richEditReadOnly, dmLector, ActnList, XPStyleActnCtrls,
  ActnMan, ExtCtrls, JvComponentBase,
  JvFormPlacement, TB2Item, SpTBXItem, TB2Dock, TB2Toolbar;

const
  WM_AFTER_RESIZE = WM_USER + 1;

type
  TfComentario = class(TfBase)
    Comentario: TRichEditReadOnly;
    Panel1: TPanel;
    ActionManagerVoz: TActionManager;
    VozReproducir: TAction;
    VozPausa: TAction;
    VozParar: TAction;
    ToolbarVoz: TSpTBXToolbar;
    TBXItem120: TSpTBXItem;
    TBXItem119: TSpTBXItem;
    TBXItem118: TSpTBXItem;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure VozReproducirExecute(Sender: TObject);
    procedure VozPausaExecute(Sender: TObject);
    procedure VozPararExecute(Sender: TObject);
  private
    PrimeraBaja: currency;
    SegundaBaja: currency;
    PrimeraAlza: currency;
    SegundaAlza: currency;
    dmComentario: TdComentario;
    Lector: TLector;
    VocesInicializadas: boolean;
    procedure OnHablaFinalizada;
    function comparar(valor1, valor2: currency): string;
    function futurosPosibles(dinero1, dinero2, papel1, papel2: currency): string;
    procedure situacionActual;
    procedure futuros;
    procedure observaciones;
    procedure Titulo(cad: string);
    procedure AfterResize(var message: TMessage); message WM_AFTER_RESIZE;
  public
    { Public declarations }
  end;

implementation

uses dmData, math, dmLectorImages;

{$R *.dfm}

procedure TfComentario.AfterResize(var message: TMessage);
begin
  Comentario.Repaint;
end;

function TfComentario.comparar(valor1, valor2: currency): string;
begin
  if (valor1 = valor2) then
    result := 'repitió'
  else
    if (valor1 < valor2) then
      result := 'subió'
  else
      result := 'bajó'
end;

procedure TfComentario.FormShow(Sender: TObject);
begin
  inherited;
  if Data.CotizacionEstadoDINERO_ALZA_SIMPLE.Value = 0 then begin
    Comentario.Lines.Add('El sistema no puede comentar el gráfico porque en la' +
     'sesión del día ' + Data.CotizacionFECHA.AsString + ' no se procesó.');
    exit;
  end;


  PrimeraBaja := RoundTo(Data.CotizacionCIERRE.Value * (1-(Data.CotizacionEstadoVARIABILIDAD.Value / 100)), -2);
  SegundaBaja := RoundTo(Data.CotizacionCIERRE.Value * (1-(2*Data.CotizacionEstadoVARIABILIDAD.Value / 100)), -2);
  PrimeraAlza := RoundTo(Data.CotizacionCIERRE.Value * (1+ (Data.CotizacionEstadoVARIABILIDAD.Value / 100)), -2);
  SegundaAlza := RoundTo(Data.CotizacionCIERRE.Value * (1+ (2*Data.CotizacionEstadoVARIABILIDAD.Value / 100)), -2);

  Comentario.Paragraph.FirstIndent := 10;
  Comentario.Paragraph.LeftIndent := 10;
  Comentario.Paragraph.RightIndent := 10;

  situacionActual;
  futuros;
  observaciones;
//  Comentario.CaretPos := Point(0,0);
  // Move to the first line:
  Comentario.SelStart := Comentario.Perform(EM_LINEINDEX, 0, 0);
  Comentario.Perform(EM_SCROLLCARET, 0, 0);
end;

procedure TfComentario.futuros;
var aux: string;
begin
  Titulo('Futuros posibles');

  Comentario.Paragraph.Numbering := nsBullet;
  aux := 'Si el gráfico cayera ahora hasta el nivel ' +
    CurrToStr(PrimeraBaja) +
    ' entonces la fuerza del dinero ';
  aux := aux + futurosPosibles(Data.CotizacionEstadoDINERO_BAJA_SIMPLE.Value,
    Data.CotizacionEstadoDINERO.Value, Data.CotizacionEstadoPAPEL_BAJA_SIMPLE.Value, Data.CotizacionEstadoPAPEL.Value);
  aux := aux + ' (' + Data.CotizacionEstadoZONA_BAJA_SIMPLE_DESC.Value + ').';
  Comentario.Lines.Add(aux);

  aux := 'Si el gráfico cayera ahora hasta el nivel ' +
    CurrToStr(SegundaBaja) +
    ' entonces la fuerza del dinero ';
  aux := aux + futurosPosibles(Data.CotizacionEstadoDINERO_BAJA_DOBLE.Value,
    Data.CotizacionEstadoDINERO.Value, Data.CotizacionEstadoPAPEL_BAJA_DOBLE.Value, Data.CotizacionEstadoPAPEL.Value);
  aux := aux + ' (' + Data.CotizacionEstadoZONA_BAJA_DOBLE_DESC.Value + ').';
  Comentario.Lines.Add(aux);

  aux := 'Si el gráfico subiera ahora hasta el nivel ' +
    CurrToStr(PrimeraAlza) +
    ' entonces la fuerza del dinero ';
  aux := aux + futurosPosibles(Data.CotizacionEstadoDINERO_ALZA_SIMPLE.Value,
    Data.CotizacionEstadoDINERO.Value, Data.CotizacionEstadoPAPEL_ALZA_SIMPLE.Value, Data.CotizacionEstadoPAPEL.Value);
  aux := aux + ' (' + Data.CotizacionEstadoZONA_ALZA_SIMPLE_DESC.Value + ').';
  Comentario.Lines.Add(aux);

  aux := 'Si el gráfico subiera ahora hasta el nivel ' +
    CurrToStr(SegundaAlza) +
    ' entonces la fuerza del dinero ';
  aux := aux + futurosPosibles(Data.CotizacionEstadoDINERO_ALZA_DOBLE.Value,
    Data.CotizacionEstadoDINERO.Value, Data.CotizacionEstadoPAPEL_ALZA_DOBLE.Value, Data.CotizacionEstadoPAPEL.Value);
  aux := aux + ' (' + Data.CotizacionEstadoZONA_ALZA_DOBLE_DESC.Value + ').';
  Comentario.Lines.Add(aux);
end;

function TfComentario.futurosPosibles(dinero1, dinero2, papel1, papel2: currency): string;
begin
  result := '';
  if dinero1 > dinero2 then
    result := result + 'aumentaría hasta los ' + CurrToStr(dinero1) +
      ' grados'
  else
    if dinero1 < dinero2 then
      result := result + 'retrocedería hasta los ' + CurrToStr(dinero1) +
        ' grados'
    else
      if dinero1 < dinero2 then
        result := result + 'se mantendría en los ' + CurrToStr(dinero1) +
          ' grados';
  result := result + ' y la fuerza del papel ';

  if papel1 > papel2 then
    result := result + 'aumentaría hasta los ' + CurrToStr(papel1) +
      ' grados'
  else
    if papel1 < papel2 then
      result := result + 'retrocedería hasta los ' + CurrToStr(papel1) +
        ' grados'
    else
      if papel1 = papel2 then
        result := result + 'se mantendría en los ' + CurrToStr(papel1) +
          ' grados';
end;


procedure TfComentario.observaciones;
var aux: string;

begin
  Comentario.Lines.Add('');
  aux := 'El máximo en intradía en la última sesión llegó hasta ' +
    Data.CotizacionMAXIMO.AsString;
  aux := aux + ' y el mínimo intradía se situó en el nivel ' +
    Data.CotizacionMINIMO.AsString + ' inferior.';
  Comentario.Lines.Add(aux);
  Comentario.Lines.Add('');

  aux := 'Los indicadores Dobson del gráfico actualmente ';
  if (Data.CotizacionEstadoDOBSON_130.Value > Data.CotizacionEstadoDOBSON_100.Value) and
    (Data.CotizacionEstadoDOBSON_100.Value > Data.CotizacionEstadoDOBSON_70.Value) and
    (Data.CotizacionEstadoDOBSON_70.Value > Data.CotizacionEstadoDOBSON_40.Value) and
    (Data.CotizacionEstadoDOBSON_40.Value > Data.CotizacionEstadoDOBSON_10.Value) then
    aux := aux + 'están ordenados para acumulación.'
  else
    if (Data.CotizacionEstadoDOBSON_130.Value < Data.CotizacionEstadoDOBSON_100.Value) and
      (Data.CotizacionEstadoDOBSON_100.Value < Data.CotizacionEstadoDOBSON_70.Value) and
      (Data.CotizacionEstadoDOBSON_70.Value < Data.CotizacionEstadoDOBSON_40.Value) and
      (Data.CotizacionEstadoDOBSON_40.Value < Data.CotizacionEstadoDOBSON_10.Value) then
      aux := aux + 'están ordenados para distribución.'
    else begin
      aux := aux + ' no están ordenados para acumulación ni para distribución, ' +
        'sólo muestran ';
      if (Data.CotizacionEstadoDOBSON_130.Value = 0) and
        (Data.CotizacionEstadoDOBSON_100.Value = 0) and
        (Data.CotizacionEstadoDOBSON_70.Value = 0) and
        (Data.CotizacionEstadoDOBSON_40.Value = 0) and
        (Data.CotizacionEstadoDOBSON_10.Value = 0) then
          aux := aux + 'que están todos a cero.'
      else begin
        aux := aux + 'la siguiente situación de las medias móviles:';
        Comentario.Lines.Add(aux);
        Comentario.Paragraph.Numbering := nsBullet;
        aux := 'Media móvil de 130 días igual a ' + Data.CotizacionEstadoDOBSON_130.AsString;
        if Data.CotizacionEstadoDOBSON_130.Value < 0 then
          aux := aux + ' (rota)';
        Comentario.Lines.Add(aux);

        aux := 'Media móvil de 100 días igual a ' + Data.CotizacionEstadoDOBSON_100.AsString;
        if Data.CotizacionEstadoDOBSON_100.Value < 0 then
          aux := aux + ' (rota)';
        Comentario.Lines.Add(aux);

        aux := 'Media móvil de 70 días igual a ' + Data.CotizacionEstadoDOBSON_70.AsString;
        if Data.CotizacionEstadoDOBSON_70.Value < 0 then
          aux := aux + ' (rota)';
        Comentario.Lines.Add(aux);

        aux := 'Media móvil de 40 días igual a ' + Data.CotizacionEstadoDOBSON_40.AsString;
        if Data.CotizacionEstadoDOBSON_40.Value < 0 then
          aux := aux + ' (rota)';
        Comentario.Lines.Add(aux);

        aux := 'Media móvil de 10 días igual a ' + Data.CotizacionEstadoDOBSON_10.AsString;
        if Data.CotizacionEstadoDOBSON_10.Value < 0 then
          aux := aux + ' (rota)';
        Comentario.Lines.Add(aux);
        Comentario.Lines.Add('');
        aux := 'Con lo cual, y desde el punto de vista de las medias móviles ' +
          'se puede decir que ' + Data.ValoresNOMBRE.Value +
          ' (' + Data.ValoresSIMBOLO.Value + ') actualmente es ';
        if Data.CotizacionEstadoDOBSON_130.Value = 0 then
          aux := aux + 'neutro a largo plazo'
        else
          if Data.CotizacionEstadoDOBSON_130.Value > 0 then
            aux := aux + 'alcista a largo plazo'
          else
            aux := aux + 'bajista a largo plazo';

        aux := aux + ', ';
        if Data.CotizacionEstadoDOBSON_70.Value = 0 then
          aux := aux + 'neutro a medio plazo'
        else
          if Data.CotizacionEstadoDOBSON_70.Value > 0 then
            aux := aux + 'alcista a medio plazo'
          else
            aux := aux + 'bajista a medio plazo';

        aux := aux + ' y ';
        if Data.CotizacionEstadoDOBSON_10.Value = 0 then
          aux := aux + 'neutro a corto plazo.'
        else
          if Data.CotizacionEstadoDOBSON_10.Value > 0 then
            aux := aux + 'alcista a corto plazo.'
          else
            aux := aux + 'bajista a corto plazo.';
      end;
    end;
  Comentario.Lines.Add(aux);
  Comentario.Lines.Add('');
  
  aux := 'Además si el gráfico subiera hasta el nivel ' + CurrToStr(SegundaAlza) +
    ' los indicadores de Dobson ';
  if (Data.CotizacionEstadoDOBSON_ALTO_130.Value > Data.CotizacionEstadoDOBSON_ALTO_100.Value) and
    (Data.CotizacionEstadoDOBSON_ALTO_100.Value > Data.CotizacionEstadoDOBSON_ALTO_70.Value) and
    (Data.CotizacionEstadoDOBSON_ALTO_70.Value > Data.CotizacionEstadoDOBSON_ALTO_40.Value) and
    (Data.CotizacionEstadoDOBSON_ALTO_40.Value > Data.CotizacionEstadoDOBSON_ALTO_10.Value) then
    aux := aux + 'están ordenados para acumulación.'
  else
    if (Data.CotizacionEstadoDOBSON_ALTO_130.Value < Data.CotizacionEstadoDOBSON_ALTO_100.Value) and
      (Data.CotizacionEstadoDOBSON_ALTO_100.Value < Data.CotizacionEstadoDOBSON_ALTO_70.Value) and
      (Data.CotizacionEstadoDOBSON_ALTO_70.Value < Data.CotizacionEstadoDOBSON_ALTO_40.Value) and
      (Data.CotizacionEstadoDOBSON_ALTO_40.Value < Data.CotizacionEstadoDOBSON_ALTO_10.Value) then
      aux := aux + 'están ordenados para distribución.'
    else
      aux := aux + ' no están ordenados para acumulación ni para distribución.';

  aux := aux + 'Y si el gráfico bajara hasta el nivel ' + CurrToStr(SegundaBaja) +
    ' los indicadores de Dobson ';
  if (Data.CotizacionEstadoDOBSON_BAJO_130.Value > Data.CotizacionEstadoDOBSON_BAJO_100.Value) and
    (Data.CotizacionEstadoDOBSON_BAJO_100.Value > Data.CotizacionEstadoDOBSON_BAJO_70.Value) and
    (Data.CotizacionEstadoDOBSON_BAJO_70.Value > Data.CotizacionEstadoDOBSON_BAJO_40.Value) and
    (Data.CotizacionEstadoDOBSON_BAJO_40.Value > Data.CotizacionEstadoDOBSON_BAJO_10.Value) then
    aux := aux + 'están ordenados para acumulación.'
  else
    if (Data.CotizacionEstadoDOBSON_BAJO_130.Value < Data.CotizacionEstadoDOBSON_BAJO_100.Value) and
      (Data.CotizacionEstadoDOBSON_BAJO_100.Value < Data.CotizacionEstadoDOBSON_BAJO_70.Value) and
      (Data.CotizacionEstadoDOBSON_BAJO_70.Value < Data.CotizacionEstadoDOBSON_BAJO_40.Value) and
      (Data.CotizacionEstadoDOBSON_BAJO_40.Value < Data.CotizacionEstadoDOBSON_BAJO_10.Value) then
      aux := aux + 'están ordenados para distribución.'
    else
      aux := aux + ' no están ordenados para acumulación ni para distribución.';
  Comentario.Lines.Add(aux);
  Comentario.Lines.Add('');
  aux := 'Observamos también que ';
  if Data.CotizacionEstadoVARIABILIDAD.Value = Data.CotizacionEstadoVOLATILIDAD.Value then
    aux := aux + 'la volatilidad coincide con la variabilidad.'
  else
    if Data.CotizacionEstadoVARIABILIDAD.Value > Data.CotizacionEstadoVOLATILIDAD.Value then
      aux := aux + 'la volatilidad es menor que la variabilidad.'
    else
      if Data.CotizacionEstadoVARIABILIDAD.Value < Data.CotizacionEstadoVOLATILIDAD.Value then begin
        aux := aux + 'la volatilidad supera ahora la variabilidad';
        if (Data.CotizacionEstadoVOLATILIDAD.Value / Data.CotizacionEstadoVARIABILIDAD.Value) > 2.5 then
          aux := aux + ' y la proporción es tal que indica un próximo cambio ' +
            'en la dirección del valor.'
        else
          aux := aux + '.';
      end;
  Comentario.Lines.Add(aux);
  Comentario.Lines.Add('');
  aux := 'Por otra parte el RSI corto a 14 dias es igual a ' +
    Data.CotizacionEstadoRSI_14.AsString + ' y por tanto ';
  if (Data.CotizacionEstadoRSI_14.Value = 69) or (Data.CotizacionEstadoRSI_14.Value = 70) then
    aux := aux + 'si sube un poco más entrará en sobrecomprado'
  else
    if Data.CotizacionEstadoRSI_14.Value > 70 then
      aux := aux + 'se encuentra en sobrecomprado'
    else
      if Data.CotizacionEstadoRSI_14.Value < 30 then
        aux := aux + 'se encuentra en sobrevendido'
      else
        if (Data.CotizacionEstadoRSI_14.Value = 31) or (Data.CotizacionEstadoRSI_14.Value = 30) then
          aux := aux + 'si baja un poco más entrará en sobrevendido'
        else
          if (Data.CotizacionEstadoRSI_14.Value > 31) and (Data.CotizacionEstadoRSI_14.Value < 69) then
            aux := aux + 'se encuentra dentro de su zona neutra';

  aux := aux + ' y el RSI largo a 140 dias vale actualmente ' +
    Data.CotizacionEstadoRSI_140.AsString + ' lo cual significa que está ';
  if Data.CotizacionEstadoRSI_140.Value = 50 then
    aux := aux + 'equilibrado.'
  else
    if Data.CotizacionEstadoRSI_140.Value < 50 then
      aux := aux + 'drenado o desequilibrado a la baja.'
    else
      aux := aux + 'hinchado o desequilibrado al alza.';
  Comentario.Lines.Add(aux);
  Comentario.Lines.Add('');
  aux := 'Vemos también que la banda de Bollinger alta se encuentra situada ' +
    'ahora en el nivel ' + Data.CotizacionEstadoBANDA_ALTA.AsString +
    ' y la banda baja en el nivel ' + Data.CotizacionEstadoBANDA_BAJA.AsString;
  if SegundaBaja < Data.CotizacionEstadoBANDA_BAJA.Value then begin
      aux := aux + ' y por tanto si el gráfico cae mañana hasta el nivel ';
      aux := aux + CurrToStr(SegundaBaja) + ' la caída será altamente significativa';
  end;
  Comentario.Lines.Add(aux + '.');
end;

procedure TfComentario.OnHablaFinalizada;
begin
  VozPausa.Enabled := false;
  VozParar.Enabled := false;
  VozReproducir.Enabled := true;
end;

procedure TfComentario.situacionActual;
var aux: string;
  cambios: TCambios;
begin
  cambios := dmComentario.getCambiosAnteriores(5);

  Titulo('Situación actual');

  Comentario.Lines.Add('El gráfico cerró el día ' + Data.CotizacionFECHA.AsString +
    ' a ' + Data.CotizacionCIERRE.AsString + ' y en este nivel del gráfico ' +
    'la fuerza del dinero es de ' + Data.CotizacionEstadoDINERO.AsString + ' grados y ' +
    'la fuerza del papel es de ' + Data.CotizacionEstadoPAPEL.AsString + ' grados (' +
    Data.CotizacionEstadoZONA_DESC.Value + ').');
  Comentario.Lines.Add('');

  aux := 'Comparando estos datos con los de la sesión anterior ' +
  'se observa lo siguiente: El gráfico ha ';
  if cambios[0] = Data.CotizacionCIERRE.Value then
   aux := 'repetido'
  else begin
   if cambios[0] < Data.CotizacionCIERRE.Value then
    aux := aux + 'subido'
   else
    if cambios[0] > Data.CotizacionCIERRE.Value then
      aux := aux + 'bajado';
    aux := aux + ' ya que ha pasado de ' + CurrToStr(cambios[0]) + ' a ' +
      Data.CotizacionCIERRE.AsString;
  end;

  dmComentario.Open(dmComentario.getOIDCotizacionDiaAnterior);
  aux := aux + ' y en cuanto a los grados del dinero y los del papel se observa ' +
  'que la fuerza del dinero ';
  if Data.CotizacionEstadoDINERO.Value > dmComentario.EstadoAyerDINERO.Value then
  aux := aux + 'aumenta ya que pasa de los ' + dmComentario.EstadoAyerDINERO.AsString +
    ' grados que tenía en la sesión anterior a los ' + Data.CotizacionEstadoDINERO.AsString +
    ' grados de la sesión actual'
  else
    if Data.CotizacionEstadoDINERO.Value < dmComentario.EstadoAyerDINERO.Value then
      aux := aux + 'desciende ya que pasa de los ' + dmComentario.EstadoAyerDINERO.AsString +
        ' grados que tenía en la sesión anterior a los ' + Data.CotizacionEstadoDINERO.AsString +
        ' grados de la sesión actual'
    else
      aux := aux + 'se mantiene fijo en los ' + Data.CotizacionEstadoDINERO.AsString +
        ' grados';
  aux := aux + ' y la fuerza del papel ';
  if Data.CotizacionEstadoPAPEL.Value > dmComentario.EstadoAyerPAPEL.Value then
   aux := aux + 'aumenta ya que pasa de los ' + dmComentario.EstadoAyerPAPEL.AsString +
     ' grados que tenía en la sesión anterior a los ' + Data.CotizacionEstadoPAPEL.AsString +
     ' grados de la sesión actual.'
  else
  if Data.CotizacionEstadoPAPEL.Value < dmComentario.EstadoAyerPAPEL.Value then
    aux := aux + 'desciende ya que pasa de los ' + dmComentario.EstadoAyerPAPEL.AsString +
      ' grados que tenía en la sesión anterior a los ' + Data.CotizacionEstadoPAPEL.AsString +
      ' grados de la sesión actual.'
  else
    aux := aux + 'se mantiene fijo en los ' + Data.CotizacionEstadoPAPEL.AsString + ' grados.';
  Comentario.Lines.Add(aux);
  Comentario.Lines.Add('');

  aux := 'Si ahora examinamos los cambios de las cuatro últimas sesiones observamos que ' +
  'su evolución ha sido ';
  if (cambios[3] < cambios[2]) and (cambios[2] < cambios[1]) and
  (cambios[1] < cambios[0]) and (cambios[0] < Data.CotizacionCIERRE.Value) then
  aux := aux + 'alcista ya que en todas ellas los cambios han subido y por tanto ' +
    'una corrección a cortísimo plazo es más que probable (Regla de las siete sesiones).'
  else
   if (cambios[3] > cambios[2]) and (cambios[2] > cambios[1]) and
    (cambios[1] > cambios[0]) and (cambios[0] > Data.CotizacionCIERRE.Value) then
      aux := aux + 'bajista ya que en todas ellas los cambios han bajado y por tanto ' +
      'una correción a cortísimo plazo es más que probable (Regla de las siete sesiones).'
    else begin
      aux := aux + 'la siguente: Hace cuatro sesiones ';
      aux := aux + comparar(cambios[3], cambios[2]) + ' a ';
      aux := aux + CurrToStr(cambios[2]) + ', hace tres sesiones ';
      aux := aux + comparar(cambios[2], cambios[1]) + ' a ';
      aux := aux + CurrToStr(cambios[1]) + ', dos sesiones atrás ';
      aux := aux + comparar(cambios[1], cambios[0]) + ' a ';
      aux := aux + CurrToStr(cambios[0]) + ' y finalmente en la sesión última ' +
        'que estamos comentando, el cambio ha ';
      aux := aux + comparar(cambios[0], Data.CotizacionCIERRE.Value) + ' a ';
      aux := aux + Data.CotizacionCIERRE.AsString;
      aux := aux + ' tal como se ha dicho anteriormente.';
    end;
  Comentario.Lines.Add(aux);
end;

procedure TfComentario.FormCreate(Sender: TObject);
begin
  inherited;
  dmComentario := TdComentario.Create(Self);
  Lector := TLector.Create(Self);
  TLectorImages.Create(Self);
  VocesInicializadas := false;
end;

procedure TfComentario.FormResize(Sender: TObject);
begin
  inherited;
  PostMessage(Handle, WM_AFTER_RESIZE, 0, 0);
end;

procedure TfComentario.Titulo(cad: string);
begin
  Comentario.Lines.Add('');
  Comentario.SelAttributes.Color := clBlue;
  Comentario.SelAttributes.Height := 16;
  Comentario.Lines.Add(cad);
  Comentario.SelAttributes.Color := clBlack;
end;

procedure TfComentario.VozPararExecute(Sender: TObject);
begin
  inherited;
  Lector.ParaDeHablar;
  VozPausa.Enabled := false;
  VozParar.Enabled := false;
  VozReproducir.Enabled := true;
end;

procedure TfComentario.VozPausaExecute(Sender: TObject);
begin
  inherited;
  VozParar.Enabled := not VozParar.Enabled;
  Lector.Pausa;
end;

procedure TfComentario.VozReproducirExecute(Sender: TObject);
begin
  inherited;
  if VocesInicializadas then begin
    VozPausa.Enabled := true;
    VozParar.Enabled := true;
    VozReproducir.Enabled := false;
    Lector.Habla(Comentario.Text);
  end
  else begin
    try
      // No se puede poner el InitializeVoices en el constructor del TLectorFP
      // porque si tira una excepción esta no se porque no se coge en el except
      Lector.InitializeVoices;
      Lector.OnHablaFinalizada := OnHablaFinalizada;
      VocesInicializadas := true;
      VozReproducirExecute(Sender);
    except
      Lector.MostrarErrorVoz;
    end;
  end;
end;

end.
