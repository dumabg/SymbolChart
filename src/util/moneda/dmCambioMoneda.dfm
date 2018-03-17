inherited CambioMoneda: TCambioMoneda
  OldCreateOrder = True
  Height = 248
  Width = 327
  object qCambio: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select first 1 c.CIERRE from cotizacion c, sesion s'
      'where'
      'c.or_valor = :OID_VALOR and'
      'c.or_sesion = s.oid_sesion'
      'order by s.fecha desc')
    UniDirectional = True
    Left = 152
    Top = 72
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_VALOR'
        ParamType = ptUnknown
      end>
    object qCambioCIERRE: TIBBCDField
      FieldName = 'CIERRE'
      Origin = '"COTIZACION"."CIERRE"'
      Precision = 9
      Size = 4
    end
  end
end
