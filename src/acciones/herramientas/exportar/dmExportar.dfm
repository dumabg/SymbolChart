object Exportar: TExportar
  OldCreateOrder = False
  Height = 358
  Width = 462
  object qDatos: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    BeforeOpen = qDatosBeforeOpen
    SQL.Strings = (
      'SELECT'
      '  C.*,'
      '  S.*,'
      '  CE.*,'
      '  CE.PERCENT_ALZA_SIMPLE * 2 AS PERCENT_ALZA_DOBLE,'
      '  CE.PERCENT_BAJA_SIMPLE * 2 AS PERCENT_BAJA_DOBLE,'
      '  CR.NIVEL AS NIVEL_ABIERTA,'
      '  CR.TIPO AS TIPO_ABIERTA,'
      '  CR.FECHA AS FECHA_INICIO_ABIERTA,'
      '  CR2.NIVEL AS NIVEL_CERRADA,'
      '  CR2.TIPO AS TIPO_CERRADA,'
      '  CR2.FECHA AS FECHA_INICIO_CERRADA,'
      '  CR.TOTAL_PERCENT AS RENTABILIDAD_CERRADA'
      'FROM'
      '  COTIZACION C'
      
        '  LEFT OUTER JOIN COTIZACION_ESTADO CE ON (C.OID_COTIZACION = CE' +
        '.OR_COTIZACION)'
      
        '  LEFT OUTER JOIN COTIZACION_RENTABILIDAD CR ON (CE.OR_RENTABILI' +
        'DAD = CR.OR_COTIZACION)'
      
        '  LEFT OUTER JOIN COTIZACION_RENTABILIDAD CR2 ON (CR.OR_CERRADA ' +
        '= CR2.OR_COTIZACION),'
      '  VALOR_ACTIVO VA,'
      '  SESION S'
      'WHERE'
      '  (C.OR_SESION = :OID_SESION) AND'
      '  (C.OR_SESION = S.OID_SESION) AND'
      '  (C.OR_VALOR = VA.OR_VALOR)'
      ''
      '  ')
    Left = 216
    Top = 160
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_SESION'
        ParamType = ptUnknown
      end>
    object qDatosOID_COTIZACION: TIntegerField
      FieldName = 'OID_COTIZACION'
      Origin = '"COTIZACION"."OID_COTIZACION"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qDatosOR_VALOR: TSmallintField
      FieldName = 'OR_VALOR'
      Origin = '"COTIZACION"."OR_VALOR"'
      Required = True
    end
    object qDatosOR_SESION: TSmallintField
      FieldName = 'OR_SESION'
      Origin = '"COTIZACION"."OR_SESION"'
      Required = True
    end
    object qDatosDIAS_SEGUIDOS_NUM: TSmallintField
      FieldName = 'DIAS_SEGUIDOS_NUM'
      Origin = '"COTIZACION"."DIAS_SEGUIDOS_NUM"'
    end
    object qDatosVARIACION: TIBBCDField
      FieldName = 'VARIACION'
      Origin = '"COTIZACION"."VARIACION"'
      Precision = 9
      Size = 2
    end
    object qDatosMAXIMO: TIBBCDField
      FieldName = 'MAXIMO'
      Origin = '"COTIZACION"."MAXIMO"'
      Precision = 9
      Size = 4
    end
    object qDatosMINIMO: TIBBCDField
      FieldName = 'MINIMO'
      Origin = '"COTIZACION"."MINIMO"'
      Precision = 9
      Size = 4
    end
    object qDatosOID_SESION: TSmallintField
      FieldName = 'OID_SESION'
      Origin = '"SESION"."OID_SESION"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qDatosFECHA: TDateField
      FieldName = 'FECHA'
      Origin = '"SESION"."FECHA"'
      Required = True
    end
    object qDatosOR_COTIZACION: TIntegerField
      FieldName = 'OR_COTIZACION'
      Origin = '"COTIZACION_ESTADO"."OR_COTIZACION"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object qDatosVOLATILIDAD: TIBBCDField
      FieldName = 'VOLATILIDAD'
      Origin = '"COTIZACION_ESTADO"."VOLATILIDAD"'
      Precision = 9
      Size = 2
    end
    object qDatosVARIABILIDAD: TIBBCDField
      FieldName = 'VARIABILIDAD'
      Origin = '"COTIZACION_ESTADO"."VARIABILIDAD"'
      Precision = 9
      Size = 2
    end
    object qDatosBANDA_ALTA: TIBBCDField
      FieldName = 'BANDA_ALTA'
      Origin = '"COTIZACION_ESTADO"."BANDA_ALTA"'
      Precision = 9
      Size = 4
    end
    object qDatosBANDA_BAJA: TIBBCDField
      FieldName = 'BANDA_BAJA'
      Origin = '"COTIZACION_ESTADO"."BANDA_BAJA"'
      Precision = 9
      Size = 4
    end
    object qDatosDINERO: TIBBCDField
      FieldName = 'DINERO'
      Origin = '"COTIZACION_ESTADO"."DINERO"'
      Precision = 9
      Size = 2
    end
    object qDatosDINERO_ALZA_DOBLE: TIBBCDField
      FieldName = 'DINERO_ALZA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."DINERO_ALZA_DOBLE"'
      Precision = 9
      Size = 2
    end
    object qDatosDINERO_BAJA_DOBLE: TIBBCDField
      FieldName = 'DINERO_BAJA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."DINERO_BAJA_DOBLE"'
      Precision = 9
      Size = 2
    end
    object qDatosDINERO_BAJA_SIMPLE: TIBBCDField
      FieldName = 'DINERO_BAJA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."DINERO_BAJA_SIMPLE"'
      Precision = 9
      Size = 2
    end
    object qDatosDINERO_ALZA_SIMPLE: TIBBCDField
      FieldName = 'DINERO_ALZA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."DINERO_ALZA_SIMPLE"'
      Precision = 9
      Size = 2
    end
    object qDatosPAPEL: TIBBCDField
      FieldName = 'PAPEL'
      Origin = '"COTIZACION_ESTADO"."PAPEL"'
      Precision = 9
      Size = 2
    end
    object qDatosPAPEL_ALZA_DOBLE: TIBBCDField
      FieldName = 'PAPEL_ALZA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."PAPEL_ALZA_DOBLE"'
      Precision = 9
      Size = 2
    end
    object qDatosPAPEL_ALZA_SIMPLE: TIBBCDField
      FieldName = 'PAPEL_ALZA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."PAPEL_ALZA_SIMPLE"'
      Precision = 9
      Size = 2
    end
    object qDatosPAPEL_BAJA_DOBLE: TIBBCDField
      FieldName = 'PAPEL_BAJA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."PAPEL_BAJA_DOBLE"'
      Precision = 9
      Size = 2
    end
    object qDatosPAPEL_BAJA_SIMPLE: TIBBCDField
      FieldName = 'PAPEL_BAJA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."PAPEL_BAJA_SIMPLE"'
      Precision = 9
      Size = 2
    end
    object qDatosDIMENSION_FRACTAL: TIBBCDField
      FieldName = 'DIMENSION_FRACTAL'
      Origin = '"COTIZACION_ESTADO"."DIMENSION_FRACTAL"'
      Precision = 4
      Size = 3
    end
    object qDatosPOTENCIAL_FRACTAL: TSmallintField
      FieldName = 'POTENCIAL_FRACTAL'
      Origin = '"COTIZACION_ESTADO"."POTENCIAL_FRACTAL"'
    end
    object qDatosRSI_140: TSmallintField
      FieldName = 'RSI_140'
      Origin = '"COTIZACION_ESTADO"."RSI_140"'
    end
    object qDatosRSI_14: TSmallintField
      FieldName = 'RSI_14'
      Origin = '"COTIZACION_ESTADO"."RSI_14"'
    end
    object qDatosDOBSON_ALTO_130: TSmallintField
      FieldName = 'DOBSON_ALTO_130'
      Origin = '"COTIZACION_ESTADO"."DOBSON_ALTO_130"'
    end
    object qDatosDOBSON_ALTO_100: TSmallintField
      FieldName = 'DOBSON_ALTO_100'
      Origin = '"COTIZACION_ESTADO"."DOBSON_ALTO_100"'
    end
    object qDatosDOBSON_ALTO_70: TSmallintField
      FieldName = 'DOBSON_ALTO_70'
      Origin = '"COTIZACION_ESTADO"."DOBSON_ALTO_70"'
    end
    object qDatosDOBSON_ALTO_40: TSmallintField
      FieldName = 'DOBSON_ALTO_40'
      Origin = '"COTIZACION_ESTADO"."DOBSON_ALTO_40"'
    end
    object qDatosDOBSON_ALTO_10: TSmallintField
      FieldName = 'DOBSON_ALTO_10'
      Origin = '"COTIZACION_ESTADO"."DOBSON_ALTO_10"'
    end
    object qDatosDOBSON_130: TSmallintField
      FieldName = 'DOBSON_130'
      Origin = '"COTIZACION_ESTADO"."DOBSON_130"'
    end
    object qDatosDOBSON_100: TSmallintField
      FieldName = 'DOBSON_100'
      Origin = '"COTIZACION_ESTADO"."DOBSON_100"'
    end
    object qDatosDOBSON_70: TSmallintField
      FieldName = 'DOBSON_70'
      Origin = '"COTIZACION_ESTADO"."DOBSON_70"'
    end
    object qDatosDOBSON_40: TSmallintField
      FieldName = 'DOBSON_40'
      Origin = '"COTIZACION_ESTADO"."DOBSON_40"'
    end
    object qDatosDOBSON_10: TSmallintField
      FieldName = 'DOBSON_10'
      Origin = '"COTIZACION_ESTADO"."DOBSON_10"'
    end
    object qDatosDOBSON_BAJO_130: TSmallintField
      FieldName = 'DOBSON_BAJO_130'
      Origin = '"COTIZACION_ESTADO"."DOBSON_BAJO_130"'
    end
    object qDatosDOBSON_BAJO_100: TSmallintField
      FieldName = 'DOBSON_BAJO_100'
      Origin = '"COTIZACION_ESTADO"."DOBSON_BAJO_100"'
    end
    object qDatosDOBSON_BAJO_70: TSmallintField
      FieldName = 'DOBSON_BAJO_70'
      Origin = '"COTIZACION_ESTADO"."DOBSON_BAJO_70"'
    end
    object qDatosDOBSON_BAJO_40: TSmallintField
      FieldName = 'DOBSON_BAJO_40'
      Origin = '"COTIZACION_ESTADO"."DOBSON_BAJO_40"'
    end
    object qDatosDOBSON_BAJO_10: TSmallintField
      FieldName = 'DOBSON_BAJO_10'
      Origin = '"COTIZACION_ESTADO"."DOBSON_BAJO_10"'
    end
    object qDatosMAXIMO_SE_PREVINO: TIBBCDField
      FieldName = 'MAXIMO_SE_PREVINO'
      Origin = '"COTIZACION_ESTADO"."MAXIMO_SE_PREVINO"'
      Precision = 9
      Size = 4
    end
    object qDatosMINIMO_SE_PREVINO: TIBBCDField
      FieldName = 'MINIMO_SE_PREVINO'
      Origin = '"COTIZACION_ESTADO"."MINIMO_SE_PREVINO"'
      Precision = 9
      Size = 4
    end
    object qDatosMAXIMO_PREVISTO: TIBBCDField
      FieldName = 'MAXIMO_PREVISTO'
      Origin = '"COTIZACION_ESTADO"."MAXIMO_PREVISTO"'
      Precision = 9
      Size = 4
    end
    object qDatosMINIMO_PREVISTO: TIBBCDField
      FieldName = 'MINIMO_PREVISTO'
      Origin = '"COTIZACION_ESTADO"."MINIMO_PREVISTO"'
      Precision = 9
      Size = 4
    end
    object qDatosMAXIMO_PREVISTO_APROX: TIBBCDField
      FieldName = 'MAXIMO_PREVISTO_APROX'
      Origin = '"COTIZACION_ESTADO"."MAXIMO_PREVISTO_APROX"'
      Precision = 9
      Size = 2
    end
    object qDatosMINIMO_PREVISTO_APROX: TIBBCDField
      FieldName = 'MINIMO_PREVISTO_APROX'
      Origin = '"COTIZACION_ESTADO"."MINIMO_PREVISTO_APROX"'
      Precision = 9
      Size = 2
    end
    object qDatosZONA_ALZA_DOBLE: TIBStringField
      FieldName = 'ZONA_ALZA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."ZONA_ALZA_DOBLE"'
      FixedChar = True
      Size = 1
    end
    object qDatosZONA_ALZA_SIMPLE: TIBStringField
      FieldName = 'ZONA_ALZA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."ZONA_ALZA_SIMPLE"'
      FixedChar = True
      Size = 1
    end
    object qDatosZONA_BAJA_DOBLE: TIBStringField
      FieldName = 'ZONA_BAJA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."ZONA_BAJA_DOBLE"'
      FixedChar = True
      Size = 1
    end
    object qDatosZONA_BAJA_SIMPLE: TIBStringField
      FieldName = 'ZONA_BAJA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."ZONA_BAJA_SIMPLE"'
      FixedChar = True
      Size = 1
    end
    object qDatosZONA: TIBStringField
      FieldName = 'ZONA'
      Origin = '"COTIZACION_ESTADO"."ZONA"'
      FixedChar = True
      Size = 1
    end
    object qDatosPIVOT_POINT: TIBBCDField
      FieldName = 'PIVOT_POINT'
      Origin = '"COTIZACION_ESTADO"."PIVOT_POINT"'
      Precision = 9
      Size = 4
    end
    object qDatosPIVOT_POINT_R1: TIBBCDField
      FieldName = 'PIVOT_POINT_R1'
      Origin = '"COTIZACION_ESTADO"."PIVOT_POINT_R1"'
      Precision = 9
      Size = 4
    end
    object qDatosPIVOT_POINT_R2: TIBBCDField
      FieldName = 'PIVOT_POINT_R2'
      Origin = '"COTIZACION_ESTADO"."PIVOT_POINT_R2"'
      Precision = 9
      Size = 4
    end
    object qDatosPIVOT_POINT_R3: TIBBCDField
      FieldName = 'PIVOT_POINT_R3'
      Origin = '"COTIZACION_ESTADO"."PIVOT_POINT_R3"'
      Precision = 9
      Size = 4
    end
    object qDatosPIVOT_POINT_S1: TIBBCDField
      FieldName = 'PIVOT_POINT_S1'
      Origin = '"COTIZACION_ESTADO"."PIVOT_POINT_S1"'
      Precision = 9
      Size = 4
    end
    object qDatosPIVOT_POINT_S2: TIBBCDField
      FieldName = 'PIVOT_POINT_S2'
      Origin = '"COTIZACION_ESTADO"."PIVOT_POINT_S2"'
      Precision = 9
      Size = 4
    end
    object qDatosPIVOT_POINT_S3: TIBBCDField
      FieldName = 'PIVOT_POINT_S3'
      Origin = '"COTIZACION_ESTADO"."PIVOT_POINT_S3"'
      Precision = 9
      Size = 4
    end
    object qDatosSTOP: TIBBCDField
      FieldName = 'STOP'
      Origin = '"COTIZACION_ESTADO"."STOP"'
      Precision = 9
      Size = 4
    end
    object qDatosMEDIA_200: TIBBCDField
      FieldName = 'MEDIA_200'
      Origin = '"COTIZACION_ESTADO"."MEDIA_200"'
      Precision = 9
      Size = 4
    end
    object qDatosCAMBIO_ALZA_SIMPLE: TIBBCDField
      FieldName = 'CAMBIO_ALZA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."CAMBIO_ALZA_SIMPLE"'
      Precision = 9
      Size = 4
    end
    object qDatosCAMBIO_ALZA_DOBLE: TIBBCDField
      FieldName = 'CAMBIO_ALZA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."CAMBIO_ALZA_DOBLE"'
      Precision = 9
      Size = 4
    end
    object qDatosCAMBIO_BAJA_SIMPLE: TIBBCDField
      FieldName = 'CAMBIO_BAJA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."CAMBIO_BAJA_SIMPLE"'
      Precision = 9
      Size = 4
    end
    object qDatosCAMBIO_BAJA_DOBLE: TIBBCDField
      FieldName = 'CAMBIO_BAJA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."CAMBIO_BAJA_DOBLE"'
      Precision = 9
      Size = 4
    end
    object qDatosPERCENT_ALZA_SIMPLE: TIBBCDField
      FieldName = 'PERCENT_ALZA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."PERCENT_ALZA_SIMPLE"'
      Precision = 9
      Size = 2
    end
    object qDatosPERCENT_BAJA_SIMPLE: TIBBCDField
      FieldName = 'PERCENT_BAJA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."PERCENT_BAJA_SIMPLE"'
      Precision = 9
      Size = 2
    end
    object qDatosNIVEL_SUBE: TIBStringField
      FieldName = 'NIVEL_SUBE'
      Origin = '"COTIZACION_ESTADO"."NIVEL_SUBE"'
      OnGetText = qDatosNIVEL_SUBEGetText
      FixedChar = True
      Size = 1
    end
    object qDatosNIVEL_ACTUAL: TIBStringField
      FieldName = 'NIVEL_ACTUAL'
      Origin = '"COTIZACION_ESTADO"."NIVEL_ACTUAL"'
      OnGetText = qDatosNIVEL_SUBEGetText
      FixedChar = True
      Size = 1
    end
    object qDatosNIVEL_BAJA: TIBStringField
      FieldName = 'NIVEL_BAJA'
      Origin = '"COTIZACION_ESTADO"."NIVEL_BAJA"'
      OnGetText = qDatosNIVEL_SUBEGetText
      FixedChar = True
      Size = 1
    end
    object qDatosAMBIENTE_INTRADIA: TIBStringField
      FieldName = 'AMBIENTE_INTRADIA'
      Origin = '"COTIZACION_ESTADO"."AMBIENTE_INTRADIA"'
      FixedChar = True
      Size = 1
    end
    object qDatosRENTABILIDAD_ABIERTA: TIBBCDField
      FieldName = 'RENTABILIDAD_ABIERTA'
      Origin = '"COTIZACION_ESTADO"."RENTABILIDAD_ABIERTA"'
      Precision = 9
      Size = 2
    end
    object qDatosOR_RENTABILIDAD: TIntegerField
      FieldName = 'OR_RENTABILIDAD'
      Origin = '"COTIZACION_ESTADO"."OR_RENTABILIDAD"'
    end
    object qDatosPERCENT_ALZA_DOBLE: TIBBCDField
      FieldName = 'PERCENT_ALZA_DOBLE'
      ProviderFlags = []
      Precision = 18
      Size = 2
    end
    object qDatosPERCENT_BAJA_DOBLE: TIBBCDField
      FieldName = 'PERCENT_BAJA_DOBLE'
      ProviderFlags = []
      Precision = 18
      Size = 2
    end
    object qDatosNIVEL_ABIERTA: TIBBCDField
      FieldName = 'NIVEL_ABIERTA'
      Origin = '"COTIZACION_RENTABILIDAD"."NIVEL"'
      Precision = 9
      Size = 4
    end
    object qDatosTIPO_ABIERTA: TIBStringField
      FieldName = 'TIPO_ABIERTA'
      Origin = '"COTIZACION_RENTABILIDAD"."TIPO"'
      OnGetText = qDatosTIPO_ABIERTAGetText
      FixedChar = True
      Size = 1
    end
    object qDatosFECHA_INICIO_ABIERTA: TDateField
      FieldName = 'FECHA_INICIO_ABIERTA'
      Origin = '"COTIZACION_RENTABILIDAD"."FECHA"'
    end
    object qDatosNIVEL_CERRADA: TIBBCDField
      FieldName = 'NIVEL_CERRADA'
      Origin = '"COTIZACION_RENTABILIDAD"."NIVEL"'
      Precision = 9
      Size = 4
    end
    object qDatosTIPO_CERRADA: TIBStringField
      FieldName = 'TIPO_CERRADA'
      Origin = '"COTIZACION_RENTABILIDAD"."TIPO"'
      OnGetText = qDatosTIPO_ABIERTAGetText
      FixedChar = True
      Size = 1
    end
    object qDatosFECHA_INICIO_CERRADA: TDateField
      FieldName = 'FECHA_INICIO_CERRADA'
      Origin = '"COTIZACION_RENTABILIDAD"."FECHA"'
    end
    object qDatosRENTABILIDAD_CERRADA: TIBBCDField
      FieldName = 'RENTABILIDAD_CERRADA'
      Origin = '"COTIZACION_RENTABILIDAD"."TOTAL_PERCENT"'
      Precision = 9
      Size = 2
    end
    object qDatosCORRELACION: TSmallintField
      FieldName = 'CORRELACION'
      Origin = '"COTIZACION_ESTADO"."CORRELACION"'
    end
    object qDatosPOSICIONADO: TIBBCDField
      FieldName = 'POSICIONADO'
      Origin = '"COTIZACION_ESTADO"."POSICIONADO"'
      Precision = 9
      Size = 4
    end
    object qDatosRIESGO: TIBBCDField
      FieldName = 'RIESGO'
      Origin = '"COTIZACION_ESTADO"."RIESGO"'
      Precision = 9
      Size = 2
    end
    object qDatosPRESION_VERTICAL: TIBBCDField
      FieldName = 'PRESION_VERTICAL'
      Origin = '"COTIZACION_ESTADO"."PRESION_VERTICAL"'
      Precision = 9
      Size = 2
    end
    object qDatosPRESION_VERTICAL_ALZA_SIMPLE: TIBBCDField
      FieldName = 'PRESION_VERTICAL_ALZA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."PRESION_VERTICAL_ALZA_SIMPLE"'
      Precision = 9
      Size = 2
    end
    object qDatosPRESION_VERTICAL_ALZA_DOBLE: TIBBCDField
      FieldName = 'PRESION_VERTICAL_ALZA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."PRESION_VERTICAL_ALZA_DOBLE"'
      Precision = 9
      Size = 2
    end
    object qDatosPRESION_VERTICAL_BAJA_SIMPLE: TIBBCDField
      FieldName = 'PRESION_VERTICAL_BAJA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."PRESION_VERTICAL_BAJA_SIMPLE"'
      Precision = 9
      Size = 2
    end
    object qDatosPRESION_VERTICAL_BAJA_DOBLE: TIBBCDField
      FieldName = 'PRESION_VERTICAL_BAJA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."PRESION_VERTICAL_BAJA_DOBLE"'
      Precision = 9
      Size = 2
    end
    object qDatosPRESION_LATERAL: TIBBCDField
      FieldName = 'PRESION_LATERAL'
      Origin = '"COTIZACION_ESTADO"."PRESION_LATERAL"'
      Precision = 9
      Size = 2
    end
    object qDatosPRESION_LATERAL_ALZA_SIMPLE: TIBBCDField
      FieldName = 'PRESION_LATERAL_ALZA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."PRESION_LATERAL_ALZA_SIMPLE"'
      Precision = 9
      Size = 2
    end
    object qDatosPRESION_LATERAL_ALZA_DOBLE: TIBBCDField
      FieldName = 'PRESION_LATERAL_ALZA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."PRESION_LATERAL_ALZA_DOBLE"'
      Precision = 9
      Size = 2
    end
    object qDatosPRESION_LATERAL_BAJA_SIMPLE: TIBBCDField
      FieldName = 'PRESION_LATERAL_BAJA_SIMPLE'
      Origin = '"COTIZACION_ESTADO"."PRESION_LATERAL_BAJA_SIMPLE"'
      Precision = 9
      Size = 2
    end
    object qDatosPRESION_LATERAL_BAJA_DOBLE: TIBBCDField
      FieldName = 'PRESION_LATERAL_BAJA_DOBLE'
      Origin = '"COTIZACION_ESTADO"."PRESION_LATERAL_BAJA_DOBLE"'
      Precision = 9
      Size = 2
    end
    object qDatosZONA_BAJA_SIMPLE_DESC: TStringField
      FieldKind = fkLookup
      FieldName = 'ZONA_BAJA_SIMPLE_DESC'
      LookupDataSet = DataComun.qZonas
      LookupKeyFields = 'OID_ZONA'
      LookupResultField = 'NOMBRE'
      KeyFields = 'ZONA_BAJA_SIMPLE'
      LookupCache = True
      ReadOnly = True
      Size = 3
      Lookup = True
    end
    object qDatosZONA_BAJA_DOBLE_DESC: TStringField
      FieldKind = fkLookup
      FieldName = 'ZONA_BAJA_DOBLE_DESC'
      LookupDataSet = DataComun.qZonas
      LookupKeyFields = 'OID_ZONA'
      LookupResultField = 'NOMBRE'
      KeyFields = 'ZONA_BAJA_DOBLE'
      LookupCache = True
      ReadOnly = True
      Size = 3
      Lookup = True
    end
    object qDatosZONA_ALZA_SIMPLE_DESC: TStringField
      FieldKind = fkLookup
      FieldName = 'ZONA_ALZA_SIMPLE_DESC'
      LookupDataSet = DataComun.qZonas
      LookupKeyFields = 'OID_ZONA'
      LookupResultField = 'NOMBRE'
      KeyFields = 'ZONA_ALZA_SIMPLE'
      LookupCache = True
      ReadOnly = True
      Size = 3
      Lookup = True
    end
    object qDatosZONA_ALZA_DOBLE_DESC: TStringField
      DisplayWidth = 3
      FieldKind = fkLookup
      FieldName = 'ZONA_ALZA_DOBLE_DESC'
      LookupDataSet = DataComun.qZonas
      LookupKeyFields = 'OID_ZONA'
      LookupResultField = 'NOMBRE'
      KeyFields = 'ZONA_ALZA_DOBLE'
      LookupCache = True
      ReadOnly = True
      Size = 3
      Lookup = True
    end
    object qDatosZONA_DESC: TStringField
      DisplayWidth = 3
      FieldKind = fkLookup
      FieldName = 'ZONA_DESC'
      LookupDataSet = DataComun.qZonas
      LookupKeyFields = 'OID_ZONA'
      LookupResultField = 'NOMBRE'
      KeyFields = 'ZONA'
      LookupCache = True
      ReadOnly = True
      Size = 3
      Lookup = True
    end
    object qDatosAPERTURA: TIBBCDField
      FieldName = 'APERTURA'
      Origin = '"COTIZACION"."APERTURA"'
      Precision = 9
      Size = 4
    end
    object qDatosCIERRE: TIBBCDField
      FieldName = 'CIERRE'
      Origin = '"COTIZACION"."CIERRE"'
      Precision = 9
      Size = 4
    end
    object qDatosVOLUMEN: TIntegerField
      FieldName = 'VOLUMEN'
      Origin = '"COTIZACION"."VOLUMEN"'
    end
    object qDatosDIAS_SEGUIDOS_PERCENT: TIBBCDField
      FieldName = 'DIAS_SEGUIDOS_PERCENT'
      Origin = '"COTIZACION"."DIAS_SEGUIDOS_PERCENT"'
      Precision = 9
      Size = 2
    end
  end
end
