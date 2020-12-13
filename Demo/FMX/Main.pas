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
    procedure FormDestroy(Sender: TObject);
    procedure lst1ItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FNavigator: TViewNavigator;
    procedure RegisterViews(AViews: TArray<TvnControlClass>);
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses
  One, Two, Three;
{$R *.fmx}

procedure TForm4.FormDestroy(Sender: TObject);
begin
  FNavigator.Free;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  FNavigator := TViewNavigator.Create;
  RegisterViews([Tview1, Tview2, Tview3]);
  FNavigator.Parent := lyt1;
end;

procedure TForm4.lst1ItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  FNavigator.Navigate(Item.Text, Format('data: %s', [Item.Text]));
end;

procedure TForm4.RegisterViews(AViews: TArray<TvnControlClass>);
var
  I: Integer;
begin
  for I := Low(AViews) to High(AViews) do
    FNavigator.Store.AddView(AViews[I]);
end;

end.
