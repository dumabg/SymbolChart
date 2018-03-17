inherited Broker: TBroker
  OldCreateOrder = True
  Height = 356
  Width = 434
  object qBrokerPosiciones: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    AutoCalcFields = False
    OnCalcFields = qBrokerPosicionesCalcFields
    SQL.Strings = (
      'select * from BROKER_POSICIONES'
      'where'
      'ESTADO = '#39'B'#39' and'
      'OR_CUENTA = :OID_CUENTA and OR_BROKER = :OID_BROKER'
      '')
    UpdateObject = uBrokerPosiciones
    Filtered = True
    OnFilterRecord = qBrokerPosicionesFilterRecord
    Left = 104
    Top = 40
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
    object qBrokerPosicionesOID_BROKER_POSICIONES: TIntegerField
      FieldName = 'OID_BROKER_POSICIONES'
      Origin = '"BROKER_POSICIONES"."OID_BROKER_POSICIONES"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Visible = False
    end
    object qBrokerPosicionesOR_BROKER: TSmallintField
      FieldName = 'OR_BROKER'
      Origin = '"BROKER_POSICIONES"."OR_BROKER"'
      Required = True
      Visible = False
    end
    object qBrokerPosicionesOR_CUENTA: TSmallintField
      FieldName = 'OR_CUENTA'
      Origin = '"BROKER_POSICIONES"."OR_CUENTA"'
      Required = True
      Visible = False
    end
    object qBrokerPosicionesBROKER_ID: TIntegerField
      FieldName = 'BROKER_ID'
      Origin = '"BROKER_POSICIONES"."BROKER_ID"'
      Required = True
      Visible = False
    end
    object qBrokerPosicionesESTADO: TIBStringField
      DisplayLabel = 'Estado'
      FieldName = 'ESTADO'
      Origin = '"BROKER_POSICIONES"."ESTADO"'
      Required = True
      FixedChar = True
      Size = 1
    end
    object qBrokerPosicionesFECHA_HORA: TDateTimeField
      DisplayLabel = 'Fecha Hora'
      FieldName = 'FECHA_HORA'
      Origin = '"BROKER_POSICIONES"."FECHA_HORA"'
      Required = True
    end
    object qBrokerPosicionesOR_VALOR: TSmallintField
      FieldName = 'OR_VALOR'
      Origin = '"BROKER_POSICIONES"."OR_VALOR"'
      Required = True
      Visible = False
    end
    object qBrokerPosicionesTIPO_ORDEN: TIBStringField
      DisplayLabel = 'Tipo'
      FieldName = 'TIPO_ORDEN'
      Origin = '"BROKER_POSICIONES"."TIPO_ORDEN"'
      Required = True
      Size = 6
    end
    object qBrokerPosicionesOPERACION: TIBStringField
      DisplayLabel = 'Operaci'#243'n'
      FieldName = 'OPERACION'
      Origin = '"BROKER_POSICIONES"."OPERACION"'
      Required = True
      FixedChar = True
      Size = 1
    end
    object qBrokerPosicionesCAMBIO: TIBBCDField
      DisplayLabel = 'Cambio'
      FieldName = 'CAMBIO'
      Origin = '"BROKER_POSICIONES"."CAMBIO"'
      Precision = 9
      Size = 4
    end
    object qBrokerPosicionesMENSAJE: TMemoField
      DisplayLabel = 'Mensaje'
      FieldName = 'MENSAJE'
      Origin = '"BROKER_POSICIONES"."MENSAJE"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qBrokerPosicionesSIMBOLO: TIBStringField
      DisplayLabel = 'S'#237'mbolo'
      FieldKind = fkCalculated
      FieldName = 'SIMBOLO'
      Calculated = True
    end
    object qBrokerPosicionesNOMBRE: TIBStringField
      DisplayLabel = 'Nombre'
      FieldKind = fkCalculated
      FieldName = 'NOMBRE'
      Required = True
      Size = 50
      Calculated = True
    end
    object qBrokerPosicionesMERCADO: TIBStringField
      DisplayLabel = 'Mercado'
      FieldKind = fkCalculated
      FieldName = 'MERCADO'
      Required = True
      Calculated = True
    end
    object qBrokerPosicionesNUM_ACCIONES: TIntegerField
      FieldName = 'NUM_ACCIONES'
      Origin = '"BROKER_POSICIONES"."NUM_ACCIONES"'
      Required = True
    end
  end
  object uBrokerPosiciones: TIBUpdateSQL
    RefreshSQL.Strings = (
      'Select '
      '  OID_BROKER_POSICIONES,'
      '  OR_BROKER,'
      '  OR_CUENTA,'
      '  BROKER_ID,'
      '  ESTADO,'
      '  FECHA_HORA,'
      '  OR_VALOR,'
      '  TIPO_ORDEN,'
      '  OPERACION,'
      '  NUM_ACCIONES,'
      '  CAMBIO,'
      '  MENSAJE'
      'from BROKER_POSICIONES '
      'where'
      '  OID_BROKER_POSICIONES = :OID_BROKER_POSICIONES')
    ModifySQL.Strings = (
      'update BROKER_POSICIONES'
      'set'
      '  BROKER_ID = :BROKER_ID,'
      '  CAMBIO = :CAMBIO,'
      '  ESTADO = :ESTADO,'
      '  FECHA_HORA = :FECHA_HORA,'
      '  MENSAJE = :MENSAJE,'
      '  NUM_ACCIONES = :NUM_ACCIONES,'
      '  OID_BROKER_POSICIONES = :OID_BROKER_POSICIONES,'
      '  OPERACION = :OPERACION,'
      '  OR_BROKER = :OR_BROKER,'
      '  OR_CUENTA = :OR_CUENTA,'
      '  OR_VALOR = :OR_VALOR,'
      '  TIPO_ORDEN = :TIPO_ORDEN'
      'where'
      '  OID_BROKER_POSICIONES = :OLD_OID_BROKER_POSICIONES')
    InsertSQL.Strings = (
      'insert into BROKER_POSICIONES'
      
        '  (BROKER_ID, CAMBIO, ESTADO, FECHA_HORA, MENSAJE, NUM_ACCIONES,' +
        ' OID_BROKER_POSICIONES, '
      '   OPERACION, OR_BROKER, OR_CUENTA, OR_VALOR, TIPO_ORDEN)'
      'values'
      
        '  (:BROKER_ID, :CAMBIO, :ESTADO, :FECHA_HORA, :MENSAJE, :NUM_ACC' +
        'IONES, '
      
        '   :OID_BROKER_POSICIONES, :OPERACION, :OR_BROKER, :OR_CUENTA, :' +
        'OR_VALOR, '
      '   :TIPO_ORDEN)')
    DeleteSQL.Strings = (
      'delete from BROKER_POSICIONES'
      'where'
      '  OID_BROKER_POSICIONES = :OLD_OID_BROKER_POSICIONES')
    Left = 240
    Top = 40
  end
  object uBrokerPosicionEstado: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'update BROKER_POSICIONES'
      'set'
      '  ESTADO = :ESTADO'
      'where'
      '  BROKER_ID = :BROKER_ID and'
      '  OR_BROKER = :OID_BROKER and'
      '  OR_CUENTA = :OID_CUENTA')
    Transaction = BD.IBTransactionUsuario
    Left = 320
    Top = 136
  end
end
