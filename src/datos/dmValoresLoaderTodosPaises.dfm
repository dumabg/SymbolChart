inherited ValoresLoaderTodosPaises: TValoresLoaderTodosPaises
  OldCreateOrder = True
  inherited qValores: TIBQuery
    SQL.Strings = (
      'select OID_VALOR from VALOR'
      'where OR_MERCADO <= 10'
      '')
  end
end
