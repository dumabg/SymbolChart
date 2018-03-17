object PanelEscenario: TPanelEscenario
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 261
  Width = 407
  object Cambios: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <>
    IndexDefs = <>
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
    AfterScroll = CambiosAfterScroll
    Left = 152
    Top = 56
    object CambiosFECHA: TDateField
      FieldName = 'FECHA'
      Origin = '"SESION"."FECHA"'
      Required = True
      DisplayFormat = 'dddd dd/mm/yy'
    end
    object CambiosCAMBIO: TIBBCDField
      FieldName = 'CAMBIO'
      Origin = '"COTIZACION"."CAMBIO"'
      currency = True
      Precision = 9
      Size = 4
    end
  end
end
