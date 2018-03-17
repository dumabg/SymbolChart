inherited fMensajePageWizard: TfMensajePageWizard
  Caption = 'fMensajePageWizard'
  ClientHeight = 170
  ExplicitWidth = 320
  ExplicitHeight = 195
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel2: TPanel
    Top = 125
    ExplicitTop = 125
    inherited Hecho: TJvXPButton
      OnClick = HechoClick
    end
  end
  inherited FrameBrowser: TFrameBrowser
    Height = 125
    ExplicitHeight = 125
  end
end
