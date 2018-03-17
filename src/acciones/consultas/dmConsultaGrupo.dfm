object ConsultaGrupo: TConsultaGrupo
  OldCreateOrder = False
  Height = 192
  Width = 297
  object iGrupo: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'insert into GRUPO(OID_GRUPO, NOMBRE) values (:OID_GRUPO,:NOMBRE)')
    Transaction = BD.IBTransactionUsuario
    Left = 64
    Top = 40
  end
  object iGrupoValor: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      
        'insert into GRUPO_VALOR(OR_GRUPO, OR_VALOR) values (:OR_GRUPO,:O' +
        'R_VALOR)')
    Transaction = BD.IBTransactionUsuario
    Left = 64
    Top = 112
  end
  object qExisteGrupo: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select count(*) from GRUPO where NOMBRE=:NOMBRE')
    Left = 200
    Top = 80
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'NOMBRE'
        ParamType = ptUnknown
      end>
    object qExisteGrupoCOUNT: TIntegerField
      FieldName = 'COUNT'
      ProviderFlags = []
    end
  end
end
