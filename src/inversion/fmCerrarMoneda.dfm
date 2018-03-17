inherited fCerrarMoneda: TfCerrarMoneda
  Caption = 'Cerrar cambios de moneda'
  ClientHeight = 176
  ClientWidth = 283
  ExplicitWidth = 289
  ExplicitHeight = 208
  PixelsPerInch = 96
  TextHeight = 13
  inherited Bevel2: TBevel
    Top = 116
    Width = 263
  end
  inherited bAceptar: TBitBtn
    Left = 30
    Top = 134
    Anchors = [akLeft, akBottom]
    ExplicitLeft = 30
    ExplicitTop = 129
  end
  inherited bCancelar: TBitBtn
    Left = 147
    Top = 134
    Anchors = [akLeft, akBottom]
    ExplicitLeft = 147
    ExplicitTop = 129
  end
  object cbCompras: TCheckBox
    Left = 43
    Top = 75
    Width = 115
    Height = 17
    Caption = 'Aplicar a compras'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object cbVentas: TCheckBox
    Left = 43
    Top = 98
    Width = 115
    Height = 17
    Caption = 'Aplicar a ventas'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
end
