unit DevApp.Form.PendingInfo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, DevApp.Base.DetailForm,
  FMX.Controls.Presentation, FMX.Layouts;

type
  TPendingInfo = class(TDevBaseForm)
  private
    { Private declarations }
    Procedure UpdateCount;
    Procedure ListOps;
  public
    { Public declarations }
    Procedure InitialiseThis; override;
  end;

var
  PendingInfo: TPendingInfo;

implementation

{$R *.fmx}

{ TPendingInfo }

procedure TPendingInfo.InitialiseThis;
begin
  inherited;

end;

procedure TPendingInfo.ListOps;
begin

end;

procedure TPendingInfo.UpdateCount;
begin

end;

end.
