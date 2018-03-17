inherited fBaseBuscar: TfBaseBuscar
  Left = 417
  Top = 235
  BorderStyle = bsSizeToolWin
  ClientHeight = 356
  ClientWidth = 485
  OldCreateOrder = True
  OnCreate = FormCreate
  ExplicitWidth = 493
  ExplicitHeight = 382
  PixelsPerInch = 96
  TextHeight = 13
  object GridValores: TJvDBUltimGrid
    Left = 0
    Top = 21
    Width = 485
    Height = 335
    Align = alClient
    DataSource = dsValores
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnCellClick = GridValoresCellClick
    OnDrawDataCell = GridValoresDrawDataCell
    TitleButtons = True
    SelectColumnsDialogStrings.Caption = 'Select columns'
    SelectColumnsDialogStrings.OK = '&OK'
    SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
    EditControls = <>
    RowsHeight = 17
    TitleRowHeight = 17
  end
  object eFiltrada: TEdit
    Left = 0
    Top = 0
    Width = 485
    Height = 21
    Align = alTop
    TabOrder = 0
    OnChange = eFiltradaChange
    OnKeyDown = eBusquedaKeyDown
  end
  object dsValores: TDataSource
    Left = 88
    Top = 112
  end
end
