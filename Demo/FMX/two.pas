unit two;

interface

uses
  VN.Attributes,
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

  [vnName('view2')]
  [vnLifeCycle(TvnLifeCycle.OnCreateDestroy)]
  Tview2 = class(TFrame)
    txt1: TText;
  private
    { Private declarations }
  public
    { Public declarations }

  end;

implementation

{$R *.fmx}

end.
