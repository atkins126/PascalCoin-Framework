Unit PascalCoin.RPC.API;

Interface

Uses
  System.JSON,
  System.Generics.Collections,
  PascalCoin.RPC.Interfaces;

Type

  TPascalCoinAPI = Class(TInterfacedObject, IPascalCoinAPI)
  Private
    FClient: IPascalCoinRPCClient;
    FLastError: String;
    // FTools: IPascalCoinTools;
    Function PublicKeyParam(Const AKey: String; Const AKeyStyle: TKeyStyle): TParamPair;
  Protected
    Function GetNodeURI: String;
    Procedure SetNodeURI(Const Value: String);

    Function URI(Const Value: String): IPascalCoinAPI;
    Function GetLastError: String;

    Function GetJSONResult: TJSONValue;
    Function GetJSONResultStr: String;

    //API
    Function NodeStatus: IPascalCoinNodeStatus;

    Function GetAccount(Const AAccountNumber: Cardinal): IPascalCoinAccount;

    Function getwalletaccounts(Const APublicKey: String; Const AKeyStyle: TKeyStyle; Const AStartIndex: Integer = 0;
      Const AMaxCount: Integer = 100): IPascalCoinAccounts;

    Function getwalletaccountscount(Const APublicKey: String; Const AKeyStyle: TKeyStyle): Integer;

    Function getaccountoperations(Const AAccount: Cardinal; Const ADepth: Integer = 100; Const AStart: Integer = 0;
      Const AMax: Integer = 100): IPascalCoinOperations;

    Function getblock(Const BlockNumber: Integer): IPascalCoinBlock;
    Function GetBlockCount: Integer;

    Function payloadEncryptWithPublicKey(Const APayload: String; Const AKey: String;
      Const AKeyStyle: TKeyStyle): String;



    Function executeoperation(Const RawOperation: String): IPascalCoinOperation;


    //Support Methods
    Procedure AddWalletAccounts(Const APublicKey: String; Const AKeyStyle: TKeyStyle; AAccountList: IPascalCoinAccounts;
      Const AStartIndex: integer; Const AMaxCount: integer = 100);


    Property JSONResult: TJSONValue Read GetJSONResult;
  Public
    Constructor Create(AClient: IPascalCoinRPCClient); // ; ATools: IPascalCoinTools);
  End;

Implementation

Uses
  System.SysUtils,
  System.DateUtils,
  REST.JSON,
  PascalCoin.RPC.Account,
  PascalCoin.RPC.Node,
  PascalCoin.RPC.Operation,
  PascalCoin.Utils, PascalCoin.RPC.Consts;

{ TPascalCoinAPI }

Function TPascalCoinAPI.executeoperation(Const RawOperation: String): IPascalCoinOperation;
Begin
  If FClient.RPCCall('executeoperations', [TParamPair.Create('rawoperations', RawOperation)]) Then
  Begin
    result := TJSON.JsonToObject<TPascalCoinOperation>((GetJSONResult As TJSONObject));
  End
  Else
  Begin
    Raise ERPCException.Create(FClient.ResultStr);
  End;
End;

Function TPascalCoinAPI.GetAccount(Const AAccountNumber: Cardinal): IPascalCoinAccount;
Begin
  If FClient.RPCCall('getaccount', [TParamPair.Create('account', AAccountNumber)]) Then
  Begin
    result := TJSON.JsonToObject<TPascalCoinAccount>((GetJSONResult As TJSONObject));
  End
  Else
  Begin
    Raise ERPCException.Create(FClient.ResultStr);
  End;
End;

function TPascalCoinAPI.getaccountoperations(Const AAccount: Cardinal; Const
    ADepth: Integer = 100; Const AStart: Integer = 0; Const AMax: Integer =
    100): IPascalCoinOperations;
Var
  lDepth: TParamPair;
Begin
  if ADepth = DEEP_SEARCH then
     lDepth := TParamPair.Create('depth', 'deep')
  else
     lDepth := TParamPair.Create('depth', ADepth);
  If FClient.RPCCall('getaccountoperations', [TParamPair.Create('account', AAccount),
    lDepth, TParamPair.Create('start', AStart), TParamPair.Create('max', AMax)]) Then
  Begin
    result := TPascalCoinOperations.FromJSONValue(GetJSONResult);
  End
  Else
  Begin
    Raise ERPCException.Create(FClient.ResultStr);
  End;
End;

Function TPascalCoinAPI.getblock(Const BlockNumber: Integer): IPascalCoinBlock;
Begin
  // if True then

