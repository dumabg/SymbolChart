object Grupos: TGrupos
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 561
  Width = 623
  object dsGrupos: TDataSource
    Left = 136
    Top = 112
  end
  object qMercados: TIBQuery
    Database = BD.IBDatabaseComun
    Transaction = BD.IBTransactionComun
    AfterOpen = qMercadosAfterOpen
    AfterScroll = qMercadosAfterScroll
    CachedUpdates = True
    SQL.Strings = (
      'select OID_MERCADO, PAIS AS NOMBRE from MERCADO'
      'order by NOMBRE')
    UpdateObject = uMercadosDummy
    Left = 232
    Top = 424
    object qMercadosOID_MERCADO: TSmallintField
      FieldName = 'OID_MERCADO'
      Origin = '"MERCADO"."OID_MERCADO"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qMercadosNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = '"MERCADO"."PAIS"'
      Required = True
    end
  end
  object dsMercados: TDataSource
    DataSet = qMercados
    Left = 232
    Top = 368
  end
  object qValorMercados: TIBQuery
    Database = BD.IBDatabaseComun
    Transaction = BD.IBTransactionComun
    SQL.Strings = (
      'select m.PAIS as NOMBRE from valor v, mercado m'
      'where'
      'or_mercado = oid_mercado and'
      'oid_valor = :OID_VALOR'
      'union'
      'select i.NOMBRE from indice i, indice_valor iv'
      'where'
      'iv.OR_VALOR = :OID_VALOR and'
      'i.OID_INDICE = iv.OR_INDICE')
    Left = 88
    Top = 408
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_VALOR'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'OID_VALOR'
        ParamType = ptUnknown
      end>
    object qValorMercadosNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = 'INDICE.NOMBRE'
      Required = True
      Size = 30
    end
  end
  object iGrupoValor: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'insert into GRUPO_VALOR'
      '  (OR_VALOR, OR_GRUPO)'
      'values'
      '  (:OID_VALOR, :OID_GRUPO)')
    Transaction = BD.IBTransactionUsuario
    Left = 224
    Top = 128
  end
  object dValoresGrupo: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'delete from GRUPO_VALOR'
      'where'
      '  OR_GRUPO = :OID_GRUPO')
    Transaction = BD.IBTransactionUsuario
    Left = 224
    Top = 200
  end
  object Valores: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
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
    IndexName = 'ValoresIndexNombre'
    IndexDefs = <
      item
        Name = 'ValoresIndexNombre'
        Fields = 'NOMBRE'
      end
      item
        Name = 'ValoresIndexSimbolo'
        Fields = 'SIMBOLO'
      end>
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
    Left = 512
    Top = 344
    object ValoresOID_VALOR: TIntegerField
      FieldName = 'OID_VALOR'
      Required = True
    end
    object ValoresNOMBRE: TStringField
      FieldName = 'NOMBRE'
      Required = True
      Size = 50
    end
    object ValoresSIMBOLO: TStringField
      FieldName = 'SIMBOLO'
    end
    object ValoresOID_MERCADO: TSmallintField
      FieldName = 'OID_MERCADO'
      Origin = '"VALOR"."OR_MERCADO"'
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
  object uMercadosDummy: TIBUpdateSQL
    ModifySQL.Strings = (
      '//')
    InsertSQL.Strings = (
      '//')
    DeleteSQL.Strings = (
      '//')
    Left = 232
    Top = 488
  end
  object DialogExportar: TSaveDialog
    DefaultExt = 'scg'
    Filter = 'Grupos (*scg)|*.scg|Todos (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Exportar grupo'
    Left = 512
    Top = 104
  end
  object DialogImportar: TOpenDialog
    DefaultExt = 'scg'
    Filter = 'Grupos (*scg)|*.scg|Grupos antiguos(*.fpg)|*.fpg|Todos (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Importar grupo'
    Left = 512
    Top = 176
  end
  object ValoresGrupo: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
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
    IndexName = 'ValoresIndexNombre'
    IndexDefs = <
      item
        Name = 'ValoresIndexNombre'
        Fields = 'NOMBRE'
      end
      item
        Name = 'ValoresIndexSimbolo'
        Fields = 'SIMBOLO'
      end>
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
    Left = 128
    Top = 200
    object ValoresGrupoOID_VALOR: TSmallintField
      FieldName = 'OID_VALOR'
      Origin = '"GRUPO_VALOR"."OR_VALOR"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ValoresGrupoNOMBRE: TIBStringField
      FieldKind = fkInternalCalc
      FieldName = 'NOMBRE'
      Origin = 'VALOR.NOMBRE'
      Required = True
      Size = 50
    end
    object ValoresGrupoSIMBOLO: TIBStringField
      FieldKind = fkInternalCalc
      FieldName = 'SIMBOLO'
      Origin = '"VALOR"."SIMBOLO"'
    end
    object ValoresGrupoOID_MERCADO: TIntegerField
      FieldName = 'OID_MERCADO'
    end
    object ValoresGrupoMERCADO: TStringField
      FieldName = 'MERCADO'
      Size = 30
    end
    object ValoresGrupoDECIMALES: TSmallintField
      FieldName = 'DECIMALES'
    end
  end
end
