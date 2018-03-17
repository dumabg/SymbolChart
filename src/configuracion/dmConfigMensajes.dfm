object ConfigMensajes: TConfigMensajes
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 308
  Width = 384
  object TipoMensajes: TIBQuery
    Database = BD.IBDatabaseComun
    Transaction = BD.IBTransactionComun
    SQL.Strings = (
      'select * from TIPO_MENSAJE'
      'order by POSICION desc'
      ' ')
    UniDirectional = True
    Left = 160
    Top = 80
    object TipoMensajesOID_TIPO_MENSAJE: TSmallintField
      FieldName = 'OID_TIPO_MENSAJE'
      Origin = 'TIPO_MENSAJE.OID_TIPO_MENSAJE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object TipoMensajesDESCRIPCION: TIBStringField
      FieldName = 'DESCRIPCION'
      Origin = 'TIPO_MENSAJE.DESCRIPCION'
      Required = True
      Size = 30
    end
    object TipoMensajesPOSICION: TSmallintField
      FieldName = 'POSICION'
      Origin = '"TIPO_MENSAJE"."POSICION"'
      Required = True
    end
    object TipoMensajesCAMPO: TIBStringField
      FieldName = 'CAMPO'
      Origin = '"TIPO_MENSAJE"."CAMPO"'
      Size = 30
    end
  end
end
