unit ViewNavigator;

// Я был бухой когда писал этот код... и вообще это не мое - мне подкинули.

interface

{$SCOPEDENUMS ON}

uses
  VN.History,
  VN.Types,
  System.Generics.Collections,
  System.Rtti,
  System.SysUtils;

type
  TvnCreateDestroyTime = VN.Types.TvnCreateDestroyTime;

  IvnDataView = VN.Types.IvnDataView;

  EViewNavigator = class(Exception);

  TViewsStore = class
  private
    class var
      FViews: TObjectDictionary<string, TvnViewInfo>;
  public
    class procedure ViewsInitialize;
    class constructor Create;
    class destructor Destroy;
    class procedure AddView(const AName: string; ANavClass: TvnControlClass;
      ACreateDestroyTime: TvnCreateDestroyTime = TvnCreateDestroyTime.OnShowHide);
    class function FindView(const AName: string; out Return: TvnViewInfo): Boolean;
  end;

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
    procedure Navigate(const APageName: string; const AData: TValue); overload;
    function Back: string; override;
    function forward: string; override;
    constructor Create; override;
  published
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
    AView.Hide();
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
    AView.Show(Parent)
  else
    raise EViewNavigator.CreateFmt('Cant find view by name: %s', [AName]);
end;

{ TViewsStore }

class procedure TViewsStore.AddView(const AName: string; ANavClass:
  TvnControlClass; ACreateDestroyTime: TvnCreateDestroyTime);
var
  AInfo: TvnViewInfo;
begin
  { TODO -oOwner -cGeneral : При совпадении имени вьюшки - нужно разрушить существующую
    и зарегистрировать новую }
  AInfo := TvnViewInfo.Create(AName.ToLower, ANavClass, ACreateDestroyTime);
  FViews.Add(AInfo.Name, AInfo);
end;

class constructor TViewsStore.Create;
begin
  FViews := TObjectDictionary<string, TvnViewInfo>.Create();
end;

class destructor TViewsStore.Destroy;
begin
  FreeAndNil(FViews);
end;

class function TViewsStore.FindView(const AName: string; out Return: TvnViewInfo):
  Boolean;
var
  LLoweredName: string;
begin
  LLoweredName := AName.ToLower;
  Result := FViews.ContainsKey(LLoweredName);
  if Result then
    Return := FViews[LLoweredName];
end;

class procedure TViewsStore.ViewsInitialize;
var
  LViewInfo: TvnViewInfo;
begin
  for LViewInfo in FViews.Values do
    LViewInfo.NotifySelfCreate();
end;

end.

