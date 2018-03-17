object EstudioScriptError: TEstudioScriptError
  OldCreateOrder = False
  Height = 329
  Width = 402
  object qEstrategia: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select ESTRATEGIA_APERTURA, ESTRATEGIA_APERTURA_POSICIONADO, '
      'ESTRATEGIA_CIERRE, ESTRATEGIA_CIERRE_POSICIONADO from ESTRATEGIA'
      'where OID_ESTRATEGIA = :OID_ESTRATEGIA')
    Left = 184
    Top = 120
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_ESTRATEGIA'
        ParamType = ptUnknown
      end>
    object qEstrategiaESTRATEGIA_APERTURA: TMemoField
      FieldName = 'ESTRATEGIA_APERTURA'
      Origin = '"ESTRATEGIA"."ESTRATEGIA_APERTURA"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qEstrategiaESTRATEGIA_APERTURA_POSICIONADO: TMemoField
      FieldName = 'ESTRATEGIA_APERTURA_POSICIONADO'
      Origin = '"ESTRATEGIA"."ESTRATEGIA_APERTURA_POSICIONADO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qEstrategiaESTRATEGIA_CIERRE: TMemoField
      FieldName = 'ESTRATEGIA_CIERRE'
      Origin = '"ESTRATEGIA"."ESTRATEGIA_CIERRE"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qEstrategiaESTRATEGIA_CIERRE_POSICIONADO: TMemoField
      FieldName = 'ESTRATEGIA_CIERRE_POSICIONADO'
      Origin = '"ESTRATEGIA"."ESTRATEGIA_CIERRE_POSICIONADO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
  end
end
