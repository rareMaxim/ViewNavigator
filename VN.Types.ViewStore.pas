unit VN.Types.ViewStore;

interface

uses
  VN.Types,
  VN.Types.ViewNavigatorInfo,
  System.Generics.Collections, System.SysUtils;

type
  TViewsType = TObjectList<TvnViewInfo>;

  TViewsStore = class
  private
    FViews: TViewsType;
    fIsMainFormCreated: Boolean;
    FOnChangeState: TProc<string, TvnViewInfoStates>;
    procedure SetIsMainFormCreated(const Value: Boolean);
  protected
    procedure FillFromRtti(ANavClass: TvnControlClass; var AViewInfo: TvnViewInfo);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddView(ANavClass: TvnControlClass; const AName: string = '';
      ALifeCycle: TvnLifeCycle = TvnLifeCycle.OnCreateDestroy);
    function FindView(const AName: string; out Return: TvnViewInfo): Boolean;
  public
    property Views: TViewsType read FViews;
    property IsMainFormCreated: Boolean read fIsMainFormCreated write SetIsMainFormCreated;
    property OnChangeState: TProc<string, TvnViewInfoStates> read FOnChangeState write FOnChangeState;
  end;

implementation

uses
  VN.Attributes,
  System.Rtti;

{ TViewsStore }

procedure TViewsStore.AddView(ANavClass: TvnControlClass; const AName: string = '';
  ALifeCycle: TvnLifeCycle = TvnLifeCycle.OnCreateDestroy);
var
  AInfo: TvnViewInfo;
begin
  AInfo := TvnViewInfo.Create(ANavClass);
  FillFromRtti(ANavClass, AInfo);
  if not AName.IsEmpty then
    AInfo.Name := AName;
  if ALifeCycle <> TvnLifeCycle.OnCreateDestroy then
    AInfo.LifeCycle := ALifeCycle;
  if fIsMainFormCreated then
    AInfo.NotifyMainFormIsCreated;
  AInfo.OnChangeState := procedure(AState: TvnViewInfoStates)
    begin
      if Assigned(OnChangeState) then
        OnChangeState(AInfo.Name, AState);
    end;
  FViews.Add(AInfo);
end;

constructor TViewsStore.Create;
begin
  FViews := TObjectList<TvnViewInfo>.Create;
  fIsMainFormCreated := False;
end;

destructor TViewsStore.Destroy;
begin
  FViews.Clear;
  FreeAndNil(FViews);
end;

procedure TViewsStore.FillFromRtti(ANavClass: TvnControlClass; var AViewInfo: TvnViewInfo);
var
  lRttiCtx: TRttiContext;
  lRttiType: TRttiType;
  lRttiAttr: TCustomAttribute;
begin
  if not Assigned(AViewInfo) then
    AViewInfo := TvnViewInfo.Create(ANavClass);
  lRttiCtx := TRttiContext.Create;
  try
    lRttiType := lRttiCtx.GetType(ANavClass);
    for lRttiAttr in lRttiType.GetAttributes do
    begin
      if lRttiAttr is vnNameAttribute then
        AViewInfo.Name := (lRttiAttr as vnNameAttribute).Name
      else if lRttiAttr is vnLifeCycleAttribute then
        AViewInfo.LifeCycle := (lRttiAttr as vnLifeCycleAttribute).LifeCycle;
    end;
  finally
    lRttiCtx.Free;
  end;
end;

function TViewsStore.FindView(const AName: string; out Return: TvnViewInfo): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FViews.count - 1 do
    if FViews[I].Name = AName then
    begin
      Return := FViews[I];
      Result := true;
      break;
    end;
end;

procedure TViewsStore.SetIsMainFormCreated(const Value: Boolean);
var
  LView: TvnViewInfo;
begin
  fIsMainFormCreated := Value;
  if Value then
    for LView in Views do
    begin
      LView.NotifyMainFormIsCreated;
    end;
end;

end.
