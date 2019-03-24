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
  FGX.Button,
  FGX.PageControl;

type
  TView2 = class(TfgForm)
    fgPageControl1: TfgPageControl;
    fgPage1: TfgPage;
    fgPage2: TfgPage;
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
  TViewsStore.AddView('view2', TView2, TvnCreateDestroyTime.OnCreateDestroy);

end.

