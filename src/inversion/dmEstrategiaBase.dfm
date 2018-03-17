inherited EstrategiaBase: TEstrategiaBase
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Height = 367
  Width = 499
  object Posiciones: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <
      item
        Name = 'PUNTOS'
        DataType = ftInteger
      end
      item
        Name = 'OID_VALOR'
        DataType = ftInteger
      end
      item
        Name = 'NOMBRE'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'SIMBOLO'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'OID_MERCADO'
        DataType = ftInteger
      end
      item
        Name = 'MERCADO'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'POSICION'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'STOP'
        DataType = ftCurrency
      end
      item
        Name = 'LIMITE'
        DataType = ftCurrency
      end>
    IndexName = 'PuntosIndex'
    IndexDefs = <
      item
        Name = 'PuntosIndex'
        Fields = 'PUNTOS'
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
    Left = 112
    Top = 80
    object PosicionesPUNTOS: TIntegerField
      DisplayLabel = 'Puntos'
      DisplayWidth = 10
      FieldName = 'PUNTOS'
    end
    object PosicionesOID_VALOR: TIntegerField
      DisplayWidth = 10
      FieldName = 'OID_VALOR'
    end
    object PosicionesNOMBRE: TStringField
      DisplayLabel = 'Nombre'
      DisplayWidth = 50
      FieldName = 'NOMBRE'
      Size = 50
    end
    object PosicionesSIMBOLO: TStringField
      DisplayLabel = 'S'#237'mbolo'
      DisplayWidth = 20
      FieldName = 'SIMBOLO'
    end
    object PosicionesOID_MERCADO: TIntegerField
      DisplayWidth = 10
      FieldName = 'OID_MERCADO'
    end
    object PosicionesMERCADO: TStringField
      DisplayLabel = 'Mercado'
      DisplayWidth = 20
      FieldName = 'MERCADO'
    end
    object PosicionesPOSICION: TStringField
      DisplayLabel = 'Posici'#243'n'
      DisplayWidth = 1
      FieldName = 'POSICION'
      Size = 1
    end
    object PosicionesSTOP: TCurrencyField
      DisplayLabel = 'Stop'
      DisplayWidth = 10
      FieldName = 'STOP'
    end
    object PosicionesLIMITE: TCurrencyField
      DisplayLabel = 'L'#237'mite'
      DisplayWidth = 10
      FieldName = 'LIMITE'
    end
  end
  object Posicionados: TkbmMemTable
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
    Left = 112
    Top = 152
    object PosicionadosOID_VALOR: TIntegerField
      DisplayWidth = 10
      FieldName = 'OID_VALOR'
    end
    object PosicionadosSTOP: TCurrencyField
      DisplayWidth = 10
      FieldName = 'STOP'
    end
  end
end
