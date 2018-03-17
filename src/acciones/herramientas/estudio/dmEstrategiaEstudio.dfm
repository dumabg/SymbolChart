inherited EstrategiaEstudio: TEstrategiaEstudio
  object qCotizaciones: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select OR_VALOR from cotizacion'
      'where'
      'OR_SESION = :OID_SESION and'
      'not CIERRE is null'
      'order by OR_VALOR')
    Left = 320
    Top = 136
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_SESION'
        ParamType = ptUnknown
      end>
    object qCotizacionesOR_VALOR: TSmallintField
      FieldName = 'OR_VALOR'
      Origin = '"COTIZACION"."OR_VALOR"'
      Required = True
    end
  end
end
