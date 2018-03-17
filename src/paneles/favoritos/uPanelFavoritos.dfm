inherited frPanelFavoritos: TfrPanelFavoritos
  Width = 595
  Height = 128
  ExplicitWidth = 595
  ExplicitHeight = 128
  object ToolWindowFavoritos: TSpTBXToolWindow
    Left = 0
    Top = 0
    Width = 300
    Height = 21
    Hint = 'Barra Favoritos'
    Caption = 'Favoritos'
    CloseButtonWhenDocked = True
    DockableTo = [dpTop, dpBottom]
    DockPos = 0
    DockRow = 1
    FullSize = True
    Stretch = True
    TabOrder = 0
    OnDockChanged = ToolWindowFavoritosDockChanged
    ClientAreaHeight = 21
    ClientAreaWidth = 300
    MaxClientHeight = 27
    MinClientHeight = 27
    object Favoritos: TJvTabBar
      Left = 25
      Top = 0
      Width = 275
      Height = 21
      Align = alClient
      PopupMenu = PopupFavoritos
      Orientation = toBottom
      RightClickSelect = False
      HotTracking = True
      AllowUnselected = True
      Margin = 8
      AllowTabMoving = True
      Images = DataComun.ImageListBanderas
      Tabs = <>
      OnTabClosing = FavoritosTabClosing
      OnTabClosed = FavoritosTabClosed
      OnTabSelected = FavoritosTabSelected
      OnMouseUp = FavoritosMouseUp
    end
    object ToolBarAnadirFavoritos: TSpTBXToolbar
      Left = 0
      Top = 0
      Width = 25
      Height = 21
      Align = alLeft
      AutoResize = False
      CloseButton = False
      DockableTo = []
      DockMode = dmCannotFloat
      Images = ImageList
      Options = [tboShowHint]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      UpdateActions = False
      Caption = 'TBXToolbar1'
      object TBXItem22: TSpTBXItem
        Action = AnadirFavoritos
      end
    end
  end
  object ActionList: TActionList
    Images = ImageList
    Left = 280
    Top = 48
    object AnadirFavoritos: TAction
      Caption = 'A'#241'adir a favoritos'
      Hint = 'A'#241'adir el valor actual a la barra de favoritos'
      ImageIndex = 0
      OnExecute = AnadirFavoritosExecute
    end
    object CerrarTodasFavoritos: TAction
      Category = 'Opciones'
      Caption = 'Cerrar todas'
      Hint = 'Cerrar todas las pesta'#241'as de favoritos'
      OnExecute = CerrarTodasFavoritosExecute
    end
    object MostrarNombre: TAction
      Category = 'Opciones'
      Caption = 'Nombre'
      Checked = True
      Hint = 'Mostrar el nombre'
      OnExecute = MostrarNombreExecute
    end
    object MostrarSimbolo: TAction
      Category = 'Opciones'
      Caption = 'S'#237'mbolo'
      Hint = 'Mostrar el s'#237'mbolo'
      OnExecute = MostrarSimboloExecute
    end
    object MostrarBandera: TAction
      Category = 'Opciones'
      Caption = 'Bandera'
      Hint = 'Mostrar la bandera'
      OnExecute = MostrarBanderaExecute
    end
  end
  object ImageList: TImageList
    Left = 408
    Top = 48
    Bitmap = {
      494C010101000300040010001000FFFFFFFFFF00FFFFFFFFFFFFFFFF424D3600
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000056A35F005DE37F0032C164002EBA5C0042C661004C9551000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004EB056002AA138004194
      490045914A0019912C004EE8710053EC850050EB800034D1580010892100458E
      4A003989420020912F00459E4E00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000289B340040E65D005DF0
      7D005FDF7A0040D8610045E86F0039CE6C0039D76D002FD95B0036D35A0052D6
      710042D464001EC23F000D7B1D00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000399046006CFF920060F9
      8C0052DA7C0050E37B005EF28E005AD78D0053DB890041DF75003ED96E003DC9
      6B0036D267003EDD69001B6C2D00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000038903C0076FFA30077FA
      93006ED39F0063EE7F005FF5910050E0790056D5900046DA7C0042D7750041CB
      73003AD56C003DDF690012692500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003BAB47005CF08C0085FF
      9F0089F0B70069F8850064FE990051E7830050E4860046E9760050E674006EEF
      8E005EF0800036DD58001D912E00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004DB544002DA33C0048A8
      3D00509A5A002AA5250062F17E006EF98A005AEF8D003FD56300188C2B004A92
      50003D8D4600209430003F9D4800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000066B0700084EBB2006ACF9B0049D37B005BDC7B005BA361000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000003C9C31007BFF95007EFF9A005DF88F0053E5750035853E000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      000000000000000000000000FFFFFF00FFFF000000000000F81F000000000000
      F81F000000000000F81F000000000000F81F0000000000008001000000000000
      8001000000000000800100000000000080010000000000008001000000000000
      8001000000000000F81F000000000000F81F000000000000F81F000000000000
      F81F000000000000FFFF000000000000}
  end
  object PopupFavoritos: TPopupActionBar
    Left = 112
    Top = 34
    object Smbolo1: TMenuItem
      Action = MostrarSimbolo
    end
    object Nombre1: TMenuItem
      Action = MostrarNombre
    end
    object Bandera1: TMenuItem
      Action = MostrarBandera
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Cerrartodas1: TMenuItem
      Action = CerrarTodasFavoritos
    end
  end
end
