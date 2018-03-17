object Ranquing: TRanquing
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 310
  Width = 566
  object qData: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select c.OR_VALOR, ce.DINERO, ce.PAPEL '
      
        'from cotizacion c, cotizacion_estado ce, sesion s, valor_activo ' +
        'va'
      'where'
      'c.oid_cotizacion = ce.or_cotizacion and'
      'c.or_sesion = s.oid_sesion and'
      's.fecha = :FECHA and'
      'c.or_valor = va.or_valor')
    Left = 240
    Top = 80
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'FECHA'
        ParamType = ptUnknown
      end>
    object qDataOR_VALOR: TSmallintField
      FieldName = 'OR_VALOR'
      Origin = '"COTIZACION"."OR_VALOR"'
      Required = True
    end
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
  end
  object qSesionAnt: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'SELECT first 1 FECHA FROM SESION'
      'where FECHA < :FECHA'
      'order by FECHA desc')
    Left = 240
    Top = 152
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'FECHA'
        ParamType = ptUnknown
      end>
    object qSesionAntFECHA: TDateField
      FieldName = 'FECHA'
      Origin = '"SESION"."FECHA"'
      Required = True
    end
  end
end
