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
  FMX.ListBox,
  FMX.Memo.Types,
  FMX.Controls.Presentation,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.StdCtrls,
  System.Rtti,
  FMX.Grid.Style,
  FMX.Grid;

type
  TForm4 = class(TForm)
    lst1: TListBox;
    lyt1: TLayout;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Grid1: TGrid;
    StringColumn1: TStringColumn;
    CheckColumn1: TCheckColumn;
    CheckColumn2: TCheckColumn;
    Layout1: TLayout;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Grid1GetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
    procedure lst1ItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
    fIsCreatedViewNavigator: Boolean;
    FNavigator: TViewNavigator;
    procedure RegisterViews(AViews: TArray<TvnControlClass>);
  public
    procedure UpdateGrid;
    procedure CreateViewNavigator;
    procedure DestroyViewNavigator;
  end;

var
  Form4: TForm4;

implementation

uses
  One, Two, Three, System.Generics.Collections;
{$R *.fmx}

procedure TForm4.FormDestroy(Sender: TObject);
begin
  DestroyViewNavigator;
end;

procedure TForm4.CreateViewNavigator;
begin
  FNavigator := TViewNavigator.Create;

  FNavigator.Store.OnChangeState := procedure(AName: string; AState: TvnViewInfoStates)
    begin
      UpdateGrid;
    end;

  RegisterViews([Tview1, Tview2, Tview3]);
  FNavigator.Parent := lyt1;
  SpeedButton1.IsPressed := True;
  fIsCreatedViewNavigator := True;
end;

procedure TForm4.DestroyViewNavigator;
begin
  FNavigator.Free;
  SpeedButton2.IsPressed := True;
  fIsCreatedViewNavigator := False;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  CreateViewNavigator;
end;

procedure TForm4.Grid1GetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
begin
  case ACol of
    0:
      Value := FNavigator.Store.Views[ARow].Name;
    1:
      Value := TvnViewInfoState.IsCreated in FNavigator.Store.Views[ARow].States;
    2:
      Value := TvnViewInfoState.IsVisible in FNavigator.Store.Views[ARow].States;
  end;
end;

procedure TForm4.lst1ItemClick(const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  FNavigator.Navigate(Item.Text, Format('data: %s', [Item.Text]));
end;

procedure TForm4.RegisterViews(AViews: TArray<TvnControlClass>);
var
  i: Integer;
begin
  for i := Low(AViews) to High(AViews) do
    FNavigator.Store.AddView(AViews[i]);
  UpdateGrid;
end;

procedure TForm4.SpeedButton1Click(Sender: TObject);
begin
  if fIsCreatedViewNavigator then
    Exit;
  CreateViewNavigator;
end;

procedure TForm4.SpeedButton2Click(Sender: TObject);
begin
  if not fIsCreatedViewNavigator then
    Exit;
  DestroyViewNavigator;
end;

procedure TForm4.UpdateGrid;
begin
  Grid1.RowCount := 0;
  Grid1.RowCount := FNavigator.Store.Views.Count;
end;

end.
