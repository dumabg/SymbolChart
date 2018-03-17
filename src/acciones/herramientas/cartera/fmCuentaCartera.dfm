inherited fCuentaCartera: TfCuentaCartera
  inherited pcPosiciones: TPageControl
    ActivePage = tsPosicionesPendientes
    object tsCartera: TTabSheet [0]
      Caption = 'Cartera'
      ImageIndex = 6
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        785
        397)
      object lNombre: TLabel
        Left = 16
        Top = 24
        Width = 37
        Height = 13
        Caption = 'Nombre'
      end
      object Label4: TLabel
        Left = 192
        Top = 70
        Width = 61
        Height = 13
        Caption = 'Capital inicial'
      end
      object Label5: TLabel
        Left = 13
        Top = 109
        Width = 190
        Height = 13
        Caption = 'Inversi'#243'n en paquetes de como m'#225'ximo'
      end
      object Label3: TLabel
        Left = 64
        Top = 173
        Width = 645
        Height = 39
        Anchors = [akLeft, akTop, akRight]
        Caption = 
          'En el mercado USA el n'#250'mero m'#237'nimo de acciones para entrar en un' +
          ' valor es de 100 acciones. Para un n'#250'mero de acciones no m'#250'ltipl' +
          'o de 100, el mercado espera a que haya otras peticiones de otros' +
          ' inversores  y no realiza la operaci'#243'n hasta que haya un grupo d' +
          'e 100 acciones.'
        WordWrap = True
      end
      object Image2: TImage
        Left = 34
        Top = 176
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
      object dbtCapital: TDBText
        Left = 259
        Top = 70
        Width = 58
        Height = 13
        AutoSize = True
        DataField = 'CAPITAL'
        DataSource = dsCartera
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label1: TLabel
        Left = 15
        Top = 70
        Width = 80
        Height = 13
        Caption = 'Moneda principal'
      end
      object dbtMoneda: TDBText
        Left = 101
        Top = 70
        Width = 64
        Height = 13
        AutoSize = True
        DataField = 'MONEDA'
        DataSource = dsCartera
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 345
        Top = 70
        Width = 31
        Height = 13
        Caption = 'Broker'
      end
      object dbtBorker: TDBText
        Left = 382
        Top = 70
        Width = 57
        Height = 13
        AutoSize = True
        DataField = 'BROKER'
        DataSource = dsCartera
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtMoneda2: TDBText
        Left = 265
        Top = 109
        Width = 71
        Height = 13
        AutoSize = True
        DataField = 'MONEDA'
        DataSource = dsCartera
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object eNombre: TDBEdit
        Left = 67
        Top = 21
        Width = 214
        Height = 21
        DataField = 'NOMBRE'
        DataSource = dsCartera
        TabOrder = 0
        OnKeyDown = eNombreKeyDown
      end
      object ePaquetes: TJvDBSpinEdit
        Left = 209
        Top = 106
        Width = 50
        Height = 21
        CheckMaxValue = False
        Decimal = 0
        MinValue = 1.000000000000000000
        ShowButton = False
        TabOrder = 1
        DataField = 'PAQUETES'
        DataSource = dsCartera
      end
      object cbUSA100: TDBCheckBox
        Left = 13
        Top = 150
        Width = 270
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Realizar paquetes de 100 acciones en valores USA'
        DataField = 'USA100'
        DataSource = dsCartera
        TabOrder = 2
        ValueChecked = 'S'
        ValueUnchecked = 'N'
      end
    end
    object tsPosiblePosicionamiento: TTabSheet [1]
      Caption = 'Posible posicionamiento'
      ImageIndex = 5
      object pcPosiblePosicionamiento: TJvPageControl
        Left = 0
        Top = 28
        Width = 785
        Height = 369
        ActivePage = tsResultado
        Align = alClient
        TabOrder = 1
        HideAllTabs = True
        object tsInicial: TTabSheet
          ImageIndex = 2
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
        end
        object tsCalculando: TTabSheet
          inline frCalculando: TfrCalculando
            Left = 0
            Top = 0
            Width = 777
            Height = 81
            Align = alTop
            TabOrder = 0
            ExplicitWidth = 777
            ExplicitHeight = 81
            inherited pCargando: TPanel
              AlignWithMargins = True
              Left = 10
              Top = 10
              Width = 757
              Height = 68
              ExplicitLeft = 10
              ExplicitTop = 10
              ExplicitWidth = 757
              ExplicitHeight = 68
              inherited GIFCargando: TJvGIFAnimator
                Image.Data = {
                  7F0C000047494638396120002000B30000FFFFFFFF0000FEC6C6FE8484FEB6B6
                  FE9A9AFE3636FE5656FED8D8FEE4E4FEBCBCFE1E1EFE04040000000000000000
                  0021FF0B4E45545343415045322E30030100000021FE1A437265617465642077
                  69746820616A61786C6F61642E696E666F0021F904000A0000002C0000000020
                  0020000004E710C8496961A5EACDE7624B85249D460C15A35202419454B22C07
                  A53253E22A30352F2FC96DA270217A93C1CC301902103B24C53043019C2E0249
                  2A21FC4843284140116F0104832133395435BA5CD13829A80D87A060C1EEB4B2
                  6414077778473D59040A67140483774862861D7606413D923009565C9C5C883B
                  09020503A4A59C9F3BA5AA9B48A88AA2ABAC9DB31D9830B6B57425914873898B
                  72593C487F2E8113C589B79609BE9262BF135A1A62C74F45673A04987F47595D
                  2EC03DDA41DF4F519C7386E600EA5C62C3682E39EC3D7367F57F9E638CF365E2
                  1D12D82A128FD68666003744000021F904000A0000002C000000002000200000
                  04EA10C8496959A4EACDA7594635149D4690D4A25206C39454621847BA4A85BB
                  C0ECAC4CAA9D64E11AF02685596D781BE88E94C30C1504205C0C141440981912
                  80EAC1159A200804B0043118FC265283B1921348120A34013151B4DB7C560619
                  25027A047614047F236A30870A8E146C8C47677B307E03893C813C09845BA25B
                  87689178A5A147A9040A79A9A2A9A7AF87A3B6965B9E3097BA1BBC47B4911BA8
                  A650867A9C12C768C9BEA1C4986B7AC212691A97C908798EA0D1CA687C7AD568
                  9247DD84E256C5A2AF81E900EDB9EB5C6813E75BAF8EEF00C7A4888AF526952B
                  91A0579E37B738E019C821020021F904000A0000002C00000000200020000004
                  EE10C8492931A4EACDE7314735645D852895A152C7B29454328C946A4C847BC3
                  D33C20135BD035E04D14BEE00A30D0192985190A204CB816A4490286F06D85CD
                  45A8C76014B404057012A5550A0B81045E66142508825EB105C8E41D0206750C
                  3B13027A7A027D3084581B090A8953300365771D79046B3C079C25099F4FA3A3
                  89930991A67AA4AA7B92ADACAA7CA9AAA4B6A3A225B91C9ABB14BD46AF698C31
                  C2943088898087A6CBBC59B49B139AC338C4788ABF928C097A9FC940891289D7
                  3CDDAB00E2009AC7C1DEE3E800AFBE1BEC38F1E7593CAF8CEA12C9A50838F387
                  A75C87501524B5BBA52192C10D11000021F904000A0000002C00000000200020
                  000004E710C849A918A2EACD67194555109D9620D5A052876194544210D9A40E
                  13E1BE703E27B695A46508F5248899228803145C8723453143016E80C48E1483
                  C97ED7D5004A192C16DC2C41619508AA1A9D55775E3401492550DDDE080E750B
                  51163333027B30810669315485470567771C797D2503882527529C9D130CA0A1
                  0B05098E858C3DA1AA0CA6A79DAB0CA3A5A7339EB6479625B99470BABD30A60A
                  9913B34A526F853513C8863049C4A66D796B8804C378CD130854885F7DC8288F
                  0085D75EE2E2794B9D8E73B512EC9CE93E695FA8258ED5EE6EFA3DD912E2DACA
                  71D83465CD2D4DC2A444000021F904000A0000002C00000000200020000004EE
                  10C849292AA8EACD272945A5645D95901318A6C35052094108943A21ADFB7A72
                  9282939C6277930D2536802247A42864245B228792F84AB11EC04668AD900603
                  61121B5104508D6070251CC2862F4246505C63550DE20D3F54D07402572F7006
                  0747264F744405615F1C7304791D6C44274D9899130B9C9D71098A7463989DA5
                  0BA1A299A60B62A0A2329AB1440393904D030C0C3A1D91B51AB9B90B8F64A188
                  250206C00C067FA2342573290BC0BB9175830483453314B80CA300595580198B
                  0074DA96E6E691C6448A24E64A694DED3CE059E03B8AD8B0138098643C93204F
                  02827458F23C71272B11420E11000021F904000A0000002C0000000020002000
                  0004F310C8496952A9EACDA7224A25209D969014A1A645515AAA90AE12D212EF
                  4C64928AF72D59AEA60AF56882966BE851A17C80841235E17512BE0C3459F849
                  14830115ABA002044E0D62570B878D80759187359B0AEEC17282F609AC257962
                  1B173E5E25026F2F72761D6C39274C929313069697073B1F868739979F069B9C
                  93A0069985A394AA390380258D1C050B0B038B6939B3B3069D12A820430807B9
                  0B072286421D030C420406B9B54473138F14070C0C061403CE5E5804667D2450
                  09D70C7B4CDE3F5000CA0C0B949B4F34000BD7D0C045D3F304E5929B56EB2418
                  B8E6CA11016400024AD0232912850F705611C2C024020021F904000A0000002C
                  00000000200020000004EB10C8496952A9EACDA7224A85645D952015A152C25A
                  4E892A502A01ABE13BD524507B2A944E82C0ED5C45D090F221087F31554F32DD
                  4409995F723649F6620AA1A4E5D4C448979A380942973B09B2AC222708AA9C5A
                  DBDA74BD92621C804B2343274B888913038C8D05777D3F888D940391924B9503
                  8F697A368AA03A0378824B040606057F4143A8A8079F267D397F07AE0607747A
                  5C1D050B5C04B6A8AA4435183B78030B0BB91305A8B1518164280CD60009CB0B
                  B14B5712D60C12CA0B068A4D42E01306CB038849B4E91204DA884D3DF11207CB
                  A41B7313F8E2B8BD384461018305A14A1460404C47040021F904000A0000002C
                  00000000200020000004EF10C8496952A9EACDA7224A85645D952015A152C25A
                  4E892A502A01ABE13BD524507B2A944E82C0ED5C45D090F221087F31554F32DD
                  4409995F723649F6620AA1A4E5D4C448979A380942973B09B2AC222708AA9C5A
                  DBDA74BD92621C804B2343274B8889477A18697A36888F387D7A89928D947E8A
                  9B2558844B020303391D833AA2A881307DA4250905A80305747A5C1D04064208
                  B1A46C18630C031A030606074CA2625181060C0CC70BD10009C506908805CE0C
                  19D10B1205C5C7890BCEC200DD1307C5B34B03CEDE12E812B8C588E40CECE7D2
                  E9C5781CCE0628C89B50E09A0E58150C2C08C8E9D6827C2F22000021F904000A
                  0000002C00000000200020000004F010C8496952A9EACDA7224A85645D952015
                  A152C25A4E892A502A01ABE13BD524507B2A944E82C0ED5C45D090F221087F31
                  554F32DD4409995F723649F6620AA1A4E5D4C448979A380942973B09B2AC2227
                  08AA9C5ADBDA74BD92621C804B2343274B8889477A18697A36888F387D7A8992
                  8D947E8A9B25853A080784412F030C0C03437D181B040BA6A686755C1306AF0C
                  06B31B0203687D62A5A60B0544C21A040303C35D1F3D05A6A813070B0BA806D6
                  0009C803815629D30B19D606120ADA8A06D3D0E21305C8394303D3E312EB44E6
                  4BE80B9000F512EDBC4BA685A2758D09B712C72A1C303090531E03CA74440000
                  21F904000A0000002C00000000200020000004EB10C8496952A9EACDA7224A85
                  645D952015A152C25A4E892A502A01ABE13BD524507B2A944E82C0ED5C45D090
                  F221087F31554F32DD4409995F723649F6620AA1A4E5D4C448979A380942973B
                  09B2AC222708AA9C5ADBDA74BD92621C804B2343274B8889477A18050B0C9091
                  897A350A91970C93948D8F988A9F43853A090384412F030B0B05437D181B0406
                  AAAA86755C1307B30B07B71B45687D62A9AA06360008C51A5B14081F3D04AAA5
                  B80606A503D70057782629D40619D7D249398807D4AC00E1406F4305D40713EA
                  543F4BDEC6E9D81364DB1BEF14F25DF8C14237A1C00082A0360818D0AB440400
                  21F904000A0000002C00000000200020000004E810C8496952A9EACDA7224A85
                  645D952015A152C25A4E892A502A01ABE13BD524507B2A944E82C0ED5C45D090
                  F221087F31554F32DD4409995F723649F6080CC68015D4C448979A1030083316
                  05AAB39468D5B813839B61C0976A205512050B7B43496B1C6D624B2387634B91
                  9212803809847B61929538996E9B9518989993A5878256903A882F050606713A
                  4D811B0A07AFAF4375807E00B7B807891A4568B36BAEAF0736000903BD005B14
                  081F5FAFB183030336503C2F5508D90359484692E1393F124DC2250AE147CBCC
                  E943E16BF30076A81BD9F13E2E5DFA3614A9F02187290E17025688000021F904
                  000A0000002C00000000200020000004F010C8496952A9EACDA7224A85645D55
                  0C15A152C25A4E09C318944AC06AF84E32734B368F0AB19B0C648B491080C815
                  290B190A104CD848B057A1470C360902CA174B5818A61283ECA0B1922E36A264
                  B0A81B7E02067A9368D9C21407757507722F362058350683493B5F861C740B05
                  4F2345097B4F9B9B8839560706A2A39C9E39A3A8349D9E1804A1A99CB19B973B
                  5696432F0A030380B936181B08BBC3987E2ABD1227C3058A1A4D6F1FB812BABB
                  05806ECEC7621F58C2033A127E5D2B562ACD6D15E504194B5FE04FD1724B00F1
                  B34E402E00EA9BD164F9007ECE71D0A6E41F13811C1244A20742D68B0B083544
                  00003B}
              end
              inherited sbCancelar: TSpeedButton
                Left = 666
                ExplicitLeft = 541
              end
            end
          end
          object lbLog: TListBox
            Left = 0
            Top = 81
            Width = 777
            Height = 260
            Align = alClient
            ItemHeight = 13
            Items.Strings = (
              '')
            TabOrder = 1
            Visible = False
          end
        end
        object tsResultado: TTabSheet
          ImageIndex = 1
          object dbgPosiciones: TJvDBUltimGrid
            Left = 0
            Top = 0
            Width = 777
            Height = 341
            Align = alClient
            DataSource = Inversor.dsPosiciones
            Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnCellClick = GridCellClick
            OnDrawColumnCell = GridPosicionDrawColumnCell
            OnMouseMove = GridMouseMove
            OnGetCellParams = dbgPosicionesGetCellParams
            AlternateRowColor = 16250871
            ShowTitleHint = True
            SelectColumnsDialogStrings.Caption = 'Select columns'
            SelectColumnsDialogStrings.OK = '&OK'
            SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
            EditControls = <>
            RowsHeight = 17
            TitleRowHeight = 17
            ReadOnlyCellColor = 15138815
            Columns = <
              item
                Color = clWhite
                Expanded = False
                FieldName = 'PUNTOS'
                Visible = True
              end
              item
                Color = clWhite
                Expanded = False
                FieldName = 'NOMBRE'
                Visible = True
              end
              item
                Color = clWhite
                Expanded = False
                FieldName = 'SIMBOLO'
                Width = 64
                Visible = True
              end
              item
                Color = clWhite
                Expanded = False
                FieldName = 'MERCADO'
                Width = 64
                Visible = True
              end
              item
                Color = clWhite
                Expanded = False
                FieldName = 'POSICION'
                Width = 64
                Visible = True
              end
              item
                Color = clWhite
                Expanded = False
                FieldName = 'STOP'
                Visible = True
              end
              item
                Color = clWhite
                Expanded = False
                FieldName = 'LIMITE'
                Visible = True
              end>
          end
        end
      end
      object TBXToolbar1: TSpTBXToolbar
        AlignWithMargins = True
        Left = 10
        Top = 3
        Width = 772
        Height = 22
        Margins.Left = 10
        Align = alTop
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Color = clWindow
        Caption = 'TBXToolbar1'
        object lEstrategia: TSpTBXLabelItem
          Caption = 'Estrategia'
        end
        object TBXSeparatorItem1: TSpTBXSeparatorItem
          Blank = True
        end
        object TBControlItem1: TTBControlItem
          Control = Estrategias
        end
        object TBXSeparatorItem18: TSpTBXSeparatorItem
          Blank = True
        end
        object TBControlItem2: TTBControlItem
          Control = cbCuando
        end
        object TBXSeparatorItem2: TSpTBXSeparatorItem
          Blank = True
        end
        object TBXItem3: TSpTBXItem
          Action = BuscarPosiciones
          Images = ImageList
        end
        object TBXSeparatorItem3: TSpTBXSeparatorItem
        end
        object TBXItem1: TSpTBXItem
          Action = Posicionar
        end
        object TBXSeparatorItem14: TSpTBXSeparatorItem
          Blank = True
        end
        object TBXItem5: TSpTBXItem
          Action = PosicionarTodos
        end
        object TBXSeparatorItem17: TSpTBXSeparatorItem
        end
        object TBXLabelItem2: TSpTBXLabelItem
          Caption = 'Posibles posiciones encontradas'
        end
        object lNumPosibles: TSpTBXLabelItem
          Caption = '0'
        end
        object Estrategias: TJvDBSearchComboBox
          Left = 65
          Top = 0
          Width = 145
          Height = 21
          DataField = 'NOMBRE'
          DataSource = dsEstrategias
          Style = csDropDownList
          ParentFlat = False
          ItemHeight = 13
          TabOrder = 0
          OnChange = EstrategiasChange
        end
        object cbCuando: TComboBox
          Left = 216
          Top = 0
          Width = 119
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 1
          Text = 'Antes abrir sesi'#243'n'
          Items.Strings = (
            'Antes abrir sesi'#243'n'
            'Antes cerrar sesi'#243'n')
        end
      end
    end
    object tsPosicionesPendientes: TTabSheet [2]
      Caption = 'Posiciones pendientes de entrar a mercado'
      ImageIndex = 4
      object dbgPosicionesMercado: TJvDBUltimGrid
        Left = 0
        Top = 25
        Width = 785
        Height = 372
        Align = alClient
        DataSource = InversorCartera.dsPosicionesMercado
        Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnCellClick = GridCellClick
        OnDrawColumnCell = GridPosicionDrawColumnCell
        OnMouseMove = GridMouseMove
        OnGetCellParams = dbgPosicionesMercadoGetCellParams
        AlternateRowColor = 16250871
        ShowTitleHint = True
        OnShowTitleHint = GridTitleHint
        ShowCellHint = True
        SelectColumnsDialogStrings.Caption = 'Select columns'
        SelectColumnsDialogStrings.OK = '&OK'
        SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
        EditControls = <>
        RowsHeight = 17
        TitleRowHeight = 17
        ReadOnlyCellColor = 15138815
        Columns = <
          item
            Color = clWhite
            Expanded = False
            FieldName = 'SIMBOLO'
            Title.Caption = 'S'#237'mbolo'
            Width = 73
            Visible = True
          end
          item
            Color = clWhite
            Expanded = False
            FieldName = 'NOMBRE'
            Title.Caption = 'Nombre'
            Width = 167
            Visible = True
          end
          item
            Color = clWhite
            Expanded = False
            FieldName = 'MERCADO'
            Title.Caption = 'Mercado'
            Width = 118
            Visible = True
          end
          item
            Color = clWhite
            Expanded = False
            FieldName = 'TIPO_ORDEN'
            Visible = False
          end
          item
            Color = clWhite
            Expanded = False
            FieldName = 'OPERACION'
            Title.Caption = 'Posici'#243'n'
            Width = 27
            Visible = True
          end
          item
            Color = clWhite
            Expanded = False
            FieldName = 'NUM_ACCIONES'
            Title.Caption = 'Num. acciones'
            Visible = True
          end
          item
            Color = clWhite
            Expanded = False
            FieldName = 'CAMBIO'
            Title.Caption = 'Cambio'
            Visible = True
          end
          item
            Color = clWhite
            Expanded = False
            FieldName = 'ESTADO'
            Visible = False
          end
          item
            Color = clWhite
            Expanded = False
            FieldName = 'MENSAJE'
            Visible = False
          end>
      end
      object TBXToolbar2: TSpTBXToolbar
        AlignWithMargins = True
        Left = 10
        Top = 3
        Width = 772
        Height = 19
        Margins.Left = 10
        Align = alTop
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Color = clWindow
        Caption = 'TBXToolbar1'
        object TBXSeparatorItem5: TSpTBXSeparatorItem
          Blank = True
        end
        object TBXItem2: TSpTBXItem
          Action = Confirmar
        end
        object TBXSeparatorItem12: TSpTBXSeparatorItem
          Blank = True
        end
        object TBXItem10: TSpTBXItem
          Action = ConfirmarTodos
        end
        object TBXSeparatorItem4: TSpTBXSeparatorItem
        end
        object TBXItem4: TSpTBXItem
          Action = Descartar
        end
        object TBXSeparatorItem13: TSpTBXSeparatorItem
          Blank = True
        end
        object TBXItem7: TSpTBXItem
          Action = DescartarTodos
        end
      end
    end
    inherited tsPosicionesAbiertas: TTabSheet
      object TBXToolbar3: TSpTBXToolbar [2]
        AlignWithMargins = True
        Left = 10
        Top = 3
        Width = 772
        Height = 19
        Margins.Left = 10
        Align = alTop
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Color = clWindow
        Caption = 'TBXToolbar1'
        object TBXItem8: TSpTBXItem
          Action = CerrarStops
          DisplayMode = nbdmImageAndText
          Images = ImageList
        end
        object TBXSeparatorItem7: TSpTBXSeparatorItem
          Blank = True
        end
        object TBXItem9: TSpTBXItem
          Action = CerrarPosicion
          DisplayMode = nbdmImageAndText
          Images = ImageList
        end
        object TBXSeparatorItem11: TSpTBXSeparatorItem
          Blank = True
        end
        object TBXItem6: TSpTBXItem
          Action = CerrarPosicionTodos
          DisplayMode = nbdmImageAndText
          Images = ImageList
        end
      end
      inherited GridPosAbiertas: TJvDBUltimGrid
        Top = 25
        Height = 369
        TabOrder = 1
      end
    end
    inherited tsPosicionesCerradas: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 24
      ExplicitWidth = 785
      ExplicitHeight = 397
      inherited pCurvaCapital: TPanel
        inherited ChartCurvaCapital: TChart
          inherited Series1: TAreaSeries
            Data = {
              02060000000000000000003E4000FF000000000000000032C0FF000000000000
              00000059C0FF0000000000000000388840000000200000000000588640000000
              200000000000D0864000000020}
          end
        end
      end
    end
    inherited tsMovimientos: TTabSheet
      ExplicitLeft = 4
      ExplicitTop = 24
      ExplicitWidth = 785
      ExplicitHeight = 397
    end
  end
  inherited dsCurvaCapital: TDataSource
    Left = 416
    Top = 104
  end
  inherited dsPosicionesCerradas: TDataSource
    Left = 376
    Top = 152
  end
  inherited dsCuentaMovimientos: TDataSource
    Left = 536
    Top = 264
  end
  inherited dsPosicionesAbiertas: TDataSource
    Left = 48
    Top = 256
  end
  object ActionList: TActionList
    Images = ImageList
    Left = 256
    Top = 264
    object BuscarPosiciones: TAction
      Category = 'PosiblePos'
      Caption = 'BuscarPosiciones'
      Hint = 'Buscar posiciones aplicando la estrategia seleccionada'
      ImageIndex = 0
      OnExecute = BuscarPosicionesExecute
      OnUpdate = BuscarPosicionesUpdate
    end
    object Posicionar: TAction
      Category = 'PosiblePos'
      Caption = 'Posicionar'
      Enabled = False
      Hint = 'Posicionar en el mercado el valor seleccionado'
      OnExecute = PosicionarExecute
    end
    object Confirmar: TAction
      Category = 'PosPendientes'
      Caption = 'Confirmar'
      Enabled = False
      Hint = 'Confirmar que la posici'#243'n esta en el mercado'
      OnExecute = ConfirmarExecute
      OnUpdate = ConfirmarUpdate
    end
    object Descartar: TAction
      Category = 'PosPendientes'
      Caption = 'Descartar'
      Enabled = False
      Hint = 'Descartar la posici'#243'n porque no ha entrado en el mercado'
      OnExecute = DescartarExecute
      OnUpdate = DescartarUpdate
    end
    object PosicionarTodos: TAction
      Category = 'PosiblePos'
      Caption = 'Posicionar todos'
      Enabled = False
      Hint = 'Posicionar todos los valores en el mercado'
      OnExecute = PosicionarTodosExecute
    end
    object DescartarTodos: TAction
      Category = 'PosPendientes'
      Caption = 'Descartar Todos'
      Enabled = False
      Hint = 
        'Descartar todas las posiciones porque no han entrado en el merca' +
        'do'
      OnExecute = DescartarTodosExecute
      OnUpdate = DescartarTodosUpdate
    end
    object CerrarStops: TAction
      Category = 'PosAbiertas'
      Caption = 'Cerrar Stops'
      Enabled = False
      Hint = 'Cerrar todas las posiciones que hayan roto el stop'
      OnExecute = CerrarStopsExecute
      OnUpdate = CerrarStopsUpdate
    end
    object CerrarPosicion: TAction
      Category = 'PosAbiertas'
      Caption = 'Cerrar Posici'#243'n'
      Enabled = False
      Hint = 'Cerrar la posici'#243'n seleccionada'
      OnExecute = CerrarPosicionExecute
      OnUpdate = CerrarPosicionUpdate
    end
    object ConfirmarTodos: TAction
      Category = 'PosPendientes'
      Caption = 'Confirmar Todos'
      Enabled = False
      OnExecute = ConfirmarTodosExecute
      OnUpdate = ConfirmarTodosUpdate
    end
    object CerrarPosicionTodos: TAction
      Category = 'PosAbiertas'
      Caption = 'Cerrar todas'
      Enabled = False
      Hint = 'Cerrar todas las posiciones'
      OnExecute = CerrarPosicionTodosExecute
      OnUpdate = CerrarPosicionTodosUpdate
    end
  end
  object ImageList: TImageList
    Left = 368
    Top = 264
    Bitmap = {
      494C010101000300040010001000FFFFFFFFFF00FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000108ABD001994C6000B699700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000148D
      BE00148DBE000B6B9A000D82B4001B96C8001F9AC9000B71A0000A6D9C00259D
      C9001791C3000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000158E
      C000259DC9001B96C800108ABD001BBBED0032CBF6001791C30037ABD30037AB
      D300158EC0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000C71A1000E7EAF002DA2
      CA0068D2EC0037ABD30023B6E60011C7FC0024C8F80045CEF40037ABD3009ED6
      E3007AD3E9000C71A10000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000033A7CE002DA2CA0037AB
      D3007AD3E90072D3EA003DCDF50016C8FB0011C7FC003DCDF5005BD5F30060D4
      F10020B8E9001F9AC900158EC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000C7BAD001791C30025B3
      E30064D3EF007AD3E90054D1F30033A7CE002DA2CA0023B6E60011C6FB0011C6
      FB0011C6FB0018BFF2001F9AC900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000A74A5001B96C80028B0
      DF0051D0F3007AD3E900807F7F00807F7F00807F7F00807F7F002DA2CA0011C6
      FB0011C6FB0011C6FB000F88BA00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000B77A9001B96C8001F9A
      C9003DCDF500807F7F00DED9D8009E899900938C8C00D0A0B500807F7F003DCD
      F50080D3E6009ED6E3000E7EAF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000A73A4000F88BA001B96
      C80023B6E600807F7F00DED9D8009A8E9600938C8C00D0A0B500807F7F0060D4
      F10093D5E50072D3EA00158EC000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000D689400118B
      BE0025B3E300807F7F00DED9D8009A8E9600938C8C00D0A0B500807F7F004BCE
      F3004BCEF3000F66910000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000B70
      A0000B77A900807F7F00DED9D8009A8E9600938C8C00CCA8B300807F7F000D82
      B4000B77A9000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000807F7F00DDD9D8009A8E9600918A8A00CCA8B300807F7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000807F7F009E8999008F898900817F7F008F898900807F7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000807F7F00DBD7D600B7B7B700938C8C00988F9200807F7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000807F7F00DDD9D800DED9D800B6B6B6008B868600807F7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000807F7F00807F7F00807F7F00807F7F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FE3F000000000000E007000000000000
      E007000000000000800300000000000080010000000000008001000000000000
      800100000000000080010000000000008001000000000000C003000000000000
      E007000000000000F81F000000000000F81F000000000000F81F000000000000
      F81F000000000000FC3F000000000000}
  end
  object dsEstrategias: TDataSource
    DataSet = InversorCartera.qEstrategias
    Left = 656
    Top = 168
  end
  object dsCartera: TDataSource
    DataSet = Cartera.qCartera
    Left = 128
    Top = 240
  end
  object dsBrokers: TDataSource
    Left = 600
    Top = 88
  end
end
