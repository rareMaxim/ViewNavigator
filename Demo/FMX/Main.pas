unit Main;

interface

uses
  two,
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
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lst1ItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
  private
    { Private declarations }
    FViewMng: TViewNavigator;
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.fmx}

procedure TForm4.FormDestroy(Sender: TObject);
begin
  FViewMng.Free;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  FViewMng := TViewNavigator.Create;
  FViewMng.Parent := lyt1;
end;

procedure TForm4.lst1ItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  FViewMng.Navigate(Item.Text, Format('data: %s', [Item.Text]));
end;

end.

