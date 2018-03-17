inherited Tareas: TTareas
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  object kbmTareas: TkbmMemTable
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
    Left = 120
    Top = 72
    object kbmTareasID: TIntegerField
      DisplayLabel = 'Id'
      FieldName = 'ID'
      Visible = False
    end
    object kbmTareasTIPO: TStringField
      DisplayLabel = 'Tipo'
      FieldName = 'TIPO'
      Size = 15
    end
    object kbmTareasDESCRIPCION: TStringField
      DisplayLabel = 'Descripci'#243'n'
      FieldName = 'DESCRIPCION'
      Size = 60
    end
    object kbmTareasPERCENT: TIntegerField
      DisplayLabel = '% realizado'
      FieldName = 'PERCENT'
      OnGetText = kbmTareasPERCENTGetText
    end
    object kbmTareasESTADO: TIntegerField
      DisplayLabel = 'Estado'
      FieldName = 'ESTADO'
      OnGetText = kbmTareasESTADOGetText
    end
    object kbmTareasPRIORIDAD: TIntegerField
      DisplayLabel = 'Prioridad'
      FieldName = 'PRIORIDAD'
      OnGetText = kbmTareasPRIORIDADGetText
    end
  end
end
