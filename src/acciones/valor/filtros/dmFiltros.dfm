object Filtros: TFiltros
  OldCreateOrder = False
  OnDestroy = DataModuleDestroy
  Height = 345
  Width = 337
  object dsFiltrosFiltroValores: TDataSource
    DataSet = FiltrosFiltroValores
    Left = 40
    Top = 24
  end
  object dsValoresFiltroValores: TDataSource
    Left = 40
    Top = 88
  end
  object dsFiltrosValorFiltros: TDataSource
    DataSet = FiltrosValorFiltros
    Left = 40
    Top = 240
  end
  object dsValoresValorFiltros: TDataSource
    DataSet = ValoresValorFiltros
    Left = 48
    Top = 176
  end
  object dsMasterDetail: TDataSource
    DataSet = ValoresValorFiltros
    Left = 184
    Top = 200
  end
  object FiltrosFiltroValores: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <
      item
        Name = 'DESCRIPCION'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'FILTRO'
        DataType = ftInteger
      end
      item
        Name = 'TIENE_DATOS'
        DataType = ftBoolean
      end>
    Filtered = True
    IndexFieldNames = 'DESCRIPCION'
    IndexName = 'FiltrosIndex'
    IndexDefs = <
      item
        Name = 'FiltrosIndex'
        Fields = 'DESCRIPCION'
      end>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    Filter = 'TIENE_DATOS=true'
    FilterOptions = []
    Version = '5.60'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 144
    Top = 24
    object FiltrosFiltroValoresDESCRIPCION: TStringField
      DisplayWidth = 40
      FieldName = 'DESCRIPCION'
      Size = 40
    end
    object FiltrosFiltroValoresFILTRO: TIntegerField
      DisplayWidth = 10
      FieldName = 'FILTRO'
    end
    object FiltrosFiltroValoresTIENE_DATOS: TBooleanField
      DisplayWidth = 5
      FieldName = 'TIENE_DATOS'
    end
  end
  object FiltrosValorFiltros: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <
      item
        Name = 'OR_VALOR'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'DESCRIPCION'
        DataType = ftString
        Size = 40
      end>
    IndexName = 'FiltrosValorFiltrosIndexOID'
    IndexDefs = <
      item
        Name = 'FiltrosValorFiltrosIndexOID'
        Fields = 'OR_VALOR'
      end>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    MasterFields = 'OID_VALOR'
    MasterSource = dsMasterDetail
    Version = '5.60'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 184
    Top = 256
    object FiltrosValorFiltrosOR_VALOR: TIntegerField
      DisplayWidth = 10
      FieldName = 'OR_VALOR'
      Required = True
      Visible = False
    end
    object FiltrosValorFiltrosDESCRIPCION: TStringField
      DisplayWidth = 40
      FieldName = 'DESCRIPCION'
      Size = 40
    end
  end
  object ValoresValorFiltros: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <
      item
        Name = 'OID_VALOR'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'NOMBRE'
        Attributes = [faRequired]
        DataType = ftString
        Size = 30
      end>
    IndexFieldNames = 'NOMBRE'
    IndexName = 'ValoresValorFiltrosIndex1'
    IndexDefs = <
      item
        Name = 'ValoresValorFiltrosIndex1'
        Fields = 'NOMBRE'
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
    Left = 184
    Top = 152
    object ValoresValorFiltrosOID_VALOR: TIntegerField
      DisplayWidth = 10
      FieldName = 'OID_VALOR'
      Required = True
      Visible = False
    end
    object ValoresValorFiltrosNOMBRE: TStringField
      DisplayLabel = 'Valor'
      DisplayWidth = 30
      FieldName = 'NOMBRE'
      Required = True
      Size = 30
    end
  end
end
