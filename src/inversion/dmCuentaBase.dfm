inherited CuentaBase: TCuentaBase
  OnCreate = DataModuleCreate
  Height = 393
  Width = 479
  inherited CuentaMovimientos: TkbmMemTable
    IndexName = 'CuentaMovimientosIndexNumMov'
    IndexDefs = <
      item
        Name = 'CuentaMovimientosIndexNumMov'
        DescFields = 'NUM_MOVIMIENTO'
        Fields = 'NUM_MOVIMIENTO'
        Options = [ixDescending]
      end>
    Left = 104
  end
  object CurvaCapital: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <
      item
        Name = 'NUM_MOVIMIENTO'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'FECHA_HORA'
        Attributes = [faRequired]
        DataType = ftDateTime
      end
      item
        Name = 'GANANCIA'
        DataType = ftBCD
        Precision = 18
        Size = 2
      end
      item
        Name = 'TOTAL'
        DataType = ftCurrency
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
    AfterScroll = CurvaCapitalAfterScroll
    Left = 104
    Top = 128
    object CurvaCapitalNUM_MOVIMIENTO: TIntegerField
      FieldName = 'NUM_MOVIMIENTO'
      Required = True
    end
    object CurvaCapitalOR_VALOR: TIntegerField
      FieldName = 'OR_VALOR'
    end
    object CurvaCapitalFECHA_HORA: TDateTimeField
      DisplayLabel = 'Fecha/Hora'
      FieldName = 'FECHA_HORA'
      Required = True
      DisplayFormat = 'dd/mm/yy hh:mm:ss'
    end
    object CurvaCapitalGANANCIA: TBCDField
      DisplayLabel = 'Ganancia'
      FieldName = 'GANANCIA'
      DisplayFormat = '#0.00;-#0.00;0'
      Precision = 18
      Size = 2
    end
    object CurvaCapitalTOTAL: TCurrencyField
      DisplayLabel = 'Total'
      FieldName = 'TOTAL'
      DisplayFormat = '#0.00;-#0.00;0'
    end
  end
  object PosicionesAbiertas: TkbmMemTable
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
    Top = 200
    object PosicionesAbiertasNUM_MOVIMIENTO: TIntegerField
      FieldName = 'NUM_MOVIMIENTO'
      Required = True
      Visible = False
    end
    object PosicionesAbiertasFECHA_HORA: TDateTimeField
      DisplayLabel = 'Fecha/Hora compra'
      FieldName = 'FECHA_HORA'
      Required = True
      DisplayFormat = 'dd/mm/yy hh:mm:ss'
    end
    object PosicionesAbiertasOR_VALOR: TSmallintField
      FieldName = 'OR_VALOR'
      Visible = False
    end
    object PosicionesAbiertasSIMBOLO: TStringField
      DisplayLabel = 'S'#237'mbolo'
      FieldName = 'SIMBOLO'
    end
    object PosicionesAbiertasNOMBRE: TStringField
      DisplayLabel = 'Nombre'
      FieldName = 'NOMBRE'
      Size = 50
    end
    object PosicionesAbiertasMERCADO: TStringField
      DisplayLabel = 'Mercado'
      FieldName = 'MERCADO'
    end
    object PosicionesAbiertasOID_MERCADO: TSmallintField
      FieldName = 'OID_MERCADO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object PosicionesAbiertasNUM_ACCIONES: TIntegerField
      DisplayLabel = 'N'#250'm. acciones'
      FieldName = 'NUM_ACCIONES'
    end
    object PosicionesAbiertasCAMBIO: TBCDField
      DisplayLabel = 'Cambio'
      FieldName = 'CAMBIO'
      DisplayFormat = '#0.00#'
      Precision = 9
    end
    object PosicionesAbiertasPOSICION: TStringField
      DisplayLabel = 'Posici'#243'n'
      FieldName = 'POSICION'
      FixedChar = True
      Size = 1
    end
    object PosicionesAbiertasCAMBIO_ACTUAL: TCurrencyField
      DisplayLabel = 'Cambio actual'
      FieldName = 'CAMBIO_ACTUAL'
    end
    object PosicionesAbiertasSTOP_DIARIO: TCurrencyField
      DisplayLabel = 'Stop Diario'
      FieldName = 'STOP_DIARIO'
    end
    object PosicionesAbiertasSTOP_SEMANAL: TCurrencyField
      DisplayLabel = 'Stop Semanal'
      FieldName = 'STOP_SEMANAL'
    end
    object PosicionesAbiertasGANANCIA_PER_CENT_DIARIO: TCurrencyField
      DisplayLabel = '% ganancia Diario'
      FieldName = 'GANANCIA_PER_CENT_DIARIO'
    end
    object PosicionesAbiertasGANANCIA_TOTAL_DIARIO: TCurrencyField
      DisplayLabel = 'Ganancia Diario'
      FieldName = 'GANANCIA_TOTAL_DIARIO'
    end
    object PosicionesAbiertasGANANCIA_PER_CENT_SEMANAL: TCurrencyField
      DisplayLabel = '% ganancia Semanal'
      FieldName = 'GANANCIA_PER_CENT_SEMANAL'
    end
    object PosicionesAbiertasGANANCIA_TOTAL_SEMANAL: TCurrencyField
      DisplayLabel = 'Ganancia Semanal'
      FieldName = 'GANANCIA_TOTAL_SEMANAL'
    end
    object PosicionesAbiertasCOMISION: TCurrencyField
      DisplayLabel = 'Comisi'#243'n'
      FieldName = 'COMISION'
    end
    object PosicionesAbiertasBROKER_ID: TIntegerField
      DisplayLabel = 'ID Broker'
      FieldName = 'BROKER_ID'
    end
    object PosicionesAbiertasOID_MONEDA: TSmallintField
      FieldName = 'OID_MONEDA'
      Origin = '"MONEDA"."OID_MONEDA"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object PosicionesAbiertasMONEDA: TStringField
      DisplayLabel = 'Moneda'
      FieldName = 'MONEDA'
      Origin = '"MONEDA"."MONEDA"'
      Required = True
    end
  end
  object PosicionesCerradas: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <>
    Filtered = True
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
    AfterScroll = PosicionesCerradasAfterScroll
    Left = 240
    Top = 200
    object PosicionesCerradasNUM_MOVIMIENTO: TIntegerField
      FieldName = 'NUM_MOVIMIENTO'
      Required = True
      Visible = False
    end
    object PosicionesCerradasFECHA_HORA: TDateTimeField
      DisplayLabel = 'Fecha/Hora venta'
      FieldName = 'FECHA_HORA'
      Required = True
      DisplayFormat = 'dd/mm/yy hh:mm:ss'
    end
    object PosicionesCerradasOR_VALOR: TSmallintField
      FieldName = 'OR_VALOR'
      Visible = False
    end
    object PosicionesCerradasNUM_ACCIONES: TIntegerField
      DisplayLabel = 'N'#250'm. acciones'
      FieldName = 'NUM_ACCIONES'
    end
    object PosicionesCerradasCAMBIO: TBCDField
      DisplayLabel = 'Cambio venta'
      FieldName = 'CAMBIO'
      DisplayFormat = '#0.00#'
      Precision = 9
    end
    object PosicionesCerradasCOMISION: TBCDField
      DisplayLabel = 'Comisi'#243'n venta'
      FieldName = 'COMISION'
      DisplayFormat = '#0.00;-#0.00;0'
      Precision = 9
      Size = 2
    end
    object PosicionesCerradasPOSICION: TStringField
      DisplayLabel = 'Posici'#243'n'
      FieldName = 'POSICION'
      FixedChar = True
      Size = 1
    end
    object PosicionesCerradasOR_NUM_MOVIMIENTO: TIntegerField
      FieldName = 'OR_NUM_MOVIMIENTO'
      Visible = False
    end
    object PosicionesCerradasGANANCIA: TBCDField
      DisplayLabel = 'Ganancia'
      FieldName = 'GANANCIA'
      DisplayFormat = '#0.00;-#0.00;0'
      Precision = 18
      Size = 2
    end
    object PosicionesCerradasFECHA_HORA_COMPRA: TDateTimeField
      DisplayLabel = 'Fecha/Hora compra'
      FieldName = 'FECHA_HORA_COMPRA'
      Origin = '"CUENTA_MOVIMIENTOS"."FECHA_HORA"'
      DisplayFormat = 'dd/mm/yy hh:mm:ss'
    end
    object PosicionesCerradasCAMBIO_COMPRA: TBCDField
      DisplayLabel = 'Cambio compra'
      FieldName = 'CAMBIO_COMPRA'
      Origin = '"CUENTA_MOVIMIENTOS"."CAMBIO"'
      Precision = 9
    end
    object PosicionesCerradasCOMISION_COMPRA: TBCDField
      DisplayLabel = 'Comisi'#243'n compra'
      FieldName = 'COMISION_COMPRA'
      Origin = '"CUENTA_MOVIMIENTOS"."COMISION"'
      DisplayFormat = '#0.00;-#0.00;0'
      Precision = 9
      Size = 2
    end
    object PosicionesCerradasSIMBOLO: TStringField
      DisplayLabel = 'S'#237'mbolo'
      FieldName = 'SIMBOLO'
    end
    object PosicionesCerradasNOMBRE: TStringField
      DisplayLabel = 'Nombre'
      FieldName = 'NOMBRE'
      Size = 50
    end
    object PosicionesCerradasOID_MERCADO: TSmallintField
      FieldName = 'OID_MERCADO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object PosicionesCerradasMERCADO: TStringField
      DisplayLabel = 'Mercado'
      FieldName = 'MERCADO'
    end
    object PosicionesCerradasOID_MONEDA: TSmallintField
      FieldName = 'OID_MONEDA'
      Origin = '"MONEDA"."OID_MONEDA"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object PosicionesCerradasMONEDA: TStringField
      DisplayLabel = 'Moneda'
      FieldName = 'MONEDA'
      Origin = '"MONEDA"."MONEDA"'
      Required = True
    end
    object PosicionesCerradasMONEDA_VALOR: TBCDField
      DisplayLabel = 'Cambio moneda'
      FieldName = 'MONEDA_VALOR'
    end
  end
  object qCambioStopDiario: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select c.CIERRE, ce.STOP from COTIZACION c, COTIZACION_ESTADO ce'
      'where'
      'c.OID_COTIZACION = ('
      'SELECT first 1 c.OID_COTIZACION'
      'FROM SESION s, COTIZACION c'
      'where'
      'c.OR_SESION = s.OID_SESION and'
      's.FECHA <= :FECHA and'
      'c.OR_VALOR = :OID_VALOR'
      'order by s.fecha desc) and'
      'c.OID_COTIZACION = ce.OR_COTIZACION'
      '')
    Left = 112
    Top = 272
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'FECHA'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'OID_VALOR'
        ParamType = ptUnknown
      end>
    object qCambioStopDiarioCIERRE: TIBBCDField
      FieldName = 'CIERRE'
      Origin = '"COTIZACION"."CIERRE"'
      Precision = 9
      Size = 4
    end
    object qCambioStopDiarioSTOP: TIBBCDField
      FieldName = 'STOP'
      Origin = '"COTIZACION_ESTADO"."STOP"'
      Precision = 9
      Size = 4
    end
  end
  object qCambioStopSemanal: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select c.CIERRE, ce.STOP from COTIZACION c, COTIZACION_ESTADO ce'
      'where'
      'c.OID_COTIZACION = ('
      'SELECT first 1 c.OID_COTIZACION'
      'FROM SESION s, COTIZACION c'
      'where'
      'c.OR_SESION = s.OID_SESION and'
      's.FECHA <= :FECHA and'
      'c.OR_VALOR = :OID_VALOR'
      'order by s.fecha desc) and'
      'c.OID_COTIZACION = ce.OR_COTIZACION'
      '')
    Left = 240
    Top = 272
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'FECHA'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'OID_VALOR'
        ParamType = ptUnknown
      end>
    object qCambioStopSemanalSTOP: TIBBCDField
      FieldName = 'STOP'
      Origin = '"COTIZACION_ESTADO"."STOP"'
      Precision = 9
      Size = 4
    end
    object qCambioStopSemanalCIERRE: TIBBCDField
      FieldName = 'CIERRE'
      Origin = '"COTIZACION"."CIERRE"'
      Precision = 9
      Size = 4
    end
  end
end
