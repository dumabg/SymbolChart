inherited BD: TBD
  OldCreateOrder = True
  Height = 235
  Width = 553
  object IBDatabaseComun: TIBDatabase
    DatabaseName = 'D:\Bolsa\SymbolChart\SymbolChart\SCC.DAT'
    Params.Strings = (
      'user_name=sysdba')
    DefaultTransaction = IBTransactionComun
    AllowStreamedConnected = False
    Left = 208
    Top = 56
  end
  object IBTransactionComun: TIBTransaction
    DefaultDatabase = IBDatabaseComun
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saCommitRetaining
    Left = 208
    Top = 136
  end
  object IBDatabaseUsuario: TIBDatabase
    DatabaseName = 'D:\Bolsa\SymbolChart\SymbolChart\SCU.DAT'
    Params.Strings = (
      'user_name=sysdba')
    DefaultTransaction = IBTransactionUsuario
    AllowStreamedConnected = False
    Left = 56
    Top = 56
  end
  object IBTransactionUsuario: TIBTransaction
    DefaultDatabase = IBDatabaseUsuario
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saCommitRetaining
    Left = 56
    Top = 136
  end
  object IBDatabaseDatos: TIBDatabase
    DatabaseName = 'D:\Bolsa\SymbolChart\SymbolChart\SCDD.DAT'
    Params.Strings = (
      'user_name=sysdba')
    DefaultTransaction = IBTransactionDatos
    AllowStreamedConnected = False
    Left = 392
    Top = 64
  end
  object IBTransactionDatos: TIBTransaction
    DefaultDatabase = IBDatabaseDatos
    Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    AutoStopAction = saCommitRetaining
    Left = 400
    Top = 144
  end
end
