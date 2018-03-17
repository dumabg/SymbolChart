inherited EstrategiaCartera: TEstrategiaCartera
  Height = 414
  Width = 544
  object qSesion: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      
        'select c.OR_VALOR, max(s.FECHA) as FECHA from cotizacion c, sesi' +
        'on s'
      'where '
      'c.OR_SESION = s.OID_SESION and'
      's.FECHA >= (select max(fecha) - 7 from sesion)'
      'group by'
      'c.OR_VALOR')
    Left = 320
    Top = 136
    object qSesionOR_VALOR: TSmallintField
      FieldName = 'OR_VALOR'
      Origin = '"COTIZACION"."OR_VALOR"'
      Required = True
    end
    object qSesionFECHA: TDateField
      FieldName = 'FECHA'
      ProviderFlags = []
    end
  end
end
