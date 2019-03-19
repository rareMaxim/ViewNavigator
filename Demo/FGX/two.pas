unit two;

interface

{$SCOPEDENUMS ON}

uses
  System.Types,
  System.Classes,
  FGX.Forms,
  FGX.Forms.Types,
  FGX.Control,
  FGX.Control.Types,
  FGX.Layout,
  FGX.Layout.Types,
  FGX.Button.Types,
  FGX.Button;

type
  TView2 = class(TfgForm)
    fgButton1: TfgButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  View2: TView2;

implementation

{$R *.xfm}

uses
  System.SysUtils,
  FGX.Application,
  FGX.Dialogs,
  FGX.Log,
  ViewNavigator;

initialization
  TViewNavigator.AddView('view2', Tview2, TvnCreateDestroyTime.OnShowHide);

end.

