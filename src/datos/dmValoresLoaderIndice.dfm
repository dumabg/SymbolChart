inherited ValoresLoaderIndice: TValoresLoaderIndice
  OldCreateOrder = True
  inherited qValores: TIBQuery
    SQL.Strings = (
      'select OR_VALOR as OID_VALOR from INDICE_VALOR'
      'where OR_INDICE = :OID_INDICE')
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_INDICE'
        ParamType = ptUnknown
      end>
  end
end
