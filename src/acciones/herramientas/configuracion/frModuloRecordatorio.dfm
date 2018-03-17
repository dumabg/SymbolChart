inherited fModuloRecordatorio: TfModuloRecordatorio
  object cbRecordatorio: TCheckBox [0]
    Left = 69
    Top = 40
    Width = 244
    Height = 17
    Caption = 'Mostrar el recordatorio al iniciar el programa'
    Checked = True
    State = cbChecked
    TabOrder = 0
  end
  object bVerRecordatorio: TButton [1]
    Left = 87
    Top = 106
    Width = 106
    Height = 31
    Caption = 'Ver recordatorio'
    TabOrder = 1
    OnClick = bVerRecordatorioClick
  end
end
