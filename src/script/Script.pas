unit Script;

interface

uses Classes, ScriptObject, TypInfo, ScriptEngine, ScriptRTTI;

type
  TScript = class(TComponent)
  private
    RootObjects: TStringList;
//    code: TStrings;
//    line: integer;
//    procedure OnScriptObjectGetVars(varNames, varTypes: TStrings);
    function GetScriptRTTIAndFreeScriptObject(objScript: TScriptObject): TScriptRTTI;
    function GetScriptRTTI(objScript: TScriptObject): TScriptRTTI;
    function GetObjectReturnType(const ScriptRTTI: TScriptRTTI;
      const StackObjects: TStringList): PTypeInfo;
    function GetObjectFunctionParametersHint(const ScriptRTTI: TScriptRTTI;
      const StackObjects: TStringList; const ItemList: TStrings): boolean; overload;
    function GetSelfProposal(const ScriptRTTI: TScriptRTTI;
      const ItemList, InsertList: TStrings): boolean;
    function GetFunctionProposal(const ScriptRTTI: TScriptRTTI;
      const name: string): TScriptObject;
    function GetObjectProposal(const ScriptRTTI: TScriptRTTI;
      const StackObjects: TStringList; const ItemList, InsertList: TStrings): boolean;
    procedure GetVars(const code: TStrings; line: integer; varName, varType: TStrings);
    function GetStackObjects(line: string; posX, posIni: integer): TStringList;
    function GetProposal(const code: TStrings; const line: integer;
      const StackObjects: TStringList; const ItemList, InsertList: TStrings): boolean; overload;
    function GetFunctionParametersHint(const StackObjects: TStringList; const ItemList: TStrings): boolean; overload;
  public
    constructor Create(const scriptEngine: TScriptEngine); reintroduce;
    function GetProposal(const code: TStrings; line, lineX: integer;
      const ItemList, InsertList: TStrings): boolean; overload;
    function GetFunctionParametersHint(const line: string; posx: integer;
      const ItemList: TStrings; var numParametro: integer): boolean; overload;
    function GetRootObject(const name: string): TScriptObject;
  end;

  procedure RegisterEnumeration(const name: string; const tipo: PTypeInfo);

implementation

uses SysUtils;

var
  enumerations: TStringList;
{ TScript }

  procedure RegisterEnumeration(const name: string; const tipo: PTypeInfo);
  begin
    if enumerations = nil then
      enumerations := TStringList.Create;
    enumerations.AddObject(Uppercase(name), TObject(tipo));
  end;

constructor TScript.Create(const scriptEngine: TScriptEngine);
begin
  inherited Create(nil);
  RootObjects := scriptEngine.RootObjects;
end;

function TScript.GetFunctionParametersHint(const StackObjects: TStringList;
  const ItemList: TStrings): boolean;
var i: integer;
  obj: TScriptObject;
  objRTTI: TScriptRTTI;
begin
  if StackObjects.Count > 0 then begin
    for i := 1 to RootObjects.Count do begin
      if UpperCase(RootObjects[i - 1]) = StackObjects[0] then begin
        StackObjects.Delete(0);
        obj := RootObjects.Objects[i - 1] as TScriptObject;
        objRTTI := GetScriptRTTI(obj);
        try
          result := GetObjectFunctionParametersHint(objRTTI, StackObjects, ItemList);
        finally
          objRTTI.Free;
        end;
        exit;
      end;
    end;
  end;
  result := false;
end;

function TScript.GetFunctionParametersHint(const line: string; posx: integer;
  const ItemList: TStrings; var numParametro: integer): boolean;
var StackObjects: TStringList;
    c: char;
    lastObj, sNumParam: string;
    posObj, num, numParentesis, posIni: integer;
    isNumber: boolean;
