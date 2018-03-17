unit dmBuscarValor;

interface

uses
  SysUtils, Classes, DB, IBCustomDataSet, kbmMemTable, dmBaseBuscar;

type
  TBuscarValor = class(TBaseBuscar)
  private
    procedure OnGrupoCambiado;
  protected
    procedure LoadValores; override;  
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


implementation

uses dmData, BusCommunication, dmAccionesValor;

{$R *.dfm}

{ TBuscarValor }

constructor TBuscarValor.Create(AOwner: TComponent);
begin
  inherited;
  Bus.RegisterEvent(MessageMercadoGrupoCambiado, OnGrupoCambiado);
end;

destructor TBuscarValor.Destroy;
begin
  Bus.UnregisterEvent(MessageMercadoGrupoCambiado, OnGrupoCambiado);
  inherited;
end;

procedure TBuscarValor.LoadValores;
begin
  inherited;
  Valores.Locate('OID_VALOR', Data.OIDValor, []);
end;

procedure TBuscarValor.OnGrupoCambiado;
begin
  LoadValores;
end;

end.
