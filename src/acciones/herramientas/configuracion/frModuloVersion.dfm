inherited fModuloVersion: TfModuloVersion
  Width = 526
  Height = 246
  ExplicitWidth = 526
  ExplicitHeight = 246
  object LinkWeb: TJvLinkLabel [0]
    Left = 31
    Top = 158
    Width = 438
    Height = 26
    Caption = 
      'Tambi'#233'n puede comprobar si existe alguna nueva versi'#243'n en la web' +
      ' <link>www.symbolchart.com</link>'#13#10
    Text.Strings = (
      
        'Tambi'#233'n puede comprobar si existe alguna nueva versi'#243'n en la web' +
        ' <link>www.symbolchart.com</link>'#13#10)
    LinkStyle = [fsBold, fsUnderline]
    HotLinks = True
    OnLinkClick = LinkWebLinkClick
  end
  object cbVersionNuevaAlArrancar: TCheckBox [1]
    Left = 31
    Top = 54
    Width = 393
    Height = 41
    Caption = 
      'Comprobar autom'#225'ticamente si hay nuevas versiones al arrancar el' +
      ' programa'
    Checked = True
    State = cbChecked
    TabOrder = 0
    OnClick = cbVersionNuevaAlArrancarClick
  end
  object bComprobar: TButton [2]
    Left = 31
    Top = 118
    Width = 106
    Height = 34
    Caption = 'Comprobar ahora'
    TabOrder = 1
    OnClick = bComprobarClick
  end
  inherited JvErrorIndicator: TJvErrorIndicator
    Left = 216
    Top = 8
  end
  inherited ImageListErrorIndicator: TImageList
    Left = 384
    Top = 16
  end
end
