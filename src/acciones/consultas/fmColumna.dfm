inherited fColumna: TfColumna
  Caption = 'Columna'
  ClientHeight = 141
  ClientWidth = 267
  OnCreate = FormCreate
  ExplicitWidth = 273
  ExplicitHeight = 173
  PixelsPerInch = 96
  TextHeight = 13
  inherited Label1: TLabel
    Left = 33
    Top = 19
    ExplicitLeft = 33
    ExplicitTop = 19
  end
  inherited Bevel2: TBevel
    Top = 92
    Height = 6
    ExplicitTop = 92
    ExplicitHeight = 6
  end
  object lTipo: TLabel [2]
    Left = 48
    Top = 62
    Width = 21
    Height = 13
    Caption = 'Tipo'
  end
  inherited bCrear: TBitBtn
    Top = 104
    Height = 28
    Caption = 'Aceptar'
    TabOrder = 2
    ExplicitTop = 104
    ExplicitHeight = 28
  end
  inherited bCancelar: TBitBtn
    Top = 104
    Height = 28
    TabOrder = 3
    ExplicitTop = 104
    ExplicitHeight = 28
  end
  inherited eNombre: TEdit
    Left = 89
    Top = 16
    ExplicitLeft = 89
    ExplicitTop = 16
  end
  object cbTipo: TComboBox
    Left = 89
    Top = 57
    Width = 76
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = cbTipoChange
  end
end
