inherited CuentaMovimientosBase: TCuentaMovimientosBase
  OldCreateOrder = True
  Height = 338
  Width = 461
  object CuentaMovimientos: TkbmMemTable
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
    Left = 96
    Top = 56
    object CuentaMovimientosNUM_MOVIMIENTO: TIntegerField
      DisplayLabel = 'N'#250'm. movimiento'
      FieldName = 'NUM_MOVIMIENTO'
    end
    object CuentaMovimientosFECHA_HORA: TDateTimeField
      DisplayLabel = 'Fecha/Hora'
      FieldName = 'FECHA_HORA'
      DisplayFormat = 'dd/mm/yy hh:mm:ss'
    end
    object CuentaMovimientosTIPO: TStringField
      Alignment = taCenter
      DisplayLabel = 'Operaci'#243'n'
      FieldName = 'TIPO'
      FixedChar = True
      Size = 1
    end
    object CuentaMovimientosOR_VALOR: TSmallintField
      FieldName = 'OR_VALOR'
    end
    object CuentaMovimientosNOMBRE: TStringField
      DisplayLabel = 'Nombre'
      FieldName = 'NOMBRE'
      Size = 50
    end
    object CuentaMovimientosSIMBOLO: TStringField
      DisplayLabel = 'S'#237'mbolo'
      FieldName = 'SIMBOLO'
    end
    object CuentaMovimientosOID_MERCADO: TIntegerField
      FieldName = 'OID_MERCADO'
    end
    object CuentaMovimientosMERCADO: TStringField
      DisplayLabel = 'Mercado'
      FieldName = 'MERCADO'
    end
    object CuentaMovimientosNUM_ACCIONES: TIntegerField
      DisplayLabel = 'N'#250'm. acciones'
      FieldName = 'NUM_ACCIONES'
    end
    object CuentaMovimientosCAMBIO: TBCDField
      DisplayLabel = 'Cambio'
      FieldName = 'CAMBIO'
      DisplayFormat = '#0.00#'
      Precision = 9
    end
    object CuentaMovimientosCOMISION: TBCDField
      DisplayLabel = 'Comisi'#243'n'
      FieldName = 'COMISION'
      DisplayFormat = '#0.00;-#0.00;0'
      Precision = 9
      Size = 2
    end
    object CuentaMovimientosPOSICION: TStringField
      DisplayLabel = 'Posici'#243'n'
      FieldName = 'POSICION'
      FixedChar = True
      Size = 1
    end
    object CuentaMovimientosOR_NUM_MOVIMIENTO: TIntegerField
      DisplayLabel = 'Relacionado con'
      FieldName = 'OR_NUM_MOVIMIENTO'
    end
    object CuentaMovimientosGANANCIA: TBCDField
      DisplayLabel = 'Ganancia'
      FieldName = 'GANANCIA'
      DisplayFormat = '#0.00;-#0.00;0'
      currency = True
      Precision = 18
      Size = 2
    end
    object CuentaMovimientosBROKER_ID: TIntegerField
      DisplayLabel = 'ID Broker'
      FieldName = 'BROKER_ID'
    end
    object CuentaMovimientosOID_MONEDA: TSmallintField
      FieldName = 'OID_MONEDA'
      Origin = '"MONEDA"."OID_MONEDA"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object CuentaMovimientosMONEDA: TStringField
      DisplayLabel = 'Moneda'
      FieldName = 'MONEDA'
      Origin = '"MONEDA"."MONEDA"'
    end
    object CuentaMovimientosMONEDA_VALOR: TBCDField
      DisplayLabel = 'Cambio moneda'
      FieldName = 'MONEDA_VALOR'
    end
    object CuentaMovimientosGANANCIA_MONEDA_BASE: TBCDField
      FieldName = 'GANANCIA_MONEDA_BASE'
      DisplayFormat = '#0.00;-#0.00;0'
      currency = True
      Precision = 18
      Size = 2
    end
    object CuentaMovimientosCOSTE: TCurrencyField
      FieldName = 'COSTE'
    end
  end
end
