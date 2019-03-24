unit One;

interface

{$SCOPEDENUMS ON}

uses
  System.Types,
  System.Classes,
  System.Rtti,
  ViewNavigator,
  FGX.Forms,
  FGX.Forms.Types,
  FGX.Control,
  FGX.Control.Types,
  FGX.Layout,
  FGX.Layout.Types,
  FGX.StaticLabel;

type
  TView1 = class(TfgForm, IvnDataView)
    fgLbl1: TfgLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DataReceive(AData: TValue);
  end;

var
  View1: TView1;

implementation

{$R *.xfm}

uses
  System.SysUtils,
  FGX.Application,
  FGX.Dialogs,
  FGX.Log;

{ TView1 }

procedure TView1.DataReceive(AData: TValue);
begin
  ShowMessage(AData.AsString);
end;

initialization
  TViewsStore.AddView('view1', TView1, TvnCreateDestroyTime.OnShowHide);

end.

