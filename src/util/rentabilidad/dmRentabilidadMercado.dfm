object RentabilidadMercado: TRentabilidadMercado
  OldCreateOrder = True
  Height = 194
  Width = 327
  object MercadoRentabilidad: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select PERCENT_CORTO_ABIERTO_GANANCIAS, '
      'PERCENT_CORTO_ABIERTO_PERDIDAS, '
      'PERCENT_CORTO_CERRADO_GANANCIAS, '
      'PERCENT_CORTO_CERRADO_PERDIDAS, '
      'PERCENT_LARGO_ABIERTO_GANANCIAS, '
      'PERCENT_LARGO_ABIERTO_PERDIDAS, '
      'PERCENT_LARGO_CERRADO_GANANCIAS, '
      'PERCENT_LARGO_CERRADO_PERDIDAS '
      'from SESION_RENTABILIDAD'
      'where'
      'OR_SESION = :OID_SESION and'
      'OR_MERCADO = :OID_MERCADO')
    Left = 144
    Top = 72
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_SESION'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'OID_MERCADO'
        ParamType = ptUnknown
      end>
    object MercadoRentabilidadPERCENT_CORTO_ABIERTO_GANANCIAS: TIBBCDField
      FieldName = 'PERCENT_CORTO_ABIERTO_GANANCIAS'
      Origin = '"SESION_RENTABILIDAD"."PERCENT_CORTO_ABIERTO_GANANCIAS"'
      DisplayFormat = '#0.00%;#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object MercadoRentabilidadPERCENT_CORTO_ABIERTO_PERDIDAS: TIBBCDField
      FieldName = 'PERCENT_CORTO_ABIERTO_PERDIDAS'
      Origin = '"SESION_RENTABILIDAD"."PERCENT_CORTO_ABIERTO_PERDIDAS"'
      DisplayFormat = '#0.00%;#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object MercadoRentabilidadPERCENT_CORTO_CERRADO_GANANCIAS: TIBBCDField
      FieldName = 'PERCENT_CORTO_CERRADO_GANANCIAS'
      Origin = '"SESION_RENTABILIDAD"."PERCENT_CORTO_CERRADO_GANANCIAS"'
      DisplayFormat = '#0.00%;#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object MercadoRentabilidadPERCENT_CORTO_CERRADO_PERDIDAS: TIBBCDField
      FieldName = 'PERCENT_CORTO_CERRADO_PERDIDAS'
      Origin = '"SESION_RENTABILIDAD"."PERCENT_CORTO_CERRADO_PERDIDAS"'
      DisplayFormat = '#0.00%;#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object MercadoRentabilidadPERCENT_LARGO_ABIERTO_GANANCIAS: TIBBCDField
      FieldName = 'PERCENT_LARGO_ABIERTO_GANANCIAS'
      Origin = '"SESION_RENTABILIDAD"."PERCENT_LARGO_ABIERTO_GANANCIAS"'
      DisplayFormat = '#0.00%;#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object MercadoRentabilidadPERCENT_LARGO_ABIERTO_PERDIDAS: TIBBCDField
      FieldName = 'PERCENT_LARGO_ABIERTO_PERDIDAS'
      Origin = '"SESION_RENTABILIDAD"."PERCENT_LARGO_ABIERTO_PERDIDAS"'
      DisplayFormat = '#0.00%;#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object MercadoRentabilidadPERCENT_LARGO_CERRADO_GANANCIAS: TIBBCDField
      FieldName = 'PERCENT_LARGO_CERRADO_GANANCIAS'
      Origin = '"SESION_RENTABILIDAD"."PERCENT_LARGO_CERRADO_GANANCIAS"'
      DisplayFormat = '#0.00%;#0.00%;0%'
      Precision = 9
      Size = 2
    end
    object MercadoRentabilidadPERCENT_LARGO_CERRADO_PERDIDAS: TIBBCDField
      FieldName = 'PERCENT_LARGO_CERRADO_PERDIDAS'
      Origin = '"SESION_RENTABILIDAD"."PERCENT_LARGO_CERRADO_PERDIDAS"'
      DisplayFormat = '#0.00%;#0.00%;0%'
      Precision = 9
      Size = 2
    end
  end
end
