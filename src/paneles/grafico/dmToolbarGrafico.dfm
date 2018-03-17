object ToolbarGrafico: TToolbarGrafico
  OldCreateOrder = False
  Height = 369
  Width = 405
  object uColor: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'update OSCILADOR '
      'set COLOR=:COLOR'
      'where OR_FS=:OIDFS')
    Transaction = BD.IBTransactionUsuario
    Left = 152
    Top = 128
  end
end
