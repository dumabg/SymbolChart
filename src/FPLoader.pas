unit FPLoader;

interface

  function Precondiciones: boolean;
  procedure InitializeEnvironment;

implementation

uses dmConfiguracion, UtilForms, Dialogs, Registry, fmBloquear, SysUtils,
  Windows, Forms, Controls, dmBD, IBDatabase, IBSQL, UtilDB, Classes;

resourcestring
  E_ID = 'El programa no puede iniciarse porque no se ha instalado correctamente.' + #13 +
    'Por favor, vuelva a instalarlo.';
  TITULO_ERROR_INSTALACION = 'Error de instalación';
  BLOQUEAR_CAPTION = 'Identificación de entrada';


  function ExistGUID(const GUID: string): boolean;
  var sGUID: string;
    reg: TRegistry;
  begin
    sGUID := '{' + Copy(GUID, 1, 8) + '-' + Copy(GUID, 9, 4) + '-' +
      Copy(GUID, 13, 4) + '-' + Copy(GUID, 17, 4) + '-' + Copy(GUID, 21, 12) + '}';
    reg := TRegistry.Create;
    try
      reg.RootKey := HKEY_LOCAL_MACHINE;
      result := reg.KeyExists('\SOFTWARE\Classes\CLSID\' + sGUID);
    finally
      reg.Free;
    end;
  end;

  function CheckGUID: boolean;
  var GUID: string;

      function isGUIDDBEqual(BDDatos: TBDDatos): boolean;
      var database: TIBDatabase;
        q: TIBSQL;
      begin
        database := BD.GetNewDatabase(nil, scdDatos, BDDatos);
        try
          q := TIBSQL.Create(nil);
          try
            q.Database := database;
            q.SQL.Text := 'select VALOR from SISTEMA where SECCION=''SISTEMA'' and NOMBRE=''GUID''';
            ExecQuery(q, true);
            result := GUID = q.Fields[0].AsString;
          finally
            q.Free;
          end;
        finally
          database.Free;
        end;
      end;

      function PrimeraVez: string;
      var data: TFileStream;
        buffer: array [1..32] of char;
      begin
        data := TFileStream.Create(ExtractFilePath(Application.ExeName) + 'I.DAT', fmOpenRead or fmShareDenyNone);
        try
          data.Read(buffer, length(buffer));
          result := buffer;
        finally
          data.Free;
        end;
      end;

      procedure InitBD(database: TIBDatabase);
      var q: TIBSQL;
      begin
        q := TIBSQL.Create(nil);
        try
          q.Database := database;
          q.SQL.Text := 'insert into SISTEMA (OID_SISTEMA, SECCION, NOMBRE, VALOR) ' +
            ' values (1, ''SISTEMA'', ''GUID'',''' + GUID + ''')';
          ExecQuery(q, true);
        finally
          q.Free;
        end;
      end;

      procedure InitBDs;
      var database: TIBDatabase;
      begin
        database := BD.GetNewDatabase(nil, scdComun, bddDiaria);
        try
          InitBD(database);
        finally
          database.Free;
        end;
        database := BD.GetNewDatabase(nil, scdDatos, bddDiaria);
        try
          InitBD(database);
        finally
          database.Free;
        end;
        database := BD.GetNewDatabase(nil, scdDatos, bddSemanal);
        try
          InitBD(database);
        finally
          database.Free;
        end;
      end;
  begin
    GUID := Configuracion.Sistema.GUID;
    if GUID = '' then begin
      GUID := PrimeraVez;
      InitBDs;
      Configuracion.Sistema.GUID := GUID;
      result := true;
    end
    else begin
      result := (GUID = '0') or ((GUID <> '') and (ExistGUID(GUID)));
      if result then begin
        result := isGUIDDBEqual(bddDiaria);
        if result then
          result := isGUIDDBEqual(bddSemanal);
      end;
    end;
  end;

  function CheckLogin: boolean;
  var salir: boolean;
    fBloquear: TfBloquear;
  begin
    if (Configuracion.Identificacion.Bloquear) and (Configuracion.Identificacion.AlEntrar) then begin
      fBloquear := TfBloquear.Create(nil);
      try
        fBloquear.Caption := BLOQUEAR_CAPTION;
        salir := false;
        fBloquear.ShowModal;
        salir := fBloquear.CerrarAplicacion;
      finally
        fBloquear.Free;
      end;
      result := not salir;
    end
    else
      result := true;
  end;

  function Precondiciones: boolean;
  begin
    result := CheckGUID;
    if result then begin
      result := CheckLogin;
    end
    else
      ShowMensaje(TITULO_ERROR_INSTALACION, E_ID, mtError, [mbOK]);
  end;

  procedure InitializeEnvironment;
  var C: HCURSOR;
  begin
    ThousandSeparator := #0;
    DecimalSeparator := ',';
    CurrencyString := '';
    DateSeparator := '/';
    ShortDateFormat := 'dd/MM/yy';
    LongDateFormat := 'dd/MM/yyyy';

    { Replace Borland's hand cursor with windows default one, if available }
    C := LoadCursor(0, IDC_HAND);
    if C <> 0 then
      Screen.Cursors[crHandPoint] := C;
  end;

end.
