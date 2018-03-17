inherited MapaValores: TMapaValores
  OnCreate = DataModuleCreate
  Height = 294
  Width = 367
  object qValores: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select  va.*, ce.DINERO, ce.PAPEL, ce.ZONA'
      
        'from VALOR_ACTIVO va, COTIZACION c, COTIZACION_ESTADO ce, SESION' +
        ' s'
      'where'
      'c.OR_VALOR = va.OR_VALOR and'
      'c.OR_SESION = s.OID_SESION and'
      'c.OID_COTIZACION = ce.OR_COTIZACION and'
      's.OID_SESION = :OID_SESION'
      '')
    Left = 216
    Top = 96
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_SESION'
        ParamType = ptUnknown
      end>
    object qValoresOR_VALOR: TSmallintField
      FieldName = 'OR_VALOR'
      Origin = '"VALOR_ACTIVO"."OR_VALOR"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qValoresDINERO: TIBBCDField
      FieldName = 'DINERO'
      Origin = '"COTIZACION_ESTADO"."DINERO"'
      Precision = 9
      Size = 2
    end
    object qValoresPAPEL: TIBBCDField
      FieldName = 'PAPEL'
      Origin = '"COTIZACION_ESTADO"."PAPEL"'
      Precision = 9
      Size = 2
    end
    object qValoresZONA: TIBStringField
      FieldName = 'ZONA'
      Origin = '"COTIZACION_ESTADO"."ZONA"'
      FixedChar = True
      Size = 1
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
    OnFilterRecord = ValoresFilterRecord
    Left = 120
    Top = 96
    object ValoresSELECCIONADO: TBooleanField
      DisplayLabel = 'Sel.'
      FieldName = 'SELECCIONADO'
    end
    object ValoresOID_VALOR: TSmallintField
      FieldName = 'OID_VALOR'
      Origin = '"VALOR"."OID_VALOR"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Visible = False
    end
    object ValoresNOMBRE: TIBStringField
      DisplayLabel = 'Nombre'
      FieldName = 'NOMBRE'
      Origin = '"VALOR"."NOMBRE"'
      Required = True
      Size = 50
    end
    object ValoresSIMBOLO: TIBStringField
      DisplayLabel = 'S'#237'mbolo'
      FieldName = 'SIMBOLO'
      Origin = '"VALOR"."SIMBOLO"'
    end
    object ValoresDINERO: TIBBCDField
      DisplayLabel = 'Dinero'
      FieldName = 'DINERO'
      Origin = '"COTIZACION_ESTADO"."DINERO"'
      Precision = 9
      Size = 2
    end
    object ValoresPAPEL: TIBBCDField
      DisplayLabel = 'Papel'
      FieldName = 'PAPEL'
      Origin = '"COTIZACION_ESTADO"."PAPEL"'
      Precision = 9
      Size = 2
    end
    object ValoresZONA: TIBStringField
      DisplayLabel = 'Zona'
      FieldName = 'ZONA'
      Origin = '"ZONA"."NOMBRE"'
      Required = True
      Size = 3
    end
    object ValoresPAIS: TIBStringField
      DisplayLabel = 'Pa'#237's'
      FieldName = 'PAIS'
      Origin = '"MERCADO"."PAIS"'
      Required = True
    end
  end
end
