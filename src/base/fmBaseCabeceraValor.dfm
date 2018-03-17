inherited fBaseCabeceraValor: TfBaseCabeceraValor
  ClientHeight = 284
  ClientWidth = 372
  ExplicitWidth = 380
  ExplicitHeight = 318
  PixelsPerInch = 96
  TextHeight = 13
  object PanelValor: TPanel
    Left = 0
    Top = 0
    Width = 372
    Height = 29
    Align = alTop
    BevelOuter = bvSpace
    BevelWidth = 2
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 0
    object lValor: TLabel
      AlignWithMargins = True
      Left = 47
      Top = 4
      Width = 319
      Height = 19
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowAccelChar = False
      ShowHint = False
      Transparent = False
      ExplicitLeft = 44
      ExplicitTop = 3
      ExplicitWidth = 322
      ExplicitHeight = 20
    end
    object lSimbolo: TLabel
      AlignWithMargins = True
      Left = 27
      Top = 4
      Width = 5
      Height = 19
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 0
      Align = alLeft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      ExplicitLeft = 31
      ExplicitTop = 3
      ExplicitHeight = 20
    end
    object lSeparadorNombreSimbolo: TLabel
      AlignWithMargins = True
      Left = 34
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
      ExplicitLeft = 47
      ExplicitTop = 4
      ExplicitHeight = 20
    end
    object iBandera: TImage
      AlignWithMargins = True
      Left = 5
      Top = 4
      Width = 16
      Height = 16
      Margins.Top = 2
      Align = alLeft
      AutoSize = True
    end
  end
end
