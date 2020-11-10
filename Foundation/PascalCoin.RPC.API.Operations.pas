unit PascalCoin.RPC.API.Operations;

interface

Uses
  System.JSON,
  System.Generics.Collections,
  PascalCoin.RPC.Interfaces,
  PascalCoin.RPC.API.Base;

Type

  TPascalCoinOperationsAPI = Class(TPascalCoinAPIBase, IPascalCoinOperationsAPI)
  Private
  Protected
       Function payloadEncryptWithPublicKey(Const APayload: String; Const AKey: String;
      Const AKeyStyle: TKeyStyle): String;

    Function executeoperation(Const RawOperation: String): IPascalCoinOperation;
  Public
  Constructor Create(AClient: IPascalCoinRPCClient);
  End;

implementation

uses Rest.JSON, PascalCoin.RPC.Operation;

{ TPascalCoinOperationsAPI }

constructor TPascalCoinOperationsAPI.Create(AClient: IPascalCoinRPCClient);
begin
  inherited Create(AClient);
end;

function TPascalCoinOperationsAPI.executeoperation(const RawOperation: String): IPascalCoinOperation;
begin
  If FClient.RPCCall('executeoperations', [TParamPair.Create('rawoperations', RawOperation)]) Then
  Begin
    result := TJSON.JsonToObject<TPascalCoinOperation>((GetJSONResult As TJSONObject));
  End;
end;

function TPascalCoinOperationsAPI.payloadEncryptWithPublicKey(const APayload, AKey: String;
  const AKeyStyle: TKeyStyle): String;
begin
  If FClient.RPCCall('payloadencrypt', [TParamPair.Create('payload', APayload), TParamPair.Create('payload_method',
    'pubkey'), PublicKeyParam(AKey, AKeyStyle)]) Then
    result := GetJSONResult.AsType<String>;
End;


end.
