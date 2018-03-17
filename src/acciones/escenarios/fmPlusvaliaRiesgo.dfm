inherited fPlusvaliaRiesgo: TfPlusvaliaRiesgo
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'Escenarios - Plusval'#237'as riesgos'
  ClientHeight = 414
  ClientWidth = 646
  FormStyle = fsStayOnTop
  OnClose = FormClose
  OnCreate = FormCreate
  ExplicitWidth = 654
  ExplicitHeight = 440
  PixelsPerInch = 96
  TextHeight = 13
  object vtPlusvaliaRiesgo: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 646
    Height = 414
    Align = alClient
    Header.AutoSizeIndex = 0
    Header.DefaultHeight = 17
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    TabOrder = 0
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnCompareNodes = vtPlusvaliaRiesgoCompareNodes
    OnFocusChanged = vtPlusvaliaRiesgoFocusChanged
    OnGetText = vtPlusvaliaRiesgoGetText
    OnHeaderClick = vtPlusvaliaRiesgoHeaderClick
    OnInitNode = vtPlusvaliaRiesgoInitNode
    ExplicitWidth = 576
    ExplicitHeight = 406
    Columns = <
      item
        Position = 0
        Width = 60
        WideText = 'S'#237'mbolo'
      end
      item
        Position = 1
        Width = 250
        WideText = 'Nombre'
      end
      item
        Position = 2
        Width = 120
        WideText = 'Mercado'
      end
      item
        Position = 3
        Width = 60
        WideText = 'Plusval'#237'a'
      end
      item
        Position = 4
        Width = 60
        WideText = 'Riesgo'
      end
      item
        Position = 5
        Width = 70
        WideText = 'P - R'
      end>
  end
end
