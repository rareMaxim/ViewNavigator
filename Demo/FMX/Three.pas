unit Three;

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
  Tview3 = class(TFrame)
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
  TViewsStore.AddView('view3', Tview3);

end.

