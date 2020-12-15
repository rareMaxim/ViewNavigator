unit VN.Types.ViewNavigatorInfo;

interface

uses
  VN.Types,
  System.SysUtils;

type
  TvnViewInfo = class(TInterfacedObject)
  private
    fName: string;
    fLifeCycle: TvnLifeCycle;
    fNavigationClass: TvnControlClass;
    fControl: TvnControl;
    fIsCreated: Boolean;
    FStates: TvnViewInfoStates;
    FOnChangeState: TProc<TvnViewInfoStates>;
    procedure SetParent(const Value: TvnControl);
    procedure DoChangeStates(AStates: TvnViewInfoStates);
    procedure NotifySelfCreate; // must be private
    procedure NotifySelfShow;
    procedure NotifySelfHide;
    procedure NotifySelfDestroy;
    function CanBeFree(ADestroyTime: TvnLifeCycle): Boolean;
    function CanBeCreate(ACreationTime: TvnLifeCycle): Boolean;
    function IsCreated: Boolean;
    function IsHaveParent: Boolean;
    procedure ViewCreate;
    procedure ViewDestroy;
    procedure SetStates(const Value: TvnViewInfoStates);
  public
    procedure NotifyMainFormIsCreated;
    procedure ShowView(AParent: TvnControl);
    procedure HideView();
    constructor Create(ANavClass: TvnControlClass);
    destructor Destroy; override;
    property States: TvnViewInfoStates read FStates write SetStates;
    property Name: string read fName write fName;
    property NavigationClass: TvnControlClass read fNavigationClass write fNavigationClass;
    property LifeCycle: TvnLifeCycle read fLifeCycle write fLifeCycle;
    property Control: TvnControl read fControl write fControl;
    property OnChangeState: TProc<TvnViewInfoStates> read FOnChangeState write FOnChangeState;
  end;

implementation

{ TvnViewInfo }

function TvnViewInfo.CanBeCreate(ACreationTime: TvnLifeCycle): Boolean;
begin
  Result := (fLifeCycle = ACreationTime) and (not IsCreated);
end;

function TvnViewInfo.CanBeFree(ADestroyTime: TvnLifeCycle): Boolean;
begin
  Result := IsCreated and (fLifeCycle = ADestroyTime) and (not IsHaveParent);
end;

constructor TvnViewInfo.Create(ANavClass: TvnControlClass);
begin
  fName := ANavClass.ClassName;
  fNavigationClass := ANavClass;
  fLifeCycle := TvnLifeCycle.OnCreateDestroy;
end;

destructor TvnViewInfo.Destroy;
begin
  NotifySelfDestroy;
  inherited;
end;

procedure TvnViewInfo.DoChangeStates(AStates: TvnViewInfoStates);
begin
  FStates := AStates;
  if Assigned(OnChangeState) then
    OnChangeState(AStates);
end;

procedure TvnViewInfo.HideView;
begin
  fControl.Parent := nil;
  DoChangeStates(FStates - [TvnViewInfoState.IsVisible]);
  NotifySelfHide;
end;

procedure TvnViewInfo.ViewCreate;
begin
  fControl := TvnControl(fNavigationClass.Create(nil));
  fIsCreated := True;
  DoChangeStates(FStates + [TvnViewInfoState.IsCreated]);
end;

procedure TvnViewInfo.ViewDestroy;
begin
  fControl.Parent := nil;
  fControl.Free; // or Dispose?
  fIsCreated := False;
  DoChangeStates(FStates - [TvnViewInfoState.IsCreated]);
end;

function TvnViewInfo.IsCreated: Boolean;
begin
  Result := fIsCreated and Assigned(fControl);
end;

function TvnViewInfo.IsHaveParent: Boolean;
begin
  Result := IsCreated and Assigned(fControl.Parent);
end;

procedure TvnViewInfo.NotifyMainFormIsCreated;
begin
  NotifySelfCreate;
end;

procedure TvnViewInfo.NotifySelfCreate;
begin
  if CanBeCreate(TvnLifeCycle.OnCreateDestroy) then
    ViewCreate;
end;

procedure TvnViewInfo.NotifySelfDestroy;
begin
  if CanBeFree(TvnLifeCycle.OnCreateDestroy) then
    ViewDestroy;
end;

procedure TvnViewInfo.NotifySelfHide;
begin
  if CanBeFree(TvnLifeCycle.OnShowHide) then
    ViewDestroy;
end;

procedure TvnViewInfo.NotifySelfShow;
begin
  if CanBeCreate(TvnLifeCycle.OnShowHide) then
    ViewCreate;
end;

procedure TvnViewInfo.SetParent(const Value: TvnControl);
begin
  if IsCreated then
    fControl.Parent := Value;
end;

procedure TvnViewInfo.SetStates(const Value: TvnViewInfoStates);
begin
  FStates := Value;
  if Assigned(OnChangeState) then
    OnChangeState(Value);
end;

procedure TvnViewInfo.ShowView(AParent: TvnControl);
begin
  NotifySelfShow;
  SetParent(AParent);
  fControl.Visible := True;
  DoChangeStates(FStates + [TvnViewInfoState.IsVisible]);
end;

end.
