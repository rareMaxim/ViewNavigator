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
  FGX.ListMenu,
  FGX.NavigationBar.Types,
  FGX.NavigationBar, FGX.PageControl;

type
  TForm5 = class(TfgForm)
    fgnvgtnbr1: TfgNavigationBar;
    fgpgcntrl1: TfgPageControl;
    fgpg1: TfgPage;
    procedure fgFormDestroy(Sender: TObject);
    procedure fgFormCreate(Sender: TObject);
    procedure fgnvgtnbr1ActionButtonTap(const Sender: TObject; const AButton:
      TfgNavigationBarButton);
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
  FViewMng.Parent := fgpg1;
end;

procedure TForm5.fgnvgtnbr1ActionButtonTap(const Sender: TObject; const AButton:
  TfgNavigationBarButton);
begin
  FViewMng.Navigate(AButton.Title);
end;

end.

