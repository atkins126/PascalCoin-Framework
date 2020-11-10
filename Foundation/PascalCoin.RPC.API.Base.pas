unit PascalCoin.RPC.API.Base;

interface

Uses
  System.JSON,
  System.Generics.Collections,
  PascalCoin.RPC.Interfaces;

Type

  TPascalCoinAPIBase = Class(TInterfacedObject, IPascalCoinBaseAPI)
  Private
  Protected
    FClient: IPascalCoinRPCClient;
    FLastError: String;
    // FTools: IPascalCoinTools;

    Function PublicKeyParam(Const AKey: String; Const AKeyStyle: TKeyStyle): TParamPair;

    Function GetNodeURI: String;
    Procedure SetNodeURI(Const Value: String);

    Function GetLastError: String;

    Function GetJSONResult: TJSONValue;
    Function GetJSONResultStr: String;

    Function ResultAsObj: TJSONObject;
    Function ResultAsArray: TJSONArray;

    Constructor Create(AClient: IPascalCoinRPCClient);

  End;

implementation

Uses PascalCoin.Utils;

{ TPascalCoinAPIBase }

constructor TPascalCoinAPIBase.Create(AClient: IPascalCoinRPCClient);
begin
  inherited Create;
  FClient := AClient;
end;

function TPascalCoinAPIBase.GetJSONResult: TJSONValue;
begin
    result := FClient.ResponseObject.GetValue('result');
end;

function TPascalCoinAPIBase.GetJSONResultStr: String;
begin
    result := FClient.ResponseStr;
end;

function TPascalCoinAPIBase.GetLastError: String;
begin
result := FLastError;
end;

function TPascalCoinAPIBase.GetNodeURI: String;
begin
  result := FClient.NodeURI;
end;

function TPascalCoinAPIBase.PublicKeyParam(const AKey: String; const AKeyStyle: TKeyStyle): TParamPair;
Const
  _KeyType: Array [Boolean] Of String = ('b58_pubkey', 'enc_pubkey');
Begin
  Case AKeyStyle Of
    ksUnkown:
      result := TParamPair.Create(_KeyType[TPascalCoinUtils.IsHexaString(AKey)], AKey);
    ksEncKey:
      result := TParamPair.Create('enc_pubkey', AKey);
    ksB58Key:
      result := TParamPair.Create('b58_pubkey', AKey);
  End;
end;

function TPascalCoinAPIBase.ResultAsArray: TJSONArray;
begin
  Result := GetJSONResult as TJSONArray;
end;

function TPascalCoinAPIBase.ResultAsObj: TJSONObject;
begin
  Result := GetJSONResult as TJSONObject;
end;

procedure TPascalCoinAPIBase.SetNodeURI(const Value: String);
begin
  FClient.NodeURI := Value;
end;

end.
