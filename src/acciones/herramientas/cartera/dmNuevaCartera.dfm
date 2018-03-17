object NuevaCartera: TNuevaCartera
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 224
  Width = 300
  object qBrokers: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select OID_BROKER, NOMBRE from BROKER')
    Left = 128
    Top = 40
    object qBrokersOID_BROKER: TSmallintField
      FieldName = 'OID_BROKER'
      Origin = '"BROKER"."OID_BROKER"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qBrokersNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = '"BROKER"."NOMBRE"'
      Required = True
      Size = 25
    end
  end
  object Monedas: TkbmMemTable
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
    Left = 128
    Top = 112
    object MonedasOID_MONEDA: TIntegerField
      FieldName = 'OID_MONEDA'
    end
    object MonedasMONEDA: TStringField
      FieldName = 'MONEDA'
    end
  end
end
