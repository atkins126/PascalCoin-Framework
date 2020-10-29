unit DevApp.Base.DetailForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  PascalCoin.RPC.Interfaces, FMX.Controls.Presentation, FMX.StdCtrls;

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
    function GetAPI: IPascalCoinAPI;
    function UseURI: String; virtual;
    procedure HandleAPIException(eMessage: string);
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

uses DevApp.Shared, XSuperObject, FMX.DialogService;

{ TDevBaseForm }

function TDevBaseForm.CanClose: Boolean;
begin
  Result := True;
end;

function TDevBaseForm.GetAPI: IPascalCoinAPI;
begin
  Result := Config.Container.Resolve<IPascalCoinAPI>;
  Result.NodeURI := UseURI;
end;

procedure TDevBaseForm.HandleAPIException(eMessage: string);
var S: ISuperObject;
    M: String;
begin
   S := SO(eMessage);
   M := S.S['StatusMessage'].Replace(':', #10);

   TDialogService.ShowMessage(M);
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

end.

