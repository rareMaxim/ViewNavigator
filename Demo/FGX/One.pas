unit One;

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
  FGX.Layout.Types, FGX.StaticLabel;

type
  TView1 = class(TfgForm)
    fgLbl1: TfgLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  View1: TView1;

implementation

{$R *.xfm}

uses
  System.SysUtils,
  FGX.Application,
  FGX.Dialogs,
  FGX.Log,
  ViewNavigator;

initialization
  TViewNavigator.AddView('view1', TView1, TvnCreateDestroyTime.OnShowHide);

end.