begin
  if (posX = 1) or (length(line) = 0) then
    result := false
  else begin
    posIni := posX;
    if length(line) < posX then
      posX := length(line) + 1;  // + 1, ya que despues se realiza un dec(posX)
    numParentesis := 1;
    repeat
      dec(posX);
      c := line[posX];
      if c = ' ' then begin
        repeat
          dec(posX);
          c := line[posX];
        until (posX = 1) or (c <> ' ');
      end;
      if c = ')' then
        inc(numParentesis)
      else
        if c = '(' then
          dec(numParentesis);
    until (posX = 1) or ((c = '(') and (numParentesis = 0));
    if (posX > 1) and (c = '(') then begin
      StackObjects := GetStackObjects(line, posX, posIni);
      // Extraemos el número de parámetro y pasamos al nuevo formato.
      // Ejemplo: formato Datos/Mensaje/Es(1) --> Extraemos 1 y cambiamos el Es(1) por Es
      try
        num := StackObjects.Count - 1;
        lastObj := StackObjects[num];
        posObj := length(lastObj);
        if (lastObj[posObj] = ')') then begin
          repeat
            dec(posObj);
            c := lastObj[posObj];
            isNumber := (c >= '0') and (c <= '9');
            if isNumber then
              sNumParam := c + sNumParam;
          until (not isNumber) or (posObj = 1);
          if (posObj > 1) and (c = '(') then begin
            StackObjects[num] := Copy(lastObj, 1, posObj - 1);
            result := GetFunctionParametersHint(StackObjects, ItemList);
            if result then
              numParametro := StrToInt(sNumParam) - 1;
          end
          else
            result := false;
        end
        else
          result := false;
      finally
        StackObjects.Free;
      end;
    end
    else
      result := false;
  end;
end;

function TScript.GetFunctionProposal(const ScriptRTTI: TScriptRTTI;
  const name: string): TScriptObject;
var method: TScriptMethod;
  cad: string;
  objClass: TClass;
begin
  try
    method := ScriptRTTI.Find(name);
    if (method.hasReturn) and (method.return.Kind = tkClass) then begin
      cad := 'TScript' + Copy(method.return.Name, 2, length(method.return.Name));
      try
        objClass := FindClass(cad);
        result := TScriptObjectClass(objClass).Create;
      except
        result := nil;
      end;
    end
    else
      result := nil;
  except
    on EMethodNameNotFound do begin
      result := nil;
    end;
  end;
end;

function TScript.GetObjectFunctionParametersHint(const ScriptRTTI: TScriptRTTI;
  const StackObjects: TStringList; const ItemList: TStrings): boolean;
var obj, cad: string;
  i: integer;
  method: TScriptMethod;
  param: TScriptParam;

    function funcion(const nombre: string): boolean;
    var objScript: TScriptObject;
      objScriptRTTI: TScriptRTTI;
    begin
      objScript := GetFunctionProposal(ScriptRTTI, nombre);
      if objScript = nil then
        result := false
      else begin
        objScriptRTTI := GetScriptRTTIAndFreeScriptObject(objScript);
        try
          StackObjects.Delete(0);
          result := GetObjectFunctionParametersHint(objScriptRTTI, StackObjects, ItemList);
        finally
          objScriptRTTI.Free;
        end;
      end;
    end;

begin
  if StackObjects.Count = 1 then begin
    obj := StackObjects[0];
    try
      method := ScriptRTTI.Find(obj);
      result := length(method.params) > 0;
      if result then begin
        cad := '';
        for i := Low(method.params) to High(method.params) do begin
          param := method.params[i];
          cad := cad + '"' + param.name + ': ' + param.tipo.Name + ',", ';
        end;
        Delete(cad, Length(cad) - 3, 4);
        cad := cad + '"';
  //    ItemList.Add('"puntos: integer", "largos: boolean", "stop: currency"')
        ItemList.Add(cad);
      end;
    except
      on EMethodNameNotFound do
        result := false;
    end;
  end
  else begin
    obj := StackObjects[0];
    i := Pos('(', obj);
      //Ej: DIARIO o DIARIO() --> Debe realizarse un proposal de lo que devuelva
      // la función
    if i > 0 then
      result := funcion(Copy(obj, 1, i - 1))
    else
      result := funcion(obj);
  end;
end;

function TScript.GetObjectReturnType(const ScriptRTTI: TScriptRTTI;
  const StackObjects: TStringList): PTypeInfo;
var method: TScriptMethod;
    objScript: TScriptObject;
    objScriptRTTI: TScriptRTTI;
begin
  StackObjects.Delete(0);
  if StackObjects.Count = 1 then begin
    try
      method := ScriptRTTI.Find(StackObjects[0]);
      result := method.return;
    except
      on EMethodNameNotFound do
        result := nil;
    end;
  end
  else begin
    objScript := GetFunctionProposal(ScriptRTTI, StackObjects[0]);
    if objScript = nil then
      result := nil
    else begin
        objScriptRTTI := GetScriptRTTIAndFreeScriptObject(objScript);
        try
          result := GetObjectReturnType(objScriptRTTI, StackObjects);
        finally
          objScriptRTTI.Free;
        end;
    end;
  end;
