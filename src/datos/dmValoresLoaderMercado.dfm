inherited ValoresLoaderMercado: TValoresLoaderMercado
  OldCreateOrder = True
  inherited qValores: TIBQuery
    SQL.Strings = (
      'select OID_VALOR from VALOR'
      'where OR_MERCADO = :OID_MERCADO'
      '')
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_MERCADO'
        ParamType = ptUnknown
      end>
  end
end
