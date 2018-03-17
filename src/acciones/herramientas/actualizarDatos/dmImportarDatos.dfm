object ImportarDatos: TImportarDatos
  OldCreateOrder = True
  Height = 255
  Width = 506
  object Modificaciones: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <>
    IndexName = 'ModificacionesIndex'
    IndexDefs = <
      item
        Name = 'ModificacionesIndex'
        Fields = 'OID_MODIFICACION'
      end>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    LoadedCompletely = False
    SavedCompletely = False
    FilterOptions = []
    Version = '5.60'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 176
    Top = 80
    object ModificacionesOID_MODIFICACION: TSmallintField
      DisplayWidth = 10
      FieldName = 'OID_MODIFICACION'
      Origin = '"MODIFICACION"."OID_MODIFICACION"'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
      Visible = False
    end
    object ModificacionesCOMENTARIO: TStringField
      DisplayWidth = 150
      FieldName = 'COMENTARIO'
      Origin = '"MODIFICACION"."COMENTARIO"'
      Size = 150
    end
    object ModificacionesSENTENCIAS: TMemoField
      FieldName = 'SENTENCIAS'
      Visible = False
      BlobType = ftMemo
    end
    object ModificacionesHECHO: TBooleanField
      FieldName = 'HECHO'
    end
    object ModificacionesTIPO: TStringField
      FieldName = 'TIPO'
      Visible = False
      Size = 1
    end
  end
end
