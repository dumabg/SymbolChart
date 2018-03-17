inherited Filtro: TFiltro
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Height = 201
  Width = 222
  object ValoresFiltrados: TkbmMemTable
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
        Name = 'SIMBOLO'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'NOMBRE'
        Attributes = [faRequired]
        DataType = ftString
        Size = 50
      end>
    IndexFieldNames = 'SIMBOLO;NOMBRE'
    IndexName = 'ValoresFiltradosIndex'
    IndexDefs = <
      item
        Name = 'ValoresFiltradosIndex'
        Fields = 'SIMBOLO;NOMBRE'
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
    Left = 96
    Top = 72
    object ValoresFiltradosOR_VALOR: TIntegerField
      DisplayWidth = 10
      FieldName = 'OR_VALOR'
      Required = True
      Visible = False
    end
    object ValoresFiltradosSIMBOLO: TStringField
      DisplayLabel = 'S'#237'mbolo'
      DisplayWidth = 8
      FieldName = 'SIMBOLO'
    end
    object ValoresFiltradosNOMBRE: TStringField
      DisplayLabel = 'Valor'
      DisplayWidth = 15
      FieldName = 'NOMBRE'
      Required = True
      Size = 50
    end
  end
end
