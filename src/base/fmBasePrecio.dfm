inherited fBasePrecio: TfBasePrecio
  ClientHeight = 354
  ClientWidth = 380
  ExplicitWidth = 388
  ExplicitHeight = 388
  DesignSize = (
    380
    354)
  PixelsPerInch = 96
  TextHeight = 13
  object lPrecio: TLabel [0]
    Left = 24
    Top = 83
    Width = 30
    Height = 13
    Caption = 'Precio'
  end
  object lComision: TLabel [1]
    Left = 121
    Top = 83
    Width = 42
    Height = 13
    Caption = 'Comisi'#243'n'
  end
  object lPrecioMedio: TLabel [2]
    Left = 40
    Top = 171
    Width = 61
    Height = 13
    Caption = 'lPrecioMedio'
    Visible = False
  end
  object Bevel2: TBevel [3]
    AlignWithMargins = True
    Left = 10
    Top = 294
    Width = 360
    Height = 10
    Margins.Left = 10
    Margins.Right = 10
    Margins.Bottom = 50
    Align = alBottom
    Shape = bsBottomLine
    ExplicitLeft = 21
    ExplicitTop = 226
    ExplicitWidth = 324
  end
  object iPrecioGBP: TImage [4]
    Left = 67
    Top = 84
    Width = 16
    Height = 14
    Hint = 
      'Precio en PENIQUES (igual que el precio mostrado en el programa)' +
      '.'#13#10'El programa traducir'#225' autom'#225'ticamente el precio a libras.'
    AutoSize = True
    ParentShowHint = False
    Picture.Data = {
      0B544A76474946496D616765F303000047494638396110000E00F7000000003C
      00004800114F0719450B1D49021D57000364000862000A6D000B7C00187E0C21
      4F0E245211244C102754172950192C541A2F581E315913336D1935631E376F23
      345A203660263B63213D6B2A3F632D4066254372284B7B334363394A6A314A74
      35507E3D527844506C4256774B5D7A515E7759667E5B687E001B83001B8B0020
      8D042C8100269200279A002A97002E9B02308F00309C183E89002FA30A3EA61C
      438D1F47931A49AA1A4EBD1B50BE2B4984314F853E5C863F628E3B62933E619B
      295ECC4A628541629B5F6A805D6F8A516D955F74954D6CA2567CA7567FAC5F7E
      A3636F866973866E798B6E7D90737D8E727E935C8AB97D85916386AB6981A763
      8BB26591BE6D93BB708AB47190B37B9CBD4E86DF5185E36387C9698DC17596C8
      739AC07A95C07B9BC96EA1D678A0C670A2D371A1D572AADF7CA8D78089968991
      9B91979F8095AF889CBD9299A09499A1989EA584A2BF9CA0A59FA4A897A4B094
      A9BEA7ACAEA8ACACAAAFBDAEB2B3ADB6BDB1B3B2B1B4B2B0B4B4B4B7B6B5B8B5
      BBBDB9859DC7879FC882A3C480A5CE84A9CA8BAAC48BACCB80A8DA8AAFD48CB2
      D395ADC392AECC99AEC299AED493B1CD9AB0C39AB2CB92B4D493B6D896B8DB98
      B6D39EB9D59BBBD892BCE3A2B7CCA6B9CBAAB5C1A8B7C9A9BBC9A3BDD3B0BBC2
      B2BFCDBFC0BBBEC0BC9EC1E59CC4EC9DC1F1A7C0D6ACC4DBB5C1CCBFC3C0B9C3
      CCB1C4D5B0C6DEB4C9DFB8C6D4BDC8D6BFCFD9A3C4E5A4C6E8AAC6E2AAC7E8AC
      C9E7A3CBF4A5CFF9A7D1FDACD2FAB4CCE3B4CFEBB8CEE4BCD2E5B2D4F5B0D4F8
      B6D8F1B4D9FCB9D7F6B9D8F5BBDDFDBDE2FFC1C3BDC6CBCECCCCC5C9CDC8C3CD
      D7CAD2DCD3D3C9DAD9CCDDDBCEDEDCCFD2D6DCD4DBDDDADEDCC6D9EBCBDCEEC4
      DAF3C2DEFAD3DDE3DCDEE0C4E2FECAE4FECDE8FFD6E0E4DDE3EAD2E2F2D1E6FD
      D3EAFEDAE6F3DDE9F4DBEDFED3F3FFDCF1FFDFF9FFE2E0D2E6E4D5E8E5D5EAE7
      D8EBE8D7EAEADEECE9D8E3E4E1E2E5E9E4E9EDE8E7E7EBEBECE3EBF3E1EFFFE3
      F2FEE3FAFFEAF5FEECFAFFF0F0EEF5F5F3F1F6FBF3FBFEF9F8F6FDFEFE21F904
      010000EE002C0000000010000E000008D000DD0974176DDFBF83FEFEED193810
      9BBE83FF001438C8EF9FAA86F10EF6A32783C63F7CFFF8F1E3E36E5DB67FFD52
      42C487CF5EBF71D49CC5F2D68F65BE0A3C04F4AB678E5CBE6F4C5289B367AF9E
      CB1629FA910B17CE9C2F09A9BEF524E733458A7CDCC0710BD72BC2275F4B999E
      B37A6FDB366DDA5A4568E6691B37B3E6AC9A436BCCD6240FEEE468BAA66D1B31
      183082192B560B12033A02B748AA65CC94AE5BB9805582C481C8C07445E41C32
      344957254456163849C7D01DA013241A50F0D000C5B1D2034F53A0D0FAF5C080
      00003B}
    ShowHint = True
  end
  object iComisionGBP: TImage [5]
    Left = 169
    Top = 84
    Width = 16
    Height = 14
    Hint = 'Comisi'#243'n en LIBRAS.'
    AutoSize = True
    ParentShowHint = False
    Picture.Data = {
      0B544A76474946496D616765F303000047494638396110000E00F7000000003C
      00004800114F0719450B1D49021D57000364000862000A6D000B7C00187E0C21
      4F0E245211244C102754172950192C541A2F581E315913336D1935631E376F23
      345A203660263B63213D6B2A3F632D4066254372284B7B334363394A6A314A74
      35507E3D527844506C4256774B5D7A515E7759667E5B687E001B83001B8B0020
      8D042C8100269200279A002A97002E9B02308F00309C183E89002FA30A3EA61C
      438D1F47931A49AA1A4EBD1B50BE2B4984314F853E5C863F628E3B62933E619B
      295ECC4A628541629B5F6A805D6F8A516D955F74954D6CA2567CA7567FAC5F7E
      A3636F866973866E798B6E7D90737D8E727E935C8AB97D85916386AB6981A763
      8BB26591BE6D93BB708AB47190B37B9CBD4E86DF5185E36387C9698DC17596C8
      739AC07A95C07B9BC96EA1D678A0C670A2D371A1D572AADF7CA8D78089968991
      9B91979F8095AF889CBD9299A09499A1989EA584A2BF9CA0A59FA4A897A4B094
      A9BEA7ACAEA8ACACAAAFBDAEB2B3ADB6BDB1B3B2B1B4B2B0B4B4B4B7B6B5B8B5
      BBBDB9859DC7879FC882A3C480A5CE84A9CA8BAAC48BACCB80A8DA8AAFD48CB2
      D395ADC392AECC99AEC299AED493B1CD9AB0C39AB2CB92B4D493B6D896B8DB98
      B6D39EB9D59BBBD892BCE3A2B7CCA6B9CBAAB5C1A8B7C9A9BBC9A3BDD3B0BBC2
      B2BFCDBFC0BBBEC0BC9EC1E59CC4EC9DC1F1A7C0D6ACC4DBB5C1CCBFC3C0B9C3
      CCB1C4D5B0C6DEB4C9DFB8C6D4BDC8D6BFCFD9A3C4E5A4C6E8AAC6E2AAC7E8AC
      C9E7A3CBF4A5CFF9A7D1FDACD2FAB4CCE3B4CFEBB8CEE4BCD2E5B2D4F5B0D4F8
      B6D8F1B4D9FCB9D7F6B9D8F5BBDDFDBDE2FFC1C3BDC6CBCECCCCC5C9CDC8C3CD
      D7CAD2DCD3D3C9DAD9CCDDDBCEDEDCCFD2D6DCD4DBDDDADEDCC6D9EBCBDCEEC4
      DAF3C2DEFAD3DDE3DCDEE0C4E2FECAE4FECDE8FFD6E0E4DDE3EAD2E2F2D1E6FD
      D3EAFEDAE6F3DDE9F4DBEDFED3F3FFDCF1FFDFF9FFE2E0D2E6E4D5E8E5D5EAE7
      D8EBE8D7EAEADEECE9D8E3E4E1E2E5E9E4E9EDE8E7E7EBEBECE3EBF3E1EFFFE3
      F2FEE3FAFFEAF5FEECFAFFF0F0EEF5F5F3F1F6FBF3FBFEF9F8F6FDFEFE21F904
      010000EE002C0000000010000E000008D000DD0974176DDFBF83FEFEED193810
      9BBE83FF001438C8EF9FAA86F10EF6A32783C63F7CFFF8F1E3E36E5DB67FFD52
      42C487CF5EBF71D49CC5F2D68F65BE0A3C04F4AB678E5CBE6F4C5289B367AF9E
      CB1629FA910B17CE9C2F09A9BEF524E733458A7CDCC0710BD72BC2275F4B999E
      B37A6FDB366DDA5A4568E6691B37B3E6AC9A436BCCD6240FEEE468BAA66D1B31
      183082192B560B12033A02B748AA65CC94AE5BB9805582C481C8C07445E41C32
      344957254456163849C7D01DA013241A50F0D000C5B1D2034F53A0D0FAF5C080
      00003B}
    ShowHint = True
  end
  inherited PanelValor: TPanel
    Width = 380
    ExplicitWidth = 380
    inherited lValor: TLabel
      Width = 315
      Height = 20
    end
    inherited lSimbolo: TLabel
      Height = 20
    end
  end
  object ePrecio: TJvSpinEdit
    Left = 23
    Top = 102
    Width = 74
    Height = 21
    CheckMaxValue = False
    Decimal = 4
    MinValue = 0.000100000000000000
    ShowButton = False
    ValueType = vtFloat
    Value = 0.000100000000000000
    TabOrder = 1
    OnChange = ePrecioChange
  end
  object eComision: TJvSpinEdit
    Left = 121
    Top = 102
    Width = 57
    Height = 21
    CheckMinValue = True
    ShowButton = False
    ValueType = vtFloat
    TabOrder = 2
    OnChange = eComisionChange
  end
  object cbComisionIncluida: TCheckBox
    Left = 23
    Top = 148
    Width = 225
    Height = 17
    Caption = 'El precio es medio, incluyendo la comisi'#243'n'
    TabOrder = 3
    OnClick = cbComisionIncluidaClick
  end
  inline fCambioMoneda: TfCambioMoneda
    Left = 23
    Top = 222
    Width = 252
    Height = 61
    TabOrder = 5
    ExplicitLeft = 23
    ExplicitTop = 222
    ExplicitWidth = 252
    ExplicitHeight = 61
    inherited lMonedaBase: TLabel
      Width = 44
      ExplicitWidth = 44
    end
    inherited lMonedaNueva: TLabel
      Width = 23
      ExplicitWidth = 23
    end
    inherited sbBuscarBD: TSpeedButton
      OnClick = fCambioMonedasbBuscarBDClick
    end
  end
  object bOK: TBitBtn
    Left = 81
    Top = 312
    Width = 97
    Height = 34
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    TabOrder = 6
  end
  object bCancelar: TBitBtn
    Left = 202
    Top = 312
    Width = 97
    Height = 34
    Anchors = [akLeft, akBottom]
    Caption = 'Cancelar'
    TabOrder = 7
    Kind = bkCancel
  end
  object cbCambioMoneda: TCheckBox
    Left = 24
    Top = 199
    Width = 225
    Height = 17
    Caption = 'Especficar el cambio de moneda'
    TabOrder = 4
    OnClick = cbCambioMonedaClick
  end
end