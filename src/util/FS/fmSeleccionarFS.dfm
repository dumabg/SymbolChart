inherited fSeleccionarFS: TfSeleccionarFS
  BorderStyle = bsSizeToolWin
  ClientHeight = 456
  ClientWidth = 334
  ExplicitWidth = 342
  ExplicitHeight = 482
  PixelsPerInch = 96
  TextHeight = 13
  inline fFS: TfFS
    Left = 0
    Top = 0
    Width = 334
    Height = 424
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 80
    ExplicitTop = 136
    inherited TreeFS: TVirtualStringTree
      Width = 334
      Height = 424
      OnChange = fFS1TreeFSChange
      ExplicitTop = -3
      ExplicitWidth = 338
      ExplicitHeight = 424
      WideDefaultText = 'Sin nombre'
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 424
    Width = 334
    Height = 32
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      334
      32)
    object bSeleccionar: TBitBtn
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 99
      Height = 27
      Anchors = [akLeft]
      Caption = 'Seleccionar'
      Enabled = False
      TabOrder = 0
      Kind = bkOK
      ExplicitTop = 6
    end
    object BitBtn2: TBitBtn
      AlignWithMargins = True
      Left = 110
      Top = 3
      Width = 99
      Height = 27
      Anchors = [akLeft]
      Caption = 'Cancelar'
      TabOrder = 1
      Kind = bkCancel
    end
  end
end
