object fMensajeEstrategia: TfMensajeEstrategia
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Mensaje Estrategia'
  ClientHeight = 626
  ClientWidth = 1292
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pcVista: TPageControl
    Left = 0
    Top = 0
    Width = 1292
    Height = 626
    ActivePage = tsResumen
    Align = alClient
    MultiLine = True
    TabOrder = 0
    OnChange = pcVistaChange
    OnChanging = pcVistaChanging
    object tsResumen: TTabSheet
      Caption = 'Resumen'
      object pTodo: TPanel
        Left = 298
        Top = 0
        Width = 986
        Height = 598
        Align = alClient
        TabOrder = 2
        object gData: TStringGrid
          Left = 1
          Top = 57
          Width = 368
          Height = 540
          TabStop = False
          Align = alLeft
          ColCount = 7
          DefaultColWidth = 55
          DefaultRowHeight = 17
          RowCount = 24
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
          ScrollBars = ssNone
          TabOrder = 1
          OnDrawCell = gDataDrawCell
          ExplicitLeft = -14
          ExplicitTop = 89
        end
        object pGrafico: TPanel
          Left = 369
          Top = 57
          Width = 616
          Height = 540
          Margins.Left = 50
          Align = alClient
          Color = clBlack
          ParentBackground = False
          TabOrder = 2
        end
        object pIndicadores: TPanel
          Left = 1
          Top = 1
          Width = 984
          Height = 56
          Align = alTop
          Color = clWhite
          ParentBackground = False
          TabOrder = 0
          ExplicitLeft = -39
          ExplicitTop = -5
          object lL: TLabel
            AlignWithMargins = True
            Left = 11
            Top = 4
            Width = 6
            Height = 48
            Margins.Left = 10
            Align = alLeft
            Caption = '?'
            Color = clWhite
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            ExplicitHeight = 13
          end
          object eEA: TLabeledEdit
            Left = 367
            Top = 22
            Width = 24
            Height = 21
            EditLabel.Width = 13
            EditLabel.Height = 13
            EditLabel.Caption = 'EA'
            TabOrder = 1
            Text = '1'
            Visible = False
          end
          object eEB: TLabeledEdit
            Left = 395
            Top = 22
            Width = 24
            Height = 21
            EditLabel.Width = 12
            EditLabel.Height = 13
            EditLabel.Caption = 'EB'
            TabOrder = 2
            Text = '1'
            Visible = False
          end
          object eEXA: TLabeledEdit
            Left = 459
            Top = 22
            Width = 24
            Height = 21
            EditLabel.Width = 19
            EditLabel.Height = 13
            EditLabel.Caption = 'EXA'
            TabOrder = 4
            Text = '1'
            Visible = False
          end
          object eEXB: TLabeledEdit
            Left = 485
            Top = 22
            Width = 24
            Height = 21
            EditLabel.Width = 18
            EditLabel.Height = 13
            EditLabel.Caption = 'EXB'
            TabOrder = 5
            Text = '1'
            Visible = False
          end
          object eEIA: TLabeledEdit
            Left = 543
            Top = 22
            Width = 24
            Height = 21
            EditLabel.Width = 17
            EditLabel.Height = 13
            EditLabel.Caption = 'EIA'
            TabOrder = 7
            Text = '1'
            Visible = False
          end
          object eEIB: TLabeledEdit
            Left = 570
            Top = 22
            Width = 24
            Height = 21
            EditLabel.Width = 16
            EditLabel.Height = 13
            EditLabel.Caption = 'EIB'
            TabOrder = 8
            Text = '1'
            Visible = False
          end
          object bAplicar: TButton
            Left = 626
            Top = 20
            Width = 47
            Height = 25
            Caption = 'Aplicar'
            TabOrder = 0
            OnClick = bAplicarClick
          end
          object eEZ: TLabeledEdit
            Left = 423
            Top = 22
            Width = 24
            Height = 21
            EditLabel.Width = 12
            EditLabel.Height = 13
            EditLabel.Caption = 'EZ'
            TabOrder = 3
            Text = '1'
            Visible = False
          end
          object eEXZ: TLabeledEdit
            Left = 511
            Top = 22
            Width = 24
            Height = 21
            EditLabel.Width = 18
            EditLabel.Height = 13
            EditLabel.Caption = 'EXZ'
            TabOrder = 6
            Text = '1'
            Visible = False
          end
          object eEIZ: TLabeledEdit
            Left = 596
            Top = 22
            Width = 24
            Height = 21
            EditLabel.Width = 16
            EditLabel.Height = 13
            EditLabel.Caption = 'EIZ'
            TabOrder = 9
            Text = '1'
            Visible = False
          end
          object cbLDB: TCheckBox
            Left = 440
            Top = 26
            Width = 65
            Height = 17
            Caption = 'LDB'
            TabOrder = 10
          end
          object cbLDZ: TCheckBox
            Left = 501
            Top = 26
            Width = 65
            Height = 17
            Caption = 'LDZ'
            TabOrder = 11
          end
        end
      end
      object pResumen: TPanel
        Left = 0
        Top = 0
        Width = 284
        Height = 598
        Align = alLeft
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
        object lMensaje: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 276
          Height = 13
          Align = alTop
          Caption = '?'
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clPurple
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          WordWrap = True
          ExplicitWidth = 6
        end
        object lSugerencia: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 23
          Width = 276
          Height = 13
          Align = alTop
          Caption = '?'
          Color = clWhite
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentColor = False
          ParentFont = False
          WordWrap = True
          ExplicitWidth = 6
        end
        object pGrids: TPanel
          Left = 1
          Top = 39
          Width = 282
          Height = 558
          Align = alClient
          TabOrder = 0
          object sgResumen: TStringGrid
            Left = 1
            Top = 1
            Width = 280
            Height = 336
            Align = alTop
            ColCount = 4
            DefaultColWidth = 60
            DefaultRowHeight = 20
            FixedCols = 0
            RowCount = 9
            FixedRows = 0
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
            ParentFont = False
            PopupMenu = pmResumen
            ScrollBars = ssNone
            TabOrder = 0
            OnDrawCell = sgResumenDrawCell
          end
          object sgResumen2: TStringGrid
            Left = 1
            Top = 337
            Width = 280
            Height = 148
            Align = alTop
            DefaultColWidth = 60
            DefaultRowHeight = 20
            RowCount = 7
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
            ParentFont = False
            PopupMenu = pmResumen2
            ScrollBars = ssNone
            TabOrder = 1
            Visible = False
            OnDrawCell = sgResumen2DrawCell
          end
          object sgLx: TStringGrid
            Left = 1
            Top = 485
            Width = 280
            Height = 53
            Align = alTop
            DefaultColWidth = 60
            DefaultRowHeight = 20
            RowCount = 2
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
            ParentFont = False
            ScrollBars = ssNone
            TabOrder = 2
            Visible = False
            OnDrawCell = sgResumen2DrawCell
          end
        end
      end
      object bTodo: TButton
        Left = 284
        Top = 0
        Width = 14
        Height = 598
        Align = alLeft
        Caption = '>'
        TabOrder = 1
        TabStop = False
        OnClick = bTodoClick
      end
    end
    object tsOsciladores: TTabSheet
      Caption = 'Osciladores'
      ImageIndex = 2
      object cbLAL: TCheckBox
        Left = 11
        Top = 5
        Width = 97
        Height = 17
        Caption = 'LAL'
        TabOrder = 0
        OnClick = cbLALClick
      end
      object cbLAC: TCheckBox
        Left = 11
        Top = 28
        Width = 97
        Height = 17
        Caption = 'LAC'
        TabOrder = 2
        OnClick = cbLACClick
      end
      object cbA11: TCheckBox
        Left = 11
        Top = 51
        Width = 97
        Height = 17
        Caption = 'A11'
        TabOrder = 4
        Visible = False
        OnClick = cbA11Click
      end
      object cbPRUA: TCheckBox
        Left = 11
        Top = 74
        Width = 97
        Height = 17
        Caption = 'PRUA'
        TabOrder = 6
        Visible = False
        OnClick = cbPRUAClick
      end
      object cbA1: TCheckBox
        Left = 131
        Top = 7
        Width = 97
        Height = 17
        Caption = 'A1'
        TabOrder = 1
        OnClick = cbAClick
      end
      object CheckBox1: TCheckBox
        Left = 131
        Top = 30
        Width = 97
        Height = 17
        Caption = 'A2'
        TabOrder = 3
        OnClick = cbAClick
      end
      object CheckBox2: TCheckBox
        Left = 131
        Top = 53
        Width = 97
        Height = 17
        Caption = 'A3'
        TabOrder = 5
        OnClick = cbAClick
      end
      object CheckBox3: TCheckBox
        Left = 131
        Top = 76
        Width = 97
        Height = 17
        Caption = 'A4'
        TabOrder = 7
        OnClick = cbAClick
      end
      object CheckBox4: TCheckBox
        Left = 131
        Top = 99
        Width = 97
        Height = 17
        Caption = 'A5'
        TabOrder = 8
        OnClick = cbAClick
      end
      object CheckBox5: TCheckBox
        Left = 131
        Top = 122
        Width = 97
        Height = 17
        Caption = 'A6'
        TabOrder = 9
        OnClick = cbAClick
      end
      object CheckBox6: TCheckBox
        Left = 131
        Top = 145
        Width = 97
        Height = 17
        Caption = 'A7'
        TabOrder = 10
        OnClick = cbAClick
      end
      object CheckBox7: TCheckBox
        Left = 131
        Top = 168
        Width = 97
        Height = 17
        Caption = 'A8'
        TabOrder = 11
        OnClick = cbAClick
      end
      object CheckBox8: TCheckBox
        Left = 131
        Top = 191
        Width = 97
        Height = 17
        Caption = 'A9'
        TabOrder = 12
        OnClick = cbAClick
      end
      object CheckBox9: TCheckBox
        Left = 131
        Top = 214
        Width = 97
        Height = 17
        Caption = 'A10'
        TabOrder = 13
        OnClick = cbAClick
      end
      object CheckBox10: TCheckBox
        Left = 131
        Top = 237
        Width = 97
        Height = 17
        Caption = 'A11'
        TabOrder = 14
        OnClick = cbAClick
      end
      object CheckBox11: TCheckBox
        Left = 131
        Top = 260
        Width = 97
        Height = 17
        Caption = 'A12'
        TabOrder = 15
        OnClick = cbAClick
      end
      object CheckBox12: TCheckBox
        Left = 131
        Top = 283
        Width = 97
        Height = 17
        Caption = 'A13'
        TabOrder = 16
        OnClick = cbAClick
      end
      object CheckBox13: TCheckBox
        Left = 131
        Top = 306
        Width = 97
        Height = 17
        Caption = 'A14'
        TabOrder = 17
        OnClick = cbAClick
      end
      object CheckBox14: TCheckBox
        Left = 131
        Top = 329
        Width = 97
        Height = 17
        Caption = 'A15'
        TabOrder = 18
        OnClick = cbAClick
      end
      object CheckBox15: TCheckBox
        Left = 131
        Top = 352
        Width = 97
        Height = 17
        Caption = 'A16'
        TabOrder = 19
        OnClick = cbAClick
      end
      object CheckBox16: TCheckBox
        Left = 131
        Top = 375
        Width = 97
        Height = 17
        Caption = 'A17'
        TabOrder = 20
        OnClick = cbAClick
      end
      object CheckBox17: TCheckBox
        Left = 131
        Top = 398
        Width = 97
        Height = 17
        Caption = 'A18'
        TabOrder = 21
        OnClick = cbAClick
      end
      object CheckBox18: TCheckBox
        Left = 131
        Top = 444
        Width = 97
        Height = 17
        Caption = 'A20'
        TabOrder = 23
        OnClick = cbAClick
      end
      object CheckBox19: TCheckBox
        Left = 131
        Top = 421
        Width = 97
        Height = 17
        Caption = 'A19'
        TabOrder = 22
        OnClick = cbAClick
      end
      object CheckBox20: TCheckBox
        Left = 131
        Top = 467
        Width = 97
        Height = 17
        Caption = 'A21'
        TabOrder = 24
        OnClick = cbAClick
      end
    end
    object tsAnalisis: TTabSheet
      Caption = 'An'#225'lisis'
      ImageIndex = 3
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 1284
        Height = 30
        Align = alTop
        TabOrder = 0
        object lNumGanadoras: TLabel
          Left = 168
          Top = 8
          Width = 6
          Height = 13
          Caption = '?'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lNumPerdedoras: TLabel
          Left = 272
          Top = 8
          Width = 6
          Height = 13
          Caption = '?'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object bCalcular: TButton
          Left = 3
          Top = 2
          Width = 63
          Height = 25
          Caption = 'Calcular'
          TabOrder = 0
          OnClick = bCalcularClick
        end
        object bCalcularInversa: TButton
          Left = 69
          Top = 2
          Width = 75
          Height = 25
          Caption = 'Calc. Inversa'
          TabOrder = 1
          OnClick = bCalcularClick
        end
        object cbAuto: TCheckBox
          Left = 440
          Top = 7
          Width = 45
          Height = 17
          Caption = 'Auto'
          TabOrder = 4
        end
        object cbAlcista: TCheckBox
          Left = 487
          Top = 7
          Width = 49
          Height = 17
          Caption = 'Alcista'
          Checked = True
          State = cbChecked
          TabOrder = 5
        end
        object eLIM: TLabeledEdit
          Left = 562
          Top = 4
          Width = 31
          Height = 21
          EditLabel.Width = 17
          EditLabel.Height = 13
          EditLabel.Caption = 'LIM'
          LabelPosition = lpLeft
          TabOrder = 2
          Text = '0'
        end
        object cbEstrategiaNormal: TCheckBox
          Left = 364
          Top = 7
          Width = 72
          Height = 17
          Caption = 'Est. normal'
          TabOrder = 3
        end
      end
      object sgPosiciones: TStringGrid
        Left = 0
        Top = 30
        Width = 609
        Height = 568
        Align = alLeft
        ColCount = 10
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 2
        TabOrder = 1
        OnDrawCell = sgPosicionesDrawCell
        OnSelectCell = sgPosicionesSelectCell
        ColWidths = (
          45
          64
          50
          64
          56
          49
          58
          64
          64
          64)
      end
    end
  end
  object cbLDA: TCheckBox
    Left = 671
    Top = 51
    Width = 66
    Height = 17
    Caption = 'LDA'
    TabOrder = 1
  end
  object pmResumen: TPopupMenu
    Left = 104
    Top = 112
  end
  object pmResumen2: TPopupMenu
    Left = 80
    Top = 464
  end
end
