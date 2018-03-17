inherited DataGraficoValorLayer: TDataGraficoValorLayer
  OldCreateOrder = True
  Height = 192
  Width = 252
  object qCotizacion: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'SELECT s.FECHA, c.CIERRE FROM SESION s, COTIZACION c'
      'where'
      'c.OR_SESION = s.OID_SESION and'
      'c.OR_VALOR = :OID_VALOR'
      'order by s.fecha')
    Left = 112
    Top = 56
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_VALOR'
        ParamType = ptUnknown
      end>
    object qCotizacionFECHA: TDateField
      FieldName = 'FECHA'
      Origin = '"SESION"."FECHA"'
      Required = True
    end
    object qCotizacionCIERRE: TIBBCDField
      FieldName = 'CIERRE'
      Origin = '"COTIZACION"."CIERRE"'
      Precision = 9
      Size = 4
    end
  end
end
