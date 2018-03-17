object DataComun: TDataComun
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 290
  Width = 382
  object qMercados: TIBQuery
    Database = BD.IBDatabaseComun
    Transaction = BD.IBTransactionComun
    ParamCheck = False
    SQL.Strings = (
      'select * from MERCADO'
      'order by OID_MERCADO')
    Left = 104
    Top = 40
    object qMercadosOID_MERCADO: TSmallintField
      FieldName = 'OID_MERCADO'
      Origin = '"MERCADO"."OID_MERCADO"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qMercadosNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = '"MERCADO"."NOMBRE"'
      Required = True
      Size = 30
    end
    object qMercadosPAIS: TIBStringField
      FieldName = 'PAIS'
      Origin = '"MERCADO"."PAIS"'
      Required = True
    end
    object qMercadosBANDERA: TMemoField
      FieldName = 'BANDERA'
      Origin = '"MERCADO"."BANDERA"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftGraphic
      Size = 8
    end
    object qMercadosDECIMALES: TSmallintField
      FieldName = 'DECIMALES'
      Origin = '"MERCADO"."DECIMALES"'
      Required = True
    end
    object qMercadosOR_MONEDA: TSmallintField
      FieldName = 'OR_MONEDA'
      Origin = '"MERCADO"."OR_MONEDA"'
      Required = True
    end
  end
  object qMonedas: TIBQuery
    Database = BD.IBDatabaseComun
    Transaction = BD.IBTransactionComun
    ParamCheck = False
    SQL.Strings = (
      'select * from MONEDA'
      'order by OID_MONEDA desc')
    Left = 216
    Top = 40
    object qMonedasOID_MONEDA: TSmallintField
      FieldName = 'OID_MONEDA'
      Origin = '"MONEDA"."OID_MONEDA"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qMonedasMONEDA: TIBStringField
      FieldName = 'MONEDA'
      Origin = '"MONEDA"."MONEDA"'
      Required = True
    end
  end
  object qValores: TIBQuery
    Database = BD.IBDatabaseComun
    Transaction = BD.IBTransactionComun
    ParamCheck = False
    SQL.Strings = (
      'select * from VALOR'
      'order by OID_VALOR')
    Left = 104
    Top = 120
    object qValoresOID_VALOR: TSmallintField
      FieldName = 'OID_VALOR'
      Origin = '"VALOR"."OID_VALOR"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qValoresOR_MERCADO: TSmallintField
      FieldName = 'OR_MERCADO'
      Origin = '"VALOR"."OR_MERCADO"'
    end
    object qValoresNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = '"VALOR"."NOMBRE"'
      Required = True
      Size = 50
    end
    object qValoresSIMBOLO: TIBStringField
      FieldName = 'SIMBOLO'
      Origin = '"VALOR"."SIMBOLO"'
    end
  end
  object ImageListBanderas: TImageList
    Left = 216
    Top = 120
  end
  object qZonas: TIBQuery
    Database = BD.IBDatabaseComun
    Transaction = BD.IBTransactionComun
    ParamCheck = False
    SQL.Strings = (
      'select * from zona'
      'order by OID_ZONA desc')
    Left = 104
    Top = 200
    object qZonasOID_ZONA: TIBStringField
      FieldName = 'OID_ZONA'
      Origin = '"ZONA"."OID_ZONA"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      FixedChar = True
      Size = 1
    end
    object qZonasNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = 'ZONA.NOMBRE'
      Required = True
      Size = 3
    end
  end
  object qSesion: TIBQuery
    ParamCheck = False
    SQL.Strings = (
      'select * from  SESION'
      'order by OID_SESION')
    Left = 216
    Top = 200
    object qSesionOID_SESION: TSmallintField
      FieldName = 'OID_SESION'
      Origin = '"SESION"."OID_SESION"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qSesionFECHA: TDateField
      FieldName = 'FECHA'
      Origin = '"SESION"."FECHA"'
      Required = True
    end
  end
end
