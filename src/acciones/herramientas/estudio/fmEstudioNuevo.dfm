inherited fEstudioNuevo: TfEstudioNuevo
  ActiveControl = eNombre
  BorderStyle = bsDialog
  Caption = 'Estudio nuevo'
  ClientHeight = 488
  ClientWidth = 715
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 721
  ExplicitHeight = 520
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 254
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Crear'
    ModalResult = 1
    TabOrder = 1
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object BitBtn2: TBitBtn
    Left = 366
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 2
    Kind = bkCancel
  end
  object JvWizardEstudio: TJvWizard
    Left = 0
    Top = 0
    Width = 715
    Height = 488
    ActivePage = PageNombre
    ButtonBarHeight = 42
    ButtonStart.Caption = 'To &Start Page'
    ButtonStart.NumGlyphs = 1
    ButtonStart.Width = 85
    ButtonLast.Caption = 'To &Last Page'
    ButtonLast.NumGlyphs = 1
    ButtonLast.Width = 85
    ButtonBack.Caption = '< &Anterior'
    ButtonBack.NumGlyphs = 1
    ButtonBack.Width = 75
    ButtonNext.Caption = '&Siguiente >'
    ButtonNext.NumGlyphs = 1
    ButtonNext.Width = 75
    ButtonFinish.Caption = '&Finalizar'
    ButtonFinish.NumGlyphs = 1
    ButtonFinish.Width = 75
    ButtonCancel.Caption = 'Cancelar'
    ButtonCancel.NumGlyphs = 1
    ButtonCancel.ModalResult = 2
    ButtonCancel.Width = 75
    ButtonHelp.Caption = '&Help'
    ButtonHelp.NumGlyphs = 1
    ButtonHelp.Width = 75
    ShowRouteMap = True
    DesignSize = (
      715
      488)
    object PageNombre: TJvWizardInteriorPage
      Header.ParentFont = False
      Header.Title.Color = clNone
      Header.Title.Text = 'Par'#225'metros'
      Header.Title.Anchors = [akLeft, akTop, akRight]
      Header.Title.Font.Charset = DEFAULT_CHARSET
      Header.Title.Font.Color = clWindowText
      Header.Title.Font.Height = -16
      Header.Title.Font.Name = 'MS Sans Serif'
      Header.Title.Font.Style = [fsBold]
      Header.Subtitle.Color = clNone
      Header.Subtitle.Text = 'Especifique los par'#225'metros del estudio'
      Header.Subtitle.Anchors = [akLeft, akTop, akRight, akBottom]
      Header.Subtitle.Font.Charset = DEFAULT_CHARSET
      Header.Subtitle.Font.Color = clWindowText
      Header.Subtitle.Font.Height = -11
      Header.Subtitle.Font.Name = 'MS Sans Serif'
      Header.Subtitle.Font.Style = []
      EnabledButtons = [bkStart, bkLast, bkFinish, bkCancel, bkHelp]
      object Label1: TLabel
        Left = 24
        Top = 99
        Width = 37
        Height = 13
        Caption = 'Nombre'
      end
      object Label2: TLabel
        Left = 24
        Top = 126
        Width = 56
        Height = 13
        Caption = 'Descripci'#243'n'
      end
      object Label3: TLabel
        Left = 24
        Top = 194
        Width = 47
        Height = 13
        Caption = 'Estrategia'
      end
      object Label5: TLabel
        Left = 24
        Top = 285
        Width = 187
        Height = 13
        Caption = 'Inversi'#243'n en paquetes de como m'#225'ximo'
      end
      object Label6: TLabel
        Left = 321
        Top = 194
        Width = 31
        Height = 13
        Caption = 'Broker'
      end
      object lMoneda: TLabel
        Left = 274
        Top = 285
        Width = 6
        Height = 13
        Caption = #8364
      end
      object Label10: TLabel
        Left = 57
        Top = 349
        Width = 499
        Height = 39
        Caption = 
          'En el mercado USA el n'#250'mero m'#237'nimo de acciones a comprar para en' +
          'trar en un valor es de 100 acciones. En caso de querer comprar m' +
          'enos de 100, el mercado espera a que haya otras peticiones y no ' +
          'realiza la compra hasta que haya un grupo de 100 acciones.'
        WordWrap = True
      end
      object Label11: TLabel
        Left = 24
        Top = 246
        Width = 81
        Height = 13
        Caption = 'Moneda principal'
      end
      object Image2: TImage
        Left = 35
        Top = 349
        Width = 16
        Height = 14
        AutoSize = True
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
        Transparent = True
      end
      object eNombre: TEdit
        Left = 91
        Top = 96
        Width = 195
        Height = 21
        MaxLength = 30
        TabOrder = 0
        OnKeyUp = eNombreKeyUp
      end
      object mDescripcion: TMemo
        Left = 91
        Top = 123
        Width = 462
        Height = 46
        MaxLength = 300
        TabOrder = 1
      end
      object scbTipo: TJvDBSearchComboBox
        Left = 91
        Top = 191
        Width = 195
        Height = 21
        DataField = 'NOMBRE'
        DataSource = dsEstrategias
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
      end
      object ePaquetes: TJvSpinEdit
        Left = 219
        Top = 282
        Width = 50
        Height = 21
        CheckMaxValue = False
        Decimal = 0
        MinValue = 1.000000000000000000
        ShowButton = False
        Value = 3000.000000000000000000
        TabOrder = 5
      end
      object scbBroker: TJvDBSearchComboBox
        Left = 358
        Top = 191
        Width = 195
        Height = 21
        DataField = 'NOMBRE'
        DataSource = dsBroker
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
      end
      object cbUSA100: TCheckBox
        Left = 24
        Top = 326
        Width = 270
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Realizar paquetes de 100 acciones en valores USA'
        Checked = True
        State = cbChecked
        TabOrder = 6
      end
      object cbMonedas: TComboBox
        Left = 110
        Top = 243
        Width = 74
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 4
        OnChange = cbMonedasChange
      end
    end
    object PagePeriodo: TJvWizardInteriorPage
      Header.ParentFont = False
      Header.Title.Color = clNone
      Header.Title.Text = 'Periodo'
      Header.Title.Anchors = [akLeft, akTop, akRight]
      Header.Title.Font.Charset = DEFAULT_CHARSET
      Header.Title.Font.Color = clWindowText
      Header.Title.Font.Height = -16
      Header.Title.Font.Name = 'MS Sans Serif'
      Header.Title.Font.Style = [fsBold]
      Header.Subtitle.Color = clNone
      Header.Subtitle.Text = 'Seleccione el periodo en el que quiere realizar el estudio'
      Header.Subtitle.Anchors = [akLeft, akTop, akRight, akBottom]
      Header.Subtitle.Font.Charset = DEFAULT_CHARSET
      Header.Subtitle.Font.Color = clWindowText
      Header.Subtitle.Font.Height = -11
      Header.Subtitle.Font.Name = 'MS Sans Serif'
      Header.Subtitle.Font.Style = []
      VisibleButtons = [bkBack, bkFinish, bkCancel]
      OnFinishButtonClick = PagePeriodoFinishButtonClick
      inline fSeleccionFechas: TfSeleccionFechas
        Left = 28
        Top = 76
        Width = 533
        Height = 364
        TabOrder = 0
        ExplicitLeft = 28
        ExplicitTop = 76
        inherited PanelDesde: TPanel
          Left = 0
          ExplicitLeft = 0
          inherited Label5: TLabel
            Width = 116
            ExplicitWidth = 116
          end
          inherited ePrincipioAno: TEdit
            TabOrder = 1
          end
          inherited SeleccionAno: TUpDown
            TabOrder = 2
          end
          inherited CalendarioDesde: TframeCalendario
            TabOrder = 0
            inherited Panel1: TPanel
              ExplicitLeft = 0
            end
          end
        end
        inherited PanelHasta: TPanel
          inherited Label7: TLabel
            Width = 116
            ExplicitWidth = 116
          end
        end
      end
    end
    object JvWizardRouteMapNodes1: TJvWizardRouteMapNodes
      Left = 0
      Top = 0
      Width = 145
      Height = 446
      Color = clNavy
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
  end
  object dsEstrategias: TDataSource
    DataSet = EstudioNuevo.qEstrategias
    Left = 336
    Top = 168
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
      end
      item
      end
      item
        Items = <
          item
            Caption = '-'
          end>
      end
      item
        Items = <
          item
            Caption = '-'
          end>
      end
      item
      end
      item
      end
      item
        Items = <
          item
            Caption = '-'
          end
          item
            Action = SelecTodo
            ImageIndex = 3
            ShowCaption = False
          end
          item
            Action = SelecNinguno
            ImageIndex = 4
            ShowCaption = False
          end
          item
            Action = SelecInvert
            ImageIndex = 5
            ShowCaption = False
          end>
      end
      item
      end
      item
        Items = <
          item
            Action = SelecTodo
            ImageIndex = 0
            ShowCaption = False
          end
          item
            Action = SelecNinguno
            ImageIndex = 1
            ShowCaption = False
          end
          item
            Action = SelecInvert
            ImageIndex = 2
            ShowCaption = False
          end>
      end
      item
        Items = <
          item
            Caption = '-'
          end>
      end
      item
        Items = <
          item
            Action = SelecTodo
            ImageIndex = 0
            ShowCaption = False
          end
          item
            Action = SelecNinguno
            ImageIndex = 1
            ShowCaption = False
          end
          item
            Action = SelecInvert
            ImageIndex = 2
            ShowCaption = False
          end>
      end
      item
        Items = <
          item
            Action = SelecTodo
            ImageIndex = 0
            ShowCaption = False
          end
          item
            Action = SelecNinguno
            ImageIndex = 1
            ShowCaption = False
          end
          item
            Action = SelecInvert
            ImageIndex = 2
            ShowCaption = False
          end>
      end>
    Left = 76
    Top = 208
    StyleName = 'XP Style'
    object SelecTodo: TAction
      Category = 'Seleccion'
      Caption = 'SelecTodo'
      Hint = 'Seleccionar todos los valores'
      ImageIndex = 0
    end
    object SelecNinguno: TAction
      Category = 'Seleccion'
      Caption = 'SelecNinguno'
      Hint = 'No seleccionar ning'#250'n valor'
      ImageIndex = 1
    end
    object SelecInvert: TAction
      Category = 'Seleccion'
      Caption = 'SelecInvert'
      Hint = 'Invertir la selecci'#243'n'
      ImageIndex = 2
    end
  end
  object dsBroker: TDataSource
    DataSet = EstudioNuevo.qBroker
    Left = 544
    Top = 344
  end
end
