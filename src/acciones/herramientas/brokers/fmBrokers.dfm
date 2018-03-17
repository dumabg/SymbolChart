inherited fBrokers: TfBrokers
  Left = 274
  Top = 239
  Caption = 'Brokers'
  ClientHeight = 546
  ClientWidth = 823
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  ExplicitWidth = 831
  ExplicitHeight = 580
  PixelsPerInch = 96
  TextHeight = 13
  inherited Splitter: TJvNetscapeSplitter
    Height = 546
    ExplicitHeight = 429
  end
  inherited pDetalle: TPanel
    Width = 628
    Height = 546
    ExplicitWidth = 628
    ExplicitHeight = 546
    object TBXToolbar2: TSpTBXToolbar
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 620
      Height = 19
      Align = alTop
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Caption = 'TBXToolbar2'
      object TBXItem9: TSpTBXItem
        Action = Copiar
      end
      object TBXItem8: TSpTBXItem
        Action = Pegar
      end
      object TBXSeparatorItem2: TSpTBXSeparatorItem
      end
      object TBXItem7: TSpTBXItem
        Action = CopiarES
      end
      object TBXItem6: TSpTBXItem
        Action = CopiarSE
      end
      object TBXItem3: TSpTBXItem
        Action = CopiarTodos
      end
      object TBXSeparatorItem1: TSpTBXSeparatorItem
      end
      object TBXItem5: TSpTBXItem
        Action = BorrarComision
      end
      object TBXItem4: TSpTBXItem
        Action = BorrarTodosComision
      end
      object TBXSeparatorItem3: TSpTBXSeparatorItem
      end
      object TBXItem10: TSpTBXItem
        Action = Comprobar
      end
    end
    object gComisiones: TJvDBUltimGrid
      Left = 1
      Top = 26
      Width = 626
      Height = 462
      Align = alClient
      DataSource = dsBrokerComision
      Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete]
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      AutoSizeColumns = True
      SelectColumnsDialogStrings.Caption = 'Select columns'
      SelectColumnsDialogStrings.OK = '&OK'
      SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
      EditControls = <
        item
          ControlName = 'Entrada'
          FieldName = 'ENTRADA'
          FitCell = fcCellSize
          LeaveOnEnterKey = True
          LeaveOnUpDownKey = True
        end
        item
          ControlName = 'MaximoEntrada'
          FieldName = 'ENTRADA_MAXIMO'
          FitCell = fcCellSize
          LeaveOnEnterKey = True
          LeaveOnUpDownKey = True
        end
        item
          ControlName = 'MinimoEntrada'
          FieldName = 'ENTRADA_MINIMO'
          FitCell = fcCellSize
          LeaveOnEnterKey = True
          LeaveOnUpDownKey = True
        end
        item
          ControlName = 'Salida'
          FieldName = 'SALIDA'
          FitCell = fcCellSize
          LeaveOnEnterKey = True
          LeaveOnUpDownKey = True
        end
        item
          ControlName = 'MaximoSalida'
          FieldName = 'SALIDA_MAXIMO'
          FitCell = fcCellSize
          LeaveOnEnterKey = True
          LeaveOnUpDownKey = True
        end
        item
          ControlName = 'MinimoSalida'
          FieldName = 'SALIDA_MINIMO'
          FitCell = fcCellSize
          LeaveOnEnterKey = True
          LeaveOnUpDownKey = True
        end>
      RowsHeight = 17
      TitleRowHeight = 17
      ReadOnlyCellColor = 14024703
      Columns = <
        item
          Color = 15794175
          Expanded = False
          FieldName = 'MERCADO'
          Width = 106
          Visible = True
        end
        item
          ButtonStyle = cbsEllipsis
          Expanded = False
          FieldName = 'ENTRADA'
          Width = 79
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ENTRADA_MAXIMO'
          Width = 91
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ENTRADA_MINIMO'
          Width = 84
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SALIDA'
          Width = 77
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SALIDA_MAXIMO'
          Width = 88
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SALIDA_MINIMO'
          Width = 78
          Visible = True
        end>
    end
    object Entrada: TDBMemo
      Left = 16
      Top = 303
      Width = 97
      Height = 50
      DataField = 'ENTRADA'
      DataSource = dsBrokerComision
      TabOrder = 2
      Visible = False
    end
    object MaximoEntrada: TDBMemo
      Left = 128
      Top = 303
      Width = 97
      Height = 50
      DataField = 'ENTRADA_MAXIMO'
      DataSource = dsBrokerComision
      TabOrder = 3
      Visible = False
    end
    object MinimoEntrada: TDBMemo
      Left = 256
      Top = 303
      Width = 97
      Height = 50
      DataField = 'ENTRADA_MINIMO'
      DataSource = dsBrokerComision
      TabOrder = 4
      Visible = False
    end
    object Salida: TDBMemo
      Left = 16
      Top = 383
      Width = 97
      Height = 50
      DataField = 'SALIDA'
      DataSource = dsBrokerComision
      TabOrder = 5
      Visible = False
    end
    object MaximoSalida: TDBMemo
      Left = 128
      Top = 383
      Width = 97
      Height = 50
      DataField = 'SALIDA_MAXIMO'
      DataSource = dsBrokerComision
      TabOrder = 6
      Visible = False
    end
    object MinimoSalida: TDBMemo
      Left = 256
      Top = 383
      Width = 97
      Height = 50
      DataField = 'SALIDA_MINIMO'
      DataSource = dsBrokerComision
      TabOrder = 7
      Visible = False
    end
    object pInfo: TPanel
      Left = 1
      Top = 488
      Width = 626
      Height = 57
      Align = alBottom
      TabOrder = 8
      object Image1: TImage
        Left = 8
        Top = 4
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
      end
      object JvHTLabel1: TJvHTLabel
        AlignWithMargins = True
        Left = 32
        Top = 4
        Width = 200
        Height = 14
        Caption = 'Existen dos variables: <b>accion</b> y <b>efectivo</b>'
        Layout = tlCenter
      end
      object JvHTLabel2: TJvHTLabel
        AlignWithMargins = True
        Left = 39
        Top = 20
        Width = 525
        Height = 14
        Caption = 
          '<b>accion</b> permite especificar un c'#225'lculo sobre el n'#250'mero de ' +
          'acciones que entrar'#225'n al mercado. (Ej.: 0.01*accion)'
        Layout = tlCenter
      end
      object JvHTLabel3: TJvHTLabel
        AlignWithMargins = True
        Left = 39
        Top = 37
        Width = 490
        Height = 14
        Caption = 
          '<b>efectivo</b> permite especificar un c'#225'lculo sobre el efectivo' +
          ' total que entrar'#225' al mercado. (Ej.: 1% efectivo)'
        Layout = tlCenter
      end
    end
  end
  inherited pMaster: TPanel
    Height = 546
    ExplicitHeight = 546
    inherited gMaster: TJvDBUltimGrid
      Height = 516
      Options = [dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    end
  end
  inherited dsMaster: TDataSource
    DataSet = Brokers.qBroker
  end
  inherited ActionList: TActionList
    inherited Borrar: TDataSetDelete
      OnExecute = BorrarExecute
    end
  end
  object dsBrokerComision: TDataSource
    DataSet = Brokers.mBrokerComision
    Left = 424
    Top = 200
  end
  object ActionListComision: TActionList
    Left = 416
    Top = 328
    object CopiarTodos: TAction
      Caption = 'Copiar todos'
      Hint = 'Copiar las f'#243'rmulas de la fila actual a todas las otras filas'
      OnExecute = CopiarTodosExecute
    end
    object BorrarComision: TAction
      Caption = 'Borrar'
      Hint = 'Borra todas las f'#243'rmulas de la fila seleccionada'
      OnExecute = BorrarComisionExecute
    end
    object BorrarTodosComision: TAction
      Caption = 'Borrar todos'
      Hint = 'Borra todas las f'#243'rmulas de todas las filas'
      OnExecute = BorrarTodosComisionExecute
    end
    object CopiarES: TAction
      Caption = 'Copiar Entrada a Salida'
      Hint = 'Copiar las f'#243'rmulas de la entrada a la salida'
      OnExecute = CopiarESExecute
    end
    object CopiarSE: TAction
      Caption = 'Copiar Salida a Entrada'
      Hint = 'Copiar las f'#243'rmulas de la salida a la entrada'
      OnExecute = CopiarSEExecute
    end
    object Copiar: TAction
      Caption = 'Copiar'
      Hint = 'Copia la fila entera a memoria'
      OnExecute = CopiarExecute
    end
    object Pegar: TAction
      Caption = 'Pegar'
      Enabled = False
      Hint = 'Pega la fila que hay en memoria a la fila actual'
      OnExecute = PegarExecute
    end
    object Comprobar: TAction
      Caption = 'Comprobar'
      Hint = 'Comprobar que todas las f'#243'rmulas introducidas son correctas'
      OnExecute = ComprobarExecute
    end
  end
end