end;

function TScript.GetObjectProposal(const ScriptRTTI: TScriptRTTI;
  const StackObjects: TStringList; const ItemList,
  InsertList: TStrings): boolean;
var obj: string;
  i, j, numParam: integer;

    function funcion(const nombre: string): boolean;
    var objScript: TScriptObject;
      objScriptRTTI: TScriptRTTI;
    begin
      objScript := GetFunctionProposal(ScriptRTTI, nombre);
      if objScript = nil then
        result := false
      else begin
        StackObjects.Delete(0);
        objScriptRTTI := GetScriptRTTIAndFreeScriptObject(objScript);
        try
          result := GetObjectProposal(objScriptRTTI, StackObjects, ItemList, InsertList);
        finally
          objScriptRTTI.Free;
        end;
      end;
    end;

    function parameter(const nombre: string; numParam: integer): boolean;
    var method: TScriptMethod;
      cad, tipo: string;
      param: TScriptParam;
      OrdTypeData: PTypeData;
      MinVal, MaxVal, i: integer;
      typeInfo: TTypeInfo;
      varNames, varTypes: TStringList;
    begin
      method := ScriptRTTI.Find(nombre);
      param := method.params[numParam - 1];
      typeInfo := param.tipo;
      if typeInfo.Kind = tkEnumeration then begin
        OrdTypeData := GetTypeData(@typeInfo);
        MinVal := OrdTypeData^.MinValue;
        MaxVal := OrdTypeData^.MaxValue;
        for i := MinVal to MaxVal do begin
          cad := GetEnumName(@typeInfo, i);
          ItemList.Add(cad);
          InsertList.Add(cad);
        end;
        result := true;
      end
      else begin
        result := false;
        varNames := TStringList.Create;
        try
          varTypes := TStringList.Create;
          try
//            FOnGetVariables(varNames, varTypes);
            tipo := UpperCase(typeInfo.Name);
            for i := 0 to varTypes.Count - 1 do begin
              if varTypes[i] = tipo then begin
                cad := varNames[i];
                ItemList.Add(cad);
                InsertList.Add(cad);
                result := true;
              end;
            end;
          finally
            varTypes.Free;
          end;
        finally
          varNames.Free;
        end;
      end;
    end;

begin
  if StackObjects.Count = 0 then begin
    result := GetSelfProposal(ScriptRTTI, ItemList, InsertList);
  end
  else begin
    obj := StackObjects[0];
    i := Pos('(', obj);
    j := Pos(')', obj);
    if (i > 0) and (j > i + 1) then begin
       //Ej: DIARIO(1) --> Debe realizarse un proposal del primer parámetro de la función
      numParam := StrToInt(Copy(obj, i + 1, j - i - 1));
      result := parameter(Copy(obj, 1, i - 1), numParam);
    end
    else begin
      //Ej: DIARIO o DIARIO() --> Debe realizarse un proposal de lo que devuelva
      // la función
      if i > 0 then
        result := funcion(Copy(obj, 1, i - 1))
      else
        result := funcion(obj);
    end;
  end;
end;

function TScript.GetProposal(const code: TStrings; line, lineX: integer;
  const ItemList, InsertList: TStrings): boolean;
