inherited DataEstudio: TDataEstudio
  OldCreateOrder = True
  Height = 360
  Width = 435
  object iEstudio: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'insert into ESTUDIO'
      
        '  (ESTADO, CAPITAL, DESCRIPCION, DESDE, HASTA, OID_ESTUDIO, OR_C' +
        'UENTA, OR_ESTRATEGIA, '
      '   PAQUETES, USA100,   GRUPO, NOMBRE)'
      'values'
      
        '  ('#39'C'#39', :CAPITAL, :DESCRIPCION, :DESDE, :HASTA, :OID_ESTUDIO, :O' +
        'R_CUENTA, :OR_ESTRATEGIA, '
      '   :PAQUETES, :USA100,   :GRUPO, :NOMBRE)')
    Transaction = BD.IBTransactionUsuario
    Left = 216
    Top = 80
  end
  object qSesiones: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select FECHA from sesion'
      'where FECHA>=:DESDE and FECHA<=:HASTA'
      'order by FECHA')
    Left = 113
    Top = 80
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DESDE'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'HASTA'
        ParamType = ptUnknown
      end>
    object qSesionesFECHA: TDateField
      FieldName = 'FECHA'
      Origin = '"SESION"."FECHA"'
      Required = True
    end
  end
  object Valores: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <>
    IndexDefs = <>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    Version = '5.60'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 216
    Top = 168
    object ValoresOID_VALOR: TIntegerField
      FieldName = 'OID_VALOR'
    end
    object ValoresOID_MERCADO: TIntegerField
      FieldName = 'OID_MERCADO'
    end
  end
  object dCuenta: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'delete from CUENTA'
      'where OID_CUENTA=:OID_CUENTA')
    Transaction = BD.IBTransactionUsuario
    Left = 101
    Top = 168
  end
end
