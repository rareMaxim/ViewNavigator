unit ViewNavigator;

// Я был бухой когда писал этот код... и вообще это не мое - мне подкинули.

interface

{$SCOPEDENUMS ON}

uses
  VN.History,
  VN.Types,
  VN.Types.ViewStore,
  VN.Types.ViewNavigatorInfo,
  System.Generics.Collections,
  System.Rtti,
  System.SysUtils;

type
  TvnLifeCycle = VN.Types.TvnLifeCycle;

  IvnDataView = VN.Types.IvnDataView;
  IvnSetViewNavigator = VN.Types.IvnSetViewNavigator;
  IvnNavigator = VN.Types.IvnNavigator;
  TViewsStore = VN.Types.ViewStore.TViewsStore;
  TvnControlClass = VN.Types.TvnControlClass;
  TvnViewInfoState = VN.Types.TvnViewInfoState;
  TvnViewInfoStates = VN.Types.TvnViewInfoStates;

  TViewNavigator = class(TvnHistory, IvnNavigator)
  private
    FParent: TvnControl;
    FViewStore: TViewsStore;
    function GetParent: TvnControl;
    procedure SetParent(const Value: TvnControl);
  protected
    procedure Show(const AName: string);
    procedure Hide;
  public
    procedure Navigate(const APageName: string); overload; override;
    procedure Navigate(const APageName: string; const AData: TValue); reintroduce; overload;
    function Back: string; override;
    function Next: string; override;
    constructor Create; override;
    destructor Destroy; override;
    property Store: TViewsStore read FViewStore;
    property Parent: TvnControl read GetParent write SetParent;
  end;

implementation

{ TViewNavigator }

function TViewNavigator.Back: string;
begin
  Result := inherited Back;
  Show(Result);
end;

constructor TViewNavigator.Create;
begin
  inherited;
  FViewStore := TViewsStore.Create;
end;

destructor TViewNavigator.Destroy;
begin
  FViewStore.Free;
  inherited;
end;

function TViewNavigator.Next: string;
begin
  Result := inherited Next;
  Show(Result);
end;

function TViewNavigator.GetParent: TvnControl;
begin
  Result := FParent;
end;

procedure TViewNavigator.Hide;
var
  AView: TvnViewInfo;
begin
  if (not Current.IsEmpty) and FViewStore.FindView(Current, AView) then
    AView.HideView();
end;

procedure TViewNavigator.Navigate(const APageName: string; const AData: TValue);
var
  LView: TvnViewInfo;
  LDataView: IvnDataView;
begin
  Navigate(APageName);
  if FViewStore.FindView(APageName, LView) then
  begin
    if Supports(LView.Control, IvnDataView, LDataView) then
      LDataView.DataReceive(AData);
  end;
end;

procedure TViewNavigator.Navigate(const APageName: string);
var
  LView: TvnViewInfo;
  lSetViewNav: IvnSetViewNavigator;
begin
  if APageName = Current then
    Exit;
  Hide();
  inherited Navigate(APageName);
  Show(APageName);
  if FViewStore.FindView(APageName, LView) then
  begin
    if Supports(LView.Control, IvnSetViewNavigator, lSetViewNav) then
      lSetViewNav.SetViewNavigator(Self);
  end;
end;

procedure TViewNavigator.SetParent(const Value: TvnControl);
begin
  FParent := Value;
  if Assigned(Value) and (not FViewStore.IsMainFormCreated) then
  begin
    FViewStore.IsMainFormCreated := True;
  end;
end;

procedure TViewNavigator.Show(const AName: string);
var
  AView: TvnViewInfo;
begin
  if FViewStore.FindView(AName, AView) then
    AView.ShowView(Parent)
  else
    raise EViewNavigator.CreateFmt('Cant find view by name: %s', [AName]);
end;

end.
