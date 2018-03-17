inherited BrokerCartera: TBrokerCartera
  inherited qBrokerPosiciones: TIBQuery
    inherited qBrokerPosicionesOPERACION: TIBStringField
      DisplayLabel = 'Posici'#243'n'
    end
  end
  object qMaxBrokerID: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select MAX(BROKER_ID) from BROKER_POSICIONES'
      'where '
      'OR_CUENTA = :OID_CUENTA and '
      'OR_BROKER = :OID_BROKER')
    UniDirectional = True
    Left = 272
    Top = 208
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_CUENTA'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'OID_BROKER'
        ParamType = ptUnknown
      end>
    object qMaxBrokerIDMAX: TIntegerField
      FieldName = 'MAX'
      ProviderFlags = []
    end
  end
  object qCotizacion: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select first 1 c.CIERRE from cotizacion c, sesion s '
      'where'
      'c.or_sesion = s.oid_sesion and'
      'c.or_valor = :OID_VALOR'
      'order by s.FECHA desc')
    Left = 104
    Top = 200
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_VALOR'
        ParamType = ptUnknown
      end>
    object qCotizacionCIERRE: TIBBCDField
      FieldName = 'CIERRE'
      Origin = '"COTIZACION"."CIERRE"'
      Precision = 9
      Size = 4
    end
  end
  object qBrokerComision: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select * from BROKER_COMISION'
      'where OR_BROKER = :OID_BROKER')
    Left = 96
    Top = 120
    ParamData = <
      item
        DataType = ftSmallint
        Name = 'OID_BROKER'
        ParamType = ptUnknown
        Size = 2
      end>
    object qBrokerComisionOR_BROKER: TSmallintField
      FieldName = 'OR_BROKER'
      Origin = '"BROKER_COMISION"."OR_BROKER"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qBrokerComisionOR_MERCADO: TSmallintField
      FieldName = 'OR_MERCADO'
      Origin = '"BROKER_COMISION"."OR_MERCADO"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qBrokerComisionENTRADA: TMemoField
      FieldName = 'ENTRADA'
      Origin = '"BROKER_COMISION"."ENTRADA"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qBrokerComisionENTRADA_MAXIMO: TMemoField
      FieldName = 'ENTRADA_MAXIMO'
      Origin = '"BROKER_COMISION"."ENTRADA_MAXIMO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qBrokerComisionENTRADA_MINIMO: TMemoField
      FieldName = 'ENTRADA_MINIMO'
      Origin = '"BROKER_COMISION"."ENTRADA_MINIMO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qBrokerComisionSALIDA: TMemoField
      FieldName = 'SALIDA'
      Origin = '"BROKER_COMISION"."SALIDA"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qBrokerComisionSALIDA_MAXIMO: TMemoField
      FieldName = 'SALIDA_MAXIMO'
      Origin = '"BROKER_COMISION"."SALIDA_MAXIMO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qBrokerComisionSALIDA_MINIMO: TMemoField
      FieldName = 'SALIDA_MINIMO'
      Origin = '"BROKER_COMISION"."SALIDA_MINIMO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
  end
end
