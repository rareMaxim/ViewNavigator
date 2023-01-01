unit UI.Page.SendData;

interface

uses
  ViewNavigator,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, System.Rtti, FMX.Controls.Presentation;

type

  [ViewInfoAttribute(TpmLifeStyle.ShowHide)]
  TSendData = class(TFrame, IvnView)
    Rectangle1: TRectangle;
    Label1: TLabel;
  private
    { Private declarations }
  public
    procedure DataReceive(AData: TValue);
    { Public declarations }

  end;

implementation

{$R *.fmx}
{ TSendData }

procedure TSendData.DataReceive(AData: TValue);
begin
  Label1.Text := AData.AsString;
end;

end.
