inherited fStopsManuales: TfStopsManuales
  Left = 356
  Top = 472
  BorderStyle = bsSizeToolWin
  Caption = 'Stops din'#225'micos manuales'
  ClientHeight = 336
  ClientWidth = 512
  FormStyle = fsStayOnTop
  OnCreate = FormCreate
  ExplicitWidth = 520
  ExplicitHeight = 362
  PixelsPerInch = 96
  TextHeight = 13
  object PageList: TJvPageList
    Left = 0
    Top = 0
    Width = 512
    Height = 336
    ActivePage = PageStopsDinamicos
    PropagateEnable = False
    Align = alClient
    object PageStopsDinamicos: TJvStandardPage
      Left = 0
      Top = 0
      Width = 512
      Height = 336
      object ActionToolBar: TActionToolBar
        Left = 0
        Top = 0
        Width = 512
        Height = 26
        ActionManager = ActionManager
        Caption = 'ActionToolBar'
        ColorMap.HighlightColor = 15660791
        ColorMap.BtnSelectedColor = clBtnFace
        ColorMap.UnusedColor = 15660791
        HorzMargin = 15
        ParentShowHint = False
        ShowHint = True
        Spacing = 5
      end
      object GridStops: TJvDBUltimGrid
        Left = 0
        Top = 26
        Width = 512
        Height = 310
        Align = alClient
        DataSource = dsStops
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete]
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDrawColumnCell = GridStopsDrawColumnCell
        AutoAppend = False
        OnGetCellParams = GridStopsGetCellParams
        SelectColumn = scGrid
        ShowCellHint = True
        AutoSizeColumns = True
        SelectColumnsDialogStrings.Caption = 'Seleccionar columnas'
        SelectColumnsDialogStrings.OK = '&OK'
        SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
        EditControls = <>
        RowsHeight = 17
        TitleRowHeight = 17
        Columns = <
          item
            Expanded = False
            FieldName = 'LARGO_CORTO'
            Title.Caption = 'Pos'
            Width = 24
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VALOR'
            Title.Caption = 'Valor'
            Width = 123
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'POSICION_INICIAL'
            Title.Caption = 'Pos. inicial'
            Width = 59
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CAMBIO'
            Title.Caption = 'Cambio'
            Width = 59
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'GANANCIA'
            Title.Caption = '% Ganancia'
            Width = 65
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'STOP'
            Title.Caption = 'Stop'
            Width = 65
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PER_CENT_GANA'
            Title.Caption = '% gane'
            Width = 46
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PER_CENT_PIERDE'
            Title.Caption = '% pierde'
            Width = 47
            Visible = True
          end>
      end
    end
    object PageNuevoStop: TJvStandardPage
      Left = 0
      Top = 0
      Width = 512
      Height = 336
      object Label10: TLabel
        Left = 62
        Top = 171
        Width = 155
        Height = 13
        Caption = 'Pongo un stop de protecci'#243'n en '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 62
        Top = 42
        Width = 93
        Height = 13
        Caption = 'Me he posicionado '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label7: TLabel
        Left = 246
        Top = 42
        Width = 49
        Height = 13
        Caption = 'en el valor'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label8: TLabel
        Left = 62
        Top = 104
        Width = 112
        Height = 13
        Caption = 'He comprado al cambio'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 62
        Top = 141
        Width = 137
        Height = 13
        Caption = 'El valor ha cerrado al cambio'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object LabelLargoCorto: TLabel
        Left = 125
        Top = 207
        Width = 85
        Height = 13
        Caption = 'que debe subir un'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 260
        Top = 207
        Width = 74
        Height = 13
        Caption = '% cuando gane'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label1: TLabel
        Left = 191
        Top = 235
        Width = 20
        Height = 13
        Caption = 'y un'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 260
        Top = 235
        Width = 82
        Height = 13
        Caption = '% cuando pierde '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object iLargo: TImage
        Left = 212
        Top = 36
        Width = 17
        Height = 10
        AutoSize = True
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
      object iCorto: TImage
        Left = 213
        Top = 56
        Width = 15
        Height = 10
        AutoSize = True
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
        Transparent = True
      end
      object rbLargo: TRadioButton
        Left = 157
        Top = 32
        Width = 51
        Height = 17
        Action = Largo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        TabStop = True
      end
      object PosicionInicial: TDBEdit
        Left = 181
        Top = 100
        Width = 65
        Height = 21
        DataField = 'POSICION_INICIAL'
        DataSource = dsStops
        TabOrder = 0
        OnKeyPress = OnCurrencyKeyPress
      end
      object Cambio: TDBEdit
        Left = 204
        Top = 137
        Width = 65
        Height = 21
        DataField = 'CAMBIO'
        DataSource = dsStops
        TabOrder = 1
      end
      object Stop: TDBEdit
        Left = 220
        Top = 167
        Width = 65
        Height = 21
        DataField = 'STOP'
        DataSource = dsStops
        TabOrder = 2
      end
      object Ganancia: TDBEdit
        Left = 216
        Top = 203
        Width = 41
        Height = 21
        DataField = 'PER_CENT_GANA'
        DataSource = dsStops
        TabOrder = 3
      end
      object Perdida: TDBEdit
        Left = 216
        Top = 231
        Width = 41
        Height = 21
        DataField = 'PER_CENT_PIERDE'
        DataSource = dsStops
        TabOrder = 4
      end
      object rbCorto: TRadioButton
        Left = 157
        Top = 52
        Width = 50
        Height = 17
        Action = Corto
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
      end
      object bAceptar: TJvXPButton
        Left = 148
        Top = 288
        Width = 96
        Height = 28
        Caption = 'Aceptar'
        TabOrder = 7
        Default = True
        Glyph.Data = {
          07544269746D6170AA040000424DAA0400000000000036000000280000001400
          000013000000010018000000000074040000C30E0000C30E0000000000000000
          0000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
          D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
          D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D4800000800000C8D0D4C8D0D4C8D0D4C8D0D4C8D0
          D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
          D0D4C8D0D4800000008000008000800000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D48000
          00008000008000008000008000800000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
          D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4800000008000008000
          008000008000008000008000800000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
          D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D480000000800000800000800000FF0000
          8000008000008000008000800000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D400800000800000800000FF00C8D0D400FF000080
          00008000008000800000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
          D0D4C8D0D4C8D0D400FF0000800000FF00C8D0D4C8D0D4C8D0D400FF00008000
          008000008000800000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
          D4C8D0D4C8D0D400FF00C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400FF0000800000
          8000008000800000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400FF000080000080
          00008000800000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
          D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400FF00008000008000
          008000800000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
          D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400FF0000800000800000
          8000800000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400FF000080000080000080
          00800000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
          D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400FF00008000008000800000
          C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
          D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400FF00008000008000C8D0D4C8
          D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400FF00C8D0D4C8D0D4C8D0D4C8D0
          D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
          D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
          D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4}
        OnClick = bAceptarClick
      end
      object bCancelar: TJvXPButton
        Left = 268
        Top = 288
        Width = 96
        Height = 28
        Caption = 'Cancelar'
        TabOrder = 8
        Glyph.Data = {
          07544269746D617022050000424D220500000000000036000000280000001300
          0000150000000100180000000000EC040000C30E0000C30E0000000000000000
          0000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0
          D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
          D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4
          C8D0D4C8D0D4808080808080C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
          D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D400
          00FF000080000080808080C8D0D4C8D0D4C8D0D4C8D0D4C8D0D40000FF808080
          C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D40000FF0000
          80000080000080808080C8D0D4C8D0D4C8D0D40000FF000080000080808080C8
          D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D40000FF000080000080
          000080000080808080C8D0D40000FF000080000080000080000080808080C8D0
          D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D40000FF00008000008000
          0080000080808080000080000080000080000080000080808080C8D0D4C8D0D4
          C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D40000FF0000800000800000
          80000080000080000080000080000080808080C8D0D4C8D0D4C8D0D4C8D0D400
          0000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D40000FF000080000080000080
          000080000080000080808080C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0
          D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400008000008000008000008000
          0080808080C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D4C8D0D40000FF0000800000800000800000808080
          80C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8
          D0D4C8D0D4C8D0D40000FF000080000080000080000080000080808080C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0
          D40000FF000080000080000080808080000080000080000080808080C8D0D4C8
          D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D40000FF000080
          000080000080808080C8D0D40000FF000080000080000080808080C8D0D4C8D0
          D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D40000FF00008000008080
          8080C8D0D4C8D0D4C8D0D40000FF000080000080000080808080C8D0D4C8D0D4
          C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D40000FF000080C8D0D4C8D0
          D4C8D0D4C8D0D4C8D0D40000FF000080000080000080C8D0D4C8D0D4C8D0D400
          0000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
          C8D0D4C8D0D4C8D0D40000FF0000800000FFC8D0D4C8D0D4C8D0D4000000C8D0
          D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
          D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
          D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8
          D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0
          D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
          D0D4C8D0D4C8D0D4C8D0D4000000}
        OnClick = bCancelarClick
      end
      object Valores: TJvDBSearchComboBox
        Left = 301
        Top = 38
        Width = 188
        Height = 21
        DataField = 'NOMBRE'
        DataSource = dsValores
        ItemHeight = 13
        TabOrder = 9
      end
    end
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = Largo
            Caption = '&Largo'
            ImageIndex = 1
          end
          item
            Action = Corto
            Caption = '&Corto'
          end>
      end
      item
        Items = <
          item
            Action = Anadir
            ImageIndex = 3
            ShowCaption = False
            ShortCut = 45
          end
          item
            Caption = '-'
          end>
      end
      item
        Items = <
          item
            ChangesAllowed = []
            Action = Largo
            Caption = '&Largo'
            ImageIndex = 1
          end
          item
            ChangesAllowed = []
            Action = Corto
            Caption = '&Corto'
          end>
      end
      item
        Items = <
          item
            Action = Largo
            Caption = '&Largo'
            ImageIndex = 1
          end
          item
            Action = Corto
            Caption = '&Corto'
          end>
      end
      item
        Items = <
          item
            Action = Largo
            Caption = '&Largo'
            ImageIndex = 1
          end
          item
            Action = Corto
            Caption = '&Corto'
          end>
      end
      item
        Items = <
          item
            Action = BuscarValor
            ImageIndex = 6
            ShowCaption = False
          end>
      end
      item
        Items = <
          item
            Action = Anadir
            ImageIndex = 0
            ShortCut = 45
          end
          item
            Action = Borrar
            ImageIndex = 1
            ShortCut = 46
          end
          item
            Caption = '-'
          end
          item
            Action = CambiarCambio
            ImageIndex = 2
          end>
        ActionBar = ActionToolBar
      end>
    Images = ImageList
    Left = 216
    Top = 152
    StyleName = 'XP Style'
    object Largo: TAction
      Category = 'Nuevo'
      Caption = 'Largo'
      Checked = True
      OnExecute = LargoExecute
      OnUpdate = LargoUpdate
    end
    object Corto: TAction
      Category = 'Nuevo'
      Caption = 'Corto'
      OnExecute = CortoExecute
    end
    object Anadir: TDataSetInsert
      Category = 'Principal'
      Enabled = False
      Hint = 'A'#241'adir un nuevo stop din'#225'mico'
      ImageIndex = 0
      ShortCut = 45
      OnExecute = AnadirExecute
    end
    object BuscarValor: TAction
      Category = 'Nuevo'
    end
    object CambiarCambio: TAction
      Category = 'Principal'
      Hint = 'Cambiar el cambio del valor seleccionado'
      ImageIndex = 2
      OnExecute = CambiarCambioExecute
      OnUpdate = CambiarCambioUpdate
    end
    object Borrar: TAction
      Category = 'Principal'
      Hint = 'Borrar el stop din'#225'mico seleccionado'
      ImageIndex = 1
      ShortCut = 46
      OnExecute = BorrarExecute
      OnUpdate = BorrarUpdate
    end
  end
  object dsStops: TDataSource
    DataSet = StopsManuales.Stops
    Left = 312
    Top = 232
  end
  object dsValores: TDataSource
    DataSet = StopsManuales.Valores
    Left = 56
    Top = 202
  end
  object ImageList: TImageList
    Left = 352
    Top = 136
    Bitmap = {
      494C010103000500040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000003E9B4600229331001D7430001C6D2E00117F21003D9646000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000259B360032DB560032D6600034D35F0020C441001F902E000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000398E440057ED7B0041E2760045E1760043D5650031813A000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000008080800000000000303030001010100000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000056A35F005DE37F0032C164002EBA5C0042C661004C9551000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F0EFED00EBECEA00EAEAE800EBEBE800ECECE900EBEBE800EDEDEA00EDEE
      EC00EEEEEE00000000000000000000000000000000000000000000000000FBFB
      FB000000000000000000F1F1F1000000000000000000EFEFEF00030303000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004EB056002AA138004194
      490045914A0019912C004EE8710053EC850050EB800034D1580010892100458E
      4A003989420020912F00459E4E0000000000000000000000000000000000EFEB
      EB00D2D3D600ADAFBF00ABABBF00ACABBF00ADACC000ABABBE00ADACC000CED2
      D400EAEBEC000000000000000000000000000000000000000000000000000000
      000000000000FEFEFE00FBFBFB00FCFCFC000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000289B340040E65D005DF0
      7D005FDF7A0040D8610045E86F0039CE6C0039D76D002FD95B0036D35A0052D6
      710042D464001EC23F000D7B1D0000000000000000000000000000000000CBCC
      D6008B8CC5008487DE008E8DEE008F8DF0008E8CEE008E8CEE008684E2008E8F
      C500CECBE0000000000000000000000000000000000000000000000000000000
      000004040400FCFCFC00F8F8F800000000000000000000000000F5F5F5000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000399046006CFF920060F9
      8C0052DA7C0050E37B005EF28E005AD78D0053DB890041DF75003ED96E003DC9
      6B0036D267003EDD69001B6C2D00000000000000000000000000000000009D9D
      CB006D68E3007073FD007675FC007576FE007675FD007473FB007475FB006C6C
      E4009C9CCF000000000000000000000000000000000000000000000000000000
      0000060606000000000006060600000000000606060000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000038903C0076FFA30077FA
      93006ED39F0063EE7F005FF5910050E0790056D5900046DA7C0042D7750041CB
      73003AD56C003DDF690012692500000000000000000000000000000000009090
      D6005D5CEF008684F7008B86FC008386FC008588FF008587FE008386FE005D5F
      EE00908EDE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F0F0F0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003BAB47005CF08C0085FF
      9F0089F0B70069F8850064FE990051E7830050E4860046E9760050E674006EEF
      8E005EF0800036DD58001D912E0000000000000000000000000000000000BEBB
      DC006B6BDD00A19FF500ACB4F700ADB1F800B0B0FA00B0AFF800A2A0F300726A
      DD00BCC0D8000000000000000000000000000000000000000000000000000000
      0000050505000000000002020200010101000303030000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004DB544002DA33C0048A8
      3D00509A5A002AA5250062F17E006EF98A005AEF8D003FD56300188C2B004A92
      50003D8D4600209430003F9D480000000000000000000000000000000000EEE7
      EB00BEC2DC009790E1008D88E7008987E8008B89E5008988DF008C8EE400C1C2
      DD00ECE8EB000000000000000000000000000000000000000000000000000000
      00000000000000000000EBEBEB00FAFAFA000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000066B0700084EBB2006ACF9B0049D37B005BDC7B005BA361000000
      000000000000000000000000000000000000000000000000000000000000EEF0
      EC00EDECED00E8F0ED00EFF0EB00F2EEF200F0EEF000F0F0EF00F0F0EE00EDF0
      EB00EFEBF100000000000000000000000000000000000000000000000000FEFE
      FE00FDFDFD00000000000000000000000000F6F6F600F3F3F300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000003C9C31007BFF95007EFF9A005DF88F0053E5750035853E000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FAFA
      FA00000000000000000000000000080808000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000036AC45005FF38F0075FEA2005FFF8B0041E8630032A642000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000049B140003BAB4700409844003B924E00279B380049A752000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000F81FFFFFFFFF0000
      F81FFFFFFFFF0000F81FFFFFFC3F0000F81FF007E99F00008001E007F0FF0000
      8001E007F1DF00008001E007E03F00008001E007F6FF00008001E007E03F0000
      8001E007F4FF0000F81FE007E31F0000F81FFFFFEC3F0000F81FFFFFFFFF0000
      F81FFFFFFFFF0000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
end
