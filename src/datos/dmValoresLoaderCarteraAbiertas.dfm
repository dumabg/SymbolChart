inherited ValoresLoaderCarteraAbiertas: TValoresLoaderCarteraAbiertas
  OldCreateOrder = True
  inherited qValores: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select distinct(cm.OR_VALOR) as OID_VALOR'
      'from CARTERA ca, CUENTA C, CUENTA_MOVIMIENTOS CM where'
      'ca.OR_CUENTA = c.OID_CUENTA and C.OID_CUENTA = CM.OR_CUENTA and'
      'ca.OID_CARTERA = :OID_CARTERA and'
      'CM.TIPO='#39'C'#39' and (CM.OR_NUM_MOVIMIENTO is null)')
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_CARTERA'
        ParamType = ptUnknown
      end>
  end
end
