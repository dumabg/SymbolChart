object dComentario: TdComentario
  OldCreateOrder = False
  Height = 256
  Width = 321
  object EstadoAyer: TIBQuery
    Database = BD.IBDatabaseDatos
    Transaction = BD.IBTransactionDatos
    SQL.Strings = (
      'select DINERO, PAPEL from COTIZACION_ESTADO'
      'where OR_COTIZACION = :OID_COTIZACION')
    Left = 144
    Top = 48
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_COTIZACION'
        ParamType = ptUnknown
      end>
    object EstadoAyerDINERO: TIBBCDField
      FieldName = 'DINERO'
      Origin = 'ESTADO.DINERO'
      Required = True
      Precision = 9
      Size = 2
    end
    object EstadoAyerPAPEL: TIBBCDField
      FieldName = 'PAPEL'
      Origin = 'ESTADO.PAPEL'
      Required = True
      Precision = 9
      Size = 2
    end
  end
  object doCotizacion: TDataSetObserver
    DataSource = Data.dsCotizacion
    BufferCount = 640
    Left = 144
    Top = 136
  end
end
