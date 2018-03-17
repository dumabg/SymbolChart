inherited ConsultasMenuData: TConsultasMenuData
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Height = 289
  Width = 457
  object qConsulta: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select OR_FS, CODIGO_COMPILED from CONSULTA'
      'where CONTAR_VALORES = '#39'S'#39)
    Left = 88
    Top = 56
    object qConsultaOR_FS: TIntegerField
      FieldName = 'OR_FS'
      Origin = '"CONSULTA"."OR_FS"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qConsultaCODIGO_COMPILED: TMemoField
      FieldName = 'CODIGO_COMPILED'
      Origin = '"CONSULTA"."CODIGO_COMPILED"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
  end
end
