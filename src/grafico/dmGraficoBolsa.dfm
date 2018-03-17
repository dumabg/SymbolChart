object DataGraficoBolsa: TDataGraficoBolsa
  OldCreateOrder = False
  Height = 241
  Width = 349
  object qLineas: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select * from LINEA'
      'where OR_VALOR = :OID_VALOR')
    Left = 104
    Top = 48
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_VALOR'
        ParamType = ptUnknown
      end>
    object qLineasOID_LINEA: TSmallintField
      FieldName = 'OID_LINEA'
      Origin = '"LINEA"."OID_LINEA"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qLineasOR_VALOR: TSmallintField
      FieldName = 'OR_VALOR'
      Origin = '"LINEA"."OR_VALOR"'
      Required = True
    end
    object qLineasTIPO: TIBStringField
      FieldName = 'TIPO'
      Origin = '"LINEA"."TIPO"'
      Required = True
      FixedChar = True
      Size = 1
    end
    object qLineasY1: TIBBCDField
      FieldName = 'Y1'
      Origin = '"LINEA"."Y1"'
      Required = True
      Precision = 9
      Size = 2
    end
    object qLineasY2: TIBBCDField
      FieldName = 'Y2'
      Origin = '"LINEA"."Y2"'
      Required = True
      Precision = 9
      Size = 2
    end
    object qLineasX1: TDateField
      FieldName = 'X1'
      Origin = '"LINEA"."X1"'
    end
    object qLineasX2: TDateField
      FieldName = 'X2'
      Origin = '"LINEA"."X2"'
    end
  end
  object dLineas: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'delete from LINEA'
      'where OR_VALOR = :OID_VALOR')
    Transaction = BD.IBTransactionUsuario
    Left = 104
    Top = 120
  end
  object iLinea: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'insert into LINEA'
      '(OID_LINEA, OR_VALOR, TIPO, X1, X2, Y1, Y2)'
      'values'
      '(:OID_LINEA, :OR_VALOR, :TIPO, :X1, :X2, :Y1, :Y2)')
    Transaction = BD.IBTransactionUsuario
    Left = 200
    Top = 120
  end
end