End;

function TPascalCoinAPI.GetBlockCount: Integer;
begin
  if FClient.RPCCall('getblockcount', []) then
     Result := GetJSONResult.AsType<Integer>
  else
  begin
    Raise ERPCException.Create(FClient.ResultStr);
  end;
end;

Function TPascalCoinAPI.GetJSONResult: TJSONValue;
Begin
  result := (TJSONObject.ParseJSONValue(FClient.ResultStr) As TJSONObject).GetValue('result');
End;

Function TPascalCoinAPI.GetJSONResultStr: String;
Begin
  result := FClient.ResultStr;
End;

Function TPascalCoinAPI.GetLastError: String;
Begin
  result := FLastError;
End;

Function TPascalCoinAPI.GetNodeURI: String;
Begin
  result := FClient.NodeURI;
End;

Function TPascalCoinAPI.getwalletaccounts(Const APublicKey: String; Const AKeyStyle: TKeyStyle;
  Const AStartIndex, AMaxCount: Integer): IPascalCoinAccounts;
Var
  lAccounts: TJSONArray;
  lAccount: TJSONValue;
Begin
  If FClient.RPCCall('getwalletaccounts', [PublicKeyParam(APublicKey, AKeyStyle), TParamPair.Create('start',
    AStartIndex), TParamPair.Create('max', AMaxCount)]) Then
  Begin
    result := TPascalCoinAccounts.Create;
    lAccounts := (GetJSONResult As TJSONArray);
    For lAccount In lAccounts Do
      result.AddAccount(TJSON.JsonToObject<TPascalCoinAccount>((lAccount As TJSONObject)));
  End
  Else
    Raise ERPCException.Create(FClient.ResultStr);
End;

Function TPascalCoinAPI.getwalletaccountscount(Const APublicKey: String; Const AKeyStyle: TKeyStyle): Integer;
Begin
  If FClient.RPCCall('getwalletaccountscount', PublicKeyParam(APublicKey, AKeyStyle)) Then
    result := GetJSONResult.AsType<Integer>
  Else
    Raise ERPCException.Create(FClient.ResultStr);
End;

Function TPascalCoinAPI.NodeStatus: IPascalCoinNodeStatus;
Begin
  result := Nil;
  If FClient.RPCCall('nodestatus', []) Then
  Begin
    result := TPascalCoinNodeStatus.FromJsonValue(GetJSONResult);
  End
  Else
    Raise ERPCException.Create(FClient.ResultStr);

End;

Function TPascalCoinAPI.payloadEncryptWithPublicKey(Const APayload, AKey: String; Const AKeyStyle: TKeyStyle): String;
Begin
  If FClient.RPCCall('payloadencrypt', [TParamPair.Create('payload', APayload), TParamPair.Create('payload_method',
    'pubkey'), PublicKeyParam(AKey, AKeyStyle)]) Then
    result := GetJSONResult.AsType<String>
  Else
    Raise ERPCException.Create(FClient.ResultStr);
End;

Function TPascalCoinAPI.PublicKeyParam(Const AKey: String; Const AKeyStyle: TKeyStyle): TParamPair;
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
End;

Procedure TPascalCoinAPI.SetNodeURI(Const Value: String);
Begin
  FClient.NodeURI := Value;
End;

Function TPascalCoinAPI.URI(Const Value: String): IPascalCoinAPI;
Begin
  SetNodeURI(Value);
  result := Self;
End;

procedure TPascalCoinAPI.AddWalletAccounts(const APublicKey: String; const AKeyStyle: TKeyStyle;
  AAccountList: IPascalCoinAccounts; const AStartIndex, AMaxCount: integer);
Var
  lAccounts: TJSONArray;
  lAccount: TJSONValue;
Begin
  If FClient.RPCCall('getwalletaccounts', [PublicKeyParam(APublicKey, AKeyStyle), TParamPair.Create('start',
    AStartIndex), TParamPair.Create('max', AMaxCount)]) Then
  Begin
    lAccounts := (GetJSONResult As TJSONArray);
    For lAccount In lAccounts Do
      AAccountList.AddAccount(TJSON.JsonToObject<TPascalCoinAccount>((lAccount As TJSONObject)));
  End
  Else
    Raise ERPCException.Create(FClient.ResultStr);

end;

Constructor TPascalCoinAPI.Create(AClient: IPascalCoinRPCClient);
Begin
  Inherited Create;
  FClient := AClient;
  // FTools := ATools;
End;

End.
