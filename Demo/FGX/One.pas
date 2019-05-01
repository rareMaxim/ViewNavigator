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
  FGX.StaticLabel,
  FGX.CollectionView;

type
  TView1 = class(TfgForm, IvnDataView)
    fgLbl1: TfgLabel;
    fgclctnvw1: TfgCollectionView;
    function fgclctnvw1GetItemCount(Sender: TObject): Integer;
    procedure fgclctnvw1BindItem(Sender: TObject; const AIndex: Integer; const AStyle: string; const AItem: TfgItemWrapper);
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
  Demo.Bootstrap,
  System.SysUtils,
  FGX.Application,
  FGX.Dialogs,
  FGX.Log;

{ TView1 }

procedure TView1.DataReceive(AData: TValue);
begin
  TfgDialogs.ShowMessage(AData.AsString);
end;

procedure TView1.fgclctnvw1BindItem(Sender: TObject; const AIndex: Integer; const AStyle: string; const AItem: TfgItemWrapper);
begin
  AItem.GetControlByLookupName<TfgLabel>('123').Text := '123';
end;

function TView1.fgclctnvw1GetItemCount(Sender: TObject): Integer;
begin
  Result := 10;
end;

initialization
  TBootstrap.NavStore.AddView('view1', Tview1, TvnCreateDestroyTime.OnShowHide);

end.

