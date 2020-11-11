unit DevApp.Base.DetailForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  PascalCoin.RPC.Interfaces, FMX.Controls.Presentation, FMX.StdCtrls, PascalCoin.RPC.Exceptions;

type
  TDevBaseForm = class(TForm)
    HeaderLayout: TLayout;
    FooterLayout: TLayout;
    ContentLayout: TLayout;
    FormCaption: TLabel;
  private
    FDefaultURI: String;
    procedure SetDefaultURI(const Value: String);
    { Private declarations }
  protected
    function NodeAPI: IPascalCoinNodeAPI;
    function ExplorerAPI: IPascalCoinExplorerAPI;
    function WalletExplorerAPI: IPascalCoinWalletAPI;

    function UseURI: String; virtual;
    procedure HandleAPIException(E: Exception);
  public
    { Public declarations }
    procedure InitialiseThis; virtual;
    function CanClose: Boolean; Virtual;
    procedure TearDown; virtual;
    property DefaultURI: String read FDefaultURI write SetDefaultURI;
  end;

var
  DevBaseForm: TDevBaseForm;

implementation

{$R *.fmx}

uses DevApp.Shared, FMX.DialogService;

{ TDevBaseForm }

function TDevBaseForm.CanClose: Boolean;
begin
  Result := True;
end;

function TDevBaseForm.ExplorerAPI: IPascalCoinExplorerAPI;
begin
  Result := Config.Container.Resolve<IPascalCoinExplorerAPI>;
  Result.NodeURI := UseURI;
end;

function TDevBaseForm.NodeAPI: IPascalCoinNodeAPI;
begin
  Result := Config.Container.Resolve<IPascalCoinNodeAPI>;
  Result.NodeURI := UseURI;
end;

procedure TDevBaseForm.HandleAPIException(E: Exception);
begin
   TDialogService.ShowMessage(E.Message);
end;

procedure TDevBaseForm.InitialiseThis;
begin
//for descendants; not abstract as this is easier
end;

procedure TDevBaseForm.SetDefaultURI(const Value: String);
begin
  FDefaultURI := Value;
end;

procedure TDevBaseForm.TearDown;
begin
//for descendants; not abstract as this is easier
end;

function TDevBaseForm.UseURI: String;
begin
  Result := FDefaultURI;
end;

function TDevBaseForm.WalletExplorerAPI: IPascalCoinWalletAPI;
begin
  Result := Config.Container.Resolve<IPascalCoinWalletAPI>;
  Result.NodeURI := UseURI;
end;

end.

