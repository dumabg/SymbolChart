inherited PanelRSI: TPanelRSI
  OldCreateOrder = True
  Height = 235
  Width = 309
  object qRSI: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select c.OR_SESION, ce.RSI_14, ce.RSI_140, s.FECHA'
      'from COTIZACION_ESTADO ce, COTIZACION c, SESION s'
      'where '
      'ce.OR_COTIZACION = c.OID_COTIZACION and'
      'c.OR_VALOR = :OID_VALOR and'
      's.OID_SESION = c.OR_SESION'
      'order by s.FECHA')
    Left = 152
    Top = 104
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_VALOR'
        ParamType = ptUnknown
      end>
    object qRSIOR_SESION: TSmallintField
      FieldName = 'OR_SESION'
      Origin = '"COTIZACION"."OR_SESION"'
      Required = True
    end
    object qRSIFECHA: TDateField
      FieldName = 'FECHA'
      Origin = '"SESION"."FECHA"'
      Required = True
    end
    object qRSIRSI_14: TSmallintField
      FieldName = 'RSI_14'
      Origin = '"COTIZACION_ESTADO"."RSI_14"'
    end
    object qRSIRSI_140: TSmallintField
      FieldName = 'RSI_140'
      Origin = '"COTIZACION_ESTADO"."RSI_140"'
    end
  end
end
