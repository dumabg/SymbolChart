inherited ValoresLoaderPais: TValoresLoaderPais
  OldCreateOrder = True
  inherited qValores: TIBQuery
    SQL.Strings = (
      'select v.* from valor v, mercado m'
      'where '
      'v.or_mercado = m.oid_mercado and'
      'm.pais = :PAIS'
      '')
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'PAIS'
        ParamType = ptUnknown
      end>
  end
end
