object ExceptionDialog: TExceptionDialog
  Left = 310
  Top = 255
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'ExceptionDialog'
  ClientHeight = 392
  ClientWidth = 605
  Color = clBtnFace
  Constraints.MinWidth = 200
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    605
    392)
  PixelsPerInch = 96
  TextHeight = 13
  object BevelDetails: TBevel
    Left = 3
    Top = 155
    Width = 595
    Height = 9
    Anchors = [akLeft, akTop, akRight]
    Shape = bsTopLine
  end
  object OkBtn: TButton
    Left = 512
    Top = 4
    Width = 88
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Cerrar'
    ModalResult = 1
    TabOrder = 0
  end
  object DetailsBtn: TButton
    Left = 512
    Top = 124
    Width = 85
    Height = 25
    Hint = 'Show or hide additional information|'
    Anchors = [akTop, akRight]
    Caption = '&Ver informe'
    TabOrder = 5
    OnClick = DetailsBtnClick
  end
  object DetailsMemo: TMemo
    Left = 4
    Top = 168
    Width = 594
    Height = 217
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentColor = True
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 6
    WantReturns = False
    WordWrap = False
  end
  object Memo2: TMemo
    Left = 88
    Top = 8
    Width = 401
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    BorderStyle = bsNone
    Ctl3D = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Se ha producido un error inesperado.'
      ''
      '')
    ParentColor = True
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    WantReturns = False
  end
  object Memo1: TMemo
    Left = 88
    Top = 39
    Width = 409
    Height = 100
    Anchors = [akLeft, akTop, akRight]
    BorderStyle = bsNone
    Ctl3D = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 8404992
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Se ha creado un informe que puede ser de gran ayuda para '
      'determinar c'#250'al es la causa del error y poder subsanarlo en '
      'versiones posteriores. '
      ''
      'Puede enviarse autom'#225'ticamente pulsando el bot'#243'n Enviar informe.'
      ''
      
        'Si desea ver la informaci'#243'n que se enviar'#225', pulse el bot'#243'n Ver i' +
        'nforme.'
      ''
      ''
      ''
      '')
    ParentColor = True
    ParentCtl3D = False
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
    WantReturns = False
  end
  object SendBtn: TButton
    Left = 512
    Top = 88
    Width = 85
    Height = 30
    Hint = 'Enviar el error al equipo de soporte'
    Anchors = [akTop, akRight]
    Caption = '&Enviar informe'
    TabOrder = 4
    OnClick = SendBtnClick
  end
  object bCerrarApp: TButton
    Left = 513
    Top = 36
    Width = 88
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Cerrar aplicaci'#243'n'
    TabOrder = 2
    OnClick = bCerrarAppClick
  end
end
