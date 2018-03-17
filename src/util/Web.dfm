inherited WebAsyncInternal: TWebAsyncInternal
  OldCreateOrder = True
  Height = 222
  Width = 255
  object auHTTP: TauHTTP
    Agent = 'acHTTP component (AppControls.com)'
    CacheOptions = [coAlwaysReload, coReloadIfNoExpireInformation, coReloadUpdatedObjects, coNoCacheWrite, coCreateTempFilesIfCantCache]
    Timeouts.ConnectTimeout = 10000
    Timeouts.ReceiveTimeout = 10000
    Timeouts.SendTimeout = 10000
    OnDone = auHTTPDone
    Left = 64
    Top = 40
  end
end
