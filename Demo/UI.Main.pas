unit UI.Main;

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
  FMX.Controls.Presentation,
  FMX.MultiView,

  FMX.Layouts,
  FMX.ListBox, System.Rtti, FMX.Grid.Style, FMX.Grid, FMX.ScrollBox,
  FMX.Memo.Types, FMX.Memo, FMX.StdCtrls;

type
  TForm6 = class(TForm)
    ListBox1: TListBox;
    Layout1: TLayout;
    CreateOnCreate: TListBoxItem;
    CreateOmShow: TListBoxItem;
    Grid1: TGrid;
    clmnName: TColumn;
    clmnIsCreated: TCheckColumn;
    clmnIsVisible: TCheckColumn;
    SendData: TListBoxItem;
    Layout2: TLayout;
    ListBox2: TListBox;
    ToolBar1: TToolBar;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CreateOnCreateClick(Sender: TObject);
    procedure CreateOmShowClick(Sender: TObject);
    procedure Grid1GetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
    procedure SendDataClick(Sender: TObject);
  private
    { Private declarations }
    FViews: TViewNavigator;
  public
    { Public declarations }
    procedure UpdateGrid;
  end;

var
  Form6: TForm6;

implementation

uses
  UI.Page.CreateOnShow,
  UI.Page.CreateOnCreate,
  UI.Page.SendData;
{$R *.fmx}

procedure TForm6.Button1Click(Sender: TObject);
begin
  FViews.GoBack;
end;

procedure TForm6.Button2Click(Sender: TObject);
begin
  FViews.GoForward;
end;

procedure TForm6.FormDestroy(Sender: TObject);
begin
  FViews.OnChangeState := nil;
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
  FViews := TViewNavigator.Create(Layout1);
  FViews.OnChangeState := procedure(APage: string; AStates: TvnViewInfoStates)
    begin
      UpdateGrid;
    end;
  FViews.History.OnNavigate := procedure(AItem: string)
    begin
      ListBox2.BeginUpdate;
      try
        ListBox2.Clear;
        ListBox2.Items.AddStrings(FViews.History.History.ToArray);
        ListBox2.ItemIndex := FViews.History.Cursor;
      finally
        ListBox2.EndUpdate;
      end;
      Button1.Enabled := FViews.History.CanBack;
      Button2.Enabled := FViews.History.CanForward;
    end;
  FViews.Parent := Layout1;
  FViews.RegisterFrame([TCreateOnShow, TCreateOnCreate, TSendData]);
  UpdateGrid;
end;

procedure TForm6.CreateOnCreateClick(Sender: TObject);
begin
  FViews.Navigate(TCreateOnCreate);
end;

procedure TForm6.CreateOmShowClick(Sender: TObject);
begin
  FViews.Navigate(TCreateOnShow);
end;

procedure TForm6.Grid1GetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
begin
  if Grid1.ColumnByIndex(ACol) = clmnName then
    Value := FViews.Pages[ARow].Name;
  if Grid1.ColumnByIndex(ACol) = clmnIsCreated then
    Value := TvnViewInfoState.IsCreated in FViews.Pages[ARow].States;
  if Grid1.ColumnByIndex(ACol) = clmnIsVisible then
    Value := TvnViewInfoState.IsVisible in FViews.Pages[ARow].States;
end;

procedure TForm6.SendDataClick(Sender: TObject);
begin
  FViews.Navigate(TSendData, 'Glory to Ukraine!!!');
end;

procedure TForm6.UpdateGrid;
begin
  Grid1.BeginUpdate;
  Grid1.RowCount := FViews.Pages.Count;
  Grid1.EndUpdate;
end;

end.
