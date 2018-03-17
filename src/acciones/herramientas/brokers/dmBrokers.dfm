object Brokers: TBrokers
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 392
  Width = 518
  object qBroker: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    AfterScroll = qBrokerAfterScroll
    BeforeScroll = qBrokerBeforeScroll
    SQL.Strings = (
      'select * from BROKER')
    UpdateObject = uBroker
    Left = 64
    Top = 64
    object qBrokerOID_BROKER: TSmallintField
      FieldName = 'OID_BROKER'
      Origin = '"BROKER"."OID_BROKER"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qBrokerNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = '"BROKER"."NOMBRE"'
      Required = True
      Size = 25
    end
  end
  object qBrokerComision: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    DataSource = dsBroker
    SQL.Strings = (
      'SELECT * FROM BROKER_COMISION'
      'WHERE'
      ' BROKER_COMISION.OR_BROKER = :OID_BROKER')
    Left = 64
    Top = 216
    ParamData = <
      item
        DataType = ftSmallint
        Name = 'OID_BROKER'
        ParamType = ptUnknown
        Size = 2
      end>
    object qBrokerComisionENTRADA: TMemoField
      DisplayLabel = 'Entrada'
      FieldName = 'ENTRADA'
      Origin = '"BROKER_COMISION"."ENTRADA"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qBrokerComisionENTRADA_MAXIMO: TMemoField
      DisplayLabel = 'M'#225'ximo entrada'
      FieldName = 'ENTRADA_MAXIMO'
      Origin = '"BROKER_COMISION"."ENTRADA_MAXIMO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qBrokerComisionENTRADA_MINIMO: TMemoField
      DisplayLabel = 'M'#237'nimo entrada'
      FieldName = 'ENTRADA_MINIMO'
      Origin = '"BROKER_COMISION"."ENTRADA_MINIMO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qBrokerComisionSALIDA: TMemoField
      DisplayLabel = 'Salida'
      FieldName = 'SALIDA'
      Origin = '"BROKER_COMISION"."SALIDA"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qBrokerComisionSALIDA_MAXIMO: TMemoField
      DisplayLabel = 'M'#225'ximo salida'
      FieldName = 'SALIDA_MAXIMO'
      Origin = '"BROKER_COMISION"."SALIDA_MAXIMO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qBrokerComisionSALIDA_MINIMO: TMemoField
      DisplayLabel = 'M'#237'nimo salida'
      FieldName = 'SALIDA_MINIMO'
      Origin = '"BROKER_COMISION"."SALIDA_MINIMO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qBrokerComisionOR_BROKER: TSmallintField
      FieldName = 'OR_BROKER'
      Origin = '"BROKER_COMISION"."OR_BROKER"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qBrokerComisionOR_MERCADO: TSmallintField
      FieldName = 'OR_MERCADO'
      Origin = '"BROKER_COMISION"."OR_MERCADO"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
  end
  object dsBroker: TDataSource
    DataSet = qBroker
    Left = 64
    Top = 144
  end
  object uBroker: TIBUpdateSQL
    RefreshSQL.Strings = (
      'Select '
      '  OID_BROKER,'
      '  NOMBRE'
      'from BROKER '
      'where'
      '  OID_BROKER = :OID_BROKER')
    ModifySQL.Strings = (
      'update BROKER'
      'set'
      '  NOMBRE = :NOMBRE,'
      '  OID_BROKER = :OID_BROKER'
      'where'
      '  OID_BROKER = :OLD_OID_BROKER')
    InsertSQL.Strings = (
      'insert into BROKER'
      '  (NOMBRE, OID_BROKER, CLASSNAME)'
      'values'
      '  (:NOMBRE, :OID_BROKER, '#39'TBrokerEstudio'#39')')
    DeleteSQL.Strings = (
      'delete from BROKER'
      'where'
      '  OID_BROKER = :OLD_OID_BROKER')
    Left = 168
    Top = 64
  end
  object dTodo: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'delete from BROKER_COMISION'
      'where OR_BROKER = :OID_BROKER')
    Transaction = BD.IBTransactionUsuario
    Left = 400
    Top = 72
  end
  object iComision: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'insert into BROKER_COMISION'
      '(OR_BROKER, OR_MERCADO, ENTRADA, ENTRADA_MAXIMO, '
      'ENTRADA_MINIMO, SALIDA, SALIDA_MAXIMO, SALIDA_MINIMO)'
      'values'
      '(:OR_BROKER, :OR_MERCADO, :ENTRADA, :ENTRADA_MAXIMO, '
      ':ENTRADA_MINIMO, :SALIDA, :SALIDA_MAXIMO, :SALIDA_MINIMO)')
    Transaction = BD.IBTransactionUsuario
    Left = 296
    Top = 224
  end
  object dComision: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'delete from BROKER_COMISION'
      'where '
      'OR_BROKER = :OR_BROKER and  '
      'OR_MERCADO=:OR_MERCADO')
    Transaction = BD.IBTransactionUsuario
    Left = 296
    Top = 280
  end
  object qBrokerCartera: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select nombre from cartera'
      'where or_broker = :OID_BROKER')
    Left = 440
    Top = 272
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_BROKER'
        ParamType = ptUnknown
      end>
    object qBrokerCarteraNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = '"CARTERA"."NOMBRE"'
      Required = True
      Size = 30
    end
  end
  object qBrokerEstudios: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select distinct(e.nombre) from estudio e, broker_posiciones bp'
      'where'
      'bp.or_cuenta = e.or_cuenta and'
      'bp.or_broker = :OID_BROKER')
    Left = 440
    Top = 328
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_BROKER'
        ParamType = ptUnknown
      end>
    object qBrokerEstudiosNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = '"ESTUDIO"."NOMBRE"'
      Size = 30
    end
  end
  object mBrokerComision: TkbmMemTable
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
    Left = 184
    Top = 216
    object mBrokerComisionOID_MERCADO: TSmallintField
      FieldName = 'OID_MERCADO'
      Origin = '"MERCADO"."OID_MERCADO"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Visible = False
    end
    object mBrokerComisionMERCADO: TIBStringField
      DisplayLabel = 'Mercado'
      FieldName = 'MERCADO'
      Origin = '"MERCADO"."PAIS"'
      Required = True
    end
    object mBrokerComisionENTRADA: TMemoField
      DisplayLabel = 'Entrada'
      FieldName = 'ENTRADA'
      Origin = '"BROKER_COMISION"."ENTRADA"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object mBrokerComisionENTRADA_MAXIMO: TMemoField
      DisplayLabel = 'M'#225'ximo entrada'
      FieldName = 'ENTRADA_MAXIMO'
      Origin = '"BROKER_COMISION"."ENTRADA_MAXIMO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object mBrokerComisionENTRADA_MINIMO: TMemoField
      DisplayLabel = 'M'#237'nimo entrada'
      FieldName = 'ENTRADA_MINIMO'
      Origin = '"BROKER_COMISION"."ENTRADA_MINIMO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object mBrokerComisionSALIDA: TMemoField
      DisplayLabel = 'Salida'
      FieldName = 'SALIDA'
      Origin = '"BROKER_COMISION"."SALIDA"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object mBrokerComisionSALIDA_MAXIMO: TMemoField
      DisplayLabel = 'M'#225'ximo salida'
      FieldName = 'SALIDA_MAXIMO'
      Origin = '"BROKER_COMISION"."SALIDA_MAXIMO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object mBrokerComisionSALIDA_MINIMO: TMemoField
      DisplayLabel = 'M'#237'nimo salida'
      FieldName = 'SALIDA_MINIMO'
      Origin = '"BROKER_COMISION"."SALIDA_MINIMO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
  end
end
