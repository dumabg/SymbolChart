inherited fScriptError: TfScriptError
  Caption = 'Error de ejecuci'#243'n en la estrategia'
  ClientWidth = 646
  Color = clWhite
  ExplicitWidth = 654
  PixelsPerInch = 96
  TextHeight = 13
  object lMensaje: TLabel
    AlignWithMargins = True
    Left = 40
    Top = 6
    Width = 603
    Height = 13
    Cursor = crHandPoint
    Margins.Left = 40
    Margins.Top = 6
    Margins.Bottom = 10
    Align = alTop
    Color = clWhite
    ParentColor = False
    ParentShowHint = False
    ShowHint = True
    Transparent = False
    Layout = tlCenter
    WordWrap = True
    OnClick = lMensajeClick
    ExplicitWidth = 3
  end
  object sbEditar: TSpeedButton
    Left = 3
    Top = 1
    Width = 26
    Height = 28
    Hint = 'Editar la estrategia'
    Flat = True
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000F00A0000F00A00000000000000000000FFFFFFD4D4D5
      D9DADADDDDDEDDDDDEDEDFDFDFDFDFDBDBDCDBDCDCDBDBDCDADBDBD9DADAD7D8
      D8CDCDCEFFFFFFFFFFFFFFFFFFDBDBDCDEDFDFD8D9D9DCDDDDDADBDCD7D9DBF0
      EBE7EAE9E7E5E6E6E3E4E4E2E3E3DFE0E0D0D1D1FFFFFFFFFFFFFFFFFFDEDFDF
      DEDFDFCDCECED2D3D3D7D4D3BAD0DC80B9E7D1D6DEE3E0DBE6E7E8E8E9E9E2E3
      E3D2D2D2FFFFFFFFFFFFFFFFFFE0E1E1E2E3E3D6D7D7DCDDDDDCDBDBE1E1E22B
      B4F42599E7D6D6DBECE8E3E1E3E3E4E5E5D3D4D4FFFFFFFFFFFFFFFFFFE2E3E3
      E4E6E6D6D7D7DDDEDFDADBDCE2DDDBC6D3DD1BB3F52A9CEBD4D5DBEDE9E4E7E8
      E8D5D5D6FFFFFFFFFFFFFFFFFFE4E5E5E7E8E8D9DADADADBDCDADBDCDEDFE0E8
      E0DCCFD9E21BB4F42599E9E1E2E9F6F1ECD2D3D6FFFFFFFFFFFFFFFFFFE5E6E6
      E9EAEADEDFDFE0E1E1DEDEDFE0E1E1DBDCDDEDE5E1CFDBE319B5F4289DEDE1E3
      EBFFF3D5FFFFFFFFFFFFFFFFFFE6E6E7EBECECD9D9DAE0E1E1E3E3E4E0E1E2E1
      E2E3E1E2E3ECE4E0D3DFE71BB8F6299DEA73A9E9FFFFFFFFFFFFFFFFFFE7E8E8
      EBEBECDADBDCE0E1E1E5E6E6E5E6E6E5E6E6E0E1E1E3E4E4EEE6E2DFECF21AB9
      F74BA3DFFFDB93FFFFFFFFFFFFE8E8E8ECEDEDDADADBE5E6E6E3E4E4E5E5E6E5
      E5E6E5E5E6E4E4E4EAEBECFFF8F4DAE9F2BEC8C9A2A4D78083EEFFFFFFE8E9E9
      ECEDEDDEDFE0E6E6E7E6E7E7EAEBEBE7E8E8E3E4E4E4E5E5E5E5E5E1E2E3F8F4
      F1D0D5D297ACF48586EBFFFFFFE8E8E8EFF0F0E2E2E3E5E5E6E7E7E8E8E9E9EA
      EAEAE8E8E8E8E8E9DFDFE0EBEBEBEEEEEEEEE9DEFFFFFFFFFFFFFFFFFFE8E9E9
      EDEEEEDCDDDDE0E1E1E5E5E6E3E4E4E7E7E8E1E2E2EBECECEDEDEDE7E7E7D2D2
      D3FFFFFFFFFFFFFFFFFFFFFFFFE7E7E7EFF0F0EBEBECEDEDEEEDEDEEEEEFEFF0
      F0F0F0F1F1EEEEEEEFEFEFDADADAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5E6E6
      F1F1F1F4F5F5F6F7F7F8F8F8F9F9F9F9F9F9FAFAFAF4F4F4D6D6D6FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFE2E2E2EBECECEDEEEEEFEFEFF0F0F0F1F1F1F1
      F1F2F1F2F2EBEBEBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    ParentShowHint = False
    ShowHint = True
    OnClick = sbEditarClick
  end
  object Editor: TSynEdit
    Left = 0
    Top = 29
    Width = 646
    Height = 387
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 0
    OnKeyDown = FormKeyDown
    Gutter.AutoSize = True
    Gutter.Color = 16053492
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Gutter.LeftOffset = 0
    Gutter.RightOffset = 4
    Gutter.ShowLineNumbers = True
    Gutter.Width = 20
    Highlighter = SynPasSyn
    Options = [eoAutoIndent, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoScrollPastEol, eoShowScrollHint, eoSmartTabDelete, eoTabIndent, eoTabsToSpaces, eoTrimTrailingSpaces]
    ReadOnly = True
    TabWidth = 2
    WantTabs = True
    OnStatusChange = EditorStatusChange
  end
  object StatusBar: TStatusBar
    AlignWithMargins = True
    Left = 0
    Top = 416
    Width = 646
    Height = 20
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Panels = <
      item
        Alignment = taCenter
        Width = 66
      end
      item
        Width = 75
      end
      item
        Width = 90
      end
      item
        Width = 100
      end>
  end
  object SynPasSyn: TSynPasSyn
    CommentAttri.Foreground = clGreen
    NumberAttri.Foreground = clBlue
    StringAttri.Foreground = clBlue
    Left = 448
    Top = 248
  end
end
