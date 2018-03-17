inherited UtilGridColumnasVisibles: TUtilGridColumnasVisibles
  OldCreateOrder = True
  Height = 277
  Width = 373
  object GridPopup: TSpTBXPopupMenu
    OnPopup = GridPopupPopup
    Left = 88
    Top = 56
    object TBXItem3: TSpTBXItem
      Action = SeleccionarCol
    end
    object TBXSeparatorItem1: TSpTBXSeparatorItem
    end
    object TBXItem2: TSpTBXItem
      Action = AutoSize
    end
    object TBXItem1: TSpTBXItem
      Action = RestaurarCol
    end
  end
  object ActionList: TActionList
    Left = 88
    Top = 136
    object AutoSize: TAction
      Caption = 'Ancho columnas autom'#225'tico'
      Hint = 'Ancho de las columnas autom'#225'tico'
      OnExecute = AutoSizeExecute
    end
    object SeleccionarCol: TAction
      Caption = 'Seleccionar columnas'
      Hint = 'Seleccionar las columnas visibles'
      OnExecute = SeleccionarColExecute
    end
    object RestaurarCol: TAction
      Caption = 'Restaurar ancho columnas'
      Hint = 'Restaura al valor por defecto el ancho de las columnas'
      OnExecute = RestaurarColExecute
    end
  end
end
