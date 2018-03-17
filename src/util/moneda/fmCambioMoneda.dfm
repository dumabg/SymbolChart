inherited fCambioMoneda2: TfCambioMoneda2
  BorderStyle = bsDialog
  Caption = 'Cambio moneda'
  ClientHeight = 132
  ClientWidth = 279
  OnShow = FormShow
  ExplicitWidth = 285
  ExplicitHeight = 164
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel2: TBevel
    AlignWithMargins = True
    Left = 10
    Top = 72
    Width = 259
    Height = 10
    Margins.Left = 10
    Margins.Right = 10
    Margins.Bottom = 50
    Align = alBottom
    Shape = bsBottomLine
    ExplicitLeft = -49
    ExplicitTop = 130
    ExplicitWidth = 331
  end
  inline fCambioMoneda: TfCambioMoneda
    Left = 8
    Top = 8
    Width = 257
    Height = 61
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitWidth = 257
    ExplicitHeight = 61
    inherited lMonedaBase: TLabel
      Width = 44
      ExplicitWidth = 44
    end
    inherited lMonedaNueva: TLabel
      Width = 23
      ExplicitWidth = 23
    end
    inherited eMonedaValor: TJvSpinEdit
      OnChange = fCambioMonedaeMonedaValorChange
    end
  end
  object bAceptar: TBitBtn
    Left = 34
    Top = 90
    Width = 97
    Height = 34
    Caption = 'Aceptar'
    TabOrder = 1
    Kind = bkOK
  end
  object bCancelar: TBitBtn
    Left = 151
    Top = 90
    Width = 97
    Height = 34
    Caption = 'Cancelar'
    TabOrder = 2
    Kind = bkCancel
  end
end
