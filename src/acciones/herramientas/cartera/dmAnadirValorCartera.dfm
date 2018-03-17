object AnadirValorCartera: TAnadirValorCartera
  OldCreateOrder = False
  Height = 276
  Width = 369
  object Cuentas: TkbmMemTable
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
    Left = 120
    Top = 72
    object CuentasOR_CUENTA: TSmallintField
      DisplayWidth = 10
      FieldName = 'OR_CUENTA'
      Origin = '"CARTERA"."OR_CUENTA"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object CuentasNOMBRE: TIBStringField
      DisplayWidth = 30
      FieldName = 'NOMBRE'
      Origin = '"CUENTA"."NOMBRE"'
      Size = 30
    end
  end
end
