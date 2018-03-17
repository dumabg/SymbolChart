object Lector: TLector
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 296
  Width = 348
  object SpVoice: TSpVoice
    AutoConnect = False
    ConnectKind = ckRunningOrNew
    OnVoiceChange = SpVoiceVoiceChange
    Left = 136
    Top = 112
  end
end
