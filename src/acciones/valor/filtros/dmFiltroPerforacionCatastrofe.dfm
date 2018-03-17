inherited FiltroPerforacionCatastrofe: TFiltroPerforacionCatastrofe
  Height = 228
  Width = 233
  object Ayer: TIBQuery [0]
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      
        'select first 1 ce.ZONA from COTIZACION c, COTIZACION_ESTADO ce, ' +
        'SESION s'
      'where'
      'ce.OR_COTIZACION = c.OID_COTIZACION and'
      'c.OR_VALOR = :OID_VALOR and'
      'c.OR_SESION = s.OID_SESION and'
      
        's.FECHA < (select FECHA from sesion where oid_sesion = :OID_SESI' +
        'ON)'
      'order by s.FECHA desc')
    Left = 32
    Top = 72
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_VALOR'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'OID_SESION'
        ParamType = ptUnknown
      end>
    object AyerZONA: TIBStringField
      FieldName = 'ZONA'
      Origin = '"COTIZACION_ESTADO"."ZONA"'
      FixedChar = True
      Size = 1
    end
  end
end
