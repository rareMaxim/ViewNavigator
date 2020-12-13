unit Three;

interface

uses
  vn.Attributes,
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

  [vnName('view3')]
  [vnLifeCycle(TvnLifeCycle.OnShowHide)]
  Tview3 = class(TFrame)
    txt1: TText;
  private
    { Private declarations }
  public
    { Public declarations }
    destructor Destroy; override;
  end;

implementation

uses
  Demo.Bootstrap;

{$R *.fmx}
{ Tview3 }

destructor Tview3.Destroy;
begin

  inherited;
end;

initialization

// TBootstrap.NavStore.AddView(Tview3);

end.
