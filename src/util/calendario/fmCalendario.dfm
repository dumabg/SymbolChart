object fCalendario: TfCalendario
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'fCalendario'
  ClientHeight = 221
  ClientWidth = 327
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  inline FrameCalendario: TframeCalendario
    Left = 0
    Top = 0
    Width = 327
    Height = 221
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 322
    ExplicitHeight = 221
    inherited Panel1: TPanel
      Width = 327
      Height = 185
      ExplicitWidth = 322
      ExplicitHeight = 185
    end
    inherited Panel2: TPanel
      Top = 185
      Width = 327
      ExplicitTop = 185
      ExplicitWidth = 322
      inherited Cerrar: TSpeedButton
        Left = 297
        OnClick = FrameCalendarioCerrarClick
        ExplicitLeft = 292
      end
    end
  end
end
