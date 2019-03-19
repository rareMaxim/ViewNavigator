unit Main;

interface

{$SCOPEDENUMS ON}

uses
  ViewNavigator,
  System.Types,
  System.Classes,
  FGX.Forms,
  FGX.Forms.Types,
  FGX.Control,
  FGX.Control.Types,
  FGX.Layout,
  FGX.Layout.Types,
  FGX.ListMenu.Types,
  FGX.ListMenu;

type
  TForm5 = class(TfgForm)
    fgLayout1: TfgLayout;
    fgListMenu1: TfgListMenu;
    procedure fgFormDestroy(Sender: TObject);
    procedure fgFormCreate(Sender: TObject);
    procedure fgListMenu1TapItem(Sender: TObject; const AItem: TfgListMenuItem);
  private
    { Private declarations }
    FViewMng: TViewNavigator;
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.xfm}

uses
  System.SysUtils,
  FGX.Application,
  FGX.Dialogs,
  FGX.Log;

procedure TForm5.fgFormDestroy(Sender: TObject);
begin
  FViewMng.Free;
end;

procedure TForm5.fgFormCreate(Sender: TObject);
begin
  FViewMng := TViewNavigator.Create;
  FViewMng.Parent := fgLayout1;
end;

procedure TForm5.fgListMenu1TapItem(Sender: TObject; const AItem: TfgListMenuItem);
begin
  FViewMng.Navigate(AItem.Name);
end;

end.

