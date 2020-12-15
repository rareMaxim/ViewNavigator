unit One;

interface

uses
  VN.Attributes,
  ViewNavigator,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Rtti,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Objects;

type

  [vnName('SendDataToView')]
  [vnLifeCycle(TvnLifeCycle.OnCreateDestroy)]
  Tview1 = class(TFrame, IvnDataView)
    txt1: TText;
  private
    { Private declarations }
  public
    procedure DataReceive(AData: TValue);
    { Public declarations }
  end;

implementation

uses
  FMX.DialogService;

{$R *.fmx}
{ Tview1 }

procedure Tview1.DataReceive(AData: TValue);
begin
  TDialogService.ShowMessage(AData.AsString);
end;

end.
