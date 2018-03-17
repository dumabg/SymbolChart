inherited frPanelValor: TfrPanelValor
  Width = 464
  Height = 32
  Color = 16054521
  ParentBackground = False
  ParentColor = False
  ExplicitWidth = 464
  ExplicitHeight = 32
  object ToolbarValor: TSpTBXToolbar
    Left = 0
    Top = 0
    Width = 412
    Height = 29
    CloseButtonWhenDocked = True
    DockableTo = [dpTop]
    DockPos = 588
    Resizable = False
    TabOrder = 0
    Color = 16054521
    Caption = 'Valor'
    object TBControlItem2: TTBControlItem
      Control = PanelValor
    end
    object PanelValor: TPanel
      Left = 0
      Top = 0
      Width = 412
      Height = 29
      BevelOuter = bvSpace
      BevelWidth = 2
      BorderStyle = bsSingle
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object Valor: TDBText
        AlignWithMargins = True
        Left = 155
        Top = 4
        Width = 251
        Height = 19
        Hint = 'Valor'
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        AutoSize = True
        DataField = 'NOMBRE'
        DataSource = dsValores
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        Transparent = False
        ShowHint = True
        ExplicitWidth = 38
        ExplicitHeight = 16
      end
      object Simbolo: TDBText
        AlignWithMargins = True
        Left = 82
        Top = 4
        Width = 58
        Height = 19
        Hint = 'S'#237'mbolo'
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 0
        Align = alLeft
        AutoSize = True
        DataField = 'SIMBOLO'
        DataSource = dsValores
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        Transparent = False
        ShowHint = True
        ExplicitHeight = 16
      end
      object lSeparadorNombreSimbolo: TLabel
        AlignWithMargins = True
        Left = 142
        Top = 5
        Width = 11
        Height = 15
        Margins.Left = 0
        Margins.Right = 0
        Align = alLeft
        Alignment = taCenter
        AutoSize = False
        Caption = ' - '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        ExplicitLeft = 47
        ExplicitTop = 4
        ExplicitHeight = 20
      end
      object DBText1: TDBText
        AlignWithMargins = True
        Left = 5
        Top = 5
        Width = 48
        Height = 15
        Align = alLeft
        AutoSize = True
        DataField = 'OID_VALOR'
        DataSource = dsValores
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 8388863
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
        ExplicitHeight = 13
      end
      object pBandera: TPanel
        AlignWithMargins = True
        Left = 59
        Top = 2
        Width = 20
        Height = 18
        Margins.Top = 0
        Margins.Right = 0
        Align = alLeft
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
        object iBandera: TImage
          Left = 0
          Top = 2
          Width = 16
          Height = 16
        end
      end
    end
  end
  object dsValores: TDataSource
    DataSet = Data.Valores
    Left = 424
  end
end
