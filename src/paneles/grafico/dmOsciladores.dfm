inherited Osciladores: TOsciladores
  OldCreateOrder = False
  Height = 370
  Width = 492
  object qOscilador: TIBQuery
    Database = BD.IBDatabaseUsuario
    Transaction = BD.IBTransactionUsuario
    SQL.Strings = (
      'select * from OSCILADOR'
      'where'
      'OR_FS=:OID_FS')
    UpdateObject = uOscilador
    Left = 128
    Top = 232
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'OID_FS'
        ParamType = ptUnknown
      end>
    object qOsciladorOR_FS: TIntegerField
      FieldName = 'OR_FS'
      Origin = '"OSCILADOR"."OR_FS"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qOsciladorCODIGO: TMemoField
      FieldName = 'CODIGO'
      Origin = '"OSCILADOR"."CODIGO"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qOsciladorCODIGO_COMPILED: TMemoField
      FieldName = 'CODIGO_COMPILED'
      Origin = '"OSCILADOR"."CODIGO_COMPILED"'
      ProviderFlags = [pfInUpdate]
      BlobType = ftMemo
      Size = 8
    end
    object qOsciladorCOLOR: TIntegerField
      FieldName = 'COLOR'
      Origin = '"OSCILADOR"."COLOR"'
      Required = True
    end
  end
  object uOscilador: TIBUpdateSQL
    RefreshSQL.Strings = (
      'Select '
      '  OR_FS,'
      '  CODIGO,'
      '  CODIGO_COMPILED,'
      '  COLOR'
      'from OSCILADOR '
      'where'
      '  OR_FS = :OR_FS')
    ModifySQL.Strings = (
      'update OSCILADOR'
      'set'
      '  CODIGO = :CODIGO,'
      '  CODIGO_COMPILED = :CODIGO_COMPILED,'
      '  COLOR = :COLOR'
      'where'
      '  OR_FS = :OLD_OR_FS')
    InsertSQL.Strings = (
      'insert into OSCILADOR'
      '  (CODIGO, CODIGO_COMPILED, COLOR, OR_FS)'
      'values'
      '  (:CODIGO, :CODIGO_COMPILED, :COLOR, :OR_FS)')
    DeleteSQL.Strings = (
      'delete from OSCILADOR'
      'where'
      '  OR_FS = :OLD_OR_FS')
    Left = 232
    Top = 232
  end
  object iOscilador: TIBSQL
    Database = BD.IBDatabaseUsuario
    SQL.Strings = (
      'insert into OSCILADOR'
      '  (COLOR, OR_FS)'
      'values'
      '  (:COLOR, :OR_FS)')
    Transaction = BD.IBTransactionUsuario
    Left = 328
    Top = 232
  end
end
