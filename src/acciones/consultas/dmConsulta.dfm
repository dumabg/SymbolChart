object Consulta: TConsulta
  OldCreateOrder = False
  Height = 356
  Width = 442
  object qColumnas: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select * from CONSULTA_COLUMNA'
      'where OR_CONSULTA = :OID_CONSULTA'
      'order by POSICION')
    Left = 88
    Top = 200
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_CONSULTA'
        ParamType = ptUnknown
      end>
    object qColumnasOR_CONSULTA: TIntegerField
      FieldName = 'OR_CONSULTA'
      Origin = '"CONSULTA_COLUMNA"."OR_CONSULTA"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qColumnasPOSICION: TSmallintField
      FieldName = 'POSICION'
      Origin = '"CONSULTA_COLUMNA"."POSICION"'
      Required = True
    end
    object qColumnasNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = '"CONSULTA_COLUMNA"."NOMBRE"'
      Required = True
      Size = 30
    end
    object qColumnasTIPO: TSmallintField
      FieldName = 'TIPO'
      Origin = '"CONSULTA_COLUMNA"."TIPO"'
    end
    object qColumnasCODIGO: TMemoField
      FieldName = 'CODIGO'
      Origin = '"CONSULTA_COLUMNA"."CODIGO"'
      ProviderFlags = [pfInUpdate]
      Required = True
      BlobType = ftMemo
      Size = 8
    end
    object qColumnasANCHO: TSmallintField
      FieldName = 'ANCHO'
      Origin = '"CONSULTA_COLUMNA"."ANCHO"'
    end
    object qColumnasCODIGO_COMPILED: TMemoField
      FieldName = 'CODIGO_COMPILED'
      Origin = '"CONSULTA_COLUMNA"."CODIGO_COMPILED"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
  end
  object Consulta: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <>
    IndexDefs = <>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    Version = '5.60'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    AfterInsert = ConsultaAfterInsert
    Left = 128
    Top = 48
    object ConsultaOID_VALOR: TIntegerField
      FieldName = 'OID_VALOR'
      Visible = False
    end
    object ConsultaSIMBOLO: TStringField
      DisplayLabel = 'S'#237'mbolo'
      DisplayWidth = 60
      FieldName = 'SIMBOLO'
    end
    object ConsultaNOMBRE: TStringField
      DisplayLabel = 'Nombre'
      DisplayWidth = 180
      FieldName = 'NOMBRE'
      Size = 50
    end
  end
  object qCaracteristica: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select ca.CODIGO from CONSULTA c, CARACTERISTICA ca'
      'where c.OR_FS = :OID_CONSULTA and'
      'c.OR_CARACTERISTICA = ca.OR_CARACTERISTICA_FS')
    Left = 200
    Top = 192
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_CONSULTA'
        ParamType = ptUnknown
      end>
    object qCaracteristicaCODIGO: TMemoField
      FieldName = 'CODIGO'
      Origin = '"CARACTERISTICA"."CODIGO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
  end
  object qConsulta: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select c.*,fs.NOMBRE  from CONSULTA c, CONSULTA_FS fs'
      'where c.OR_FS = :OID_CONSULTA and'
      'c.OR_FS = fs.OID_FS'
      '')
    Left = 128
    Top = 120
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_CONSULTA'
        ParamType = ptUnknown
      end>
    object qConsultaOR_FS: TIntegerField
      FieldName = 'OR_FS'
      Origin = '"CONSULTA"."OR_FS"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qConsultaTIPO: TIBStringField
      FieldName = 'TIPO'
      Origin = '"CONSULTA"."TIPO"'
      Required = True
      FixedChar = True
      Size = 1
    end
    object qConsultaOR_CARACTERISTICA: TIntegerField
      FieldName = 'OR_CARACTERISTICA'
      Origin = '"CONSULTA"."OR_CARACTERISTICA"'
    end
    object qConsultaCODIGO: TMemoField
      FieldName = 'CODIGO'
      Origin = '"CONSULTA"."CODIGO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qConsultaCOLUMNA_SIMBOLO: TIBStringField
      FieldName = 'COLUMNA_SIMBOLO'
      Origin = '"CONSULTA"."COLUMNA_SIMBOLO"'
      FixedChar = True
      Size = 1
    end
    object qConsultaCOLUMNA_NOMBRE: TIBStringField
      FieldName = 'COLUMNA_NOMBRE'
      Origin = '"CONSULTA"."COLUMNA_NOMBRE"'
      FixedChar = True
      Size = 1
    end
    object qConsultaCODIGO_COMPILED: TMemoField
      FieldName = 'CODIGO_COMPILED'
      Origin = '"CONSULTA"."CODIGO_COMPILED"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qConsultaCONTAR_VALORES: TIBStringField
      FieldName = 'CONTAR_VALORES'
      Origin = '"CONSULTA"."CONTAR_VALORES"'
      FixedChar = True
      Size = 1
    end
    object qConsultaNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = '"CONSULTA_FS"."NOMBRE"'
      Required = True
      Size = 50
    end
  end
  object qValoresSesion: TIBSQL
    Database = BD.IBDatabaseDatos
    SQL.Strings = (
      'select OR_VALOR from cotizacion'
      'where OR_SESION = :OID_SESION and not CIERRE is null')
    Transaction = BD.IBTransactionDatos
    Left = 344
    Top = 128
  end
end
