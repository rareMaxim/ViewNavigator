unit One;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Objects;

type
  Tview1 = class(TFrame)
    txt1: TText;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  ViewNavigator;
{$R *.fmx}

initialization
  TViewNavigator.AddView()//
.SetNavClass(Tview1)//
.SetName('view1');

end.

