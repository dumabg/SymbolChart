inherited fModuloEscenarios: TfModuloEscenarios
  Width = 551
  Height = 189
  ExplicitWidth = 551
  ExplicitHeight = 189
  object Label4: TLabel [0]
    Left = 75
    Top = 105
    Width = 10
    Height = 13
    AutoSize = False
    Caption = '%'
    Transparent = True
  end
  object Label3: TLabel [1]
    Left = 18
    Top = 82
    Width = 51
    Height = 13
    Hint = 'Desviaci'#243'n'
    Caption = 'Desviaci'#243'n'
    ParentShowHint = False
    ShowHint = True
    Transparent = True
  end
  object Label2: TLabel [2]
    Left = 18
    Top = 54
    Width = 139
    Height = 13
    Hint = 'Sintonizaci'#243'n'
    Caption = 'Intento de Sintonizaci'#243'n con '
    ParentShowHint = False
    ShowHint = True
    Transparent = True
  end
  object Label1: TLabel [3]
    Left = 18
    Top = 137
    Width = 94
    Height = 13
    Hint = 'N'#250'mero de intentos'
    Caption = 'N'#250'mero de intentos'
    ParentShowHint = False
    ShowHint = True
    Transparent = True
  end
  object Label8: TLabel [4]
    Left = 190
    Top = 54
    Width = 41
    Height = 13
    Hint = 'Sintonizaci'#243'n'
    Caption = 'sesiones'
    ParentShowHint = False
    ShowHint = True
    Transparent = True
  end
  object AyudaQueSon: TJvLinkLabel [5]
    Left = 18
    Top = 20
    Width = 407
    Height = 13
    Caption = 
      '<link>'#191'Qu'#233' son los escenarios y que significan estos par'#225'metros?' +
      '</link>'
    Text.Strings = (
      
        '<link>'#191'Qu'#233' son los escenarios y que significan estos par'#225'metros?' +
        '</link>')
    LinkStyle = [fsBold, fsUnderline]
    HotLinks = True
    OnLinkClick = AyudaQueSonLinkClick
  end
  object eSintonizacion: TEdit [6]
    Left = 158
    Top = 50
    Width = 25
    Height = 21
    Hint = 'Sintonizaci'#243'n'
    MaxLength = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Text = '5'
    OnKeyPress = NumeroKeyPress
  end
  object eDesviacionPerCent: TEdit [7]
    Tag = 1
    Left = 41
    Top = 101
    Width = 28
    Height = 21
    Hint = 'Desviaci'#243'n'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Text = '1'
    OnKeyPress = NumeroKeyPress
  end
  object eIntentos: TEdit [8]
    Left = 118
    Top = 133
    Width = 25
    Height = 21
    Hint = 'N'#250'mero de intentos'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Text = '50'
    OnKeyPress = NumeroKeyPress
  end
  object cbDesviacionAutomatico: TCheckBox [9]
    Left = 115
    Top = 103
    Width = 97
    Height = 17
    Caption = 'Autom'#225'tico'
    TabOrder = 2
    OnClick = cbDesviacionAutomaticoClick
  end
  inherited JvErrorIndicator: TJvErrorIndicator
    Left = 480
    Top = 64
  end
end
