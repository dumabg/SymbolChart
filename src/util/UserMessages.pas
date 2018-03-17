unit UserMessages;

interface

uses Messages;

const
  WM_PERCENT = WM_USER + 1;
  WM_CANCEL_CURRENT_OPERATION = WM_USER + 3; // Utilitzat a fmBaseServer


  //BORRAR
  WM_SELECCIONAR_TAB_FAVORITOS = WM_USER + 6; // Utilitzat a fmMain


  WM_CHANGE_SIZE_TOOLWINDOW_MENSAJE = WM_USER + 7; // Utilitzat a fmMain
      // LParam = Height
      // WParam = Width


implementation

end.
