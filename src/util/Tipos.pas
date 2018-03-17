unit Tipos;

interface

uses Controls;

type
  TNotificacion = procedure of object;

  TArrayCurrency = array of currency;
  PArrayCurrency = ^TArrayCurrency;

  TArrayDate = array of TDate;
  PArrayDate = ^TArrayDate;

  TArrayInteger = array of integer;
  PArrayInteger = ^TArrayInteger;

  TArrayBoolean = array of boolean;
  PArrayBoolean = ^TArrayBoolean;

  TArrayString = array of string;
  PArrayString = ^TArrayString;

implementation

end.
