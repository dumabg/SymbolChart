object fBloquear: TfBloquear
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = 'Identificaci'#243'n SymbolChart'
  ClientHeight = 182
  ClientWidth = 341
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inline fLogin: TframeLogin
    Left = 0
    Top = 0
    Width = 341
    Height = 182
    Align = alClient
    Color = 16051939
    ParentBackground = False
    ParentColor = False
    TabOrder = 0
    inherited bIdentificar: TButton
      Left = 197
      Top = 127
      OnClick = fLoginbIdentificarClick
      ExplicitLeft = 197
      ExplicitTop = 127
    end
  end
  object bCerrar: TButton
    Left = 29
    Top = 127
    Width = 133
    Height = 33
    Cursor = crHandPoint
    Caption = 'Cerrar la aplicaci'#243'n'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    WordWrap = True
    OnClick = bCerrarClick
  end
end
