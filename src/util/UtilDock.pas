unit UtilDock;

interface

type
  TDockPositions = (dpArriba, dpAbajo, dpArribaBotones, dpAbajoBotones,
    dpArribaCentro, dpAbajoCentro, dpIzquierdaCentro, dpDerechaCentro,
    dpMenu, dpFlotando);

  TDefaultDock = record
    case Position: TDockPositions of
      dpFlotando: (
        Parent: TDockPositions;
        X,Y: integer; );
      dpArriba, dpAbajo, dpArribaBotones, dpAbajoBotones,
      dpArribaCentro, dpAbajoCentro, dpIzquierdaCentro,
      dpDerechaCentro, dpMenu: (
        Pos: integer;
        Row: integer; );
  end;


implementation

end.
