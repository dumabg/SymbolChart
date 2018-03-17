object PanelIntradia: TPanelIntradia
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 186
  Width = 233
  object AmbienteIntradia: TIBQuery
    Database = BD.IBDatabaseComun
    Transaction = BD.IBTransactionComun
    SQL.Strings = (
      'select * from ambiente_intradia')
    Left = 104
    Top = 72
    object AmbienteIntradiaOID_AMBIENTE_INTRADIA: TIBStringField
      FieldName = 'OID_AMBIENTE_INTRADIA'
      Origin = '"AMBIENTE_INTRADIA"."OID_AMBIENTE_INTRADIA"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      FixedChar = True
      Size = 1
    end
    object AmbienteIntradiaMENSAJE: TIBStringField
      FieldName = 'MENSAJE'
      Origin = '"AMBIENTE_INTRADIA"."MENSAJE"'
      Required = True
      Size = 45
    end
  end
end
