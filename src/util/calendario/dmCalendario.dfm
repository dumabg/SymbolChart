inherited Calendario: TCalendario
  Height = 248
  Width = 264
  object qMaxDate: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select max(FECHA) as FECHA from SESION')
    Left = 112
    Top = 40
    object qMaxDateFECHA: TDateField
      FieldName = 'FECHA'
      ProviderFlags = []
    end
  end
  object qMinDate: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      
        'select min(FECHA) as FECHA from SESION s, COTIZACION_ESTADO ce, ' +
        'COTIZACION c'
      'where'
      's.OID_SESION = c.OR_SESION and'
      'c.OID_COTIZACION = ce.OR_COTIZACION')
    Left = 112
    Top = 112
    object qMinDateFECHA: TDateField
      FieldName = 'FECHA'
      ProviderFlags = []
    end
  end
  object qDias: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select FECHA from SESION'
      'where FECHA>=:FECHA1 and FECHA<:FECHA2')
    Left = 200
    Top = 112
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'FECHA1'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'FECHA2'
        ParamType = ptUnknown
      end>
    object qDiasFECHA: TDateField
      FieldName = 'FECHA'
      Origin = '"SESION"."FECHA"'
      Required = True
    end
  end
end
