object Estadistica: TEstadistica
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 285
  Width = 387
  object qData: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select c.VARIACION, ce.DINERO, ce.PAPEL, ce.ZONA, cm.FLAGS '
      'from cotizacion c, cotizacion_estado ce, cotizacion_mensaje cm'
      'where'
      'c.oid_cotizacion = ce.or_cotizacion and'
      'c.oid_cotizacion = cm.or_cotizacion and'
      'c.or_valor = :OID_VALOR')
    Left = 168
    Top = 64
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_VALOR'
        ParamType = ptUnknown
      end>
    object qDataDINERO: TIBBCDField
      FieldName = 'DINERO'
      Origin = '"COTIZACION_ESTADO"."DINERO"'
      Precision = 9
      Size = 2
    end
    object qDataPAPEL: TIBBCDField
      FieldName = 'PAPEL'
      Origin = '"COTIZACION_ESTADO"."PAPEL"'
      Precision = 9
      Size = 2
    end
    object qDataZONA: TIBStringField
      FieldName = 'ZONA'
      Origin = '"COTIZACION_ESTADO"."ZONA"'
      FixedChar = True
      Size = 1
    end
    object qDataVARIACION: TIBBCDField
      FieldName = 'VARIACION'
      Origin = '"COTIZACION"."VARIACION"'
      Precision = 9
      Size = 2
    end
    object qDataFLAGS: TIntegerField
      FieldName = 'FLAGS'
      Origin = '"COTIZACION_MENSAJE"."FLAGS"'
    end
  end
end
