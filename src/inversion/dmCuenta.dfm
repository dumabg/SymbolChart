inherited Cuenta: TCuenta
  Height = 418
  Width = 661
  inherited CuentaMovimientos: TkbmMemTable
    FieldDefs = <
      item
        Name = 'NUM_MOVIMIENTO'
        DataType = ftInteger
      end
      item
        Name = 'FECHA_HORA'
        DataType = ftDateTime
      end
      item
        Name = 'TIPO'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'OR_VALOR'
        DataType = ftSmallint
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
        Name = 'NUM_ACCIONES'
        DataType = ftSmallint
      end
      item
        Name = 'CAMBIO'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'COMISION'
        DataType = ftBCD
        Size = 2
      end
      item
        Name = 'POSICION'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'OR_NUM_MOVIMIENTO'
        DataType = ftInteger
      end
      item
        Name = 'GANANCIA'
        DataType = ftBCD
        Size = 2
      end
      item
        Name = 'BROKER_ID'
        DataType = ftInteger
      end
      item
        Name = 'OID_MONEDA'
        DataType = ftSmallint
      end
      item
        Name = 'MONEDA'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'MONEDA_VALOR'
        DataType = ftBCD
        Size = 4
      end
      item
        Name = 'GANANCIA_MONEDA_BASE'
        DataType = ftBCD
        Size = 2
      end
      item
        Name = 'COSTE'
        DataType = ftCurrency
      end
      item
        Name = 'OR_CUENTA'
        DataType = ftSmallint
      end>
    BeforePost = CuentaMovimientosBeforePost
    BeforeDelete = CuentaMovimientosBeforeDelete
    Left = 56
    Top = 128
    inherited CuentaMovimientosNUM_MOVIMIENTO: TIntegerField
      Origin = '"CUENTA_MOVIMIENTOS"."NUM_MOVIMIENTO"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    inherited CuentaMovimientosFECHA_HORA: TDateTimeField
      Origin = '"CUENTA_MOVIMIENTOS"."FECHA_HORA"'
    end
    inherited CuentaMovimientosTIPO: TStringField
      Origin = '"CUENTA_MOVIMIENTOS"."TIPO"'
    end
    inherited CuentaMovimientosOR_VALOR: TSmallintField
      Origin = '"CUENTA_MOVIMIENTOS"."OR_VALOR"'
    end
    inherited CuentaMovimientosNOMBRE: TStringField
      Origin = '"VALOR"."NOMBRE"'
    end
    inherited CuentaMovimientosSIMBOLO: TStringField
      Origin = '"VALOR"."SIMBOLO"'
    end
    inherited CuentaMovimientosOID_MERCADO: TIntegerField
      Origin = '"MERCADO"."OID_MERCADO"'
    end
    inherited CuentaMovimientosMERCADO: TStringField
      Origin = '"MERCADO"."PAIS"'
    end
    inherited CuentaMovimientosNUM_ACCIONES: TIntegerField
      Origin = '"CUENTA_MOVIMIENTOS"."NUM_ACCIONES"'
    end
    inherited CuentaMovimientosCAMBIO: TBCDField
      Origin = '"CUENTA_MOVIMIENTOS"."CAMBIO"'
    end
    inherited CuentaMovimientosCOMISION: TBCDField
      Origin = '"CUENTA_MOVIMIENTOS"."COMISION"'
    end
    inherited CuentaMovimientosPOSICION: TStringField
      Origin = '"CUENTA_MOVIMIENTOS"."POSICION"'
    end
    inherited CuentaMovimientosOR_NUM_MOVIMIENTO: TIntegerField
      Origin = '"CUENTA_MOVIMIENTOS"."OR_NUM_MOVIMIENTO"'
    end
    inherited CuentaMovimientosGANANCIA: TBCDField
      Origin = '"CUENTA_MOVIMIENTOS"."GANANCIA"'
    end
    inherited CuentaMovimientosBROKER_ID: TIntegerField
      Origin = '"CUENTA_MOVIMIENTOS"."BROKER_ID"'
    end
    inherited CuentaMovimientosMONEDA_VALOR: TBCDField
      Origin = '"CUENTA_MOVIMIENTOS"."MONEDA_VALOR"'
    end
    inherited CuentaMovimientosGANANCIA_MONEDA_BASE: TBCDField
      Origin = '"CUENTA_MOVIMIENTOS"."GANANCIA_MONEDA_BASE"'
    end
    inherited CuentaMovimientosCOSTE: TCurrencyField
      DisplayLabel = 'Coste'
    end
  end
  inherited CurvaCapital: TkbmMemTable
    Left = 56
    Top = 200
  end
  inherited PosicionesAbiertas: TkbmMemTable
    Left = 56
    Top = 272
    inherited PosicionesAbiertasCAMBIO: TBCDField
      DisplayFormat = '#0.00#;-#0.00#;0'
    end
    inherited PosicionesAbiertasCAMBIO_ACTUAL: TCurrencyField
      DisplayFormat = '#0.00#;-#0.00#;0'
    end
    inherited PosicionesAbiertasSTOP_DIARIO: TCurrencyField
      DisplayFormat = '#0.00#;-#0.00#;0'
    end
    inherited PosicionesAbiertasSTOP_SEMANAL: TCurrencyField
      DisplayFormat = '#0.00#;-#0.00#;0'
    end
    inherited PosicionesAbiertasGANANCIA_PER_CENT_DIARIO: TCurrencyField
      DisplayFormat = '#0.00;-#0.00;0'
    end
    inherited PosicionesAbiertasGANANCIA_TOTAL_DIARIO: TCurrencyField
      DisplayFormat = '#0.00;-#0.00;0'
    end
    inherited PosicionesAbiertasGANANCIA_PER_CENT_SEMANAL: TCurrencyField
      DisplayFormat = '#0.00;-#0.00;0'
    end
    inherited PosicionesAbiertasGANANCIA_TOTAL_SEMANAL: TCurrencyField
      DisplayFormat = '#0.00;-#0.00;0'
    end
  end
  inherited PosicionesCerradas: TkbmMemTable
    Left = 56
    Top = 344
    inherited PosicionesCerradasCAMBIO: TBCDField
      DisplayFormat = '#0.00#;-#0.00#;0'
    end
    inherited PosicionesCerradasCAMBIO_COMPRA: TBCDField
      DisplayFormat = '#0.00#;-#0.00#;0'
    end
    inherited PosicionesCerradasMONEDA_VALOR: TBCDField
      DisplayFormat = '#0.00#;-#0.00#;0'
    end
  end
  inherited qCambioStopDiario: TIBQuery
    Left = 176
    Top = 336
  end
  inherited qCambioStopSemanal: TIBQuery
    Left = 304
    Top = 336
  end
  object qMaxNumMov: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select max(NUM_MOVIMIENTO) from CUENTA_MOVIMIENTOS'
      'where OR_CUENTA = :OID_CUENTA')
    UniDirectional = True
    Left = 304
    Top = 208
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_CUENTA'
        ParamType = ptUnknown
      end>
    object qMaxNumMovMAX: TIntegerField
      FieldName = 'MAX'
      ProviderFlags = []
    end
  end
  object qCuentaMovimientos: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    OnCalcFields = qCuentaMovimientosCalcFields
    SQL.Strings = (
      'SELECT'
      '  CM.*'
      ' FROM'
      '  CUENTA_MOVIMIENTOS CM'
      '  where'
      '  cm.OR_CUENTA = :OR_CUENTA'
      'order by'
      '  cm.NUM_MOVIMIENTO desc')
    UniDirectional = True
    Left = 528
    Top = 128
    ParamData = <
      item
        DataType = ftSmallint
        Name = 'OR_CUENTA'
        ParamType = ptUnknown
        Size = 2
      end>
    object qCuentaMovimientosOR_CUENTA: TSmallintField
      FieldName = 'OR_CUENTA'
      Origin = '"CUENTA_MOVIMIENTOS"."OR_CUENTA"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qCuentaMovimientosNUM_MOVIMIENTO: TIntegerField
      FieldName = 'NUM_MOVIMIENTO'
      Origin = '"CUENTA_MOVIMIENTOS"."NUM_MOVIMIENTO"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qCuentaMovimientosFECHA_HORA: TDateTimeField
      FieldName = 'FECHA_HORA'
      Origin = '"CUENTA_MOVIMIENTOS"."FECHA_HORA"'
      Required = True
    end
    object qCuentaMovimientosTIPO: TIBStringField
      FieldName = 'TIPO'
      Origin = '"CUENTA_MOVIMIENTOS"."TIPO"'
      Required = True
      FixedChar = True
      Size = 1
    end
    object qCuentaMovimientosOR_VALOR: TSmallintField
      FieldName = 'OR_VALOR'
      Origin = '"CUENTA_MOVIMIENTOS"."OR_VALOR"'
    end
    object qCuentaMovimientosCAMBIO: TIBBCDField
      FieldName = 'CAMBIO'
      Origin = '"CUENTA_MOVIMIENTOS"."CAMBIO"'
      Precision = 9
      Size = 4
    end
    object qCuentaMovimientosCOMISION: TIBBCDField
      FieldName = 'COMISION'
      Origin = '"CUENTA_MOVIMIENTOS"."COMISION"'
      Precision = 9
      Size = 2
    end
    object qCuentaMovimientosPOSICION: TIBStringField
      FieldName = 'POSICION'
      Origin = '"CUENTA_MOVIMIENTOS"."POSICION"'
      FixedChar = True
      Size = 1
    end
    object qCuentaMovimientosOR_NUM_MOVIMIENTO: TIntegerField
      FieldName = 'OR_NUM_MOVIMIENTO'
      Origin = '"CUENTA_MOVIMIENTOS"."OR_NUM_MOVIMIENTO"'
    end
    object qCuentaMovimientosGANANCIA: TIBBCDField
      FieldName = 'GANANCIA'
      Origin = '"CUENTA_MOVIMIENTOS"."GANANCIA"'
      Precision = 18
      Size = 2
    end
    object qCuentaMovimientosBROKER_ID: TIntegerField
      FieldName = 'BROKER_ID'
      Origin = '"CUENTA_MOVIMIENTOS"."BROKER_ID"'
    end
    object qCuentaMovimientosMONEDA_VALOR: TIBBCDField
      FieldName = 'MONEDA_VALOR'
      Origin = '"CUENTA_MOVIMIENTOS"."MONEDA_VALOR"'
      Precision = 9
      Size = 4
    end
    object qCuentaMovimientosOR_MONEDA: TSmallintField
      FieldName = 'OR_MONEDA'
      Origin = '"CUENTA_MOVIMIENTOS"."OR_MONEDA"'
      Required = True
    end
    object qCuentaMovimientosGANANCIA_MONEDA_BASE: TIBBCDField
      FieldName = 'GANANCIA_MONEDA_BASE'
      Origin = '"CUENTA_MOVIMIENTOS"."GANANCIA_MONEDA_BASE"'
      Precision = 18
      Size = 2
    end
    object qCuentaMovimientosNUM_ACCIONES: TIntegerField
      FieldName = 'NUM_ACCIONES'
      Origin = '"CUENTA_MOVIMIENTOS"."NUM_ACCIONES"'
    end
    object qCuentaMovimientosOID_MONEDA: TSmallintField
      FieldKind = fkCalculated
      FieldName = 'OID_MONEDA'
      Calculated = True
    end
    object qCuentaMovimientosMONEDA: TIBStringField
      FieldKind = fkCalculated
      FieldName = 'MONEDA'
      Required = True
      Calculated = True
    end
    object qCuentaMovimientosMERCADO: TIBStringField
      FieldKind = fkCalculated
      FieldName = 'MERCADO'
      Calculated = True
    end
    object qCuentaMovimientosOID_MERCADO: TSmallintField
      FieldKind = fkCalculated
      FieldName = 'OID_MERCADO'
      Calculated = True
    end
    object qCuentaMovimientosSIMBOLO: TIBStringField
      FieldKind = fkCalculated
      FieldName = 'SIMBOLO'
      Calculated = True
    end
    object qCuentaMovimientosNOMBRE: TIBStringField
      FieldKind = fkCalculated
      FieldName = 'NOMBRE'
      Size = 50
      Calculated = True
    end
    object qCuentaMovimientosCOSTE: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'COSTE'
      Calculated = True
    end
  end
  object iCrearCuenta: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'insert into CUENTA'
      '  (OID_CUENTA, OR_MONEDA)'
      'values'
      '  (:OID_CUENTA, :OR_MONEDA)')
    Transaction = BD.IBTransactionUsuario
    Left = 528
    Top = 33
  end
  object qCuenta: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    AfterOpen = qCuentaAfterOpen
    SQL.Strings = (
      'select * from cuenta'
      'where '
      'OID_CUENTA = :OID_CUENTA')
    Left = 416
    Top = 32
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_CUENTA'
        ParamType = ptUnknown
      end>
    object qCuentaOID_CUENTA: TSmallintField
      FieldName = 'OID_CUENTA'
      Origin = '"CUENTA"."OID_CUENTA"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qCuentaOR_MONEDA: TSmallintField
      FieldName = 'OR_MONEDA'
      Origin = '"CUENTA"."OR_MONEDA"'
      Required = True
    end
  end
  object iCuentaMovimientos: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'insert into CUENTA_MOVIMIENTOS'
      
        '(OR_CUENTA, NUM_MOVIMIENTO, FECHA_HORA, TIPO, OR_VALOR, NUM_ACCI' +
        'ONES, CAMBIO,'
      
        'COMISION, POSICION, OR_NUM_MOVIMIENTO, GANANCIA, BROKER_ID,OR_MO' +
        'NEDA,'
      'MONEDA_VALOR, GANANCIA_MONEDA_BASE)'
      'values'
      
        '(:OR_CUENTA, :NUM_MOVIMIENTO, :FECHA_HORA, :TIPO, :OR_VALOR, :NU' +
        'M_ACCIONES, :CAMBIO,'
      
        ':COMISION, :POSICION, :OR_NUM_MOVIMIENTO, :GANANCIA, :BROKER_ID,' +
        ' :OR_MONEDA,'
      ':MONEDA_VALOR, :GANANCIA_MONEDA_BASE)')
    Transaction = BD.IBTransactionUsuario
    Left = 160
    Top = 128
  end
  object uCuentaMovimientos: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'update CUENTA_MOVIMIENTOS'
      '      set OR_NUM_MOVIMIENTO = :OR_NUM_MOVIMIENTO,'
      '      MONEDA_VALOR = :MONEDA_VALOR,'
      '      GANANCIA = :GANANCIA,'
      '      GANANCIA_MONEDA_BASE = :GANANCIA_MONEDA_BASE'
      '      where'
      '      OR_CUENTA = :OR_CUENTA and'
      '      NUM_MOVIMIENTO = :NUM_MOVIMIENTO')
    Transaction = BD.IBTransactionUsuario
    Left = 264
    Top = 128
  end
  object dCuentaMovimientos: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'delete from CUENTA_MOVIMIENTOS'
      '      where'
      '        NUM_MOVIMIENTO = :NUM_MOVIMIENTO and'
      '        OR_CUENTA = :OR_CUENTA')
    Transaction = BD.IBTransactionUsuario
    Left = 374
    Top = 128
  end
end
