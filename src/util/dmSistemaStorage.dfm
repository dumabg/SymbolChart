object SistemaStorage: TSistemaStorage
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 259
  Width = 419
  object qSistema: TIBQuery
    Database = IBDatabaseUsuario
    Transaction = IBTransaction
    SQL.Strings = (
      'select * from sistema')
    UpdateObject = uSistema
    Left = 136
    Top = 120
    object qSistemaOID_SISTEMA: TIntegerField
      FieldName = 'OID_SISTEMA'
      Origin = '"SISTEMA"."OID_SISTEMA"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Visible = False
    end
    object qSistemaSECCION: TIBStringField
      FieldName = 'SECCION'
      Origin = '"SISTEMA"."SECCION"'
      Required = True
      Size = 30
    end
    object qSistemaNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = '"SISTEMA"."NOMBRE"'
      Required = True
      Size = 60
    end
    object qSistemaVALOR: TMemoField
      FieldName = 'VALOR'
      Origin = '"SISTEMA"."VALOR"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
  end
  object uSistema: TIBUpdateSQL
    RefreshSQL.Strings = (
      'Select '
      '  OID_SISTEMA,'
      '  SECCION,'
      '  NOMBRE,'
      '  VALOR'
      'from sistema '
      'where'
      '  OID_SISTEMA = :OID_SISTEMA')
    ModifySQL.Strings = (
      'update sistema'
      'set'
      '  NOMBRE = :NOMBRE,'
      '  OID_SISTEMA = :OID_SISTEMA,'
      '  SECCION = :SECCION,'
      '  VALOR = :VALOR'
      'where'
      '  OID_SISTEMA = :OLD_OID_SISTEMA')
    InsertSQL.Strings = (
      'insert into sistema'
      '  (OID_SISTEMA, NOMBRE, SECCION, VALOR)'
      'values'
      '  (:OID_SISTEMA, :NOMBRE, :SECCION, :VALOR)')
    DeleteSQL.Strings = (
      'delete from sistema'
      'where'
      '  OID_SISTEMA = :OLD_OID_SISTEMA')
    Left = 248
    Top = 120
  end
  object IBTransaction: TIBTransaction
    DefaultDatabase = IBDatabaseUsuario
    Left = 136
    Top = 32
  end
  object IBDatabaseUsuario: TIBDatabase
    DefaultTransaction = IBTransaction
    Left = 240
    Top = 32
  end
end
