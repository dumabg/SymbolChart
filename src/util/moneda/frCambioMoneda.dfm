object fCambioMoneda: TfCambioMoneda
  Left = 0
  Top = 0
  Width = 263
  Height = 52
  TabOrder = 0
  object lMonedaBase: TLabel
    Left = 22
    Top = 23
    Width = 43
    Height = 13
    Caption = '1 EUR = '
  end
  object lMonedaNueva: TLabel
    Left = 139
    Top = 23
    Width = 20
    Height = 13
    Caption = 'USD'
  end
  object sbBuscarBD: TSpeedButton
    Left = 172
    Top = 15
    Width = 29
    Height = 29
    Hint = 
      'Extraer el cambio del '#250'ltimo cambio '#13#10'existente en la base de da' +
      'tos'
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
      92897A948A789C907BA79A84B5A894C2B7A6CFC7BBD7D2CBCECAC2B7B0A39E95
      85908777FFFFFFFFFFFFFFFFFFFFFFFF94876DA08E6FAC997CB8A68CC5B69FD5
      C8B6E7E0D5FBF9F6FFFFFFF4EFEAE0D8CCB3A896FFFFFFFFFFFFFFFFFFFFFFFF
      92805E9F8C6CB1A186C3B59FD2C7B5DFD5C8ECE6DEFAF8F6FFFEFDF4F0EBE5DC
      D1CCBEA9FFFFFFFFFFFFFFFFFFFFFFFFA5967AC5BBAACAC1B3C8C0B2C6BDAFC4
      BBADC3BAACC5BCADCBC2B5D4CDC3E0DAD1D3C8B6FFFFFFFFFFFFFFFFFFFFFFFF
      CBC5BB8C816C857962897C658E816A9386709589739286708A7D6680735A8477
      60CDC7BDFFFFFFFFFFFFFFFFFFFFFFFFAFA7979B8F78948368AB9B81BDAF98CD
      C1AFDDD6CAEBE9E3E4E2DCC4BCB0B7AFA0BCB4A7FFFFFFFFFFFFFFFFFFFFFFFF
      92805FA18F6FAB987BB6A58BC4B59ED4C8B6E6DFD4FAF8F5FFFFFEF5F1EBE7DF
      D3CABDA7FFFFFFFFFFFFFFFFFFFFFFFF927F5EA8977ABFB19BCFC3B2DAD0C2E1
      DACFEAE4DCF3F0ECF8F7F4F5F1ECE8E0D6CBBDA8FFFFFFFFFFFFFFFFFFFFFFFF
      B6A993C1B8A9BCB3A4B5AC9BB2A796AFA492ADA18FACA08DAFA492B9B0A0CAC2
      B6D6CCBEFFFFFFFFFFFFFFFFFFFFFFFFCAC5BD8579638072598E8067998C75A3
      9681AA9F8CAAA08F9D938086796381745DC5C0B6FFFFFFFFFFFFFFFFFFFFFFFF
      A1957FA5977DA39174B7A58CC6B7A1D6CAB9E8E1D6FAF9F6FBFAF9E3DDD6D4CD
      C1BDB3A3FFFFFFFFFFFFFFFFFFFFFFFF927F5E9C8968A89578B5A48AC4B6A0D5
      C9B9E6E0D6F8F7F4FDFCFBF2EEE9E3DBCECCBFA9FFFFFFFFFFFFFFFFFFFFFFFF
      958262B6A991D2C8B9E2DCD1EBE5DEEDE8E1ECE7E0EDE8E0EEE9E2EDE8E1E8E1
      D8CDC0ABFFFFFFFFFFFFFFFFFFFFFFFFD4CCBEEDE7DEF3EEEAF8F5F3F8F5F3F0
      EBE6E6DFD5DCD3C6D3C6B4CEC0ACD0C4B1DFD8CBFFFFFFFFFFFFFFFFFFFFFFFF
      CCC7BFDAD3C9E9E3DCF5F3F0FAF8F6F1EDE8E7E1D8DED5C8D3C8B7CBBEACC5BA
      A9C6C0B6FFFFFFFFFFFFFFFFFFFFFFFF92897AA69E92B6B0A5C4BEB5CDC8C0CF
      CBC2CDC8BEC7C1B6BEB8ADB5AEA3A8A094938A7BFFFFFFFFFFFF}
    ParentShowHint = False
    ShowHint = True
    OnClick = sbBuscarBDClick
  end
  object sbBuscarInternet: TSpeedButton
    Left = 207
    Top = 15
    Width = 29
    Height = 29
    Hint = 'Extraer el cambio desde Internet'
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000FEFEFEFBFEFE
      FEFDFDFBFCFBDDE5DFA8B8AD8D8D84957D79997C7AA59794CAC6C2F1EFEDFEFC
      FEFEFCFEFFFBFEFFFCFFF5FDFCF6FCFCF5F6F2AAB5A759836756856054644277
      58408C59468456457D5B4A9B8677D4D8D1F7F9F8FFFBFEFFFCFFF7FDFDFAF6F6
      AB9C935D6B4E519A65429C5F5F905A7A643D9C5C3EA35B439D5D47845A43687C
      65C5D3C7FAFCFBFEFCFEF8F7F8C8B0AF825E5166714750A7612FAB6253A56976
      6F44A36345B25E47AB5C47905D456389636F8D74DBE4DDFEFDFEECEADFA0705D
      6D644553956049AE6832AE6948A96D877249A26444AB6547AD674980674247A2
      6854A07090B39BF6F9F9C4C0AEBF725C81815A46B27747B26F45B06F4AAE7286
      774EA36A47AE684793603C6F794B49B47450AD746DA080DAE5E2BAA392A27D60
      81A87B6BB58174B5798C96657E8A5C9F704BAC6C4A9F6E4A6C8C5A42B3743DB8
      7649B87B5FA881B4CFC69A8D7982AC8069A7778F8B65A3996BB7825CA67C57B3
      704FB86F4FA16B476AA67031C27F34C07C35BF7C4FB78799C5B587B99785C292
      929972A38F6DB68B66C68967C68A68CE8464C47C5CB1755373A5704DBB7D49BC
      7D3BC17D49B9859BCBB681D0AA73AD7E8A876487A87F9F8C65B2946CB58F69CA
      8E6CC38E6AB78460739160749A687BA47166B97C60B581BADBC5A9DDBD6BC18E
      73BA8B73C191899A6EA8845FCD8B6ADA8C6DB8926C99976B72C0887CA776A188
      6084986779A277DFEDDBCCF2E06FC59C5CC69260C8906FC38E7CB180B28F6ADF
      8C6DBA906A78A1705FC7907CB48799876295866BA6A095FBFAF9E6FDF59AD9BA
      68C39461C58F64C68E6BC18D7F936AB48766A88E6984B38469C69570C1948AB6
      8B93B194D6E7DCF7FEFEF6FEFCDEFBEC90CCAA70C49558BB8658AC787ABA8798
      9E729C946A89AA7D75BC8D51C7946ABF97A0DBBFE5FEF7F8FEFEFEFDFEF8FEFA
      DCF8E799D4B370C29874C5918BBB87B4946BA89C6F72B57F6EBA876FC798A8DF
      C7E1FDF1F8FEFAFEFDFEFFFDFFFEFEFEF5FDFAE3FCF0BFEAD39CCCA897A17CBF
      8F71A89A7689C5979CDBB1CFF3DAF5FDF6FCFDF9FFFDFDFFFCFE}
    ParentShowHint = False
    ShowHint = True
    OnClick = sbBuscarInternetClick
  end
  object eMonedaValor: TJvSpinEdit
    Left = 72
    Top = 20
    Width = 65
    Height = 21
    CheckMinValue = True
    Decimal = 4
    ShowButton = False
    ValueType = vtFloat
    TabOrder = 0
  end
end
