inherited fEstudioCuenta: TfEstudioCuenta
  Width = 733
  ExplicitWidth = 733
  inherited pcPosiciones: TPageControl
    Width = 727
    ActivePage = tsCaracteristicas
    ExplicitWidth = 727
    object tsCaracteristicas: TTabSheet [0]
      Caption = 'Caracter'#237'sticas'
      ImageIndex = 4
      DesignSize = (
        719
        397)
      object Label1: TLabel
        Left = 24
        Top = 16
        Width = 37
        Height = 13
        Caption = 'Nombre'
        FocusControl = dbeNombre
      end
      object Label2: TLabel
        Left = 24
        Top = 51
        Width = 54
        Height = 13
        Caption = 'Descripci'#243'n'
        FocusControl = dbeDescripcion
      end
      object Label3: TLabel
        Left = 24
        Top = 144
        Width = 30
        Height = 13
        Caption = 'Desde'
      end
      object Label4: TLabel
        Left = 151
        Top = 144
        Width = 28
        Height = 13
        Caption = 'Hasta'
      end
      object Label5: TLabel
        Left = 146
        Top = 194
        Width = 33
        Height = 13
        Caption = 'Capital'
        Visible = False
      end
      object Label6: TLabel
        Left = 24
        Top = 168
        Width = 45
        Height = 13
        Caption = 'Paquetes'
      end
      object dbtDesde: TDBText
        Left = 60
        Top = 144
        Width = 54
        Height = 13
        AutoSize = True
        DataField = 'DESDE'
        DataSource = dsEstudio
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtHasta: TDBText
        Left = 185
        Top = 144
        Width = 52
        Height = 13
        AutoSize = True
        DataField = 'HASTA'
        DataSource = dsEstudio
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbtCapital: TDBText
        Left = 185
        Top = 194
        Width = 58
        Height = 13
        AutoSize = True
        DataField = 'CAPITAL'
        DataSource = dsEstudio
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object dbtPaquetes: TDBText
        Left = 75
        Top = 168
        Width = 72
        Height = 13
        AutoSize = True
        DataField = 'PAQUETES'
        DataSource = dsEstudio
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 24
        Top = 224
        Width = 49
        Height = 13
        Caption = 'Estrategia'
      end
      object Label17: TLabel
        Left = 41
        Top = 243
        Width = 37
        Height = 13
        Caption = 'Nombre'
      end
      object dbtNombreTipo: TDBText
        Left = 84
        Top = 243
        Width = 87
        Height = 13
        AutoSize = True
        DataField = 'NOMBRE_ESTRATEGIA'
        DataSource = dsEstudio
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label18: TLabel
        Left = 41
        Top = 262
        Width = 54
        Height = 13
        Caption = 'Descripci'#243'n'
      end
      object sbCargar: TSpeedButton
        Left = 584
        Top = 13
        Width = 102
        Height = 41
        Action = Cargar
        Anchors = [akTop, akRight]
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00023F9A000846B000FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000B6BD300FF00FF00FF00
          FF00FF00FF00FF00FF000C4FA3002077E9001C6DD700FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00176EC900157EE500FF00FF00FF00
          FF00FF00FF00FF00FF003486E800AADAFC00276FCA00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF004691E500368BE000FF00FF00FF00
          FF001257AA003589E70094DBFB00BCF3FE002678DD00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF001F73C2004193E8008FD3F9003E8FE200FF00FF00FF00
          FF00358BE80094D6FA0067D8FF007ADCFF00AADAFA0061A7F0002681E700197A
          E2001D7EE9002F86E40062A8EC008FD5FA0070D1FA001A7EE100FF00FF003194
          F90085CEFC0066D1FF0055C2FF0055C2FF007AD3FF0088DEFF008BCEF90085CB
          F5007EC8F6007CCAF7007FD6FF0075D8FF0074C1FC001B6EC200277DD6007BCF
          FF005BC5FF004DBCFF0055BEFF0053BEFF004BBBFF004EBDFF005DC4FF005EC7
          FF0062C6FF0065C9FF0070CBFF0086D1FE0048A1F6001966B8002782D20089D2
          FF006AC5FF0057B8FF0059BCFF0056B9FF0054B9FF0056BBFF005BBAFF0060BC
          FF0076C6FF0096D6FF00B1E6FE007CC1FA00298EE600FF00FF00FF00FF003EA4
          F9009CD5FF0082CAFF006BBDFF0070BEFF007BC6FF007FC8FF0087CAFF00A5DD
          FF00BCE9FF00B5E0FD007CBCF5002888E500FF00FF00FF00FF00FF00FF00FF00
          FF0043A4F700A5D6FF008AC8FF00A1D5FF00AAD9FC00A8D8FE00B2DEFD00CBE8
          FF0083BDF200479DF2002496ED00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF003EA0F300B4DBFF00DEF3FD002F7BD9003874CD00529AF3004F99
          F0002185D800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF003FA8F600BCEDFF002377CD00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00188DE4000061CE00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF009ABDE900FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      end
      object Bevel1: TBevel
        Left = 80
        Top = 228
        Width = 606
        Height = 6
        Anchors = [akLeft, akTop, akRight]
        Shape = bsBottomLine
      end
      object Label19: TLabel
        Left = 24
        Top = 194
        Width = 35
        Height = 13
        Caption = 'Valores'
      end
      object dbtGrupo: TDBText
        Left = 65
        Top = 194
        Width = 53
        Height = 13
        AutoSize = True
        DataField = 'GRUPO'
        DataSource = dsEstudio
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbeNombre: TDBEdit
        Left = 72
        Top = 13
        Width = 304
        Height = 21
        DataField = 'NOMBRE'
        DataSource = dsEstudio
        TabOrder = 0
      end
      object dbeDescripcion: TDBMemo
        Left = 24
        Top = 70
        Width = 662
        Height = 59
        Anchors = [akLeft, akTop, akRight]
        DataField = 'DESCRIPCION'
        DataSource = dsEstudio
        TabOrder = 1
      end
      object dbtDescripcionTipo: TDBMemo
        Left = 41
        Top = 281
        Width = 645
        Height = 104
        Anchors = [akLeft, akTop, akRight, akBottom]
        DataField = 'DESCRIPCION_ESTRATEGIA'
        DataSource = dsEstudio
        ParentColor = True
        ReadOnly = True
        TabOrder = 3
      end
      object dbcUSA100: TDBCheckBox
        Left = 151
        Top = 168
        Width = 225
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Paquetes de 100 acciones en valores USA'
        DataField = 'USA100'
        DataSource = dsEstudio
        ReadOnly = True
        TabOrder = 2
        ValueChecked = 'S'
        ValueUnchecked = 'N'
      end
    end
    object tsMensajes: TTabSheet [1]
      Caption = 'Mensajes'
      ImageIndex = 4
      object JvDBUltimGrid1: TJvDBUltimGrid
        Left = 0
        Top = 0
        Width = 719
        Height = 397
        Align = alClient
        DataSource = dsMensajes
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        AlternateRowColor = 16250871
        AutoSizeColumns = True
        SelectColumnsDialogStrings.Caption = 'Select columns'
        SelectColumnsDialogStrings.OK = '&OK'
        SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
        EditControls = <>
        RowsHeight = 16
        TitleRowHeight = 17
      end
    end
    inherited tsPosicionesAbiertas: TTabSheet
      ExplicitWidth = 719
      inherited GridPosAbiertas: TJvDBUltimGrid
        Width = 713
      end
    end
    inherited tsPosicionesCerradas: TTabSheet
      ExplicitWidth = 719
      inherited GridPosCerradas: TJvDBUltimGrid
        Width = 713
        Columns = <
          item
            Expanded = False
            FieldName = 'NOMBRE'
            Width = 120
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SIMBOLO'
            Width = 30
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MERCADO'
            Width = 63
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'POSICION'
            Width = 16
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NUM_ACCIONES'
            Width = 36
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FECHA_HORA_COMPRA'
            Width = 87
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CAMBIO_COMPRA'
            Width = 38
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'COMISION_COMPRA'
            Width = 41
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FECHA_HORA'
            Width = 83
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CAMBIO'
            Width = 34
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'COMISION'
            Width = 40
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'GANANCIA'
            Width = 35
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MONEDA'
            Width = 73
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MONEDA_VALOR'
            Visible = False
          end>
      end
      inherited TBXToolbar4: TSpTBXToolbar
        Width = 713
        ExplicitWidth = 713
      end
      inherited pCurvaCapital: TPanel
        Width = 719
        ExplicitWidth = 719
        inherited ChartCurvaCapital: TChart
          Width = 510
          ExplicitWidth = 510
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
      ExplicitWidth = 719
      inherited GridMovimientos: TJvDBUltimGrid
        Width = 713
        Columns = <
          item
            Expanded = False
            FieldName = 'NUM_MOVIMIENTO'
            Width = 37
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'FECHA_HORA'
            Width = 50
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TIPO'
            Width = 63
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NOMBRE'
            Width = 108
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SIMBOLO'
            Width = 30
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MERCADO'
            Width = 51
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'POSICION'
            Width = 15
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NUM_ACCIONES'
            Width = 29
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CAMBIO'
            Width = 28
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'COMISION'
            Width = 28
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'COSTE'
            Width = 57
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'GANANCIA'
            Width = 51
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MONEDA'
            Width = 51
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MONEDA_VALOR'
            Visible = False
          end
          item
            Expanded = False
            FieldName = 'GANANCIA_MONEDA_BASE'
            Width = 57
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OR_NUM_MOVIMIENTO'
            Width = 39
            Visible = True
          end>
      end
      inherited MovimientosToolBar: TSpTBXToolbar
        Width = 706
        Visible = False
        ExplicitWidth = 706
        inherited TBXItem15: TSpTBXItem
          Visible = False
        end
        inherited TBXSeparatorItem10: TSpTBXSeparatorItem
          Visible = False
        end
        inherited TBXItem17: TSpTBXItem
          Visible = False
        end
        inherited TBXSeparatorItem9: TSpTBXSeparatorItem
          Visible = False
        end
        inherited TBXItem14: TSpTBXItem
          Visible = False
        end
        inherited TBXSeparatorItem15: TSpTBXSeparatorItem
          Visible = False
        end
        inherited TBXItem16: TSpTBXItem
          Visible = False
        end
        inherited TBXSeparatorItem16: TSpTBXSeparatorItem
          Visible = False
        end
      end
    end
  end
  inherited dsCurvaCapital: TDataSource
    Left = 504
    Top = 136
  end
  inherited dsPosicionesCerradas: TDataSource
    Left = 400
    Top = 136
  end
  inherited dsCuentaMovimientos: TDataSource
    Left = 616
    Top = 136
  end
  inherited dsPosicionesAbiertas: TDataSource
    Left = 288
    Top = 120
  end
  object dsEstudio: TDataSource
    DataSet = Estudios.qEstudio
    Left = 528
    Top = 64
  end
  object ActionList: TActionList
    Images = ImageList
    Left = 608
    Top = 104
    object Cargar: TAction
      Caption = 'Cargar'
      ImageIndex = 0
    end
    object Descargar: TAction
      Caption = 'Descargar'
      ImageIndex = 1
    end
  end
  object ImageList: TImageList
    Left = 664
    Top = 104
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF00FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000277DD6002782D200000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000003194F9007BCFFF0089D2FF003EA4F9000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000023F9A000846B000000000000000000000000000000000000000
      00000000000000000000000000000B6BD3000000000000000000000000000000
      0000000000001257AA00358BE80085CEFC005BC5FF006AC5FF009CD5FF0043A4
      F700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000C4FA3002077E9001C6DD700000000000000000000000000000000000000
      00000000000000000000176EC900157EE5000000000000000000000000000000
      0000000000003589E70094D6FA0066D1FF004DBCFF0057B8FF0082CAFF00A5D6
      FF003EA0F3000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00003486E800AADAFC00276FCA00000000000000000000000000000000000000
      000000000000000000004691E500368BE0000000000000000000000000000C4F
      A3003486E80094DBFB0067D8FF0055C2FF0055BEFF0059BCFF006BBDFF008AC8
      FF00B4DBFF003FA8F60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001257AA003589
      E70094DBFB00BCF3FE002678DD00000000000000000000000000000000000000
      00001F73C2004193E8008FD3F9003E8FE2000000000000000000023F9A002077
      E900AADAFC00BCF3FE007ADCFF0055C2FF0053BEFF0056B9FF0070BEFF00A1D5
      FF00DEF3FD00BCEDFF00188DE400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000358BE80094D6
      FA0067D8FF007ADCFF00AADAFA0061A7F0002681E700197AE2001D7EE9002F86
      E40062A8EC008FD5FA0070D1FA001A7EE10000000000000000000846B0001C6D
      D700276FCA002678DD00AADAFA007AD3FF004BBBFF0054B9FF007BC6FF00AAD9
      FC002F7BD9002377CD000061CE009ABDE9000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003194F90085CEFC0066D1
      FF0055C2FF0055C2FF007AD3FF0088DEFF008BCEF90085CBF5007EC8F6007CCA
      F7007FD6FF0075D8FF0074C1FC001B6EC2000000000000000000000000000000
      0000000000000000000061A7F00088DEFF004EBDFF0056BBFF007FC8FF00A8D8
      FE003874CD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000277DD6007BCFFF005BC5FF004DBC
      FF0055BEFF0053BEFF004BBBFF004EBDFF005DC4FF005EC7FF0062C6FF0065C9
      FF0070CBFF0086D1FE0048A1F6001966B8000000000000000000000000000000
      000000000000000000002681E7008BCEF9005DC4FF005BBAFF0087CAFF00B2DE
      FD00529AF3000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002782D20089D2FF006AC5FF0057B8
      FF0059BCFF0056B9FF0054B9FF0056BBFF005BBAFF0060BCFF0076C6FF0096D6
      FF00B1E6FE007CC1FA00298EE600000000000000000000000000000000000000
      00000000000000000000197AE20085CBF5005EC7FF0060BCFF00A5DDFF00CBE8
      FF004F99F0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003EA4F9009CD5FF0082CA
      FF006BBDFF0070BEFF007BC6FF007FC8FF0087CAFF00A5DDFF00BCE9FF00B5E0
      FD007CBCF5002888E50000000000000000000000000000000000000000000000
      000000000000000000001D7EE9007EC8F60062C6FF0076C6FF00BCE9FF0083BD
      F2002185D8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000043A4F700A5D6
      FF008AC8FF00A1D5FF00AAD9FC00A8D8FE00B2DEFD00CBE8FF0083BDF200479D
      F2002496ED000000000000000000000000000000000000000000000000000000
      000000000000000000002F86E4007CCAF70065C9FF0096D6FF00B5E0FD00479D
      F200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000003EA0
      F300B4DBFF00DEF3FD002F7BD9003874CD00529AF3004F99F0002185D8000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001F73C20062A8EC007FD6FF0070CBFF00B1E6FE007CBCF5002496
      ED00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00003FA8F600BCEDFF002377CD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000004193E8008FD5FA0075D8FF0086D1FE007CC1FA002888E5000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000188DE4000061CE00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000176E
      C9004691E5008FD3F90070D1FA0074C1FC0048A1F600298EE600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000009ABDE900000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000B6BD300157E
      E500368BE0003E8FE2001A7EE1001B6EC2001966B80000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFF3F00000000FFFFFE1F00000000
      F9FEF80F00000000F1FCF80700000000F1FCE00300000000C1F0C00100000000
      C000C000000000008000FC07000000000000FC07000000000001FC0700000000
      8003FC0700000000C007FC0F00000000E01FF80F00000000F1FFF81F00000000
      F9FFE03F00000000FDFFC07F00000000}
  end
  object dsMensajes: TDataSource
    DataSet = Estudios.qMensajes
    Left = 184
    Top = 120
  end
end
