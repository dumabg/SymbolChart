inherited EditFS: TEditFS
  Height = 219
  object iFS: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'insert into <TABLE>'
      '  (NOMBRE, OID_FS, OR_PADRE, TIPO)'
      'values'
      '  (:NOMBRE, :OID_FS, :OR_PADRE, :TIPO)')
    Transaction = BD.IBTransactionUsuario
    Left = 64
    Top = 128
  end
  object uFS: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'update <TABLE>'
      'set'
      '  NOMBRE = :NOMBRE,'
      '  OR_PADRE = :OR_PADRE'
      'where'
      '  OID_FS = :OID_FS')
    Transaction = BD.IBTransactionUsuario
    Left = 128
    Top = 128
  end
  object dFS: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'delete from <TABLE>'
      'where'
      '  OID_FS = :OID_FS')
    Transaction = BD.IBTransactionUsuario
    Left = 192
    Top = 128
  end
end
