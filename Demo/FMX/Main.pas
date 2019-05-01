unit Main;

interface

uses
  ViewNavigator,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Layouts,
  FMX.ListBox;

type
  TForm4 = class(TForm)
    lst1: TListBox;
    lyt1: TLayout;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    procedure lst1ItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses
  Demo.Bootstrap;
{$R *.fmx}

procedure TForm4.FormCreate(Sender: TObject);
begin
  TBootstrap.Navigator.Parent := lyt1;
end;

procedure TForm4.lst1ItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  TBootstrap.Navigator.Navigate(Item.Text, Format('data: %s', [Item.Text]));
end;

end.

