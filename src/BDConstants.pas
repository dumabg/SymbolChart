unit BDConstants;

interface

type
  TResultType = (rtBoolean = 0, rtCurrency, rtInteger, rtString);

const
  FS_TYPE_DIRECTORY: char = 'D';
  FS_TYPE_FILE: char = 'F';

  BOOLEAN_SI: char = 'S';
  BOOLEAN_NO: char = 'N';

  POSICION_LARGO: char = 'L';
  POSICION_CORTO: char = 'C';

  CONSULTA_TIPO_CARACTERISTICA: char = 'C'; //Caracteristica
  CONSULTA_TIPO_CODIGO: char = 'P'; //Programa

  function GetResultTypeString(const resultType: TResultType): string;
  function GetBooleanRepresentation(const boolValue: Boolean): string; inline;

implementation

  function GetResultTypeString(const resultType: TResultType): string;
  type aRT = array[TResultType] of string;
  const rt: aRT = ('boolean', 'currency', 'integer', 'string');
  begin
    result := rt[resultType];
  end;

  function GetBooleanRepresentation(const boolValue: Boolean): string;
  begin
    if boolValue then
      result := 'S'
    else
      result := 'N';
  end;

end.
