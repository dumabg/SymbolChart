inherited FS: TFS
  Height = 163
  Width = 299
  object qFS: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select * from <TABLE>'
      'where OR_PADRE = :OID_PADRE and OID_FS<>0'
      'order by TIPO desc, UPPER(NOMBRE)')
    Left = 56
    Top = 32
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_PADRE'
        ParamType = ptUnknown
      end>
    object qFSOID_FS: TIntegerField
      FieldName = 'OID_FS'
      Origin = '"FS"."OID_FS"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qFSOR_PADRE: TIntegerField
      FieldName = 'OR_PADRE'
      Origin = '"FS"."OR_PADRE"'
      Required = True
    end
    object qFSTIPO: TIBStringField
      FieldName = 'TIPO'
      Origin = '"FS"."TIPO"'
      Required = True
      FixedChar = True
      Size = 1
    end
    object qFSNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = '"FS"."NOMBRE"'
      Required = True
      Size = 50
    end
  end
  object qFSChildCount: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select count(*) from <TABLE>'
      'where'
      'or_padre = :OID_PADRE and OID_FS<>0')
    Left = 152
    Top = 32
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_PADRE'
        ParamType = ptUnknown
      end>
    object qFSChildCountCOUNT: TIntegerField
      FieldName = 'COUNT'
      ProviderFlags = []
    end
  end
end