var c: char;
  StackObjects: TStringList;
  posIni: integer;
  linea: string;

  procedure RootValues;
  var i, num: integer;
    name: string;
  begin
    num := RootObjects.Count - 1;
    for i := 0 to num do begin
      name := RootObjects[i];
      InsertList.Add(name + '.');
      ItemList.Add(name + ': T' + name);
    end;
  end;

  procedure ReturnValues;
  var MaxVal, MinVal, i, j, num: integer;
    obj: TScriptObject;
    objRTTI: TScriptRTTI;
    tipo: PTypeInfo;
    vars, varsTipo: TStringList;

      procedure Enumeration(tipo: PTypeInfo);
      var OrdTypeData: PTypeData;
        cad: string;
        i: integer;
      begin
        OrdTypeData := GetTypeData(tipo);
        MinVal := OrdTypeData^.MinValue;
        MaxVal := OrdTypeData^.MaxValue;
        for i := MinVal to MaxVal do begin
          cad := GetEnumName(tipo, i);
          ItemList.Add(cad);
          InsertList.Add(cad);
        end;
        ItemList.Add('');
        InsertList.Add('');
      end;
  begin
    StackObjects := GetStackObjects(linea, lineX, posIni);
    try
      if StackObjects.Count > 1 then begin
        num := RootObjects.Count - 1;
        for i := 0 to num do begin
          if UpperCase(RootObjects[i]) = StackObjects[0] then begin
            obj := RootObjects.Objects[i] as TScriptObject;
            objRTTI := GetScriptRTTI(obj);
            try
              tipo := GetObjectReturnType(objRTTI, StackObjects);
            finally
              objRTTI.Free;
            end;
            if (tipo <> nil) and (tipo^.Kind = tkEnumeration) then
              Enumeration(tipo);
            break;
          end;
        end;
      end
      else begin
        if StackObjects.Count = 1 then begin
          // ¿Alguna variable creada por el usuario?
          vars := TStringList.Create;
          try
            varsTipo := TStringList.Create;
            try
              GetVars(Code, Line, vars, varsTipo);
              num := vars.Count - 1;
              for i := 0 to num do begin
                if Uppercase(vars[i]) = Uppercase(StackObjects[0]) then begin
                  j := enumerations.IndexOf(Uppercase(varsTipo[i]));
                  if j > 0 then begin
                    Enumeration(PTypeInfo(enumerations.Objects[j]));
                    ItemList.Add('');
                    InsertList.Add('');
                  end;
                  break;
                end;
              end;
            finally
              varsTipo.Free;
            end;
          finally
            vars.Free;
          end;
        end;
      end;
    finally
      StackObjects.Free;
    end;
  end;

begin
  inherited;
  linea := code[line];
  if (lineX = 0) or (length(linea) = 0) then begin
    RootValues;
    result := true;
  end
  else begin
    posIni := lineX;
    if length(linea) < lineX then
      lineX := length(linea);
    repeat
      c := linea[lineX];
      dec(lineX);
    until (lineX = 0) or (c in ['.', '(', ')', '=', '+']);
    if lineX = 0 then begin
      RootValues;
      result := true;
    end
    else begin
      if c in ['=', '+'] then begin
        if linea[lineX] = ':' then //Caso :=
          dec(lineX);
        ReturnValues;
        RootValues;
        result := true;
      end
      else begin
        if c <> ')'then begin
          inc(lineX);
          StackObjects := GetStackObjects(linea, lineX, posIni);
          try
            result := GetProposal(code, posIni, StackObjects, ItemList, InsertList);
          finally
            StackObjects.Free;
          end;
          if c = '(' then begin
            if result then begin
              ItemList.Add('');
              InsertList.Add('');
            end
            else
              result := true;
            RootValues;
          end;
        end
        else
          result := false;
      end;
    end;
  end;
end;

function TScript.GetRootObject(const name: string): TScriptObject;
var i: integer;
begin
  for i := 1 to RootObjects.Count do begin
    if UpperCase(RootObjects[i - 1]) = UpperCase(name) then begin
      result := RootObjects.Objects[i - 1] as TScriptObject;
      exit;
    end;
  end;
  result := nil;
end;

function TScript.GetProposal(const code: TStrings; const line: integer;
  const StackObjects: TStringList; const ItemList, InsertList: TStrings): boolean;
var i, num: integer;
  obj: TScriptObject;
  objRTTI: TScriptRTTI;
  so, tipo: string;
  objClass: TClass;
  varNames, varTypes: TStringList;
begin
  if StackObjects.Count > 0 then begin
    // Necesario por si se llama a OnScriptObjectGetVars
//    Self.Code := Code;
//    Self.Line := line;
    num := RootObjects.Count - 1;
    for i := 0 to num do begin
      if UpperCase(RootObjects[i]) = StackObjects[0] then begin
        StackObjects.Delete(0);
        obj := RootObjects.Objects[i] as TScriptObject;
