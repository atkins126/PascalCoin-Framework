Unit UC.Net.Interfaces;

Interface

Uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections;

Type

  EucHTTPException = Class(Exception);

{$SCOPEDENUMS ON}
  THTTPStatusType = (OK, Fail, Exception);
{$SCOPEDENUMS OFF}

  IucHTTPRequest = Interface(IInvokable)
    ['{67CDB48B-C4F4-4C0F-BE61-BDA3497CF892}']
    Function GetResponseStr: String;
    Function GetStatusCode: integer;
    Function GetStatusText: String;
    Function GetStatusType: THTTPStatusType;

    Procedure Clear;
    Function Post(AURL: String; AData: String): boolean;

    Property ResponseStr: String Read GetResponseStr;
    Property StatusCode: integer Read GetStatusCode;
    Property StatusText: String Read GetStatusText;
    Property StstusType: THTTPStatusType Read GetStatusType;
  End;

Implementation

End.
