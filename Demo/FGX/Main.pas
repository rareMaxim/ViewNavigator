unit Main;

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
  FGX.ListMenu.Types,
  FGX.ListMenu,
  FGX.NavigationBar.Types,
  FGX.NavigationBar,
  FGX.PageControl;

type
  TviewMain = class(TfgForm)
    fgnvgtnbr1: TfgNavigationBar;
    fgpgcntrl1: TfgPageControl;
    fgpg1: TfgPage;
    procedure fgFormCreate(Sender: TObject);
    procedure fgnvgtnbr1ActionButtonTap(const Sender: TObject; const AButton: TfgNavigationBarButton);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  viewMain: TviewMain;

implementation

{$R *.xfm}

uses
  Demo.Bootstrap,
  System.SysUtils,
  FGX.Application,
  FGX.Dialogs,
  FGX.Log;

procedure TviewMain.fgFormCreate(Sender: TObject);
begin
  TBootstrap.Navigator.Parent := fgpg1;
end;

procedure TviewMain.fgnvgtnbr1ActionButtonTap(const Sender: TObject; const AButton: TfgNavigationBarButton);
begin
  TBootstrap.Navigator.Navigate(AButton.Title, Format('data: %s', [AButton.Title]));
end;

end.

