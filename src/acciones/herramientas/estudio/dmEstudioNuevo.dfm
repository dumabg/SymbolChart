inherited EstudioNuevo: TEstudioNuevo
  OldCreateOrder = True
  Height = 429
  Width = 543
  object qEstrategias: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select OID_ESTRATEGIA, NOMBRE, DESCRIPCION from ESTRATEGIA'
      'order by NOMBRE')
    Left = 360
    Top = 248
    object qEstrategiasOID_ESTRATEGIA: TSmallintField
      FieldName = 'OID_ESTRATEGIA'
      Origin = '"ESTRATEGIA"."OID_ESTRATEGIA"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qEstrategiasNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = '"TIPO_ESTUDIO"."NOMBRE"'
      Required = True
      Size = 30
    end
    object qEstrategiasDESCRIPCION: TMemoField
      FieldName = 'DESCRIPCION'
      Origin = '"TIPO_ESTUDIO"."DESCRIPCION"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
  end
  object dsMonedas: TDataSource
    DataSet = DataComun.qMonedas
    Left = 104
    Top = 328
  end
end
