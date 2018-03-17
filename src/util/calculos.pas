unit calculos;

interface

  function coeficienteVariacion(const valores: array of currency): currency;
  function media(const valores: array of currency): currency;
  function nitidez(const distanciaMax: array of currency; const distanciaMin: array of currency): currency;
  function maximo(const valores: array of currency): currency;
  function minimo(const valores: array of currency): currency;
  function BandaBajaStudentFischer(const valores: array of currency): currency;
  function BandaAltaStudentFischer(const valores: array of currency): currency;
  function desviacionEstandar(const valores: array of currency; media: currency): currency;

implementation

uses math;

  function desviacionEstandar(const valores: array of currency; media: currency): currency;
  var i, num: integer;
  begin
    // desviación estándard --> sqr( ((X1-M)^2 + ... + (Xn-M)^2) / num ) )
    result := 0;
      // (X1-M)^2 + ... + (Xn-M)^2
    for i := Low(valores) to High(valores) do
      result := result + Power((valores[i] - media), 2);

    num := High(valores) - Low(valores) + 1;
    result := Power(result / num, 0.5);
  end;

  function BandaBajaStudentFischer(const valores: array of currency): currency;
  var m: currency;
    num: integer;
  begin
    num := High(valores) - Low(valores) + 1;
    // media - 2 * (desviacion estandard / sqr(num))
    m := media(valores);
    result := m - 2 * (desviacionEstandar(valores, m) / Power(num, 0.5));
  end;

  function BandaAltaStudentFischer(const valores: array of currency): currency;
  var m: currency;
    num: integer;
  begin
    num := High(valores) - Low(valores) + 1;
    // media + 2 * (desviacion estandard / sqr(num))
    m := media(valores);
    result := m + 2 * (desviacionEstandar(valores, m) / Power(num, 0.5));
  end;


  function maximo(const valores: array of currency): currency;
  var i, primero: integer;
  begin
    primero := Low(valores);
    result := valores[primero];
    for i := primero + 1 to High(valores) do
      if result < valores[i] then
        result := valores[i];
  end;

  function minimo(const valores: array of currency): currency;
  var i, primero: integer;
  begin
    primero := Low(valores);
    result := valores[primero];
    for i := primero + 1 to High(valores) do
      if result > valores[i] then
        result := valores[i];
  end;

  function media(const valores: array of currency): currency;
  var num: currency;
    i: integer;
  begin
    // Media  -->  (X1 + ... + Xn) / num
    num := High(valores) - Low(valores) + 1;
    result := 0;
    for i := Low(valores) to High(valores) do
      result := result + valores[i];
    result := result / num;
  end;

  function coeficienteVariacion(const valores: array of currency): currency;
  var m: currency;
  begin
    m := media(valores);
    // coeficiente variación --> desviacion estandard / M
    result := desviacionEstandar(valores, m) / m;
  end;

  function nitidez(const distanciaMax: array of currency;
                   const distanciaMin: array of currency): currency;
  begin
    result := media(distanciaMax) - media(distanciaMin);
  end;

end.
