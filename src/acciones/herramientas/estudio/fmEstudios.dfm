inherited fEstudios: TfEstudios
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Estudios'
  ClientHeight = 504
  ClientWidth = 889
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  ExplicitWidth = 897
  ExplicitHeight = 538
  PixelsPerInch = 96
  TextHeight = 13
  inherited Splitter: TJvNetscapeSplitter
    Height = 504
    ExplicitHeight = 512
  end
  inherited pDetalle: TPanel
    Width = 718
    Height = 504
    Visible = True
    ExplicitWidth = 718
    ExplicitHeight = 504
    object pCargando: TPanel
      Left = 0
      Top = 0
      Width = 718
      Height = 27
      Align = alTop
      BevelOuter = bvNone
      Color = 16316664
      ParentBackground = False
      TabOrder = 0
      object lMensaje: TLabel
        Left = 10
        Top = 7
        Width = 64
        Height = 13
        Caption = 'Calculando'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 33023
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object sbCancelar: TSpeedButton
        Left = 306
        Top = 2
        Width = 75
        Height = 23
        Caption = 'Cancelar'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Glyph.Data = {
          22050000424D2205000000000000360000002800000013000000150000000100
          180000000000EC040000C30E0000C30E00000000000000000000C8D0D4C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
          D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8
          D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D48080
          80808080C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
          D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D40000FF000080000080
          808080C8D0D4C8D0D4C8D0D4C8D0D4C8D0D40000FF808080C8D0D4C8D0D4C8D0
          D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D40000FF00008000008000008080
          8080C8D0D4C8D0D4C8D0D40000FF000080000080808080C8D0D4C8D0D4C8D0D4
          C8D0D4000000C8D0D4C8D0D4C8D0D40000FF0000800000800000800000808080
          80C8D0D40000FF000080000080000080000080808080C8D0D4C8D0D4C8D0D400
          0000C8D0D4C8D0D4C8D0D4C8D0D40000FF000080000080000080000080808080
          000080000080000080000080000080808080C8D0D4C8D0D4C8D0D4000000C8D0
          D4C8D0D4C8D0D4C8D0D4C8D0D40000FF00008000008000008000008000008000
          0080000080000080808080C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D40000FF0000800000800000800000800000800000
          80808080C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8
          D0D4C8D0D4C8D0D4C8D0D4000080000080000080000080000080808080C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0
          D4C8D0D4C8D0D40000FF000080000080000080000080808080C8D0D4C8D0D4C8
          D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
          0000FF000080000080000080000080000080808080C8D0D4C8D0D4C8D0D4C8D0
          D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D40000FF00008000
          0080000080808080000080000080000080808080C8D0D4C8D0D4C8D0D4C8D0D4
          C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D40000FF0000800000800000808080
          80C8D0D40000FF000080000080000080808080C8D0D4C8D0D4C8D0D4C8D0D400
          0000C8D0D4C8D0D4C8D0D4C8D0D40000FF000080000080808080C8D0D4C8D0D4
          C8D0D40000FF000080000080000080808080C8D0D4C8D0D4C8D0D4000000C8D0
          D4C8D0D4C8D0D4C8D0D4C8D0D40000FF000080C8D0D4C8D0D4C8D0D4C8D0D4C8
          D0D40000FF000080000080000080C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
          D40000FF0000800000FFC8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8
          D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0
          D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
          D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
          C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
          D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
          D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
          C8D0D4000000}
        ParentFont = False
        OnClick = sbCancelarClick
      end
      object ProgressBar: TProgressBar
        Left = 84
        Top = 5
        Width = 216
        Height = 17
        Step = 1
        TabOrder = 0
      end
    end
    inline fEstudioCuenta: TfEstudioCuenta
      Left = 0
      Top = 27
      Width = 718
      Height = 477
      Align = alClient
      TabOrder = 1
      ExplicitTop = 27
      ExplicitWidth = 718
      ExplicitHeight = 477
      inherited pcPosiciones: TPageControl
        Width = 712
        Height = 471
        ExplicitWidth = 712
        ExplicitHeight = 471
        inherited tsCaracteristicas: TTabSheet
          ExplicitWidth = 704
          ExplicitHeight = 443
          inherited Label2: TLabel
            Width = 56
            ExplicitWidth = 56
          end
          inherited Label3: TLabel
            Width = 31
            ExplicitWidth = 31
          end
          inherited Label5: TLabel
            Width = 32
            ExplicitWidth = 32
          end
          inherited Label7: TLabel
            Width = 47
            ExplicitWidth = 47
          end
          inherited Label18: TLabel
            Width = 56
            ExplicitWidth = 56
          end
          inherited sbCargar: TSpeedButton
            Left = 568
            ExplicitLeft = 560
          end
          inherited Bevel1: TBevel
            Width = 585
            ExplicitWidth = 577
          end
          inherited dbeDescripcion: TDBMemo
            Width = 641
            ExplicitWidth = 641
          end
          inherited dbtDescripcionTipo: TDBMemo
            Width = 624
            Height = 97
            ExplicitWidth = 624
            ExplicitHeight = 97
          end
        end
        inherited tsMensajes: TTabSheet
          TabVisible = False
          inherited JvDBUltimGrid1: TJvDBUltimGrid
            TitleFont.Name = 'MS Sans Serif'
          end
        end
        inherited tsPosicionesAbiertas: TTabSheet
          TabVisible = False
          ExplicitWidth = 0
          inherited GridPosAbiertas: TJvDBUltimGrid
            TitleFont.Name = 'MS Sans Serif'
          end
        end
        inherited tsPosicionesCerradas: TTabSheet
          TabVisible = False
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          inherited GridPosCerradas: TJvDBUltimGrid
            TitleFont.Name = 'MS Sans Serif'
            Columns = <
              item
                Expanded = False
                FieldName = 'NOMBRE'
                Width = 120
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'SIMBOLO'
                Width = 30
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'MERCADO'
                Width = 63
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'POSICION'
                Width = 16
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'NUM_ACCIONES'
                Width = 35
                Visible = True
              end
              item
                Color = 15269887
                Expanded = False
                FieldName = 'FECHA_HORA_COMPRA'
                Width = 87
                Visible = True
              end
              item
                Color = 15269887
                Expanded = False
                FieldName = 'CAMBIO_COMPRA'
                Width = 38
                Visible = True
              end
              item
                Color = 15269887
                Expanded = False
                FieldName = 'COMISION_COMPRA'
                Width = 41
                Visible = True
              end
              item
                Color = 16775666
                Expanded = False
                FieldName = 'FECHA_HORA'
                Width = 83
                Visible = True
              end
              item
                Color = 16775666
                Expanded = False
                FieldName = 'CAMBIO'
                Width = 34
                Visible = True
              end
              item
                Color = 16775666
                Expanded = False
                FieldName = 'COMISION'
                Width = 40
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'GANANCIA'
                Width = 35
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'MONEDA'
                Width = 74
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'MONEDA_VALOR'
                Visible = False
              end>
          end
          inherited pCurvaCapital: TPanel
            inherited Splitter: TJvNetscapeSplitter
              ExplicitHeight = 274
            end
            inherited GridCurvaCapital: TJvDBUltimGrid
              TitleFont.Name = 'MS Sans Serif'
            end
            inherited ChartCurvaCapital: TChart
              inherited Series1: TAreaSeries
                Data = {
                  02060000000000000000003E4000FF000000000000000032C0FF000000000000
                  00000059C0FF0000000000000000388840000000200000000000588640000000
                  200000000000D0864000000020}
              end
            end
          end
        end
        inherited tsMovimientos: TTabSheet
          TabVisible = False
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          inherited GridMovimientos: TJvDBUltimGrid
            TitleFont.Name = 'MS Sans Serif'
            Columns = <
              item
                Expanded = False
                FieldName = 'NUM_MOVIMIENTO'
                Width = 37
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'FECHA_HORA'
                Width = 49
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'TIPO'
                Width = 63
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'NOMBRE'
                Width = 108
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'SIMBOLO'
                Width = 30
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'MERCADO'
                Width = 51
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'POSICION'
                Width = 15
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'NUM_ACCIONES'
                Width = 29
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'CAMBIO'
                Width = 28
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'COMISION'
                Width = 28
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'COSTE'
                Width = 57
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'GANANCIA'
                Width = 51
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'MONEDA'
                Width = 51
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'MONEDA_VALOR'
                Visible = False
              end
              item
                Expanded = False
                FieldName = 'GANANCIA_MONEDA_BASE'
                Width = 57
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'OR_NUM_MOVIMIENTO'
                Width = 40
                Visible = True
              end>
          end
        end
      end
      inherited dsPosicionesAbiertas: TDataSource
        Left = 304
      end
      inherited ActionList: TActionList
        Left = 584
        Top = 88
        inherited Cargar: TAction
          OnExecute = fEstudioCuentaCargarExecute
        end
        inherited Descargar: TAction
          OnExecute = fEstudioCuentaDescargarExecute
        end
      end
      inherited ImageList: TImageList
        Left = 440
        Top = 24
      end
    end
  end
  inherited fFS: TfEditFS
    Height = 504
    ExplicitHeight = 504
    inherited TreeFS: TVirtualStringTree
      Height = 476
      OnStructureChange = fFSTreeFSStructureChange
      ExplicitHeight = 476
      WideDefaultText = 'Sin nombre'
    end
    inherited ActionList: TActionList
      inherited BorrarFichero: TAction
        OnExecute = fFSBorrarFicheroExecute
      end
    end
  end
end
