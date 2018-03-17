inherited fEstrategias: TfEstrategias
  Caption = 'Estrategias'
  ClientHeight = 514
  ClientWidth = 836
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 844
  ExplicitHeight = 548
  PixelsPerInch = 96
  TextHeight = 13
  inherited Splitter: TJvNetscapeSplitter
    Height = 514
    ExplicitLeft = 187
    ExplicitTop = 0
    ExplicitHeight = 448
  end
  inherited pDetalle: TPanel
    Width = 641
    Height = 514
    ExplicitLeft = 195
    ExplicitTop = 0
    ExplicitWidth = 641
    ExplicitHeight = 514
    object pcEstrategia: TPageControl
      Left = 1
      Top = 1
      Width = 639
      Height = 512
      ActivePage = tsDetalles
      Align = alClient
      TabOrder = 0
      object tsDetalles: TTabSheet
        Caption = 'Detalles'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        DesignSize = (
          631
          484)
        object Label2: TLabel
          Left = 11
          Top = 80
          Width = 56
          Height = 13
          Caption = 'Descripci'#243'n'
          FocusControl = Descripcion
        end
        object Label1: TLabel
          Left = 11
          Top = 16
          Width = 37
          Height = 13
          Caption = 'Nombre'
          FocusControl = Descripcion
        end
        object Label3: TLabel
          Left = 504
          Top = 16
          Width = 84
          Height = 13
          Anchors = [akTop, akRight]
          Caption = 'Usar en la cartera'
        end
        object LEDProductivo: TJvShape
          Left = 594
          Top = 16
          Width = 15
          Height = 15
          Cursor = crHandPoint
          Anchors = [akTop, akRight]
          Brush.Color = clLime
          Pen.Color = clSilver
          Shape = stCircle
          OnClick = LEDProductivoClick
        end
        object Descripcion: TDBMemo
          Left = 11
          Top = 99
          Width = 606
          Height = 374
          Anchors = [akLeft, akTop, akRight, akBottom]
          DataField = 'DESCRIPCION'
          DataSource = dsMaster
          ScrollBars = ssVertical
          TabOrder = 1
        end
        object Nombre: TDBEdit
          Left = 11
          Top = 35
          Width = 190
          Height = 21
          DataField = 'NOMBRE'
          DataSource = dsMaster
          TabOrder = 0
        end
      end
      object tsCodigo: TTabSheet
        Caption = 'C'#243'digo'
        ImageIndex = 1
        OnShow = tsCodigoShow
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object pEstrategia: TPanel
          Left = 0
          Top = 0
          Width = 631
          Height = 484
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          inline EditorCodigo: TfEditorCodigo
            Left = 0
            Top = 0
            Width = 631
            Height = 484
            Align = alClient
            TabOrder = 0
            ExplicitWidth = 631
            ExplicitHeight = 484
            inherited Editor: TSynEdit
              Width = 631
              Height = 388
              ExplicitWidth = 631
              ExplicitHeight = 388
            end
            inherited StatusBar: TStatusBar
              Top = 409
              Width = 631
              ExplicitTop = 409
              ExplicitWidth = 631
            end
            inherited pInfo: TPanel
              Top = 432
              Width = 631
              TabOrder = 3
              ExplicitTop = 432
              ExplicitWidth = 631
              inherited lbInfo: TListBox
                Width = 599
                ExplicitWidth = 599
              end
            end
            inherited pToolbarEditorCodigo: TPanel
              Width = 631
              ExplicitWidth = 631
              inherited pEstadoCompilacion: TPanel
                Left = 613
                Visible = False
                ExplicitLeft = 613
              end
            end
            inherited ActionListEditor: TActionList
              inherited aCompilar: TAction
                OnExecute = EditorCodigoCompilarExecute
              end
            end
          end
          object tcTipoEstrategia: TTabControl
            Left = 29
            Top = 1
            Width = 580
            Height = 19
            TabOrder = 1
            Tabs.Strings = (
              'Antes abrir sesi'#243'n'
              'Antes abrir sesi'#243'n posicionados'
              'Antes cerrar sesi'#243'n'
              'Antes cerrar sesi'#243'n posicionados')
            TabIndex = 0
            OnChange = tcTipoEstrategiaChange
            OnChanging = tcTipoEstrategiaChanging
          end
        end
      end
    end
  end
  inherited pMaster: TPanel
    Height = 514
    ParentBackground = False
    ExplicitHeight = 514
    inherited gMaster: TJvDBUltimGrid
      Height = 484
      Options = [dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    end
    inherited TBXToolbar1: TSpTBXToolbar
      Color = clBtnFace
      object TBXItem5: TSpTBXItem [1]
        Action = Duplicar
        ImageIndex = 0
        Images = ImageList
      end
      object TBXSeparatorItem1: TSpTBXSeparatorItem [2]
        Blank = True
      end
    end
  end
  inherited dsMaster: TDataSource
    DataSet = Estrategias.qEstrategias
  end
  inherited ActionList: TActionList
    inherited Borrar: TDataSetDelete
      OnExecute = BorrarExecute
    end
    object Duplicar: TAction
      Category = 'Master'
      Caption = 'Duplicar'
      Hint = 'Duplicar'
      OnExecute = DuplicarExecute
      OnUpdate = DuplicarUpdate
    end
  end
  object ImageList: TImageList
    Left = 48
    Top = 232
    Bitmap = {
      494C010101000300040010001000FFFFFFFFFF00FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000800000008000000180808001808
      0800392929003929290042313100392929000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000010080800A59CA500B5ADAD00B5A5
      AD00D6C6C600EFDEDE00EFDEDE00423139000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000080000008C8484006B5A63008C7B
      7B009C949400AD9C9C00BDADAD00392931000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000100808008C848400948C8C00ADA5
      A500B5A5AD00B5ADAD009C8C8C00392929000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000010081000C6BDBD00D6CECE00DED6
      D600D6CECE00D6CECE00ADA5A500423139000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000008000000DEDEDE00DED6D600D6CE
      CE00DED6DE00D6CECE00CEC6C600393131000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000008000000DED6D600EFE7E700CEC6
      C600EFEFEF00F7EFEF00DEDEDE00312931000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6B5BD009C949400A594
      9400A59C9C009C949400A5949C00ADA5A5000800000010081000080000000000
      0000313131003129290029292900313131000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004231310039293100393131004231
      310031212900392929003939390031292900B5ADAD0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000039292900BDADAD00CEBDBD00CEC6
      C600CEC6C600D6C6CE00DED6D600393131009C94940000000000000000000000
      0000000000008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000039293100ADA5A50094848C00AD9C
      9C00A59C9C009C8C8C00BDB5B50039293100ADA5A50000000000000000000000
      0000212121003131310029292900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000042313100B5ADAD00C6B5BD00B5AD
      AD00ADA5A500B5ADAD00A59C9C0029212100ADADAD0000000000000000000000
      0000000000002121210000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000039313100D6C6CE00EFE7E700DECE
      D600D6CECE00CEC6CE00BDB5B50039313100847B7B0000000000000000000000
      0000000000007B73730000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000039313100EFE7E700EFE7E700EFE7
      E700E7D6DE00D6CECE00D6CECE0039313100B5ADAD0000000000393131003939
      39007B7373000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000039313100EFE7E700F7EFEF00EFE7
      EF00F7EFEF00EFE7E700CEC6C60031293100948C8C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003129290039393900312129002929
      2900393939003931310031292900423131000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FF00000000000000FF00000000000000
      FF00000000000000FF00000000000000FF00000000000000FF00000000000000
      FF000000000000008000000000000000007F000000000000007B000000000000
      0071000000000000007B000000000000007B0000000000000047000000000000
      007F00000000000000FF000000000000}
  end
end