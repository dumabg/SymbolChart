object CrearEstudio: TCrearEstudio
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 377
  Width = 545
  object qSesiones: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select FECHA from sesion'
      'where FECHA>=:DESDE and FECHA<=:HASTA'
      'order by FECHA')
    Left = 248
    Top = 72
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
  object qMensajes: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    CachedUpdates = True
    SQL.Strings = (
      'select * from ESTUDIO_MENSAJE'
      'where OR_ESTUDIO = :OID_ESTUDIO'
      'order by POSICION desc')
    UpdateObject = uMensajes
    Left = 232
    Top = 176
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
    Left = 304
    Top = 176
  end
  object Valores: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 6
    FieldDefs = <
      item
        Name = 'OID_VALOR'
        Attributes = [faRequired]
        DataType = ftSmallint
      end
      item
        Name = 'OID_MERCADO'
        DataType = ftSmallint
      end
      item
        Name = 'NOMBRE'
        Attributes = [faRequired]
        DataType = ftString
        Size = 50
      end
      item
        Name = 'SIMBOLO'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'DECIMALES'
        DataType = ftSmallint
      end
      item
        Name = 'MERCADO'
        Attributes = [faRequired]
        DataType = ftString
        Size = 20
      end>
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
    Left = 232
    Top = 280
    object ValoresOID_VALOR: TSmallintField
      FieldName = 'OID_VALOR'
      Origin = '"VALOR"."OID_VALOR"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ValoresOID_MERCADO: TSmallintField
      FieldName = 'OID_MERCADO'
      Origin = '"VALOR"."OR_MERCADO"'
    end
    object ValoresNOMBRE: TIBStringField
      FieldName = 'NOMBRE'
      Origin = '"VALOR"."NOMBRE"'
      Required = True
      Size = 50
    end
    object ValoresSIMBOLO: TIBStringField
      FieldName = 'SIMBOLO'
      Origin = '"VALOR"."SIMBOLO"'
    end
    object ValoresDECIMALES: TSmallintField
      FieldName = 'DECIMALES'
      Origin = '"MERCADO"."DECIMALES"'
    end
    object ValoresMERCADO: TIBStringField
      FieldName = 'MERCADO'
      Origin = '"MERCADO"."PAIS"'
      Required = True
    end
  end
end
