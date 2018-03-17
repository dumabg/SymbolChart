inherited BrokerEstudio: TBrokerEstudio
  OnCreate = DataModuleCreate
  Height = 360
  Width = 495
  inherited qMaxBrokerID: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
  end
  inherited qBrokerComision: TIBQuery [4]
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
  end
  object PosicionesAbiertas: TkbmMemTable [5]
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
    Left = 352
    Top = 192
    object PosicionesAbiertasBROKER_ID: TIntegerField
      DisplayWidth = 10
      FieldName = 'BROKER_ID'
    end
    object PosicionesAbiertasOID_VALOR: TIntegerField
      DisplayWidth = 10
      FieldName = 'OID_VALOR'
    end
    object PosicionesAbiertasES_LARGO: TBooleanField
      DisplayWidth = 5
      FieldName = 'ES_LARGO'
    end
    object PosicionesAbiertasCAMBIO: TCurrencyField
      DisplayWidth = 10
      FieldName = 'CAMBIO'
    end
    object PosicionesAbiertasSTOP: TCurrencyField
      DisplayWidth = 10
      FieldName = 'STOP'
    end
    object PosicionesAbiertasNUM_ACCIONES: TIntegerField
      DisplayWidth = 10
      FieldName = 'NUM_ACCIONES'
    end
  end
  object PosicionesPendientes: TkbmMemTable [6]
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
    Left = 352
    Top = 264
    object PosicionesPendientesBROKER_ID: TIntegerField
      DisplayWidth = 10
      FieldName = 'BROKER_ID'
    end
    object PosicionesPendientesOID_VALOR: TIntegerField
      DisplayWidth = 10
      FieldName = 'OID_VALOR'
    end
    object PosicionesPendientesES_LARGO: TBooleanField
      DisplayWidth = 5
      FieldName = 'ES_LARGO'
    end
    object PosicionesPendientesCAMBIO: TCurrencyField
      DisplayWidth = 10
      FieldName = 'CAMBIO'
    end
    object PosicionesPendientesSTOP: TCurrencyField
      DisplayWidth = 10
      FieldName = 'STOP'
    end
    object PosicionesPendientesNUM_ACCIONES: TIntegerField
      DisplayWidth = 10
      FieldName = 'NUM_ACCIONES'
    end
  end
  inherited qCotizacion: TIBQuery [7]
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select first 2 c.CIERRE, c.MAXIMO, c.MINIMO  '
      'from COTIZACION c, SESION s'
      'where'
      'c.OR_VALOR = :OID_VALOR and'
      'c.OR_SESION = s.OID_SESION and'
      's.FECHA = :FECHA'
      'order by s.FECHA desc')
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_VALOR'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'FECHA'
        ParamType = ptUnknown
      end>
    object qCotizacionMAXIMO: TIBBCDField
      FieldName = 'MAXIMO'
      Origin = '"COTIZACION"."MAXIMO"'
      Precision = 9
      Size = 4
    end
    object qCotizacionMINIMO: TIBBCDField
      FieldName = 'MINIMO'
      Origin = '"COTIZACION"."MINIMO"'
      Precision = 9
      Size = 4
    end
  end
end
