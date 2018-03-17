object Correo: TCorreo
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 283
  Width = 425
  object qCorreo: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select * from CORREO'
      'order by FECHA_HORA desc')
    UpdateObject = uCorreo
    Left = 152
    Top = 64
    object qCorreoOID_CORREO: TIntegerField
      FieldName = 'OID_CORREO'
      Origin = '"CORREO"."OID_CORREO"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Visible = False
    end
    object qCorreoFECHA_HORA: TDateTimeField
      DisplayLabel = 'Fecha Hora'
      FieldName = 'FECHA_HORA'
      Origin = '"CORREO"."FECHA_HORA"'
      Required = True
    end
    object qCorreoTITULO: TIBStringField
      DisplayLabel = 'T'#237'tulo'
      FieldName = 'TITULO'
      Origin = '"CORREO"."TITULO"'
      Required = True
      Size = 100
    end
    object qCorreoMENSAJE: TMemoField
      DisplayLabel = 'Mensaje'
      FieldName = 'MENSAJE'
      Origin = '"CORREO"."MENSAJE"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
  end
  object uCorreo: TIBUpdateSQL
    RefreshSQL.Strings = (
      'Select '
      '  OID_CORREO,'
      '  FECHA_HORA,'
      '  TITULO,'
      '  MENSAJE'
      'from CORREO '
      'where'
      '  OID_CORREO = :OID_CORREO')
    ModifySQL.Strings = (
      'update CORREO'
      'set'
      '  FECHA_HORA = :FECHA_HORA,'
      '  MENSAJE = :MENSAJE,'
      '  OID_CORREO = :OID_CORREO,'
      '  TITULO = :TITULO'
      'where'
      '  OID_CORREO = :OLD_OID_CORREO')
    InsertSQL.Strings = (
      'insert into CORREO'
      '  (FECHA_HORA, MENSAJE, OID_CORREO, TITULO)'
      'values'
      '  (:FECHA_HORA, :MENSAJE, :OID_CORREO, :TITULO)')
    DeleteSQL.Strings = (
      'delete from CORREO'
      'where'
      '  OID_CORREO = :OLD_OID_CORREO')
    Left = 240
    Top = 64
  end
end
