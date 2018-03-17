inherited PanelMensaje: TPanelMensaje
  OldCreateOrder = True
  Height = 337
  Width = 476
  object CotizacionMensajes: TIBQuery
    BeforeOpen = CotizacionMensajesBeforeOpen
    SQL.Strings = (
      'select * from cotizacion_mensaje cm'
      'where'
      'cm.or_cotizacion =:OID_COTIZACION')
    Left = 80
    Top = 72
    ParamData = <
      item
        DataType = ftInteger
        Name = 'OID_COTIZACION'
        ParamType = ptUnknown
        Size = 4
      end>
  end
  object TipoMensajes: TIBQuery
    Database = BD.IBDatabaseComun
    Transaction = BD.IBTransactionComun
    SQL.Strings = (
      'select * from TIPO_MENSAJE'
      'order by POSICION desc'
      ' ')
    Left = 272
    Top = 48
    object TipoMensajesOID_TIPO_MENSAJE: TSmallintField
      FieldName = 'OID_TIPO_MENSAJE'
      Origin = 'TIPO_MENSAJE.OID_TIPO_MENSAJE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object TipoMensajesDESCRIPCION: TIBStringField
      FieldName = 'DESCRIPCION'
      Origin = 'TIPO_MENSAJE.DESCRIPCION'
      Required = True
      Size = 30
    end
    object TipoMensajesPOSICION: TSmallintField
      FieldName = 'POSICION'
      Origin = '"TIPO_MENSAJE"."POSICION"'
      Required = True
    end
    object TipoMensajesCAMPO: TIBStringField
      FieldName = 'CAMPO'
      Origin = '"TIPO_MENSAJE"."CAMPO"'
      Size = 30
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
    Left = 272
    Top = 160
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
