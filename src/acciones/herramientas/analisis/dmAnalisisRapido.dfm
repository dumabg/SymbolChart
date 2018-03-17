inherited AnalisisRapido: TAnalisisRapido
  Height = 352
  Width = 487
  object qParams: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    BeforeOpen = qParamsBeforeOpen
    SQL.Strings = (
      
        'select c.OR_VALOR, cm.FLAGS from cotizacion c, cotizacion_mensaj' +
        'e cm, '
      'valor_activo va where'
      'c.OR_SESION = :OID_SESION and'
      'c.OID_COTIZACION = cm.OR_COTIZACION and'
      'c.OR_VALOR = va.OR_VALOR')
    Left = 192
    Top = 112
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_SESION'
        ParamType = ptUnknown
      end>
    object qParamsOR_VALOR: TSmallintField
      FieldName = 'OR_VALOR'
      Origin = '"COTIZACION"."OR_VALOR"'
      Required = True
    end
    object qParamsFLAGS: TIntegerField
      FieldName = 'FLAGS'
      Origin = '"COTIZACION_MENSAJE"."FLAGS"'
    end
  end
end
