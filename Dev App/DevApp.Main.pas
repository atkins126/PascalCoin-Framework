Unit DevApp.Main;

Interface

Uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.ListBox,
  SubjectStand,
  FormStand,
  FMX.Controls.Presentation,
  FMX.MultiView,
  DevApp.Shared,
  PascalCoin.RPC.Interfaces;

Type
  TMainForm = Class(TForm)
    Layout1: TLayout;
    MultiView1: TMultiView;
    FormStand1: TFormStand;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    NodeLayoout: TLayout;
    NodeList: TComboBox;
    Panel1: TPanel;
    NodeStatusLabel: TLabel;
    FlowLayout1: TFlowLayout;
    NodeStatusBtn: TButton;
    AccountInfoBtn: TButton;
    Layout2: TLayout;
    NodeButton: TSpeedButton;
    AddNodeButton: TSpeedButton;
    OpenFolderBtn: TSpeedButton;
    Procedure AccountInfoBtnClick(Sender: TObject);
    Procedure AddNodeButtonClick(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure NodeButtonClick(Sender: TObject);
    Procedure NodeListChange(Sender: TObject);
    Procedure NodeStatusBtnClick(Sender: TObject);
    procedure OpenFolderBtnClick(Sender: TObject);
  Private
    { Private declarations }
    FAPI: IPascalCoinAPI;
    FDisplayedClass: TClass;
    Function GetAPI: IPascalCoinAPI;
    Function CloseDisplayedClass: Boolean;
    Procedure ShowNodeStatusForm;
    Procedure LoadConfig;
  Public
    { Public declarations }
    Property API: IPascalCoinAPI Read GetAPI;
  End;

Var
  MainForm: TMainForm;

Implementation

{$R *.fmx}

Uses
  System.JSON,
  DevApp.Form.NodeStatus,
  DevApp.Base.DetailForm,
  DevApp.Form.AccountInfo,
  FMX.DialogService, FMX.PlatformUtils;

Procedure TMainForm.AccountInfoBtnClick(Sender: TObject);
Var
  LFormInfo: TFormInfo<TAccountInfoForm>;
Begin
  If Not CloseDisplayedClass Then
    Exit;
  LFormInfo := FormStand1.GetFormInfo<TAccountInfoForm>(True, Layout1);
  If Not LFormInfo.IsVisible Then
    LFormInfo.Show;
  LFormInfo.Form.DefaultURI := NodeList.Items[NodeList.ItemIndex];
  FDisplayedClass := TAccountInfoForm;
  LFormInfo.Form.InitialiseThis;
End;

Procedure TMainForm.AddNodeButtonClick(Sender: TObject);
Var
  S: String;
Begin
  TDialogService.InputQuery('Add RPC Node', ['New Node'], [S],
    Procedure(Const AResult: TModalResult; Const AValues: Array Of String)
      Var
    I: Integer;
    Value: String;
  Begin
    Value := AValues[0];
    if Value = '' then
       Exit;
    For I := 0 To NodeList.Items.Count - 1 Do
    Begin
      If SameText(Value, NodeList.Items[I]) Then
        Exit;
    End;
    NodeList.Items.Add(Value);
    Config.AddServer(Value);
    End);
End;

Function TMainForm.CloseDisplayedClass: Boolean;
Begin
  If Assigned(FDisplayedClass) Then
  Begin
    If (FormStand1.LastShownForm Is TDevBaseForm) And (Not TDevBaseForm(FormStand1.LastShownForm).CanClose) Then
      Exit(False);
    If (FormStand1.LastShownForm Is TDevBaseForm) Then
      TDevBaseForm(FormStand1.LastShownForm).Teardown;

    FormStand1.HideAndCloseAll([FDisplayedClass]);
    FDisplayedClass := Nil;
    Result := True;
  End
  Else
  Begin
    Result := True;
  End;
End;

Procedure TMainForm.FormCreate(Sender: TObject);
Begin
  LoadConfig;
End;

Function TMainForm.GetAPI: IPascalCoinAPI;
Begin
  Result := Config.Container.Resolve<IPascalCoinAPI>;
  Result.NodeURI := NodeList.Items[NodeList.ItemIndex];
End;

Procedure TMainForm.LoadConfig;
Var
  lServers: TJSONArray;
  S: String;
  I: Integer;
Begin
  For I := 0 To pred(Config.Servers.Count) Do
  begin
    S := Config.Servers[I].AsType<String>;
    NodeList.Items.Add(S);
  end;

  If NodeList.Items.Count = 0 Then
    NodeList.Items.Add('http://127.0.0.1:4003');
End;

Procedure TMainForm.NodeButtonClick(Sender: TObject);
Begin
  If NodeList.ItemIndex > -1 Then
    NodeListChange(Self);
End;

Procedure TMainForm.NodeListChange(Sender: TObject);
Var
  JO: TJSONObject;
Begin
  FAPI := Nil;
  Try
    NodeStatusLabel.Text := API.NodeStatus.status_s;
  Except
    On e: exception Do
    Begin
      NodeStatusLabel.Text := 'Oops, a problem';
      If e.Message.StartsWith('{') Then
      Begin
        JO := TJSONObject.ParseJSONValue(e.Message) As TJSONObject;
        showmessage(JO.GetValue<String>('StatusMessage'));
      End
      Else
        showmessage(e.Message);
    End;
  End;
End;

Procedure TMainForm.NodeStatusBtnClick(Sender: TObject);
Begin
  ShowNodeStatusForm;
End;

procedure TMainForm.OpenFolderBtnClick(Sender: TObject);
begin
  TFMXUtils.CopyToClipboard(Config.ConfigFolder);
  ShowMessage(Config.ConfigFolder + ':  saved to clipboard');
end;

Procedure TMainForm.ShowNodeStatusForm;
Var
  LFormInfo: TFormInfo<TNodeStatusForm>;
Begin
  If Not CloseDisplayedClass Then
    Exit;
  LFormInfo := FormStand1.GetFormInfo<TNodeStatusForm>(True, Layout1);
  If Not LFormInfo.IsVisible Then
    LFormInfo.Show;
  LFormInfo.Form.DefaultURI := NodeList.Items[NodeList.ItemIndex];
  FDisplayedClass := TNodeStatusForm;
  LFormInfo.Form.InitialiseThis;

End;

End.