//        obj.OnGetVariables := OnScriptObjectGetVars;
        objRTTI := GetScriptRTTI(obj);
        try
          result := GetObjectProposal(objRTTI, StackObjects, ItemList, InsertList);
        finally
          objRTTI.Free;
        end;
        exit;
      end;
    end;

    so := StackObjects[0];
    varNames := TStringList.Create;
    try
      varTypes := TStringList.Create;
      try
        GetVars(Code, line, varNames, varTypes);
        i := varNames.IndexOf(so);
        if i > -1 then begin
          tipo := varTypes[i];
          if UpCase(tipo[1]) = 'T' then begin //Es un objeto, buscamos su TScript = TScript + Sacamos la T de delante
              tipo := 'TScript' + Copy(tipo, 2, length(tipo));
            try
              objClass := FindClass(tipo);
              StackObjects.Delete(0);
              obj := TScriptObjectClass(objClass).Create;
              objRTTI := GetScriptRTTIAndFreeScriptObject(obj);
              try
                result := GetObjectProposal(objRTTI, StackObjects, ItemList, InsertList);
              finally
                objRTTI.Free;
              end;
            except
              on EClassNotFound do
                result := false;
            end;
          end
          else
            result := false;
        end
        else
          result := false;
      finally
        varTypes.Free;
      end;
    finally
      varNames. Free;
    end;
  end
  else
    result := false;
end;

function TScript.GetScriptRTTI(objScript: TScriptObject): TScriptRTTI;
var scriptObjectInstance: TScriptObjectInstance;
begin
  scriptObjectInstance := objScript.ScriptInstance;
  result := TScriptRTTI.Create(scriptObjectInstance);
  // No se debe hacer un scriptObjectInstance.Free, ya que este ya se destruye
  // cuando se destruya el objScript
end;

function TScript.GetScriptRTTIAndFreeScriptObject(
  objScript: TScriptObject): TScriptRTTI;
begin
  try
    result := GetScriptRTTI(objScript);
  finally
    objScript.Free;
  end;
end;

function TScript.GetSelfProposal(const ScriptRTTI: TScriptRTTI;
  const ItemList, InsertList: TStrings): boolean;
var i: integer;
  cad, params: string;
  num: integer;
  methods: TScriptMethods;
  method: TScriptMethod;

    function GetParams(params: array of TScriptParam): string;
    var i, num: integer;
    begin
      result := '';
      num := length(params) - 1;
      for i := 0 to num do begin
        result := result + params[i].name + ': ' + params[i].tipo.Name;
        if i < num then
          result := result + '; ';
      end;
    end;

begin
  methods := ScriptRTTI.Methods;
  num := length(methods) - 1;
  for i := 0 to num do begin
    method := methods[i];
    cad := method.name;
    params := GetParams(method.params);
    if params = '' then begin
      if (method.hasReturn) and (method.return.Kind = tkClass) then
        InsertList.Add(method.name + '.')
      else
        InsertList.Add(method.name);
    end
    else begin
      cad := cad + '( ' + params + ' )';
      InsertList.Add(method.name + '(');
    end;
    if method.hasReturn then
      cad := cad + ': ' + method.return.Name;
    ItemList.Add(cad);
  end;
  result := ItemList.Count > 0;
end;

function TScript.GetStackObjects(line: string; posX, posIni: integer): TStringList;
var cad: string;
  salir: boolean;
  c: char;
  foundPunto: boolean;

  function FormatearParametros(cad: string): string;
  var num, i: integer;
  begin
    if cad[length(cad)] = '(' then begin
      num := 1;
      i := posX;
      while (length(line) >= i) and (i < posIni) do begin
        if line[i] = ',' then
          inc(num);
        inc(i);
      end;
      cad := cad + IntToStr(num) + ')';
    end;
    result := UpperCase(cad);
  end;

