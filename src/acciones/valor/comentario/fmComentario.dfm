inherited fComentario: TfComentario
  Left = 341
  Top = 236
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Comentario'
  OldCreateOrder = True
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  object Comentario: TRichEditReadOnly
    Left = 0
    Top = 35
    Width = 682
    Height = 404
    Align = alClient
    ScrollBars = ssVertical
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 682
    Height = 35
    Align = alTop
    TabOrder = 1
    object ToolbarVoz: TSpTBXToolbar
      Left = 7
      Top = 6
      Width = 69
      Height = 22
      DockPos = 287
      Images = LectorImages.ImageListVoz
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Caption = 'ToolbarVoz'
      object TBXItem120: TSpTBXItem
        Action = VozReproducir
      end
      object TBXItem119: TSpTBXItem
        Action = VozPausa
      end
      object TBXItem118: TSpTBXItem
        Action = VozParar
      end
    end
  end
  object ActionManagerVoz: TActionManager
    Left = 360
    Top = 56
    StyleName = 'XP Style'
    object VozReproducir: TAction
      Category = 'Voz'
      Caption = 'VozReproducir'
      Hint = 'Reproducir'
      ImageIndex = 0
      OnExecute = VozReproducirExecute
    end
    object VozPausa: TAction
      Category = 'Voz'
      Caption = 'VozPausa'
      Enabled = False
      Hint = 'Pausa'
      ImageIndex = 1
      OnExecute = VozPausaExecute
    end
    object VozParar: TAction
      Category = 'Voz'
      Caption = 'VozParar'
      Enabled = False
      Hint = 'Parar'
      ImageIndex = 2
      OnExecute = VozPararExecute
    end
  end
end
