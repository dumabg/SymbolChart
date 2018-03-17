inherited frPanelInhibidores: TfrPanelInhibidores
  Width = 66
  Height = 61
  ExplicitWidth = 66
  ExplicitHeight = 61
  object TBXToolWindow: TSpTBXToolWindow
    Left = 0
    Top = 0
    Width = 66
    Height = 61
    Caption = 'TBXToolWindow'
    Color = 16054521
    Align = alClient
    CloseButtonWhenDocked = True
    TabOrder = 0
    ClientAreaHeight = 61
    ClientAreaWidth = 66
    object InhibidorCorto: TJvShape
      Left = 44
      Top = 39
      Width = 15
      Height = 15
      Hint = 'Aproximaci'#243'n de posici'#243'n corta'
      Brush.Color = clLime
      ParentShowHint = False
      Pen.Color = clSilver
      Shape = stCircle
      ShowHint = True
    end
    object InhibidorLargo: TJvShape
      Left = 11
      Top = 39
      Width = 15
      Height = 15
      Hint = 'Aproximaci'#243'n de posici'#243'n larga'
      Brush.Color = clLime
      ParentShowHint = False
      Pen.Color = clSilver
      Shape = stCircle
      ShowHint = True
    end
    object lInhibidorCorto: TLabel
      Left = 34
      Top = 40
      Width = 7
      Height = 13
      Caption = 'C'
      ParentShowHint = False
      ShowHint = False
    end
    object lInhibidorLargo: TLabel
      Left = 3
      Top = 40
      Width = 5
      Height = 13
      Caption = 'L'
      ParentShowHint = False
      ShowHint = False
    end
    object iHistoricoLargo: TImage
      Left = 3
      Top = 3
      Width = 60
      Height = 12
      Transparent = True
    end
    object iHistoricoCorto: TImage
      Left = 3
      Top = 21
      Width = 60
      Height = 12
      Transparent = True
    end
  end
  object ApplicationEvents: TApplicationEvents
    OnShowHint = ApplicationEventsShowHint
    Left = 24
  end
end
