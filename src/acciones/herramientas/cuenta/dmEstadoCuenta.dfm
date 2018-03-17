inherited EstadoCuenta: TEstadoCuenta
  Height = 352
  Width = 439
  object Operacion: TkbmMemTable
    Active = True
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <
      item
        Name = 'OID_OPERACION'
        DataType = ftInteger
      end
      item
        Name = 'NOMBRE'
        DataType = ftString
        Size = 30
      end>
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
    Left = 200
    Top = 120
    object OperacionOID_OPERACION: TIntegerField
      DisplayWidth = 10
      FieldName = 'OID_OPERACION'
    end
    object OperacionNOMBRE: TStringField
      DisplayWidth = 30
      FieldName = 'NOMBRE'
      Size = 30
    end
  end
  object Transaccion: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <
      item
        Name = 'OID_TRANSACCION'
        DataType = ftInteger
      end
      item
        Name = 'OR_OPERACION'
        DataType = ftInteger
      end
      item
        Name = 'IMPORTE'
        DataType = ftInteger
      end
      item
        Name = 'FECHA_HORA'
        DataType = ftDateTime
      end>
    IndexFieldNames = 'FECHA_HORA'
    IndexName = 'TransaccionIndex'
    IndexDefs = <
      item
        Name = 'TransaccionIndex'
        DescFields = 'FECHA_HORA'
        Fields = 'FECHA_HORA'
        Options = [ixDescending]
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
    Left = 200
    Top = 184
    object TransaccionOID_TRANSACCION: TIntegerField
      DisplayWidth = 10
      FieldName = 'OID_TRANSACCION'
      Visible = False
    end
    object TransaccionOR_OPERACION: TIntegerField
      DisplayWidth = 10
      FieldName = 'OR_OPERACION'
      Visible = False
    end
    object TransaccionOPERACION: TStringField
      DisplayLabel = 'Operaci'#243'n'
      DisplayWidth = 30
      FieldKind = fkLookup
      FieldName = 'OPERACION'
      LookupDataSet = Operacion
      LookupKeyFields = 'OID_OPERACION'
      LookupResultField = 'NOMBRE'
      KeyFields = 'OR_OPERACION'
      Size = 30
      Lookup = True
    end
    object TransaccionIMPORTE: TIntegerField
      DisplayLabel = 'Importe'
      FieldName = 'IMPORTE'
    end
    object TransaccionFECHA_HORA: TDateTimeField
      DisplayLabel = 'D'#237'a y hora'
      DisplayWidth = 22
      FieldName = 'FECHA_HORA'
      DisplayFormat = 'dd/mm/yy hh:mm'
    end
  end
  object Totales: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <
      item
        Name = 'IMPORTE'
        DataType = ftInteger
      end
      item
        Name = 'POS'
        DataType = ftInteger
      end
      item
        Name = 'FECHA'
        DataType = ftString
        Size = 20
      end>
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
    Left = 104
    Top = 184
    object TotalesIMPORTE: TIntegerField
      DisplayLabel = 'Importe'
      FieldName = 'IMPORTE'
      DisplayFormat = '#0'
    end
    object TotalesPOS: TIntegerField
      DisplayWidth = 10
      FieldName = 'POS'
      OnGetText = TotalesPOSGetText
    end
    object TotalesFECHA: TStringField
      DisplayWidth = 20
      FieldName = 'FECHA'
    end
  end
end
