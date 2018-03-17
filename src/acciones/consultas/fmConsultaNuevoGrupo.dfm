inherited fConsultaNuevoGrupo: TfConsultaNuevoGrupo
  Caption = 'Crear un nuevo grupo'
  OnCreate = FormCreate
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  inherited bCrear: TBitBtn
    ModalResult = 0
    OnClick = bCrearClick
  end
end
