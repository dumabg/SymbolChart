inherited fEditableFS: TfEditableFS
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TJvNetscapeSplitter
    Left = 161
    Top = 0
    Height = 439
    Align = alLeft
    Maximized = False
    Minimized = False
    ButtonCursor = crDefault
    ExplicitLeft = 208
    ExplicitTop = -8
  end
  object pDetalle: TPanel
    Left = 171
    Top = 0
    Width = 511
    Height = 439
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
  end
  inline fFS: TfEditFS
    Left = 0
    Top = 0
    Width = 161
    Height = 439
    Align = alLeft
    TabOrder = 0
    ExplicitWidth = 161
    ExplicitHeight = 439
    inherited TreeFS: TVirtualStringTree
      Width = 161
      Height = 411
      TabOrder = 1
      OnChange = fFSTreeFSChange
      OnStateChange = fFSTreeFSStateChange
      ExplicitWidth = 161
      ExplicitHeight = 411
      WideDefaultText = 'Sin nombre'
    end
    inherited Toolbar: TSpTBXToolbar
      Width = 155
      ShowCaption = False
      TabOrder = 0
      Caption = ''
      ChevronVertical = False
      DisplayMode = tbdmImageOnly
      ExplicitWidth = 155
    end
    inherited ActionList: TActionList
      inherited CrearCarpeta: TAction
        Caption = ''
        ShortCut = 16429
      end
      inherited BorrarCarpeta: TAction
        Caption = ''
        ShortCut = 16430
      end
      inherited CrearFichero: TAction
        Caption = ''
        ShortCut = 8237
      end
      inherited BorrarFichero: TAction
        Caption = ''
        ShortCut = 8238
      end
      inherited CambiarNombre: TAction
        Caption = ''
        ShortCut = 113
      end
    end
  end
end
