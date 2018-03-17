object StopsManuales: TStopsManuales
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 248
  Width = 346
  object Valores: TkbmMemTable
    DesignActivation = True
    AttachedTo = Data.Valores
    AttachedAutoRefresh = True
    AttachMaxCount = 4
    FieldDefs = <
      item
        Name = 'OID_VALOR'
        Attributes = [faRequired]
        DataType = ftSmallint
      end
      item
        Name = 'OID_MERCADO'
        DataType = ftSmallint
      end
      item
        Name = 'NOMBRE'
        Attributes = [faRequired]
        DataType = ftString
        Size = 50
      end
      item
        Name = 'SIMBOLO'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'DECIMALES'
        DataType = ftSmallint
      end
      item
        Name = 'MERCADO'
        Attributes = [faRequired]
        DataType = ftString
        Size = 20
      end>
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
    AfterScroll = ValoresAfterScroll
    Left = 48
    Top = 104
    object ValoresOID_VALOR: TSmallintField
      FieldName = 'OID_VALOR'
      Origin = '"VALOR"."OID_VALOR"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ValoresOID_MERCADO: TSmallintField
      FieldName = 'OID_MERCADO'
      Origin = '"VALOR"."OR_MERCADO"'
    end
    object ValoresNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = '"VALOR"."NOMBRE"'
      Required = True
      Size = 50
    end
    object ValoresSIMBOLO: TIBStringField
      FieldName = 'SIMBOLO'
      Origin = '"VALOR"."SIMBOLO"'
    end
    object ValoresDECIMALES: TSmallintField
      FieldName = 'DECIMALES'
      Origin = '"MERCADO"."DECIMALES"'
    end
    object ValoresMERCADO: TIBStringField
      FieldName = 'MERCADO'
      Origin = '"MERCADO"."PAIS"'
      Required = True
    end
  end
  object qStops: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select * from stop')
    UniDirectional = True
    GeneratorField.Field = 'OID_STOP'
    GeneratorField.Generator = 'STOP_OID'
    Left = 136
    Top = 24
    object qStopsOID_STOP: TIntegerField
      FieldName = 'OID_STOP'
      Origin = '"STOP"."OID_STOP"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qStopsLARGO_CORTO: TIBStringField
      FieldName = 'LARGO_CORTO'
      Origin = '"STOP"."LARGO_CORTO"'
      Required = True
      FixedChar = True
      Size = 1
    end
    object qStopsCAMBIO: TIBBCDField
      FieldName = 'CAMBIO'
      Origin = '"STOP"."CAMBIO"'
      Required = True
      Precision = 9
      Size = 2
    end
    object qStopsSTOP: TIBBCDField
      FieldName = 'STOP'
      Origin = '"STOP"."STOP"'
      Required = True
      Precision = 9
      Size = 2
    end
    object qStopsPER_CENT_GANA: TIntegerField
      FieldName = 'PER_CENT_GANA'
      Origin = '"STOP"."PER_CENT_GANA"'
      Required = True
    end
    object qStopsPER_CENT_PIERDE: TIntegerField
      FieldName = 'PER_CENT_PIERDE'
      Origin = '"STOP"."PER_CENT_PIERDE"'
      Required = True
    end
    object qStopsOR_VALOR: TIntegerField
      FieldName = 'OR_VALOR'
      Origin = '"STOP"."OR_VALOR"'
      Required = True
    end
    object qStopsPOSICION_INICIAL: TIBBCDField
      FieldName = 'POSICION_INICIAL'
      Origin = '"STOP"."POSICION_INICIAL"'
      Required = True
      Precision = 9
      Size = 2
    end
  end
  object uStops: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'update stop'
      'set'
      '  CAMBIO = :CAMBIO,'
      '  PER_CENT_GANA = :PER_CENT_GANA,'
      '  PER_CENT_PIERDE = :PER_CENT_PIERDE,'
      '  STOP = :STOP'
      'where'
      '  OID_STOP = :OID_STOP')
    Transaction = BD.IBTransactionUsuario
    Left = 224
    Top = 144
  end
  object iStops: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'insert into stop'
      
        '  (CAMBIO, LARGO_CORTO, OID_STOP, OR_VALOR, PER_CENT_GANA, PER_C' +
        'ENT_PIERDE, '
      '   POSICION_INICIAL, STOP)'
      'values'
      
        '  (:CAMBIO, :LARGO_CORTO, :OID_STOP, :OR_VALOR, :PER_CENT_GANA, ' +
        ':PER_CENT_PIERDE, '
      '   :POSICION_INICIAL, :STOP)')
    Transaction = BD.IBTransactionUsuario
    Left = 224
    Top = 80
  end
  object dStops: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'delete from stop'
      'where oid_stop = :OID_STOP')
    Transaction = BD.IBTransactionUsuario
    Left = 224
    Top = 16
  end
  object Stops: TkbmMemTable
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
    BeforePost = StopsBeforePost
    OnCalcFields = StopsCalcFields
    Left = 48
    Top = 24
    object StopsOID_STOP: TIntegerField
      FieldName = 'OID_STOP'
      Origin = '"STOP"."OID_STOP"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object StopsLARGO_CORTO: TIBStringField
      FieldName = 'LARGO_CORTO'
      Origin = '"STOP"."LARGO_CORTO"'
      Required = True
      FixedChar = True
      Size = 1
    end
    object StopsCAMBIO: TIBBCDField
      FieldName = 'CAMBIO'
      Origin = '"STOP"."CAMBIO"'
      Required = True
      Precision = 9
      Size = 2
    end
    object StopsSTOP: TIBBCDField
      FieldName = 'STOP'
      Origin = '"STOP"."STOP"'
      Required = True
      Precision = 9
      Size = 2
    end
    object StopsPER_CENT_GANA: TIntegerField
      FieldName = 'PER_CENT_GANA'
      Origin = '"STOP"."PER_CENT_GANA"'
      Required = True
    end
    object StopsPER_CENT_PIERDE: TIntegerField
      FieldName = 'PER_CENT_PIERDE'
      Origin = '"STOP"."PER_CENT_PIERDE"'
      Required = True
    end
    object StopsOR_VALOR: TIntegerField
      FieldName = 'OR_VALOR'
      Origin = '"STOP"."OR_VALOR"'
      Required = True
    end
    object StopsPOSICION_INICIAL: TIBBCDField
      FieldName = 'POSICION_INICIAL'
      Origin = '"STOP"."POSICION_INICIAL"'
      Required = True
      Precision = 9
      Size = 2
    end
    object StopsVALOR: TStringField
      FieldKind = fkCalculated
      FieldName = 'VALOR'
      Size = 60
      Calculated = True
    end
    object StopsGANANCIA: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'GANANCIA'
      Calculated = True
    end
  end
end