begin
  result := TStringList.Create;
  cad := '';
  c := line[posX];
  while (c = ' ') and (posX > 1) do begin
    dec(posX);
    c := line[posX];
  end;
  foundPunto := line[posX] = '.';
  repeat
    c := line[posX];
    if c = ' ' then begin
      while (c = '') and (posX > 1) do begin
        dec(posX);
        c := line[posX];
      end;
      salir := (c <> '(') and (c <> ',');
      if (salir) and (cad <> '') then begin
        result.Insert(0, FormatearParametros(cad));
        cad := '';
      end;
    end
    else begin
      if c = '.' then begin
        // Caso en que exactamente despues del . se haga Ctrl+Space, la
        // primera cad = ''
        if cad <> '' then begin
          result.Insert(0, FormatearParametros(cad));
          cad := '';
        end;
        foundPunto := true;
      end
      else begin
        if c in ['(', ',', '=', '+', '-', '*', '/'] then begin
          if cad <> '' then begin
            result.Insert(0, FormatearParametros(cad));
            cad := '';
          end
          else
            cad := c + cad;
          // Caso ...Mensaje.Es(Datos. --> Ahora lo que hay antes del ( no importa
          if foundPunto then
            posX := 1 // Lo posicionamos a 1 para que salga
        end
        else begin
          if c = ']' then begin // p.e. Datos[i]
            while (posX > 1) and (c <> '[') do begin
              dec(posX);
              c := line[posX];
            end;
          end
          else begin
            // Se cierra una función, por lo que nos interesa que devuelve,
            // que seria solo el nombre
            if c = ')' then begin
              repeat
                dec(posX);
                c := line[posX];
              until (c = '(') or (posX = 1);
              // Para indicar que se quiere lo que devuelve la función
              cad := '()' + cad;
            end
            else
              cad := c + cad;
          end;
        end;
      end;
      dec(posX);
      salir := PosX = 0;
    end;
  until (salir);
  if cad <> '' then
    result.Insert(0, FormatearParametros(cad));
end;

procedure TScript.GetVars(const code: TStrings; line: integer; varName, varType: TStrings);
var beginFound, varFound, searchVariable: boolean;
  tipo, variable, codigo: string;
  i, posX: integer;

  procedure SkipBlanks;
  begin
    while codigo[posX] in [' ', #13, #10, #8] do
      dec(posX);
  end;

  function GetChar: char;
  begin
    result := UpCase(codigo[posX]);
  end;

begin
  posX := 0;
  codigo := '';
  for i := 0 to line - 1 do begin  // -1 zero based
    codigo := codigo + code[i] + ' '; // Sustituidos los saltos de línea por un espacio
    posX := posX + length(code[i]) + 1;
  end;

  beginFound := false;
  while (posX > 5) and (not beginFound) do begin
    if GetChar = 'N' then begin
      dec(posX);
      if GetChar = 'I' then begin
        dec(posX);
        if GetChar = 'G' then begin
          dec(posX);
          if GetChar = 'E' then begin
            dec(posX);
            if GetChar = 'B' then begin
              dec(posX);
              beginFound := (GetChar in [' ', ';', #13, #10, #8]) or (posX = 0);
              if (beginFound) and (GetChar = ';') then
                //Se incrementa porque despues se va a decrementar y para empezar a
                // buscar variables está el "if GetChar = ';' then begin"
                inc(posX);
            end;
          end;
        end;
      end;
    end;
    dec(posX);
  end;

  if beginFound then begin
    try
      SkipBlanks;
      if GetChar = ';' then begin
        varFound := false;
        while not varFound do begin
          dec(posX);
          SkipBlanks;
          tipo := '';
          while GetChar <> ':' do begin
            tipo := GetChar + tipo; //Vamos hacia atrás, entonces es + tipo
            dec(posX);
          end;
          dec(posX);
          tipo := TrimLeft(tipo);
          SkipBlanks;
          searchVariable := true;
          while searchVariable do begin
            variable := '';
            while not (GetChar in [',' , ';', ' ', #13, #10, #8]) do begin
              //El nombre de la variable se guarda igual como está escrita,
              //por eso codigo[posX] y no GetChar
              variable := codigo[posX] + variable;
              dec(posX);
            end;
            varName.Add(variable);
            varType.Add(tipo);
            SkipBlanks;
            searchVariable := GetChar = ',';
            if searchVariable then
              dec(posX);
          end;
          SkipBlanks;
          if not (GetChar = ';') then begin
            // Ahora debe venir var
            if GetChar = 'R' then begin
              dec(posX);
              if GetChar = 'A' then begin
                dec(posX);
                if GetChar = 'V' then begin
                  dec(posX);
                  varFound := (posX = 0) or (GetChar in [' ', #13, #10, #8]);
                end;
              end;
            end;
            if not varFound then begin
              varName.Clear;
              varType.Clear;
              exit;
            end;
          end;
        end;
      end;
    except
      // Así no tenemos que estar comprobando cada vez que posX > 0
      on ERangeError do begin
        varName.Clear;
        varType.Clear;
      end;
    end;
  end;
end;

{procedure TScript.OnScriptObjectGetVars(varNames, varTypes: TStrings);
begin
  GetVars(Code, line, varNames, varTypes);
end;}

initialization

finalization
  enumerations.Free;

end.
