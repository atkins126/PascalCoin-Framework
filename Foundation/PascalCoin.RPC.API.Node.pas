unit PascalCoin.RPC.API.Node;

interface

Uses
  System.JSON,
  System.Generics.Collections,
  PascalCoin.RPC.Interfaces,
  PascalCoin.RPC.API.Base;

Type

  TPascalCoinNodeAPI = Class(TPascalCoinAPIBase, IPascalCoinNodeAPI)
  protected
    Function NodeStatus: IPascalCoinNodeStatus;
  public
  Constructor Create(AClient: IPascalCoinRPCClient);
  End;

implementation

{ TPascalCoinNodeAPI }

uses PascalCoin.RPC.Node;

constructor TPascalCoinNodeAPI.Create(AClient: IPascalCoinRPCClient);
begin
  inherited Create(AClient);
end;

function TPascalCoinNodeAPI.NodeStatus: IPascalCoinNodeStatus;
begin
  result := Nil;
  If FClient.RPCCall('nodestatus', []) Then
  Begin
    result := TPascalCoinNodeStatus.FromJsonValue(GetJSONResult);
  End;
end;

end.
