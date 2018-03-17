inherited Data: TData
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 438
  Width = 342
  object dsValores: TDataSource
    DataSet = Valores
    Left = 144
    Top = 144
  end
  object CotizacionEstado: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    OnCalcFields = CotizacionEstadoCalcFields
    DataSource = dsCotizacion
    SQL.Strings = (
      'select * from cotizacion_estado where'
      'OR_COTIZACION = :OID_COTIZACION')
    Left = 144
    Top = 320
    ParamData = <
      item
        DataType = ftInteger
        Name = 'OID_COTIZACION'
        ParamType = ptUnknown
        Size = 4
      end>
    object CotizacionEstadoOR_COTIZACION: TIntegerField
      FieldName = 'OR_COTIZACION'
      Origin = '"COTIZACION_ESTADO"."OR_COTIZACION"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object CotizacionEstadoVOLATILIDAD: TIBBCDField
      FieldName = 'VOLATILIDAD'
      Origin = '"COTIZACION_ESTADO"."VOLATILIDAD"'
      DisplayFormat = '#0.00%'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoVARIABILIDAD: TIBBCDField
      FieldName = 'VARIABILIDAD'
      Origin = '"COTIZACION_ESTADO"."VARIABILIDAD"'
      DisplayFormat = '#0.00%'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoBANDA_ALTA: TIBBCDField
      FieldName = 'BANDA_ALTA'
      Origin = '"COTIZACION_ESTADO"."BANDA_ALTA"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoBANDA_BAJA: TIBBCDField
      FieldName = 'BANDA_BAJA'
      Origin = '"COTIZACION_ESTADO"."BANDA_BAJA"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoDINERO: TIBBCDField
      FieldName = 'DINERO'
      Origin = '"COTIZACION_ESTADO"."DINERO"'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoDINERO_ALZA_DOBLE: TIBBCDField
      FieldName = 'DINERO_ALZA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."DINERO_ALZA_DOBLE"'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoDINERO_BAJA_DOBLE: TIBBCDField
      FieldName = 'DINERO_BAJA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."DINERO_BAJA_DOBLE"'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoDINERO_BAJA_SIMPLE: TIBBCDField
      FieldName = 'DINERO_BAJA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."DINERO_BAJA_SIMPLE"'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoDINERO_ALZA_SIMPLE: TIBBCDField
      FieldName = 'DINERO_ALZA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."DINERO_ALZA_SIMPLE"'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoPAPEL: TIBBCDField
      FieldName = 'PAPEL'
      Origin = '"COTIZACION_ESTADO"."PAPEL"'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoPAPEL_ALZA_DOBLE: TIBBCDField
      FieldName = 'PAPEL_ALZA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."PAPEL_ALZA_DOBLE"'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoPAPEL_ALZA_SIMPLE: TIBBCDField
      FieldName = 'PAPEL_ALZA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."PAPEL_ALZA_SIMPLE"'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoPAPEL_BAJA_DOBLE: TIBBCDField
      FieldName = 'PAPEL_BAJA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."PAPEL_BAJA_DOBLE"'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoPAPEL_BAJA_SIMPLE: TIBBCDField
      FieldName = 'PAPEL_BAJA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."PAPEL_BAJA_SIMPLE"'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoDIMENSION_FRACTAL: TIBBCDField
      FieldName = 'DIMENSION_FRACTAL'
      Origin = '"COTIZACION_ESTADO"."DIMENSION_FRACTAL"'
      Precision = 4
      Size = 3
    end
    object CotizacionEstadoPOTENCIAL_FRACTAL: TSmallintField
      FieldName = 'POTENCIAL_FRACTAL'
      Origin = '"COTIZACION_ESTADO"."POTENCIAL_FRACTAL"'
      DisplayFormat = '#0%'
    end
    object CotizacionEstadoRSI_140: TSmallintField
      FieldName = 'RSI_140'
      Origin = '"COTIZACION_ESTADO"."RSI_140"'
    end
    object CotizacionEstadoRSI_14: TSmallintField
      FieldName = 'RSI_14'
      Origin = '"COTIZACION_ESTADO"."RSI_14"'
    end
    object CotizacionEstadoDOBSON_ALTO_130: TSmallintField
      FieldName = 'DOBSON_ALTO_130'
      Origin = '"COTIZACION_ESTADO"."DOBSON_ALTO_130"'
    end
    object CotizacionEstadoDOBSON_ALTO_100: TSmallintField
      FieldName = 'DOBSON_ALTO_100'
      Origin = '"COTIZACION_ESTADO"."DOBSON_ALTO_100"'
    end
    object CotizacionEstadoDOBSON_ALTO_70: TSmallintField
      FieldName = 'DOBSON_ALTO_70'
      Origin = '"COTIZACION_ESTADO"."DOBSON_ALTO_70"'
    end
    object CotizacionEstadoDOBSON_ALTO_40: TSmallintField
      FieldName = 'DOBSON_ALTO_40'
      Origin = '"COTIZACION_ESTADO"."DOBSON_ALTO_40"'
    end
    object CotizacionEstadoDOBSON_ALTO_10: TSmallintField
      FieldName = 'DOBSON_ALTO_10'
      Origin = '"COTIZACION_ESTADO"."DOBSON_ALTO_10"'
    end
    object CotizacionEstadoDOBSON_130: TSmallintField
      FieldName = 'DOBSON_130'
      Origin = '"COTIZACION_ESTADO"."DOBSON_130"'
    end
    object CotizacionEstadoDOBSON_100: TSmallintField
      FieldName = 'DOBSON_100'
      Origin = '"COTIZACION_ESTADO"."DOBSON_100"'
    end
    object CotizacionEstadoDOBSON_70: TSmallintField
      FieldName = 'DOBSON_70'
      Origin = '"COTIZACION_ESTADO"."DOBSON_70"'
    end
    object CotizacionEstadoDOBSON_40: TSmallintField
      FieldName = 'DOBSON_40'
      Origin = '"COTIZACION_ESTADO"."DOBSON_40"'
    end
    object CotizacionEstadoDOBSON_10: TSmallintField
      FieldName = 'DOBSON_10'
      Origin = '"COTIZACION_ESTADO"."DOBSON_10"'
    end
    object CotizacionEstadoDOBSON_BAJO_130: TSmallintField
      FieldName = 'DOBSON_BAJO_130'
      Origin = '"COTIZACION_ESTADO"."DOBSON_BAJO_130"'
    end
    object CotizacionEstadoDOBSON_BAJO_100: TSmallintField
      FieldName = 'DOBSON_BAJO_100'
      Origin = '"COTIZACION_ESTADO"."DOBSON_BAJO_100"'
    end
    object CotizacionEstadoDOBSON_BAJO_70: TSmallintField
      FieldName = 'DOBSON_BAJO_70'
      Origin = '"COTIZACION_ESTADO"."DOBSON_BAJO_70"'
    end
    object CotizacionEstadoDOBSON_BAJO_40: TSmallintField
      FieldName = 'DOBSON_BAJO_40'
      Origin = '"COTIZACION_ESTADO"."DOBSON_BAJO_40"'
    end
    object CotizacionEstadoDOBSON_BAJO_10: TSmallintField
      FieldName = 'DOBSON_BAJO_10'
      Origin = '"COTIZACION_ESTADO"."DOBSON_BAJO_10"'
    end
    object CotizacionEstadoMAXIMO_SE_PREVINO: TIBBCDField
      FieldName = 'MAXIMO_SE_PREVINO'
      Origin = '"COTIZACION_ESTADO"."MAXIMO_SE_PREVINO"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoMINIMO_SE_PREVINO: TIBBCDField
      FieldName = 'MINIMO_SE_PREVINO'
      Origin = '"COTIZACION_ESTADO"."MINIMO_SE_PREVINO"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoMAXIMO_PREVISTO: TIBBCDField
      FieldName = 'MAXIMO_PREVISTO'
      Origin = '"COTIZACION_ESTADO"."MAXIMO_PREVISTO"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoMINIMO_PREVISTO: TIBBCDField
      FieldName = 'MINIMO_PREVISTO'
      Origin = '"COTIZACION_ESTADO"."MINIMO_PREVISTO"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoPIVOT_POINT: TIBBCDField
      FieldName = 'PIVOT_POINT'
      Origin = '"COTIZACION_ESTADO"."PIVOT_POINT"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoPIVOT_POINT_R1: TIBBCDField
      FieldName = 'PIVOT_POINT_R1'
      Origin = '"COTIZACION_ESTADO"."PIVOT_POINT_R1"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoPIVOT_POINT_R2: TIBBCDField
      FieldName = 'PIVOT_POINT_R2'
      Origin = '"COTIZACION_ESTADO"."PIVOT_POINT_R2"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoPIVOT_POINT_R3: TIBBCDField
      FieldName = 'PIVOT_POINT_R3'
      Origin = '"COTIZACION_ESTADO"."PIVOT_POINT_R3"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoPIVOT_POINT_S1: TIBBCDField
      FieldName = 'PIVOT_POINT_S1'
      Origin = '"COTIZACION_ESTADO"."PIVOT_POINT_S1"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoPIVOT_POINT_S2: TIBBCDField
      FieldName = 'PIVOT_POINT_S2'
      Origin = '"COTIZACION_ESTADO"."PIVOT_POINT_S2"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoPIVOT_POINT_S3: TIBBCDField
      FieldName = 'PIVOT_POINT_S3'
      Origin = '"COTIZACION_ESTADO"."PIVOT_POINT_S3"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoSTOP: TIBBCDField
      FieldName = 'STOP'
      Origin = '"COTIZACION_ESTADO"."STOP"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoMEDIA_200: TIBBCDField
      FieldName = 'MEDIA_200'
      Origin = '"COTIZACION_ESTADO"."MEDIA_200"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoCAMBIO_ALZA_SIMPLE: TIBBCDField
      FieldName = 'CAMBIO_ALZA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."CAMBIO_ALZA_SIMPLE"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoCAMBIO_ALZA_DOBLE: TIBBCDField
      FieldName = 'CAMBIO_ALZA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."CAMBIO_ALZA_DOBLE"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoCAMBIO_BAJA_SIMPLE: TIBBCDField
      FieldName = 'CAMBIO_BAJA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."CAMBIO_BAJA_SIMPLE"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoCAMBIO_BAJA_DOBLE: TIBBCDField
      FieldName = 'CAMBIO_BAJA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."CAMBIO_BAJA_DOBLE"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoPERCENT_ALZA_SIMPLE: TIBBCDField
      FieldName = 'PERCENT_ALZA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."PERCENT_ALZA_SIMPLE"'
      DisplayFormat = '#0.00%;#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoPERCENT_BAJA_SIMPLE: TIBBCDField
      FieldName = 'PERCENT_BAJA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."PERCENT_BAJA_SIMPLE"'
      DisplayFormat = '#0.00%;#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoMAXIMO_PREVISTO_APROX: TIBBCDField
      FieldName = 'MAXIMO_PREVISTO_APROX'
      Origin = '"COTIZACION_ESTADO"."MAXIMO_PREVISTO_APROX"'
      DisplayFormat = '#0.00%;#0.00%;0%'
      currency = True
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoMINIMO_PREVISTO_APROX: TIBBCDField
      FieldName = 'MINIMO_PREVISTO_APROX'
      Origin = '"COTIZACION_ESTADO"."MINIMO_PREVISTO_APROX"'
      DisplayFormat = '#0.00%;#0.00%;0%'
      currency = True
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoZONA_BAJA_SIMPLE_DESC: TStringField
      FieldKind = fkCalculated
      FieldName = 'ZONA_BAJA_SIMPLE_DESC'
      LookupKeyFields = 'OID_ZONA'
      LookupResultField = 'NOMBRE'
      KeyFields = 'ZONA_BAJA_SIMPLE'
      LookupCache = True
      ReadOnly = True
      Size = 3
      Calculated = True
    end
    object CotizacionEstadoZONA_BAJA_DOBLE_DESC: TStringField
      FieldKind = fkCalculated
      FieldName = 'ZONA_BAJA_DOBLE_DESC'
      LookupKeyFields = 'OID_ZONA'
      LookupResultField = 'NOMBRE'
      KeyFields = 'ZONA_BAJA_DOBLE'
      LookupCache = True
      ReadOnly = True
      Size = 3
      Calculated = True
    end
    object CotizacionEstadoZONA_ALZA_SIMPLE_DESC: TStringField
      FieldKind = fkCalculated
      FieldName = 'ZONA_ALZA_SIMPLE_DESC'
      LookupKeyFields = 'OID_ZONA'
      LookupResultField = 'NOMBRE'
      KeyFields = 'ZONA_ALZA_SIMPLE'
      LookupCache = True
      ReadOnly = True
      Size = 3
      Calculated = True
    end
    object CotizacionEstadoZONA_ALZA_DOBLE_DESC: TStringField
      DisplayWidth = 3
      FieldKind = fkCalculated
      FieldName = 'ZONA_ALZA_DOBLE_DESC'
      LookupKeyFields = 'OID_ZONA'
      LookupResultField = 'NOMBRE'
      KeyFields = 'ZONA_ALZA_DOBLE'
      LookupCache = True
      ReadOnly = True
      Size = 3
      Calculated = True
    end
    object CotizacionEstadoZONA_DESC: TStringField
      DisplayWidth = 3
      FieldKind = fkCalculated
      FieldName = 'ZONA_DESC'
      LookupKeyFields = 'OID_ZONA'
      LookupResultField = 'NOMBRE'
      KeyFields = 'ZONA'
      LookupCache = True
      ReadOnly = True
      Size = 3
      Calculated = True
    end
    object CotizacionEstadoPERCENT_BAJA_DOBLE: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PERCENT_BAJA_DOBLE'
      DisplayFormat = '#0.00%;#0.00%;0%'
      Calculated = True
    end
    object CotizacionEstadoPERCENT_ALZA_DOBLE: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'PERCENT_ALZA_DOBLE'
      DisplayFormat = '#0.00%;#0.00%;0%'
      Calculated = True
    end
    object CotizacionEstadoZONA_ALZA_DOBLE: TIBStringField
      FieldName = 'ZONA_ALZA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."ZONA_ALZA_DOBLE"'
      FixedChar = True
      Size = 1
    end
    object CotizacionEstadoZONA_ALZA_SIMPLE: TIBStringField
      FieldName = 'ZONA_ALZA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."ZONA_ALZA_SIMPLE"'
      FixedChar = True
      Size = 1
    end
    object CotizacionEstadoZONA_BAJA_DOBLE: TIBStringField
      FieldName = 'ZONA_BAJA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."ZONA_BAJA_DOBLE"'
      FixedChar = True
      Size = 1
    end
    object CotizacionEstadoZONA_BAJA_SIMPLE: TIBStringField
      FieldName = 'ZONA_BAJA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."ZONA_BAJA_SIMPLE"'
      FixedChar = True
      Size = 1
    end
    object CotizacionEstadoZONA: TIBStringField
      FieldName = 'ZONA'
      Origin = '"COTIZACION_ESTADO"."ZONA"'
      FixedChar = True
      Size = 1
    end
    object CotizacionEstadoNIVEL_SUBE: TIBStringField
      FieldName = 'NIVEL_SUBE'
      Origin = '"COTIZACION_ESTADO"."NIVEL_SUBE"'
      OnGetText = CotizacionEstadoNIVELGetText
      FixedChar = True
      Size = 1
    end
    object CotizacionEstadoNIVEL_ACTUAL: TIBStringField
      FieldName = 'NIVEL_ACTUAL'
      Origin = '"COTIZACION_ESTADO"."NIVEL_ACTUAL"'
      OnGetText = CotizacionEstadoNIVELGetText
      FixedChar = True
      Size = 1
    end
    object CotizacionEstadoNIVEL_BAJA: TIBStringField
      FieldName = 'NIVEL_BAJA'
      Origin = '"COTIZACION_ESTADO"."NIVEL_BAJA"'
      OnGetText = CotizacionEstadoNIVELGetText
      FixedChar = True
      Size = 1
    end
    object CotizacionEstadoAMBIENTE_INTRADIA: TIBStringField
      FieldName = 'AMBIENTE_INTRADIA'
      Origin = '"COTIZACION_ESTADO"."AMBIENTE_INTRADIA"'
      FixedChar = True
      Size = 1
    end
    object CotizacionEstadoRENTABILIDAD_ABIERTA: TIBBCDField
      FieldName = 'RENTABILIDAD_ABIERTA'
      Origin = '"COTIZACION_ESTADO"."RENTABILIDAD_ABIERTA"'
      DisplayFormat = '#0.00%;-#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoOR_RENTABILIDAD: TIntegerField
      FieldName = 'OR_RENTABILIDAD'
      Origin = '"COTIZACION_ESTADO"."OR_RENTABILIDAD"'
    end
    object CotizacionEstadoCORRELACION: TSmallintField
      FieldName = 'CORRELACION'
      Origin = '"COTIZACION_ESTADO"."CORRELACION"'
    end
    object CotizacionEstadoPOSICIONADO: TIBBCDField
      FieldName = 'POSICIONADO'
      Origin = '"COTIZACION_ESTADO"."POSICIONADO"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionEstadoRIESGO: TIBBCDField
      FieldName = 'RIESGO'
      Origin = '"COTIZACION_ESTADO"."RIESGO"'
      DisplayFormat = '#0.00 %;#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoPRESION_VERTICAL: TIBBCDField
      FieldName = 'PRESION_VERTICAL'
      Origin = '"COTIZACION_ESTADO"."PRESION_VERTICAL"'
      DisplayFormat = '#0.00%;-#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoPRESION_VERTICAL_ALZA_SIMPLE: TIBBCDField
      FieldName = 'PRESION_VERTICAL_ALZA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."PRESION_VERTICAL_ALZA_SIMPLE"'
      DisplayFormat = '#0.00%;-#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoPRESION_VERTICAL_ALZA_DOBLE: TIBBCDField
      FieldName = 'PRESION_VERTICAL_ALZA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."PRESION_VERTICAL_ALZA_DOBLE"'
      DisplayFormat = '#0.00%;-#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoPRESION_VERTICAL_BAJA_SIMPLE: TIBBCDField
      FieldName = 'PRESION_VERTICAL_BAJA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."PRESION_VERTICAL_BAJA_SIMPLE"'
      DisplayFormat = '#0.00%;-#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoPRESION_VERTICAL_BAJA_DOBLE: TIBBCDField
      FieldName = 'PRESION_VERTICAL_BAJA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."PRESION_VERTICAL_BAJA_DOBLE"'
      DisplayFormat = '#0.00%;-#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoPRESION_LATERAL_ALZA_SIMPLE: TIBBCDField
      FieldName = 'PRESION_LATERAL_ALZA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."PRESION_LATERAL_ALZA_SIMPLE"'
      DisplayFormat = '#0.00%;-#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoPRESION_LATERAL_ALZA_DOBLE: TIBBCDField
      FieldName = 'PRESION_LATERAL_ALZA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."PRESION_LATERAL_ALZA_DOBLE"'
      DisplayFormat = '#0.00%;-#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoPRESION_LATERAL_BAJA_SIMPLE: TIBBCDField
      FieldName = 'PRESION_LATERAL_BAJA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."PRESION_LATERAL_BAJA_SIMPLE"'
      DisplayFormat = '#0.00%;-#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoPRESION_LATERAL: TIBBCDField
      FieldName = 'PRESION_LATERAL'
      Origin = '"COTIZACION_ESTADO"."PRESION_LATERAL"'
      DisplayFormat = '#0.00%;-#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoPRESION_LATERAL_BAJA_DOBLE: TIBBCDField
      FieldName = 'PRESION_LATERAL_BAJA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."PRESION_LATERAL_BAJA_DOBLE"'
      DisplayFormat = '#0.00%;-#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object CotizacionEstadoRELACION_VOL_VAR: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'RELACION_VOL_VAR'
      DisplayFormat = '#0.00'
      Calculated = True
    end
  end
  object dsCotizacion: TDataSource
    DataSet = Cotizacion
    Left = 144
    Top = 256
  end
  object Cotizacion: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    AfterScroll = CotizacionAfterScroll
    DataSource = dsValores
    SQL.Strings = (
      'SELECT s.FECHA, c.* FROM SESION s, COTIZACION c'
      'where'
      'c.OR_SESION = s.OID_SESION and'
      'c.OR_VALOR = :OID_VALOR'
      'order by s.fecha desc')
    Left = 144
    Top = 200
    ParamData = <
      item
        DataType = ftSmallint
        Name = 'OID_VALOR'
        ParamType = ptUnknown
        Size = 2
      end>
    object CotizacionOID_COTIZACION: TIntegerField
      FieldName = 'OID_COTIZACION'
      Origin = '"COTIZACION"."OID_COTIZACION"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object CotizacionOR_VALOR: TSmallintField
      FieldName = 'OR_VALOR'
      Origin = '"COTIZACION"."OR_VALOR"'
    end
    object CotizacionOR_SESION: TSmallintField
      FieldName = 'OR_SESION'
      Origin = '"COTIZACION"."OR_SESION"'
    end
    object CotizacionFECHA: TDateField
      FieldName = 'FECHA'
      Origin = '"SESION"."FECHA"'
      Required = True
      DisplayFormat = 'dddd dd/mm/yy'
    end
    object CotizacionAPERTURA: TIBBCDField
      DisplayLabel = 'Apertura'
      FieldName = 'APERTURA'
      Origin = '"COTIZACION"."APERTURA"'
      Precision = 9
      Size = 4
    end
    object CotizacionCIERRE: TIBBCDField
      DisplayLabel = 'Cierre'
      FieldName = 'CIERRE'
      Origin = '"COTIZACION"."CIERRE"'
      Precision = 9
      Size = 4
    end
    object CotizacionMAXIMO: TIBBCDField
      DisplayLabel = 'M'#225'ximo'
      FieldName = 'MAXIMO'
      Origin = '"COTIZACION"."MAXIMO"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionMINIMO: TIBBCDField
      DisplayLabel = 'M'#237'nimo'
      FieldName = 'MINIMO'
      Origin = '"COTIZACION"."MINIMO"'
      currency = True
      Precision = 9
      Size = 4
    end
    object CotizacionVOLUMEN: TIntegerField
      DisplayLabel = 'Volumen'
      FieldName = 'VOLUMEN'
      Origin = '"COTIZACION"."VOLUMEN"'
    end
    object CotizacionDIAS_SEGUIDOS_NUM: TSmallintField
      FieldName = 'DIAS_SEGUIDOS_NUM'
      Origin = '"COTIZACION"."DIAS_SEGUIDOS_NUM"'
    end
    object CotizacionDIAS_SEGUIDOS_PERCENT: TIBBCDField
      FieldName = 'DIAS_SEGUIDOS_PERCENT'
      Origin = '"COTIZACION"."DIAS_SEGUIDOS_PERCENT"'
      DisplayFormat = '#0.00%;-#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object CotizacionVARIACION: TIBBCDField
      FieldName = 'VARIACION'
      Origin = '"COTIZACION"."VARIACION"'
      DisplayFormat = '#0.00%;-#0.00%;0%'
      Precision = 9
      Size = 2
    end
  end
  object Valores: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = False
    AttachMaxCount = 4
    AutoCalcFields = False
    FieldDefs = <
      item
        Name = 'OID_VALOR'
        Attributes = [faRequired]
        DataType = ftSmallint
      end
      item
        Name = 'OID_MERCADO'
        DataType = ftSmallint
      end
      item
        Name = 'NOMBRE'
        Attributes = [faRequired]
        DataType = ftString
        Size = 50
      end
      item
        Name = 'SIMBOLO'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'DECIMALES'
        DataType = ftSmallint
      end
      item
        Name = 'MERCADO'
        Attributes = [faRequired]
        DataType = ftString
        Size = 20
      end>
    IndexName = 'ValoresIndexNombreSimbolo'
    IndexDefs = <
      item
        Name = 'ValoresIndex'
        Fields = 'OID_VALOR'
      end
      item
        Name = 'ValoresIndexNombreSimbolo'
        Fields = 'NOMBRE;SIMBOLO'
      end>
    RecalcOnIndex = True
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = []
    LoadedCompletely = True
    SavedCompletely = False
    FilterOptions = []
    Version = '5.60'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    BeforeScroll = ValoresBeforeScroll
    AfterScroll = ValoresAfterScroll
    Left = 144
    Top = 80
    object ValoresOID_VALOR: TSmallintField
      FieldName = 'OID_VALOR'
      Origin = '"VALOR"."OID_VALOR"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      OnGetText = ValoresOID_VALORGetText
    end
    object ValoresOID_MERCADO: TSmallintField
      FieldName = 'OID_MERCADO'
      Origin = '"VALOR"."OR_MERCADO"'
    end
    object ValoresNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = '"VALOR"."NOMBRE"'
      Required = True
      Size = 50
    end
    object ValoresSIMBOLO: TIBStringField
      FieldName = 'SIMBOLO'
      Origin = '"VALOR"."SIMBOLO"'
    end
    object ValoresDECIMALES: TSmallintField
      FieldName = 'DECIMALES'
      Origin = '"MERCADO"."DECIMALES"'
    end
    object ValoresMERCADO: TIBStringField
      FieldName = 'MERCADO'
      Origin = '"MERCADO"."PAIS"'
      Required = True
    end
  end
end
