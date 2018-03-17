inherited fBaseMasterDetalle: TfBaseMasterDetalle
  ClientHeight = 364
  ClientWidth = 659
  ExplicitWidth = 667
  ExplicitHeight = 398
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TJvNetscapeSplitter
    Left = 185
    Top = 0
    Height = 364
    Align = alLeft
    MinSize = 1
    Maximized = False
    Minimized = False
    ButtonCursor = crDefault
    ExplicitLeft = 201
    ExplicitTop = 8
  end
  object pDetalle: TPanel
    Left = 195
    Top = 0
    Width = 464
    Height = 364
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 201
    ExplicitTop = -8
  end
  object pMaster: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 364
    Align = alLeft
    TabOrder = 0
    object gMaster: TJvDBUltimGrid
      Left = 1
      Top = 29
      Width = 183
      Height = 334
      Align = alClient
      DataSource = dsMaster
      Enabled = False
      Options = [dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      SelectColumnsDialogStrings.Caption = 'Select columns'
      SelectColumnsDialogStrings.OK = '&OK'
      SelectColumnsDialogStrings.NoSelectionWarning = 'At least one column must be visible!'
      EditControls = <>
      RowsHeight = 17
      TitleRowHeight = 17
      Columns = <
        item
          Expanded = False
          FieldName = 'NOMBRE'
          Visible = True
        end>
    end
    object TBXToolbar1: TSpTBXToolbar
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 177
      Height = 22
      Align = alTop
      Images = RecursosListas.ImageList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Caption = 'TBXToolbar1'
      object TBXItem1: TSpTBXItem
        Action = Anadir
      end
      object TBXItem2: TSpTBXItem
        Action = Borrar
      end
    end
  end
  object dsMaster: TDataSource
    OnDataChange = dsMasterDataChange
    Left = 56
    Top = 160
  end
  object ActionList: TActionList
    Left = 56
    Top = 72
    object Anadir: TAction
      Category = 'Master'
      Caption = 'A'#241'adir'
      Hint = 'A'#241'adir'
      ImageIndex = 0
      OnExecute = AnadirExecute
    end
    object Borrar: TDataSetDelete
      Category = 'Master'
      Caption = 'Borrar'
      Enabled = False
      Hint = 'Borrar'
      ImageIndex = 1
      DataSource = dsMaster
    end
  end
end
