inherited Saldo: TSaldo
  OnCreate = DataModuleCreate
  Height = 228
  Width = 339
  object qSesion: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select first 1 OID_SESION from sesion'
      'order by OID_SESION desc')
    Left = 104
    Top = 64
    object qSesionOID_SESION: TSmallintField
      FieldName = 'OID_SESION'
      Origin = '"SESION"."OID_SESION"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
  end
end
