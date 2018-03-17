inherited ValoresLoaderTodos: TValoresLoaderTodos
  OldCreateOrder = True
  inherited qValores: TIBQuery
    SQL.Strings = (
      'select OID_VALOR from VALOR'
      ''
      '')
  end
end
