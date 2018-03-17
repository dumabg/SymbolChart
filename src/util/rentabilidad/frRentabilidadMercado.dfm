object fRentabilidadMercado: TfRentabilidadMercado
  Left = 0
  Top = 0
  Width = 290
  Height = 63
  TabOrder = 0
  object Bevel1: TBevel
    AlignWithMargins = True
    Left = 145
    Top = 5
    Width = 2
    Height = 53
    Margins.Left = 0
    Margins.Top = 5
    Margins.Right = 0
    Margins.Bottom = 5
    Align = alLeft
    Shape = bsLeftLine
    ExplicitTop = 0
    ExplicitHeight = 63
  end
  object pGananciasCerradoUSA: TPanel
    Left = 0
    Top = 0
    Width = 145
    Height = 63
    Align = alLeft
    BevelOuter = bvNone
    Color = 16776436
    ParentBackground = False
    TabOrder = 0
    object Image11: TImage
      Left = 4
      Top = 6
      Width = 15
      Height = 15
      Hint = 'Posiciones abiertas'
      AutoSize = True
      ParentShowHint = False
      Picture.Data = {
        0954474946496D6167654749463839610F000F00E60000000000FFFFFFB89CA7
        BAA1AB62606177727D938EA498A0BAA1A8BFACB2C67E8EB08492B26A7CA0A3AF
        C766738A8499BAA7B7CEB7C4D7C4CFDFCBD4E2A3B4CCDCE3EC5B4D408F4B1483
        3F0AE06B12AE540EA34E0D94470C4A2406F97715F17314EF7214EA7014DB6912
        D76612D66612D46512CE6311CD6211C75F11BF5B10BC5A10B0540FA9510EA44F
        0E9A4A0D90450C8F440C8F450C833F0B693209E76E14E46D14C35D11B95810B7
        5710B5561095480D89410C803D0B6832095D2D08CB6214F97A1DF97B1EEC7A26
        AB5A1DBF6926D76919F97F28CB6A26F98331F98332FA8637CC6D2D443225CC70
        34FA8A42FA8E49D87C44CC7540FA9459FA9861E68D5CCC7D52D7885BA6765BFA
        9D6D493A32CD8360FBA176FBA47FFBA783D991733D2E28291B16FBAA8B2B1D18
        2A1D18FBAD91E7A0852E211CD397813C2C26E9A48D3526213A2A25B287792A1C
        188A7670EBAC9C2A1C192C1E1B2D1D1AA887829A7E7AC79F9EFFFFFF00000000
        000000000000000000000000000000000000000000000021F90401000076002C
        000000000F000F0000079D807682838485860902088685116F6165148B830364
        5D5B7392760D69019D540A8B15755E9D0150571386075C5AA54D490E85126758
        55A5474144108406535251A53F1F34048314564F4E4BA5291923430F826E4A48
        4645303D183727362A16760B42401E1F25A52B381A2C170C6C2021352239A51C
        1B2E3A2F4C74222426282D333AF8901163870C1E59EC14F882668D1A3363E0C4
        9123A60D183B8100003B}
      ShowHint = True
      Transparent = True
    end
    object Label47: TLabel
      Left = 27
      Top = 11
      Width = 5
      Height = 13
      Hint = 'Posiciones largas abiertas'
      Caption = 'L'
      ParentShowHint = False
      ShowHint = True
    end
    object Label49: TLabel
      Left = 26
      Top = 39
      Width = 7
      Height = 13
      Hint = 'Posiciones cortas abiertas'
      Caption = 'C'
      ParentShowHint = False
      ShowHint = True
    end
    object gAbiertoGananciaLargos: TGauge
      Left = 38
      Top = 1
      Width = 56
      Height = 14
      Hint = 
        '% de n'#250'mero de posiciones largas con ganancias sobre el total de' +
        ' n'#250'mero de posiciones abiertas'
      BackColor = clSilver
      ForeColor = 8454016
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      Progress = 0
      ShowHint = True
    end
    object gAbiertoPerdidasLargos: TGauge
      Left = 38
      Top = 16
      Width = 56
      Height = 14
      Hint = 
        '% de n'#250'mero de posiciones largas con p'#233'rdidas sobre el total de ' +
        'n'#250'mero de posiciones abiertas'
      BackColor = clSilver
      ForeColor = 8421631
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      Progress = 0
      ShowHint = True
    end
    object gAbiertoGananciasCortos: TGauge
      Left = 38
      Top = 32
      Width = 56
      Height = 14
      Hint = 
        '% de n'#250'mero de posiciones cortas con ganancias sobre el total de' +
        ' n'#250'mero de posiciones abiertas'
      BackColor = clSilver
      ForeColor = 8454016
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      Progress = 0
      ShowHint = True
    end
    object gAbiertoPerdidasCortos: TGauge
      Left = 38
      Top = 47
      Width = 56
      Height = 14
      Hint = 
        '% de n'#250'mero de posiciones cortas con p'#233'rdidas sobre el total de ' +
        'n'#250'mero de posiciones abiertas'
      BackColor = clSilver
      ForeColor = 8421631
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      Progress = 0
      ShowHint = True
    end
    object lAbiertoGananciaLargos: TLabel
      Left = 97
      Top = 2
      Width = 3
      Height = 13
      Hint = 
        'Esperanza de ganancia si se entra en un valor en posici'#243'n larga ' +
        'para el mercado en curso '
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object lAbiertoPerdidasLargos: TLabel
      Left = 97
      Top = 16
      Width = 3
      Height = 13
      Hint = 
        'Esperanza de p'#233'rdida si se entra en un valor en posici'#243'n larga p' +
        'ara el mercado en curso '
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object lAbiertoGananciasCortos: TLabel
      Left = 97
      Top = 32
      Width = 3
      Height = 13
      Hint = 
        'Esperanza de ganancia si se entra en un valor en posici'#243'n corta ' +
        'para el mercado en curso '
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object lAbiertoPerdidasCortos: TLabel
      Left = 97
      Top = 47
      Width = 3
      Height = 13
      Hint = 
        'Esperanza de p'#233'rdida si se entra en un valor en posici'#243'n corta p' +
        'ara el mercado en curso '
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
  end
  object pGananciasAbiertoUSA: TPanel
    Left = 147
    Top = 0
    Width = 143
    Height = 63
    Align = alClient
    BevelOuter = bvNone
    Color = 16776436
    ParentBackground = False
    TabOrder = 1
    object Image15: TImage
      Left = 6
      Top = 6
      Width = 15
      Height = 15
      Hint = 'Posiciones cerradas'
      AutoSize = True
      ParentShowHint = False
      Picture.Data = {
        0954474946496D6167654749463839610F000F00F70000000000FFFFFF8499BA
        A6B6CEA7B7CEBCC8DAC7D1E0BFC8D5637EA2A1B1C7DFE5ED7790AC7F99B4A6B8
        CB97AEBF9DB3C3A9BDCB5371821D2A2F82A1AD1A252823383D1B272A2133371D
        2C2F284348274146263E421E2F321D2A2C29464917222150726B9CBCB4A2C0B8
        6A958684AC9C749C8BA2C5B246634F83AD8F37473BC5D6C89DC8A3ACD6A9B7DB
        B4B8DFB232422EB2E1A5B3E2A6B7E3ABB8E4ACB8E4ADBAE5AFBCE5B18FC280B6
        E3A9B2E0A2B2E0A39CCE88ACDE98ABDC99A9D997ABDB975D95429DCE85A2D48B
        A9DB919DCD84ADD5975D943EA1D484E7F1E188BB6693C7728DBF6D88B66AD0E6
        C2F8FBF6629C374A772A558730578A3295D169D4E4C86DAA3B41672472B33F6F
        AC3D659E38669E38629B375A8E32598A3153822E4A742951793189CB5785BD59
        75A451658B4663884597B97B9BBD817B93689DAD90CED7C7EEF3EA84CA4776B7
        4075B53F6BA53A689E376092334A72287FC3455E9133517C2C537E2D4468257D
        BC444569268BCE51B2C5A2D6E0CDCFD7C8E3EBDC496D2651782B4F74294D6F28
        EAEFE54C6C26496725476324F5F7F2FEFEFEFBFBFBF7F7F7FFFFFF0000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000000000000021F9040100008B002C
        000000000F000F000008BB0017091C48B0A04108211E182C58A0450D1604160E
        146143460E12121735704103C68F1D0B162A303123860F224E541C30E800870E
        1E419804A012A1A081153D861C59B22680192009084E1052A44992310106C5C1
        0262E0801B4A9004F0C327C01E3A6F8C081038628A98338702882DC365CB9313
        8B1884D183070E993E01D47C89C2A50B180428D8CC71A3C58B953468E4D4B103
        28D08B126DAE54C922054A9E3B7F04112A6428C5220F19346CA870810306091D
        2C50F8B02820003B}
      ShowHint = True
      Transparent = True
    end
    object lLargo: TLabel
      Left = 28
      Top = 11
      Width = 5
      Height = 13
      Hint = 'Posiciones largas cerradas'
      Caption = 'L'
      ParentShowHint = False
      ShowHint = True
    end
    object Label36: TLabel
      Left = 27
      Top = 39
      Width = 7
      Height = 13
      Hint = 'Posiciones cortas cerradas'
      Caption = 'C'
      ParentShowHint = False
      ShowHint = True
    end
    object gCerradoPerdidasLargos: TGauge
      Left = 38
      Top = 16
      Width = 56
      Height = 14
      Hint = 
        '% de n'#250'mero de posiciones largas con p'#233'rdidas sobre el total de ' +
        'n'#250'mero de posiciones cerradas'
      BackColor = clSilver
      ForeColor = 8421631
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      Progress = 0
      ShowHint = True
    end
    object gCerradoGananciasCortos: TGauge
      Left = 38
      Top = 32
      Width = 56
      Height = 14
      Hint = 
        '% de n'#250'mero de posiciones cortas con ganancias sobre el total de' +
        ' n'#250'mero de posiciones cerradas'
      BackColor = clSilver
      ForeColor = 8454016
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      Progress = 0
      ShowHint = True
    end
    object gCerradoPerdidasCortos: TGauge
      Left = 38
      Top = 47
      Width = 56
      Height = 14
      Hint = 
        '% de n'#250'mero de posiciones cortas con p'#233'rdidas sobre el total de ' +
        'n'#250'mero de posiciones cerradas'
      BackColor = clSilver
      ForeColor = 8421631
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      Progress = 0
      ShowHint = True
    end
    object gCerradoGananciasLargos: TGauge
      Left = 38
      Top = 1
      Width = 56
      Height = 14
      Hint = 
        '% de n'#250'mero de posiciones largas con ganancias sobre el total de' +
        ' n'#250'mero de posiciones cerradas'
      BackColor = clSilver
      ForeColor = 8454016
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      Progress = 0
      ShowHint = True
    end
    object lCerradoGananciasLargos: TLabel
      Left = 97
      Top = 2
      Width = 3
      Height = 13
      Hint = 
        'Media de ganancias cerradas en posiciones largas para el mercado' +
        ' en curso'
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object lCerradoPerdidasLargos: TLabel
      Left = 97
      Top = 16
      Width = 3
      Height = 13
      Hint = 
        'Media de p'#233'rdidas cerradas en posiciones largas para el mercado ' +
        'en curso'
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object lCerradoGananciasCortos: TLabel
      Left = 97
      Top = 32
      Width = 3
      Height = 13
      Hint = 
        'Media de ganancias cerradas en posiciones cortas para el mercado' +
        ' en curso'
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object lCerradoPerdidasCortos: TLabel
      Left = 97
      Top = 47
      Width = 3
      Height = 13
      Hint = 
        'Media de p'#233'rdidas cerradas en posiciones largas para el mercado ' +
        'en curso'
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
  end
end
