object DataAccionesValor: TDataAccionesValor
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 214
  Width = 337
  object Grupos: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select * from grupo'
      'order by nombre')
    UpdateObject = uGrupos
    Left = 144
    Top = 32
    object GruposOID_GRUPO: TIntegerField
      FieldName = 'OID_GRUPO'
      Origin = 'GRUPO.OID_GRUPO'
      Required = True
    end
    object GruposNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = 'GRUPO.NOMBRE'
      Required = True
      Size = 30
    end
  end
  object uGrupos: TIBUpdateSQL
    RefreshSQL.Strings = (
      'Select '
      '  OID_GRUPO,'
      '  NOMBRE'
      'from grupo '
      'where'
      '  OID_GRUPO = :OID_GRUPO')
    ModifySQL.Strings = (
      'update grupo'
      'set'
      '  OID_GRUPO = :OID_GRUPO,'
      '  NOMBRE = :NOMBRE'
      'where'
      '  OID_GRUPO = :OLD_OID_GRUPO')
    InsertSQL.Strings = (
      'insert into grupo'
      '  (OID_GRUPO, NOMBRE)'
      'values'
      '  (:OID_GRUPO, :NOMBRE)')
    DeleteSQL.Strings = (
      'delete from grupo'
      'where'
      '  OID_GRUPO = :OLD_OID_GRUPO')
    Left = 72
    Top = 32
  end
  object OIDGrupo: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select MIN(OID_GRUPO) from GRUPO')
    Left = 208
    Top = 32
    object OIDGrupoMIN: TIntegerField
      FieldName = 'MIN'
    end
  end
  object Indices: TIBQuery
    Database = BD.IBDatabaseComun
    Transaction = BD.IBTransactionComun
    SQL.Strings = (
      'SELECT '
      '  INDICE.OID_INDICE,'
      '  INDICE.NOMBRE,'
      '  INDICE.OR_MERCADO,'
      '  INDICE.OR_VALOR,'
      '  count(INDICE_VALOR.OR_VALOR) AS NUM_VALORES'
      'FROM'
      '  INDICE_VALOR'
      
        '  RIGHT OUTER JOIN INDICE ON (INDICE_VALOR.OR_INDICE = INDICE.OI' +
        'D_INDICE)'
      'GROUP BY'
      '  INDICE.OID_INDICE,'
      '  INDICE.NOMBRE,'
      '  INDICE.OR_MERCADO,'
      '  INDICE.OR_VALOR'
      'ORDER BY'
      '  INDICE.NOMBRE')
    Left = 99
    Top = 103
    object IndicesOID_INDICE: TSmallintField
      FieldName = 'OID_INDICE'
      Origin = 'INDICE.OID_INDICE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object IndicesNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = 'INDICE.NOMBRE'
      Required = True
      Size = 30
    end
    object IndicesOR_MERCADO: TSmallintField
      FieldName = 'OR_MERCADO'
      Origin = 'INDICE.OR_MERCADO'
    end
    object IndicesOR_VALOR: TIntegerField
      FieldName = 'OR_VALOR'
      Origin = 'INDICE.OR_VALOR'
    end
    object IndicesNUM_VALORES: TIntegerField
      FieldName = 'NUM_VALORES'
      ProviderFlags = []
    end
  end
  object Carteras: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select OID_CARTERA, NOMBRE, OR_CUENTA from CARTERA'
      '')
    Left = 216
    Top = 112
    object CarterasOID_CARTERA: TSmallintField
      FieldName = 'OID_CARTERA'
      Origin = '"CARTERA"."OID_CARTERA"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object CarterasNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = '"CARTERA"."NOMBRE"'
      Required = True
      Size = 30
    end
  end
  object dGrupoValor: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'delete from GRUPO_VALOR'
      'where OR_GRUPO=:OID_GRUPO')
    Transaction = BD.IBTransactionUsuario
    Left = 152
    Top = 152
  end
end
