inherited Consultas: TConsultas
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 437
  Width = 544
  object qConsulta: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'SELECT '
      '  C.*,'
      '  CFS.NOMBRE AS CARACTERISTICA'
      'FROM'
      '  CONSULTA C'
      
        '  LEFT OUTER JOIN CARACTERISTICA_FS CFS ON (C.OR_CARACTERISTICA ' +
        '= CFS.OID_FS)'
      'WHERE'
      '  (C.OR_FS = :OID_FS)')
    Left = 80
    Top = 224
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_FS'
        ParamType = ptUnknown
      end>
    object qConsultaOR_FS: TIntegerField
      FieldName = 'OR_FS'
      Origin = '"CONSULTA"."OR_FS"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qConsultaOR_CARACTERISTICA: TIntegerField
      FieldName = 'OR_CARACTERISTICA'
      Origin = '"CONSULTA"."OR_CARACTERISTICA"'
    end
    object qConsultaCARACTERISTICA: TIBStringField
      FieldName = 'CARACTERISTICA'
      Origin = '"FS"."NOMBRE"'
      Required = True
      Size = 50
    end
    object qConsultaTIPO: TIBStringField
      FieldName = 'TIPO'
      Origin = '"CONSULTA"."TIPO"'
      Required = True
      FixedChar = True
      Size = 1
    end
    object qConsultaCODIGO: TMemoField
      FieldName = 'CODIGO'
      Origin = '"CONSULTA"."CODIGO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qConsultaCODIGO_COMPILED: TMemoField
      FieldName = 'CODIGO_COMPILED'
      Origin = '"CONSULTA"."CODIGO_COMPILED"'
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
    object qConsultaCONTAR_VALORES: TIBStringField
      FieldName = 'CONTAR_VALORES'
      Origin = '"CONSULTA"."CONTAR_VALORES"'
      FixedChar = True
      Size = 1
    end
  end
  object uiConsulta: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'UPDATE OR INSERT INTO CONSULTA'
      
        ' (OR_FS, TIPO, OR_CARACTERISTICA, CODIGO, COLUMNA_SIMBOLO, COLUM' +
        'NA_NOMBRE, CONTAR_VALORES)'
      'values'
      
        ' (:OR_FS, :TIPO, :OR_CARACTERISTICA, :CODIGO, :COLUMNA_SIMBOLO, ' +
        ':COLUMNA_NOMBRE, :CONTAR_VALORES)')
    Transaction = BD.IBTransactionUsuario
    Left = 88
    Top = 296
  end
  object iConsultaColumna: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'INSERT INTO CONSULTA_COLUMNA'
      
        ' (OR_CONSULTA, POSICION, NOMBRE, TIPO, CODIGO, CODIGO_COMPILED, ' +
        'ANCHO)'
      'values'
      
        ' (:OR_CONSULTA, :POSICION, :NOMBRE, :TIPO, :CODIGO, :CODIGO_COMP' +
        'ILED, :ANCHO)')
    Transaction = BD.IBTransactionUsuario
    Left = 192
    Top = 296
  end
  object dConsultaColumnas: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'delete from CONSULTA_COLUMNA'
      'where'
      '  OR_CONSULTA = :OID_CONSULTA')
    Transaction = BD.IBTransactionUsuario
    Left = 296
    Top = 296
  end
  object qColumnas: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select * from CONSULTA_COLUMNA'
      'where OR_CONSULTA = :OID_CONSULTA'
      'order by POSICION')
    Left = 296
    Top = 216
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
    object qColumnasCODIGO_COMPILED: TMemoField
      FieldName = 'CODIGO_COMPILED'
      Origin = '"CONSULTA_COLUMNA"."CODIGO_COMPILED"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qColumnasANCHO: TSmallintField
      FieldName = 'ANCHO'
      Origin = '"CONSULTA_COLUMNA"."ANCHO"'
    end
  end
  object uConsultaCodigoCompiled: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'UPDATE CONSULTA'
      'set'
      ' CODIGO_COMPILED=:CODIGO_COMPILED'
      'where'
      ' OR_FS=:OID_FS')
    Transaction = BD.IBTransactionUsuario
    Left = 88
    Top = 352
  end
  object qConsultasMenu: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'SELECT OR_FS, CONTAR_VALORES, CODIGO_COMPILED from CONSULTA')
    Left = 296
    Top = 32
    object qConsultasMenuOR_FS: TIntegerField
      FieldName = 'OR_FS'
      Origin = '"CONSULTA"."OR_FS"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qConsultasMenuCONTAR_VALORES: TIBStringField
      FieldName = 'CONTAR_VALORES'
      Origin = '"CONSULTA"."CONTAR_VALORES"'
      FixedChar = True
      Size = 1
    end
    object qConsultasMenuCODIGO_COMPILED: TMemoField
      FieldName = 'CODIGO_COMPILED'
      Origin = '"CONSULTA"."CODIGO_COMPILED"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
  end
end
