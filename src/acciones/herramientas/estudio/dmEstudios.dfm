inherited Estudios: TEstudios
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 487
  Width = 638
  inherited dFS: TIBSQL
    Left = 256
  end
  object qSesiones: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select FECHA from sesion'
      'where FECHA>=:DESDE and FECHA<=:HASTA'
      'order by FECHA')
    Left = 376
    Top = 200
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DESDE'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'HASTA'
        ParamType = ptUnknown
      end>
    object qSesionesFECHA: TDateField
      FieldName = 'FECHA'
      Origin = '"SESION"."FECHA"'
      Required = True
    end
  end
  object dCuenta: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'delete from CUENTA'
      'where '
      'OID_CUENTA = :OID_CUENTA')
    Transaction = BD.IBTransactionUsuario
    Left = 368
    Top = 128
  end
  object dsEstudio: TDataSource
    Left = 176
    Top = 128
  end
  object qMensajes: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    CachedUpdates = True
    SQL.Strings = (
      'select * from ESTUDIO_MENSAJE'
      'where OR_ESTUDIO = :OID_ESTUDIO'
      'order by POSICION desc')
    Left = 176
    Top = 256
    ParamData = <
      item
        DataType = ftSmallint
        Name = 'OID_ESTUDIO'
        ParamType = ptUnknown
        Size = 2
      end>
    object qMensajesOR_ESTUDIO: TIntegerField
      FieldName = 'OR_ESTUDIO'
      Origin = '"ESTUDIO_MENSAJE"."OR_ESTUDIO"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Visible = False
    end
    object qMensajesMENSAJE: TMemoField
      DisplayLabel = 'Mensaje'
      DisplayWidth = 140
      FieldName = 'MENSAJE'
      Origin = '"ESTUDIO_MENSAJE"."MENSAJE"'
      ProviderFlags = [pfInUpdate]
      Required = True
      BlobType = ftMemo
      Size = 8
    end
    object qMensajesPOSICION: TIntegerField
      FieldName = 'POSICION'
      Origin = '"ESTUDIO_MENSAJE"."POSICION"'
      Required = True
      Visible = False
    end
  end
  object uMensajes: TIBUpdateSQL
    RefreshSQL.Strings = (
      'Select '
      '  OR_ESTUDIO,'
      '  POSICION,'
      '  MENSAJE'
      'from ESTUDIO_MENSAJE '
      'where'
      '  OR_ESTUDIO = :OR_ESTUDIO and'
      '  POSICION = :POSICION')
    ModifySQL.Strings = (
      'update ESTUDIO_MENSAJE'
      'set'
      '  MENSAJE = :MENSAJE,'
      '  OR_ESTUDIO = :OR_ESTUDIO,'
      '  POSICION = :POSICION'
      'where'
      '  OR_ESTUDIO = :OLD_OR_ESTUDIO and'
      '  POSICION = :OLD_POSICION')
    InsertSQL.Strings = (
      'insert into ESTUDIO_MENSAJE'
      '  (MENSAJE, OR_ESTUDIO, POSICION)'
      'values'
      '  (:MENSAJE, :OR_ESTUDIO, :POSICION)')
    DeleteSQL.Strings = (
      'delete from ESTUDIO_MENSAJE'
      'where'
      '  OR_ESTUDIO = :OLD_OR_ESTUDIO and'
      '  POSICION = :OLD_POSICION')
    Left = 256
    Top = 256
  end
  object qEstudio: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select e.*, es.NOMBRE as NOMBRE_ESTRATEGIA,'
      'es.DESCRIPCION as DESCRIPCION_ESTRATEGIA, '
      'es.ESTRATEGIA_APERTURA, es.ESTRATEGIA_CIERRE'
      'from ESTUDIO e,  ESTRATEGIA es, CUENTA c'
      'where'
      'e.OR_ESTRATEGIA = es.OID_ESTRATEGIA and'
      'e.OR_CUENTA = c.OID_CUENTA and'
      'e.OID_ESTUDIO=:OID_ESTUDIO'
      '')
    Left = 360
    Top = 344
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_ESTUDIO'
        ParamType = ptUnknown
      end>
    object qEstudioOID_ESTUDIO: TSmallintField
      FieldName = 'OID_ESTUDIO'
      Origin = '"ESTUDIO"."OID_ESTUDIO"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qEstudioOR_CUENTA: TSmallintField
      FieldName = 'OR_CUENTA'
      Origin = '"ESTUDIO"."OR_CUENTA"'
    end
    object qEstudioOR_ESTRATEGIA: TSmallintField
      FieldName = 'OR_ESTRATEGIA'
      Origin = '"ESTUDIO"."OR_ESTRATEGIA"'
      Required = True
    end
    object qEstudioNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = '"ESTUDIO"."NOMBRE"'
      Size = 30
    end
    object qEstudioDESDE: TDateField
      FieldName = 'DESDE'
      Origin = '"ESTUDIO"."DESDE"'
      Required = True
    end
    object qEstudioHASTA: TDateField
      FieldName = 'HASTA'
      Origin = '"ESTUDIO"."HASTA"'
      Required = True
    end
    object qEstudioCAPITAL: TIntegerField
      FieldName = 'CAPITAL'
      Origin = '"ESTUDIO"."CAPITAL"'
      Required = True
    end
    object qEstudioPAQUETES: TIntegerField
      FieldName = 'PAQUETES'
      Origin = '"ESTUDIO"."PAQUETES"'
      Required = True
    end
    object qEstudioUSA100: TIBStringField
      FieldName = 'USA100'
      Origin = '"ESTUDIO"."USA100"'
      Required = True
      FixedChar = True
      Size = 1
    end
    object qEstudioGRUPO: TIBStringField
      FieldName = 'GRUPO'
      Origin = '"ESTUDIO"."GRUPO"'
      Required = True
      Size = 30
    end
    object qEstudioNOMBRE_ESTRATEGIA: TIBStringField
      FieldName = 'NOMBRE_ESTRATEGIA'
      Origin = '"ESTRATEGIA"."NOMBRE"'
      Required = True
      Size = 30
    end
    object qEstudioDESCRIPCION_ESTRATEGIA: TMemoField
      FieldName = 'DESCRIPCION_ESTRATEGIA'
      Origin = '"ESTRATEGIA"."DESCRIPCION"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qEstudioESTRATEGIA_APERTURA: TMemoField
      FieldName = 'ESTRATEGIA_APERTURA'
      Origin = '"ESTRATEGIA"."ESTRATEGIA_APERTURA"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qEstudioESTRATEGIA_CIERRE: TMemoField
      FieldName = 'ESTRATEGIA_CIERRE'
      Origin = '"ESTRATEGIA"."ESTRATEGIA_CIERRE"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qEstudioDESCRIPCION: TStringField
      FieldName = 'DESCRIPCION'
      Size = 300
    end
  end
end
