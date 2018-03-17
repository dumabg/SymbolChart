object BaseBuscar: TBaseBuscar
  OldCreateOrder = False
  Height = 305
  Width = 384
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
    IndexName = 'ValoresIndex'
    IndexDefs = <
      item
        Name = 'ValoresIndex'
        Fields = 'NOMBRE;SIMBOLO'
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
    Left = 72
    Top = 48
    object ValoresOID_VALOR: TSmallintField
      FieldName = 'OID_VALOR'
      Origin = '"VALOR"."OID_VALOR"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Visible = False
    end
    object ValoresOID_MERCADO: TSmallintField
      FieldName = 'OID_MERCADO'
      Origin = '"VALOR"."OR_MERCADO"'
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
    object ValoresDECIMALES: TSmallintField
      FieldName = 'DECIMALES'
      Origin = '"MERCADO"."DECIMALES"'
      Visible = False
    end
    object ValoresMERCADO: TIBStringField
      DisplayLabel = 'Mercado'
      FieldName = 'MERCADO'
      Origin = '"MERCADO"."PAIS"'
      Required = True
    end
  end
end
