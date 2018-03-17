inherited EstadoValoresFactory: TEstadoValoresFactory
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Height = 198
  Width = 225
  object Valores: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      
        'select c.*, ce.* from COTIZACION c, COTIZACION_ESTADO ce, SESION' +
        ' s where'
      'c.OR_SESION = s.OID_SESION and'
      'c.OID_COTIZACION = ce.OR_COTIZACION and'
      's.OID_SESION = :OID_SESION')
    Left = 96
    Top = 80
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_SESION'
        ParamType = ptUnknown
      end>
  end
end
