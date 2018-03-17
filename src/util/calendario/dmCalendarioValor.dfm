inherited CalendarioValor: TCalendarioValor
  Height = 295
  Width = 358
  inherited qMaxDate: TIBQuery
    SQL.Strings = (
      'select max(FECHA) as FECHA from SESION s, COTIZACION c'
      'where'
      'c.OR_SESION = s.OID_SESION and'
      'c.OR_VALOR = :OID_VALOR')
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_VALOR'
        ParamType = ptUnknown
      end>
  end
  inherited qMinDate: TIBQuery
    SQL.Strings = (
      'select FECHA from SESION s, COTIZACION c'
      'where'
      's.OID_SESION = c.OR_SESION and'
      'c.OR_VALOR = :OID_VALOR'
      'order by FECHA desc')
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_VALOR'
        ParamType = ptUnknown
      end>
  end
  inherited qDias: TIBQuery
    SQL.Strings = (
      'select s.FECHA from SESION s, COTIZACION c'
      'where s.FECHA>=:FECHA1 and s.FECHA<:FECHA2 and '
      'c.OR_SESION = s.OID_SESION and '
      'c.OR_VALOR=:OID_VALOR')
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'FECHA1'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'FECHA2'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'OID_VALOR'
        ParamType = ptUnknown
      end>
  end
end
