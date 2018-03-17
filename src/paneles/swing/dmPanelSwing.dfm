inherited PanelSwing: TPanelSwing
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 206
  Width = 312
  object CotizacionMensajes: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    DataSource = Data.dsCotizacion
    SQL.Strings = (
      
        'select OR_AVANCE, FLAGS, OR_SUGERENCIA, PARAMS_SUGERENCIA, OR_SO' +
        'NDEOS, PARAMS_SONDEOS from cotizacion_mensaje cm'
      'where'
      'cm.or_cotizacion =:OID_COTIZACION')
    Left = 96
    Top = 24
    ParamData = <
      item
        DataType = ftInteger
        Name = 'OID_COTIZACION'
        ParamType = ptUnknown
        Size = 4
      end>
    object CotizacionMensajesOR_AVANCE: TIntegerField
      FieldName = 'OR_AVANCE'
      Origin = '"COTIZACION_MENSAJE"."OR_AVANCE"'
    end
    object CotizacionMensajesFLAGS: TIntegerField
      FieldName = 'FLAGS'
      Origin = '"COTIZACION_MENSAJE"."FLAGS"'
    end
    object CotizacionMensajesOR_SUGERENCIA: TIntegerField
      FieldName = 'OR_SUGERENCIA'
      Origin = '"COTIZACION_MENSAJE"."OR_SUGERENCIA"'
    end
    object CotizacionMensajesPARAMS_SUGERENCIA: TIBStringField
      FieldName = 'PARAMS_SUGERENCIA'
      Origin = '"COTIZACION_MENSAJE"."PARAMS_SUGERENCIA"'
      Size = 1
    end
    object CotizacionMensajesOR_SONDEOS: TIntegerField
      FieldName = 'OR_SONDEOS'
      Origin = '"COTIZACION_MENSAJE"."OR_SONDEOS"'
    end
    object CotizacionMensajesPARAMS_SONDEOS: TIBStringField
      FieldName = 'PARAMS_SONDEOS'
      Origin = '"COTIZACION_MENSAJE"."PARAMS_SONDEOS"'
      Size = 21
    end
  end
  object qMensaje: TIBQuery
    Database = BD.IBDatabaseComun
    Transaction = BD.IBTransactionComun
    SQL.Strings = (
      'SELECT f.ES FROM MENSAJE_FRASE MF, FRASE F'
      'WHERE'
      '  (MF.OR_FRASE = F.OID_FRASE) AND '
      '  (MF.OR_MENSAJE = :OID_MENSAJE)'
      'ORDER BY'
      '  POSICION')
    Left = 208
    Top = 104
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_MENSAJE'
        ParamType = ptUnknown
      end>
    object qMensajeES: TMemoField
      FieldName = 'ES'
      Origin = '"FRASE"."ES"'
      ProviderFlags = [pfInUpdate]
      Required = True
      BlobType = ftMemo
      Size = 8
    end
  end
end
