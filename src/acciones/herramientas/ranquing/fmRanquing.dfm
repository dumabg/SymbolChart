inherited fRanquing: TfRanquing
  Caption = 'Ranquing'
  ClientHeight = 501
  ClientWidth = 662
  OnShow = FormShow
  ExplicitWidth = 670
  ExplicitHeight = 535
  PixelsPerInch = 96
  TextHeight = 13
  object vtRanquing: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 662
    Height = 501
    Align = alClient
    Header.AutoSizeIndex = 0
    Header.DefaultHeight = 17
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    Header.SortColumn = 4
    Header.SortDirection = sdDescending
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnCompareNodes = vtRanquingCompareNodes
    OnFocusChanged = vtRanquingFocusChanged
    OnGetText = vtRanquingGetText
    OnHeaderClick = vtRanquingHeaderClick
    OnInitNode = vtRanquingInitNode
    ExplicitHeight = 424
    Columns = <
      item
        Position = 0
        Width = 60
        WideText = 'Simbolo'
      end
      item
        Position = 1
        Width = 400
        WideText = 'Nombre'
      end
      item
        Position = 2
        Width = 65
        WideText = 'P. anteriores'
        WideHint = 'Puntos anteriores'
      end
      item
        Position = 3
        Width = 65
        WideText = 'Puntos'
      end
      item
        Position = 4
        Width = 65
        WideText = 'Incremento'
      end>
  end
end
