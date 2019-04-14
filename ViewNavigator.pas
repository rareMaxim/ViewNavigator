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
  TvnCreateDestroyTime = VN.Types.TvnCreateDestroyTime;

  IvnDataView = VN.Types.IvnDataView;

  TViewNavigator = class(TvnHistory)
  private
    FParent: TvnControl;
    function GetParent: TvnControl;
    procedure SetParent(const Value: TvnControl);
  protected
    procedure Show(const AName: string);
    procedure Hide;
  public
    procedure Navigate(const APageName: string); overload; override;
    procedure Navigate(const APageName: string; const AData: TValue); reintroduce; overload;
    function Back: string; override;
    function forward: string; override;
    constructor Create; override;
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
  TViewsStore.ViewsInitialize;
end;

function TViewNavigator.forward: string;
begin
  Result := inherited forward;
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
  if TViewsStore.FindView(Current, AView) then
    AView.HideView();
end;

procedure TViewNavigator.Navigate(const APageName: string; const AData: TValue);
var
  LView: TvnViewInfo;
  LDataView: IvnDataView;
begin
  Navigate(APageName);
  if TViewsStore.FindView(APageName, LView) then
  begin
    if Supports(LView.Control, IvnDataView, LDataView) then
      LDataView.DataReceive(AData);
  end;
end;

procedure TViewNavigator.Navigate(const APageName: string);
begin
  if APageName = Current then
    Exit;
  Hide();
  inherited Navigate(APageName);
  Show(APageName);
end;

procedure TViewNavigator.SetParent(const Value: TvnControl);
begin
  FParent := Value;
end;

procedure TViewNavigator.Show(const AName: string);
var
  AView: TvnViewInfo;
begin
  if TViewsStore.FindView(AName, AView) then
    AView.ShowView(Parent)
  else
    raise EViewNavigator.CreateFmt('Cant find view by name: %s', [AName]);
end;

end.

