inherited fSCMain: TfSCMain
  Left = 0
  Top = 0
  Caption = 'SymbolChart'
  ClientHeight = 535
  ClientWidth = 783
  Color = clNone
  Font.Name = 'Tahoma'
  OldCreateOrder = True
  OnCloseQuery = FormCloseQuery
  OnDestroy = FormDestroy
  OnKeyUp = FormKeyUp
  ExplicitWidth = 791
  ExplicitHeight = 569
  PixelsPerInch = 96
  TextHeight = 13
  object DockArribaBotones: TSpTBXDock
    Left = 0
    Top = 26
    Width = 783
    Height = 9
  end
  object DockMenu: TSpTBXDock
    Left = 0
    Top = 0
    Width = 783
    Height = 26
    object ToolbarMenu: TSpTBXToolbar
      Left = 0
      Top = 0
      ChevronHint = 'M'#225's botones|'
      TabOrder = 0
      Caption = 'ToolbarMenu'
    end
  end
  object DockArriba: TSpTBXDock
    Left = 0
    Top = 35
    Width = 783
    Height = 9
  end
  object DockAbajoBotones: TSpTBXDock
    Left = 0
    Top = 517
    Width = 783
    Height = 9
    Position = dpBottom
  end
  object DockAbajo: TSpTBXDock
    Left = 0
    Top = 526
    Width = 783
    Height = 9
    BackgroundOnToolbars = False
    Position = dpBottom
  end
  object PanelCentro: TPanel
    Left = 0
    Top = 44
    Width = 783
    Height = 473
    Align = alClient
    Color = clNone
    ParentBackground = False
    TabOrder = 3
    object PanelGrafico: TPanel
      Left = 10
      Top = 10
      Width = 763
      Height = 453
      Align = alClient
      BevelOuter = bvNone
      Color = clNone
      Constraints.MinHeight = 11
      ParentBackground = False
      TabOrder = 2
      object PanelGraficoTop: TPanel
        Left = 0
        Top = 0
        Width = 763
        Height = 33
        Align = alTop
        BevelOuter = bvNone
        Color = clNone
        ParentBackground = False
        TabOrder = 0
      end
    end
    object DockAbajoCentro: TSpTBXDock
      Left = 1
      Top = 463
      Width = 781
      Height = 9
      Position = dpBottom
    end
    object DockArribaCentro: TSpTBXDock
      Left = 1
      Top = 1
      Width = 781
      Height = 9
    end
    object DockDerechaCentro: TSpTBXDock
      Left = 773
      Top = 10
      Width = 9
      Height = 453
      Position = dpRight
    end
    object DockIzquierdaCentro: TSpTBXDock
      Left = 1
      Top = 10
      Width = 9
      Height = 453
      Position = dpLeft
    end
  end
  object ApplicationEvents: TApplicationEvents
    OnDeactivate = ApplicationEventsDeactivate
    Left = 280
    Top = 112
  end
end
