unit VN.Types.ViewStore;

interface

uses
  VN.Types,
  VN.Types.ViewNavigatorInfo,
  System.Generics.Collections;

type
  TViewsType = TObjectDictionary<string, TvnViewInfo>;

  TViewsStore = class
  private
    FViews: TViewsType;
    fIsMainFormCreated: Boolean;
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
  end;

implementation

uses
  VN.Attributes,
  System.Rtti,
  System.SysUtils;

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
  FViews.Add(AInfo.Name, AInfo);
  if fIsMainFormCreated then
    AInfo.NotifyMainFormIsCreated;
end;

constructor TViewsStore.Create;
begin
  FViews := TObjectDictionary<string, TvnViewInfo>.Create([doOwnsValues]);
  fIsMainFormCreated := False;
end;

destructor TViewsStore.Destroy;
begin
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
  LLoweredName: string;
begin
  LLoweredName := AName;
  Result := FViews.ContainsKey(LLoweredName);
  if Result then
    Return := FViews[LLoweredName];
end;

procedure TViewsStore.SetIsMainFormCreated(const Value: Boolean);
var
  LView: TvnViewInfo;
begin
  fIsMainFormCreated := Value;
  if Value then
    for LView in Views.Values do
    begin
      LView.NotifyMainFormIsCreated;
    end;
end;

end.
