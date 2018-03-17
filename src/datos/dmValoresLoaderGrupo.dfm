inherited ValoresLoaderGrupo: TValoresLoaderGrupo
  OldCreateOrder = True
  inherited qValores: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select OR_VALOR as OID_VALOR from GRUPO_VALOR'
      'where OR_GRUPO = :OID_GRUPO')
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_GRUPO'
        ParamType = ptUnknown
      end>
  end
end
