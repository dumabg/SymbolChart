inherited PanelInhibidores: TPanelInhibidores
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 218
  Width = 325
  object qInhibidor: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    DataSource = Data.dsCotizacion
    SQL.Strings = (
      
        'SELECT first 20 cr.INHIBIDOR, cr.TOTAL_PERCENT FROM COTIZACION c' +
        ', COTIZACION_RENTABILIDAD cr, SESION s'
      'where'
      'c.OR_VALOR = :OR_VALOR and'
      'c.OR_SESION = s.OID_SESION and'
      'c.OID_COTIZACION = cr.OR_COTIZACION and'
      's.FECHA <= :FECHA'
      'order by'
      's.FECHA desc')
    Left = 136
    Top = 48
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OR_VALOR'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'FECHA'
        ParamType = ptUnknown
      end>
    object qInhibidorTOTAL_PERCENT: TIBBCDField
      FieldName = 'TOTAL_PERCENT'
      Origin = '"COTIZACION_RENTABILIDAD"."TOTAL_PERCENT"'
      Precision = 9
      Size = 2
    end
    object qInhibidorINHIBIDOR: TIBStringField
      FieldName = 'INHIBIDOR'
      Origin = '"COTIZACION_RENTABILIDAD"."INHIBIDOR"'
      FixedChar = True
      Size = 1
    end
  end
end
