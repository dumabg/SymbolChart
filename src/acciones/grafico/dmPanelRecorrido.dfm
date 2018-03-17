inherited PanelRecorrido: TPanelRecorrido
  OldCreateOrder = True
  Height = 228
  Width = 307
  object qRecorrido: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select c.OR_SESION, ce.CORRELACION, s.FECHA'
      'from COTIZACION_ESTADO ce, COTIZACION c, SESION s'
      'where '
      'ce.OR_COTIZACION = c.OID_COTIZACION and'
      'c.OR_VALOR = :OID_VALOR and'
      's.OID_SESION = c.OR_SESION'
      'order by s.FECHA')
    Left = 128
    Top = 56
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_VALOR'
        ParamType = ptUnknown
      end>
    object qRecorridoOR_SESION: TSmallintField
      FieldName = 'OR_SESION'
      Origin = '"COTIZACION"."OR_SESION"'
      Required = True
    end
    object qRecorridoCORRELACION: TSmallintField
      FieldName = 'CORRELACION'
      Origin = '"COTIZACION_ESTADO"."CORRELACION"'
    end
    object qRecorridoFECHA: TDateField
      FieldName = 'FECHA'
      Origin = '"SESION"."FECHA"'
      Required = True
    end
  end
end
