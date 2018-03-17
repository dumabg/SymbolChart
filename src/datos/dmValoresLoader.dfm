object ValoresLoader: TValoresLoader
  OldCreateOrder = False
  Height = 286
  Width = 196
  object qValores: TIBQuery
    Database = BD.IBDatabaseComun
    Transaction = BD.IBTransactionComun
    Left = 72
    Top = 33
    object qValoresOID_VALOR: TSmallintField
      FieldName = 'OID_VALOR'
      Origin = '"VALOR"."OID_VALOR"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
  end
end
