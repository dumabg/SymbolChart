inherited frPanelCotizaciones: TfrPanelCotizaciones
  Width = 191
  ExplicitWidth = 191
  object ToolWindowCotizaciones: TSpTBXToolWindow
    Left = 0
    Top = 0
    Width = 191
    Height = 155
    Hint = 'Panel Cotizaciones'
    Caption = 'Cotizaciones'
    Align = alClient
    CloseButtonWhenDocked = True
    DockPos = 817
    Resizable = False
    TabOrder = 0
    OnDockChanged = ToolWindowCotizacionesDockChanged
    ClientAreaHeight = 155
    ClientAreaWidth = 191
    object Cotizaciones: TJvDBUltimGrid
      Left = 0
      Top = 0
      Width = 188
      Height = 155
      Align = alLeft
      DataSource = Data.dsCotizacion
      Options = [dgColLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnKeyDown = CotizacionesKeyDown
      AlternateRowColor = 16775673
      SelectColumnsDialogStrings.Caption = 'Select columns'
      SelectColumnsDialogStrings.OK = '&OK'
      SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
      EditControls = <>
      RowsHeight = 16
      TitleRowHeight = 16
      Columns = <
        item
          Alignment = taRightJustify
          Expanded = False
          FieldName = 'FECHA'
          Width = 102
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CIERRE'
          Width = 62
          Visible = True
        end>
    end
  end
end
