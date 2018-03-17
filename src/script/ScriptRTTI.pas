unit ScriptRTTI;

interface

uses Classes, SysUtils, ObjAuto, TypInfo;

type
  TScriptParam = record
    name: ShortString;
    tipo: TTypeInfo;
  end;

  TScriptParams = array of TScriptParam;

  TScriptMethod = record
    name: string;
    params: TScriptParams;
    hasReturn: boolean;
    return: PTypeInfo;
  end;

  TScriptMethods = array of TScriptMethod;

  EMethodNameNotFound = class(Exception);

  TScriptRTTI = class
  private
    FMethods: TScriptMethods;
    function NextParam(const Param: PParamInfo): PParamInfo;
  public
    constructor Create(const obj: TObject);
    function Find(const methodName: string): TScriptMethod;
    property Methods: TScriptMethods read FMethods;
  end;


implementation



const
  SHORT_LEN = sizeof(ShortString) - 1;

{ TScriptRTTI }

constructor TScriptRTTI.Create(const obj: TObject);
var
  VMT: Pointer;
  MethodInfo: Pointer;
  Count, CountProperties: Integer;
  method: PMethodInfoHeader;
  MethodHeader: PMethodInfoHeader;
  i: Integer;
  MethodName: string;
  Properties: TPropList;

    procedure Params(const i: integer);
    var
      headerEnd: Pointer;
      Params, Param: PParamInfo;
      numParams, j: integer;
      scriptParam: TScriptParam;
    begin
      // Check the length is greater than just that of the name
      if MethodHeader.Len <= SizeOf(TMethodInfoHeader) - SHORT_LEN + Length(MethodHeader.Name) then
        exit;
      headerEnd := Pointer(Integer(MethodHeader) + MethodHeader^.Len);
      // Get a pointer to the param info
      Params := PParamInfo(Integer(MethodHeader) + SizeOf(MethodHeader^) - SHORT_LEN + SizeOf(TReturnInfo) + Length(MethodHeader^.Name));
      numParams := 0;
      // Loop over the parameters
      Param := Params;
      while Integer(Param) < Integer(headerEnd) do
      begin
        // Seems to be extra info about the return function, not sure what it means
        if (not (pfResult in Param.Flags)) and (Param.Name <> 'Self') then
          inc(numParams);
        Param := NextParam(Param);
      end;
      SetLength(FMethods[i].params, numParams);
      if numParams > 0 then begin
        Param := Params;
        j := 0;
        while Integer(Param) < Integer(headerEnd) do
        begin
          // Seems to be extra info about the return function, not sure what it means
          if (not (pfResult in Param.Flags)) and (Param.Name <> 'Self') then begin
            scriptParam.name := Param.Name;
            scriptParam.tipo := (Param.ParamType^)^;
            FMethods[i].params[j] := scriptParam;
            inc(j);
          end;
          // Find next param
          Param := NextParam(Param);
        end;
      end;
    end;

    procedure Return(const i: integer);
    var returnInfo: PReturnInfo;
      hasReturn: boolean;
      tipo: PTypeInfo;
    begin
      returnInfo := Pointer(MethodHeader);
      Inc(Integer(returnInfo), SizeOf(TMethodInfoHeader) - SHORT_LEN +
        Length(MethodName));
      hasReturn := ReturnInfo^.ReturnType <> nil;
      FMethods[i].hasReturn := hasReturn;
      if hasReturn then begin
        tipo := (returnInfo^.ReturnType^);
        FMethods[i].return := tipo;
      end;
    end;
begin
  inherited Create;
  // Inspirado en ObjAuto.GetMethodInfo(Obj, MethodName );
  VMT := PPointer(obj)^;
  MethodInfo := PPointer(Integer(VMT) + vmtMethodTable)^;
  if MethodInfo <> nil then
  begin
    // Scan method and get string about each
    Count := PWord(MethodInfo)^;
    // Reservamos memoria para el número de métodos
    SetLength(FMethods, Count);
    Inc(Integer(MethodInfo), 2);
    method := MethodInfo;
    for i := 0 to Count - 1 do
    begin
      MethodHeader := method;
      MethodName := method^.Name;
      FMethods[i].name := MethodName;
      Params(i);
      Return(i);
//      FMethods[i].name := DescriptionOfMethod(obj, methodName);
      Inc(Integer(method), PMethodInfoHeader(method)^.Len); // Get next method
    end;
  end
  else
    Count := 0;

  // Añadimos las propiedades
  CountProperties := GetPropList(PTypeInfo(obj.ClassInfo), tkAny, @Properties);
  SetLength(FMethods, Count + CountProperties);
  Dec(CountProperties);
  for i := 0 to CountProperties do begin
    with FMethods[i + Count] do begin
      name := Properties[i]^.Name;
      params := nil;
      hasReturn := false;
    end;
  end;
end;


function TScriptRTTI.Find(const methodName: string): TScriptMethod;
var i, num: integer;
  uMethodName: string;
begin
  num := length(FMethods) - 1;
  uMethodName := UpperCase(methodName);
  for i := 0 to num do begin
    if UpperCase(FMethods[i].name) = uMethodName then begin
      result := FMethods[i];
      exit;
    end;
  end;
  raise EMethodNameNotFound.Create('');
end;

function TScriptRTTI.NextParam(const Param: PParamInfo): PParamInfo;
begin
  Result := PParamInfo(Integer(Param) + SizeOf(TParamInfo) - SHORT_LEN + Length(Param^.Name));
end;

end.
