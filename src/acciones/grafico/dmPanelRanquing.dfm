inherited PanelRanquing: TPanelRanquing
  OldCreateOrder = True
  Height = 335
  Width = 455
  object qRanquing: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      
        'select ce.DINERO, ce.PAPEL, s.FECHA from cotizacion c, cotizacio' +
        'n_estado ce, sesion s'
      'where'
      'c.oid_cotizacion = ce.or_cotizacion and'
      'c.or_sesion = s.oid_sesion and'
      'c.OR_VALOR = :OID_VALOR'
      'order by s.FECHA')
    Left = 256
    Top = 136
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_VALOR'
        ParamType = ptUnknown
      end>
    object qRanquingDINERO: TIBBCDField
      FieldName = 'DINERO'
      Origin = '"COTIZACION_ESTADO"."DINERO"'
      Precision = 9
      Size = 2
    end
    object qRanquingPAPEL: TIBBCDField
      FieldName = 'PAPEL'
      Origin = '"COTIZACION_ESTADO"."PAPEL"'
      Precision = 9
      Size = 2
    end
    object qRanquingFECHA: TDateField
      FieldName = 'FECHA'
      Origin = '"SESION"."FECHA"'
      Required = True
    end
  end
end
