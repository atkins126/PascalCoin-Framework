Unit DevApp.Initialise;

Interface

Uses
  Spring.Collections,
  DevApp.Config.Impl;

Procedure InitialiseApp(AConfig: TDevAppConfig);

Implementation

Uses
  UC.Net.Interfaces,
  UC.HTTPClient.Delphi,
  PascalCoin.RPC.Client,
  PascalCoin.RPC.Interfaces, PascalCoin.RPC.API.Node, PascalCoin.RPC.API.Explorer,
  pascalCoin.RPC.API.Wallet;

Procedure InitialiseApp(AConfig: TDevAppConfig);
Begin

  AConfig.Container.RegisterType<IucHTTPRequest, TDelphiHTTP>;
  AConfig.Container.RegisterType<IPascalCoinRPCClient, TPascalCoinRPCClient>;
  AConfig.Container.RegisterType<IPascalCoinExplorerAPI, TPascalCoinExplorerAPI>;
  AConfig.Container.RegisterType<IPascalCoinWalletAPI, TPascalCoinWalletAPI>;
  AConfig.Container.RegisterType<IPascalCoinNodeAPI, TPascalCoinNodeAPI>;
  AConfig.Container.Build;

End;

End.
