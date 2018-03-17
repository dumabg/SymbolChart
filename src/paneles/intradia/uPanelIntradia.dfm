inherited frPanelIntradia: TfrPanelIntradia
  Width = 343
  Height = 153
  ExplicitWidth = 343
  ExplicitHeight = 153
  object TBXToolWindow: TSpTBXToolWindow
    Left = 0
    Top = 0
    Width = 343
    Height = 153
    Caption = 'TBXToolWindow'
    Color = 16054521
    Align = alClient
    CloseButtonWhenDocked = True
    TabOrder = 0
    ClientAreaHeight = 153
    ClientAreaWidth = 343
    object pIntradia: TPanel
      Left = 0
      Top = 0
      Width = 217
      Height = 153
      Align = alLeft
      BevelOuter = bvNone
      Color = 16054521
      TabOrder = 0
      DesignSize = (
        217
        153)
      object Shape11: TShape
        Left = 1
        Top = 99
        Width = 215
        Height = 50
        Brush.Color = 14286847
        ParentShowHint = False
        Pen.Style = psClear
        ShowHint = False
      end
      object Shape8: TShape
        Left = 68
        Top = 16
        Width = 72
        Height = 83
        Brush.Color = 15466472
        ParentShowHint = False
        Pen.Style = psClear
        ShowHint = False
      end
      object Shape10: TShape
        Left = 141
        Top = 16
        Width = 67
        Height = 83
        Brush.Color = 15790335
        Pen.Style = psClear
      end
      object MaximoPrevistoAprox: TDBText
        Left = 70
        Top = 60
        Width = 65
        Height = 14
        Hint = '% de aproximaci'#243'n respecto del m'#225'ximo previsto y el m'#225'ximo real'
        Alignment = taRightJustify
        DataField = 'MAXIMO_PREVISTO_APROX'
        DataSource = dsCotizacionEstado
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        Transparent = True
        ShowHint = True
      end
      object Label24: TLabel
        Left = 89
        Top = 3
        Width = 41
        Height = 13
        AutoSize = False
        Caption = 'M'#225'ximos'
      end
      object Label91: TLabel
        Left = 8
        Top = 20
        Width = 45
        Height = 13
        Caption = 'Se previ'#243
        Transparent = True
      end
      object Label92: TLabel
        Left = 8
        Top = 40
        Width = 32
        Height = 13
        Caption = 'Reales'
        Transparent = True
      end
      object Label93: TLabel
        Left = 8
        Top = 60
        Width = 43
        Height = 13
        Caption = 'Aproxim.'
        Transparent = True
      end
      object Label94: TLabel
        Left = 8
        Top = 80
        Width = 44
        Height = 13
        Caption = 'Previstos'
        Transparent = True
      end
      object MaximoFuturo: TDBText
        Left = 70
        Top = 80
        Width = 65
        Height = 14
        Hint = 'M'#225'ximo previsto para la pr'#243'xima sesi'#243'n'
        Alignment = taRightJustify
        DataField = 'MAXIMO_PREVISTO'
        DataSource = dsCotizacionEstado
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        Transparent = True
        ShowHint = True
      end
      object MaximoHistorico: TDBText
        Left = 70
        Top = 40
        Width = 65
        Height = 14
        Hint = 'M'#225'ximo de la sesi'#243'n'
        Alignment = taRightJustify
        DataField = 'MAXIMO'
        DataSource = dsCotizacion
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        Transparent = True
        ShowHint = True
      end
      object MaximoPrevisto: TDBText
        Left = 70
        Top = 20
        Width = 65
        Height = 14
        Hint = 'M'#225'ximo que se prevey'#243' para este d'#237'a en la sesi'#243'n anterior'
        Alignment = taRightJustify
        DataField = 'MAXIMO_SE_PREVINO'
        DataSource = dsCotizacionEstado
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        Transparent = True
        ShowHint = True
      end
      object MinimoFuturo: TDBText
        Left = 141
        Top = 80
        Width = 65
        Height = 14
        Hint = 'M'#237'nimo previsto para la pr'#243'xima sesi'#243'n'
        Alignment = taRightJustify
        DataField = 'MINIMO_PREVISTO'
        DataSource = dsCotizacionEstado
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        Transparent = True
        ShowHint = True
      end
      object MinimoHistorico: TDBText
        Left = 141
        Top = 40
        Width = 65
        Height = 14
        Hint = 'M'#237'nimo de la sesi'#243'n'
        Alignment = taRightJustify
        DataField = 'MINIMO'
        DataSource = dsCotizacion
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        Transparent = True
        ShowHint = True
      end
      object MinimoPrevisto: TDBText
        Left = 141
        Top = 20
        Width = 65
        Height = 14
        Hint = 'M'#237'nimo que se prevey'#243' para este d'#237'a en la sesi'#243'n anterior'
        Alignment = taRightJustify
        DataField = 'MINIMO_SE_PREVINO'
        DataSource = dsCotizacionEstado
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        Transparent = True
        ShowHint = True
      end
      object MinimoPrevistoAprox: TDBText
        Left = 141
        Top = 60
        Width = 65
        Height = 14
        Hint = '% de aproximaci'#243'n respecto del m'#237'nimo previsto y el m'#237'nimo real'
        Alignment = taRightJustify
        DataField = 'MINIMO_PREVISTO_APROX'
        DataSource = dsCotizacionEstado
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        Transparent = True
        ShowHint = True
      end
      object Label31: TLabel
        Left = 2
        Top = 103
        Width = 78
        Height = 13
        Caption = 'Ambiente sesi'#243'n'
        Transparent = True
      end
      object FechaEstado2: TDBText
        Left = 83
        Top = 103
        Width = 82
        Height = 13
        Hint = 'Sesi'#243'n actual'
        Anchors = [akTop, akRight]
        AutoSize = True
        DataField = 'FECHA'
        DataSource = dsCotizacion
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object Label2: TLabel
        Left = 159
        Top = 3
        Width = 40
        Height = 13
        AutoSize = False
        Caption = 'M'#237'nimos'
      end
      object Label28: TLabel
        Left = 9
        Top = 3
        Width = 46
        Height = 13
        Caption = 'Intrad'#237'a'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lAmbienteIntradia: TLabel
        Left = 3
        Top = 120
        Width = 210
        Height = 25
        AutoSize = False
        Color = clWhite
        ParentColor = False
        Transparent = False
        WordWrap = True
      end
    end
    object pPivotPoints: TPanel
      Left = 224
      Top = 0
      Width = 119
      Height = 153
      Align = alRight
      BevelOuter = bvNone
      Color = 16054521
      ParentBackground = False
      TabOrder = 1
      object Label26: TLabel
        Left = 7
        Top = 1
        Width = 104
        Height = 16
        Alignment = taCenter
        AutoSize = False
        Caption = 'Pivot Points'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label34: TLabel
        Left = 32
        Top = 14
        Width = 54
        Height = 13
        AutoSize = False
        Caption = 'Previsiones'
      end
      object Panel6: TPanel
        Left = 11
        Top = 29
        Width = 100
        Height = 55
        BevelOuter = bvNone
        Color = 15466472
        ParentBackground = False
        TabOrder = 0
        object Label42: TLabel
          Left = 4
          Top = 2
          Width = 22
          Height = 13
          Hint = '3'#170' resistencia'
          AutoSize = False
          Caption = 'R3:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          Transparent = True
        end
        object Label43: TLabel
          Left = 4
          Top = 20
          Width = 22
          Height = 13
          Hint = '2'#170' resistencia'
          AutoSize = False
          Caption = 'R2:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          Transparent = True
        end
        object Label44: TLabel
          Left = 4
          Top = 38
          Width = 22
          Height = 13
          Hint = '1'#170' resistencia'
          AutoSize = False
          Caption = 'R1:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          Transparent = True
        end
        object PivotR3: TDBText
          Left = 30
          Top = 2
          Width = 66
          Height = 14
          Hint = '3'#170' resistencia del pivot point'
          Alignment = taCenter
          DataField = 'PIVOT_POINT_R3'
          DataSource = dsCotizacionEstado
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          Transparent = True
          ShowHint = True
        end
        object PivotR2: TDBText
          Left = 30
          Top = 20
          Width = 66
          Height = 14
          Hint = '2'#170' resistencia del pivot point'
          Alignment = taCenter
          DataField = 'PIVOT_POINT_R2'
          DataSource = dsCotizacionEstado
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          Transparent = True
          ShowHint = True
        end
        object PivotR1: TDBText
          Left = 30
          Top = 38
          Width = 66
          Height = 14
          Hint = '1'#170' resistencia del pivot point'
          Alignment = taCenter
          DataField = 'PIVOT_POINT_R1'
          DataSource = dsCotizacionEstado
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          Transparent = True
          ShowHint = True
        end
      end
      object Panel7: TPanel
        Left = 11
        Top = 97
        Width = 100
        Height = 53
        BevelOuter = bvNone
        Color = 15790335
        ParentBackground = False
        TabOrder = 2
        object Label37: TLabel
          Left = 4
          Top = 4
          Width = 22
          Height = 13
          Hint = '1er soporte'
          AutoSize = False
          Caption = 'S1:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          Transparent = True
        end
        object Label41: TLabel
          Left = 4
          Top = 22
          Width = 22
          Height = 13
          Hint = '2'#186' soporte'
          AutoSize = False
          Caption = 'S2:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          Transparent = True
        end
        object Label46: TLabel
          Left = 4
          Top = 38
          Width = 22
          Height = 13
          Hint = '3er soporte'
          AutoSize = False
          Caption = 'S3:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          Transparent = True
        end
        object PivotS1: TDBText
          Left = 30
          Top = 4
          Width = 66
          Height = 14
          Hint = '1er soporte del pivot point'
          Alignment = taCenter
          DataField = 'PIVOT_POINT_S1'
          DataSource = dsCotizacionEstado
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          Transparent = True
          ShowHint = True
        end
        object PivotS2: TDBText
          Left = 30
          Top = 22
          Width = 66
          Height = 14
          Hint = '2'#186' soporte del pivot point'
          Alignment = taCenter
          DataField = 'PIVOT_POINT_S2'
          DataSource = dsCotizacionEstado
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          Transparent = True
          ShowHint = True
        end
        object PivotS3: TDBText
          Left = 30
          Top = 38
          Width = 66
          Height = 14
          Hint = '3er soporte del pivot point'
          Alignment = taCenter
          DataField = 'PIVOT_POINT_S3'
          DataSource = dsCotizacionEstado
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          Transparent = True
          ShowHint = True
        end
      end
      object Panel8: TPanel
        Left = 11
        Top = 84
        Width = 97
        Height = 15
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 1
        object Label35: TLabel
          Left = 4
          Top = 1
          Width = 22
          Height = 13
          Hint = 'Pivot point'
          AutoSize = False
          Caption = 'PP:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          Transparent = True
        end
        object Pivot: TDBText
          Left = 30
          Top = 0
          Width = 66
          Height = 14
          Hint = 'Pivot point'
          Alignment = taCenter
          DataField = 'PIVOT_POINT'
          DataSource = dsCotizacionEstado
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ParentShowHint = False
          Transparent = True
          ShowHint = True
        end
      end
    end
  end
  object dsCotizacion: TDataSource
    DataSet = Data.Cotizacion
    Left = 96
    Top = 72
  end
  object dsCotizacionEstado: TDataSource
    DataSet = Data.CotizacionEstado
    Left = 248
    Top = 96
  end
end
