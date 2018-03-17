object DataComunSesion: TDataComunSesion
  OldCreateOrder = False
  Height = 250
  Width = 311
  object qSesionFecha: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select *  from SESION'
      'order by FECHA desc')
    Left = 136
    Top = 48
    object qSesionFechaOID_SESION: TSmallintField
      FieldName = 'OID_SESION'
      Origin = '"SESION"."OID_SESION"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qSesionFechaFECHA: TDateField
      FieldName = 'FECHA'
      Origin = '"SESION"."FECHA"'
      Required = True
    end
  end
end
