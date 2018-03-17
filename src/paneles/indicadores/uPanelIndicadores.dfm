inherited frPanelIndicadores: TfrPanelIndicadores
  Width = 326
  ExplicitWidth = 326
  object TBXToolWindow: TSpTBXToolWindow
    Left = 0
    Top = 0
    Width = 326
    Height = 155
    Color = 16054521
    Align = alClient
    CloseButtonWhenDocked = True
    TabOrder = 0
    ClientAreaHeight = 155
    ClientAreaWidth = 326
    object PanelDobsonFractal: TPanel
      Left = 0
      Top = 84
      Width = 326
      Height = 71
      Align = alClient
      BevelOuter = bvNone
      Color = 15790320
      TabOrder = 1
      object Shape4: TShape
        Left = 109
        Top = 4
        Width = 229
        Height = 65
        Brush.Color = 16775673
        ParentShowHint = False
        Pen.Style = psClear
        ShowHint = False
      end
      object Shape3: TShape
        Left = 16
        Top = 3
        Width = 74
        Height = 66
        Brush.Color = 16775673
        ParentShowHint = False
        Pen.Style = psClear
        ShowHint = False
      end
      object OvcRotatedLabel1: TJvLabel
        Left = 94
        Top = 10
        Width = 16
        Height = 59
        AutoSize = False
        Caption = 'Dobson'
        Color = 16768477
        FrameColor = 16768477
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        RoundedFrame = 1
        Transparent = True
        Angle = 90
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Arial'
        HotTrackFont.Style = []
      end
      object DobsonAlzaDoble130: TDBText
        Left = 160
        Top = 12
        Width = 30
        Height = 15
        Hint = 'Dobson de 130 si sube el doble'
        Alignment = taCenter
        DataField = 'DOBSON_ALTO_130'
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
      object DobsonAlzaDoble100: TDBText
        Left = 194
        Top = 12
        Width = 30
        Height = 15
        Hint = 'Dobson de 100 si sube el doble'
        Alignment = taCenter
        DataField = 'DOBSON_ALTO_100'
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
      object DobsonAlzaDoble70: TDBText
        Left = 228
        Top = 12
        Width = 30
        Height = 15
        Hint = 'Dobson de 70 si sube el doble'
        Alignment = taCenter
        DataField = 'DOBSON_ALTO_70'
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
      object DobsonAlzaDoble40: TDBText
        Left = 261
        Top = 12
        Width = 30
        Height = 15
        Hint = 'Dobson de 40 si sube el doble'
        Alignment = taCenter
        DataField = 'DOBSON_ALTO_40'
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
      object DobsonAlzaDoble10: TDBText
        Left = 293
        Top = 12
        Width = 30
        Height = 15
        Hint = 'Dobson de 10 si sube el doble'
        Alignment = taCenter
        DataField = 'DOBSON_ALTO_10'
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
      object Dobson130: TDBText
        Left = 160
        Top = 33
        Width = 30
        Height = 15
        Hint = 'Dobson de 130'
        Alignment = taCenter
        DataField = 'DOBSON_130'
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
      object DobsonBajaDoble100: TDBText
        Left = 194
        Top = 52
        Width = 30
        Height = 15
        Hint = 'Dobson de 100 si baja el doble'
        Alignment = taCenter
        DataField = 'DOBSON_BAJO_100'
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
      object Dobson100: TDBText
        Left = 194
        Top = 32
        Width = 30
        Height = 15
        Hint = 'Dobson de 100'
        Alignment = taCenter
        DataField = 'DOBSON_100'
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
      object Dobson70: TDBText
        Left = 228
        Top = 32
        Width = 30
        Height = 15
        Hint = 'Dobson de 70'
        Alignment = taCenter
        DataField = 'DOBSON_70'
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
      object DobsonBajaDoble10: TDBText
        Left = 293
        Top = 52
        Width = 30
        Height = 15
        Hint = 'Dobson de 10 si baja el doble'
        Alignment = taCenter
        DataField = 'DOBSON_BAJO_10'
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
      object DobsonBajaDoble130: TDBText
        Left = 160
        Top = 52
        Width = 30
        Height = 15
        Hint = 'Dobson de 130 si baja el doble'
        Alignment = taCenter
        DataField = 'DOBSON_BAJO_130'
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
      object Dobson40: TDBText
        Left = 261
        Top = 32
        Width = 30
        Height = 15
        Hint = 'Dobson de 40'
        Alignment = taCenter
        DataField = 'DOBSON_40'
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
      object Dobson10: TDBText
        Left = 293
        Top = 32
        Width = 30
        Height = 15
        Hint = 'Dobson de 10'
        Alignment = taCenter
        DataField = 'DOBSON_10'
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
      object DobsonBajaDoble70: TDBText
        Left = 228
        Top = 52
        Width = 30
        Height = 15
        Hint = 'Dobson de 70 si baja el doble'
        Alignment = taCenter
        DataField = 'DOBSON_BAJO_70'
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
      object DobsonBajaDoble40: TDBText
        Left = 261
        Top = 52
        Width = 30
        Height = 15
        Hint = 'Dobson de 40 si baja el doble'
        Alignment = taCenter
        DataField = 'DOBSON_BAJO_40'
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
      object Image9: TImage
        Left = 115
        Top = 51
        Width = 15
        Height = 10
        Hint = 'Baja doble'
        AutoSize = True
        ParentShowHint = False
        Picture.Data = {
          07544269746D6170D6040000424DD60400000000000036040000280000000F00
          00000A0000000100080000000000A0000000D30E0000D30E0000000100000001
          00000000C0004040FF000000FF000000FF000000C0000000FF004747F1000000
          4000000080008C8C8C004545E1001F1FF900FF00FF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF000C0C0C0C0C0C08080C0C0C0C0C0C0C000C0C0C0C0C070401000C0C0C0C0C
          0C000C0C0C0C070401010A000C0C0C0C0C000C0C0C07040101030105000C0C0C
          0C000C0C070401010301050306000C0C0C000C0704010103010503030306000C
          0C000704010103010503030303030B000C00070101010105020A0A06060B0B0B
          00000C000000000000000000000000000C000C0C0C0C0C0C0C0C0C0C0C0C0C0C
          0C00}
        ShowHint = True
        Transparent = True
      end
      object Bevel10: TBevel
        Left = 109
        Top = 4
        Width = 5
        Height = 65
        Shape = bsLeftLine
      end
      object OvcRotatedLabel4: TJvLabel
        Left = 1
        Top = 8
        Width = 16
        Height = 61
        AutoSize = False
        Caption = 'Bollinguer'
        Color = 16768477
        FrameColor = 16768477
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        RoundedFrame = 1
        Transparent = True
        Angle = 90
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Arial'
        HotTrackFont.Style = []
      end
      object Bevel11: TBevel
        Left = 16
        Top = 3
        Width = 9
        Height = 65
        Shape = bsLeftLine
      end
      object Nivel: TDBText
        Left = 140
        Top = 32
        Width = 16
        Height = 15
        Hint = 'Nivel actual'
        Alignment = taCenter
        Color = 15790320
        DataField = 'NIVEL_ACTUAL'
        DataSource = dsCotizacionEstado
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        Transparent = False
        ShowHint = True
      end
      object NivelBajada: TDBText
        Left = 140
        Top = 52
        Width = 16
        Height = 15
        Hint = 'Nivel si se produce una bajada doble'
        Alignment = taCenter
        DataField = 'NIVEL_BAJA'
        DataSource = dsCotizacionEstado
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        Transparent = False
        ShowHint = True
      end
      object NivelSubida: TDBText
        Left = 140
        Top = 12
        Width = 16
        Height = 15
        Hint = 'Nivel si se produce una alza doble'
        Alignment = taCenter
        Color = 15790320
        DataField = 'NIVEL_SUBE'
        DataSource = dsCotizacionEstado
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        Transparent = False
        ShowHint = True
      end
      object Image2: TImage
        Left = 112
        Top = 12
        Width = 17
        Height = 10
        Hint = 'Alza doble'
        AutoSize = True
        ParentShowHint = False
        Picture.Data = {
          07544269746D6170FE040000424DFE0400000000000036040000280000001100
          00000A0000000100080000000000C8000000C30E0000C30E0000000100000001
          0000007B000000DE000052FF000000FF080000BD290000FF2900ADFF29004A4A
          4A0063B563008C8C8C0052FFAD00ADFFAD00FF00FF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000C0C0000000000000000
          00000000000C0C0000000C000B0B0B06060A0A020501010101070C0000000C0C
          000B0303030303050103010104070C0000000C0C0C0006030303050103010104
          070C0C0000000C0C0C0C000603050103010104070C0C0C0000000C0C0C0C0C00
          050103010104070C0C0C0C0000000C0C0C0C0C0C000A010104070C0C0C0C0C00
          00000C0C0C0C0C0C0C000104070C0C0C0C0C0C0000000C0C0C0C0C0C0C0C0809
          0C0C0C0C0C0C0C000000}
        ShowHint = True
        Transparent = True
      end
      object Image4: TImage
        Left = 122
        Top = 56
        Width = 15
        Height = 10
        Hint = 'Baja doble'
        AutoSize = True
        ParentShowHint = False
        Picture.Data = {
          07544269746D6170D6040000424DD60400000000000036040000280000000F00
          00000A0000000100080000000000A0000000D30E0000D30E0000000100000001
          00000000C0004040FF000000FF000000FF000000C0000000FF004747F1000000
          4000000080008C8C8C004545E1001F1FF900FF00FF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF000C0C0C0C0C0C08080C0C0C0C0C0C0C000C0C0C0C0C070401000C0C0C0C0C
          0C000C0C0C0C070401010A000C0C0C0C0C000C0C0C07040101030105000C0C0C
          0C000C0C070401010301050306000C0C0C000C0704010103010503030306000C
          0C000704010103010503030303030B000C00070101010105020A0A06060B0B0B
          00000C000000000000000000000000000C000C0C0C0C0C0C0C0C0C0C0C0C0C0C
          0C00}
        ShowHint = True
        Transparent = True
      end
      object Image1: TImage
        Left = 118
        Top = 16
        Width = 17
        Height = 10
        Hint = 'Alza doble'
        AutoSize = True
        ParentShowHint = False
        Picture.Data = {
          07544269746D6170FE040000424DFE0400000000000036040000280000001100
          00000A0000000100080000000000C8000000C30E0000C30E0000000100000001
          0000007B000000DE000052FF000000FF080000BD290000FF2900ADFF29004A4A
          4A0063B563008C8C8C0052FFAD00ADFFAD00FF00FF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000C0C0000000000000000
          00000000000C0C0000000C000B0B0B06060A0A020501010101070C0000000C0C
          000B0303030303050103010104070C0000000C0C0C0006030303050103010104
          070C0C0000000C0C0C0C000603050103010104070C0C0C0000000C0C0C0C0C00
          050103010104070C0C0C0C0000000C0C0C0C0C0C000A010104070C0C0C0C0C00
          00000C0C0C0C0C0C0C000104070C0C0C0C0C0C0000000C0C0C0C0C0C0C0C0809
          0C0C0C0C0C0C0C000000}
        ShowHint = True
        Transparent = True
      end
      object BollinguerBaja: TDBText
        Left = 25
        Top = 54
        Width = 63
        Height = 13
        Hint = 'Banda baja de Bollinguer'
        DataField = 'BANDA_BAJA'
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
      object BollinguerAlta: TDBText
        Left = 26
        Top = 22
        Width = 62
        Height = 13
        Hint = 'Banda alta de Bollinguer'
        DataField = 'BANDA_ALTA'
        DataSource = dsCotizacionEstado
        DragMode = dmAutomatic
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
      object Label3: TLabel
        Left = 25
        Top = 6
        Width = 51
        Height = 13
        Caption = 'Banda alta'
        Transparent = True
      end
      object Label4: TLabel
        Left = 25
        Top = 38
        Width = 54
        Height = 13
        Caption = 'Banda baja'
        Transparent = True
      end
    end
    object PanelIncrementos: TPanel
      Left = 0
      Top = 0
      Width = 326
      Height = 84
      Align = alTop
      BevelOuter = bvNone
      Color = 15790320
      TabOrder = 0
      object Shape7: TShape
        Left = 17
        Top = 2
        Width = 100
        Height = 42
        Brush.Color = 16775673
        ParentShowHint = False
        Pen.Style = psClear
        ShowHint = False
      end
      object Shape6: TShape
        Left = 135
        Top = 0
        Width = 187
        Height = 86
        Brush.Color = 16775673
        ParentShowHint = False
        Pen.Style = psClear
        ShowHint = False
      end
      object Shape5: TShape
        Left = 16
        Top = 46
        Width = 100
        Height = 40
        Brush.Color = 16775673
        ParentShowHint = False
        Pen.Style = psClear
        ShowHint = False
      end
      object Bevel6: TBevel
        Left = 133
        Top = 3
        Width = 7
        Height = 80
        Shape = bsLeftLine
      end
      object OvcRotatedLabel3: TJvLabel
        Left = 117
        Top = 5
        Width = 16
        Height = 79
        AutoSize = False
        Caption = 'Incrementos'
        Color = 16768477
        FrameColor = 16768477
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        RoundedFrame = 1
        Transparent = True
        Angle = 90
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Arial'
        HotTrackFont.Style = []
      end
      object Label33: TLabel
        Left = 139
        Top = 48
        Width = 54
        Height = 13
        Caption = 'Variabilidad'
        Transparent = True
      end
      object Label32: TLabel
        Left = 139
        Top = 30
        Width = 48
        Height = 13
        Caption = 'Volatilidad'
        Transparent = True
      end
      object Volatilidad: TDBText
        Left = 198
        Top = 29
        Width = 49
        Height = 17
        Hint = 'Volatilidad'
        DataField = 'VOLATILIDAD'
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
      object Variabilidad: TDBText
        Left = 198
        Top = 48
        Width = 48
        Height = 17
        Hint = 'Variabilidad'
        DataField = 'VARIABILIDAD'
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
      object RSILargo: TDBText
        Left = 56
        Top = 50
        Width = 47
        Height = 13
        Hint = 'RSI largo (140 d'#237'as)'
        DataField = 'RSI_140'
        DataSource = dsCotizacionEstado
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object RSICorto: TDBText
        Left = 56
        Top = 68
        Width = 47
        Height = 14
        Hint = 'RSI corto (14 d'#237'as)'
        DataField = 'RSI_14'
        DataSource = dsCotizacionEstado
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object Label19: TLabel
        Left = 139
        Top = 7
        Width = 49
        Height = 13
        Caption = 'Media 200'
        Transparent = True
      end
      object Bevel1: TBevel
        Left = 254
        Top = 7
        Width = 7
        Height = 72
        Shape = bsLeftLine
      end
      object Media200: TDBText
        Left = 198
        Top = 7
        Width = 65
        Height = 17
        Hint = 'Media m'#243'vil de 200'
        DataField = 'MEDIA_200'
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
      object Label6: TLabel
        Left = 23
        Top = 50
        Width = 27
        Height = 13
        Hint = 'RSI largo (140 d'#237'as)'
        Caption = 'Largo'
        Transparent = True
      end
      object Label20: TLabel
        Left = 25
        Top = 68
        Width = 27
        Height = 13
        Hint = 'RSI corto (14 d'#237'as)'
        Caption = 'Corto'
        Transparent = True
      end
      object lRSI: TJvLabel
        Left = 2
        Top = 50
        Width = 15
        Height = 34
        AutoSize = False
        Caption = 'RSI'
        Color = 16768477
        FrameColor = 16768477
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        RoundedFrame = 1
        Transparent = True
        Angle = 90
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Arial'
        HotTrackFont.Style = []
      end
      object PotencialFractalSube: TImage
        Left = 56
        Top = 29
        Width = 17
        Height = 11
        Hint = 'Potencial fractal'
        Picture.Data = {
          07544269746D6170FE040000424DFE0400000000000036040000280000001100
          00000A0000000100080000000000C8000000C30E0000C30E0000000100000001
          0000007B000000DE000052FF000000FF080000BD290000FF2900ADFF29004A4A
          4A0063B563008C8C8C0052FFAD00ADFFAD00FF00FF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000C0C0000000000000000
          00000000000C0C0000000C000B0B0B06060A0A020501010101070C0000000C0C
          000B0303030303050103010104070C0000000C0C0C0006030303050103010104
          070C0C0000000C0C0C0C000603050103010104070C0C0C0000000C0C0C0C0C00
          050103010104070C0C0C0C0000000C0C0C0C0C0C000A010104070C0C0C0C0C00
          00000C0C0C0C0C0C0C000104070C0C0C0C0C0C0000000C0C0C0C0C0C0C0C0809
          0C0C0C0C0C0C0C000000}
        Transparent = True
      end
      object PotencialFractalBaja: TImage
        Left = 58
        Top = 28
        Width = 15
        Height = 10
        Hint = 'Potencial fractal'
        AutoSize = True
        ParentShowHint = False
        Picture.Data = {
          07544269746D6170D6040000424DD60400000000000036040000280000000F00
          00000A0000000100080000000000A0000000D30E0000D30E0000000100000001
          00000000C0004040FF000000FF000000FF000000C0000000FF004747F1000000
          4000000080008C8C8C004545E1001F1FF900FF00FF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF000C0C0C0C0C0C08080C0C0C0C0C0C0C000C0C0C0C0C070401000C0C0C0C0C
          0C000C0C0C0C070401010A000C0C0C0C0C000C0C0C07040101030105000C0C0C
          0C000C0C070401010301050306000C0C0C000C0704010103010503030306000C
          0C000704010103010503030303030B000C00070101010105020A0A06060B0B0B
          00000C000000000000000000000000000C000C0C0C0C0C0C0C0C0C0C0C0C0C0C
          0C00}
        ShowHint = True
        Transparent = True
      end
      object Label21: TLabel
        Left = 25
        Top = 8
        Width = 33
        Height = 13
        Hint = 'Dimensi'#243'n fractal'
        Caption = 'Dimen.'
        Transparent = True
      end
      object DimFractal: TDBText
        Left = 61
        Top = 8
        Width = 44
        Height = 15
        Hint = 'Dimensi'#243'n fractal'
        DataField = 'DIMENSION_FRACTAL'
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
      object Label23: TLabel
        Left = 25
        Top = 27
        Width = 32
        Height = 13
        Hint = 'Potencial fractal'
        Caption = 'Poten.'
        Transparent = True
      end
      object PotFractal: TDBText
        Left = 78
        Top = 27
        Width = 27
        Height = 15
        Hint = 'Potencial fractal'
        DataField = 'POTENCIAL_FRACTAL'
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
      object OvcRotatedLabel5: TJvLabel
        Left = 1
        Top = 5
        Width = 16
        Height = 39
        AutoSize = False
        Caption = 'Fractal'
        Color = 16768477
        FrameColor = 16768477
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        RoundedFrame = 1
        Transparent = True
        Angle = 90
        HotTrackFont.Charset = DEFAULT_CHARSET
        HotTrackFont.Color = clWindowText
        HotTrackFont.Height = -11
        HotTrackFont.Name = 'Arial'
        HotTrackFont.Style = []
      end
      object Bevel3: TBevel
        Left = 16
        Top = 47
        Width = 7
        Height = 37
        Shape = bsLeftLine
      end
      object Bevel4: TBevel
        Left = 16
        Top = 4
        Width = 7
        Height = 39
        Shape = bsLeftLine
      end
      object Label38: TLabel
        Left = 275
        Top = 6
        Width = 27
        Height = 13
        Hint = 'Cambio m'#225'ximo del gr'#225'fico'
        Alignment = taCenter
        AutoSize = False
        Caption = 'M'#225'x.'
        ParentShowHint = False
        ShowHint = False
        Transparent = True
      end
      object Maximo: TLabel
        Left = 259
        Top = 25
        Width = 60
        Height = 13
        Hint = 'Cambio m'#225'ximo del gr'#225'fico'
        Alignment = taCenter
        AutoSize = False
        Caption = '?'
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
      object Label39: TLabel
        Left = 280
        Top = 46
        Width = 20
        Height = 13
        Hint = 'Cambio m'#237'nimo del gr'#225'fico'
        Alignment = taCenter
        Caption = 'M'#237'n.'
        Transparent = True
      end
      object Minimo: TLabel
        Left = 259
        Top = 65
        Width = 62
        Height = 13
        Hint = 'Cambio m'#237'nimo del gr'#225'fico'
        Alignment = taCenter
        AutoSize = False
        Caption = '?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object Label49: TLabel
        Left = 139
        Top = 66
        Width = 48
        Height = 13
        Caption = 'Vol. / Var.'
        Transparent = True
      end
      object RelVolVar: TDBText
        Left = 199
        Top = 66
        Width = 48
        Height = 17
        Hint = 'Relaci'#243'n Volatilidad / Variabilidad'
        DataField = 'RELACION_VOL_VAR'
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
  object dsCotizacionEstado: TDataSource
    DataSet = Data.CotizacionEstado
    Left = 216
    Top = 48
  end
end
