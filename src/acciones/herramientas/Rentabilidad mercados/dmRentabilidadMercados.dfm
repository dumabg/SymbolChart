object RentabilidadMercados: TRentabilidadMercados
  OldCreateOrder = False
  Height = 451
  Width = 554
  object qRentabilidadMercados: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select sr.*'
      'from SESION_RENTABILIDAD sr'
      'where'
      'sr.OR_SESION = :OID_SESION')
    Left = 216
    Top = 184
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_SESION'
        ParamType = ptUnknown
      end>
    object qRentabilidadMercadosOR_SESION: TIntegerField
      FieldName = 'OR_SESION'
      Origin = '"SESION_RENTABILIDAD"."OR_SESION"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qRentabilidadMercadosOR_MERCADO: TIntegerField
      FieldName = 'OR_MERCADO'
      Origin = '"SESION_RENTABILIDAD"."OR_MERCADO"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qRentabilidadMercadosPERCENT_CORTO_ABIERTO_GANANCIAS: TIBBCDField
      FieldName = 'PERCENT_CORTO_ABIERTO_GANANCIAS'
      Origin = '"SESION_RENTABILIDAD"."PERCENT_CORTO_ABIERTO_GANANCIAS"'
      Precision = 9
      Size = 2
    end
    object qRentabilidadMercadosPERCENT_CORTO_CERRADO_GANANCIAS: TIBBCDField
      FieldName = 'PERCENT_CORTO_CERRADO_GANANCIAS'
      Origin = '"SESION_RENTABILIDAD"."PERCENT_CORTO_CERRADO_GANANCIAS"'
      Precision = 9
      Size = 2
    end
    object qRentabilidadMercadosPERCENT_LARGO_ABIERTO_GANANCIAS: TIBBCDField
      FieldName = 'PERCENT_LARGO_ABIERTO_GANANCIAS'
      Origin = '"SESION_RENTABILIDAD"."PERCENT_LARGO_ABIERTO_GANANCIAS"'
      Precision = 9
      Size = 2
    end
    object qRentabilidadMercadosPERCENT_LARGO_CERRADO_GANANCIAS: TIBBCDField
      FieldName = 'PERCENT_LARGO_CERRADO_GANANCIAS'
      Origin = '"SESION_RENTABILIDAD"."PERCENT_LARGO_CERRADO_GANANCIAS"'
      Precision = 9
      Size = 2
    end
    object qRentabilidadMercadosPERCENT_CORTO_ABIERTO_PERDIDAS: TIBBCDField
      FieldName = 'PERCENT_CORTO_ABIERTO_PERDIDAS'
      Origin = '"SESION_RENTABILIDAD"."PERCENT_CORTO_ABIERTO_PERDIDAS"'
      Precision = 9
      Size = 2
    end
    object qRentabilidadMercadosPERCENT_CORTO_CERRADO_PERDIDAS: TIBBCDField
      FieldName = 'PERCENT_CORTO_CERRADO_PERDIDAS'
      Origin = '"SESION_RENTABILIDAD"."PERCENT_CORTO_CERRADO_PERDIDAS"'
      Precision = 9
      Size = 2
    end
    object qRentabilidadMercadosPERCENT_LARGO_ABIERTO_PERDIDAS: TIBBCDField
      FieldName = 'PERCENT_LARGO_ABIERTO_PERDIDAS'
      Origin = '"SESION_RENTABILIDAD"."PERCENT_LARGO_ABIERTO_PERDIDAS"'
      Precision = 9
      Size = 2
    end
    object qRentabilidadMercadosPERCENT_LARGO_CERRADO_PERDIDAS: TIBBCDField
      FieldName = 'PERCENT_LARGO_CERRADO_PERDIDAS'
      Origin = '"SESION_RENTABILIDAD"."PERCENT_LARGO_CERRADO_PERDIDAS"'
      Precision = 9
      Size = 2
    end
  end
end
