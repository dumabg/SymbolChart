object Acciones: TAcciones
  Left = 0
  Top = 0
  Width = 341
  Height = 164
  TabOrder = 0
  object ToolbarMenu: TSpTBXToolbar
    Left = 40
    Top = 16
    Width = 23
    Height = 22
    BorderStyle = bsNone
    CloseButton = False
    Images = ImageList
    ProcessShortCuts = True
    ShrinkMode = tbsmWrap
    TabOrder = 0
    Customizable = False
    MenuBar = True
  end
  object Toolbar: TSpTBXToolbar
    Left = 40
    Top = 44
    Width = 23
    Height = 22
    ChevronHint = 'M'#225's botones|'
    ChevronMoveItems = False
    CloseButtonWhenDocked = True
    Images = ImageList
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object ImageList: TImageList
    Left = 200
    Top = 104
  end
  object ActionList: TActionList
    Images = ImageList
    OnExecute = ActionListExecute
    Left = 80
    Top = 104
  end
end
