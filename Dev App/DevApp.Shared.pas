unit DevApp.Shared;

interface

Uses DevApp.Config.Impl;


Function Config: TDevAppConfig;

implementation

var _Config: TDevAppConfig;

Function Config: TDevAppConfig;
begin
  if Not Assigned(_Config) then
     _Config := TDevAppConfig.Create();
  Result := _Config;
end;

initialization

finalization
if Assigned(_Config) then
   _Config.Free;

end.
