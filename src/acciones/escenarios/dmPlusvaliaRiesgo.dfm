object PlusvaliaRiesgo: TPlusvaliaRiesgo
  OldCreateOrder = False
  Height = 313
  Width = 415
  object Cotizacion: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'SELECT c.CIERRE FROM SESION s, COTIZACION c'
      'where'
      'c.OR_SESION = s.OID_SESION and'
      'c.OR_VALOR = :OID_VALOR and'
      '(not c.CIERRE is null)'
      'order by s.fecha')
    Left = 200
    Top = 88
    ParamData = <
      item
        DataType = ftSmallint
        Name = 'OID_VALOR'
        ParamType = ptUnknown
        Size = 2
      end>
    object CotizacionCIERRE: TIBBCDField
      DisplayLabel = 'Cierre'
      FieldName = 'CIERRE'
      Origin = '"COTIZACION"."CIERRE"'
      Precision = 9
      Size = 4
    end
  end
end
