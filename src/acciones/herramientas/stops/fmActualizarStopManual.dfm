inherited fActualizarStopManual: TfActualizarStopManual
  Left = 459
  Top = 542
  BorderStyle = bsDialog
  Caption = 'Actualizar Stop manual'
  ClientHeight = 176
  ClientWidth = 308
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 53
    Top = 90
    Width = 107
    Height = 13
    Caption = 'Nuevo cambio de stop'
    FocusControl = DBEdit1
  end
  object Label2: TLabel
    Left = 53
    Top = 24
    Width = 24
    Height = 13
    Caption = 'Valor'
  end
  object DBText1: TDBText
    Left = 85
    Top = 24
    Width = 50
    Height = 13
    AutoSize = True
    DataField = 'VALOR'
    DataSource = dsStops
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 53
    Top = 56
    Width = 105
    Height = 13
    Caption = 'Cambio de stop actual'
  end
  object lCambio: TLabel
    Left = 165
    Top = 56
    Width = 8
    Height = 13
    Caption = '?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object DBEdit1: TDBEdit
    Left = 165
    Top = 88
    Width = 89
    Height = 21
    DataField = 'CAMBIO'
    DataSource = dsStops
    TabOrder = 0
    OnKeyPress = OnCurrencyKeyPress
  end
  object BitBtn1: TBitBtn
    Left = 69
    Top = 136
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 173
    Top = 136
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object dsStops: TDataSource
    DataSet = StopsManuales.Stops
    Left = 256
    Top = 24
  end
end
