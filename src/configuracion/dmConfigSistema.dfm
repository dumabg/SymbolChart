object ConfigSistema: TConfigSistema
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 231
  Width = 333
  object qSistema: TIBQuery
    Database = BD.IBDatabaseComun
    Transaction = BD.IBTransactionComun
    SQL.Strings = (
      'select * from sistema')
    UpdateObject = uSistema
    Left = 104
    Top = 72
    object qSistemaOID_SISTEMA: TIntegerField
      FieldName = 'OID_SISTEMA'
      Origin = '"SISTEMA"."OID_SISTEMA"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qSistemaSECCION: TIBStringField
      DisplayWidth = 50
      FieldName = 'SECCION'
      Origin = 'SISTEMA.SECCION'
      Required = True
      Size = 30
    end
    object qSistemaNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = 'SISTEMA.NOMBRE'
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
      '  (NOMBRE, OID_SISTEMA, SECCION, VALOR)'
      'values'
      '  (:NOMBRE, :OID_SISTEMA, :SECCION, :VALOR)')
    DeleteSQL.Strings = (
      'delete from sistema'
      'where'
      '  OID_SISTEMA = :OLD_OID_SISTEMA')
    Left = 184
    Top = 72
  end
end
