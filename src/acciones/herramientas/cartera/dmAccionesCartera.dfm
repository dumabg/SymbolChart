object AccionesCartera: TAccionesCartera
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 278
  Width = 393
  object qCountCarteras: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select count(*) from CARTERA'
      '')
    Left = 152
    Top = 80
    object qCountCarterasCOUNT: TIntegerField
      FieldName = 'COUNT'
      ProviderFlags = []
    end
  end
end
