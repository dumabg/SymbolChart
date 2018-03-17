object fSeleccionFechas: TfSeleccionFechas
  Left = 0
  Top = 0
  Width = 533
  Height = 364
  TabOrder = 0
  object Label4: TLabel
    Left = 0
    Top = 3
    Width = 256
    Height = 24
    Alignment = taCenter
    AutoSize = False
    Caption = 'Desde'
    Color = 33023
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clCream
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = False
  end
  object Label6: TLabel
    Left = 262
    Top = 3
    Width = 251
    Height = 24
    Alignment = taCenter
    AutoSize = False
    Caption = 'Hasta'
    Color = 33023
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clCream
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = False
  end
  object PanelDesde: TPanel
    Left = 1
    Top = 27
    Width = 256
    Height = 334
    BevelInner = bvLowered
    TabOrder = 0
    object lDesde: TLabel
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 246
      Height = 20
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'lDesde'
      Color = 15329769
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
    end
    object Label1: TLabel
      Left = 48
      Top = 234
      Width = 108
      Height = 13
      Cursor = crHandPoint
      Caption = 'El primer d'#237'a disponible'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = DesdePrimerDiaExecute
    end
    object Label2: TLabel
      Left = 48
      Top = 253
      Width = 76
      Height = 13
      Cursor = crHandPoint
      Caption = 'Principio de mes'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = DesdeMesExecute
    end
    object Label3: TLabel
      Left = 48
      Top = 273
      Width = 77
      Height = 13
      Cursor = crHandPoint
      Caption = 'Principio del a'#241'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = DesdeAnoExecute
    end
    object Label5: TLabel
      Left = 34
      Top = 216
      Width = 113
      Height = 13
      Caption = 'Selecci'#243'n de d'#237'a r'#225'pido:'
    end
    object ePrincipioAno: TEdit
      Left = 131
      Top = 272
      Width = 41
      Height = 21
      TabOrder = 0
      Text = '0'
    end
    object SeleccionAno: TUpDown
      Left = 172
      Top = 272
      Width = 16
      Height = 21
      Associate = ePrincipioAno
      TabOrder = 1
      Thousands = False
    end
    inline CalendarioDesde: TframeCalendario
      Left = 21
      Top = 43
      Width = 212
      Height = 166
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      ExplicitLeft = 21
      ExplicitTop = 43
      ExplicitWidth = 212
      ExplicitHeight = 166
      inherited Panel1: TPanel
        Width = 212
        Height = 130
        ExplicitLeft = -3
        ExplicitWidth = 212
        ExplicitHeight = 130
      end
      inherited Panel2: TPanel
        Top = 130
        Width = 212
        ExplicitTop = 130
        ExplicitWidth = 212
        inherited Cerrar: TSpeedButton
          Left = 190
          ExplicitLeft = 190
        end
      end
      inherited ActionList: TActionList
        Left = 80
        Top = 40
      end
    end
  end
  object PanelHasta: TPanel
    Left = 262
    Top = 26
    Width = 251
    Height = 335
    BevelInner = bvLowered
    TabOrder = 1
    object Label7: TLabel
      Left = 35
      Top = 217
      Width = 113
      Height = 13
      Caption = 'Selecci'#243'n de d'#237'a r'#225'pido:'
    end
    object Label8: TLabel
      Left = 48
      Top = 234
      Width = 106
      Height = 13
      Cursor = crHandPoint
      Caption = 'El '#250'ltimo d'#237'a disponible'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = HastaUltimoDiaExecute
    end
    object lHasta: TLabel
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 241
      Height = 20
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'lHasta'
      Color = 15329769
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
      ExplicitWidth = 246
    end
    inline CalendarioHasta: TframeCalendario
      Left = 21
      Top = 45
      Width = 212
      Height = 166
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      ExplicitLeft = 21
      ExplicitTop = 45
      ExplicitWidth = 212
      ExplicitHeight = 166
      inherited Panel1: TPanel
        Width = 212
        Height = 130
        ExplicitWidth = 212
        ExplicitHeight = 130
      end
      inherited Panel2: TPanel
        Top = 130
        Width = 212
        ExplicitTop = 130
        ExplicitWidth = 212
        inherited Cerrar: TSpeedButton
          Left = 190
          ExplicitLeft = 190
        end
      end
    end
  end
  object ActionList: TActionList
    Left = 360
    Top = 152
    object DesdeAno: TAction
      Category = 'Periodo'
      Caption = 'Principio del a'#241'o'
      Checked = True
      OnExecute = DesdeAnoExecute
    end
    object DesdeMes: TAction
      Category = 'Periodo'
      Caption = 'Principio de mes'
      OnExecute = DesdeMesExecute
    end
    object DesdeFecha: TAction
      Category = 'Periodo'
      Caption = 'Una fecha concreta'
      OnExecute = DesdeFechaExecute
    end
    object DesdePrimerDia: TAction
      Category = 'Periodo'
      Caption = 'El primer d'#237'a disponible'
      OnExecute = DesdePrimerDiaExecute
    end
    object HastaUltimoDia: TAction
      Category = 'Periodo'
      Caption = 'Hoy'
      Checked = True
      OnExecute = HastaUltimoDiaExecute
    end
    object HastaFecha: TAction
      Category = 'Periodo'
      Caption = 'Una fecha concreta'
    end
  end
end
