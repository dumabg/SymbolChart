inherited RentabilidadValor: TRentabilidadValor
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 230
  Width = 316
  object dsCotizacionEstado: TDataSource
    DataSet = Data.CotizacionEstado
    Left = 112
    Top = 32
  end
  object CotizacionRentabilidad: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    DataSource = dsCotizacionEstado
    SQL.Strings = (
      'SELECT '
      'cr.NIVEL as NIVEL_ABIERTA,'
      'cr.TIPO as TIPO_ABIERTA,'
      'cr.FECHA as FECHA_INICIO_ABIERTA,'
      'cr.INHIBIDOR,'
      'cr2.NIVEL as NIVEL_CERRADA,'
      'cr2.TIPO as TIPO_CERRADA ,'
      'cr2.FECHA as FECHA_INICIO_CERRADA,'
      'cr.TOTAL_PERCENT as RENTABILIDAD_CERRADA'
      'FROM'
      '  COTIZACION_RENTABILIDAD CR'
      
        '  LEFT OUTER JOIN COTIZACION_RENTABILIDAD CR2 ON (CR.OR_CERRADA ' +
        '= CR2.OR_COTIZACION),'
      '  COTIZACION_ESTADO CE'
      'WHERE'
      '  (CE.OR_RENTABILIDAD = :OR_RENTABILIDAD) AND '
      '  (CE.OR_RENTABILIDAD = CR.OR_COTIZACION)')
    Left = 112
    Top = 128
    ParamData = <
      item
        DataType = ftInteger
        Name = 'OR_RENTABILIDAD'
        ParamType = ptUnknown
        Size = 4
      end>
    object CotizacionRentabilidadNIVEL_ABIERTA: TIBBCDField
      FieldName = 'NIVEL_ABIERTA'
      Origin = '"COTIZACION_RENTABILIDAD"."NIVEL"'
      Required = True
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionRentabilidadTIPO_ABIERTA: TIBStringField
      FieldName = 'TIPO_ABIERTA'
      Origin = '"COTIZACION_RENTABILIDAD"."TIPO"'
      Required = True
      OnGetText = CotizacionRentabilidadTIPO_CERRADAGetText
      FixedChar = True
      Size = 1
    end
    object CotizacionRentabilidadNIVEL_CERRADA: TIBBCDField
      FieldName = 'NIVEL_CERRADA'
      Origin = '"COTIZACION_RENTABILIDAD"."NIVEL"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionRentabilidadTIPO_CERRADA: TIBStringField
      FieldName = 'TIPO_CERRADA'
      Origin = '"COTIZACION_RENTABILIDAD"."TIPO"'
      OnGetText = CotizacionRentabilidadTIPO_CERRADAGetText
      FixedChar = True
      Size = 1
    end
    object CotizacionRentabilidadRENTABILIDAD_CERRADA: TIBBCDField
      FieldName = 'RENTABILIDAD_CERRADA'
      Origin = '"COTIZACION_RENTABILIDAD"."TOTAL_PERCENT"'
      DisplayFormat = '#0.00%;-#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object CotizacionRentabilidadFECHA_INICIO_ABIERTA: TDateField
      FieldName = 'FECHA_INICIO_ABIERTA'
      Origin = '"COTIZACION_RENTABILIDAD"."FECHA"'
      Required = True
      DisplayFormat = 'dd/mm/yy'
    end
    object CotizacionRentabilidadFECHA_INICIO_CERRADA: TDateField
      FieldName = 'FECHA_INICIO_CERRADA'
      Origin = '"COTIZACION_RENTABILIDAD"."FECHA"'
      DisplayFormat = 'dd/mm/yy'
    end
    object CotizacionRentabilidadINHIBIDOR: TIBStringField
      FieldName = 'INHIBIDOR'
      Origin = '"COTIZACION_RENTABILIDAD"."INHIBIDOR"'
      FixedChar = True
      Size = 1
    end
  end
end
