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
  PascalCoin.RPC.Interfaces, PascalCoin.RPC.API;

Procedure InitialiseApp(AConfig: TDevAppConfig);
Begin

  AConfig.Container.RegisterType<IucHTTPRequest, TDelphiHTTP>;
  AConfig.Container.RegisterType<IPascalCoinRPCClient, TPascalCoinRPCClient>;
  AConfig.Container.RegisterType<IPascalCoinAPI, TPascalCoinAPI>;
  AConfig.Container.Build;

End;

End.
