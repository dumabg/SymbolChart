object Inversor: TInversor
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 338
  Width = 407
  object dsPosiciones: TDataSource
    DataSet = EstrategiaInterpreterBD.Posiciones
    Left = 72
    Top = 64
  end
  object dsPosicionesMercado: TDataSource
    Left = 72
    Top = 144
  end
  object qEstrategias: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select * from ESTRATEGIA'
      'where TIPO='#39'P'#39
      'order by NOMBRE')
    Left = 256
    Top = 64
    object qEstrategiasOID_ESTRATEGIA: TSmallintField
      FieldName = 'OID_ESTRATEGIA'
      Origin = '"ESTRATEGIA"."OID_ESTRATEGIA"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qEstrategiasNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = '"ESTRATEGIA"."NOMBRE"'
      Required = True
      Size = 30
    end
    object qEstrategiasDESCRIPCION: TMemoField
      FieldName = 'DESCRIPCION'
      Origin = '"ESTRATEGIA"."DESCRIPCION"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qEstrategiasESTRATEGIA_APERTURA: TMemoField
      FieldName = 'ESTRATEGIA_APERTURA'
      Origin = '"ESTRATEGIA"."ESTRATEGIA_APERTURA"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qEstrategiasTIPO: TIBStringField
      FieldName = 'TIPO'
      Origin = '"ESTRATEGIA"."TIPO"'
      Required = True
      FixedChar = True
      Size = 1
    end
    object qEstrategiasESTRATEGIA_CIERRE: TMemoField
      FieldName = 'ESTRATEGIA_CIERRE'
      Origin = '"ESTRATEGIA"."ESTRATEGIA_CIERRE"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
  end
end
