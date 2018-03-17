object Estrategias: TEstrategias
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 366
  Width = 491
  object qEstrategias: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    AfterScroll = qEstrategiasAfterScroll
    BeforeScroll = qEstrategiasBeforeScroll
    SQL.Strings = (
      'select * from ESTRATEGIA')
    UpdateObject = uEstrategias
    OnFilterRecord = qEstrategiasFilterRecord
    Left = 200
    Top = 104
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
    object qEstrategiasTIPO: TIBStringField
      FieldName = 'TIPO'
      Origin = '"ESTRATEGIA"."TIPO"'
      Required = True
      FixedChar = True
      Size = 1
    end
    object qEstrategiasESTRATEGIA_APERTURA: TMemoField
      FieldName = 'ESTRATEGIA_APERTURA'
      Origin = '"ESTRATEGIA"."ESTRATEGIA_APERTURA"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qEstrategiasESTRATEGIA_CIERRE: TMemoField
      FieldName = 'ESTRATEGIA_CIERRE'
      Origin = '"ESTRATEGIA"."ESTRATEGIA_CIERRE"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qEstrategiasESTRATEGIA_APERTURA_POSICIONADO: TMemoField
      FieldName = 'ESTRATEGIA_APERTURA_POSICIONADO'
      Origin = '"ESTRATEGIA"."ESTRATEGIA_APERTURA_POSICIONADO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qEstrategiasESTRATEGIA_CIERRE_POSICIONADO: TMemoField
      FieldName = 'ESTRATEGIA_CIERRE_POSICIONADO'
      Origin = '"ESTRATEGIA"."ESTRATEGIA_CIERRE_POSICIONADO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
  end
  object uEstrategias: TIBUpdateSQL
    RefreshSQL.Strings = (
      'Select '
      '  OID_ESTRATEGIA,'
      '  NOMBRE,'
      '  DESCRIPCION,'
      '  TIPO,'
      '  ESTRATEGIA_APERTURA,'
      '  ESTRATEGIA_CIERRE,'
      '  ESTRATEGIA_APERTURA_POSICIONADO,'
      '  ESTRATEGIA_CIERRE_POSICIONADO'
      'from ESTRATEGIA '
      'where'
      '  OID_ESTRATEGIA = :OID_ESTRATEGIA')
    ModifySQL.Strings = (
      'update ESTRATEGIA'
      'set'
      '  DESCRIPCION = :DESCRIPCION,'
      '  ESTRATEGIA_APERTURA = :ESTRATEGIA_APERTURA,'
      
        '  ESTRATEGIA_APERTURA_POSICIONADO = :ESTRATEGIA_APERTURA_POSICIO' +
        'NADO,'
      '  ESTRATEGIA_CIERRE = :ESTRATEGIA_CIERRE,'
      
        '  ESTRATEGIA_CIERRE_POSICIONADO = :ESTRATEGIA_CIERRE_POSICIONADO' +
        ','
      '  NOMBRE = :NOMBRE,'
      '  OID_ESTRATEGIA = :OID_ESTRATEGIA,'
      '  TIPO = :TIPO'
      'where'
      '  OID_ESTRATEGIA = :OLD_OID_ESTRATEGIA')
    InsertSQL.Strings = (
      'insert into ESTRATEGIA'
      
        '  (DESCRIPCION, ESTRATEGIA_APERTURA, ESTRATEGIA_APERTURA_POSICIO' +
        'NADO, ESTRATEGIA_CIERRE, '
      '   ESTRATEGIA_CIERRE_POSICIONADO, NOMBRE, OID_ESTRATEGIA, TIPO)'
      'values'
      
        '  (:DESCRIPCION, :ESTRATEGIA_APERTURA, :ESTRATEGIA_APERTURA_POSI' +
        'CIONADO, '
      
        '   :ESTRATEGIA_CIERRE, :ESTRATEGIA_CIERRE_POSICIONADO, :NOMBRE, ' +
        ':OID_ESTRATEGIA, '
      '   :TIPO)')
    DeleteSQL.Strings = (
      'delete from ESTRATEGIA'
      'where'
      '  OID_ESTRATEGIA = :OLD_OID_ESTRATEGIA')
    Left = 320
    Top = 104
  end
  object qEstudios: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select OID_ESTUDIO, OR_CUENTA from estudio'
      'where OR_ESTRATEGIA = :OID_ESTRATEGIA')
    Left = 200
    Top = 208
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_ESTRATEGIA'
        ParamType = ptUnknown
      end>
    object qEstudiosOID_ESTUDIO: TSmallintField
      FieldName = 'OID_ESTUDIO'
      Origin = '"ESTUDIO"."OID_ESTUDIO"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qEstudiosOR_CUENTA: TSmallintField
      FieldName = 'OR_CUENTA'
      Origin = '"ESTUDIO"."OR_CUENTA"'
    end
  end
end
