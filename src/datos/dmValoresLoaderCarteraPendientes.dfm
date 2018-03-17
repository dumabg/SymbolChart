inherited ValoresLoaderCarteraPendientes: TValoresLoaderCarteraPendientes
  OldCreateOrder = True
  inherited qValores: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      
        'select distinct(bp.OR_VALOR) as OID_VALOR from BROKER_POSICIONES' +
        ' bp, CARTERA c where'
      'c.OID_CARTERA = :OID_CARTERA and c.OR_CUENTA = bp.OR_CUENTA and'
      'bp.ESTADO = '#39'B'#39' ')
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_CARTERA'
        ParamType = ptUnknown
      end>
  end
end
