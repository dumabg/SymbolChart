inherited Cartera: TCartera
  OnDestroy = DataModuleDestroy
  Height = 521
  Width = 602
  inherited CuentaMovimientos: TkbmMemTable
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
        Name = 'TIPO'
        Attributes = [faRequired, faFixed]
        DataType = ftString
        Size = 1
      end
      item
        Name = 'OR_VALOR'
        DataType = ftSmallint
      end
      item
        Name = 'NUM_ACCIONES'
        DataType = ftSmallint
      end
      item
        Name = 'CAMBIO'
        DataType = ftBCD
        Precision = 9
        Size = 4
      end
      item
        Name = 'COMISION'
        DataType = ftBCD
        Precision = 9
        Size = 2
      end
      item
        Name = 'POSICION'
        Attributes = [faFixed]
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
        Precision = 18
        Size = 2
      end
      item
        Name = 'BROKER_ID'
        DataType = ftInteger
      end
      item
        Name = 'OR_MONEDA'
        Attributes = [faHiddenCol, faReadonly]
        DataType = ftSmallint
      end
      item
        Name = 'MONEDA_VALOR'
        DataType = ftBCD
        Precision = 9
        Size = 4
      end
      item
        Name = 'OID_MONEDA'
        Attributes = [faRequired]
        DataType = ftSmallint
      end
      item
        Name = 'MONEDA'
        Attributes = [faRequired]
        DataType = ftString
        Size = 20
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
        DataType = ftSmallint
      end
      item
        Name = 'MERCADO'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'OR_CUENTA'
        Attributes = [faHiddenCol, faReadonly]
        DataType = ftSmallint
      end>
    Top = 200
  end
  inherited CurvaCapital: TkbmMemTable
    Top = 272
  end
  inherited PosicionesAbiertas: TkbmMemTable
    Top = 344
  end
  inherited PosicionesCerradas: TkbmMemTable
    Top = 416
  end
  inherited qCambioStopDiario: TIBQuery
    Left = 232
    Top = 432
  end
  inherited qCambioStopSemanal: TIBQuery
    Left = 376
    Top = 432
  end
  inherited qMaxNumMov: TIBQuery
    Left = 512
    Top = 425
  end
  inherited qCuentaMovimientos: TIBQuery
    Left = 416
    Top = 296
  end
  inherited iCrearCuenta: TIBSQL
    Left = 408
    Top = 121
  end
  inherited qCuenta: TIBQuery
    Left = 312
    Top = 120
  end
  inherited iCuentaMovimientos: TIBSQL
    Top = 200
  end
  inherited uCuentaMovimientos: TIBSQL
    Top = 200
  end
  inherited dCuentaMovimientos: TIBSQL
    Top = 200
  end
  object qCartera: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    OnCalcFields = qCarteraCalcFields
    SQL.Strings = (
      'select c.*,cc.OR_MONEDA, b.NOMBRE as BROKER from '
      'cartera c, cuenta cc,  broker b'
      'where'
      'c.OR_CUENTA = cc.OID_CUENTA and'
      'c.OR_BROKER = b.OID_BROKER'
      '')
    UpdateObject = uCartera
    Left = 312
    Top = 48
    object qCarteraOID_CARTERA: TSmallintField
      FieldName = 'OID_CARTERA'
      Origin = '"CARTERA"."OID_CARTERA"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qCarteraCAPITAL: TIntegerField
      FieldName = 'CAPITAL'
      Origin = '"CARTERA"."CAPITAL"'
      Required = True
    end
    object qCarteraPAQUETES: TIntegerField
      FieldName = 'PAQUETES'
      Origin = '"CARTERA"."PAQUETES"'
      Required = True
    end
    object qCarteraUSA100: TIBStringField
      FieldName = 'USA100'
      Origin = '"CARTERA"."USA100"'
      Required = True
      FixedChar = True
      Size = 1
    end
    object qCarteraNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = '"CARTERA"."NOMBRE"'
      Required = True
      Size = 30
    end
    object qCarteraOR_CUENTA: TSmallintField
      FieldName = 'OR_CUENTA'
      Origin = '"CARTERA"."OR_CUENTA"'
      Required = True
    end
    object qCarteraOR_BROKER: TSmallintField
      FieldName = 'OR_BROKER'
      Origin = '"CARTERA"."OR_BROKER"'
      Required = True
    end
    object qCarteraBROKER: TIBStringField
      FieldName = 'BROKER'
      Origin = '"BROKER"."NOMBRE"'
      Required = True
      Size = 25
    end
    object qCarteraOR_MONEDA: TSmallintField
      FieldName = 'OR_MONEDA'
      Origin = '"CUENTA"."OR_MONEDA"'
      Required = True
    end
    object qCarteraMONEDA: TStringField
      FieldKind = fkCalculated
      FieldName = 'MONEDA'
      Calculated = True
    end
  end
  object uCartera: TIBUpdateSQL
    RefreshSQL.Strings = (
      'Select '
      '  OID_CARTERA,'
      '  CAPITAL,'
      '  PAQUETES,'
      '  USA100,'
      '  NOMBRE,'
      '  OR_CUENTA,'
      '  OR_BROKER,'
      '  OID_MONEDA,'
      '  MONEDA'
      'from cartera '
      'where'
      '  OID_CARTERA = :OID_CARTERA')
    ModifySQL.Strings = (
      'update cartera'
      'set'
      '  CAPITAL = :CAPITAL,'
      '  NOMBRE = :NOMBRE,'
      '  OID_CARTERA = :OID_CARTERA,'
      '  OR_BROKER = :OR_BROKER,'
      '  OR_CUENTA = :OR_CUENTA,'
      '  PAQUETES = :PAQUETES,'
      '  USA100 = :USA100'
      'where'
      '  OID_CARTERA = :OLD_OID_CARTERA')
    InsertSQL.Strings = (
      'insert into cartera'
      
        '  (CAPITAL, NOMBRE, OID_CARTERA, OR_BROKER, OR_CUENTA, PAQUETES,' +
        ' USA100)'
      'values'
      
        '  (:CAPITAL, :NOMBRE, :OID_CARTERA, :OR_BROKER, :OR_CUENTA, :PAQ' +
        'UETES, '
      '   :USA100)')
    DeleteSQL.Strings = (
      'delete from cartera'
      'where'
      '  OID_CARTERA = :OID_CARTERA')
    Left = 400
    Top = 48
  end
  object dCuenta: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'delete from CUENTA'
      'where OID_CUENTA=:OID_CUENTA')
    Transaction = BD.IBTransactionUsuario
    Left = 504
    Top = 120
  end
end
