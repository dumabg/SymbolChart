inherited fMensaje: TfMensaje
  Caption = 'fMensaje'
  ClientHeight = 187
  ClientWidth = 634
  OnKeyDown = nil
  ExplicitWidth = 640
  ExplicitHeight = 212
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 142
    Width = 634
    Height = 45
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      634
      45)
    object Hecho: TJvXPButton
      Left = 542
      Top = 6
      Width = 84
      Height = 32
      Caption = 'Cerrar'
      TabOrder = 0
      Anchors = [akTop, akRight]
    end
  end
  object FrameBrowser: TFrameBrowser
    Left = 0
    Top = 0
    Width = 634
    Height = 142
    NoSelect = False
    PrintMarginLeft = 2.000000000000000000
    PrintMarginRight = 2.000000000000000000
    PrintMarginTop = 2.000000000000000000
    PrintMarginBottom = 2.000000000000000000
    PrintScale = 1.000000000000000000
    DefBackground = clWhite
    DefFontName = 'Times New Roman'
    DefPreFontName = 'Courier New'
    HistoryMaxCount = 0
    CharSet = DEFAULT_CHARSET
    Align = alClient
    TabOrder = 1
  end
end
